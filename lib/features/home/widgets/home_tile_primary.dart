import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:visaamigo/core/theme/theme.dart';
import 'package:visaamigo/custom_widgets/visa_textview.dart';

import '../providers/home_provider.dart';

class HomeTilePrimary extends StatelessWidget {
  final List<HomeTitles> homeTitle;
  final List<List<Color>> homeTitleColor;
  final int homeTitleIndex;

  const HomeTilePrimary(
      {super.key,
      required this.homeTitleColor,
      required this.homeTitleIndex,
      required this.homeTitle});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.w),
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25.r),
            gradient: LinearGradient(
              colors: homeTitleColor.elementAt(homeTitleIndex),
              stops: const [0, 1],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            )),
        child: Center(
          child: VisaTextView(
            text: homeTitle.elementAt(homeTitleIndex).title,
            style: VisaTextStyle.labelLarge,
            customColor: VisaColors.white,
            colorTheme: VisaTextTheme.customTextColor,
          ),
        ),
      ),
    );
  }
}
