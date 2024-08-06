class StatBarChartData {
  final int month;
  final double expense;
  final double income;

  StatBarChartData({
    required this.month,
    required this.expense,
    required this.income,
  });

  // Convert a StatBarChartData instance to a Map
  Map<String, dynamic> toMap() {
    return {
      'month': month,
      'expense': expense,
      'income': income,
    };
  }

  // Create a StatBarChartData instance from a Map
  factory StatBarChartData.fromMap(Map<String, dynamic> map) {
    return StatBarChartData(
      month: map['month'] as int,
      expense: (map['expense'] as num).toDouble(),
      income: (map['income'] as num).toDouble(),
    );
  }



}