import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:visaamigo/core/theme/theme.dart';
import 'package:visaamigo/custom_widgets/visa_textview.dart';
import 'package:visaamigo/features/select_languages/models/language_selection_model.dart';

import '../../../generated/l10n.dart';

class SelectedCard extends StatelessWidget {
  final Language language;

  const SelectedCard({
    super.key,
    required this.language,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      excludeSemantics: true,
      label: language.langCode == "ar"
          ? "${S.of(context).hello} ${S.of(context).arabic} ${S.of(context).selected}"
          : "${language.langText.toLowerCase()} ${language.title.toLowerCase()} ${S.of(context).selected}",
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: VisaColors.transparent, width: 2.w),
          gradient: LinearGradient(
            begin: const Alignment(-0.8, -1.0), // Adjusted for 113.7° angle
            end: const Alignment(1.0, 0.3),
            colors: [
              Theme.of(context).colorScheme.primary,
              Theme.of(context).colorScheme.primaryFixed
            ],
            stops: const [0.04, 0.94], // Matches 4.09% and 94.26%
          ),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            /*  ((Provider.of<SelectLanguageGenericProvider>(context)
                                .selectedLanguage ==
                            "ar" &&
                        language.langCode == "ar"))
                    ? CrossAxisAlignment.start
                    : CrossAxisAlignment.end,*/
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Directionality(
                textDirection: (language.langCode == "ar")
                    ? TextDirection.rtl
                    : TextDirection.ltr,
                child: VisaTextView(
                  semantics: false,
                  text: language.langText,
                  softWrap: true,
                  overflow: TextOverflow.visible,
                  style: VisaTextStyle.displayTitleSmall,
                  fontFamily: VisaFontWeight.bold,
                  customColor: VisaColors.white,
                  colorTheme: VisaTextTheme.customTextColor,
                  letterSpacing: -1,
                  lineHeight: 1.05,
                  maxLines: 1,
                ),
              ),
              Flexible(
                child: VisaTextView(
                  semantics: false,
                  text: language.title.toUpperCase(),
                  softWrap: true,
                  overflow: TextOverflow.visible,
                  style: VisaTextStyle.displayBodyXs,
                  fontFamily: VisaFontWeight.medium,
                  letterSpacing: 2,
                  customColor: VisaColors.white,
                  colorTheme: VisaTextTheme.customTextColor,
                  lineHeight: 1.4,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
