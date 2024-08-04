import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:money_minder/provider/stats_periods_provider.dart';
import 'package:money_minder/res/colors/color_palette.dart';
import 'package:money_minder/res/constants/text_size.dart';
import 'package:provider/provider.dart';

class StatAppBar extends StatefulWidget implements PreferredSizeWidget {

  final Size size;
  final ValueChanged<String>? onMonthSelected;
  final ValueChanged<String>? onYearSelected;

  const StatAppBar({
    super.key,
    required this.size,
    this.onMonthSelected,
    this.onYearSelected,
  });

  // final Size size;
  // // final VoidCallbackAction clickPeriod;
  //
  // const StatAppBar({super.key, required this.size, });

  @override
  Size get preferredSize => const Size.fromHeight(140);

  @override
  _StatAppBarState createState() => _StatAppBarState();
}

class _StatAppBarState extends State<StatAppBar> {
  String selectedPeriod = 'Monthly'; // Default selection
  String? selectedMonth; // Store the selected month
  String? selectedYear;  // Store the selected year

  @override
  void initState() {
    super.initState();
    // Initialize the default selected month and year
    final now = DateTime.now();
    // selectedMonth = 'This Month/${now.year}';
    // Set default selected values without special labels
    selectedMonth = '${_monthNames[now.month - 1]}/${now.year}';
    selectedYear = now.year.toString(); // Default to current year
    // selectedYear = 'This Year';
  }

  // List of month names
  final List<String> _monthNames = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
  ];



  @override
  Widget build(BuildContext context) {
    return PreferredSize(
      preferredSize: widget.preferredSize,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: const BoxDecoration(
          color: ColorsPalette.primaryLight,
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
        ),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _PeriodSelector(),
              const SizedBox(height: 10,),
              _buildHorizontalList(),
            ],
          ),
        ),
      ),
    );
  }



  Widget _PeriodSelector() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _buildPeriodButton('Monthly'),
        const SizedBox(width: 30),
        _buildPeriodButton('Yearly'),
      ],
    );
  }


  Widget _buildPeriodButton(String period) {
    bool isSelected = period == selectedPeriod;
    return ElevatedButton(
      onPressed: () {
        setState(() {
          selectedPeriod = period;
        });
        if (period == 'Monthly' && widget.onMonthSelected != null) {
          widget.onMonthSelected!(selectedMonth ?? '');
        } else if (period == 'Yearly' && widget.onYearSelected != null) {
          widget.onYearSelected!(selectedYear ?? '');
        }
      },
      style: ElevatedButton.styleFrom(
        foregroundColor: isSelected ? ColorsPalette.white : ColorsPalette.textPrimary,
        backgroundColor: isSelected ? ColorsPalette.primaryDark : ColorsPalette.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      ),
      child: Text(
        period,
        style: TextStyle(
          fontSize: TextSizes.mediumHeadingMax,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
  //
  // Widget _buildHorizontalList() {
  //   List<String> items;
  //
  //   if (selectedPeriod == 'Monthly') {
  //     items = List.generate(13, (index) {
  //       final month = DateTime.now().subtract(Duration(days: 30 * index));
  //       String label = '${_monthNames[month.month - 1]}/${month.year}';
  //       if (index == 0) {
  //         label = 'This Month/${month.year}';
  //       } else if (index == 1) {
  //         label = 'Last Month/${month.year}';
  //       }
  //       return label;
  //     }).reversed.toList();
  //   } else {
  //     items = List.generate(13, (index) {
  //       final year = DateTime.now().year - index;
  //       String label = year.toString();
  //       if (index == 0) {
  //         label = year.toString();
  //       }
  //       return label;
  //     }).reversed.toList();
  //   }
  //
  //   return SizedBox(
  //     height: 50,
  //     child: ListView.builder(
  //       scrollDirection: Axis.horizontal,
  //       itemCount: items.length,
  //       itemBuilder: (context, index) {
  //         return Container(
  //           margin: const EdgeInsets.symmetric(horizontal: 8),
  //           child: ChoiceChip(
  //             label: Text(items[index]),
  //             selected: selectedPeriod == 'Monthly'
  //                 ? items[index] == selectedMonth
  //                 : items[index] == selectedYear,
  //             onSelected: (isSelected) {
  //               setState(() {
  //                 if (selectedPeriod == 'Monthly') {
  //                   selectedMonth = isSelected ? items[index] : selectedMonth;
  //                   widget.onMonthSelected?.call(selectedMonth!);
  //                 } else {
  //                   selectedYear = isSelected ? items[index] : selectedYear;
  //                   widget.onYearSelected?.call(selectedYear!);
  //                 }
  //               });
  //               context.read<StatsPeriodsProvider>().updateSelection(
  //                 selectedPeriod,
  //                 selectedMonth ?? '',
  //                 selectedYear ?? '',
  //               );
  //             },
  //             backgroundColor: Colors.grey[200],
  //             selectedColor: Colors.blue,
  //             labelStyle: TextStyle(
  //               color: Colors.black,
  //               fontSize: 16,
  //             ),
  //             shape: RoundedRectangleBorder(
  //               borderRadius: BorderRadius.circular(20),
  //             ),
  //           ),
  //         );
  //       },
  //     ),
  //   );
  // }


  Widget _buildHorizontalList() {
    List<String> items;

    if (selectedPeriod == 'Monthly') {
      items = List.generate(12, (index) {
        final month = DateTime.now().subtract(Duration(days: 30 * index));
        return '${_monthNames[month.month - 1]}/${month.year}';
      }).reversed.toList();
    } else {
      items = List.generate(13, (index) {
        final year = DateTime.now().year - index;
        return year.toString();
      }).reversed.toList();
    }

    return SizedBox(
      height: 50,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: items.length,
        itemBuilder: (context, index) {
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 8),
            child: ChoiceChip(
              label: Text(items[index]),
              selected: selectedPeriod == 'Monthly'
                  ? items[index] == selectedMonth
                  : items[index] == selectedYear,
              onSelected: (isSelected) {
                setState(() {
                  if (selectedPeriod == 'Monthly') {
                    selectedMonth = isSelected ? items[index] : selectedMonth;
                    widget.onMonthSelected?.call(selectedMonth!);
                  } else {
                    selectedYear = isSelected ? items[index] : selectedYear;
                    widget.onYearSelected?.call(selectedYear!);
                  }
                });
                context.read<StatsPeriodsProvider>().updateSelection(
                  selectedPeriod,
                  selectedMonth ?? '',
                  selectedYear ?? '',
                );
              },
              backgroundColor: Colors.grey[200],
              selectedColor: Colors.blue,
              labelStyle: TextStyle(
                color: Colors.black,
                fontSize: 16,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          );
        },
      ),
    );
  }





  //   Widget _buildPeriodButton(String period) {
  //   bool isSelected = period == selectedPeriod;
  //   return ElevatedButton(
  //     onPressed: () {
  //       setState(() {
  //         selectedPeriod = period;
  //         if (period == 'Monthly') {
  //           // Default to current month
  //           final now = DateTime.now();
  //           selectedMonth = 'This Month/${now.year}';
  //         } else if (period == 'Yearly') {
  //           // Default to current year
  //           final now = DateTime.now();
  //           selectedYear = now.year.toString();
  //         }
  //       });
  //     },
  //     style: ElevatedButton.styleFrom(
  //       foregroundColor: isSelected ? ColorsPalette.white : ColorsPalette.textPrimary, backgroundColor: isSelected ? ColorsPalette.primaryDark : ColorsPalette.white,
  //       shape: RoundedRectangleBorder(
  //         borderRadius: BorderRadius.circular(20),
  //       ),
  //       padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
  //     ),
  //     child: Text(
  //       period,
  //       style: TextStyle(
  //         fontSize: TextSizes.mediumHeadingMax,
  //         fontWeight: FontWeight.w600,
  //       ),
  //     ),
  //   );
  // }
  //
  //
  // Widget _buildHorizontalList() {
  //   List<String> items;
  //
  //   if (selectedPeriod == 'Monthly') {
  //     items = List.generate(13, (index) {
  //       final month = DateTime.now().subtract(Duration(days: 30 * index));
  //       String label = '${_monthNames[month.month - 1]}/${month.year}';
  //       if (index == 0) {
  //         label = 'This Month/${month.year}';
  //       } else if (index == 1) {
  //         label = 'Last Month/${month.year}';
  //       }
  //       return label;
  //     }).reversed.toList();
  //   } else {
  //     items = List.generate(13, (index) {
  //       final year = DateTime.now().year - index;
  //       return year.toString();
  //     }).reversed.toList();
  //
  //   }
  //   // Set default selection based on the period
  //   String? defaultSelectedItem;
  //   if (selectedPeriod == 'Yearly') {
  //     defaultSelectedItem = DateTime.now().year.toString();
  //   }
  //
  //
  //   return SizedBox(
  //     height: 50, // Adjust as needed
  //     child: ListView.builder(
  //       scrollDirection: Axis.horizontal,
  //       itemCount: items.length,
  //       itemBuilder: (context, index) {
  //         return Container(
  //           margin: const EdgeInsets.symmetric(horizontal: 8),
  //           child: ChoiceChip(
  //             label: Text(items[index]),
  //             selected: (selectedPeriod == 'Monthly'
  //                 ? items[index] == selectedMonth
  //                 : items[index] == selectedYear) || (selectedPeriod == 'Yearly' && items[index] == defaultSelectedItem),
  //             onSelected: (isSelected) {
  //               setState(() {
  //                 if (selectedPeriod == 'Monthly') {
  //                   selectedMonth = isSelected ? items[index] : selectedMonth;
  //                 } else {
  //                   selectedYear = isSelected ? items[index] : selectedYear;
  //                 }
  //               });
  //               // Notify the provider of the selection change
  //               context.read<StatsPeriodsProvider>().updateSelection(selectedPeriod, selectedMonth ?? '', selectedYear ?? '');
  //             },
  //             backgroundColor: Colors.grey[200],
  //             selectedColor: Colors.blue,
  //             labelStyle: TextStyle(
  //               color: Colors.black,
  //               fontSize: 16,
  //             ),
  //             shape: RoundedRectangleBorder(
  //               borderRadius: BorderRadius.circular(20),
  //             ),
  //           ),
  //         );
  //       },
  //     ),
  //   );
  //
  //   // return SizedBox(
  //   //   height: 50, // Adjust as needed
  //   //   child: ListView.builder(
  //   //     scrollDirection: Axis.horizontal,
  //   //     itemCount: items.length,
  //   //     itemBuilder: (context, index) {
  //   //       return Container(
  //   //         margin: const EdgeInsets.symmetric(horizontal: 8),
  //   //         child: ChoiceChip(
  //   //           label: Text(items[index]),
  //   //           selected: selectedPeriod == 'Monthly'
  //   //               ? items[index] == selectedMonth
  //   //               : items[index] == selectedYear,
  //   //           onSelected: (isSelected) {
  //   //             setState(() {
  //   //               if (selectedPeriod == 'Monthly') {
  //   //                 selectedMonth = isSelected ? items[index] : selectedMonth;
  //   //               } else {
  //   //                 selectedYear = isSelected ? items[index] : selectedYear;
  //   //               }
  //   //             });
  //   //             // Notify the provider of the selection change
  //   //             context.read<StatsPeriodsProvider>().updateSelection(selectedPeriod, selectedMonth ?? '', selectedYear ?? '');
  //   //           },
  //   //           backgroundColor: Colors.grey[200],
  //   //           selectedColor: Colors.blue,
  //   //           labelStyle: TextStyle(
  //   //             color: Colors.black,
  //   //             fontSize: 16,
  //   //           ),
  //   //           shape: RoundedRectangleBorder(
  //   //             borderRadius: BorderRadius.circular(20),
  //   //           ),
  //   //         ),
  //   //       );
  //   //     },
  //   //   ),
  //   // );
  // }


  // Widget _buildHorizontalList() {
  //   List<String> items;
  //
  //   if (selectedPeriod == 'Monthly') {
  //     items = List.generate(13, (index) {
  //       final month = DateTime.now().subtract(Duration(days: 30 * index));
  //       String label = '${_monthNames[month.month - 1]}/${month.year}';
  //       if (index == 0) {
  //         label = 'This Month/${month.year}';
  //       } else if (index == 1) {
  //         label = 'Last Month/${month.year}';
  //       }
  //       return label;
  //     }).reversed.toList();
  //   } else {
  //     items = List.generate(13, (index) {
  //       final year = DateTime.now().year - index;
  //       String label = year.toString();
  //       if (index == 0) {
  //         label = 'This Year';
  //       }
  //       return label;
  //     }).reversed.toList();
  //   }
  //
  //   return SizedBox(
  //     height: 50, // Adjust as needed
  //     child: ListView.builder(
  //       scrollDirection: Axis.horizontal,
  //       itemCount: items.length,
  //       itemBuilder: (context, index) {
  //         return Container(
  //           margin: const EdgeInsets.symmetric(horizontal: 8),
  //           child: ChoiceChip(
  //             label: Text(items[index]),
  //             selected: selectedPeriod == 'Monthly'
  //                 ? items[index] == selectedMonth
  //                 : items[index] == selectedYear,
  //             onSelected: (isSelected) {
  //               setState(() {
  //                 if (selectedPeriod == 'Monthly') {
  //                   selectedMonth = isSelected ? items[index] : selectedMonth;
  //                 } else {
  //                   selectedYear = isSelected ? items[index] : selectedYear;
  //                 }
  //               });
  //               // Notify the provider of the selection change
  //               // context.read<StatsPeriodsProvider>().updateSelection(selectedPeriod, selectedMonth!, selectedYear!);
  //               context.read<StatsPeriodsProvider>().updateSelection(selectedPeriod, selectedMonth ?? '', selectedYear ?? '');
  //             },
  //             backgroundColor: Colors.grey[200],
  //             selectedColor: Colors.blue,
  //             labelStyle: TextStyle(
  //               color: Colors.black,
  //               fontSize: 16,
  //             ),
  //             shape: RoundedRectangleBorder(
  //               borderRadius: BorderRadius.circular(20),
  //             ),
  //           ),
  //         );
  //       },
  //     ),
  //   );
  // }












}

class _TopBar extends StatefulWidget {
  @override
  State<_TopBar> createState() => _TopBarState();
}

class _TopBarState extends State<_TopBar> {
  DateTime selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        InkWell(
          onTap: () {
            // Implement search functionality
          },
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 8),
            child: const Icon(
              Icons.search_rounded,
              color: ColorsPalette.textPrimary,
            ),
          ),
        ),
        const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.savings_outlined),
            SizedBox(width: 5),
            Text(
              "Total",
              style: TextStyle(
                fontSize: TextSizes.mediumHeadingMax,
                fontWeight: FontWeight.w300,
              ),
            ),
          ],
        ),
        InkWell(
          onTap: () {
            _selectDate(context);
          },
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 8),
            child: const Icon(Icons.date_range_outlined),
          ),
        ),
      ],
    );
  }

  void _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }


}