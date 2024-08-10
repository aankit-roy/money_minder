import 'package:flutter/foundation.dart';
import 'package:money_minder/data/database/income_database_helper.dart';

import 'package:money_minder/models/add_transactions_data.dart';
import 'package:money_minder/models/category_list.dart';
import 'package:intl/intl.dart';
import 'package:money_minder/models/time_period.dart';
import 'package:money_minder/provider/general_provider.dart';


class IncomeTransactionProvider extends ChangeNotifier {
  CategoryData? _selectedCategory;
  List<AddTransactionsData> _incomeList = [];
  Map<CategoryData, double> _aggregatedData = {};
  TimePeriod _currentPeriod = TimePeriod.daily;
  List<CategoryData> _categories = [];

  CategoryData? get selectedCategory => _selectedCategory;
  List<AddTransactionsData> get incomeList => _incomeList;
  TimePeriod get currentPeriod => _currentPeriod;
  Map<CategoryData, double> get aggregatedData => _aggregatedData;
  final IncomeDatabaseHelper _incomeDatabaseHelper = IncomeDatabaseHelper();

  double get totalAmount =>
      _incomeList.fold(0, (sum, item) => sum + item.expensesPrice);

  void selectCategory(CategoryData categoryData) {
    _selectedCategory = categoryData;
    notifyListeners();
  }

  void setTimePeriod(TimePeriod timePeriod) {
    // GeneralProvider().setPeriod(timePeriod);
    _updateAggregatedData();
    notifyListeners();
  }

  void _updateAggregatedData() {
    _aggregatedData = getAggregatedData(_currentPeriod);
  }

  IncomeTransactionProvider() {
    _loadData();
  }

  Future<void> _loadData() async {
    _categories = await IncomeDatabaseHelper().getCategories();
    _incomeList = await _getTransactionsWithCategories();
    notifyListeners();
  }



  Future<List<CategoryData>> getIncomeCategories() async {
    return await _incomeDatabaseHelper.getCategories(); // Adjust if necessary
  }
  Future<void> addIncome(AddTransactionsData incomeData) async {
    bool categoryExists = false;

    for (var existingIncome in _incomeList) {
      String existingDate = DateFormat('d MMM EEEE').format(existingIncome.date);
      String newDate = DateFormat('d MMM EEEE').format(incomeData.date);

      if (existingIncome.categoryData.name == incomeData.categoryData.name &&
          existingDate == newDate) {
        existingIncome.expensesPrice += incomeData.expensesPrice;
        updateIncomeSameCategoryExpenses(existingIncome);
        categoryExists = true;
        break;
      }
    }

    if (!categoryExists) {
      await IncomeDatabaseHelper().insertTransaction(incomeData);
    }

    _incomeList = await _getTransactionsWithCategories();
    notifyListeners();
  }

  Future<void> removeIncome(AddTransactionsData removeIncomeData) async {
    await IncomeDatabaseHelper().deleteTransaction(removeIncomeData.id!);
    _incomeList = await _getTransactionsWithCategories();
    notifyListeners();
  }

  Future<void> updateIncomeSameCategoryExpenses(AddTransactionsData transaction) async {
    await IncomeDatabaseHelper().updateIncomesSameCategoryTransactionBySameDate(transaction);

    notifyListeners();


    // Only update the amount, do not alter category or date

  }

  List<CategoryData> get categories => _categories;

  Future<void> addCategory(CategoryData category) async {
    await IncomeDatabaseHelper().insertCategory(category.toMap());
    _categories = await IncomeDatabaseHelper().getCategories();
    notifyListeners();
  }

  Map<CategoryData, double> getAggregatedData(TimePeriod timePeriod) {
    Map<CategoryData, double> aggregatedData = {};
    List<AddTransactionsData> filteredIncomes = _filterIncomesByTimePeriod(timePeriod);

    for (var income in filteredIncomes) {
      if (aggregatedData.containsKey(income.categoryData)) {
        aggregatedData[income.categoryData] =
            aggregatedData[income.categoryData]! + income.expensesPrice;
      } else {
        aggregatedData[income.categoryData] = income.expensesPrice;
      }
    }
    print('Income Aggregated Data for************************************************ $timePeriod:');
    aggregatedData.forEach((category, amount) {
      print('*************${category.name}: $amount');
    });


    return aggregatedData;
  }

  List<AddTransactionsData> _filterIncomesByTimePeriod(TimePeriod timePeriod) {
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
      case TimePeriod.yearly:
        startDate = DateTime(now.year, 1, 1);
        endDate = DateTime(now.year + 1, 1, 1);
        break;
    }

    print("Filtering from######################################### $startDate to $endDate");
    print('Filtering for period: $timePeriod');
    // Filter transactions
    List<AddTransactionsData> filteredTransactions = _incomeList.where((transaction) {
      return transaction.date.isAfter(startDate) && transaction.date.isBefore(endDate);
    }).toList();

    // Debug prints to check filtered transactions count
    print('Filtered Income  transactions count: ${filteredTransactions.length}');
    for (var transaction in filteredTransactions) {
      print('Transaction: ${transaction.date}, ${transaction.categoryData.name}, ${transaction.expensesPrice}');
    }

    return filteredTransactions;

    // return _incomeList.where((income) {
    //   return income.date.isAfter(startDate) && income.date.isBefore(endDate);
    // }).toList();
  }

  double getTotalAmountForPeriod(TimePeriod timePeriod) {
    return _filterIncomesByTimePeriod(timePeriod)
        .fold(0.0, (sum, item) => sum + item.expensesPrice);
  }
  double getTotalIncomeOfAllTime() {
    return _incomeList.fold(0.0, (sum, item) => sum + item.expensesPrice);
  }

  Future<List<AddTransactionsData>> _getTransactionsWithCategories() async {
    final maps = await IncomeDatabaseHelper().getTransactionsWithCategory();
    // return results.map((e) => AddTransactionsData.fromMap(e)).toList();
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

  // for stat page ************************************* getting data***************************


//   Method to get data on a monthly basis for the current year
  Map<int, double> getMonthlyIncomesForCurrentYear() {
    final now = DateTime.now();
    final year = now.year;

    final monthlyData = <int, double>{};
    final transactions = _incomeList.where((transaction) {
      return transaction.date.year == year;
    }).toList();

    for (int month = 1; month <= 12; month++) {
      final monthlyTotal = transactions.where((transaction) {
        return transaction.date.month == month;
      }).fold(0.0, (sum, transaction) => sum + transaction.expensesPrice);

      monthlyData[month] = monthlyTotal;
    }

    return monthlyData;
  }
  double getTotalIncomesForPast10Years() {
    final yearlyData = getYearlyIncomesForPast10Years();
    return yearlyData.values.fold(0.0, (sum, value) => sum + value);
  }

  // Method to get data on a yearly basis for the past 10 years
  Map<int, double> getYearlyIncomesForPast10Years() {
    final now = DateTime.now();
    final currentYear = now.year;
    final startYear = currentYear - 3;
    final endYear = currentYear + 3;

    final yearlyData = <int, double>{};
    final transactions = incomeList.where((transaction) {
      return transaction.date.year >= startYear && transaction.date.year <= endYear;
    }).toList();

    for (int year = startYear; year <= endYear; year++) {
      final yearlyTotal = transactions.where((transaction) {
        return transaction.date.year == year;
      }).fold(0.0, (sum, transaction) => sum + transaction.expensesPrice);

      yearlyData[year] = yearlyTotal;
    }

    return yearlyData;
  }
  double getTotalIncomesForCurrentYear() {
    final monthlyData = getMonthlyIncomesForCurrentYear();
    return monthlyData.values.fold(0.0, (sum, value) => sum + value);
  }
  void printMonthlyExpenses() async {
    print('Monthly Data for the Current Year:');
    final monthlyData = getMonthlyIncomesForCurrentYear();

    final monthNames = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];

    monthlyData.forEach((month, total) {
      final monthName = monthNames[month - 1]; // Adjust for zero-based index
      print('&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&$monthName: \$${total.toStringAsFixed(2)}');
    });
  }
  void printYearlyMonthExpenses() async {

    // Print Yearly Data for the Past 10 Years
    print('Yearly Data for the Past 10 Years:');
    final yearlyData = getYearlyIncomesForPast10Years();

    yearlyData.forEach((year, total) {
      print('&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&$year: \$${total.toStringAsFixed(2)}');
    });
  }







}



