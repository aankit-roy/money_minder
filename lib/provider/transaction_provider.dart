
import 'package:flutter/foundation.dart';
import 'package:money_minder/models/add_transactions_data.dart';
import 'package:money_minder/models/category_list.dart';

class TransactionAmountProvider extends ChangeNotifier{
  CategoryData? _selectedCategory;
  final List<AddTransactionsData> _transactionList= [];
  CategoryData? get selectedCategory => _selectedCategory;


  List<AddTransactionsData> get transactionList => _transactionList;

  double get totalAmount =>
      _transactionList.fold(0, (sum, item) => sum + item.expensesPrice);

  void selectCategory(CategoryData categoryData){
    _selectedCategory=categoryData;
    notifyListeners();
  }

  void addTransactonsAmount(AddTransactionsData transactionsData){
    bool categoryExists = false;
    for (var existingTransaction in _transactionList) {
      if (existingTransaction.categoryData.name == transactionsData.categoryData.name) {
        existingTransaction.expensesPrice += transactionsData.expensesPrice;
        categoryExists = true;
        break;
      }
    }

    if (!categoryExists) {
      _transactionList.add(transactionsData);
    }

    notifyListeners();
  }

  void removeTransactonsAmount(int index){

    _transactionList.removeAt(index);
    notifyListeners();
  }
  void updateTransactonsAmount(int index, double newAmount){

    _transactionList[index].expensesPrice= newAmount;
    notifyListeners();


  }
}