
import 'package:flutter/material.dart';
import 'package:money_minder/models/time_period.dart';
import 'package:money_minder/provider/transaction_provider.dart';
import 'package:provider/provider.dart';

class StatPage extends StatefulWidget {
  const StatPage({super.key});

  @override
  State<StatPage> createState() => _StatPageState();
}

class _StatPageState extends State<StatPage> {
  @override
  Widget build(BuildContext context) {
    final transactionProvider = context.watch<TransactionAmountProvider>();

    // Get aggregated data for weekly and monthly periods
    final weeklyData = transactionProvider.getAggregatedData(TimePeriod.weekly);
    final monthlyData = transactionProvider.getAggregatedData(TimePeriod.monthly);

    return Scaffold(
      appBar: AppBar(title: Text('Aggregated Expenses')),
      body: ListView(
        children: [
          ListTile(
            title: Text('Weekly Expenses'),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: weeklyData.entries.map((entry) {
                return Text('${entry.key.name}: ₹${entry.value.toStringAsFixed(2)}');
              }).toList(),
            ),
          ),
          ListTile(
            title: Text('Monthly Expenses'),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: monthlyData.entries.map((entry) {
                return Text('${entry.key.name}: ₹${entry.value.toStringAsFixed(2)}');
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }


  void printAggregatedData() {
    // Assume you have an instance of TransactionAmountProvider
    final transactionProvider = context.read<TransactionAmountProvider>();

    // Get aggregated data for weekly and monthly periods
    final weeklyData = transactionProvider.getAggregatedData(TimePeriod.weekly);
    final monthlyData = transactionProvider.getAggregatedData(TimePeriod.monthly);

    // Print the weekly data
    print('Weekly Expenses:');
    weeklyData.forEach((category, totalAmount) {
      print('${category.name}: ₹${totalAmount.toStringAsFixed(2)}');
    });

    // Print the monthly data
    print('Monthly Expenses:');
    monthlyData.forEach((category, totalAmount) {
      print('${category.name}: ₹${totalAmount.toStringAsFixed(2)}');
    });
  }
}
