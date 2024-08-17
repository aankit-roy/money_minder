

import 'package:flutter/material.dart';

class TextScaleFactor {
  static double scale(BuildContext context) {
    // Get the screen width
    double screenWidth = MediaQuery.of(context).size.width;

    // Define a base width for reference (e.g., 375.0, the width of an iPhone X)
    double baseWidth = 375.0;

    // Calculate the scale factor
    return screenWidth / baseWidth;
  }
}