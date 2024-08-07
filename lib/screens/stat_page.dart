import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:money_minder/models/bar_chart_data.dart';
import 'package:money_minder/models/line_chart_datamodel.dart';
import 'package:money_minder/models/time_period.dart';
import 'package:money_minder/provider/transaction_provider.dart';
import 'package:money_minder/res/constants/currency_symbol.dart';
import 'package:money_minder/ui/widgets/barchart_data.dart';
import 'package:money_minder/ui/widgets/stat_app_bar.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../ui/widgets/linechart_data.dart';


class StatPage extends StatefulWidget {
  const StatPage({super.key});

  @override
  State<StatPage> createState() => _StatPageState();
}

class _StatPageState extends State<StatPage> {

  int? _selectedMonth;
  double _totalExpenses = 0.0;
  int? _selectedYear;
  bool _showMonthly = true;
  Map<int, double> _monthlyExpenses = {};

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    // _selectedMonth = now.year;
    _selectedYear = now.year;
    _fetchTotalExpenses();
    _fetchYearlyExpenses();
  }


  final Map<int, double> _yearlyMonthlyIncome = {
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

  final PageController _pageController = PageController();
  TimePeriod selectedPeriod= TimePeriod.monthly;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    final transactionProvider = Provider.of<TransactionAmountProvider>(context);



    // final statProvider=Provider.of<StatsPeriodsProvider>(context);
    // String selectedPeriod2= statProvider.selectedPeriod;
    // String selectedMonth= statProvider.selectedMonth;
    // String selectedYear= statProvider.selectedYear;




    transactionProvider.getAggregatedData(selectedPeriod);
    // final totalAmount = transactionProvider.totalAmount;




    return Scaffold(
      appBar: StatAppBar(
        size: const Size.fromHeight(140),
        onMonthSelected: (month) {



          print("getting data on monthly basis********************************");

          // final monthNumber = int.tryParse(month.split('/').first) ?? DateTime.now().month;
          // setState(() {
          //   _selectedMonth = monthNumber;
          //   _fetchTotalExpenses();
          // });
        },
        onYearSelected: (year) {
          final yearNumber = int.tryParse(year) ?? DateTime.now().year;
          setState(() {
            _selectedYear = yearNumber;
            _fetchYearlyExpenses();
          });
          
          print("Clicking  getting yearly data **********************************************************");
        },
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const SizedBox(height: 10),
              // Summary Cards
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildSummaryCard('Total Income',
                      '${CurrencySymbols.rupee}12,000', Colors.green),
                  _buildSummaryCard('Total Expenses',
                      '${CurrencySymbols.rupee}$_totalExpenses', Colors.red),
                  _buildSummaryCard('Profit/Loss',
                      '${CurrencySymbols.rupee}2,000', Colors.blue),
                ],
              ),
              const SizedBox(height: 20),

              Container(
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

                          Padding(
                            padding:
                            const EdgeInsets.symmetric(horizontal: 8.0),
                            child: _buildChartCard(
                                'Bar Chart', _buildBarChart(size), size,_selectedYear),
                          ),
                          // Padding(
                          //   padding:
                          //   const EdgeInsets.symmetric(horizontal: 8.0),
                          //   child: _buildChartCard(
                          //       'Line Chart', _buildLineChart(size), size,_selectedYear),
                          // ),


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

              const SizedBox(height: 20),

            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryCard(String title, String value, Color color) {
    return Card(
      color: color.withOpacity(0.1),
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

  Widget _buildChartCard(String title, Widget chart, Size size,int? selectedYear) {
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
        const SizedBox(height: 5,),


      ],
    );
  }




  Widget _buildBarChart(Size size) {
    final List<StatBarChartData> chartData = List.generate(
      12,
          (index) {
        int month = index + 1; // Month numbers are 1-based
        final expense = _monthlyExpenses[month] ?? 0.0;
        final income = _yearlyMonthlyIncome[month] ?? 0.0;
        return StatBarChartData(
          month: month,
          income: income,
          expense: expense


        );
      },
    );

    return BarChartWidget(
      chartData: chartData,
      size: size,
      isMonthly: _showMonthly,

    );
  }
  // Widget _buildLineChart(Size size) {
  //   final List<String> monthNames = [
  //     'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
  //     'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
  //   ];
  //
  //   // Convert _monthlyExpenses and _yearlyMonthlyIncome to FlSpot
  //   final List<FlSpot> expenseSpots = List.generate(
  //     monthNames.length,
  //         (index) {
  //       final month = index + 1;
  //       final expense = _monthlyExpenses[month] ?? 0.0;
  //       return FlSpot(index.toDouble(), expense);
  //     },
  //   );
  //
  //   final List<FlSpot> incomeSpots = List.generate(
  //     monthNames.length,
  //         (index) {
  //       final month = index + 1;
  //       final income = _yearlyMonthlyIncome[month] ?? 0.0;
  //       return FlSpot(index.toDouble(), income);
  //     },
  //   );
  //
  //   final chartData = LineChartDataModel(
  //     incomeSpots: incomeSpots,
  //     expenseSpots: expenseSpots,
  //   );
  //
  //   return LineChartWidget(
  //     chartData: chartData,
  //     size: size,
  //     isMonthly: _showMonthly,
  //   );
  // }

  // Widget _buildLineChart(Size size) {
  //   final List<String> monthNames = [
  //     'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
  //     'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
  //   ];
  //
  //   // Convert _monthlyExpenses and _monthlyIncome to FlSpot
  //   final List<FlSpot> expenseSpots = List.generate(
  //     monthNames.length,
  //         (index) {
  //       final month = index + 1;
  //       final expense = _monthlyExpenses[month] ?? 0.0;
  //       return FlSpot(index.toDouble(), expense);
  //     },
  //   );
  //
  //   final List<FlSpot> incomeSpots = List.generate(
  //     monthNames.length,
  //         (index) {
  //       final month = index + 1;
  //       final income =  _yearlyMonthlyIncome[month] ?? 0.0;
  //       return FlSpot(index.toDouble(), income);
  //     },
  //   );
  //
  //   return SizedBox(
  //     height: size.height * 0.3,
  //     child: LineChart(
  //       LineChartData(
  //         gridData: const FlGridData(show: false),
  //         borderData: FlBorderData(
  //           show: false,
  //         ),
  //         titlesData: FlTitlesData(
  //           bottomTitles: AxisTitles(
  //             sideTitles: SideTitles(
  //               showTitles: true,
  //               reservedSize: 20,
  //               interval: 1,
  //               getTitlesWidget: (value, meta) {
  //                 final monthIndex = value.toInt();
  //                 final monthName = monthIndex >= 0 && monthIndex < monthNames.length
  //                     ? monthNames[monthIndex]
  //                     : '';
  //                 return SideTitleWidget(
  //                   axisSide: meta.axisSide,
  //                   child: Text(
  //                     monthName,
  //                     style: const TextStyle(
  //                       color: Colors.black,
  //                       fontSize: 14,
  //                     ),
  //                   ),
  //                 );
  //               },
  //             ),
  //           ),
  //           leftTitles: AxisTitles(
  //             sideTitles: SideTitles(
  //               showTitles: true,
  //               reservedSize: 40,
  //               interval: 3000,
  //               getTitlesWidget: (value, meta) {
  //                 String formattedValue;
  //                 if (value >= 1000) {
  //                   formattedValue = '${(value / 1000).toStringAsFixed(1)}k';
  //                 } else {
  //                   formattedValue = value.toInt().toString();
  //                 }
  //                 return SideTitleWidget(
  //                   axisSide: meta.axisSide,
  //                   child: Text(
  //                     '$formattedValue ',
  //                     style: const TextStyle(
  //                       color: Colors.black,
  //                       fontSize: 14,
  //                     ),
  //                   ),
  //                 );
  //               },
  //             ),
  //           ),
  //           rightTitles: const AxisTitles(
  //             sideTitles: SideTitles(
  //               showTitles: false,
  //             ),
  //           ),
  //           topTitles: const AxisTitles(
  //             sideTitles: SideTitles(
  //               showTitles: false,
  //             ),
  //           ),
  //         ),
  //         lineBarsData: [
  //           LineChartBarData(
  //             spots: incomeSpots,
  //             isCurved: true,
  //             color: Colors.green,
  //             belowBarData: BarAreaData(show: false),
  //             dotData: FlDotData(
  //               show: true,
  //               getDotPainter: (spot, percent, bar, index) => FlDotCirclePainter(
  //                 radius: 4,
  //                 color: Colors.green,
  //                 strokeWidth: 1,
  //                 strokeColor: Colors.white,
  //               ),
  //             ),
  //             aboveBarData: BarAreaData(show: false),
  //           ),
  //           LineChartBarData(
  //             spots: expenseSpots,
  //             isCurved: true,
  //             color: Colors.red,
  //             belowBarData: BarAreaData(show: false),
  //             dotData: FlDotData(
  //               show: true,
  //               getDotPainter: (spot, percent, bar, index) => FlDotCirclePainter(
  //                 radius: 4,
  //                 color: Colors.red,
  //                 strokeWidth: 1,
  //                 strokeColor: Colors.white,
  //               ),
  //             ),
  //             aboveBarData: BarAreaData(show: false),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }


  void _fetchTotalExpenses() {
    if (_selectedMonth == null || _selectedYear == null) return;

    final provider = Provider.of<TransactionAmountProvider>(context, listen: false);
    final aggregatedData = provider.getAggregatedDataByMonths(
      TimePeriod.monthly,
      selectedMonth: _selectedMonth,
      // selectedYear: _selectedYear,
    );

    setState(() {
      _totalExpenses = aggregatedData.values.fold(0.0, (sum, amount) => sum + amount);
    });
  }

  void _fetchYearlyExpenses() {
    if (_selectedYear == null) return;

    final provider = Provider.of<TransactionAmountProvider>(context, listen: false);
    final aggregatedData = provider.getAggregatedDataByYear(_selectedYear!);

    setState(() {
      _totalExpenses = aggregatedData.values.fold(0.0, (sum, amount) => sum + amount);
      _monthlyExpenses = aggregatedData;
    });
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



