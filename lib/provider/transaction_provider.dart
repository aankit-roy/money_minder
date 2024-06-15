
import 'package:flutter/foundation.dart';
import 'package:money_minder/models/add_transactions_data.dart';
import 'package:money_minder/models/category_list.dart';

class TransactionAmountProvider extends ChangeNotifier{
  CategoryData? _selectedCategory;
  List<AddTransactionsData> _transactionList= [];
  CategoryData? get selectedCategory => _selectedCategory;


  List<AddTransactionsData> get transactionList => _transactionList;
  void selectCategory(CategoryData categoryData){
    _selectedCategory=categoryData;
    notifyListeners();
  }

  void addTransactonsAmount(AddTransactionsData transactionsData){
    _transactionList.add(transactionsData);
    notifyListeners();
  }
  void removeTransactonsAmount(AddTransactionsData transactionsData){
    _transactionList.remove(transactionsData);
    notifyListeners();
  }
  void updateTransactonsAmount(AddTransactionsData transactionsData){

  }
}