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
    required this.size,
    required this.isMonthly,
  });

  @override
  Widget build(BuildContext context) {

    // Compute min and max values for expenses and income
    final double minExpense = chartData.expenseSpots
        .where((spot) => spot.y > 0)
        .map((spot) => spot.y)
        .isNotEmpty
        ? chartData.expenseSpots
        .where((spot) => spot.y > 0)
        .map((spot) => spot.y)
        .reduce((a, b) => a < b ? a : b)
        : 0;

    final double minIncome = chartData.incomeSpots
        .where((spot) => spot.y > 0)
        .map((spot) => spot.y)
        .isNotEmpty
        ? chartData.incomeSpots
        .where((spot) => spot.y > 0)
        .map((spot) => spot.y)
        .reduce((a, b) => a < b ? a : b)
        : 0;

    final double maxExpense = chartData.expenseSpots.isNotEmpty
        ? chartData.expenseSpots.map((spot) => spot.y).reduce((a, b) => a > b ? a : b)
        : 0;

    final double maxIncome = chartData.incomeSpots.isNotEmpty
        ? chartData.incomeSpots.map((spot) => spot.y).reduce((a, b) => a > b ? a : b)
        : 0;

    final double maxY = maxExpense > maxIncome ? maxExpense : maxIncome;

    // Define margin as a percentage of the maxY value
    final double marginPercentage = 0.1; // 10% margin
    final double margin = maxY * marginPercentage;

    // Set minY to slightly below the minimum non-zero value
    final double minY = minExpense < minIncome ? minExpense : minIncome;

    // Calculate interval and ensure it is not zero
    final double interval = calculateInterval(maxY + margin, 5); // Example with 5 intervals
    final double minInterval = 1000; // Minimum interval to prevent zero



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
                getTitlesWidget: (value, meta) {
                  final index = value.toInt();
                  final title =
                      index >= 0 && index < chartData.xAxisLabels.length
                          ? chartData.xAxisLabels[index]
                          : '';
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
                reservedSize: 40,
                interval: (interval > 0) ? interval : minInterval, // Ensure interval is not zero
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
                getDotPainter: (spot, percent, bar, index) =>
                    FlDotCirclePainter(
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
                getDotPainter: (spot, percent, bar, index) =>
                    FlDotCirclePainter(
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

  double calculateInterval(double maxY, int numIntervals) {
    // Divide the max value by the number of intervals and round up
    return (maxY / numIntervals).ceilToDouble();
  }

}


