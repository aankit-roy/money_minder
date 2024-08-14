import 'package:flutter/material.dart';
import 'package:money_minder/data/database/database_helper.dart';
import 'package:money_minder/data/database/income_database_helper.dart';
import 'package:money_minder/models/add_transactions_data.dart';
import 'package:money_minder/models/category_list.dart';
import 'package:money_minder/models/pie_chart_data.dart';
import 'package:money_minder/provider/general_provider.dart';
import 'package:money_minder/res/colors/color_palette.dart';
import 'package:money_minder/ui/widgets/custome_period_button.dart';
import 'package:money_minder/ui/widgets/expenses_category_grid.dart';
import 'package:money_minder/ui/widgets/incomes_category_grid.dart';

import 'package:provider/provider.dart';

class AddingData extends StatefulWidget {

 final AddTransactionsData? transactions;

  const AddingData({super.key, this.transactions});


  @override
  State<AddingData> createState() => _AddingDataState();
}

class _AddingDataState extends State<AddingData> {


  List<CategoryData> categories = [];
  List<CategoryData> incomeCategories = [];

  late bool _isExpensesSelected;

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    final generalProvider = context.read<GeneralProvider>();
    if (generalProvider.isExpensesSelected) {
      DatabaseHelper dbHelper = DatabaseHelper();
      List<CategoryData> loadedCategories = await dbHelper.getCategories2();
      setState(() {
        categories = loadedCategories;
      });
    } else {

      IncomeDatabaseHelper ibHelper =  IncomeDatabaseHelper();
      List<CategoryData> loadedIncomeCategories = await ibHelper.getCategories();

      setState(() {
        incomeCategories = loadedIncomeCategories;
      });
    }
  }



  //
  // @override
  // void dispose() {
  //   titleController.dispose();
  //   valueController.dispose();
  //   super.dispose();
  // }

  @override

  Widget build(BuildContext context) {
    final  generalProvider= context.watch<GeneralProvider>();
    Size size = MediaQuery.sizeOf(context);
    _isExpensesSelected= generalProvider.isExpensesSelected;
    return Column(
      children: [

        Container(
          height:  size.height*.1,
          decoration: const BoxDecoration(
            color: ColorsPalette.primaryColor,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomPeriodButton(
                isSelected: _isExpensesSelected,
                label: 'Expenses',
                onPressed: () {
                  if(!generalProvider.isExpensesSelected){
                    generalProvider.toggleSelection();
                  }
                  _loadCategories();
                },
              ),
              SizedBox(width: size.width * 0.1),
              CustomPeriodButton(
                isSelected: !_isExpensesSelected,
                label: 'Income',
                onPressed: () {
                  if(generalProvider.isExpensesSelected){
                    generalProvider.toggleSelection();
                  }

                  _loadCategories();

                },
              ),
            ],
          ),
        ),


        Expanded(
          child: _isExpensesSelected
              ? ExpensesCategoryGrid(categories: categories,transactionData:widget.transactions ,)
              :  IncomeCategoryGrid(categories: incomeCategories,transactionData: widget.transactions,)
        ),
      ],
    );
  }



}




