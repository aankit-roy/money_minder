


import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:money_minder/models/bar_chart_data.dart';
import 'package:money_minder/models/line_chart_datamodel.dart';
import 'package:money_minder/provider/income_transaction_provider.dart';
import 'package:money_minder/provider/transaction_provider.dart';
import 'package:money_minder/res/colors/color_palette.dart';
import 'package:money_minder/res/constants/currency_symbol.dart';
import 'package:money_minder/ui/widgets/custome_period_button.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../ui/widgets/barchart_data.dart';
import '../ui/widgets/linechart_data.dart';

class StatPage extends StatefulWidget {
  const StatPage({super.key});

  @override
  State<StatPage> createState() => _StatPageState();
}

class _StatPageState extends State<StatPage> {

  Map<int, double> _monthlyExpenses = {}; // Initialize with empty map
  Map<int, double> _yearlyExpenses = {};  // Initialize with empty map


  Map<int, double> _monthlyIncome = {};
  Map<int, double> _yearlyIncome = {};


  late TransactionAmountProvider provider;
  bool _showMonthly = true;

  @override
  void initState() {
    super.initState();

    // _updateExpenses();
  }

  @override

  Widget build(BuildContext context) {

    final provider = context.watch<TransactionAmountProvider>();
    final incomeProvider= context.watch<IncomeTransactionProvider>();
    _monthlyExpenses = provider.getMonthlyDataForCurrentYear();
    _yearlyExpenses = provider.getYearlyDataForPast10Years();

    _monthlyIncome=incomeProvider.getMonthlyIncomesForCurrentYear();
    _yearlyIncome= incomeProvider.getYearlyIncomesForPast10Years();



    Size size= MediaQuery.sizeOf(context);
    final PageController pageController = PageController();
    double totalExpensesCurrentYear= provider.getTotalExpensesForCurrentYear();
    double totalExpensesAllYear= provider.getTotalExpensesForCurrentYear();

    double totalIncomesCurrentYear= incomeProvider.getTotalIncomesForCurrentYear();
    double totalIncomesAllYear= incomeProvider.getTotalIncomesForPast10Years();

    double totalExpenses=_showMonthly?totalExpensesCurrentYear :totalExpensesAllYear;
    double totalIncomes= _showMonthly? totalIncomesCurrentYear :totalIncomesAllYear;
    return Scaffold(

      body: Column(
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                height: 200,
                decoration: const BoxDecoration(
                  color: ColorsPalette.primaryColor,
                  borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),


                ),
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,

                    // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [


                      CustomPeriodButton(
                        isSelected: _showMonthly,
                        label: 'Monthly',
                        onPressed: () {
                          setState(() {
                            _showMonthly = true;
                          });
                        },
                      ),
                      SizedBox(width: size.width * 0.1),
                      CustomPeriodButton(
                        isSelected: !_showMonthly,
                        label: 'Yearly',
                        onPressed: () {
                          setState(() {
                            _showMonthly = false;
                          });
                        },
                      ),

                    ],
                  ),
                ),

              ),

              Positioned(
                top: 150,
                left: 0,
                right: 0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildSummaryCard('Total Income',
                        '${CurrencySymbols.rupee}$totalIncomes', Colors.green),
                    _buildSummaryCard('Total Expenses',
                        '${CurrencySymbols.rupee}$totalExpenses', Colors.red),
                    _buildSummaryCard('Profit/Loss',
                        '${CurrencySymbols.rupee}2,000', Colors.blue),
                  ],
                ),
              ),


            ],

          ),
          SizedBox(height:size.height*.07 ,),

          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              height: size.height * 0.5,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18.0),
                color: Colors.white,
              ),
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(18.0),
                    child: PageView(
                      controller: pageController,
                      children: [

                        _buildChartCard(

                            _buildBarChart(size),
                            size,
                            _showMonthly
                        ),
                        _buildChartCard(

                            _buildLineChart(size),
                            size,
                            _showMonthly
                        ),


                      ],
                    ),
                  ),
                  Positioned(
                    bottom: 10,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: SmoothPageIndicator(
                        controller: pageController,
                        count: 2, // Number of pages
                        effect: const WormEffect(
                          dotWidth: 10,
                          dotHeight: 10,
                          spacing: 8,
                          radius: 8,
                          dotColor: Colors.grey,
                          activeDotColor: Colors.blue,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 20),

        ],
      ),
    );
  }

  Widget _buildSummaryCard(String title, String value, Color color) {
    return Card(
      // color: color.withOpacity(0.1),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(title,
                style:
                const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Text(value,
                style: TextStyle(
                    fontSize: 24, fontWeight: FontWeight.bold, color: color)),
          ],
        ),
      ),
    );
  }


  Widget _buildChartCard(Widget chart, Size size, bool isMonthly) {
    final displayTitle = isMonthly ? 'Monthly' : 'Yearly';
    final displayYear = isMonthly ? DateTime.now().year.toString() : '';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            displayTitle,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        Container(
          padding: const EdgeInsets.all(16.0),
          child: chart,
        ),
        if (isMonthly)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Text(
              'Year: $displayYear',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        const IncomeExpensesIcon(),
        const SizedBox(height: 5),
      ],
    );
  }


  Widget _buildBarChart(Size size) {
    final List<StatBarChartData> chartData = _showMonthly
        ? List.generate(
      _monthlyExpenses.length,
          (index) {
        int month = index + 1; // Month numbers are 1-based
        final expense = _monthlyExpenses[month] ?? 0.0;
        final income = _monthlyIncome[month] ?? 0.0;
        return StatBarChartData(
            month: month,
            income: income,
            expense: expense);
      },
    )
        : List.generate(
      _yearlyExpenses.length,
          (index) {
        final year = _yearlyExpenses.keys.elementAt(index);
        final expense = _yearlyExpenses[year] ?? 0.0;
        final income = _yearlyIncome[year] ?? 0.0;
        return StatBarChartData(
            month: year, // Use year as x-axis label for yearly view
            income: income,
            expense: expense);
      },
    );

    return BarChartWidget(
      chartData: chartData,
      size: size,
      isMonthly: _showMonthly,
    );
  }

  Widget _buildLineChart(Size size) {
    final isMonthly = _showMonthly;

    // Generate x-axis labels
    final List<String> xAxisLabels = isMonthly
        ? List.generate(12, (index) => [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ][index])
        : List.generate(
      _yearlyExpenses.length,
          (index) {
        final year = _yearlyExpenses.keys.elementAt(index);
        return year.toString();
      },
    );

    // Generate expense spots
    final List<FlSpot> expenseSpots = isMonthly
        ? List.generate(
      12,
          (index) {
        final month = index + 1;
        final expense = _monthlyExpenses[month] ?? 0.0;
        return FlSpot(index.toDouble(), expense);
      },
    )
        : List.generate(
      _yearlyExpenses.length,
          (index) {
        final year = _yearlyExpenses.keys.elementAt(index);
        final expense = _yearlyExpenses[year] ?? 0.0;
        return FlSpot(index.toDouble(), expense);
      },
    );

    // Generate income spots
    final List<FlSpot> incomeSpots = isMonthly
        ? List.generate(
      12,
          (index) {
        final month = index + 1;
        final income = _monthlyIncome[month] ?? 0.0;
        return FlSpot(index.toDouble(), income);
      },
    )
        : List.generate(
      _yearlyExpenses.length,
          (index) {
        final year = _yearlyExpenses.keys.elementAt(index);
        final income = _yearlyIncome[year] ?? 0.0;
        return FlSpot(index.toDouble(), income);
      },
    );

    final chartData = LineChartDataModel(
      xAxisLabels: xAxisLabels,
      incomeSpots: incomeSpots,
      expenseSpots: expenseSpots,
    );

    return LineChartWidget(
      chartData: chartData,
      size: size,
      isMonthly: isMonthly,
    );
  }







}

class IncomeExpensesIcon extends StatelessWidget {
  const IncomeExpensesIcon({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Container(
                height: 20,
                width: 20,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(3),
                  color: Colors.green,
                ),

              ),
              const SizedBox(width: 10,),
              const Text(
                "Income",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              )
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Container(
                height: 20,
                width: 20,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(3),
                  color: Colors.red,
                ),

              ),
              const SizedBox(width: 10,),
              const Text(
                "Expenses",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              )
            ],
          ),
        ),
      ],
    );
  }
}







