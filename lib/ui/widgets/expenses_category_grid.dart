
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:money_minder/models/add_transactions_data.dart';
import 'package:money_minder/models/category_list.dart';
import 'package:money_minder/provider/transaction_provider.dart';
import 'package:money_minder/res/constants/text_size.dart';
import 'package:money_minder/ui/widgets/amount_text_field.dart';
import 'package:provider/provider.dart';

class ExpensesCategoryGrid extends StatelessWidget {
  final List<CategoryData> categories;

  const ExpensesCategoryGrid({super.key, required this.categories});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                crossAxisSpacing: 14,
                mainAxisSpacing: 14,
              ),
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final category = categories[index];
                final isSelected = context.watch<TransactionAmountProvider>().selectedCategory == category;
                return GestureDetector(
                  onTap: () {
                    context.read<TransactionAmountProvider>().selectCategory(category);
                    showModalBottomSheet(
                      context: context,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
                      ),
                      builder: (context) {
                        return TransactionBottomSheet(categoryData: category);
                      },
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: isSelected
                          ? category.color.withOpacity(0.4)
                          : category.color.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(10),
                      border: isSelected
                          ? Border.all(color: category.color, width: 2)
                          : null,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(category.icon, size: 30, color: category.color),
                        const SizedBox(height: 10),
                        Text(category.name,
                            style: TextStyle(
                                color: category.color,
                                fontSize: TextSizes.normalBodyTextMax,
                                fontWeight: FontWeight.w800)),
                        if (isSelected) Icon(Icons.check, color: category.color),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class TransactionBottomSheet extends StatelessWidget {
  final CategoryData categoryData;

  const TransactionBottomSheet({super.key, required this.categoryData});

  @override
  Widget build(BuildContext context) {
    TextEditingController amountController = TextEditingController();

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        top: 16,
        left: 16,
        right: 16,
      ),
      child: Column(
        // mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            "Expense",
            style: TextStyle(
              fontSize: TextSizes.mediumHeadingMin,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          AmountTextField(
            amountController: amountController,
            categoryDataTextField: categoryData,
            onSubmitted: (value){
              _addTransaction(context, categoryData, amountController);
            }
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: () {
              _addTransaction(context, categoryData, amountController);
            },
            child: const Text("Add Expense"),
          ),
        ],
      ),
    );
  }

  void _addTransaction(BuildContext context, CategoryData category, TextEditingController amountController) {
    final amount = double.tryParse(amountController.text);
    if (amount != null && amount > 0) {
      final transaction = AddTransactionsData(categoryData: category, expensesPrice: amount);
      context.read<TransactionAmountProvider>().addTransactonsAmount(transaction);
      Navigator.pop(context); // Dismiss the bottom sheet


    }
  }
}