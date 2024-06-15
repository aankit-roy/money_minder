
import 'dart:ui';

import 'package:flutter/cupertino.dart';

class Indicator extends StatelessWidget {
  final Color color;
   final String text;
  final bool isSquare;

  const Indicator({super.key,
    required this.color,
    required this.text,
    this.isSquare= false
  });

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }
}