import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:money_minder/models/time_period.dart';
import 'package:money_minder/provider/transaction_provider.dart';
import 'package:money_minder/res/constants/currency_symbol.dart';
import 'package:money_minder/ui/widgets/stat_app_bar.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:provider/provider.dart';

class StatPage extends StatefulWidget {
  const StatPage({super.key});

  @override
  State<StatPage> createState() => _StatPageState();
}

class _StatPageState extends State<StatPage> {
  final List<FlSpot> incomeData = [
    FlSpot(0, 1000),
    FlSpot(1, 1500),
    FlSpot(2, 2000),
    FlSpot(3, 1200),
    FlSpot(4, 1700),
    FlSpot(5, 1800),
    FlSpot(6, 2100),
  ];

  final List<FlSpot> expenseData = [
    FlSpot(0, 800),
    FlSpot(1, 1300),
    FlSpot(2, 1600),
    FlSpot(3, 1100),
    FlSpot(4, 1500),
    FlSpot(5, 1400),
    FlSpot(6, 1900),
  ];
  final PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return Scaffold(
      appBar: StatAppBar(
        size: size,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              SizedBox(height: 10),
              // Summary Cards
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildSummaryCard('Total Income',
                      '${CurrencySymbols.rupee}12,000', Colors.green),
                  _buildSummaryCard('Total Expenses',
                      '${CurrencySymbols.rupee}12,000', Colors.red),
                  _buildSummaryCard('Profit/Loss',
                      '${CurrencySymbols.rupee}2,000', Colors.blue),
                ],
              ),
              SizedBox(height: 20),
              // Income vs Expenses Bar Chart
              // Container(
              //   height: size.height * 0.4,
              //   decoration: BoxDecoration(
              //     borderRadius: BorderRadius.circular(18.0),
              //     color: Colors.white
              //     // Optionally, you can also add a shadow or border
              //   ),
              //   child: ClipRRect(
              //     borderRadius: BorderRadius.circular(18.0),
              //     child: PageView(
              //       children: [
              //         _buildChartCard('Bar Chart', _buildBarChart(), size),
              //         _buildChartCard('Line Chart', _buildLineChart(), size),
              //       ],
              //     ),
              //   ),
              // ),

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
                                'Line Chart', _buildLineChart(size), size),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: _buildChartCard(
                                'Bar Chart', _buildBarChart(size), size),
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
                          effect: WormEffect(
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

              SizedBox(height: 20),
              // Top Spending Categories
              // Container(
              //   height: 200,
              //   child: BarChart(
              //     BarChartData(
              //       alignment: BarChartAlignment.spaceAround,
              //       maxY: 5000,
              //       barGroups: [
              //         BarChartGroupData(x: 0, barRods: [
              //           BarChartRodData(toY: 4000, color: Colors.orange)
              //         ]),
              //         BarChartGroupData(x: 1, barRods: [
              //           BarChartRodData(toY: 3000, color: Colors.orange)
              //         ]),
              //         // Add more BarChartGroupData for other categories
              //       ],
              //     ),
              //   ),
              // ),
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

  Widget _buildChartCard(String title, Widget chart, Size size) {
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
        const IncomeExpensesIcon(),
        const SizedBox(height: 5,),


      ],
    );
  }

  // Widget _buildBarChart(Size size) {
  //   return SizedBox(
  //     height: size.height*.3,
  //     child: BarChart(
  //       BarChartData(
  //         alignment: BarChartAlignment.spaceAround,
  //         maxY: 2500,
  //         barGroups: [
  //           BarChartGroupData(
  //             x: 0,
  //             barRods: [
  //               BarChartRodData(toY: 1000, color: Colors.green),
  //               BarChartRodData(toY: 800, color: Colors.red),
  //             ],
  //           ),
  //           BarChartGroupData(
  //             x: 1,
  //             barRods: [
  //               BarChartRodData(toY: 1500, color: Colors.green),
  //               BarChartRodData(toY: 1300, color: Colors.red),
  //             ],
  //           ),
  //           // Add more BarChartGroupData for other months
  //         ],
  //       ),
  //     ),
  //   );
  // }

  // Widget _buildLineChart(Size size) {
  //   return SizedBox(
  //     height: size.height*.3,
  //     child: LineChart(
  //       LineChartData(
  //         lineBarsData: [
  //           LineChartBarData(
  //             spots: incomeData,
  //             isCurved: true,
  //             color: Colors.green,
  //             belowBarData: BarAreaData(show: false),
  //             // dotData: const FlDotData(show: false),// if want to remove dot on line  then make it show false;
  //             // belowBarData: BarAreaData(show: false),
  //           ),
  //           LineChartBarData(
  //             spots: expenseData,
  //             isCurved: true,
  //             color: Colors.red,
  //             belowBarData: BarAreaData(show: false),
  //
  //             // dotData: FlDotData(show: false),
  //             // belowBarData: BarAreaData(show: false),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  Widget _buildBarChart(Size size) {
    return SizedBox(
      height: size.height * 0.3,
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          maxY: 2500,
          borderData: FlBorderData(
            show: false, // Remove the border
          ),
          gridData: const FlGridData(show: false), // Remove the grid lines
          // Remove the titles
          barGroups: [
            BarChartGroupData(
              x: 0,
              barRods: [
                BarChartRodData(
                  toY: 1000,
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(8),
                  width: 20,
                  backDrawRodData: BackgroundBarChartRodData(
                    show: true,
                    toY: 2500,
                    color: Colors.grey[300]!,
                  ),
                ),
                BarChartRodData(
                  toY: 800,
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(8),
                  width: 20,
                  backDrawRodData: BackgroundBarChartRodData(
                    show: true,
                    toY: 2500,
                    color: Colors.grey[300]!,
                  ),
                ),
              ],
            ),
            BarChartGroupData(
              x: 1,
              barRods: [
                BarChartRodData(
                  toY: 1500,
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(8),
                  width: 20,
                  backDrawRodData: BackgroundBarChartRodData(
                    show: true,
                    toY: 2500,
                    color: Colors.grey[300]!,
                  ),
                ),
                BarChartRodData(
                  toY: 1300,
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(8),
                  width: 20,
                  backDrawRodData: BackgroundBarChartRodData(
                    show: true,
                    toY: 2500,
                    color: Colors.grey[300]!,
                  ),
                ),
              ],
            ),
            // Add more BarChartGroupData for other months
          ],
        ),
      ),
    );
  }

  Widget _buildLineChart(Size size) {
    return SizedBox(
      height: size.height * 0.3,
      child: LineChart(
        LineChartData(
          gridData: FlGridData(show: false), // Remove the grid lines
          titlesData: FlTitlesData(show: false), // Remove the titles
          borderData: FlBorderData(
            show: false, // Remove the border
          ),
          lineBarsData: [
            LineChartBarData(
              spots: incomeData,
              isCurved: true,
              color: Colors.green,
              belowBarData: BarAreaData(show: false),
              dotData: FlDotData(
                show: true,
                getDotPainter: (spot, percent, bar, index) => FlDotCirclePainter(
                  radius: 6,
                  color: Colors.green,
                  strokeWidth: 2,
                  strokeColor: Colors.white,
                ),
              ),
              // Customize line thickness and other properties
              aboveBarData: BarAreaData(show: false),
              // color: Colors.green,
              // belowBarData: BarAreaData(show: false),
            ),
            LineChartBarData(
              spots: expenseData,
              isCurved: true,
              color: Colors.red,
              belowBarData: BarAreaData(show: false),
              dotData: FlDotData(
                show: true,
                getDotPainter: (spot, percent, bar, index) => FlDotCirclePainter(
                  radius: 6,
                  color: Colors.red,
                  strokeWidth: 2,
                  strokeColor: Colors.white,
                ),
              ),
              // Customize line thickness and other properties
              aboveBarData: BarAreaData(show: false),
              // colors: [Colors.red],
              // belowBarData: BarAreaData(show: false),
            ),
          ],
        ),
      ),
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
              SizedBox(width: 10,),
              Text(
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
              SizedBox(width: 10,),
              Text(
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
