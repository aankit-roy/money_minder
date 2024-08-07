
import 'package:flutter/cupertino.dart';

class GeneralProvider with ChangeNotifier{
  bool _isExpensesSelected = true;

  bool get isExpensesSelected => _isExpensesSelected;

  void toggleSelection( ){
    _isExpensesSelected=!_isExpensesSelected;
    notifyListeners();
  }
}