import 'package:flutter/material.dart';

import '../generated/assets.dart';

class VisaHeaderBackground extends StatelessWidget {
  const VisaHeaderBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Image.asset(
        Assets.imagesGradientHeaderNew, // Replace with your image path
        fit: BoxFit.contain,
        alignment: Alignment.topCenter,
      ),
    );
  }
}
