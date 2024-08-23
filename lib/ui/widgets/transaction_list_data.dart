

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:money_minder/models/add_transactions_data.dart';
import 'package:money_minder/models/time_period.dart';
import 'package:money_minder/provider/general_provider.dart';
import 'package:money_minder/provider/income_transaction_provider.dart';
import 'package:money_minder/provider/transaction_provider.dart';
import 'package:money_minder/res/colors/color_palette.dart';
import 'package:money_minder/res/constants/text_size.dart';
import 'package:money_minder/screens/adding_data.dart';
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
    final transByDate = isExpenses
        ? _filterTransactionsByPeriod(
            expensesProvider.transactionList, timePeriod)
        : _filterTransactionsByPeriod(incomeProvider.incomeList, timePeriod);

    // final sortedDates = transByDate.keys.toList()
    //   ..sort((a, b) => b.compareTo(a)); // Sort dates in descending order
    final dateFormat = _getDateFormat(timePeriod);
    final sortedDates = transByDate.keys.toList()
      ..sort((a, b) {
        final aDate = dateFormat.parse(a);
        final bDate = dateFormat.parse(b);

        if (timePeriod == TimePeriod.weekly) {
          final now = DateTime.now();
          final startOfCurrentWeek =
              now.subtract(Duration(days: now.weekday - 1));
          final endOfCurrentWeek =
              startOfCurrentWeek.add(const Duration(days: 7));

          if (aDate.isAfter(startOfCurrentWeek) &&
              aDate.isBefore(endOfCurrentWeek)) {
            return -1; // Move current week to the top
          } else if (bDate.isAfter(startOfCurrentWeek) &&
              bDate.isBefore(endOfCurrentWeek)) {
            return 1; // Move current week to the top
          }
        }
        return bDate.compareTo(aDate); // Default descending order
      });

    return ListView.builder(
      itemCount: sortedDates.length,
      physics: const NeverScrollableScrollPhysics(), // Disable the internal scrolling
      shrinkWrap: true, // Make ListView occupy only the space it needs
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
                      style: TextStyle(
                          fontSize: TextSizes.smallHeadingMax(context),
                          fontWeight: FontWeight.w600,
                          color: ColorsPalette.textSecondary),
                    ),
                    trailing: Text(
                      transaction.expensesPrice.toStringAsFixed(2),
                      style:  TextStyle(
                        fontSize: TextSizes.smallHeadingMax(context),
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    onLongPress: () {
                      final provider =
                          isExpenses ? expensesProvider : incomeProvider;
                      _showDeleteConfirmationDialog(
                          context, isExpenses, provider, transaction);
                    },
                    onTap: () {

                      final provider =
                          isExpenses ? expensesProvider : incomeProvider;
                      _showUpdateBottomSheet(
                          context, transaction, isExpenses, provider);
                    },

                  );
                }),
              ],
            ),
          ),
        );
      },
    );
  }
}

DateFormat _getDateFormat(TimePeriod timePeriod) {
  switch (timePeriod) {
    case TimePeriod.daily:
      return DateFormat('d MMM yyyy');
    case TimePeriod.weekly:
      return DateFormat('d MMM yyyy');
    case TimePeriod.monthly:
      return DateFormat('MMM yyyy');
    case TimePeriod.yearly:
      return DateFormat('yyyy');
    default:
      throw ArgumentError('Invalid TimePeriod');
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
                fontSize: TextSizes.smallHeadingMin(context),
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
  // Convert string key to DateTime
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
        style:  TextStyle(
            fontSize: TextSizes.normalBodyTextMax(context),
            fontWeight: FontWeight.bold,
            color: ColorsPalette.textSecondary),
      ),
    );
  }
}

Map<String, List<AddTransactionsData>> _filterTransactionsByPeriod(
    List<AddTransactionsData> transactions, TimePeriod period) {
  Map<String, List<AddTransactionsData>> filteredTransactions = {};
  final DateFormat dateFormat;

  switch (period) {
    case TimePeriod.daily:
      dateFormat = DateFormat('d MMM yyyy');
      break;
    case TimePeriod.weekly:
      dateFormat = DateFormat('d MMM yyyy');
      break;
    case TimePeriod.monthly:
      dateFormat = DateFormat('MMM yyyy');
      break;
    case TimePeriod.yearly:
      dateFormat = DateFormat('yyyy');
      break;
  }

  for (var transaction in transactions) {
    String key = '';

    switch (period) {
      case TimePeriod.daily:
        key = dateFormat.format(transaction.date);
        break;
      case TimePeriod.weekly:
        final weekStart = transaction.date
            .subtract(Duration(days: transaction.date.weekday - 1));
        key = dateFormat.format(weekStart);
        break;
      case TimePeriod.monthly:
        key = dateFormat.format(transaction.date);
        break;
      case TimePeriod.yearly:
        key = dateFormat.format(transaction.date);
        break;
    }

    if (filteredTransactions[key] == null) {
      filteredTransactions[key] = [];
    }

    filteredTransactions[key]!.add(transaction);
  }

  return filteredTransactions;
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
                (provider as TransactionAmountProvider)
                    .removeTransactonsAmount(transactionsData);
              } else {
                // Remove income data
                (provider as IncomeTransactionProvider)
                    .removeIncome(transactionsData);
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

Future<void> _showUpdateBottomSheet(
  BuildContext context,
  AddTransactionsData transaction,
    bool isExpenses, // Added parameter
    dynamic provider, // Changed to dynamic type
) async {
  await showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: ColorsPalette.backgroundLight,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
    ),
    builder: (context) {
      return FractionallySizedBox(
        heightFactor: 0.9,
        child: AddingData(transactions: transaction,)
      );
    },
  );
}
