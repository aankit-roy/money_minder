import 'package:flutter/material.dart';
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
    tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final generalProvider = context.watch<GeneralProvider>();
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
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              // Remove fixed height and allow the container to resize based on its content
              Container(
                width: size.width,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
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
                      generalProvider.SelectedPeriod = newPeriod;
                    });
                  },
                ),
              ),
              const SizedBox(height: 10),
              // Make the transaction list flexible so that it can scroll if it overflows
              TransactionDataList(size: size, isExpenses: generalProvider.isExpensesSelected),
              // const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}


