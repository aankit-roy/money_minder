
import 'package:flutter/cupertino.dart';
import 'package:money_minder/models/time_period.dart';

class GeneralProvider with ChangeNotifier{
  bool _isExpensesSelected = true;
  bool _isLoading = false;
  // static final GeneralProvider _instance = GeneralProvider._internal();

  TimePeriod _selectedPeriod = TimePeriod.daily;

  bool get isExpensesSelected => _isExpensesSelected;
  bool get isLoading => _isLoading;
  TimePeriod get selectedPeriod => _selectedPeriod;


   set SelectedPeriod(TimePeriod  period){
    _selectedPeriod=period;
    notifyListeners();
  }

  void setLoading(bool loading){
     _isLoading= loading;
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