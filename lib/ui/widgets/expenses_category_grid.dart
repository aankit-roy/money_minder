import 'dart:async';
import 'package:flutter/material.dart';
import 'package:money_minder/data/database/database_helper.dart';
import 'package:money_minder/models/add_transactions_data.dart';
import 'package:money_minder/models/category_list.dart';
import 'package:money_minder/provider/transaction_provider.dart';
import 'package:money_minder/res/colors/color_palette.dart';
import 'package:provider/provider.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ExpensesCategoryGrid extends StatefulWidget {
  final List<CategoryData> categories;

  const ExpensesCategoryGrid({super.key, required this.categories});

  @override
  State<ExpensesCategoryGrid> createState() => _ExpensesCategoryGridState();
}

class _ExpensesCategoryGridState extends State<ExpensesCategoryGrid> {
  TextEditingController amountController = TextEditingController();

  final TextEditingController categoryController = TextEditingController();

  CategoryData? selectedCategory;
  final FocusNode categoryFocusNode = FocusNode();
  final FocusNode amountFocusNode = FocusNode();

  @override
  void dispose() {
    categoryController.dispose();
    amountController.dispose();
    categoryFocusNode.dispose();
    amountFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            height: size.height * .3,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12), color: Colors.white),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Autocomplete<CategoryData>(
                  optionsBuilder: optionBuilder,
                  displayStringForOption: (CategoryData option) => option.name,
                  fieldViewBuilder: fieldViewBuilder,
                  optionsViewBuilder: optionsViewBuilder,
                  onSelected: (CategoryData selection) {
                    setState(() {
                      selectedCategory = selection;
                      categoryController.text = selection.name;
                    });
                    FocusScope.of(context).requestFocus(amountFocusNode);
                  },
                ),
                amountTextField(context),
                const SizedBox(height: 16),
                cancelAndAddButton(context),
              ],
            ),
          ),
          const SizedBox(
            height: 12,
          ),
        ],
      ),
    );
  }

  Row cancelAndAddButton(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text("Cancel")),
        ElevatedButton(
          onPressed: () {
            _addTransaction3(context);
          },
          child: const Text('Add Expense'),
        ),
      ],
    );
  }

  Widget fieldViewBuilder(
      BuildContext context,
      TextEditingController textEditingController,
      FocusNode focusNode,
      VoidCallback onFieldSubmitted) {
    return Padding(
      padding: const EdgeInsets.all(14.0),
      child: CategoryTextField(textEditingController, focusNode, context),
    );
  }

  FutureOr<Iterable<CategoryData>> optionBuilder(
      TextEditingValue textEditingValue) {
    return widget.categories.where((CategoryData option) {
      return option.name
          .toLowerCase()
          .contains(textEditingValue.text.toLowerCase());
    }).toList();
  }

  Widget optionsViewBuilder(
      BuildContext context,
      AutocompleteOnSelected<CategoryData> onSelected,
      Iterable<CategoryData> options) {
    return Align(
      alignment: Alignment.topLeft,
      child: Material(
        elevation: 4.0,
        child: SizedBox(
          width: 300,
          child: ListView.builder(
            padding: const EdgeInsets.all(4.0),
            itemCount: options.length,
            itemBuilder: (BuildContext context, int index) {
              final CategoryData option = options.elementAt(index);
              return GestureDetector(
                onTap: () {
                  onSelected(option);
                  // setState(() {
                  //   selectedCategory = option;
                  // });
                  FocusScope.of(context).requestFocus(amountFocusNode);
                  categoryController.text = option.name;
                },
                child: ListTile(
                  leading: Icon(option.icon, color: option.color),
                  title: Text(option.name),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  TextField CategoryTextField(TextEditingController textEditingController,
      FocusNode focusNode, BuildContext context) {
    return TextField(
      controller: textEditingController,
      autofocus: true,
      focusNode: focusNode,
      keyboardType: TextInputType.text,
      // onSubmitted: onSubmitted ,

      decoration: InputDecoration(
        label: const Text("Category"),
        prefixIcon: selectedCategory != null
            ? Icon(selectedCategory!.icon, color: selectedCategory!.color)
            : null,
        hintText: "Category",
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
      onSubmitted: (value) {
        if (selectedCategory != null) {
          FocusScope.of(context).requestFocus(amountFocusNode);
        } else {
          Fluttertoast.showToast(msg: "Please select a category");
          categoryFocusNode.requestFocus();
        }
      },
    );
  }

  Padding amountTextField(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(14.0),
      child: TextField(
        controller: amountController,
        focusNode: amountFocusNode,
        // autofocus: true,
        keyboardType: TextInputType.number,
        // onSubmitted: onSubmitted ,
        textInputAction: TextInputAction.done,
        onSubmitted: (value) {
          _addTransaction3(context);
        },

        decoration: InputDecoration(
          label: const Text("  Expense"),
          prefixIcon: const Icon(
            Icons.currency_rupee_outlined,
            color: ColorsPalette.primaryColor,
          ),
          hintText: "100 e.g",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }

  _addTransaction3(BuildContext context) async {
    final amount = double.tryParse(amountController.text);
    if (selectedCategory == null) {
      Fluttertoast.showToast(msg: "Please select your category");
      categoryFocusNode.requestFocus();
      return;
    }
    if (amount != null && amount > 0 && selectedCategory != null) {
      final transaction = AddTransactionsData(
          categoryData: selectedCategory!,
          expensesPrice: amount,
          date: DateTime.now());

      // Insert transaction into the database
      // DatabaseHelper dbHelper = DatabaseHelper();
      //  dbHelper.insertTransaction2(transaction);



      context
          .read<TransactionAmountProvider>()
          .addTransactonsAmount(transaction);
      Navigator.pop(context); // Go back to the previous screen
    } else {
      Fluttertoast.showToast(msg: "Please enter a valid amount");
      amountFocusNode.requestFocus();
    }
  }

  Future<bool> _updateExistingTransaction(
      AddTransactionsData newTransaction) async {
    // Assuming DatabaseHelper has a method to get transactions by category and date
    DatabaseHelper dbHelper = DatabaseHelper();
    final existingTransactions =
        await dbHelper.getTransactionsByCategoryAndDate(
      newTransaction.categoryData.name,
      newTransaction.date,
    );

    if (existingTransactions.isNotEmpty) {
      // Update the existing entry with the new amount
      final existingTransaction = existingTransactions.first;
      existingTransaction.expensesPrice += newTransaction.expensesPrice;
      await dbHelper.updateTransaction(
          existingTransaction); // Assuming DatabaseHelper has an update method
      // context
      //     .read<TransactionAmountProvider>()
      //     .updateTransaction(existingTransaction); // Update provider data
      return true;
    }

    return false;
  }
}
