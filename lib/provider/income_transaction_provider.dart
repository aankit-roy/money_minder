import 'package:flutter/foundation.dart';
import 'package:money_minder/data/database/income_database_helper.dart';

import 'package:money_minder/models/add_transactions_data.dart';
import 'package:money_minder/models/category_list.dart';
import 'package:intl/intl.dart';
import 'package:money_minder/models/time_period.dart';

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
    _currentPeriod = timePeriod;
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
        updateIncomeSameCategoryByDate(existingIncome);
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

  Future<void> updateIncomeSameCategoryByDate(AddTransactionsData income) async {
    await IncomeDatabaseHelper().updateTransaction(income);
    notifyListeners();
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

    return _incomeList.where((income) {
      return income.date.isAfter(startDate) && income.date.isBefore(endDate);
    }).toList();
  }

  double getTotalAmountForPeriod(TimePeriod timePeriod) {
    return _filterIncomesByTimePeriod(timePeriod)
        .fold(0.0, (sum, item) => sum + item.expensesPrice);
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
}