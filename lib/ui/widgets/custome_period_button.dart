

import 'package:flutter/material.dart';
import 'package:money_minder/res/colors/color_palette.dart';
import 'package:money_minder/res/constants/text_size.dart';
import 'package:path/path.dart';

class CustomPeriodButton extends StatelessWidget {
  final bool isSelected;
  final String label;
  final VoidCallback onPressed;

  const CustomPeriodButton({
    super.key,
    required this.isSelected,
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: isSelected ? ColorsPalette.primaryDark : Colors.white,
        foregroundColor: isSelected ? ColorsPalette.white : ColorsPalette.textPrimary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      ),
      child: Text(
        label,
        style:  TextStyle(
          fontSize: TextSizes.mediumHeadingMax(context),
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}