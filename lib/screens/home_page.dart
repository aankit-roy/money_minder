import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:money_minder/models/add_transactions_data.dart';
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
        appBar: CustomeHomeAppBar(
          size: size,
          tabController: tabController,
        ),
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
                ExpensesDataList(
                  size: size,
                ),
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
    final transactionsProvider = context.watch<TransactionAmountProvider>();
    // final transactions = transactionsProvider.transactionList;

    final transByDate = transactionsProvider.transactionsDataByDate;
    return SizedBox(
      height: size.height * .5,
      child: ListView.builder(
        itemCount: transByDate.length,
        itemBuilder: (context, index) {
          String date = transByDate.keys.elementAt(index);
          List<AddTransactionsData> transactions = transByDate[date]!;
          double totalAmount =
              transactions.fold(0.0, (sum, item) => sum + item.expensesPrice);
          // final transactionAmt = transactions[index];
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Container(
                // height: size.height * .07,
                decoration: BoxDecoration(
                    color: ColorsPalette.white,
                    borderRadius: BorderRadius.circular(10.0)),
                child: Theme(
                  data: Theme.of(context)
                      .copyWith(dividerColor: Colors.transparent),
                  child: ExpansionTile(
                    // backgroundColor: ColorsPalette.primaryLight.withOpacity(.4),

                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          date,
                          style: const TextStyle(
                              fontSize: TextSizes.normalBodyTextMax,
                              fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Expenses: \₹ ${totalAmount.toStringAsFixed(2)}',
                              style: const TextStyle(color: Colors.red, fontSize: 16),
                            ),
                            Text(
                              'Income: \₹ ${totalAmount.toStringAsFixed(2)}',
                              style:
                                  const TextStyle(color: Colors.green, fontSize: 16),
                            ),
                          ],
                        ),
                      ],
                    ),
                    children: transactions.map((transaction) {
                      return ListTile(
                        leading: Icon(transaction.categoryData.icon,
                            color: transaction.categoryData.color),
                        title: Text(
                          transaction.categoryData.name,
                          style: const TextStyle(
                            fontSize: TextSizes.normalBodyTextMax,
                          ),
                        ),
                        trailing: Text(
                          '\₹${transaction.expensesPrice.toStringAsFixed(2)}',
                          style: const TextStyle(
                              fontSize: TextSizes.normalBodyTextMax,
                              fontWeight: FontWeight.w800),
                        ),
                        onLongPress: () {
                          _showDeleteConfirmationDialog(
                              context, transactionsProvider, transaction);
                        },
                        onTap: () {
                          // update is not working****************************

                          // _showUpdateDialog(
                          //     context, transactionsProvider, transaction);
                        },
                      );
                    }).toList(),
                  ),
                )),
          );
        },
      ),
    );
  }
}

void _showUpdateDialog(BuildContext context, TransactionAmountProvider provider,
    AddTransactionsData oldTransaction) {
  TextEditingController amountController =
      TextEditingController(text: oldTransaction.expensesPrice.toString());

  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Update Expense'),
        content: TextField(
          controller: amountController,
          keyboardType: TextInputType.number,
          autofocus: true,
          decoration: InputDecoration(
            label: const Text("New Amount"),
            prefixIcon: Icon(
              oldTransaction.categoryData.icon,
              color: oldTransaction.categoryData.color,
            ),
            hintText: "100 e.g",
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final newAmount = double.tryParse(amountController.text);
              if (newAmount != null && newAmount > 0) {
                final newTransaction = AddTransactionsData(
                    id: oldTransaction.id,
                    categoryData: oldTransaction.categoryData,
                    expensesPrice: newAmount,
                    date: oldTransaction.date);
                provider.updateTransaction( newTransaction);
                Navigator.pop(context);
              }
            },
            child: const Text('Update'),
          ),
        ],
      );
    },
  );
}

Future<void> _showDeleteConfirmationDialog(
    BuildContext context,
    TransactionAmountProvider provider,
    AddTransactionsData transactionsData) async {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Delete Expense'),
        content: const Text('Are you sure you want to delete this expense?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              provider.removeTransactonsAmount(transactionsData);
              Navigator.pop(context);
            },
            child: const Text('Delete'),
          ),
        ],
      );
    },
  );
}

// ListTile(
// leading: Icon(
// transactionAmt.categoryData.icon,
// color: transactionAmt.categoryData.color,
// ),
// title: Text(
// transactionAmt.categoryData.name,
// style: const TextStyle(
// fontSize: TextSizes.mediumHeadingMin,
// ),
// ),
// trailing: Text(
// "₹${transactionAmt.expensesPrice}",
// style: const TextStyle(
// fontSize: TextSizes.normalBodyTextMax,
// fontWeight: FontWeight.w800),
// ),
// onLongPress: () {
// _showDeleteConfirmationDialog(
// context, transactionsProvider, index);
// },
// onTap: (){
//
// _showUpdateDialog(context, transactionsProvider, index, transactionAmt);
//
// },
// ),
