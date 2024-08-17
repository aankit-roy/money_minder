import 'package:flutter/cupertino.dart';
import 'package:money_minder/res/constants/text_size.dart';

class FormattedValueWidget extends StatelessWidget {
  final double value;
  final Color color;

  const FormattedValueWidget({
    super.key,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final String formattedValue = formatValue(value);

    return Text(
      formattedValue,
      style: TextStyle(
          fontSize: TextSizes.smallHeadingMax(context),
          fontWeight: FontWeight.w500,
          color: color),

    );
  }

  String formatValue(double value) {
    if (value >= 1000000) {
      return '${(value / 1000000).toStringAsFixed(1)}M'; // For millions
    } else if (value >= 1000) {
      return '${(value / 1000).toStringAsFixed(1)}K'; // For thousands
    } else {
      return value.toStringAsFixed(2); // For values less than 1000
    }
  }
}