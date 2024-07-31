import 'package:flutter/foundation.dart';

class StatsPeriodsProvider with ChangeNotifier{


  String _selectedPeriod = 'Monthly';
  String _selectedMonth = '';
  String _selectedYear = '';

  String get selectedPeriod => _selectedPeriod;
  String get selectedMonth => _selectedMonth;
  String get selectedYear => _selectedYear;

  void updateSelection(String period, String month, String year) {
    _selectedPeriod = period;
    _selectedMonth = month;
    _selectedYear = year;
    notifyListeners();
  }
}