import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:money_minder/models/add_transactions_data.dart';
import 'package:money_minder/models/category_list.dart';
import 'package:money_minder/models/pie_chart_data.dart';
import 'package:money_minder/res/colors/color_palette.dart';
import 'package:money_minder/ui/widgets/custome_Tran_add_app_bar.dart';
import 'package:money_minder/ui/widgets/expenses_category_grid.dart';

class AddingData extends StatefulWidget {
  const AddingData({super.key});

  @override
  State<AddingData> createState() => _AddingDataState();
}

class _AddingDataState extends State<AddingData> {
  final List<AddingPieChartData> pieChartData = [];
  final TextEditingController titleController = TextEditingController();
  final TextEditingController valueController = TextEditingController();
  late final TextEditingController tabController;
  Color selectedColor = ColorsPalette.secondaryColor;
  CategoryData? selectedCategory;
  List<AddTransactionsData> transactions = [];
  List<CategoryData> categories = [
    CategoryData(name: 'Food', icon: Icons.fastfood, color: Colors.orange),
    CategoryData(
        name: 'Transport', icon: Icons.directions_car, color: Colors.blue),
    CategoryData(
        name: 'Shopping', icon: Icons.shopping_cart, color: Colors.pink),
    CategoryData(name: 'Food', icon: Icons.fastfood, color: Colors.orange),
    CategoryData(
        name: 'Transport', icon: Icons.directions_car, color: Colors.blue),
    CategoryData(
        name: 'Shopping', icon: Icons.shopping_cart, color: Colors.pink),
    CategoryData(name: 'Food', icon: Icons.fastfood, color: Colors.orange),
    CategoryData(
        name: 'Transport', icon: Icons.directions_car, color: Colors.blue),
    CategoryData(
        name: 'Shopping', icon: Icons.shopping_cart, color: Colors.pink),
    CategoryData(name: 'Food', icon: Icons.fastfood, color: Colors.orange),
    CategoryData(
        name: 'Transport', icon: Icons.directions_car, color: Colors.blue),
    CategoryData(
        name: 'Shopping', icon: Icons.shopping_cart, color: Colors.pink),
    CategoryData(name: 'Food', icon: Icons.fastfood, color: Colors.orange),
    CategoryData(
        name: 'Transport', icon: Icons.directions_car, color: Colors.blue),
    CategoryData(
        name: 'Shopping', icon: Icons.shopping_cart, color: Colors.pink),
    CategoryData(name: 'Food', icon: Icons.fastfood, color: Colors.orange),
    CategoryData(
        name: 'Transport', icon: Icons.directions_car, color: Colors.blue),
    CategoryData(
        name: 'Shopping', icon: Icons.shopping_cart, color: Colors.pink),
    CategoryData(name: 'Food', icon: Icons.fastfood, color: Colors.orange),
    CategoryData(
        name: 'Transport', icon: Icons.directions_car, color: Colors.blue),
    CategoryData(
        name: 'Shopping', icon: Icons.shopping_cart, color: Colors.pink),
    CategoryData(name: 'Food', icon: Icons.fastfood, color: Colors.orange),
    CategoryData(
        name: 'Transport', icon: Icons.directions_car, color: Colors.blue),
    CategoryData(
        name: 'Shopping', icon: Icons.shopping_cart, color: Colors.pink),
    // Add more categories as needed
  ];

  @override
  void dispose() {
    // TODO: implement dispose
    titleController.dispose();
    valueController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return DefaultTabController(
      length: 2,
      child: Scaffold(
          appBar:  const CustomTransactionAppBar(),
          body: TabBarView(
            children: [
              ExpensesCategoryGrid(categories: categories),
              // Padding(
              //   padding: const EdgeInsets.all(16.0),
              //   child: Column(
              //     children: [
              //       Expanded(
              //         child: GridView.builder(
              //           gridDelegate:
              //               const SliverGridDelegateWithFixedCrossAxisCount(
              //             crossAxisCount: 4,
              //             crossAxisSpacing: 8,
              //             mainAxisSpacing: 8,
              //           ),
              //           itemCount: categories.length,
              //           itemBuilder: (context, index) {
              //             final category = categories[index];
              //             final isSelected = context.watch<TransactionAmountProvider>().selectedCategory== category;
              //             return GestureDetector(
              //               onTap: () {
              //                  context.read<TransactionAmountProvider>().selectCategory(category);
              //                 _AddTransactionsData(categoryData: category);
              //               },
              //               child: Container(
              //                 decoration: BoxDecoration(
              //                   color: isSelected
              //                       ? category.color.withOpacity(0.4)
              //                       : category.color.withOpacity(0.2),
              //                   borderRadius: BorderRadius.circular(10),
              //                   border: isSelected
              //                       ? Border.all(
              //                           color: category.color, width: 2)
              //                       : null,
              //                 ),
              //                 child: Column(
              //                   mainAxisAlignment: MainAxisAlignment.center,
              //                   children: [
              //                     Icon(category.icon,
              //                         size: 30, color: category.color),
              //                     const SizedBox(height: 10),
              //                     Text(category.name,
              //                         style: TextStyle(
              //                             color: category.color,
              //                             fontSize: TextSizes.smallBodyTextMax,
              //                             fontWeight: FontWeight.w400)),
              //                     if (isSelected)
              //                       Icon(Icons.check, color: category.color)
              //                   ],
              //                 ),
              //               ),
              //             );
              //           },
              //         ),
              //       )
              //     ],
              //   ),
              // ),
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Text("Income"),
                  ],
                ),
              ),
            ],
          )),
    );
  }

//
//   void _AddTransactionsData({required CategoryData categoryData}) {
//     TextEditingController amountController = TextEditingController();
//     showModalBottomSheet(
//         context: context,
//         shape: const RoundedRectangleBorder(
//           borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
//         ),
//         builder: (context) {
//
//           return Padding(
//             padding: EdgeInsets.only(
//               bottom: MediaQuery.of(context).viewInsets.bottom,
//               top: 16,
//               left: 16,
//               right: 16
//             ),
//             child: Column(
//               children: [
//                 const Text("Expense",style: TextStyle(
//                   fontSize: TextSizes.mediumHeadingMin,
//                   fontWeight: FontWeight.bold,
//                 ),),
//                 const SizedBox(height: 10,),
//                 AmountTextField(amountController: amountController, categoryDataTextField: categoryData,
//                 onSubmitted: (value){
//                   _addTransaction(categoryData, amountController);
//                 },
//                 ),
//                 const SizedBox(height: 10,),
//                 ElevatedButton
//                   (onPressed: (){
//                     _addTransaction(categoryData, amountController);
//                     // for(int i = 0; i< transactions.length;i++){
//                     //   print(transactions[i].expensesPrice);
//                     //   print(transactions[i].categoryData.name);
//                     //
//                     //
//                     // }
//
//
//                 },
//                     child:const Text("Add Expense") )
//               ],
//             ),
//           );
//         });
//   }
//
//
//   void _addTransaction(CategoryData category, TextEditingController amountController) {
//     final amount = double.tryParse(amountController.text);
//     if (amount != null && amount > 0) {
//       final transaction= AddTransactionsData(categoryData: category, expensesPrice: amount);
//      context.read<TransactionAmountProvider>().addTransactonsAmount(transaction);
//       Navigator.pop(context); // Dismiss the bottom sheet
//     }
//   }
}


