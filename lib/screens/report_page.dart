
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:money_minder/models/bar_chart_data.dart';
import 'package:money_minder/models/line_chart_datamodel.dart';
import 'package:money_minder/provider/transaction_provider.dart';
import 'package:money_minder/res/colors/color_palette.dart';
import 'package:money_minder/res/constants/currency_symbol.dart';
import 'package:money_minder/res/constants/text_size.dart';
import 'package:money_minder/screens/stat_page.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../ui/widgets/barchart_data.dart';
import '../ui/widgets/linechart_data.dart';


class ReportPage extends StatefulWidget {
  const ReportPage({super.key});

  @override
  State<ReportPage> createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  Map<int, double> _monthlyExpenses = {}; // Initialize with empty map
  Map<int, double> _yearlyExpenses = {};  // Initialize with empty map


  late TransactionAmountProvider provider;
  bool _showMonthly = true;

  @override
  void initState() {
    super.initState();

    // _updateExpenses();
  }

   
  final Map<int, double> monthlyIncome = {
    1: 1200.0,
    2: 1400.0,
    3: 1300.0,
    4: 1100.0,
    5: 1500.0,
    6: 1600.0,
    7: 1700.0,
    8: 1800.0,
    9: 1900.0,
    10: 1500.0,
    11: 1600.0,
    12: 1400.0,
  };
  final Map<int, double> yearlyIncome = {
    1: 1200.0,
    2: 1400.0,
    3: 1400.0,
    4: 1100.0,
    5: 1800.0,
    6: 1000.0,
    7: 1900.0,
    8: 1810.0,
    9: 1110.0,
    10: 1100.0,
    11: 1600.0,
    12: 1400.0,
  };

  @override
  Widget build(BuildContext context) {
   
   final provider = context.read<TransactionAmountProvider>();
   _monthlyExpenses = provider.getMonthlyDataForCurrentYear();
   _yearlyExpenses = provider.getYearlyDataForPast10Years();



    Size size= MediaQuery.sizeOf(context);
    final PageController _pageController = PageController();
    double totalExpensesCurrentYear= provider.getTotalExpensesForCurrentYear();
    double totalExpensesAllYear= provider.getTotalExpensesForCurrentYear();
    double totalExpenses=_showMonthly?totalExpensesCurrentYear :totalExpensesAllYear;
    return Scaffold(

      body: Column(
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                height: 200,
                decoration: const BoxDecoration(
                  color: ColorsPalette.primaryColor,
                  borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),


                ),
                child: Center(
                  child: Row(
                     mainAxisAlignment: MainAxisAlignment.center,

                    // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // ElevatedButton(
                      //   onPressed: () {
                      //     setState(() {
                      //       _showMonthly = true;
                      //     });
                      //   },
                      //   style: ElevatedButton.styleFrom(
                      //     backgroundColor: _showMonthly ? ColorsPalette.primaryDark
                      //         : Colors.white,
                      //     foregroundColor: _showMonthly? ColorsPalette.white
                      //         : ColorsPalette.textPrimary,
                      //     shape: RoundedRectangleBorder(
                      //       borderRadius: BorderRadius.circular(20),
                      //     ),
                      //     padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      //
                      //
                      //   ),
                      //   child: const Text('Monthly',
                      //     style: TextStyle(
                      //       fontSize: TextSizes.mediumHeadingMax,
                      //       fontWeight: FontWeight.w600,
                      //     ),
                      //   ),
                      // ),
                      // SizedBox(width: size.width*.1,),
                      // ElevatedButton(
                      //   onPressed: () {
                      //     setState(() {
                      //       _showMonthly = false;
                      //     });
                      //   },
                      //   style: ElevatedButton.styleFrom(
                      //     backgroundColor: !_showMonthly ? ColorsPalette.primaryDark
                      //         : Colors.white,
                      //     foregroundColor: !_showMonthly? ColorsPalette.white
                      //         : ColorsPalette.textPrimary,
                      //     shape: RoundedRectangleBorder(
                      //       borderRadius: BorderRadius.circular(20),
                      //     ),
                      //     padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      //
                      //
                      //   ),
                      //   child: const Text('Yearly',
                      //     style: TextStyle(
                      //       fontSize: TextSizes.mediumHeadingMax,
                      //       fontWeight: FontWeight.w600,
                      //     ),
                      //   ),
                      // ),

                      CustomPeriodButton(
                        isSelected: _showMonthly,
                        label: 'Monthly',
                        onPressed: () {
                          setState(() {
                            _showMonthly = true;
                          });
                        },
                      ),
                      SizedBox(width: size.width * 0.1),
                      CustomPeriodButton(
                        isSelected: !_showMonthly,
                        label: 'Yearly',
                        onPressed: () {
                          setState(() {
                            _showMonthly = false;
                          });
                        },
                      ),

                    ],
                  ),
                ),

              ),

              Positioned(
                top: 150,
                left: 0,
                right: 0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildSummaryCard('Total Income',
                        '${CurrencySymbols.rupee}12,000', Colors.green),
                    _buildSummaryCard('Total Expenses',
                        '${CurrencySymbols.rupee}$totalExpenses', Colors.red),
                    _buildSummaryCard('Profit/Loss',
                        '${CurrencySymbols.rupee}2,000', Colors.blue),
                  ],
                ),
              ),


            ],

          ),
           SizedBox(height:size.height*.07 ,),

          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              height: size.height * 0.5,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18.0),
                color: Colors.white,
              ),
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(18.0),
                    child: PageView(
                      controller: _pageController,
                      children: [

                        _buildChartCard(

                          _buildBarChart(size),
                          size,
                          _showMonthly
                        ),
                        _buildChartCard(

                          _buildLineChart(size),
                          size,
                           _showMonthly
                        ),


                      ],
                    ),
                  ),
                  Positioned(
                    bottom: 10,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: SmoothPageIndicator(
                        controller: _pageController,
                        count: 2, // Number of pages
                        effect: const WormEffect(
                          dotWidth: 10,
                          dotHeight: 10,
                          spacing: 8,
                          radius: 8,
                          dotColor: Colors.grey,
                          activeDotColor: Colors.blue,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 20),

        ],
      ),
    );
  }

  Widget _buildSummaryCard(String title, String value, Color color) {
    return Card(
      // color: color.withOpacity(0.1),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(title,
                style:
                const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Text(value,
                style: TextStyle(
                    fontSize: 24, fontWeight: FontWeight.bold, color: color)),
          ],
        ),
      ),
    );
  }


  Widget _buildChartCard(Widget chart, Size size, bool isMonthly) {
    final displayTitle = isMonthly ? 'Monthly' : 'Yearly';
    final displayYear = isMonthly ? DateTime.now().year.toString() : '';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            displayTitle,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        Container(
          padding: const EdgeInsets.all(16.0),
          child: chart,
        ),
        if (isMonthly)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Text(
              'Year: $displayYear',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        const IncomeExpensesIcon(),
        const SizedBox(height: 5),
      ],
    );
  }


  Widget _buildBarChart(Size size) {
    final List<StatBarChartData> chartData = _showMonthly
        ? List.generate(
      _monthlyExpenses.length,
          (index) {
        int month = index + 1; // Month numbers are 1-based
        final expense = _monthlyExpenses[month] ?? 0.0;
        final income = monthlyIncome[month] ?? 0.0;
        return StatBarChartData(
            month: month,
            income: income,
            expense: expense);
      },
    )
        : List.generate(
      _yearlyExpenses.length,
          (index) {
        final year = _yearlyExpenses.keys.elementAt(index);
        final expense = _yearlyExpenses[year] ?? 0.0;
        final income = yearlyIncome[year] ?? 0.0;
        return StatBarChartData(
            month: year, // Use year as x-axis label for yearly view
            income: income,
            expense: expense);
      },
    );

    return BarChartWidget(
      chartData: chartData,
      size: size,
      isMonthly: _showMonthly,
    );
  }

  Widget _buildLineChart(Size size) {
    final isMonthly = _showMonthly;

    // Generate x-axis labels
    final List<String> xAxisLabels = isMonthly
        ? List.generate(12, (index) => [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ][index])
        : List.generate(
      _yearlyExpenses.length,
          (index) {
        final year = _yearlyExpenses.keys.elementAt(index);
        return year.toString();
      },
    );

    // Generate expense spots
    final List<FlSpot> expenseSpots = isMonthly
        ? List.generate(
      12,
          (index) {
        final month = index + 1;
        final expense = _monthlyExpenses[month] ?? 0.0;
        return FlSpot(index.toDouble(), expense);
      },
    )
        : List.generate(
      _yearlyExpenses.length,
          (index) {
        final year = _yearlyExpenses.keys.elementAt(index);
        final expense = _yearlyExpenses[year] ?? 0.0;
        return FlSpot(index.toDouble(), expense);
      },
    );

    // Generate income spots
    final List<FlSpot> incomeSpots = isMonthly
        ? List.generate(
      12,
          (index) {
        final month = index + 1;
        final income = monthlyIncome[month] ?? 0.0;
        return FlSpot(index.toDouble(), income);
      },
    )
        : List.generate(
      _yearlyExpenses.length,
          (index) {
        final year = _yearlyExpenses.keys.elementAt(index);
        final income = yearlyIncome[year] ?? 0.0;
        return FlSpot(index.toDouble(), income);
      },
    );

    final chartData = LineChartDataModel(
      xAxisLabels: xAxisLabels,
      incomeSpots: incomeSpots,
      expenseSpots: expenseSpots,
    );

    return LineChartWidget(
      chartData: chartData,
      size: size,
      isMonthly: isMonthly,
    );
  }





}


class IncomeExpensesIcon extends StatelessWidget {
  const IncomeExpensesIcon({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Container(
                height: 20,
                width: 20,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(3),
                  color: Colors.green,
                ),

              ),
              const SizedBox(width: 10,),
              const Text(
                "Income",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              )
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Container(
                height: 20,
                width: 20,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(3),
                  color: Colors.red,
                ),

              ),
              const SizedBox(width: 10,),
              const Text(
                "Expenses",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              )
            ],
          ),
        ),
      ],
    );
  }
}
class CustomPeriodButton extends StatelessWidget {
  final bool isSelected;
  final String label;
  final VoidCallback onPressed;

  const CustomPeriodButton({
    Key? key,
    required this.isSelected,
    required this.label,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: isSelected ? ColorsPalette.primaryDark : Colors.white,
        foregroundColor: isSelected ? ColorsPalette.white : ColorsPalette.textPrimary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: TextSizes.mediumHeadingMax,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}







