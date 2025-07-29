import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// POC Class not in use
class Card3DRotateOnDrag extends StatefulWidget {
  @override
  Card3DRotateOnDragState createState() => Card3DRotateOnDragState();
}

class Card3DRotateOnDragState extends State<Card3DRotateOnDrag> {
  double _rotationY = 0.0;

  // Max rotation angle in radians (~30 degrees)
  final double maxRotation = pi / 6;

  void _onHorizontalDragUpdate(DragUpdateDetails details) {
    setState(() {
      // Normalize drag delta to a rotation value
      _rotationY -= details.delta.dx * 0.05;
      // Clamp rotation to maxRotation limits
      // _rotationZ = _rotationZ.clamp(-maxRotation, maxRotation);
    });
  }

  void _onHorizontalDragEnd(DragEndDetails details) {
    // Animate back to zero rotation when drag ends
    // For simplicity, reset instantly here
    setState(() {
      _rotationY = 0.0;
    });
  }

  bool isBackFacing() {
    // Normalize _rotationY between 0 and 2π
    double normalizedRotation = _rotationY % (2 * pi);

    // If normalizedRotation is between π/2 and 3π/2, consider it back-facing
    return normalizedRotation > (pi / 2) && normalizedRotation < (3 * pi / 2);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragUpdate: _onHorizontalDragUpdate,
      child: Transform(
        alignment: Alignment.center,
        transform: Matrix4.identity()
          ..setEntry(3, 2, 0.001) // perspective
          ..rotateY(_rotationY),
        child: Container(
          width: 250,
          height: 150,
          decoration: BoxDecoration(
            color: Colors.blueAccent,
            borderRadius: BorderRadius.circular(16),
            boxShadow: const [
              BoxShadow(
                color: Colors.black45,
                blurRadius: 12,
                offset: Offset(0, 8),
              ),
            ],
          ),
          alignment: Alignment.center,
          child: isBackFacing()
              ? Transform(
                  alignment: Alignment.center,
                  transform: Matrix4.identity()..rotateY(pi),
                  child: Text(
                    'Back Side',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                )
              : Text(
                  'Front Side',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
        ),
      ),
    );
  }
}
