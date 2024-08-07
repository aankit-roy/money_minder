import 'package:fl_chart/fl_chart.dart';
class LineChartDataModel {
  final List<String> xAxisLabels;
  final List<FlSpot> incomeSpots;
  final List<FlSpot> expenseSpots;

  LineChartDataModel({
    required this.xAxisLabels,
    required this.incomeSpots,
    required this.expenseSpots,
  });

  // Convert to Map
  Map<String, dynamic> toMap() {
    return {
      'xAxisLabels': xAxisLabels,
      'incomeSpots': incomeSpots.map((spot) => {'x': spot.x, 'y': spot.y}).toList(),
      'expenseSpots': expenseSpots.map((spot) => {'x': spot.x, 'y': spot.y}).toList(),
    };
  }

  // Convert from Map
  factory LineChartDataModel.fromMap(Map<String, dynamic> map) {
    return LineChartDataModel(
      xAxisLabels: List<String>.from(map['xAxisLabels']),
      incomeSpots: (map['incomeSpots'] as List).map((spot) => FlSpot(spot['x'], spot['y'])).toList(),
      expenseSpots: (map['expenseSpots'] as List).map((spot) => FlSpot(spot['x'], spot['y'])).toList(),
    );
  }
}