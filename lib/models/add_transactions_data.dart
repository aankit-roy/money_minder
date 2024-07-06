import 'package:money_minder/models/category_list.dart';

class AddTransactionsData {
  final CategoryData categoryData;
  double expensesPrice;
  final DateTime date;

  AddTransactionsData(
      {required this.categoryData,
      required this.expensesPrice,
      required this.date});
}
