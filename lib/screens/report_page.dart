
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:money_minder/models/bar_chart_data.dart';
import 'package:money_minder/models/line_chart_datamodel.dart';
import 'package:money_minder/provider/transaction_provider.dart';
import 'package:money_minder/res/colors/color_palette.dart';
import 'package:money_minder/res/constants/currency_symbol.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';


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

  // void _updateExpenses() {
  //   _monthlyExpenses = provider.getMonthlyDataForCurrentYear();
  //   _yearlyExpenses = provider.getYearlyDataForPast10Years();
  //
  //   provider.printYearlyMonthExpenses();
  //   provider.printYearlyExpenses();
  // }
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
    // final provider2= context.watch<TransactionAmountProvider>();
    // provider2.printYearlyMonthExpenses();
    // provider2.printYearlyExpenses();
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
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _showMonthly = true;
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _showMonthly ? Colors.blue : Colors.grey,
                        ),
                        child: const Text('Monthly'),
                      ),
                      const SizedBox(width: 18,),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _showMonthly = false;
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: !_showMonthly ? Colors.blue : Colors.grey,
                        ),
                        child: const Text('Yearly'),
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
                          'Monthly Bar Chart',
                          _buildBarChart(MediaQuery.of(context).size),
                          MediaQuery.of(context).size,
                          null,
                        ),
                        _buildChartCard(
                          'Monthly Line Chart',
                          _buildLineChart(MediaQuery.of(context).size),
                          MediaQuery.of(context).size,
                          null,
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
          // Button row

          // Expanded(
          //   child: _showMonthly ? MonthlyTab(provider: provider) : YearlyTab(provider: provider),
          // ),
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


  Widget _buildChartCard(String title, Widget chart, Size size, int? selectedYear) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        Container(
          padding: const EdgeInsets.all(16.0),
          child: chart,
        ),
        if (selectedYear != null)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Text(
              'Year: $selectedYear',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        const IncomeExpensesIcon(),
        const SizedBox(height: 5),
      ],
    );
  }



  // Widget _buildBarChart(Size size) {
  //   final List<StatBarChartData> chartData = _showMonthly
  //       ? List.generate(
  //     12,
  //         (index) {
  //       int month = index + 1; // Month numbers are 1-based
  //       final expense = _monthlyExpenses[month] ?? 0.0;
  //       final income = monthlyIncome[month] ?? 0.0;
  //       return StatBarChartData(
  //           month: month,
  //           income: income,
  //           expense: expense);
  //     },
  //   )
  //       : List.generate(
  //     _yearlyExpenses.length,
  //         (index) {
  //       final year = _yearlyExpenses.keys.elementAt(index);
  //       final expense = _yearlyExpenses[year] ?? 0.0;
  //       final income = yearlyIncome[year] ?? 0.0;
  //       return StatBarChartData(
  //           month: year,
  //           income: income,
  //           expense: expense);
  //     },
  //   );
  //
  //   return BarChartWidget(
  //     chartData: chartData,
  //     size: size,
  //   );
  // }
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

    final List<FlSpot> expenseSpots = _showMonthly
        ? List.generate(
      _monthlyExpenses.length,
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

    final List<FlSpot> incomeSpots = _showMonthly
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

      incomeSpots: incomeSpots,
      expenseSpots: expenseSpots,
    );

    return LineChartWidget(
      chartData: chartData,
      size: size,
      isMonthly: _showMonthly,
    );
  }
}




 




class MonthlyTab extends StatelessWidget {
  final TransactionAmountProvider provider;

  const MonthlyTab({super.key, required this.provider});

  @override
  Widget build(BuildContext context) {
    final monthlyData = provider.getMonthlyDataForCurrentYear();

    return ListView.builder(
      itemCount: monthlyData.length,
      itemBuilder: (context, index) {
        final month = monthlyData.keys.elementAt(index);
        final total = monthlyData[month]!;
        return ListTile(
          title: Text('Month $month'),
          trailing: Text('\$${total.toStringAsFixed(2)}'),
        );
      },
    );
  }
}

class YearlyTab extends StatelessWidget {
  final TransactionAmountProvider provider;

  const YearlyTab({super.key, required this.provider});

  @override
  Widget build(BuildContext context) {
    final yearlyData = provider.getYearlyDataForPast10Years();

    return ListView.builder(
      itemCount: yearlyData.length,
      itemBuilder: (context, index) {
        final year = yearlyData.keys.elementAt(index);
        final total = yearlyData[year]!;
        return ListTile(
          title: Text('Year $year'),
          trailing: Text('\$${total.toStringAsFixed(2)}'),
        );
      },
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


class BarChartWidget extends StatelessWidget {
  final List<StatBarChartData> chartData;
  final Size size;
  final bool isMonthly; // Add a parameter to indicate the period type

  const BarChartWidget({
    super.key,
    required this.chartData,
    required this.size,
    required this.isMonthly, // Initialize the period type
  });

  @override
  Widget build(BuildContext context) {
    final monthNames = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    final List<String> yearLabels = chartData
        .map((data) => data.month.toString()) // Assuming month field is used for year in yearly data
        .toSet()
        .toList() // Ensure yearLabels contains unique years
      ..sort(); // Sort years for proper display

    // final List<String> yearLabels = chartData.map((e) => null)


    // print("year labels*****************************&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&$yearLabels");
    final List<BarChartGroupData> barGroups = chartData.map((data) {
      return BarChartGroupData(
        x: data.month - 1, // Adjust month index to zero-based for the chart
        barRods: [
          BarChartRodData(
            toY: data.expense,
            color: Colors.red,
            borderRadius: BorderRadius.circular(2),
            width: 10,
          ),
          BarChartRodData(
            toY: data.income,
            color: Colors.green,
            width: 10,
            borderRadius: BorderRadius.circular(2),
            backDrawRodData: BackgroundBarChartRodData(
              toY: data.income, // This will display income as background
              color: Colors.green.withOpacity(0.2),
            ),
          ),
        ],
      );
    }).toList();

    return SizedBox(
      height: size.height * 0.3,
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          maxY: (chartData.isNotEmpty)
              ? chartData.map((data) => data.expense).reduce((a, b) => a > b ? a : b) * 2
              : 10000,
          borderData: FlBorderData(
            show: false,
          ),
          gridData: const FlGridData(show: false),
          titlesData: FlTitlesData(
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 35,
                interval: 1,
                getTitlesWidget: (value, meta) {
                  final index = value.toInt();

                  String title;
                  if (isMonthly) {
                    title = index >= 0 && index < monthNames.length
                        ? monthNames[index]
                        : '';
                  } else {
                    title = index >= 0 && index < yearLabels.length
                        ? yearLabels[index]
                        : '';
                  }
                  print('Index:%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% $index, Title: $title'); // Debug print
                  return SideTitleWidget(
                    axisSide: meta.axisSide,
                    child: Text(
                      title,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                      ),
                    ),
                  );
                },
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 45,
                interval: 5000,
                getTitlesWidget: (value, meta) {
                  String formattedValue;
                  if (value >= 1000) {
                    formattedValue = '${(value / 1000).toStringAsFixed(1)}k';
                  } else {
                    formattedValue = value.toInt().toString();
                  }
                  return SideTitleWidget(
                    axisSide: meta.axisSide,
                    child: Text(
                      '$formattedValue ',
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                      ),
                    ),
                  );
                },
              ),
            ),
            rightTitles: const AxisTitles(
              sideTitles: SideTitles(
                showTitles: false,
              ),
            ),
            topTitles: const AxisTitles(
              sideTitles: SideTitles(
                showTitles: false,
              ),
            ),
          ),
          barGroups: barGroups,
        ),
      ),
    );
  }
}



// class BarChartWidget extends StatelessWidget {
//   final List<StatBarChartData> chartData;
//   final Size size;
//
//   const BarChartWidget({
//     Key? key,
//     required this.chartData,
//     required this.size,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//
//     final monthNames = [
//       'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
//       'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
//     ];
//     final List<BarChartGroupData> barGroups = chartData.map((data) {
//       return BarChartGroupData(
//         x: data.month - 1, // Adjust month index to zero-based for the chart
//         barRods: [
//           BarChartRodData(
//             toY: data.expense,
//             color: Colors.red,
//             borderRadius: BorderRadius.circular(2),
//             width: 10,
//           ),
//           BarChartRodData(
//             toY: data.income,
//             color: Colors.green,
//             width: 10,
//             borderRadius: BorderRadius.circular(2),
//             backDrawRodData: BackgroundBarChartRodData(
//               toY: data.income, // This will display income as background
//               color: Colors.green.withOpacity(0.2),
//             ),
//           ),
//         ],
//       );
//     }).toList();
//
//     return SizedBox(
//       height: size.height * 0.3,
//       child: BarChart(
//         BarChartData(
//           alignment: BarChartAlignment.spaceAround,
//           maxY: (chartData.isNotEmpty)
//               ? chartData.map((data) => data.expense).reduce((a, b) => a > b ? a : b) * 2
//               : 10000,
//           borderData: FlBorderData(
//             show: false,
//           ),
//           gridData: const FlGridData(show: false),
//           titlesData: FlTitlesData(
//             bottomTitles: AxisTitles(
//               sideTitles: SideTitles(
//                 showTitles: true,
//                 reservedSize: 25,
//                 interval: 1,
//                 getTitlesWidget: (value, meta) {
//                   final monthIndex = value.toInt();
//                   final index = value.toInt();
//
//
//                   final monthName = monthIndex >= 0 && monthIndex < monthNames.length
//                       ? monthNames[monthIndex]
//                       : '';
//
//                   // return SideTitleWidget(
//                   //   axisSide: meta.axisSide,
//                   //   child: Text(
//                   //     chartData[index].month.toString(), // Set x-axis label
//                   //     style: const TextStyle(fontSize: 14),
//                   //   ),
//                   // );
//                   return SideTitleWidget(
//                     axisSide: meta.axisSide,
//                     child: Text(
//                       monthName,
//                       style: const TextStyle(
//                         color: Colors.black,
//                         fontSize: 14,
//                       ),
//                     ),
//                   );
//                 },
//               ),
//             ),
//             leftTitles: AxisTitles(
//               sideTitles: SideTitles(
//                 showTitles: true,
//                 reservedSize: 45,
//                 interval: 5000,
//                 getTitlesWidget: (value, meta) {
//                   String formattedValue;
//                   if (value >= 1000) {
//                     formattedValue = '${(value / 1000).toStringAsFixed(1)}k';
//                   } else {
//                     formattedValue = value.toInt().toString();
//                   }
//                   return SideTitleWidget(
//                     axisSide: meta.axisSide,
//                     child: Text(
//                       '$formattedValue ',
//                       style: const TextStyle(
//                         color: Colors.black,
//                         fontSize: 14,
//                       ),
//                     ),
//                   );
//                 },
//               ),
//             ),
//             rightTitles: const AxisTitles(
//               sideTitles: SideTitles(
//                 showTitles: false,
//               ),
//             ),
//             topTitles: const AxisTitles(
//               sideTitles: SideTitles(
//                 showTitles: false,
//               ),
//             ),
//           ),
//           barGroups: barGroups,
//         ),
//       ),
//     );
//   }
// }

class LineChartWidget extends StatelessWidget {
  final LineChartDataModel chartData;

  final Size size;
  final bool isMonthly;

  const LineChartWidget({
    super.key,
    required this.chartData,
    required this.size, required this.isMonthly,
  });

  @override
  Widget build(BuildContext context) {

    final monthNames = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    final List<String> yearLabels = chartData.incomeSpots
        .map((spot) => spot.x.toInt().toString())
        .toSet()
        .toList();

    // Extract years from chartData if isMonthly is false

    print("yearLabels*******************************^*^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^$yearLabels");


    return SizedBox(
      height: size.height * 0.3,
      child: LineChart(
        LineChartData(
          gridData: const FlGridData(show: false),
          borderData: FlBorderData(
            show: false,
          ),
          titlesData: FlTitlesData(
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 20,
                interval: 1,
                getTitlesWidget: (value, meta) {
                  final index = value.toInt();
                  String title;

                  if (isMonthly) {
                    title = index >= 0 && index < monthNames.length
                        ? monthNames[index]
                        : '';
                  } else {
                    title = index >= 0 && index < yearLabels.length
                        ? yearLabels[index]
                        : '';
                  }

                  return SideTitleWidget(
                    axisSide: meta.axisSide,
                    child: Text(
                      title,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                      ),
                    ),
                  );
                },

                // getTitlesWidget: (value, meta) {
                //   final monthIndex = value.toInt();
                //   // final monthNames = [
                //   //   'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
                //   //   'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
                //   // ];
                //
                //
                //
                //
                //
                //   final monthNames = [
                //     'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
                //     'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
                //   ];
                //   final monthName = monthIndex >= 0 && monthIndex < monthNames.length
                //       ? monthNames[monthIndex]
                //       : '';
                //   return SideTitleWidget(
                //     axisSide: meta.axisSide,
                //     child: Text(
                //       monthName,
                //       style: const TextStyle(
                //         color: Colors.black,
                //         fontSize: 14,
                //       ),
                //     ),
                //   );
                // },
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 40,
                interval: 3000,
                getTitlesWidget: (value, meta) {
                  String formattedValue;
                  if (value >= 1000) {
                    formattedValue = '${(value / 1000).toStringAsFixed(1)}k';
                  } else {
                    formattedValue = value.toInt().toString();
                  }
                  return SideTitleWidget(
                    axisSide: meta.axisSide,
                    child: Text(
                      '$formattedValue ',
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                      ),
                    ),
                  );
                },
              ),
            ),
            rightTitles: const AxisTitles(
              sideTitles: SideTitles(
                showTitles: false,
              ),
            ),
            topTitles: const AxisTitles(
              sideTitles: SideTitles(
                showTitles: false,
              ),
            ),
          ),
          lineBarsData: [
            LineChartBarData(
              spots: chartData.incomeSpots,
              isCurved: true,
              color: Colors.green,
              belowBarData: BarAreaData(show: false),
              dotData: FlDotData(
                show: true,
                getDotPainter: (spot, percent, bar, index) => FlDotCirclePainter(
                  radius: 4,
                  color: Colors.green,
                  strokeWidth: 1,
                  strokeColor: Colors.white,
                ),
              ),
              aboveBarData: BarAreaData(show: false),
            ),
            LineChartBarData(
              spots: chartData.expenseSpots,
              isCurved: true,
              color: Colors.red,
              belowBarData: BarAreaData(show: false),
              dotData: FlDotData(
                show: true,
                getDotPainter: (spot, percent, bar, index) => FlDotCirclePainter(
                  radius: 4,
                  color: Colors.red,
                  strokeWidth: 1,
                  strokeColor: Colors.white,
                ),
              ),
              aboveBarData: BarAreaData(show: false),
            ),
          ],
        ),
      ),
    );
  }
}







