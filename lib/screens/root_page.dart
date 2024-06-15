
import 'package:flutter/material.dart';
import 'package:money_minder/res/colors/color_palette.dart';
import 'package:money_minder/screens/adding_data.dart';
import 'package:money_minder/screens/home_page.dart';
import 'package:money_minder/screens/profile_page.dart';
import 'package:money_minder/screens/report_page.dart';
import 'package:money_minder/screens/stat_page.dart';
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:page_transition/page_transition.dart';
import 'package:money_minder/ui/widgets/custome_Tran_add_app_bar.dart';

class RootPage extends StatefulWidget {
  const RootPage({super.key});

  @override
  State<RootPage> createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {

  int bottomNavIndex=0;

  List<Widget> pages=[
    HomePage(),
    StatPage(),
    ReportPage(),
    ProfilePage()

  ];

  List<IconData> iconList=[
    Icons.home_filled,
    Icons.pie_chart,
    Icons.list_alt_rounded,
    Icons.person
  ];
  List<String> titleList = ["Home", "Stats", "Reports", "Me"];
  @override
  Widget build(BuildContext context) {

    Size size= MediaQuery.of(context).size;
    return Scaffold(


      body: IndexedStack(
        index: bottomNavIndex,
        children: pages,
      ),

      floatingActionButton:  FloatingActionButton(

        onPressed: (){
          Navigator.push(context, PageTransition(type: PageTransitionType.bottomToTop, child: const AddingData()));

        },
        backgroundColor: ColorsPalette.primaryColor,
        child: const Icon(
          Icons.add,

        ),
      ),
      floatingActionButtonLocation:  FloatingActionButtonLocation.centerDocked,

      bottomNavigationBar: AnimatedBottomNavigationBar(
        splashColor: ColorsPalette.primaryColor,
        activeColor: ColorsPalette.primaryColor,
        inactiveColor: ColorsPalette.textSecondary,


        icons: iconList,

        activeIndex: bottomNavIndex,
        gapLocation: GapLocation.center,
        height: size.height *.1,


        notchSmoothness: NotchSmoothness.sharpEdge,
        onTap: (index){
          setState(() {
            bottomNavIndex=index;
          });

        },

      ),


    );
  }
}
