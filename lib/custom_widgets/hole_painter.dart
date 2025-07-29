import 'package:flutter/material.dart';
import 'package:visaamigo/core/theme/theme.dart';

import '../utils/const_screen_size.dart';

class HolePainter extends CustomPainter {
  final List<Rect> highlightRects;
  final bool showHole; // NEW PARAM

  HolePainter(this.highlightRects, {this.showHole = true});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = VisaColors.tutorialBgColor.withValues(alpha: 0.9)
      ..style = PaintingStyle.fill;

    final path = Path()..addRect(Rect.fromLTRB(0, 0, size.width, size.height));

    if (showHole) {
      for (var rect in highlightRects) {
        path.addRRect(
            RRect.fromRectAndRadius(rect, Radius.circular(Sizes.twenty)));
      }
      path.fillType = PathFillType.evenOdd;
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant HolePainter oldDelegate) {
    return oldDelegate.highlightRects != highlightRects ||
        oldDelegate.showHole != showHole;
  }
}
