import 'package:flutter/foundation.dart';
import 'package:money_minder/data/database/database_helper.dart';
import 'package:money_minder/models/add_transactions_data.dart';
import 'package:money_minder/models/category_list.dart';
import 'package:intl/intl.dart';
import 'package:money_minder/models/time_period.dart';

class TransactionAmountProvider extends ChangeNotifier {
  CategoryData? _selectedCategory;
  List<AddTransactionsData> _transactionList = [];
  Map<CategoryData, double> _aggregatedData = {};
  TimePeriod _currentPeriod = TimePeriod.daily;
  List<CategoryData> _categories = [];

  CategoryData? get selectedCategory => _selectedCategory;

  List<AddTransactionsData> get transactionList => _transactionList;

  TimePeriod get currentPeriod => _currentPeriod;
  Map<CategoryData, double> get aggregatedData => _aggregatedData;

  double get totalAmount =>
      _transactionList.fold(0, (sum, item) => sum + item.expensesPrice);

  void selectCategory(CategoryData categoryData) {
    _selectedCategory = categoryData;
    notifyListeners();
  }

  void setTimePeriod(TimePeriod timePeriod) {
    _currentPeriod = timePeriod;
    _updateAggregatedData();
    notifyListeners();
  }

  void _updateAggregatedData() {
    _aggregatedData = getAggregatedData(_currentPeriod);
  }

  // database  related working
  TransactionAmountProvider() {
    _loadData();
  }

  Future<void> _loadData() async {
    _categories = await DatabaseHelper().getCategories2();
    _transactionList = await _getTransactionsWithCategories();
    notifyListeners();
  }

  Future<void> addTransactonsAmount(
      AddTransactionsData transactionsData) async {
    bool categoryExists = false;

    for (var existingTransaction in _transactionList) {
      String existingDate =
          DateFormat('d MMM EEEE').format(existingTransaction.date);
      String newDate = DateFormat('d MMM EEEE').format(transactionsData.date);

      if (existingTransaction.categoryData.name ==
              transactionsData.categoryData.name &&
          existingDate == newDate) {
        existingTransaction.expensesPrice += transactionsData.expensesPrice;
        updateExpensesSameCategoryExpenses(existingTransaction);
        categoryExists = true;
        break;
      }
    }

    if (!categoryExists) {

      await DatabaseHelper().insertTransaction2(transactionsData);

    }

    _transactionList = await _getTransactionsWithCategories();
    // _transactionList = await DatabaseHelper().getTransactions2();
    notifyListeners();
  }

  Future<void> removeTransactonsAmount(
      AddTransactionsData removeTransactionsData) async {
    await DatabaseHelper().deleteTransaction(removeTransactionsData.id!);
    _transactionList = await _getTransactionsWithCategories();
    notifyListeners();

  }
  Future<void> updateExpensesSameCategoryExpenses(AddTransactionsData transaction) async {
     await DatabaseHelper().updateExpensesSameCategoryTransactionBySameDate(transaction);

     notifyListeners();


    // Only update the amount, do not alter category or date

  }


  List<CategoryData> get categories => _categories;

  Future<void> addCategory(CategoryData category) async {
    await DatabaseHelper().insertCategory2(category.toMap());
    _categories = await DatabaseHelper().getCategories2();
    notifyListeners();
  }



  Future<void> fetchTransactionsSortedByDate() async {
    DatabaseHelper dbHelper = DatabaseHelper();
    _transactionList = await dbHelper.getAllTransactionsSortedByDate();
    _updateAggregatedData();
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

    // Filter transactions based on the selected time period
    List<AddTransactionsData> filteredTransactions =
        _filterTransactionsByTimePeriod(timePeriod);

    for (var transaction in filteredTransactions) {
      if (aggregatedData.containsKey(transaction.categoryData)) {
        aggregatedData[transaction.categoryData] =
            aggregatedData[transaction.categoryData]! +
                transaction.expensesPrice;

      } else {
        aggregatedData[transaction.categoryData] = transaction.expensesPrice;
      }
    }

    // Debug: Print aggregated data
    print('Aggregated Data for************************************************ $timePeriod:');
    aggregatedData.forEach((category, amount) {
      print('*************${category.name}: $amount');
    });

    return aggregatedData;
  }

  List<AddTransactionsData> _filterTransactionsByTimePeriod(
      TimePeriod timePeriod) {
    DateTime now = DateTime.now();
    DateTime startDate;
    DateTime endDate;

    switch (timePeriod) {
      case TimePeriod.daily:
        startDate = DateTime(now.year, now.month, now.day);
        endDate = startDate.add(const Duration(days: 1));
        break;
      case TimePeriod.weekly:
        startDate = now.subtract(Duration(days: now.weekday - 1));
        endDate = startDate.add(const Duration(days: 7));
        break;
      case TimePeriod.monthly:
        startDate = DateTime(now.year, now.month, 1);
        endDate = DateTime(now.year, now.month + 1, 1);
        break;
    }
    print("Filtering from######################################### $startDate to $endDate");
    print('Filtering for period: $timePeriod');
    // Filter transactions
    List<AddTransactionsData> filteredTransactions = _transactionList.where((transaction) {
      return transaction.date.isAfter(startDate) && transaction.date.isBefore(endDate);
    }).toList();

    // Debug prints to check filtered transactions count
    print('Filtered transactions count: ${filteredTransactions.length}');
    filteredTransactions.forEach((transaction) {
      print('Transaction: ${transaction.date}, ${transaction.categoryData.name}, ${transaction.expensesPrice}');
    });

    return filteredTransactions;


  }





  double getTotalAmountForPeriod(TimePeriod timePeriod) {
    return _filterTransactionsByTimePeriod(timePeriod)
        .fold(0.0, (sum, item) => sum + item.expensesPrice);
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

  // Filter transactions based on the selected time period



  // Example method to fetch daily transactions and aggregate them by category
  Map<CategoryData, double> getAggregatedTransactionsByCategory(DateTime date) {
    final filteredTransactions = _transactionList.where((transaction) {
      return transaction.date.year == date.year &&
          transaction.date.month == date.month &&
          transaction.date.day == date.day;
    });

    final Map<CategoryData, double> aggregatedData = {};

    for (var transaction in filteredTransactions) {
      if (aggregatedData.containsKey(transaction.categoryData)) {
        aggregatedData[transaction.categoryData] =
            aggregatedData[transaction.categoryData]! +
                transaction.expensesPrice;
      } else {
        aggregatedData[transaction.categoryData] = transaction.expensesPrice;
      }
    }

    return aggregatedData;
  }
}
