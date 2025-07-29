import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:visaamigo/utils/app_extensions.dart';

import '../utils/const_screen_size.dart';

class VisaWhiteBlurWidget extends StatelessWidget {
  const VisaWhiteBlurWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Container(
        width: context.screenWidth,
        height: Sizes.oneHundredFortyNine.h,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: const Alignment(0.00, -1.00),
            end: const Alignment(0, 1),
            colors: [
              Colors.white.withValues(alpha: 0),
              Colors.white,
            ],
          ),
        ),
      ),
    );
  }
}
