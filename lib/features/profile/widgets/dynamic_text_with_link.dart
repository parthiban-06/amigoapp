import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:visaamigo/core/theme/theme.dart';
import 'package:visaamigo/custom_widgets/visa_rich_text.dart';
import 'package:visaamigo/custom_widgets/visa_textview.dart';
import 'package:visaamigo/generated/l10n.dart';
import 'package:visaamigo/router/app_router.dart';
import 'package:visaamigo/router/app_routes_const.dart';
import 'package:visaamigo/utils/app_extensions.dart';
import 'package:visaamigo/utils/const_screen_size.dart';

class DynamicTextWithLinks extends StatelessWidget {
  final String input;

  const DynamicTextWithLinks({super.key, required this.input});

  List<VisaTextSpan> _parseText(BuildContext context, String text) {
    final RegExp linkRegExp = RegExp(r'\[([^\]]+)\]\(([^)]+)\)');
    final List<VisaTextSpan> spans = [];
    int start = 0;

    for (final Match match in linkRegExp.allMatches(text)) {
      if (match.start > start) {
        spans.add(VisaTextSpan(
          text: text.substring(start, match.start),
          style: VisaTextStyle.customLarge,
          fontFamily: VisaFontWeight.medium,
          fontSize: Sizes.fourteenInt.sp,
          customColor: VisaColors.black,
          lineHeight:
              (Sizes.eighteenInt.toDouble() / Sizes.fourteenInt.toDouble()),
          colorTheme: VisaTextTheme.customTextColor,
          letterSpacing: 0,
        ));
      }

      final String linkText = match.group(1)!;
      final String url = match.group(2)!;

      spans.add(VisaTextSpan(
        text: linkText,
        onTap: () {
          AppRouter.router.push(AppRoutes.redirecting, extra: {
            "url": url,
            "deeplink": "",
            "openInternalBrowser": true,
            "bottomMessage": S.of(context).you_are_being_to + linkText,
          });
        },
        style: VisaTextStyle.customLarge,
        fontFamily: VisaFontWeight.medium,
        fontSize: Sizes.fourteenInt.toDouble(),
        customColor: VisaColors.primary,
        decoration: TextDecoration.underline,
        lineHeight:
            (Sizes.eighteenInt.toDouble() / Sizes.fourteenInt.toDouble()).h,
        colorTheme: VisaTextTheme.customTextColor,
        letterSpacing: 0,
      ));

      start = match.end;
    }

    if (start < text.length) {
      spans.add(VisaTextSpan(
        text: text.substring(start),
        style: VisaTextStyle.customLarge,
        fontFamily: VisaFontWeight.medium,
        fontSize: Sizes.fourteenInt.toDouble(),
        customColor: VisaColors.black,
        lineHeight:
            (Sizes.eighteenInt.toDouble() / Sizes.fourteenInt.toDouble()).h,
        colorTheme: VisaTextTheme.customTextColor,
        letterSpacing: 0,
      ));
    }

    return spans;
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      container: true,
      enabled: true,
      child: SizedBox(
        width: context.screenWidth,
        child: VisaRichText(
          overflow: TextOverflow.visible,
          textSpans: _parseText(context, input),
          textAlign: TextAlign.start,
        ),
      ),
    );
  }
}
