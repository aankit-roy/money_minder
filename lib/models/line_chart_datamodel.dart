import 'package:fl_chart/fl_chart.dart';

class LineChartDataModel {
  final List<FlSpot> incomeSpots;
  final List<FlSpot> expenseSpots;

  LineChartDataModel({
    required this.incomeSpots,
    required this.expenseSpots,
  });
}