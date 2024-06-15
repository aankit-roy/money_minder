
import 'package:flutter/material.dart';
import 'package:money_minder/res/colors/color_palette.dart';
import 'package:money_minder/res/constants/text_size.dart';

class CustomTransactionAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomTransactionAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(140);

  @override
  Widget build(BuildContext context) {
    return PreferredSize(
      preferredSize: preferredSize,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: const BoxDecoration(
          color: ColorsPalette.primaryLight,
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
        ),
        child: const SafeArea(
          child: Column(
            children: [
              SizedBox(height: 16),
              TopBar(),
              SizedBox(height: 40),
              CustomTabBar(),
            ],
          ),
        ),
      ),
    );
  }
}

class TopBar extends StatelessWidget {
  const TopBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: const Icon(
            Icons.arrow_back,
            color: ColorsPalette.textPrimary,
          ),
        ),
        const Text(
          "Add Transactions",
          style: TextStyle(fontSize: TextSizes.mediumHeadingMax),
        ),
        InkWell(
          onTap: () {},
          child: const Icon(Icons.date_range_outlined),
        ),
      ],
    );
  }
}

class CustomTabBar extends StatelessWidget {
  const CustomTabBar({super.key});

  @override
  Widget build(BuildContext context) {
    return const TabBar(
      labelColor: ColorsPalette.textPrimary,
      unselectedLabelColor: ColorsPalette.textSecondary,
      indicatorColor: ColorsPalette.white,
      indicatorWeight: 0,
      labelStyle: TextStyle(
        fontSize: TextSizes.smallHeadingMax,
        fontWeight: FontWeight.w400,
      ),
      indicator: BoxDecoration(
        color: ColorsPalette.white,
        borderRadius: BorderRadius.all(Radius.circular(30)),
      ),
      tabs: [
        Tab(text: "Expenses"),
        Tab(text: "Income"),
      ],
    );
  }
}
