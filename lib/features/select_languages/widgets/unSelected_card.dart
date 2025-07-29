import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:visaamigo/core/theme/theme.dart';
import 'package:visaamigo/custom_widgets/visa_textview.dart';
import 'package:visaamigo/features/select_languages/models/language_selection_model.dart';

import '../../../generated/l10n.dart';
import '../providers/language_selection_generic_provider.dart';

class UnselectedCard extends StatelessWidget {
  final Language language;

  const UnselectedCard({
    super.key,
    required this.language,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      excludeSemantics: true,
      label: language.langCode == "ar"
          ? "${S.of(context).hello} ${S.of(context).arabic} ${S.of(context).unselected}"
          : "${language.langText} ${language.title} ${S.of(context).unselected}",
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(
                color: Theme.of(context).colorScheme.primary, width: 2.w)),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
          child: Column(
            crossAxisAlignment: (language.langCode == "ar" ||
                    Provider.of<SelectLanguageGenericProvider>(context)
                            .selectedLanguage ==
                        "ar")
                ? CrossAxisAlignment.end
                : CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              VisaTextView(
                semantics: false,
                text: language.langText,
                softWrap: true,
                overflow: TextOverflow.visible,
                style: VisaTextStyle.displayTitleSmall,
                fontFamily: VisaFontWeight.bold,
                customColor: VisaColors.black,
                colorTheme: VisaTextTheme.customTextColor,
                letterSpacing: -1,
                lineHeight: 1.05,
                maxLines: 1,
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
                  customColor: VisaColors.black,
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
