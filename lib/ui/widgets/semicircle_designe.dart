import 'package:flutter/material.dart';

class SemiCirclePainter extends CustomPainter {
  final Color color;

  SemiCirclePainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final Rect rect = Rect.fromLTWH(0, 0, size.width, size.height);
    final Path path = Path()
      ..addArc(rect, 0, 3.14) // Semi-circle
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}