import 'dart:ui';

import 'package:flutter/material.dart';

class VisaBlurEffectWidget extends StatelessWidget {
  final double width;
  final double height;
  final List<Color> listColors;
  final AlignmentGeometry alignementEnd;

  const VisaBlurEffectWidget({
    super.key,
    this.width = double.infinity,
    this.height = 100.0,
    this.alignementEnd = Alignment.bottomCenter,
    this.listColors = const [
      Colors.transparent,
    ],
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.topCenter,
          colors: listColors,
        ),
      ),
      child: ClipRRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: 4,
            sigmaY: 4,
          ),
          // Adjust for stronger blur
          child: Container(
            width: width,
            height: height,
            color: Colors.transparent,
          ),
        ),
      ),
    );
  }
}
