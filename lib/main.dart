  import 'package:flutter/material.dart';
  import 'package:flutter/services.dart';
  import 'package:google_mobile_ads/google_mobile_ads.dart';
  import 'package:money_minder/provider/general_provider.dart';
  import 'package:money_minder/provider/income_transaction_provider.dart';
  import 'package:money_minder/provider/stats_periods_provider.dart';
  import 'package:money_minder/provider/transaction_provider.dart';
  import 'package:money_minder/res/colors/color_palette.dart';
  import 'package:money_minder/screens/onboarding_page.dart';
  import 'package:money_minder/screens/root_page.dart';
  import 'package:provider/provider.dart';
  import 'package:rate_my_app/rate_my_app.dart';

  // void main() {
  //   WidgetsFlutterBinding.ensureInitialized();
  //   MobileAds.instance.initialize();
  //
  //   SystemChrome.setPreferredOrientations([
  //     DeviceOrientation.portraitUp,
  //     DeviceOrientation.portraitDown,
  //   ]);
  //
  //   runApp(const MyApp());
  // }
  //
  // class MyApp extends StatefulWidget {
  //   const MyApp({super.key});
  //
  //   @override
  //   _MyAppState createState() => _MyAppState();
  // }
  //
  // class _MyAppState extends State<MyApp> {
  //   bool _isLoading = true;
  //   bool _isFirstTime = false;
  //
  //   @override
  //   void initState() {
  //     super.initState();
  //     _checkFirstTimeOpen();
  //   }
  //
  //   Future<void> _checkFirstTimeOpen() async {
  //     final SharedPreferences prefs = await SharedPreferences.getInstance();
  //     final bool isFirstTime = prefs.getBool('isFirstTimeOpen') ?? true;
  //
  //     if (isFirstTime) {
  //       prefs.setBool('isFirstTimeOpen', false);
  //     }
  //
  //     // Simulate a delay (e.g., fetching data or initializing resources)
  //     // await Future.delayed(const Duration(seconds: 2));
  //
  //     setState(() {
  //       _isFirstTime = isFirstTime;
  //       _isLoading = false; // Finished loading, stop showing the indicator
  //     });
  //   }
  //
  //   @override
  //   Widget build(BuildContext context) {
  //     return MultiProvider(
  //       providers: [
  //         ChangeNotifierProvider(
  //             create: (context) => TransactionAmountProvider()),
  //         ChangeNotifierProvider(create: (context) => StatsPeriodsProvider()),
  //         ChangeNotifierProvider(create: (context) => GeneralProvider()),
  //         ChangeNotifierProvider(
  //             create: (context) => IncomeTransactionProvider()),
  //       ],
  //       child: MaterialApp(
  //         title: "Money Minder",
  //         debugShowCheckedModeBanner: false,
  //         theme: ThemeData(
  //           primaryColor: ColorsPalette.primaryColor,
  //           scaffoldBackgroundColor: ColorsPalette.backgroundLight,
  //           colorScheme:
  //               ColorScheme.fromSeed(seedColor: ColorsPalette.primaryColor),
  //           useMaterial3: false,
  //         ),
  //         home: _isLoading
  //             ? const Center(
  //                 child: CircularProgressIndicator(), // Show loading indicator
  //               )
  //             : _isFirstTime
  //                 ? const OnboardingScreen() // Show onboarding screen if first time
  //                 : const RootPage(), // Otherwise, show root page
  //       ),
  //     );
  //   }
  // }

  void main() async{
    WidgetsFlutterBinding.ensureInitialized();
    // MobileAds.instance.initialize();
     // Firebase.initializeApp();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    final bool isFirstTime = await checkFirstTimeOpen();
    runApp(MyApp(isFirstTime: isFirstTime));
    // runApp(const MyApp());
  }
  Future<bool> checkFirstTimeOpen() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final bool isFirstTime = prefs.getBool('isFirstTimeOpen') ?? true;
    if (isFirstTime) {
      prefs.setBool('isFirstTimeOpen', false);
    }
    return isFirstTime;
  }


  class MyApp extends StatelessWidget {
    final bool isFirstTime;

    const MyApp({super.key, required this.isFirstTime});

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
            home:  isFirstTime ? const OnboardingScreen() : const RootPage(),
        ),

      );

    }

  }
