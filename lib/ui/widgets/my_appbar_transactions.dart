
import 'package:flutter/material.dart';
import 'package:money_minder/res/colors/color_palette.dart';
import 'package:money_minder/res/constants/text_size.dart';

class MyAppBarTransactions extends StatelessWidget {
  const MyAppBarTransactions({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration:   const BoxDecoration(
          color: ColorsPalette.primaryLight,
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(30))
      ),
      child: SafeArea(
        child: Column(
          children: [
            const SizedBox(
              height: 16,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: const Icon(
                      Icons.arrow_back,
                      color: ColorsPalette.textPrimary,
                    )),
                const Text(
                  "Add Transactions",
                  style:
                  TextStyle(fontSize: TextSizes.mediumHeadingMax),
                ),
                InkWell(
                    onTap: () {},
                    child: const Icon(Icons.date_range_outlined))
              ],
            ),
            const SizedBox(
              height: 40,
            ),
            const TabBar(
              labelColor: ColorsPalette.textPrimary,
              unselectedLabelColor: ColorsPalette.textSecondary,
              indicatorColor: ColorsPalette.white,
              indicatorWeight: 0,
              labelStyle: TextStyle(
                  fontSize: TextSizes.smallHeadingMax,
                  fontWeight: FontWeight.w400),
              indicator: BoxDecoration(
                  color: ColorsPalette.white,
                  borderRadius:
                  BorderRadius.all(Radius.circular(30))),
              tabs: [
                Tab(
                  text: "Expenses",
                ),
                Tab(
                  text: "Income",
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}