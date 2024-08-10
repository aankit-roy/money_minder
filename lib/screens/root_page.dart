
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:money_minder/models/add_transactions_data.dart';
import 'package:money_minder/models/category_list.dart';
import 'package:money_minder/provider/transaction_provider.dart';
import 'package:money_minder/res/colors/color_palette.dart';
import 'package:money_minder/screens/adding_data.dart';
import 'package:money_minder/screens/home_page.dart';
import 'package:money_minder/screens/profile_page.dart';
import 'package:money_minder/screens/report_page.dart';
import 'package:money_minder/screens/stat_page.dart';
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:provider/provider.dart';

class RootPage extends StatefulWidget {
  const RootPage({super.key});

  @override
  State<RootPage> createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {

  int bottomNavIndex=0;

  List<Widget> pages=[
    const HomePage(),
    const StatPage(),
    const ReportPage(),
    const ProfilePage()

  ];

  List<IconData> iconList=[
    Icons.home_filled,
    Icons.pie_chart,
    Icons.list_alt_rounded,
    Icons.person
  ];
  List<String> titleList = ["Home", "Stats", "Reports", "Me"];
  @override
  Widget build(BuildContext context) {

    Size size= MediaQuery.of(context).size;
    return Scaffold(


      body: IndexedStack(
        index: bottomNavIndex,
        children: pages,
      ),

      floatingActionButton:  FloatingActionButton(

        onPressed: (){

          ShoeBottomSheet(context);

        },
        backgroundColor: ColorsPalette.primaryColor,
        child: const Icon(
          Icons.add,

        ),
      ),
      floatingActionButtonLocation:  FloatingActionButtonLocation.centerDocked,

      bottomNavigationBar: AnimatedBottomNavigationBar(
        splashColor: ColorsPalette.primaryColor,
        activeColor: ColorsPalette.primaryColor,
        inactiveColor: ColorsPalette.textSecondary,


        icons: iconList,

        activeIndex: bottomNavIndex,
        gapLocation: GapLocation.center,
        height: size.height *.1,


        notchSmoothness: NotchSmoothness.sharpEdge,
        onTap: (index){
          setState(() {
            bottomNavIndex=index;
          });

        },

      ),


    );
  }

  Future<dynamic> ShoeBottomSheet(BuildContext context) {
    return showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: ColorsPalette.backgroundLight,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(30)
            )
          ),
          builder: (context) => const FractionallySizedBox(
            heightFactor: 0.9,
            // child: Center(child: Text("Bottom sheet")),
            child: AddingData(),
          ),
        );
  }
}

void _showCategoryDialog(BuildContext context) {

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

  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Select Category'),
        content: SizedBox(
          width: double.maxFinite,
          child: GridView.builder(
            shrinkWrap: true,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
            ),
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final category = categories[index];
              return GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                  _showAddExpenseDialog(context, category);
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(category.icon, size: 30, color: category.color),
                    const SizedBox(height: 10),
                    Text(category.name,
                        style: TextStyle(
                          color: category.color,
                          fontSize: 12,
                        )),
                  ],
                ),
              );
            },
          ),
        ),
      );
    },
  );
}

void _showAddExpenseDialog(BuildContext context, CategoryData category) {
  TextEditingController amountController = TextEditingController();
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Add Expense'),
        content: TextField(
          controller: amountController,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(hintText: 'Enter amount'),
          onSubmitted: (value) {
            _addTransaction(context, category, amountController);
          },
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              _addTransaction(context, category, amountController);
            },
            child: const Text('Add'),
          ),
        ],
      );
    },
  );
}

void _addTransaction(BuildContext context, CategoryData category, TextEditingController amountController) {
  final amount = double.tryParse(amountController.text);
  if (amount != null && amount > 0) {
    final transaction = AddTransactionsData(categoryData: category, expensesPrice: amount,date: DateTime.now());
    context.read<TransactionAmountProvider>().addTransactonsAmount(transaction);
    Navigator.pop(context); // Dismiss the bottom sheet


  }
}
