
import 'package:flutter/material.dart';
import 'package:money_minder/provider/general_provider.dart';
import 'package:money_minder/res/colors/color_palette.dart';
import 'package:money_minder/res/constants/text_size.dart';
import 'package:money_minder/ui/widgets/custome_period_button.dart';
import 'package:provider/provider.dart';



class CustomeHomeAppBar extends StatefulWidget implements PreferredSizeWidget {
  final Size size;
  final TabController tabController;

  const CustomeHomeAppBar({super.key, required this.size, required this.tabController});

  @override
  Size get preferredSize => const Size.fromHeight(140);

  @override
  _CustomeHomeAppBarState createState() => _CustomeHomeAppBarState();
}

class _CustomeHomeAppBarState extends State<CustomeHomeAppBar> {

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    final generalProvider= context.watch<GeneralProvider>();
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
              _buildExpensesIncomesButton(generalProvider,size),
            ],
          ),
        ),
      ),
    );
  }

  Widget _TotalIncome() {
    return const Center(
      child: Text(
        "₹10009876543",
        style: TextStyle(
          color: Colors.green,
          fontSize: TextSizes.mediumHeadingMax,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }

  Widget _buildExpensesIncomesButton(GeneralProvider generalProvider, Size size) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CustomPeriodButton(
          isSelected: generalProvider.isExpensesSelected,
          label: 'Expenses',
          onPressed: () {
            if (!generalProvider.isExpensesSelected) {
              generalProvider.toggleSelection();
            }
          },
        ),
        SizedBox(width: size.width*.1),
        CustomPeriodButton(
          isSelected: !generalProvider.isExpensesSelected,
          label: 'Income',
          onPressed: () {
            if (generalProvider.isExpensesSelected) {
              generalProvider.toggleSelection();
            }
          },
        ),
      ],
    );
  }

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

            Text(
              "Money Minder",
              style: TextStyle(
                fontSize: TextSizes.mediumHeadingMax,
                fontWeight: FontWeight.w800,
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
              child: const Icon(Icons.date_range_outlined)),
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

class HomeTabView extends StatelessWidget {
  final Size size;
  final TabController tabController;

  const HomeTabView({super.key, required this.size, required this.tabController});

  @override
  Widget build(BuildContext context) {
    return TabBar(
      controller: tabController,
      labelColor: ColorsPalette.textPrimary,
      unselectedLabelColor: ColorsPalette.textSecondary,
      indicatorColor: ColorsPalette.white,
      indicatorWeight: 0,
      labelStyle: const TextStyle(
        fontSize: TextSizes.smallHeadingMax,
        fontWeight: FontWeight.w400,
      ),
      indicator: const BoxDecoration(
        color: ColorsPalette.white,
        borderRadius: BorderRadius.all(Radius.circular(30)),
      ),
      tabs: const [
        Tab(text: "Expenses"),
        Tab(text: "Income"),
      ],
    );
  }
}