import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:money_minder/provider/general_provider.dart';
import 'package:money_minder/res/colors/color_palette.dart';
import 'package:money_minder/res/constants/text_size.dart';
import 'package:money_minder/ui/widgets/custome_period_button.dart';
import 'package:provider/provider.dart';

class CustomeHomeAppBar extends StatefulWidget implements PreferredSizeWidget {

  double appBarHeight;

   CustomeHomeAppBar(
      {super.key,   required this.appBarHeight});

  @override
  Size get preferredSize =>  Size.fromHeight(appBarHeight);

  @override
  _CustomeHomeAppBarState createState() => _CustomeHomeAppBarState();
}

class _CustomeHomeAppBarState extends State<CustomeHomeAppBar> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    final generalProvider = context.watch<GeneralProvider>();
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
            children: [
              const SizedBox(height: 15),
              _TopBar(),
              const SizedBox(height: 20),
              // _TotalIncome(),

              // HomeTabView(size: widget.size, tabController: widget.tabController),
              _buildExpensesIncomesButton(generalProvider, size),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildExpensesIncomesButton(
      GeneralProvider generalProvider, Size size) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Flexible(

          child: CustomPeriodButton(
            isSelected: generalProvider.isExpensesSelected,
            label: 'Expenses',
            onPressed: () {
              if (!generalProvider.isExpensesSelected) {
                generalProvider.toggleSelection();
              }
            },
          ),
        ),
        SizedBox(width: size.width * .05),
        Flexible(

          child: CustomPeriodButton(
            isSelected: !generalProvider.isExpensesSelected,
            label: 'Income',
            onPressed: () {
              if (generalProvider.isExpensesSelected) {
                generalProvider.toggleSelection();
              }
            },
          ),
        ),
      ],
    );
  }
}

class _TopBar extends StatefulWidget {
  @override
  _TopBarState createState() => _TopBarState();
}

class _TopBarState extends State<_TopBar> {
  DateTime selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    // Format the current month and year
    String formattedMonth =
        DateFormat('MMM').format(selectedDate); // Short month
    String formattedYear = DateFormat('yyyy').format(selectedDate); // Year
    // Format the current date as day.month.year
    String formattedDate = DateFormat('dd.MM.yyyy').format(selectedDate);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Display current month and year
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              formattedMonth, // Short month
              style: const TextStyle(
                fontSize: TextSizes.mediumHeadingMax,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              formattedYear, // Year
              style: const TextStyle(
                fontSize: TextSizes.mediumHeadingMin,
                fontWeight: FontWeight.w300,
              ),
            ),
          ],
        ),
        const Expanded(
          child: Center(
            child: Text(
              "Money Minder",
              style: TextStyle(
                fontSize: TextSizes.mediumHeadingMax,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
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
