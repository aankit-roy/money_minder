import 'package:flutter/material.dart';
import 'package:money_minder/models/add_transactions_data.dart';
import 'package:money_minder/models/time_period.dart';
import 'package:money_minder/provider/general_provider.dart';
import 'package:money_minder/provider/income_transaction_provider.dart';
import 'package:money_minder/provider/transaction_provider.dart';
import 'package:money_minder/ui/widgets/custome_home_app_bar.dart';
import 'package:money_minder/ui/widgets/pie_chart_widget.dart';
import 'package:money_minder/ui/widgets/transaction_list_data.dart';
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
    // TimePeriod timePeriod =
        // context.watch<TransactionAmountProvider>().currentPeriod;
    final generalProvider = context.watch<GeneralProvider>();
    TimePeriod timePeriod =
        generalProvider.selectedPeriod;
    final transactionProvider = context.watch<TransactionAmountProvider>();
    final incomeProvider = context.watch<IncomeTransactionProvider>();

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

                  child: PieChartWidget(
                    aggregatedData: generalProvider.isExpensesSelected
                        ? transactionProvider.getAggregatedData(generalProvider.selectedPeriod)
                        : incomeProvider.getAggregatedData(generalProvider.selectedPeriod),
                    totalAmount: generalProvider.isExpensesSelected
                        ? transactionProvider.getTotalAmountForPeriod(generalProvider.selectedPeriod)
                        : incomeProvider.getTotalAmountForPeriod(generalProvider.selectedPeriod),
                    selectedPeriod: generalProvider.selectedPeriod,
                    onPeriodChanged: (newPeriod) {
                      setState(() {
                        generalProvider.SelectedPeriod= newPeriod;
                      });
                    },
                  ),
                ),
                const SizedBox(height: 20),

                 // ExpensesDataList(size: size, selectedPeriod: timePeriod),
                TransactionDataList(size: size, isExpenses: generalProvider.isExpensesSelected),

                 const SizedBox(height: 20),



              ],
            ),
          ),
        ));
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
