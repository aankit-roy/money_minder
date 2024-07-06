import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:money_minder/models/add_transactions_data.dart';
import 'package:money_minder/models/category_list.dart';
import 'package:money_minder/models/pie_chart_data.dart';
import 'package:money_minder/res/colors/color_palette.dart';
import 'package:money_minder/ui/widgets/custome_Tran_add_app_bar.dart';
import 'package:money_minder/ui/widgets/expenses_category_grid.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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
    CategoryData(name: 'Rent', icon: Icons.home, color: Colors.blue),
    CategoryData(name: 'Utilities', icon: Icons.lightbulb, color: Colors.orange),
    CategoryData(name: 'Groceries', icon: Icons.shopping_cart, color: Colors.green),
    CategoryData(name: 'Transportation', icon: Icons.directions_car, color: Colors.red),
    CategoryData(name: 'Dining Out', icon: Icons.restaurant, color: Colors.purple),
    CategoryData(name: 'Entertainment', icon: Icons.movie, color: Colors.teal),
    CategoryData(name: 'Subscriptions', icon: Icons.subscriptions, color: Colors.amber),
    CategoryData(name: 'Clothing', icon: Icons.shopping_bag, color: Colors.pink),
    CategoryData(name: 'Fitness', icon: Icons.fitness_center, color: Colors.brown),
    CategoryData(name: 'Education', icon: Icons.school, color: Colors.cyan),
    CategoryData(name: 'Books ', icon: Icons.book, color: Colors.indigo),
    CategoryData(name: 'Phone', icon: Icons.phone_android, color: Colors.lime),
    CategoryData(name: 'Internet', icon: Icons.wifi, color: Colors.deepPurple),
    CategoryData(name: 'Insurance', icon: Icons.policy, color: Colors.lightGreen),
    CategoryData(name: 'Travel', icon: Icons.flight, color: Colors.deepOrange),
    CategoryData(name: 'Savings', icon: Icons.savings, color: Colors.lightBlue),
    CategoryData(name: 'Investments', icon: Icons.trending_up, color: Colors.green.shade800),
    CategoryData(name: 'Gifts', icon: Icons.card_giftcard, color: Colors.pinkAccent),
    CategoryData(name: 'Charity', icon: Icons.volunteer_activism, color: Colors.blueGrey),
    CategoryData(name: 'Personal Care', icon: Icons.spa, color: Colors.green.shade500),
    CategoryData(name: 'Medical', icon: Icons.local_hospital, color: Colors.redAccent),
    CategoryData(name: 'Childcare', icon: Icons.child_care, color: Colors.purpleAccent),
    CategoryData(name: 'Pet Care', icon: Icons.pets, color: Colors.tealAccent.shade700),
    CategoryData(name: 'Debt Payments', icon: Icons.credit_card, color: Colors.amberAccent),
    CategoryData(name: 'Alcohol', icon: FontAwesomeIcons.wineGlass, color: Colors.orangeAccent),
    CategoryData(name: 'Coffee', icon: FontAwesomeIcons.codeFork, color: Colors.brown),
    CategoryData(name: 'Fast Food', icon: FontAwesomeIcons.burger, color: Colors.limeAccent),
    CategoryData(name: 'Laundry', icon: FontAwesomeIcons.soap, color: Colors.blueAccent),
    CategoryData(name: 'Parking', icon: FontAwesomeIcons.squareParking, color: Colors.cyanAccent),
    CategoryData(name: 'Miscellaneous', icon: Icons.more_horiz, color: Colors.grey),
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


