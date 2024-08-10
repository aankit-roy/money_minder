import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:money_minder/models/add_transactions_data.dart';
import 'package:money_minder/models/time_period.dart';
import 'package:money_minder/provider/general_provider.dart';
import 'package:money_minder/provider/income_transaction_provider.dart';
import 'package:money_minder/provider/transaction_provider.dart';
import 'package:money_minder/res/colors/color_palette.dart';
import 'package:money_minder/res/constants/text_size.dart';
import 'package:provider/provider.dart';


class TransactionDataList extends StatelessWidget {
  const TransactionDataList({
    super.key,
    required this.size,
    // required this.selectedPeriod,
    // required this.transactionProvider,
    required this.isExpenses,
  });

  final Size size;
  // final TimePeriod selectedPeriod;
  // final dynamic transactionProvider;
  final bool isExpenses; // true for expenses, false for income

  @override
  Widget build(BuildContext context) {

    final expensesProvider = Provider.of<TransactionAmountProvider>(context);
    final incomeProvider = Provider.of<IncomeTransactionProvider>(context);
    final timePeriod = Provider.of<GeneralProvider>(context).selectedPeriod;
    final transByDate =isExpenses ? _filterTransactionsByPeriod(
        expensesProvider.transactionList, timePeriod) : _filterTransactionsByPeriod(incomeProvider.incomeList, timePeriod);

    final sortedDates = transByDate.keys.toList()
      ..sort((a, b) => b.compareTo(a)); // Sort dates in descending order

    return SizedBox(
      height: size.height * .5,
      child: ListView.builder(
        itemCount: sortedDates.length,
        itemBuilder: (context, index) {
          String date = sortedDates[index];
          List<AddTransactionsData> transactions = transByDate[date]!;
          double totalAmount =
          transactions.fold(0.0, (sum, item) => sum + item.expensesPrice);

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
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  DateWidget(date: date),
                  ExpenseAndIncomeWidget(
                    totalAmount: totalAmount,
                    isExpenses: isExpenses,
                  ),
                  ...transactions.map((transaction) {
                    return ListTile(
                      leading: Container(
                        width: 40.0, // Adjust the size as needed
                        height: 40.0, // Adjust the size as needed
                        decoration: BoxDecoration(
                          color: transaction.categoryData.color.withOpacity(
                              0.2), // Light background color for the icon
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Icon(
                            transaction.categoryData.icon,
                            color: transaction.categoryData.color,
                            size: 24.0, // Adjust the icon size as needed
                          ),
                        ),
                      ),
                      title: Text(
                        transaction.categoryData.name,
                        style: const TextStyle(
                            fontSize: TextSizes.smallHeadingMax,
                            fontWeight: FontWeight.w600,
                            color: ColorsPalette.textSecondary),
                      ),
                      trailing: Text(
                        '₹${transaction.expensesPrice.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: TextSizes.smallHeadingMax,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      onLongPress: () {
                        final provider = isExpenses
                            ? expensesProvider
                            : incomeProvider;
                        _showDeleteConfirmationDialog(
                            context, isExpenses, provider, transaction);
                      },
                      onTap: () {
                        // _showUpdateDialog(context, transactionProvider, transaction);
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
    required this.isExpenses,
  });

  final double totalAmount;
  final bool isExpenses;

  @override
  Widget build(BuildContext context) {


    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Left Divider
          Expanded(
            child: Container(
              height: 1,
              color: ColorsPalette.primaryDark, // Adjust the color as needed
            ),
          ),
          // Text in the middle
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Text(
              '${isExpenses ? 'Expenses' : 'Incomes'}: ₹${totalAmount.toStringAsFixed(2)}',
              style: TextStyle(
                color: isExpenses ? Colors.red : ColorsPalette.greencColor,
                fontWeight: FontWeight.w600,
                fontSize: TextSizes.smallHeadingMin,
              ),
            ),
          ),
          // Right Divider
          Expanded(
            child: Container(
              height: 1,
              color: ColorsPalette.primaryDark, // Adjust the color as needed
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
            color: ColorsPalette.textSecondary),
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
        final weekStart = transaction.date
            .subtract(Duration(days: transaction.date.weekday - 1));
        key = DateFormat('d MMM yyyy').format(weekStart);
        break;
      case TimePeriod.monthly:
        key = DateFormat('MMM yyyy').format(transaction.date);
        break;
      case TimePeriod.yearly:
        key = DateFormat('yyyy').format(transaction.date);
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
              // final newAmount = double.tryParse(amountController.text);
              // if (newAmount != null && newAmount > 0) {
              //   final newTransaction = AddTransactionsData(
              //       id: oldTransaction.id,
              //       categoryData: oldTransaction.categoryData,
              //       expensesPrice: newAmount,
              //       date: oldTransaction.date);
              //   provider.updateTransaction(newTransaction);
              //   Navigator.pop(context);
              // }
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
    bool isExpenses, // Added parameter
    dynamic provider, // Changed to dynamic type
    AddTransactionsData transactionsData) async {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Delete Data'),
        content: const Text('Are you sure you want to delete this item?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (isExpenses) {
                // Remove expense data
                (provider as TransactionAmountProvider).removeTransactonsAmount(transactionsData);
              } else {
                // Remove income data
                (provider as IncomeTransactionProvider).removeIncome(transactionsData);
              }
              Navigator.pop(context);
            },
            child: const Text('Delete'),
          ),
        ],
      );
    },
  );
}

