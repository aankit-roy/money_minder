
import 'package:flutter/material.dart';
import 'package:money_minder/models/time_period.dart';
import 'package:money_minder/provider/transaction_provider.dart';
import 'package:money_minder/ui/widgets/stat_app_bar.dart';
import 'package:provider/provider.dart';



class ReportPage extends StatefulWidget {
  const ReportPage({super.key});

  @override
  State<ReportPage> createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  int? _selectedMonth;
  double _totalExpenses = 0.0;
  int? _selectedYear;
  Map<int, double> _monthlyExpenses = {};

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _selectedMonth =now.year;
    _selectedYear = now.month;
    _fetchTotalExpenses();
    _fetchYearlyExpenses();
  }

  @override
  Widget build(BuildContext context) {
    print("Selected Month: $_selectedMonth");
    print("Selected Year: $_selectedYear");
    print("Total Expenses: $_totalExpenses");
    print("Monthly Expenses: $_monthlyExpenses");

    return Scaffold(
      appBar: StatAppBar(
        size: Size.fromHeight(140),
        onMonthSelected: (month) {
          final monthNumber = int.tryParse(month.split('/').first) ?? DateTime.now().month;
          setState(() {
            _selectedMonth = monthNumber;
            _fetchTotalExpenses();
          });
        },
        onYearSelected: (year) {
          final yearNumber = int.tryParse(year) ?? DateTime.now().year;
          setState(() {
            _selectedYear = yearNumber;
            _fetchYearlyExpenses();
          });
        },
      ),
      body: Column(
        children: [
          SizedBox(height: 20),
          Text('Total Expenses: $_totalExpenses'),
          if (_selectedYear != null && _monthlyExpenses.isNotEmpty)
            Expanded(
              child: ListView.builder(
                itemCount: _monthlyExpenses.length,
                itemBuilder: (context, index) {
                  final month = _monthlyExpenses.keys.elementAt(index);
                  final amount = _monthlyExpenses[month];
                  return ListTile(
                    title: Text('Month $month: ${amount ?? 0.0}'),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }

  void _fetchTotalExpenses() {
    if (_selectedMonth == null || _selectedYear == null) return;

    final provider = Provider.of<TransactionAmountProvider>(context, listen: false);
    final aggregatedData = provider.getAggregatedDataByMonths(
      TimePeriod.monthly,
      selectedMonth: _selectedMonth,
      // selectedYear: _selectedYear,
    );

    setState(() {
      _totalExpenses = aggregatedData.values.fold(0.0, (sum, amount) => sum + amount);
    });
  }

  void _fetchYearlyExpenses() {
    if (_selectedYear == null) return;

    final provider = Provider.of<TransactionAmountProvider>(context, listen: false);
    final aggregatedData = provider.getAggregatedDataByYear(_selectedYear!);

    setState(() {
      _totalExpenses = aggregatedData.values.fold(0.0, (sum, amount) => sum + amount);
      _monthlyExpenses = aggregatedData;
    });
  }
}





// class ReportPage extends StatefulWidget {
//   const ReportPage({super.key});
//
//   @override
//   State<ReportPage> createState() => _ReportPageState();
// }
//
// class _ReportPageState extends State<ReportPage> {
//   int? _selectedMonth;
//   double _totalExpenses = 0.0;
//   int? _selectedYear;
//   Map<int, double> _monthlyExpenses = {};
//
//   @override
//   Widget build(BuildContext context) {
//
//     print("Total expenses of selected months*****************$_totalExpenses");
//     print("Total expenses of selected months*****************$_totalExpenses");
//
//     return Scaffold(
//       appBar: StatAppBar(
//         size: Size.fromHeight(140),
//         onMonthSelected: (month) {
//           setState(() {
//             _selectedMonth = int.tryParse(month.split('/').first) ?? 0;
//             _fetchTotalExpenses();
//           });
//         },
//         onYearSelected: (year) {
//           setState(() {
//             _selectedYear = int.tryParse(year) ?? 0;
//             _fetchYearlyExpenses();
//           });
//         },
//       ),
//       body: Column(
//         children: [
//           SizedBox(height: 20),
//           Text('Total Expenses: $_totalExpenses'),
//           if (_selectedYear != null && _monthlyExpenses.isNotEmpty)
//             Expanded(
//               child: ListView.builder(
//                 itemCount: _monthlyExpenses.length,
//                 itemBuilder: (context, index) {
//                   final month = _monthlyExpenses.keys.elementAt(index);
//                   final amount = _monthlyExpenses[month];
//                   return ListTile(
//                     title: Text('Month $month: ${amount ?? 0.0}'),
//                   );
//                 },
//               ),
//             ),
//         ],
//       ),
//     );
//   }
//
//   void _fetchTotalExpenses() {
//     final provider = Provider.of<TransactionAmountProvider>(context, listen: false);
//     final aggregatedData = provider.getAggregatedDataByMonths(
//       TimePeriod.monthly,
//       selectedMonth: _selectedMonth,
//     );
//     setState(() {
//       _totalExpenses = aggregatedData.values.fold(0.0, (sum, amount) => sum + amount);
//     });
//   }
//
//   void _fetchYearlyExpenses() {
//     final provider = Provider.of<TransactionAmountProvider>(context, listen: false);
//     final aggregatedData = provider.getAggregatedDataByYear(_selectedYear!);
//     setState(() {
//       _totalExpenses = aggregatedData.values.fold(0.0, (sum, amount) => sum + amount);
//       _monthlyExpenses = aggregatedData;
//     });
//   }
// }



class MonthSelector extends StatelessWidget {
  final List<String> months = [
    'January', 'February', 'March', 'April', 'May', 'June',
    'July', 'August', 'September', 'October', 'November', 'December'
  ];

  final ValueChanged<int> onMonthSelected;

  MonthSelector({super.key, required this.onMonthSelected});

  @override
  Widget build(BuildContext context) {
    return DropdownButton<int>(
      hint: Text('Select Month'),
      items: List.generate(12, (index) {
        return DropdownMenuItem<int>(
          value: index + 1, // 1-based month index
          child: Text(months[index]),
        );
      }),
      onChanged: (value) {
        if (value != null) {
          onMonthSelected(value);
        }
      },
    );
  }
}

class YearSelector extends StatelessWidget {
  final List<int> years = List.generate(15, (index) => DateTime.now().year - index);

  final ValueChanged<int> onYearSelected;

  YearSelector({super.key, required this.onYearSelected});

  @override
  Widget build(BuildContext context) {
    return DropdownButton<int>(
      hint: Text('Select Year'),
      items: years.map((year) {
        return DropdownMenuItem<int>(
          value: year,
          child: Text(year.toString()),
        );
      }).toList(),
      onChanged: (value) {
        if (value != null) {
          onYearSelected(value);
        }
      },
    );
  }
}


// second version of this page
// class ReportPage extends StatefulWidget {
//   const ReportPage({super.key});
//
//   @override
//   State<ReportPage> createState() => _ReportPageState();
// }
//
// class _ReportPageState extends State<ReportPage> {
//   int? _selectedMonth;
//   double _totalExpenses = 0.0;
//   int? _selectedYear;
//   Map<int, double> _monthlyExpenses = {};
//
//   @override
//   void initState() {
//     super.initState();
//     final now = DateTime.now();
//     _selectedMonth = now.month;
//     _selectedYear = now.year;
//     _fetchData(); // Fetch default data
//   }
//
//   void _onMonthSelected(int month) {
//     setState(() {
//       _selectedMonth = month;
//       _selectedYear = null; // Clear selected year if month is selected
//       _fetchData();
//     });
//   }
//
//   void _onYearSelected(int year) {
//     setState(() {
//       _selectedYear = year;
//       _selectedMonth = null; // Clear selected month if year is selected
//       _fetchData();
//     });
//   }
//
//   void _fetchData() {
//     if (_selectedYear != null) {
//       _fetchYearlyExpenses();
//     } else if (_selectedMonth != null) {
//       _fetchTotalExpenses();
//     } else {
//       _fetchDefaultMonthExpenses();
//     }
//   }
//
//   void _fetchTotalExpenses() {
//     final provider = Provider.of<TransactionAmountProvider>(context, listen: false);
//     final aggregatedData = provider.getAggregatedDataByMonths(
//       TimePeriod.monthly,
//       selectedMonth: _selectedMonth,
//     );
//     setState(() {
//       _totalExpenses = aggregatedData.values.fold(0.0, (sum, amount) => sum + amount);
//       print('Total expenses for month @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@$_selectedMonth: $_totalExpenses'); // Debug print
//     });
//   }
//
//   void _fetchYearlyExpenses() {
//     final provider = Provider.of<TransactionAmountProvider>(context, listen: false);
//     final aggregatedData = provider.getAggregatedDataByYear(_selectedYear!);
//     setState(() {
//       _totalExpenses = aggregatedData.values.fold(0.0, (sum, amount) => sum + amount);
//       _monthlyExpenses = aggregatedData;
//       print('Yearly expenses for year@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ $_selectedYear: $_totalExpenses'); // Debug print
//     });
//   }
//
//   void _fetchDefaultMonthExpenses() {
//     final now = DateTime.now();
//     final provider = Provider.of<TransactionAmountProvider>(context, listen: false);
//     final aggregatedData = provider.getAggregatedDataByMonths(
//       TimePeriod.monthly,
//       selectedMonth: now.month,
//     );
//     setState(() {
//       _totalExpenses = aggregatedData.values.fold(0.0, (sum, amount) => sum + amount);
//       _selectedMonth = now.month; // Ensure default month is set
//       print('Default month expenses for current month@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ ${now.month}: $_totalExpenses'); // Debug print
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Expenses Report')),
//       body: Column(
//         children: [
//           YearSelector(onYearSelected: _onYearSelected),
//           SizedBox(height: 20),
//           MonthSelector(onMonthSelected: _onMonthSelected),
//           SizedBox(height: 20),
//           Text('Total Expenses: $_totalExpenses'),
//           if (_selectedYear != null)
//             Expanded(
//               child: ListView.builder(
//                 itemCount: _monthlyExpenses.length,
//                 itemBuilder: (context, index) {
//                   final month = _monthlyExpenses.keys.elementAt(index);
//                   final amount = _monthlyExpenses[month];
//                   return ListTile(
//                     title: Text('Month $month: ${amount ?? 0.0}'),
//                   );
//                 },
//               ),
//             ),
//         ],
//       ),
//     );
//   }
// }


// first version of this page
// class _ReportPageState extends State<ReportPage> {
//
//   int? _selectedMonth;
//   double _totalExpenses = 0.0;
//   int? _selectedYear;
//
//   Map<int, double> _monthlyExpenses = {};
//
//
//   @override
//   void initState() {
//     super.initState();
//     final now = DateTime.now();
//     _selectedMonth = now.month;
//     _selectedYear = now.year;
//     _fetchTotalExpenses();
//     _fetchYearlyExpenses();
//   }
//
//
//   void _onMonthSelected(int month) {
//     setState(() {
//       _selectedMonth = month;
//       _fetchTotalExpenses();
//     });
//   }
//
//   void _onYearSelected(int year) {
//     setState(() {
//       _selectedYear = year;
//       _fetchYearlyExpenses();
//     });
//   }
//
//   void _fetchTotalExpenses() {
//     final provider = Provider.of<TransactionAmountProvider>(context, listen: false);
//     final aggregatedData = provider.getAggregatedDataByMonths(
//       TimePeriod.monthly,
//       selectedMonth: _selectedMonth,
//     );
//     setState(() {
//       _totalExpenses = aggregatedData.values.fold(0.0, (sum, amount) => sum + amount);
//     });
//   }
//
//   void _fetchYearlyExpenses() {
//     final provider = Provider.of<TransactionAmountProvider>(context, listen: false);
//     final aggregatedData = provider.getAggregatedDataByYear(_selectedYear!);
//     setState(() {
//       _totalExpenses = aggregatedData.values.fold(0.0, (sum, amount) => sum + amount);
//       _monthlyExpenses = aggregatedData;
//     });
//   }
//
//
//
//   @override
//
//
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Expenses Report')),
//       body: Column(
//         children: [
//           YearSelector(onYearSelected: _onYearSelected),
//           SizedBox(height: 20),
//           MonthSelector(onMonthSelected: _onMonthSelected),
//           SizedBox(height: 20),
//           Text('Total Expenses: $_totalExpenses'),
//           if (_selectedYear != null)
//             Expanded(
//               child: ListView.builder(
//                 itemCount: _monthlyExpenses.length,
//                 itemBuilder: (context, index) {
//                   final month = _monthlyExpenses.keys.elementAt(index);
//                   final amount = _monthlyExpenses[month];
//                   return ListTile(
//                     title: Text('Month $month: ${amount ?? 0.0}'),
//                   );
//                 },
//               ),
//             ),
//         ],
//       ),
//     );
//   }
//
//
// }

