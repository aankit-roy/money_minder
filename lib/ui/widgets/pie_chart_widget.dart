



import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:money_minder/models/category_list.dart';
import 'package:money_minder/models/time_period.dart';
import 'package:money_minder/provider/income_transaction_provider.dart';
import 'package:money_minder/provider/transaction_provider.dart';
import 'package:money_minder/res/colors/color_palette.dart';
import 'package:money_minder/res/components/formated_value.dart';
import 'package:money_minder/res/constants/currency_symbol.dart';
import 'package:money_minder/res/constants/text_size.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';

class PieChartWidget extends StatefulWidget {
  final Map<CategoryData, double> aggregatedData;
  final double totalAmount;
  final TimePeriod selectedPeriod;
  final void Function(TimePeriod) onPeriodChanged;

  const PieChartWidget({
    super.key,
    required this.aggregatedData,
    required this.totalAmount,
    required this.selectedPeriod,
    required this.onPeriodChanged,
  });

  @override
  State<PieChartWidget> createState() => _PieChartWidgetState();
}

class _PieChartWidgetState extends State<PieChartWidget> {
  int touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    final sections = _generateSections(widget.aggregatedData, widget.totalAmount);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: 5),
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildPeriodButton('Daily', TimePeriod.daily),
              _buildPeriodButton('Weekly', TimePeriod.weekly),
              _buildPeriodButton('Monthly', TimePeriod.monthly),
            ],
          ),
        ),
        SizedBox(height: size.height * .08),
        widget.totalAmount > 0.0
            ? Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              height: 90,
              width: 90,
              child: PieChart(
                PieChartData(
                  pieTouchData: PieTouchData(
                    touchCallback: (FlTouchEvent event, pieTouchResponse) {
                      setState(() {
                        if (!event.isInterestedForInteractions ||
                            pieTouchResponse == null ||
                            pieTouchResponse.touchedSection == null) {
                          touchedIndex = -1;
                          return;
                        }
                        touchedIndex = pieTouchResponse.touchedSection!.touchedSectionIndex;
                      });
                    },
                  ),
                  borderData: FlBorderData(
                    show: false,
                  ),
                  sectionsSpace: 2,
                  centerSpaceRadius: 60,
                  sections: sections,
                ),
              ),
            ),

             FormattedValueWidget(value: widget.totalAmount, color: ColorsPalette.textPrimary),
          ],
        )
            :   Text(
          'No data',
          style: TextStyle(
            fontSize: TextSizes.mediumHeadingMin(context),
            fontWeight: FontWeight.bold,
            color: ColorsPalette.textPrimary,
          ),
        ),
        SizedBox(height: size.height * .1),
        const BalanceWidget(),
      ],
    );
  }

  List<PieChartSectionData> _generateSections(Map<CategoryData, double> aggregatedData, double totalAmount) {
    List<PieChartSectionData> sections = [];
    int index = 0;

    aggregatedData.forEach((category, amount) {
      final isTouched = index == touchedIndex;
      final fontSize = isTouched ? 25.0 : 16.0;
      final radius = isTouched ? 60.0 : 50.0;
      const shadows = [Shadow(color: Colors.black, blurRadius: 2)];

      sections.add(PieChartSectionData(
        color: category.color,
        value: amount,
        title: '${(amount / totalAmount * 100).toStringAsFixed(1)}%',
        radius: radius,
        titleStyle: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
          color: ColorsPalette.textPrimary,
          shadows: shadows,
        ),
      ));
      index++;
    });

    return sections;
  }

  Widget _buildPeriodButton(String text, TimePeriod period) {
    final isSelected = widget.selectedPeriod == period;
    final buttonColor = isSelected ? ColorsPalette.primaryDark : Colors.white;
    final textColor = isSelected ? Colors.white : ColorsPalette.textPrimary;
    final borderColor = isSelected ? ColorsPalette.primaryDark : ColorsPalette.primaryDark;
    final buttonSize = isSelected ? 110.0 : 100.0;

    return SizedBox(
      height: 35,
      width: buttonSize,
      child: ElevatedButton(
        onPressed: () {
          setState(() {
            widget.onPeriodChanged(period);
          });
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: buttonColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: BorderSide(color: borderColor, width: 2),
          ),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: textColor,
            fontSize: isSelected ? 18.0 : 16.0,
          ),
        ),
      ),
    );
  }
}



class BalanceWidget extends StatelessWidget {
  const BalanceWidget({super.key});

  @override
  Widget build(BuildContext context) {
    // Read providers for total income and total expenses
    final incomeProvider= context.watch<IncomeTransactionProvider>();
    final expensesProvider= context.watch<TransactionAmountProvider>();

    double totalIncome= incomeProvider.getTotalIncomesForPast10Years();
    double totalExpenses= expensesProvider.getTotalExpensesForPast10Years();

    // Calculate the available balance
    final availableBalance = totalIncome - totalExpenses;
    const currencySymbol = CurrencySymbols.rupee;

    // Determine text color based on balance
    final textColor = availableBalance < 0 ? Colors.red : Colors.green;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          '${availableBalance < 0 ? '-' : ''}${availableBalance.abs().toStringAsFixed(2)}',
          style: TextStyle(
            fontSize: TextSizes.mediumHeadingMax(context),
            fontWeight: FontWeight.w800,
            color: textColor,
          ),
        ),
         Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            'Available Balance:',
            style: TextStyle(
              fontSize: TextSizes.normalBodyTextMax(context),
              fontWeight: FontWeight.w400,
              color: ColorsPalette.textSecondary,
            ),
          ),
        ),
      ],
    );
  }
}