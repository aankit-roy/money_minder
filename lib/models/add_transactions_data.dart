import 'dart:convert';

import 'package:money_minder/models/category_list.dart';

class AddTransactionsData {
  final int? id;
  final CategoryData categoryData;
   double expensesPrice;
  final DateTime date;

  AddTransactionsData({
    this.id,
    required this.categoryData,
    required this.expensesPrice,
    required this.date,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'category_id': categoryData.id,
      'amount': expensesPrice,
      'date': date.toIso8601String(),
    };
  }

  factory AddTransactionsData.fromMap(Map<String, dynamic> map) {
    return AddTransactionsData(
      id: map['id'],
      categoryData: map['category_id'],
      expensesPrice: map['amount'],
      date: DateTime.parse(map['date']),
    );
  }
  // factory AddTransactionsData.fromMap(Map<String, dynamic> map) {
  //   return AddTransactionsData(
  //     id: map['id'],
  //     categoryData: CategoryData(
  //       id: map['category_id'],
  //       name: map['name'],
  //       icon: IconData(int.parse(map['category_icon']), fontFamily: 'MaterialIcons'),
  //       color: Color(map['category_color']),
  //     ),
  //     expensesPrice: map['amount'],
  //     date: DateTime.parse(map['date']),
  //   );
  // }

}
