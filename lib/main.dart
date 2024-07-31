import 'package:flutter/material.dart';
import 'package:money_minder/provider/stats_periods_provider.dart';
import 'package:money_minder/provider/transaction_provider.dart';
import 'package:money_minder/res/colors/color_palette.dart';
import 'package:money_minder/screens/root_page.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider (

      providers: [
        ChangeNotifierProvider(create: ( context)=>TransactionAmountProvider()),
        ChangeNotifierProvider(create: ( context)=>StatsPeriodsProvider()),



      ],
      child:  MaterialApp(
          title: "Money Minder",
          debugShowCheckedModeBanner: false,
          // initialRoute: '/',
          // routes: {
          //   '/': (context) => const HomePage(),
          //   '/addTransaction': (context) => const AddingData(),
          // },

          theme: ThemeData(
              primaryColor: ColorsPalette.primaryColor,


              scaffoldBackgroundColor: ColorsPalette.backgroundLight,
              colorScheme: ColorScheme.fromSeed(seedColor: ColorsPalette.primaryColor),
              useMaterial3: false


          ),
          home: const RootPage()
      ),

    );

  }

}

// class MyHomePage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Home Screen', style: TextStyle(color: ColorsPalette.textPrimary)),
//         backgroundColor: ColorsPalette.primaryColor,
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             Text('Welcome to your Finance Manager', style: TextStyle(color: ColorsPalette.textSecondary)),
//             SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: () {},
//               style: ElevatedButton.styleFrom(backgroundColor: ColorsPalette.primaryDark),
//               child: Text('Add Expense', style: TextStyle(color: ColorsPalette.backgroundLight)),
//             ),
//             SizedBox(height: 10),
//             ElevatedButton(
//               onPressed: () {},
//               style: ElevatedButton.styleFrom(backgroundColor: ColorsPalette.secondaryColor),
//               child: Text('View Transactions', style: TextStyle(color: ColorsPalette.backgroundLight)),
//             ),
//             SizedBox(height: 10),
//             ElevatedButton(
//               onPressed: () {},
//               style: ElevatedButton.styleFrom(backgroundColor: ColorsPalette.accentColor),
//               child: Text('Set Budget', style: TextStyle(color: ColorsPalette.backgroundLight)),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// class BudgetSummaryCard extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       color: ColorsPalette.backgroundDark,
//       margin: EdgeInsets.all(10),
//       shape: RoundedRectangleBorder(
//         side: BorderSide(color: ColorsPalette.borderColor, width: 1),
//         borderRadius: BorderRadius.circular(10),
//       ),
//       child: Padding(
//         padding: EdgeInsets.all(20),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: <Widget>[
//             Text('Budget Summary', style: TextStyle(color: ColorsPalette.textPrimary, fontSize: 18)),
//             SizedBox(height: 10),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: <Widget>[
//                 Text('Groceries', style: TextStyle(color: ColorsPalette.textSecondary)),
//                 Text('\$150 / \$300', style: TextStyle(color: ColorsPalette.primaryDark)),
//               ],
//             ),
//             SizedBox(height: 5),
//             LinearProgressIndicator(
//               value: 0.8,
//               backgroundColor: ColorsPalette.primaryLight,
//               color: ColorsPalette.primaryDark,
//             ),
//             SizedBox(height: 10),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: <Widget>[
//                 Text('Entertainment', style: TextStyle(color: ColorsPalette.textSecondary)),
//                 Text('\$50 / \$100', style: TextStyle(color: ColorsPalette.secondaryColor)),
//               ],
//             ),
//             SizedBox(height: 5),
//             LinearProgressIndicator(
//               value: 0.2,
//               backgroundColor: ColorsPalette.secondaryLight,
//               color: ColorsPalette.secondaryColor,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// class ResponsiveText extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     double screenWidth = MediaQuery.of(context).size.width;
//
//     // Example scaling factor
//     double scaleFactor = screenWidth / 360; // 360 is a baseline width
//
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Home Screen', style: TextStyle(fontSize: 24 * scaleFactor, color: ColorsPalette.textPrimary)),
//         backgroundColor: ColorsPalette.primaryColor,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: <Widget>[
//             Text('Large Heading', style: TextStyle(fontSize: 28 * scaleFactor, color: ColorsPalette.textPrimary)),
//             SizedBox(height: 8),
//             Text('Medium Heading', style: TextStyle(fontSize: 24 * scaleFactor, color: ColorsPalette.textSecondary)),
//             SizedBox(height: 8),
//             Text('Small Heading', style: TextStyle(fontSize: 20 * scaleFactor, color: ColorsPalette.textPrimary)),
//             SizedBox(height: 16),
//             Text('Body Text', style: TextStyle(fontSize: 16 * scaleFactor, color: ColorsPalette.textSecondary)),
//             SizedBox(height: 8),
//             Text('Small Body Text', style: TextStyle(fontSize: 14 * scaleFactor, color: ColorsPalette.textPrimary)),
//             SizedBox(height: 16),
//             Text('Caption Text', style: TextStyle(fontSize: 12 * scaleFactor, color: ColorsPalette.textSecondary)),
//             SizedBox(height: 8),
//             Text('Overline Text', style: TextStyle(fontSize: 10 * scaleFactor, color: ColorsPalette.textPrimary)),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
