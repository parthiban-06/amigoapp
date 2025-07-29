import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:visaamigo/core/theme/theme.dart';
import 'package:visaamigo/custom_widgets/visa_textview.dart';
import 'package:visaamigo/features/profile/model/faq_model.dart';
import 'package:visaamigo/features/profile/provider/faq_provider.dart';
import 'package:visaamigo/generated/l10n.dart';
import 'package:visaamigo/utils/const_screen_size.dart';
import 'package:visaamigo/utils/utils.dart';

import '../../../custom_widgets/accordion/accordion.dart';
import '../../../custom_widgets/visa_svg_icon.dart';
import '../../../generated/assets.dart';
import '../../select_languages/providers/language_selection_generic_provider.dart';
import 'dynamic_text_with_link.dart';

class FaqsCategoryDesktop extends StatelessWidget {
  final FaqProvider provider;
  final FaqCategory faqCategory;
  final int index;

  const FaqsCategoryDesktop({
    super.key,
    required this.provider,
    required this.faqCategory,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    final localLanguageProvider =
        Provider.of<SelectLanguageGenericProvider>(context, listen: false);
    final int categoryId = index;
    final bool isOpen = provider.isOpen(categoryId);
    final String iconPath = isOpen ? Assets.iconsMinus : Assets.iconsPlus;
    final iconWidget = VisaSvgIcon(
      semantics: false,
      height: AppSizes.heightTwentyFive,
      width: AppSizes.twentyFiveWidth,
      assetPath: iconPath,
    );
    return Accordion(
      maxOpenSections: 1,
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
      flipRightIconIfOpen: false,
      // disable flip animation to use custom logic
      flipLeftIconIfOpen: false,
      children: [
        AccordionSection(
          isOpen: isOpen,
          onOpenSection: () {
            provider.setOpen(categoryId, true);
            Utils.announceMessage(S.of(context).expanded);
          },
          onCloseSection: () {
            provider.setOpen(categoryId, false);
            Utils.announceMessage(S.of(context).collapsed);
          },
          rightIcon: !localLanguageProvider.isRTL
              ? iconWidget
              : const SizedBox.shrink(),
          leftIcon: localLanguageProvider.isRTL
              ? iconWidget
              : const SizedBox.shrink(),
          headerPadding: EdgeInsets.zero,
          header: Semantics(
            container: true,
            button: false,
            label:
                "${faqCategory.category}. ${S.of(context).double_tap_to_collapse_expand}",
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 30),
                  child: VisaTextView(
                    text: faqCategory.category,
                    softWrap: true,
                    semantics: false,
                    overflow: TextOverflow.visible,
                    style: VisaTextStyle.custom,
                    fontFamily: VisaFontWeight.bold,
                    fontSize: AppSizes.fontThirtyTwo,
                    customColor: VisaColors.primary,
                    lineHeight: 0.81,
                    colorTheme: VisaTextTheme.customTextColor,
                    letterSpacing: -0.64,
                  ),
                ),
                Divider(
                  height: Sizes.oneInt.h,
                  color: VisaColors.greyBackGround,
                )
              ],
            ),
          ),
          content: Accordion(
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
                  onOpenSection: () {
                    Utils.announceMessage(S.of(context).expanded);
                  },
                  onCloseSection: () {
                    Utils.announceMessage(S.of(context).collapsed);
                  },
                  rightIcon: !(localLanguageProvider.isRTL)
                      ? VisaSvgIcon(
                          semantics: false,
                          height: AppSizes.tweleveHeight,
                          width: AppSizes.tweleveWidth,
                          assetPath: Assets.iconsMoveDown,
                        )
                      : const SizedBox.shrink(),
                  paddingBetweenOpenSections: 0,
                  paddingBetweenClosedSections: 0,
                  contentHorizontalPadding: 0,
                  contentVerticalPadding: 0,
                  leftIcon: (localLanguageProvider.isRTL)
                      ? VisaSvgIcon(
                          semantics: false,
                          height: AppSizes.tweleveHeight,
                          width: AppSizes.tweleveWidth,
                          assetPath: Assets.iconsMoveDown,
                        )
                      : const SizedBox.shrink(),
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
                              right: 25,
                              top: (index == 0) ? 5 : 20,
                              bottom: 20),
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
          ), // Replace with actual content
        ),
      ],
    );
  }
}
