import 'package:flutter/cupertino.dart';
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

class CurrentTimeDataList extends StatelessWidget {
  const CurrentTimeDataList({
    super.key,
    required this.size,
    required this.isExpenses,
  });

  final Size size;
  final bool isExpenses; // true for expenses, false for income

  @override
  Widget build(BuildContext context) {
    final expensesProvider = Provider.of<TransactionAmountProvider>(context);
    final incomeProvider = Provider.of<IncomeTransactionProvider>(context);
    final timePeriod = Provider.of<GeneralProvider>(context).selectedPeriod;

    final aggregatedData = isExpenses
        ? expensesProvider.getAggregatedData(timePeriod)
        : incomeProvider.getAggregatedData(timePeriod);

    final totalAmount =
        aggregatedData.values.fold(0.0, (sum, amount) => sum + amount);

    // Get the header date range based on the selected period
    String headerDateRange = _getHeaderDateRange(timePeriod);

    return SizedBox(
      height: size.height * .5,
      child: Column(
        children: [
          _HeaderWidget(
            dateRange: headerDateRange,
            totalAmount: totalAmount,
            isExpenses: isExpenses,
          ),
          Expanded(
            child: ListView.builder(
              itemCount: aggregatedData.length,
              itemBuilder: (context, index) {
                final category = aggregatedData.keys.elementAt(index);
                final amount = aggregatedData[category]!;
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Container(
                    decoration: BoxDecoration(
                      color: ColorsPalette.white,
                      borderRadius: BorderRadius.circular(10.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 5.0,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: ListTile(
                      leading: Container(
                        width: 40.0,
                        height: 40.0,
                        decoration: BoxDecoration(
                          color: category.color.withOpacity(0.2),
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Icon(
                            category.icon,
                            color: category.color,
                            size: 24.0,
                          ),
                        ),
                      ),
                      title: Text(
                        category.name,
                        style: const TextStyle(
                            fontSize: TextSizes.smallHeadingMax,
                            fontWeight: FontWeight.w600,
                            color: ColorsPalette.textSecondary),
                      ),
                      trailing: Text(
                        '₹${amount.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: TextSizes.smallHeadingMax,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
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

  String _getHeaderDateRange(TimePeriod timePeriod) {
    DateTime now = DateTime.now();
    switch (timePeriod) {
      case TimePeriod.daily:
        return DateFormat('d MMM yyyy').format(now);
      case TimePeriod.weekly:
        final weekStart = now.subtract(Duration(days: now.weekday - 1));
        return 'Week of ${DateFormat('d MMM yyyy').format(weekStart)}';
      case TimePeriod.monthly:
        return DateFormat('MMMM yyyy').format(now);
      case TimePeriod.yearly:
        return DateFormat('yyyy').format(now);
      default:
        return '';
    }
  }
}

class _HeaderWidget extends StatelessWidget {
  const _HeaderWidget({
    required this.dateRange,
    required this.totalAmount,
    required this.isExpenses,
  });

  final String dateRange;
  final double totalAmount;
  final bool isExpenses;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          dateRange,
          style: const TextStyle(
              fontSize: TextSizes.normalBodyTextMax,
              fontWeight: FontWeight.bold,
              color: ColorsPalette.textSecondary),
        ),
        SizedBox(height: 8),
        CurrentExpenseAndIncomeWidget(
            totalAmount: totalAmount, isExpenses: isExpenses)
      ],
    );
  }
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

class CurrentExpenseAndIncomeWidget extends StatelessWidget {
  const CurrentExpenseAndIncomeWidget({
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

// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:money_minder/models/add_transactions_data.dart';
// import 'package:money_minder/models/time_period.dart';
// import 'package:money_minder/provider/general_provider.dart';
// import 'package:money_minder/provider/income_transaction_provider.dart';
// import 'package:money_minder/provider/transaction_provider.dart';
// import 'package:money_minder/res/colors/color_palette.dart';
// import 'package:money_minder/res/constants/text_size.dart';
// import 'package:provider/provider.dart';
//
// class AggregatedDataList extends StatelessWidget {
//   const AggregatedDataList({
//     super.key,
//     required this.size,
//     required this.isExpenses,
//   });
//
//   final Size size;
//   final bool isExpenses; // true for expenses, false for income
//
//   @override
//   Widget build(BuildContext context) {
//     final expensesProvider = Provider.of<TransactionAmountProvider>(context);
//     final incomeProvider = Provider.of<IncomeTransactionProvider>(context);
//     final timePeriod = Provider.of<GeneralProvider>(context).selectedPeriod;
//
//     final aggregatedData = isExpenses
//         ? expensesProvider.getAggregatedData(timePeriod)
//         : incomeProvider.getAggregatedData(timePeriod);
//
//     final totalAmount = aggregatedData.values.fold(0.0, (sum, amount) => sum + amount);
//
//     // Get the header date range based on the selected period
//     String headerDateRange = _getHeaderDateRange(timePeriod);
//
//     return Container(
//       width: size.width,
//
//       decoration: BoxDecoration(
//         color: ColorsPalette.white,
//         borderRadius: BorderRadius.circular(18.0),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.1),
//             blurRadius: 5.0,
//             offset: const Offset(0, 2),
//           ),
//         ],
//       ),
//       child: Column(
//         children: [
//           _HeaderWidget(dateRange: headerDateRange, totalAmount: totalAmount),
//           Expanded(
//             child: ListView.builder(
//               itemCount: aggregatedData.length,
//               itemBuilder: (context, index) {
//                 final category = aggregatedData.keys.elementAt(index);
//                 final amount = aggregatedData[category]!;
//                 return Padding(
//                   padding: const EdgeInsets.symmetric(vertical: 8),
//                   child: Container(
//                     decoration: BoxDecoration(
//                       color: ColorsPalette.white,
//                       borderRadius: BorderRadius.circular(12.0),
//                       boxShadow: [
//                         BoxShadow(
//                           color: Colors.black.withOpacity(0.1),
//                           blurRadius: 5.0,
//                           offset: const Offset(0, 2),
//                         ),
//                       ],
//                     ),
//                     child: ListTile(
//                       leading: Container(
//                         width: 40.0,
//                         height: 40.0,
//                         decoration: BoxDecoration(
//                           color: category.color.withOpacity(0.2),
//                           shape: BoxShape.circle,
//                         ),
//                         child: Center(
//                           child: Icon(
//                             category.icon,
//                             color: category.color,
//                             size: 24.0,
//                           ),
//                         ),
//                       ),
//                       title: Text(
//                         category.name,
//                         style:   const TextStyle(
//                             fontSize: TextSizes.smallHeadingMax,
//                             fontWeight: FontWeight.w600,
//                             color: ColorsPalette.textSecondary),
//                       ),
//                       trailing: Text(
//                         '₹${amount.toStringAsFixed(2)}',
//                         style:  const TextStyle(
//                           fontSize: TextSizes.smallHeadingMax,
//                           fontWeight: FontWeight.w800,
//                         ),
//                       ),
//                       onLongPress: () {
//                         // final provider = isExpenses
//                         //     ? expensesProvider
//                         //     : incomeProvider;
//                         // _showDeleteConfirmationDialog(
//                         //     context, isExpenses, provider, category);
//                       },
//                     ),
//                   ),
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   String _getHeaderDateRange(TimePeriod timePeriod) {
//     DateTime now = DateTime.now();
//     switch (timePeriod) {
//       case TimePeriod.daily:
//         return DateFormat('d MMM yyyy').format(now);
//       case TimePeriod.weekly:
//         final weekStart = now.subtract(Duration(days: now.weekday - 1));
//         return 'Week of ${DateFormat('d MMM yyyy').format(weekStart)}';
//       case TimePeriod.monthly:
//         return DateFormat('MMMM yyyy').format(now);
//       case TimePeriod.yearly:
//         return DateFormat('yyyy').format(now);
//       default:
//         return '';
//     }
//   }
// }
//
// class _HeaderWidget extends StatelessWidget {
//   const _HeaderWidget({
//     required this.dateRange,
//     required this.totalAmount,
//   });
//
//   final String dateRange;
//   final double totalAmount;
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.all(12.0),
//       decoration: BoxDecoration(
//         color: ColorsPalette.primaryDark.withOpacity(0.1),
//         borderRadius: BorderRadius.only(
//           topLeft: Radius.circular(18.0),
//           topRight: Radius.circular(18.0),
//         ),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.1),
//             blurRadius: 5.0,
//             offset: const Offset(0, 2),
//           ),
//         ],
//       ),
//       child: Column(
//         children: [
//           Text(
//             dateRange,
//             style: const TextStyle(
//               fontSize: TextSizes.mediumHeadingMax,
//               fontWeight: FontWeight.bold,
//               color: ColorsPalette.textPrimary,
//             ),
//           ),
//           SizedBox(height: 8),
//           Text(
//             'Total: ₹${totalAmount.toStringAsFixed(2)}',
//             style: const TextStyle(
//               fontSize: TextSizes.smallHeadingMax,
//               fontWeight: FontWeight.w600,
//               color: ColorsPalette.textSecondary,
//             ),
//           ),
//           SizedBox(height: 8),
//           Divider(
//             color: ColorsPalette.primaryDark,
//             thickness: 1,
//           ),
//         ],
//       ),
//     );
//   }
// }
