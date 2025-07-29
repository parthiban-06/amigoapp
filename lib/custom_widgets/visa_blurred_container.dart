import 'dart:ui';

import 'package:flutter/material.dart';

class VisaBlurredContainer extends StatelessWidget {
  final String imagePath;
  final double blurX;
  final double blurY;
  final double opacity;
  final double width;
  final double height;
  final bool isTransformImage;

  const VisaBlurredContainer({
    super.key,
    required this.imagePath,
    this.blurX = 10.0, // Stronger blur effect
    this.blurY = 10.0,
    this.opacity = 0.9, // Makes image slightly transparent
    this.width = double.infinity,
    this.isTransformImage = false,
    this.height = 200, // Ensures proper height control
  });

  @override
  Widget build(BuildContext context) {
    return ImageFiltered(
      imageFilter: ImageFilter.blur(
        sigmaX: blurX,
        sigmaY: blurY,
      ),
      child: Image.asset(
        imagePath,
        fit: BoxFit.cover,
        width: width,
        height: height,
        opacity: AlwaysStoppedAnimation(opacity), // Ensures image transparency
      ),
    );
  }
}
