import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:money_minder/provider/transaction_provider.dart';
import 'package:money_minder/res/colors/color_palette.dart';
import 'package:money_minder/res/constants/text_size.dart';
import 'package:money_minder/ui/widgets/custome_home_app_bar.dart';
import 'package:money_minder/ui/widgets/expenses_tab.dart';
import 'package:money_minder/ui/widgets/income_tab.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late final TabController tabController;
  @override
  void initState() {
    // TODO: implement initState
    tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // final transaction= context.watch<TransactionAmountProvider>().transactionList;

    Size size = MediaQuery.of(context).size;
    return Scaffold(
        appBar:  CustomeHomeAppBar(size: size,tabController: tabController,),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 20,
                ),
                Container(
                  width: size.width,
                  height: size.height * .35,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18)),
                  child: TabBarView(
                    controller: tabController,
                    children: const [ExpensesTab(), IncomeTab()],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                ExpensesDataList(size: size ,),
              ],
            ),
          ),
        ));
  }


}

class ExpensesDataList extends StatelessWidget {
  const ExpensesDataList({
    super.key,
    required this.size,
  });

  final Size size;
  // final transactions;


  @override
  Widget build(BuildContext context) {
    final transactions= context.watch<TransactionAmountProvider>().transactionList;


    return Container(
      height: size.height*.5,
      child: ListView.builder(
        itemCount: transactions.length,
        itemBuilder: (context, index) {
          final transactionAmt= transactions[index];
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Container(
              height: size.height * .07,
              decoration: BoxDecoration(
                  color: ColorsPalette.white,
                  borderRadius: BorderRadius.circular(8.0)),
              child:  ListTile(
                leading: Icon(transactionAmt.categoryData.icon,color: transactionAmt.categoryData.color,),
                title: Text(
                  transactionAmt.categoryData.name,
                  style: const TextStyle(
                    fontSize: TextSizes.mediumHeadingMin,
                  ),
                ),
                trailing: Text("₹${transactionAmt.expensesPrice}",style: const TextStyle(
                  fontSize: TextSizes.normalBodyTextMax,
                  fontWeight: FontWeight.w800
                ),),
              ),
            ),
          );
        },
      ),
    );
  }
}
