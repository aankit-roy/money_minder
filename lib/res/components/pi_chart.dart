
import 'package:fl_chart/fl_chart.dart';

import 'package:flutter/material.dart';
import 'package:money_minder/res/colors/color_palette.dart';
import 'package:money_minder/res/components/indicator.dart';

class PieChartSample2 extends StatefulWidget {
  const PieChartSample2({super.key});

  @override
  State<StatefulWidget> createState() => PieChart2State();
}

class PieChart2State extends State {
  int touchedIndex = -1;


  @override
  Widget build(BuildContext context) {
    return Row(

      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        const SizedBox(
          height: 18,
        ),
        Container(
          height: 100,
          width: 100,
          child: PieChart(
            PieChartData(
              pieTouchData: PieTouchData(
                touchCallback: (FlTouchEvent event, pieTouchResponse) {
                  setState(() {
                    if (!event.isInterestedForInteractions ||
                        pieTouchResponse == null ||
                        pieTouchResponse.touchedSection == null) {
                      touchedIndex = -1;
                      return;
                    }
                    touchedIndex = pieTouchResponse
                        .touchedSection!.touchedSectionIndex;
                  });
                },
              ),
              borderData: FlBorderData(
                show: false,

              ),
              sectionsSpace: 0,
              centerSpaceRadius: 50,
              startDegreeOffset: 1000,

              sections: showingSections(),
            ),
          ),
        ),
        // const Column(
        //
        //   children: <Widget>[
        //
        //     Indicator(color: ColorsPalette.primaryDark,text: "first",isSquare: true),
        //
        //     SizedBox(
        //       height: 4,
        //     ),
        //     Indicator(
        //       color:  Colors.green,
        //       text: 'Second',
        //       isSquare: true,
        //     ),
        //     SizedBox(
        //       height: 4,
        //     ),
        //     Indicator(
        //       color:  Colors.orange,
        //       text: 'Third',
        //       isSquare: true,
        //     ),
        //     SizedBox(
        //       height: 4,
        //     ),
        //     Indicator(
        //       color: Colors.blue,
        //       text: 'Fourth',
        //       isSquare: true,
        //     ),
        //     SizedBox(
        //       height: 18,
        //     ),
        //   ],
        // ),

      ],
    );
  }

  List<PieChartSectionData> showingSections() {
    return List.generate(4, (i) {
      final isTouched = i == touchedIndex;
      final fontSize = isTouched ? 25.0 : 16.0;
      final radius = isTouched ? 60.0 : 50.0;
      const shadows = [Shadow(color: Colors.black, blurRadius: 2)];
      switch (i) {
        case 0:
          return PieChartSectionData(
            color: Colors.blue,
            value: 4,
            title: '40%',
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: ColorsPalette.textPrimary,
              shadows: shadows,
            ),
          );
        case 1:
          return PieChartSectionData(
            color: Colors.red,
            value: 30,
            title: '30%',
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: ColorsPalette.textPrimary,
              shadows: shadows,
            ),
          );
        case 2:
          return PieChartSectionData(
            color: Colors.amber,
            value: 15,
            title: '15%',
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: ColorsPalette.textPrimary,
              shadows: shadows,
            ),
          );
        case 3:
          return PieChartSectionData(
            color: Colors.deepPurple,
            value: 15,
            title: '15%',
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: ColorsPalette.textPrimary,
              shadows: shadows,
            ),
          );
        default:
          throw Error();
      }
    });
  }
}

