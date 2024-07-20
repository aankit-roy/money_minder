import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:money_minder/data/database/database_helper.dart';
import 'package:money_minder/models/add_transactions_data.dart';
import 'package:money_minder/models/category_list.dart';
import 'package:money_minder/provider/transaction_provider.dart';
import 'package:money_minder/res/colors/color_palette.dart';
import 'package:money_minder/res/constants/text_size.dart';
import 'package:money_minder/ui/widgets/amount_text_field.dart';
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
                  setState(() {
                    selectedCategory = option;
                  });
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

 _addTransaction3(BuildContext context)  {
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

  //for user category options
  // void _addTransaction4(BuildContext context) {
  //   final amount = double.tryParse(amountController.text);
  //   final transactionProvider = context.read<TransactionAmountProvider>();
  //
  //   if (categoryController.text.isEmpty) {
  //     Fluttertoast.showToast(msg: "Please select a category");
  //     categoryFocusNode.requestFocus();
  //     return;
  //   }
  //
  //   // Check if the category exists in the list
  //   CategoryData? category = transactionProvider.categories.firstWhere(
  //         (cat) => cat.name.toLowerCase() == categoryController.text.toLowerCase(),
  //     orElse: () => CategoryData(
  //       name: categoryController.text,
  //       icon: Icons.category, // Default icon
  //       color: Colors.blue, // Default color
  //     ),
  //   );
  //
  //   if (amount != null && amount > 0) {
  //     final transaction = AddTransactionsData(
  //       categoryData: category,
  //       expensesPrice: amount,
  //       date: DateTime.now(),
  //     );
  //
  //     // Add the new category if it doesn't exist
  //     if (!transactionProvider.categories.contains(category)) {
  //       transactionProvider.addCategory(category);
  //     }
  //
  //     transactionProvider.addTransactonsAmount(transaction);
  //     Navigator.pop(context); // Go back to the previous screen
  //   } else {
  //     Fluttertoast.showToast(msg: "Please enter a valid amount");
  //     amountFocusNode.requestFocus();
  //   }
  // }
}

// class TransactionBottomSheet extends StatelessWidget {
//   final CategoryData categoryData;
//
//   const TransactionBottomSheet({super.key, required this.categoryData});
//
//   @override
//   Widget build(BuildContext context) {
//     TextEditingController amountController = TextEditingController();
//
//     return Padding(
//       padding: EdgeInsets.only(
//         bottom: MediaQuery.of(context).viewInsets.bottom,
//         top: 16,
//         left: 16,
//         right: 16,
//       ),
//       child: Column(
//         // mainAxisSize: MainAxisSize.min,
//         children: [
//           const Text(
//             "Expense",
//             style: TextStyle(
//               fontSize: TextSizes.mediumHeadingMin,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//           const SizedBox(height: 10),
//           AmountTextField(
//               amountController: amountController,
//               categoryDataTextField: categoryData,
//               onSubmitted: (value) {
//                 _addTransaction(context, categoryData, amountController);
//               }),
//           const SizedBox(height: 10),
//           ElevatedButton(
//             onPressed: () {
//               _addTransaction(context, categoryData, amountController);
//             },
//             child: const Text("Add Expense"),
//           ),
//         ],
//       ),
//     );
//   }
//
//   void _addTransaction(BuildContext context, CategoryData category,
//       TextEditingController amountController) {
//     final amount = double.tryParse(amountController.text);
//     if (amount != null && amount > 0) {
//       final transaction = AddTransactionsData(
//           categoryData: category, expensesPrice: amount, date: DateTime.now());
//       context
//           .read<TransactionAmountProvider>()
//           .addTransactonsAmount(transaction);
//       Navigator.pop(context); // Dismiss the bottom sheet
//     }
//   }
// }
// Expanded(
//   child: GridView.builder(
//     gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//       crossAxisCount: 4,
//       crossAxisSpacing: 14,
//       mainAxisSpacing: 14,
//     ),
//     itemCount: widget.categories.length,
//     itemBuilder: (context, index) {
//       final category = widget.categories[index];
//       final isSelected = context
//               .watch<TransactionAmountProvider>()
//               .selectedCategory ==
//           category;
//       return GestureDetector(
//         onTap: () {
//           context
//               .read<TransactionAmountProvider>()
//               .selectCategory(category);
//           showModalBottomSheet(
//             context: context,
//             shape: const RoundedRectangleBorder(
//               borderRadius:
//                   BorderRadius.vertical(top: Radius.circular(30)),
//             ),
//             builder: (context) {
//               return TransactionBottomSheet(categoryData: category);
//             },
//           );
//         },
//         child: Container(
//           decoration: BoxDecoration(
//             color: isSelected
//                 ? category.color.withOpacity(0.4)
//                 : category.color.withOpacity(0.2),
//             borderRadius: BorderRadius.circular(10),
//             border: isSelected
//                 ? Border.all(color: category.color, width: 2)
//                 : null,
//           ),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Icon(category.icon, size: 25, color: category.color),
//               const SizedBox(height: 10),
//               Text(category.name,
//                   style: TextStyle(
//                       color: category.color,
//                       fontSize: TextSizes.smallBodyTextMax,
//                       fontWeight: FontWeight.w800)),
//               if (isSelected)
//                 Icon(Icons.check, color: category.color),
//             ],
//           ),
//         ),
//       );
//     },
//   ),
// ),