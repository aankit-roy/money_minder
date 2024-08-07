

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:money_minder/models/line_chart_datamodel.dart';

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
