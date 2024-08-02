import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:money_minder/res/constants/currency_symbol.dart';
import 'package:money_minder/ui/widgets/stat_app_bar.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';


class StatPage extends StatefulWidget {
  const StatPage({super.key});

  @override
  State<StatPage> createState() => _StatPageState();
}

class _StatPageState extends State<StatPage> {
  final List<FlSpot> incomeData = [
    const FlSpot(0, 1000),
    const FlSpot(1, 1500),
    const FlSpot(2, 2000),
    const FlSpot(3, 1200),
    const FlSpot(4, 1700),
    const FlSpot(5, 1800),
    const FlSpot(6, 2100),
    const FlSpot(7, 1000),
    const FlSpot(8, 1500),
    const FlSpot(9, 2000),
    const FlSpot(10, 1200),
    const FlSpot(11, 1700),
  ];

  final List<FlSpot> expenseData = [
    const FlSpot(0, 1200),
    const FlSpot(1, 1300),
    const FlSpot(2, 1600),
    const FlSpot(3, 1100),
    const FlSpot(4, 1500),
    const FlSpot(5, 1400),
    const FlSpot(6, 1100),
    const FlSpot(7, 800),
    const FlSpot(8, 900),
    const FlSpot(9, 300),
    const FlSpot(10, 900),
    const FlSpot(11, 1700),
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
              const SizedBox(height: 10),
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
                                'Bar Chart', _buildBarChart(size), size),
                          ),
                          Padding(
                            padding:
                            const EdgeInsets.symmetric(horizontal: 8.0),
                            child: _buildChartCard(
                                'Line Chart', _buildLineChart(size), size),
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

              const SizedBox(height: 20),
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



  Widget _buildBarChart(Size size) {

    final List<String> monthNames = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    // Generate bar chart data for each month
    final List<BarChartGroupData> barGroups = List.generate(
      monthNames.length,
          (index) => BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: (index + 1) * 500, // Example values; replace with actual data
            color: Colors.green,
            borderRadius: BorderRadius.circular(2),
            width: 10,
            // backDrawRodData: BackgroundBarChartRodData(
            //   show: true,
            //   toY: 8000,
            //   color: Colors.grey[300]!,
            // ),
          ),
          BarChartRodData(
            toY: (index + 1) * 400, // Example values; replace with actual data
            color: Colors.red,
            borderRadius: BorderRadius.circular(2),
            width: 10,
            // backDrawRodData: BackgroundBarChartRodData(
            //   show: true,
            //   toY: 8000,
            //   color: Colors.grey[300]!,
            // ),
          ),
        ],
      ),
    );



    return SizedBox(
      height: size.height * 0.3,
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          maxY: 8000,
          borderData: FlBorderData(
            show: false, // Remove the border
          ),
          gridData: const FlGridData(show: false), // Remove the grid lines

          titlesData: FlTitlesData(
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 25,
                interval: 1, // Ensure titles for each month
                getTitlesWidget: (value, meta) {
                  final monthIndex = value.toInt();
                  // Ensure monthIndex is within range
                  final monthName = monthIndex >= 0 && monthIndex < monthNames.length
                      ? monthNames[monthIndex]
                      : '';
                  return SideTitleWidget(
                    axisSide: meta.axisSide,
                    child: Text(
                      monthName,
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
                reservedSize: 30,
                interval: 1000, // Adjust interval for y-axis titles
                getTitlesWidget: (value, meta) {
                  // Format the y-axis titles
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

  Widget _buildLineChart(Size size) {
    final List<String> monthNames = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];

    return SizedBox(
      height: size.height * 0.3,
      child: LineChart(
        LineChartData(
          gridData: const FlGridData(show: false), // Remove the grid lines

          borderData: FlBorderData(
            show: false, // Remove the border
          ),
          titlesData: FlTitlesData(
            bottomTitles: AxisTitles(

              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 30,
                interval: 1,

                getTitlesWidget: (value, meta) {

                  final monthIndex = value.toInt();
                  // Ensure monthIndex is within range
                  final monthName = monthIndex >= 0 && monthIndex < monthNames.length
                      ? monthNames[monthIndex % monthNames.length]
                      : '';
                  return SideTitleWidget(
                    axisSide: meta.axisSide,
                    child: Text(
                       monthName,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                      ),
                    ),
                  );
                },
              )

            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 40,
                interval: 1000,

                getTitlesWidget: (value, meta) {

                  // Format the y-axis titles
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
              )
            ),
            rightTitles: const AxisTitles(
              sideTitles: SideTitles(
                showTitles: false
              )
            ),
            topTitles: const AxisTitles(
                sideTitles: SideTitles(
                    showTitles: false
                )
            )

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
                  radius: 4,
                  color: Colors.green,
                  strokeWidth: 1,
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
                  radius: 4,
                  color: Colors.red,
                  strokeWidth: 1,
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

// class Titles {
//   static getTitlesData()=> const FlTitlesData(
//     show: true,
//     bottomTitles: SideTitles(
//
//
//     )
//
//
//   );
//
// }
