
import 'package:flutter/cupertino.dart';
import 'package:money_minder/models/time_period.dart';

class GeneralProvider with ChangeNotifier{
  bool _isExpensesSelected = true;
  // static final GeneralProvider _instance = GeneralProvider._internal();

  TimePeriod _selectedPeriod = TimePeriod.daily;

  bool get isExpensesSelected => _isExpensesSelected;
  TimePeriod get selectedPeriod => _selectedPeriod;
  // factory GeneralProvider() {
  //   return _instance;
  // }
  // GeneralProvider._internal();


   set SelectedPeriod(TimePeriod  period){
    _selectedPeriod=period;
    notifyListeners();
  }
  // void setPeriod(TimePeriod period) {
  //   _selectedPeriod = period;
  //   notifyListeners();
  // }
  void toggleSelection( ){
    _isExpensesSelected=!_isExpensesSelected;
    notifyListeners();
  }
}