// Loading widget
import 'package:flutter/material.dart';
import 'package:visaamigo/utils/const_screen_size.dart' show AppSizes;

loadingBar() => SizedBox(
      height:  AppSizes.tweentyHeight,
      width: AppSizes.tweentyWidth,
      child: Center(
        child: CircularProgressIndicator(
          color: Colors.white,
          strokeWidth: AppSizes.fiveWidth,
        ),
      ),
    );
