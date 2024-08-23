import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:money_minder/provider/general_provider.dart';
import 'package:money_minder/provider/income_transaction_provider.dart';
import 'package:money_minder/provider/stats_periods_provider.dart';
import 'package:money_minder/provider/transaction_provider.dart';
import 'package:money_minder/res/colors/color_palette.dart';
import 'package:money_minder/screens/onboarding_page.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();
   // Firebase.initializeApp();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
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
        ChangeNotifierProvider(create: (context)=> GeneralProvider()),
        ChangeNotifierProvider(create: (context)=> IncomeTransactionProvider()),




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
          home: const OnboardingScreen(),
      ),

    );

  }

}


