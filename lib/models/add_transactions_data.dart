
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

  // Map<String, dynamic> toMap() {
  //   return {
  //     'id': id,
  //     'category_id': categoryData.id,
  //     'amount': expensesPrice,
  //     'date': date.toIso8601String(),
  //   };
  // }
  //
  // factory AddTransactionsData.fromMap(Map<String, dynamic> map) {
  //   return AddTransactionsData(
  //     id: map['id'],
  //     categoryData: map['category_id'],
  //     expensesPrice: map['amount'],
  //     date: DateTime.parse(map['date']),
  //   );
  // }



  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'category_id': categoryData.id, // Only include relevant fields
      'amount': expensesPrice,
      'date': date.toIso8601String(),
    };
  }

  factory AddTransactionsData.fromMap(Map<String, dynamic> map) {
    // Assuming you have the category data somewhere
    // Replace with actual fetching logic if needed
    return AddTransactionsData(
      id: map['id'],
      categoryData: CategoryData(
        id: map['category_id'], // Replace with how you fetch or set category
        name: map['name'], // Make sure these fields are available
        icon: map['icon'], // Adjust these to match actual fields
        color: map['color'],
      ),
      expensesPrice: map['amount'],
      date: DateTime.parse(map['date']),
    );
  }

}
