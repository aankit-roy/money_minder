import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:rate_my_app/rate_my_app.dart';

class RateMyAppWidget extends StatefulWidget {
   RateMyAppWidget({Key? key}) : super(key: key);

  @override
  _RateMyAppWidgetState createState() => _RateMyAppWidgetState();
}

class _RateMyAppWidgetState extends State<RateMyAppWidget> {
  late final RateMyApp _rateMyApp;

  @override
  void initState() {
    super.initState();
    _rateMyApp = RateMyApp(
      googlePlayIdentifier: 'app.openauthenticator',
      appStoreIdentifier: '6479272927',
    );

    // Initialize RateMyApp and check conditions
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // _rateMyApp.requestReviewIfConditionsMet();
      _checkConditions();
    });
  }

  void _checkConditions() {
    for (Condition condition in _rateMyApp.conditions) {
      if (condition is DebuggableCondition) {
        condition.printToConsole(); // Print debuggable conditions
      }
    }

    if (kDebugMode) {
      print('Are all conditions met : ${_rateMyApp.shouldOpenDialog ? 'Yes' : 'No'}');
    }

    if (_rateMyApp.shouldOpenDialog) {
      _rateMyApp.showRateDialog(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return const SizedBox.shrink(); // This widget does not render anything
  }
}