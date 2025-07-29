import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:visaamigo/custom_widgets/visa_text_rich_text.dart';
import 'package:visaamigo/custom_widgets/visa_textview.dart';
import 'package:visaamigo/utils/const_screen_size.dart' show AppSizes;

import '../../../../../core/theme/theme.dart';
import '../../../../../generated/l10n.dart';
import '../../../../../router/app_router.dart';
import '../../../../../router/app_routes_const.dart';
import '../../../../../utils/app_const.dart';
import '../../../../../utils/utils.dart';

class DeleteAccountTextSpanWidget extends StatelessWidget {
  final bool isCompanion;

  DeleteAccountTextSpanWidget({super.key, required this.isCompanion});

  final double fontFourteen = AppSizes.fontfourteen;

  @override
  Widget build(BuildContext context) {
    var s = S.of(context);
    return SingleChildScrollView(
      child: Column(
        children: [
          VisaTextRichText(
              softWrap: true,
              overflow: TextOverflow.visible,
              textSpans: [
                VisaTextSpan(
                  text: "${s.deleting_your_account}\n",
                  style: VisaTextStyle.custom,
                  colorTheme: VisaTextTheme.customTextColor,
                  customColor: VisaColors.red,
                  fontFamily: VisaFontWeight.semibold,
                  fontSize: fontFourteen,
                  lineHeight: 1.29,
                  spacing: 44,
                ),
                VisaTextSpan(
                  text:
                      '${isCompanion ? s.can_i_still_go : s.what_about_my_tickets}\n',
                  style: VisaTextStyle.custom,
                  colorTheme: VisaTextTheme.customTextColor,
                  customColor: VisaColors.black,
                  fontFamily: VisaFontWeight.semibold,
                  fontSize: fontFourteen,
                  lineHeight: 1.29,
                  spacing: 24,
                ),
                VisaTextSpan(
                  text:
                      '${isCompanion ? s.yes_your_can_still : s.your_fifa_word_cup_tickets_still_yours} ',
                  style: VisaTextStyle.custom,
                  colorTheme: VisaTextTheme.customTextColor,
                  customColor: VisaColors.black,
                  fontFamily: VisaFontWeight.regular,
                  fontSize: fontFourteen,
                  lineHeight: 1.29,
                ),
                VisaTextSpan(
                  text: isCompanion ? "" : s.you_must_register,
                  style: VisaTextStyle.custom,
                  colorTheme: VisaTextTheme.customTextColor,
                  customColor: VisaColors.black,
                  fontFamily: VisaFontWeight.bold,
                  fontSize: fontFourteen,
                  lineHeight: 1.29,
                ),
                VisaTextSpan(
                  text: isCompanion ? "" : ' ${s.with_the_same_email} ',
                  style: VisaTextStyle.custom,
                  colorTheme: VisaTextTheme.customTextColor,
                  customColor: VisaColors.black,
                  fontFamily: VisaFontWeight.regular,
                  fontSize: fontFourteen,
                  lineHeight: 1.29,
                ),
                VisaTextSpan(
                  onTap: () {},
                  text: isCompanion ? "\n" : "${s.ticketing_team}\n",
                  style: VisaTextStyle.custom,
                  colorTheme: VisaTextTheme.customTextColor,
                  customColor: VisaColors.primary,
                  fontFamily: VisaFontWeight.semibold,
                  decoration: TextDecoration.underline,
                  fontSize: fontFourteen,
                  lineHeight: 1.29,
                  spacing: 40,
                ),
                VisaTextSpan(
                  text: '${s.before_you_delete}\n',
                  style: VisaTextStyle.custom,
                  colorTheme: VisaTextTheme.customTextColor,
                  customColor: VisaColors.black,
                  fontFamily: VisaFontWeight.semibold,
                  fontSize: fontFourteen,
                  lineHeight: 1.29,
                  spacing: 28,
                ),
                VisaTextSpan(
                  text: '    • ${s.disable_push_notification} ',
                  style: VisaTextStyle.custom,
                  colorTheme: VisaTextTheme.customTextColor,
                  customColor: VisaColors.black,
                  fontFamily: VisaFontWeight.regular,
                  fontSize: fontFourteen,
                  lineHeight: 1.29,
                ),
                VisaTextSpan(
                  onTap: () {
                    AppRouter.router.pop("account_deleted");
                  },
                  text: '${s.profile_text}\n',
                  style: VisaTextStyle.custom,
                  colorTheme: VisaTextTheme.customTextColor,
                  customColor: VisaColors.primary,
                  fontFamily: VisaFontWeight.semibold,
                  fontSize: fontFourteen,
                  lineHeight: 1.29,
                  decoration: TextDecoration.underline,
                  spacing: 30,
                ),
                VisaTextSpan(
                  text: '    • ${s.review_our} ',
                  style: VisaTextStyle.custom,
                  colorTheme: VisaTextTheme.customTextColor,
                  customColor: VisaColors.black,
                  fontFamily: VisaFontWeight.regular,
                  fontSize: fontFourteen,
                  lineHeight: 1.29,
                ),
                VisaTextSpan(
                  onTap: () {
                    AppRouter.router.push(AppRoutes.faq);
                  },
                  text: '${s.faq_page}\n',
                  style: VisaTextStyle.custom,
                  colorTheme: VisaTextTheme.customTextColor,
                  customColor: VisaColors.primary,
                  fontFamily: VisaFontWeight.semibold,
                  fontSize: fontFourteen,
                  lineHeight: 1.29,
                  decoration: TextDecoration.underline,
                  spacing: 44,
                ),
                VisaTextSpan(
                  text: '${s.anything_else} ',
                  style: VisaTextStyle.custom,
                  colorTheme: VisaTextTheme.customTextColor,
                  customColor: VisaColors.black,
                  fontFamily: VisaFontWeight.regular,
                  fontSize: fontFourteen,
                  lineHeight: 1.29,
                ),
                VisaTextSpan(
                  onTap: () async {
                    var url = AppConst.visaContactSupport;
                    if (!kIsWeb) {
                      AppRouter.router.push(AppRoutes.redirecting, extra: {
                        "url": url,
                        "deeplink": "",
                        "openInternalBrowser": true,
                        "bottomMessage": S
                            .of(context)
                            .you_are_being_redirect_to_visa_contact_us_support,
                      });
                    } else {
                      Utils.openExternalApplication(url, "");
                    }
                  },
                  text: s.contact_support,
                  style: VisaTextStyle.custom,
                  colorTheme: VisaTextTheme.customTextColor,
                  customColor: VisaColors.primary,
                  fontFamily: VisaFontWeight.semibold,
                  fontSize: fontFourteen,
                  lineHeight: 1.29,
                  decoration: TextDecoration.underline,
                ),
              ]),
          SizedBox(
            height: AppSizes.heightXSmall,
          ),
        ],
      ),
    );
  }
}
