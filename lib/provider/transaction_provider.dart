import 'package:flutter/foundation.dart';
import 'package:money_minder/data/database/database_helper.dart';
import 'package:money_minder/models/add_transactions_data.dart';
import 'package:money_minder/models/category_list.dart';
import 'package:intl/intl.dart';
import 'package:money_minder/models/time_period.dart';

class TransactionAmountProvider extends ChangeNotifier {
  CategoryData? _selectedCategory;
  List<AddTransactionsData> _transactionList = [];
  List<CategoryData> _categories = [];
  CategoryData? get selectedCategory => _selectedCategory;

  List<AddTransactionsData> get transactionList => _transactionList;

  double get totalAmount =>
      _transactionList.fold(0, (sum, item) => sum + item.expensesPrice);

  void selectCategory(CategoryData categoryData) {
    _selectedCategory = categoryData;
    notifyListeners();
  }

  // database  related working
  TransactionAmountProvider() {
    _loadData();
  }

  Future<void> _loadData() async {
    // _categories = await DatabaseHelper().getCategories();

    // _transactionList = await DatabaseHelper().getTransactions();
    _categories = await DatabaseHelper().getCategories2();
    _transactionList = await _getTransactionsWithCategories();
    // _transactionList = await DatabaseHelper().getTransactions2();
    notifyListeners();
  }

  Future<void> addTransactonsAmount(
      AddTransactionsData transactionsData) async {
    bool categoryExists = false;

    for (var existingTransaction in _transactionList) {
      String existingDate =
          DateFormat('d MMM EEEE').format(existingTransaction.date);
      String newDate = DateFormat('d MMM EEEE').format(transactionsData.date);

      // print('Comparing dates: $existingDate with $newDate');//testing purpose
      // print('Comparing categories: ${existingTransaction.categoryData.name} with ${transactionsData.categoryData.name}');

      if (existingTransaction.categoryData.name ==
              transactionsData.categoryData.name &&
          existingDate == newDate) {
        existingTransaction.expensesPrice += transactionsData.expensesPrice;
        categoryExists = true;
        break;
      }
    }

    if (!categoryExists) {
      // print('Adding new transaction: ${transactionsData.categoryData.name} on ${DateFormat('d MMM EEEE').format(transactionsData.date)}');
      // _transactionList.add(transactionsData);
      await DatabaseHelper().insertTransaction2(transactionsData);
      _transactionList = await _getTransactionsWithCategories();
      // _transactionList = await DatabaseHelper().getTransactions2();
    }

    notifyListeners();
  }

  void removeTransactonsAmount(AddTransactionsData removeTransactionsData) {
    _transactionList.remove(removeTransactionsData);
    notifyListeners();
  }

  void updateTransaction(
      AddTransactionsData oldTransaction, AddTransactionsData newTransaction) {
    final index = _transactionList.indexOf(oldTransaction);
    if (index != -1) {
      _transactionList[index] = newTransaction;
      notifyListeners();
    }
  }

  //adding user category
  List<CategoryData> get categories => _categories;

  Future<void> addCategory(CategoryData category) async {
    await DatabaseHelper().insertCategory2(category.toMap());
    _categories = await DatabaseHelper().getCategories2();
    notifyListeners();
  }


  // grouped expenses by date;

  Map<String, List<AddTransactionsData>> get transactionsDataByDate {
    Map<String, List<AddTransactionsData>> groupedTransactionsByDate = {};
    for (var transaction in transactionList) {
      String date = DateFormat('d MMM EEEE').format(transaction.date);
      if (groupedTransactionsByDate[date] == null) {
        groupedTransactionsByDate[date] = [];
      }
      groupedTransactionsByDate[date]!.add(transaction);
    }
    return groupedTransactionsByDate;
  }

  // expenses by time period for pi chart;
  Map<CategoryData, double> getAggregatedData(TimePeriod timePeriod) {
    Map<CategoryData, double> aggregatedData = {};

    for (var transaction in _transactionList) {
      DateTime transactionDate = transaction.date;
      String key = " ";

      switch (timePeriod) {
        case TimePeriod.daily:
          key = DateFormat('d MMM yyyy').format(transactionDate);
          break;
        case TimePeriod.weekly:
          final weekStart =
              transactionDate.subtract(Duration(days: transactionDate.weekday));
          key = DateFormat('d MMM yyyy').format(weekStart);
          break;
        case TimePeriod.monthly:
          key = DateFormat('MMM yyyy').format(transactionDate);
          break;
      }

      if (aggregatedData[transaction.categoryData] == null) {
        aggregatedData[transaction.categoryData] = 0.0;
      }
      aggregatedData[transaction.categoryData] =
          (aggregatedData[transaction.categoryData] ?? 0.0) +
              transaction.expensesPrice;
    }

    return aggregatedData;
  }

  Future<List<AddTransactionsData>> _getTransactionsWithCategories() async {
    final maps = await DatabaseHelper().getTransactionsWithCategory();
    return maps.map((map) {
      final category = CategoryData.fromMap({
        'id': map['id'],
        'name': map['name'],
        'icon': map['icon'],
        'color': map['color'],
      });
      return AddTransactionsData(
        id: map['id'],
        categoryData: category,
        expensesPrice: map['amount'],
        date: DateTime.parse(map['date']),
      );
    }).toList();
  }
}
