import 'package:flutter/material.dart';
import 'package:visaamigo/custom_widgets/visa_textview.dart';

import '../core/theme/theme.dart';
import '../generated/l10n.dart';
import '../utils/const_screen_size.dart';

class CircleLetterWidget extends StatelessWidget {
  final String letter;
  final double? size;
  final Color backgroundColor;
  final Color? textColor;

  const CircleLetterWidget({
    super.key,
    required this.letter,
    this.size, // Default size of the circle
    this.backgroundColor = VisaColors.blueBackgroundLightNew,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: "$letter, ${S.of(context).your_name_initial}",
      container: true,
      enabled: true,
      child: Container(
        padding: EdgeInsets.all(AppSizes.ten),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: backgroundColor, // Light blue background
        ),
        alignment: Alignment.center,
        child: VisaTextView(
          semantics: false,
          text: letter,
          softWrap: true,
          overflow: TextOverflow.visible,
          style: VisaTextStyle.displayBodyXl,
          fontFamily: VisaFontWeight.medium,
          customColor: VisaColors.primary,
          colorTheme: VisaTextTheme.customTextColor,
          lineHeight: 1.78,
        ),
      ),
    );
  }
}
