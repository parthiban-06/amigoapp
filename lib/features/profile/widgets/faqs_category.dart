import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:visaamigo/core/theme/theme.dart';
import 'package:visaamigo/custom_widgets/visa_rich_text.dart';
import 'package:visaamigo/custom_widgets/visa_textview.dart';
import 'package:visaamigo/features/profile/model/faq_model.dart';
import 'package:visaamigo/generated/l10n.dart';
import 'package:visaamigo/router/app_router.dart';
import 'package:visaamigo/router/app_routes_const.dart';
import 'package:visaamigo/utils/const_screen_size.dart';

import '../../../analytics/firebase_analytics_service.dart';
import '../../../custom_widgets/accordion/accordion.dart';
import '../../../custom_widgets/visa_svg_icon.dart';
import '../../../generated/assets.dart';
import '../../select_languages/providers/language_selection_generic_provider.dart';
import 'dynamic_text_with_link.dart';

class FaqsCategory extends StatelessWidget {
  final FaqCategory faqCategory;

  const FaqsCategory({
    super.key,
    required this.faqCategory,
  });

  @override
  Widget build(BuildContext context) {
    bool isRTL =
        Provider.of<SelectLanguageGenericProvider>(context, listen: false)
            .isRTL;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        VisaTextView(
          text:
              "${faqCategory.category.toUpperCase()} ${S.of(context).faqs.toUpperCase()}",
          softWrap: true,
          overflow: TextOverflow.visible,
          style: VisaTextStyle.customLarge,
          fontFamily: VisaFontWeight.medium,
          fontSize: Sizes.twelveInt.toDouble(),
          customColor: VisaColors.textFieldBorder,
          lineHeight: (16.8 / Sizes.twelveInt.toDouble()).h,
          colorTheme: VisaTextTheme.customTextColor,
          letterSpacing: 2,
        ),
        Accordion(
          maxOpenSections: 1,
          // no open/close behavior if 1 item
          headerBackgroundColorOpened: Colors.white,
          contentBackgroundColor: Colors.white,
          paddingListTop: 0,
          contentHorizontalPadding: 0,
          contentVerticalPadding: 0,
          disableScrolling: true,
          openAndCloseAnimation: true,
          headerPadding: EdgeInsets.zero,
          paddingBetweenOpenSections: 0,
          paddingBetweenClosedSections: 0,
          contentBorderRadius: 0,
          paddingListHorizontal: 0,
          contentBorderColor: Colors.white,
          headerBackgroundColor: Colors.white,
          paddingListBottom: 0,
          scaleWhenAnimating: false,
          flipRightIconIfOpen: true,
          flipLeftIconIfOpen: true,
          children: List.generate(
            faqCategory.faqs.length,
            (index) {
              // final item = userMatches[index];
              final Faq faq = faqCategory.faqs.elementAt(index);

              return AccordionSection(
                // isOpen: _isOpenList[index],
                // onOpenSection: () {
                //   Utils.announceMessage(S.of(context).expanded);
                // },
                // onCloseSection: () {
                //   Utils.announceMessage(S.of(context).expand_details);
                // },
                moveUpIcon: VisaSvgIcon(
                  semanticsLabel: S.of(context).collapse_details,
                  height: AppSizes.tweleveHeight,
                  width: AppSizes.tweleveWidth,
                  assetPath: Assets.iconsMoveUp,
                  padding: const EdgeInsets.symmetric(vertical: 10),
                ),
                rightIcon: !isRTL
                    ? VisaSvgIcon(
                        semanticsLabel: S.of(context).expand_details,
                        height: AppSizes.tweleveHeight,
                        width: AppSizes.tweleveWidth,
                        assetPath: Assets.iconsMoveDown,
                      )
                    : const SizedBox.shrink(),
                leftIcon: isRTL
                    ? VisaSvgIcon(
                        semanticsLabel: S.of(context).expand_details,
                        height: AppSizes.tweleveHeight,
                        width: AppSizes.tweleveWidth,
                        assetPath: Assets.iconsMoveDown,
                        padding: const EdgeInsets.symmetric(vertical: 10),
                      )
                    : const SizedBox.shrink(),
                paddingBetweenOpenSections: isRTL ? 20 : 0,
                paddingBetweenClosedSections: isRTL ? 20 : 0,
                contentHorizontalPadding: 0,
                contentVerticalPadding: 0,
                headerPadding: EdgeInsets.zero,
                header: Semantics(
                  container: true,
                  button: false,
                  label:
                      "${faq.questionText}. ${S.of(context).double_tap_to_collapse_expand}",
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                          left: isRTL ? 18 : 0,
                          right: 25,
                          top: (index == 0)
                              ? 5
                              : !isRTL
                                  ? 20
                                  : 0,
                          bottom: 20,
                        ),
                        child: VisaTextView(
                          semantics: false,
                          text: faq.questionText,
                          softWrap: true,
                          overflow: TextOverflow.visible,
                          style: VisaTextStyle.customLarge,
                          fontFamily: VisaFontWeight.semibold,
                          fontSize: Sizes.twentyTwoInt.toDouble(),
                          customColor: VisaColors.black,
                          lineHeight: 1.09,
                          colorTheme: VisaTextTheme.customTextColor,
                          // letterSpacing: -1,
                        ),
                      ),
                      Divider(
                        height: Sizes.oneInt.h,
                        color: VisaColors.greyBackGround,
                      )
                    ],
                  ),
                ),
                content: Padding(
                  padding: EdgeInsets.only(
                    top: Sizes.twentyInt.h,
                    left: Sizes.twentyInt.h,
                    right: Sizes.twentyInt.h,
                  ),
                  child: DynamicTextWithLinks(input: faq.answerText),
                ),
              );
            },
          ).toList(),
        ),
        Padding(
          padding: EdgeInsets.only(top: Sizes.twentyInt.h),
          child: VisaRichText(
            overflow: TextOverflow.visible,
            textSpans: [
              VisaTextSpan(
                text: S.of(context).other_booking_questions(
                    faqCategory.category.toLowerCase()),
                style: VisaTextStyle.walletNormal,
              ),
              VisaTextSpan(
                  text: S.of(context).view_full_faqs,
                  semanticTitle: S.of(context).view_full +
                      " " +
                      S.of(context).frequently_asked_questions,
                  style: VisaTextStyle.walletHighlighted,
                  onTap: () {
                    AppRouter.router.push(AppRoutes.redirecting, extra: {
                      "url":
                          "${dotenv.env["WEB_URL"]}${FirebaseAnalyticsService.cleanRoutePath(AppRoutes.faq)}",
                      "deeplink": "",
                      "openInternalBrowser": true,
                      "bottomMessage": S.of(context).you_are_being_to_faqs,
                    });
                  }),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(
            vertical: Sizes.twentyInt.h,
          ),
          child: Divider(
            height: Sizes.oneInt.h,
            color: VisaColors.greyBackGround,
          ),
        ),
      ],
    );
  }
}
