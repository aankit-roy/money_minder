
import 'package:flutter/material.dart';
import 'package:money_minder/res/colors/color_palette.dart';
import 'package:money_minder/res/constants/text_size.dart';

class CustomeHomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Size size;
  final TabController tabController;

  const CustomeHomeAppBar({super.key, required this.size, required this.tabController});

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
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 16),
              _TopBar(),
              const SizedBox(height: 45),
              HomeTabView(size: size, tabController: tabController),
            ],
          ),
        ),
      ),
    );
  }
}

class _TopBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        InkWell(
          onTap: () {},
          child: const Icon(
            Icons.search_rounded,
            color: ColorsPalette.textPrimary,
          ),
        ),
        const Text(
          "Money Minder",
          style: TextStyle(
            fontSize: TextSizes.mediumHeadingMax,
            fontWeight: FontWeight.w400,
          ),
        ),
        InkWell(
          onTap: () {},
          child: const Icon(Icons.date_range_outlined),
        ),
      ],
    );
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