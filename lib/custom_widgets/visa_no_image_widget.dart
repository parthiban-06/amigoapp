import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:visaamigo/custom_widgets/visa_svg_icon.dart';
import 'package:visaamigo/custom_widgets/visa_textview.dart';
import 'package:visaamigo/generated/assets.dart';
import 'package:visaamigo/utils/const_screen_size.dart';

import '../core/theme/theme.dart';
import '../generated/l10n.dart';

class VisaNoImageWidget extends StatelessWidget {
  const VisaNoImageWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: 0.30,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
           const VisaSvgIcon(
            semantics: false,
            assetPath: Assets.iconsCarbonNoImage,
          ),
          SizedBox(
            height: Sizes.fourInt.h,
          ),
          VisaTextView(
            semantics: false,
            text: S.of(context).no_image_available,
            softWrap: true,
            overflow: TextOverflow.visible,
            style: VisaTextStyle.custom,
            fontFamily: VisaFontWeight.semibold,
            customColor: VisaColors.chatTextColor,
            colorTheme: VisaTextTheme.customTextColor,
            lineHeight: 1.12,
            fontSize: context.getCustomFontSize(
              desktopSize: Sizes.sixteenInt,
              tabSize: Sizes.sixteenInt,
              mobileSize: Sizes.sixteenInt,
            ),
          ),
        ],
      ),
    );
  }
}
