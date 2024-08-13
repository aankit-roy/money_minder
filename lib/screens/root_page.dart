import 'package:flutter/material.dart';
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
            SnackBar(
              content: const Text('Press back again to exit'),
              duration: const Duration(seconds: 2),
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

// Widget build(BuildContext context) {
//
//   Size size= MediaQuery.of(context).size;
//
//
//   return Scaffold(
//
//
//     body: IndexedStack(
//       index: bottomNavIndex,
//       children: pages,
//     ),
//
//     floatingActionButton:  FloatingActionButton(
//
//       onPressed: (){
//
//         ShoeBottomSheet(context);
//
//       },
//       backgroundColor: ColorsPalette.primaryColor,
//       child: const Icon(
//         Icons.add,
//
//       ),
//     ),
//     floatingActionButtonLocation:  FloatingActionButtonLocation.centerDocked,
//
//     bottomNavigationBar: AnimatedBottomNavigationBar(
//       splashColor: ColorsPalette.primaryColor,
//       activeColor: ColorsPalette.primaryColor,
//       inactiveColor: ColorsPalette.textSecondary,
//
//
//       icons: iconList,
//
//       activeIndex: bottomNavIndex,
//       gapLocation: GapLocation.center,
//       height: size.height *.1,
//
//
//       notchSmoothness: NotchSmoothness.sharpEdge,
//       onTap: (index){
//         setState(() {
//           bottomNavIndex=index;
//         });
//
//       },
//
//     ),
//
//
//   );
// }

Future<dynamic> ShoeBottomSheet(BuildContext context) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: ColorsPalette.backgroundLight,
    shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(30))),
    builder: (context) => const FractionallySizedBox(
      heightFactor: 0.9,
      // child: Center(child: Text("Bottom sheet")),
      child: AddingData(),
    ),
  );
}

// custom app bar
// return Scaffold(
//   body: IndexedStack(
//     index: bottomNavIndex,
//     children: pages,
//   ),
//   floatingActionButton: FloatingActionButton(
//     onPressed: () {
//       ShoeBottomSheet(context);
//     },
//     backgroundColor: ColorsPalette.primaryDark,
//     child: const Icon(Icons.add),
//   ),
//   floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
//   bottomNavigationBar: BottomAppBar(
//     child: Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: List.generate(4, (index) {
//         bool isSelected = bottomNavIndex == index;
//         return Expanded(
//           child: InkWell(
//             onTap: () {
//               setState(() {
//                 bottomNavIndex = index;
//               });
//             },
//             child: Container(
//               height: size.height * 0.1,
//               alignment: Alignment.center,
//               child: isSelected
//                   ? Container(
//                 width: 80,
//                 height: 60,
//
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(40.0),
//                   color: ColorsPalette.primaryColor.withOpacity(0.2),
//                 ),
//                 padding: EdgeInsets.all(8), // Adjust padding as needed
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Icon(
//                       iconList[index],
//                       color: ColorsPalette.primaryColor,
//                     ),
//                     SizedBox(height: 4), // Adjust spacing as needed
//                     Text(
//                       titleList[index],
//                       style: TextStyle(
//                         color: ColorsPalette.primaryColor,
//                         fontWeight: FontWeight.bold, // Optional: for emphasis
//                       ),
//                     ),
//                   ],
//                 ),
//               )
//                   : Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Icon(
//                     iconList[index],
//                     color: ColorsPalette.textSecondary,
//                   ),
//                   SizedBox(height: 4), // Adjust spacing as needed
//                   Text(
//                     titleList[index],
//                     style: TextStyle(
//                       color: ColorsPalette.textSecondary,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         );
//       }),
//     ),
//   ),
//
//
//
//
// );
