import 'package:flutter/material.dart';
import 'package:money_minder/data/database/database_helper.dart';
import 'package:money_minder/data/database/income_database_helper.dart';
import 'package:money_minder/models/add_transactions_data.dart';
import 'package:money_minder/models/category_list.dart';
import 'package:money_minder/models/pie_chart_data.dart';
import 'package:money_minder/provider/general_provider.dart';
import 'package:money_minder/provider/income_transaction_provider.dart';
import 'package:money_minder/res/colors/color_palette.dart';
import 'package:money_minder/ui/widgets/custome_period_button.dart';
import 'package:money_minder/ui/widgets/expenses_category_grid.dart';
import 'package:money_minder/ui/widgets/incomes_category_grid.dart';
import 'package:provider/provider.dart';

class AddingData extends StatefulWidget {
  const AddingData({super.key});

  @override
  State<AddingData> createState() => _AddingDataState();
}

class _AddingDataState extends State<AddingData> {
  final List<AddingPieChartData> pieChartData = [];
  final TextEditingController titleController = TextEditingController();
  final TextEditingController valueController = TextEditingController();
  Color selectedColor = ColorsPalette.secondaryColor;
  CategoryData? selectedCategory;
  List<AddTransactionsData> transactions = [];
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
      // Fetch income categories
      // final incomeProvider = context.read<IncomeTransactionProvider>();
      // List<CategoryData> loadedIncomeCategories = await incomeProvider
      //     .getIncomeCategories();
      IncomeDatabaseHelper ibHelper =  IncomeDatabaseHelper();
      List<CategoryData> loadedIncomeCategories = await ibHelper.getCategories();

      setState(() {
        incomeCategories = loadedIncomeCategories;
      });
    }
  }


  // Future<void> _loadCategories() async {
  //   DatabaseHelper dbHelper = DatabaseHelper();
  //   IncomeDatabaseHelper ibHelper= IncomeDatabaseHelper();
  //   List<CategoryData> loadedCategories = await dbHelper.getCategories2();
  //   // List<CategoryData> loadedIncomeCategories = await ibHelper.getCategories();
  //
  //   setState(() {
  //     categories = loadedCategories;
  //
  //   });
  // }

  @override
  void dispose() {
    titleController.dispose();
    valueController.dispose();
    super.dispose();
  }

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
                  generalProvider.toggleSelection();
                  _loadCategories();
                },
              ),
              SizedBox(width: size.width * 0.1),
              CustomPeriodButton(
                isSelected: !_isExpensesSelected,
                label: 'Income',
                onPressed: () {
                  generalProvider.toggleSelection();
                  _loadCategories();

                },
              ),
            ],
          ),
        ),

        // Container(
        //   height: 100,
        //   decoration: const BoxDecoration(
        //     color: ColorsPalette.primaryColor,
        //     borderRadius: BorderRadius.only(
        //       topLeft: Radius.circular(20),
        //       topRight: Radius.circular(20),
        //     ),
        //   ),
        //   child: Row(
        //     mainAxisAlignment: MainAxisAlignment.spaceAround,
        //     children: [
        //       ElevatedButton(
        //         onPressed: () {
        //           setState(() {
        //             _isExpensesSelected = true;
        //           });
        //         },
        //         style: ElevatedButton.styleFrom(
        //           backgroundColor: _isExpensesSelected ? ColorsPalette.primaryColor : Colors.grey,
        //           shape: RoundedRectangleBorder(
        //             borderRadius: BorderRadius.circular(20),
        //           ),
        //         ),
        //         child: Text(
        //           'Expenses',
        //           style: TextStyle(
        //             color: _isExpensesSelected ? ColorsPalette.textPrimary : Colors.white,
        //           ),
        //         ),
        //       ),
        //       ElevatedButton(
        //         onPressed: () {
        //           setState(() {
        //             _isExpensesSelected = false;
        //           });
        //         },
        //         style: ElevatedButton.styleFrom(
        //           backgroundColor: !_isExpensesSelected ? ColorsPalette.primaryColor : Colors.grey,
        //           shape: RoundedRectangleBorder(
        //             borderRadius: BorderRadius.circular(20),
        //           ),
        //         ),
        //         child: Text(
        //           'Income',
        //           style: TextStyle(
        //             color: !_isExpensesSelected ? ColorsPalette.textPrimary : Colors.white,
        //           ),
        //         ),
        //       ),
        //     ],
        //   ),
        // ),
        Expanded(
          child: _isExpensesSelected
              ? ExpensesCategoryGrid(categories: categories)
              :  IncomeCategoryGrid(categories: incomeCategories)
        ),
      ],
    );
  }



}




