import 'package:flutter/material.dart';
import 'package:money_minder/provider/general_provider.dart';
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
        ChangeNotifierProvider(create: (context)=> GeneralProvider())



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


