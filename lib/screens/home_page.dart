import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:money_minder/models/add_transactions_data.dart';
import 'package:money_minder/models/time_period.dart';
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
    TimePeriod timePeriod= context.watch<TransactionAmountProvider>().currentPeriod;

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
                  height: size.height * .45,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20)),
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
                  selectedPeriod: timePeriod,
                ),
                SizedBox(height: 20), // Add some space between the pie chart and the text below

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
    required this.selectedPeriod,
  });

  final Size size;
  final TimePeriod selectedPeriod;
  // final transactions;

  @override
  Widget build(BuildContext context) {
    final transactionsProvider = context.watch<TransactionAmountProvider>();
    // Filter expenses data by daily, weekly, monthly
    final transByDate = _filterTransactionsByPeriod(transactionsProvider.transactionList, selectedPeriod);

    // Convert keys (dates) to a list and sort it in descending order
    final sortedDates = transByDate.keys.toList()
      ..sort((a, b) => b.compareTo(a)); // Sort dates in descending order

    return SizedBox(
      height: size.height * .5,
      child: ListView.builder(
        itemCount: sortedDates.length,
        itemBuilder: (context, index) {
          String date = sortedDates[index];
          List<AddTransactionsData> transactions = transByDate[date]!;
          double totalAmount = transactions.fold(0.0, (sum, item) => sum + item.expensesPrice);

          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Container(
              decoration: BoxDecoration(
                color: ColorsPalette.white,
                borderRadius: BorderRadius.circular(18.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 5.0,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,

                children: [
                  DateWidget(date: date),
                  ExpenseAndIncomeWidget(totalAmount: totalAmount),
                  ...transactions.map((transaction) {
                    return ListTile(
                      leading: Icon(transaction.categoryData.icon, color: transaction.categoryData.color),
                      title: Text(
                        transaction.categoryData.name,
                        style: const TextStyle(
                          fontSize: TextSizes.normalBodyTextMax,
                        ),
                      ),
                      trailing: Text(
                        '₹${transaction.expensesPrice.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: TextSizes.normalBodyTextMax,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      onLongPress: () {
                        _showDeleteConfirmationDialog(context, transactionsProvider, transaction);
                      },
                      onTap: () {
                        // Update functionality
                        // _showUpdateDialog(context, transactionsProvider, transaction);
                      },
                    );
                  }),
                ],
              ),
            ),
          );
        },
      ),
    );
  }




}

class ExpenseAndIncomeWidget extends StatelessWidget {
  const ExpenseAndIncomeWidget({
    super.key,
    required this.totalAmount,
  });

  final double totalAmount;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Expenses: ₹ ${totalAmount.toStringAsFixed(2)}',
            style: const TextStyle(
              color: ColorsPalette.textPrimary,
              fontWeight: FontWeight.w600,
              fontSize: TextSizes.smallHeadingMin,
            ),
          ),
          Text(
            'Income: ₹ ${totalAmount.toStringAsFixed(2)}',
            style: const TextStyle(
              color: ColorsPalette.textPrimary,
              fontWeight: FontWeight.w600,
              fontSize: TextSizes.smallHeadingMin,
            ),
          ),
        ],
      ),
    );
  }
}

class DateWidget extends StatelessWidget {
  const DateWidget({
    super.key,
    required this.date,
  });

  final String date;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Text(
        date,
        style: const TextStyle(
          fontSize: TextSizes.normalBodyTextMax,
          fontWeight: FontWeight.bold,
          color: ColorsPalette.textSecondary
        ),
      ),
    );
  }
}

Map<String, List<AddTransactionsData>> _filterTransactionsByPeriod(
    List<AddTransactionsData> transactions, TimePeriod period) {
  Map<String, List<AddTransactionsData>> filteredTransactions = {};

  for (var transaction in transactions) {
    String key = '';

    switch (period) {
      case TimePeriod.daily:
        key = DateFormat('d MMM yyyy').format(transaction.date);
        break;
      case TimePeriod.weekly:
        final weekStart =
            transaction.date.subtract(Duration(days: transaction.date.weekday));
        key = DateFormat('d MMM yyyy').format(weekStart);
        break;
      case TimePeriod.monthly:
        key = DateFormat('MMM yyyy').format(transaction.date);
        break;
    }

    if (filteredTransactions[key] == null) {
      filteredTransactions[key] = [];
    }

    filteredTransactions[key]!.add(transaction);
  }

  return filteredTransactions;
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
                // provider.updateTransaction(newTransaction);
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

