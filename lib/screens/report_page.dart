
import 'package:flutter/material.dart';

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






