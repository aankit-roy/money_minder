
import 'package:flutter/material.dart';
import 'package:money_minder/res/colors/color_palette.dart';
import 'package:money_minder/res/constants/text_size.dart';



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
              const SizedBox(height: 16),
              _TopBar(),
              const SizedBox(height: 5),
              _TotalIncome(),
              const SizedBox(height: 18),
              HomeTabView(size: widget.size, tabController: widget.tabController),
            ],
          ),
        ),
      ),
    );
  }

  Widget _TotalIncome() {
    return const Center(
      child: Text(
        "${"₹10009876543"}",
        style: TextStyle(
          color: Colors.green,
          fontSize: TextSizes.mediumHeadingMax,
          fontWeight: FontWeight.w800,
        ),
      ),
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
            Icon(Icons.savings_outlined),
            SizedBox(width: 5,),
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

  HomeTabView({super.key, required this.size, required this.tabController});

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