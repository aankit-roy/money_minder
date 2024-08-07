
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:money_minder/models/bar_chart_data.dart';
import 'package:money_minder/models/line_chart_datamodel.dart';
import 'package:money_minder/provider/transaction_provider.dart';
import 'package:money_minder/res/colors/color_palette.dart';
import 'package:money_minder/res/constants/currency_symbol.dart';
import 'package:money_minder/res/constants/text_size.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../ui/widgets/barchart_data.dart';
import '../ui/widgets/linechart_data.dart';


class ReportPage extends StatefulWidget {
  const ReportPage({super.key});

  @override
  State<ReportPage> createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Center(
        child: Text(
          "Report page",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 45
          ),
        ),
      ),


    );
  }






}






