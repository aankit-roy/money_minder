import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:money_minder/res/colors/color_palette.dart';
import 'package:money_minder/screens/adding_data.dart';
import 'package:money_minder/screens/home_page.dart';
import 'package:money_minder/screens/profile_page.dart';
import 'package:money_minder/screens/stat_page.dart';
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';

class RootPage extends StatefulWidget {
  const RootPage({super.key});

  @override
  State<RootPage> createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {


  @override
  void initState() {
    super.initState();
    _initializeMobileAds();
  }

  Future<void> _initializeMobileAds() async {
    // Delay the MobileAds initialization until after the UI has loaded.
    await MobileAds.instance.initialize();
  }

  int bottomNavIndex = 0;
  List<Widget> pages = [
    const HomePage(),
    const StatPage(),
    // const ReportPage(),
    const ProfilePage()
  ];

  List<IconData> iconList = [
    Icons.home_filled,
    Icons.pie_chart,
    // Icons.list_alt_rounded,
    Icons.person
  ];
  List<String> titleList = ["Home", "Stats",  "Me"];
  DateTime? lastPressedAt;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return WillPopScope(
      onWillPop: () async {
        final now = DateTime.now();
        final backButtonHasNotBeenPressedOrSnackBarHasBeenClosed =
            lastPressedAt == null ||
                now.difference(lastPressedAt!) > const Duration(seconds: 2);

        if (backButtonHasNotBeenPressedOrSnackBarHasBeenClosed) {
          lastPressedAt = DateTime.now();
          // Show a snackbar with a message
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Press back again to exit'),
              duration: Duration(seconds: 2),
            ),
          );
          return Future.value(false);
        } else {
          return Future.value(true);
        }
      },
      child: Scaffold(
        body: IndexedStack(
          index: bottomNavIndex,
          children: pages,
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            showBottomSheet(context);
          },
          backgroundColor: ColorsPalette.primaryColor,
          child: const Icon(Icons.add),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
        bottomNavigationBar: AnimatedBottomNavigationBar(
          splashColor: ColorsPalette.primaryColor,
          activeColor: ColorsPalette.primaryColor,
          inactiveColor: ColorsPalette.textSecondary,
          icons: iconList,
          activeIndex: bottomNavIndex,
          gapLocation: GapLocation.end,
          height: size.height * .1,
          notchSmoothness: NotchSmoothness.sharpEdge,
          onTap: (index) {
            setState(() {
              bottomNavIndex = index;
            });
          },
        ),
      ),
    );
  }

  Future<dynamic> showBottomSheet(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: ColorsPalette.backgroundLight,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      builder: (context) => const FractionallySizedBox(
        heightFactor: 0.9,
        child: AddingData(),
      ),
    );
  }
}





