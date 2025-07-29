import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:visaamigo/core/theme/theme.dart';
import 'package:visaamigo/custom_widgets/visa_textview.dart';

import '../../../custom_widgets/visa_svg_icon.dart';
import '../../../generated/assets.dart';
import '../../../utils/const_screen_size.dart';

regexWidget(
    {required bool isDisable, required bool regex, required String text}) {
  return Semantics(
    enabled: true,
    excludeSemantics: false,
    label: text,
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        HSpacings.xxsmall,
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: isDisable
              ? Container(
                  height: 16.w,
                  width: 16.w,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: VisaColors.grey,
                  ))
              : !regex
                  ? VisaSvgIcon(
                      semantics: false,
                      assetPath: Assets.iconsIcError,
                      width: 16.w,
                      height: 16.h,
                      setColorFilter: false,
                    )
                  : VisaSvgIcon(
                      semantics: false,
                      assetPath: Assets.iconsIcCheck,
                      width: 16.w,
                      height: 16.h,
                      setColorFilter: false,
                    ),
        ),
        HSpacings.xsmall,
        Expanded(
          child: VisaTextView(
            text: text,
            semantics: false,
            overflow: TextOverflow.fade,
            style: VisaTextStyle.displayBodyS,
            customColor: VisaColors.black,
            colorTheme: VisaTextTheme.customTextColor,
            fontFamily: VisaFontWeight.regular,
          ),
        ),
      ],
    ),
  );
}
