import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:money_minder/models/bar_chart_data.dart';

class BarChartWidget extends StatelessWidget {
  final List<StatBarChartData> chartData;
  final Size size;
  final bool isMonthly;

   const BarChartWidget({
    super.key,
    required this.chartData,
    required this.size,
    required this.isMonthly,
  });

  @override
  Widget build(BuildContext context) {
    final monthNames = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];

    final List<String> yearLabels = chartData
        .map((data) => data.month.toString()) // Assuming 'month' field is used for years in yearly data
        .toSet()
        .toList()
      ..sort((a, b) => int.parse(a).compareTo(int.parse(b))); // Sort years numerically

    final double maxY = (chartData.isNotEmpty)
        ? chartData.map((data) => data.expense).reduce((a, b) => a > b ? a : b) * 1.2
        : 10000;
    final interval = maxY / 5; // Avoid zero interval


    final List<BarChartGroupData> barGroups = chartData.map((data) {
      final xIndex = isMonthly
          ? data.month - 1 // For monthly data, zero-based index
          : yearLabels.indexOf(data.month.toString()); // For yearly data

      return BarChartGroupData(
        x: xIndex,
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
              ? chartData.map((data) => data.expense).reduce((a, b) => a > b ? a : b) * 1.1
              : 10000,
          borderData: FlBorderData(
            show: false,
          ),
          gridData: const FlGridData(show: false),
          titlesData: FlTitlesData(
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 25,
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
              ),
            ),

            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 45,
                interval:  4000,// Adjust this as needed
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