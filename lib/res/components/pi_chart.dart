import 'package:fl_chart/fl_chart.dart';

import 'package:flutter/material.dart';

import 'package:money_minder/models/category_list.dart';
import 'package:money_minder/models/time_period.dart';
import 'package:money_minder/provider/transaction_provider.dart';
import 'package:money_minder/res/colors/color_palette.dart';
import 'package:money_minder/res/constants/text_size.dart';
import 'package:provider/provider.dart';

class PieChartSample2 extends StatefulWidget {
  const PieChartSample2({super.key});

  @override
  State<StatefulWidget> createState() => PieChart2State();
}

class PieChart2State extends State {
  int touchedIndex = -1;
  TimePeriod selectedPeriod= TimePeriod.daily;

  @override
  Widget build(BuildContext context) {
    Size size=MediaQuery.sizeOf(context);
    final transactionProvider = context.watch<TransactionAmountProvider>();







    // final aggregatedData =
    // transactionProvider.getAggregatedData(selectedPeriod);
    final aggregatedData =
    transactionProvider.getAggregatedData(selectedPeriod);
    // final totalAmount = transactionProvider.totalAmount;
    final totalAmount = transactionProvider.getTotalAmountForPeriod(selectedPeriod);
    final sections = _generateSections(aggregatedData,totalAmount);

    print("total daily amount***************************************$totalAmount");

    return  Column(
      // mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [

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
        SizedBox(height: size.height * .08,),
        Stack(
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
                        touchedIndex =
                            pieTouchResponse.touchedSection!.touchedSectionIndex;
                      });
                    },
                  ),
                  borderData: FlBorderData(
                    show: false,
                  ),
                  sectionsSpace: 2,
                  centerSpaceRadius: 60,

                  // sections: showingSections(transactionList, totalAmount),
                  sections: sections,
                ),

              ),
            ),
            Text(
              '₹${totalAmount.toStringAsFixed(2)}',

              style: const TextStyle(
                fontSize: TextSizes.mediumHeadingMin,
                fontWeight: FontWeight.bold,
                color: ColorsPalette.textPrimary,
              ),),
          ],
        ),
        SizedBox(height: size.height* .1), // Add some space between the pie chart and the text below
        Column(
          children: [
            const Text(
              "Available balance",
              style: TextStyle(
                fontSize: TextSizes.mediumHeadingMax,
                fontWeight: FontWeight.w800,
                color: ColorsPalette.textSecondary,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: const Text(
                "₹4000",
                style: TextStyle(
                  fontSize: TextSizes.mediumHeadingMin,
                  fontWeight: FontWeight.w400,
                  color: ColorsPalette.greencColor,
                ),
              ),
            ),
          ],
        ),



      ],

    );
  }



  List<PieChartSectionData> _generateSections(
      Map<CategoryData, double> aggregatedData, double totalAmount) {
    List<PieChartSectionData> sections = [];
    int index = 0;
    // Ensure totalAmount is not zero to avoid division by zero
    // if (totalAmount == 0) {
    //   print('Total amount is zero. No sections to generate.');
    //   return sections;
    // }

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

    // Debug: Print pie chart sections
    print('**************************************Pie Chart Sections:');
    sections.forEach((section) {
      print('**********************${section.title}: ${section.value}');
    });

    return sections;
  }
  Widget _buildPeriodButton(String text, TimePeriod period) {

    final isSelected = selectedPeriod == period;
    final buttonColor = isSelected ? ColorsPalette.primaryDark: Colors.white;
    final textColor = isSelected ? Colors.white : ColorsPalette.textPrimary;
    final borderColor = isSelected ? ColorsPalette. primaryDark : ColorsPalette. primaryDark;
    final buttonSize = isSelected ? 110.0 : 100.0;

    return SizedBox(
      height: 35,
      width: buttonSize,
      child: ElevatedButton(
        onPressed: () {
          setState(() {
            selectedPeriod = period;
            context.read<TransactionAmountProvider>().setTimePeriod(period);
          });


        },
        style: ElevatedButton.styleFrom(
          backgroundColor: buttonColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: BorderSide(color: borderColor,width: 2)
          )
        ),
        child: Text(text,
          style: TextStyle(
            color: textColor,
            fontSize: isSelected ? 18.0 : 16.0,
          ),
        ),
      ),
    );
  }

  // List<PieChartSectionData> showingSections(
  //     List<AddTransactionsData> transactions, double totalAmount) {
  //   if (totalAmount == 0) {
  //     return [];
  //   }
  //
  //   return List.generate(transactions.length, (i) {
  //     final transaction = transactions[i];
  //     final isTouched = i == touchedIndex;
  //     final fontSize = isTouched ? 25.0 : 16.0;
  //     final radius = isTouched ? 60.0 : 50.0;
  //     final percentage = (transaction.expensesPrice / totalAmount) * 100;
  //     const shadows = [Shadow(color: Colors.black, blurRadius: 2)];
  //
  //     return PieChartSectionData(
  //       color: transaction.categoryData.color,
  //       value: percentage,
  //       title: '${percentage.toStringAsFixed(1)}%',
  //       radius: radius,
  //       titleStyle: TextStyle(
  //         fontSize: fontSize,
  //         fontWeight: FontWeight.bold,
  //         color: ColorsPalette.textPrimary,
  //         shadows: shadows,
  //       ),
  //     );
  //   });
  // }


}




class PeriodButton extends StatefulWidget {
  final String text;
  final TimePeriod period;
  final TimePeriod selectedPeriod;
  final void Function(TimePeriod) onPeriodChanged;

  const PeriodButton({
    Key? key,
    required this.text,
    required this.period,
    required this.selectedPeriod,
    required this.onPeriodChanged,
  }) : super(key: key);

  @override
  _PeriodButtonState createState() => _PeriodButtonState();
}

class _PeriodButtonState extends State<PeriodButton> {
  @override
  Widget build(BuildContext context) {
    final isSelected = widget.selectedPeriod == widget.period;
    final buttonColor = isSelected ? ColorsPalette.primaryDark : Colors.white;
    final textColor = isSelected ? Colors.white : ColorsPalette.textPrimary;
    final borderColor = isSelected ? ColorsPalette.primaryDark : ColorsPalette.primaryDark;
    final buttonSize = isSelected ? 100.0 : 80.0;

    return SizedBox(
      height: 35,
      width: buttonSize,
      child: ElevatedButton(
        onPressed: () {
          setState(() {
            widget.onPeriodChanged(widget.period);
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
          widget.text,
          style: TextStyle(
            color: textColor,
            fontSize: isSelected ? 18.0 : 16.0,
          ),
        ),
      ),
    );
  }
}






