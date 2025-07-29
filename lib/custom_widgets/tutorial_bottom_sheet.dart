import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:visaamigo/core/theme/theme.dart';
import 'package:visaamigo/custom_widgets/tutorial_highligted_text_widget.dart';
import 'package:visaamigo/custom_widgets/visa_appbar.dart';
import 'package:visaamigo/custom_widgets/visa_button.dart';
import 'package:visaamigo/custom_widgets/visa_font_family.dart';
import 'package:visaamigo/custom_widgets/visa_image.dart';
import 'package:visaamigo/custom_widgets/visa_size_box.dart';
import 'package:visaamigo/custom_widgets/visa_svg_icon.dart';
import 'package:visaamigo/custom_widgets/visa_textview.dart';
import 'package:visaamigo/generated/assets.dart';
import 'package:visaamigo/utils/app_extensions.dart';

import '../generated/l10n.dart';
import '../utils/const_screen_size.dart';
import 'custom_visa_two_button.dart';

class TutorialBottomSheet extends StatefulWidget {
  final VoidCallback onBack;
  final VoidCallback onNext;
  final VoidCallback onStart;
  final VoidCallback onCancel;
  final String title;
  final String subTitle;
  final String description;
  final String tutorialIcon;
  final bool isSingleButtonVisible;
  final bool isTutorialStarted;
  final bool isTextSpan;
  final String startButtonText;
  final String backButtonText;
  final String nextButtonText;
  final List<String>? boldWords;
  final bool isShowForHome;
  final bool showAppBar;

  const TutorialBottomSheet({
    super.key,
    required this.onBack,
    required this.onNext,
    required this.onStart,
    required this.onCancel,
    required this.startButtonText,
    required this.backButtonText,
    required this.nextButtonText,
    this.isSingleButtonVisible = true,
    this.isTutorialStarted = false,
    this.isTextSpan = false,
    this.tutorialIcon = Assets.iconsEva,
    this.title = "",
    this.subTitle = "",
    this.description = "",
    this.boldWords,
    this.isShowForHome = true,
    this.showAppBar = false,
  });

  @override
  State<TutorialBottomSheet> createState() => _TutorialBottomSheetState();
}

class _TutorialBottomSheetState extends State<TutorialBottomSheet> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: VisaColors.transparent,
      body: SizedBox(
        width: context.screenWidth,
        height: context.screenHeight,
        child: GestureDetector(
          onTap: () {}, // Optional: Tap outside to dismiss if needed
          behavior: HitTestBehavior.opaque,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              widget.showAppBar == true
                  ? const VisaAppBar(
                      brandingLogoColor: VisaColors.white,
                    )
                  : const SizedBox.shrink(),
              const Spacer(),
              Container(
                decoration: BoxDecoration(
                  color: VisaColors.white, // or any color you want
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20.r),
                    // adjust the radius as needed
                    topRight: Radius.circular(20.r),
                  ),
                ),
                child: Column(
                  children: [
                    ExcludeSemantics(
                      child: ClipRRect(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30.r),
                          // adjust the radius as needed
                          topRight: Radius.circular(30.r),
                        ),
                        child: VisaImageIcon(
                          semantics: false,
                          assetPath: Assets.imagesTutorialDialogTopImage,
                          fit: BoxFit.fitWidth,
                          width: context.screenWidth,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        bottom: AppSizes.thirtySixHeight,
                        left: AppSizes.dimSmall,
                        right: AppSizes.dimSmall,
                        top: AppSizes.heightSmall,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Align(
                            alignment: Alignment.centerRight,
                            child: Semantics(
                              label:
                                  "${S.of(context).tutorial_cancel_button},${S.of(context).double_tap_to_activate}",
                              button: false,
                              container: true,
                              excludeSemantics: true,
                              child: SizedBox(
                                height: AppSizes.heightTweentyFour,
                                width: AppSizes.tweentyFourWidth,
                                child: IconButton(
                                  padding: EdgeInsets.zero,
                                  // remove default padding
                                  constraints: const BoxConstraints(),
                                  // remove default min size
                                  visualDensity: VisualDensity.compact,
                                  icon: Icon(
                                    Icons.close,
                                    size: AppSizes
                                        .twentyTwoRadius, // internal icon size
                                  ),
                                  onPressed: widget.onCancel,
                                ),
                              ),
                            ),
                          ),
                          Row(
                            children: [
                              VisaSvgIcon(
                                semantics: false,
                                assetPath: widget.tutorialIcon,
                                height: Sizes.twentyFourInt.toDouble(),
                                width: Sizes.twentyFourInt.toDouble(),
                              ),
                              VisaSizeBox(
                                width: Sizes.eightInt.toDouble(),
                              ),
                              Expanded(
                                child: VisaTextView(
                                  semanticsFocus: true,
                                  text: widget.title,
                                  softWrap: true,
                                  overflow: TextOverflow.visible,
                                  fontSize: AppSizes.fontMedium,
                                  fontFamily: VisaFontWeight.bold,
                                  colorTheme: VisaTextTheme.customTextColor,
                                  customColor: VisaColors.black,
                                  lineHeight: 1.17,
                                  letterSpacing: 0,
                                ),
                              ),
                            ],
                          ),
                          VisaSizeBox(
                            height: Sizes.sixteenInt.toDouble(),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                              left: Sizes.thirtyInt.toDouble(),
                              right: Sizes.fortyEightInt.toDouble(),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                widget.isTextSpan &&
                                        widget.boldWords!.isNotEmpty
                                    ? HighlightedText(
                                        text: widget.subTitle,
                                        boldWords: widget.boldWords!,
                                        style: TextStyle(
                                          fontFamily:
                                              VisaFontFamily.getFontFamily(
                                                  VisaFontWeight.regular,
                                                  false),
                                          fontSize: AppSizes.fontfourteen,
                                          height: 1.29,
                                          color: VisaColors.black,
                                          letterSpacing: 0,
                                          fontWeight: FontWeight.w500,
                                          overflow: TextOverflow.visible,
                                        ),
                                      )
                                    : VisaTextView(
                                        text: widget.subTitle,
                                        softWrap: true,
                                        overflow: TextOverflow.visible,
                                        fontSize: AppSizes.fontfourteen,
                                        fontFamily: VisaFontWeight.medium,
                                        colorTheme:
                                            VisaTextTheme.customTextColor,
                                        customColor: VisaColors.black,
                                        lineHeight: 1.29,
                                        letterSpacing: 0,
                                        textAlign: TextAlign.start,
                                      ),
                                widget.description.isNotEmpty
                                    ? Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          VisaSizeBox(
                                            height: AppSizes.tweleveHeight,
                                          ),
                                          VisaTextView(
                                            text: widget.description,
                                            softWrap: true,
                                            overflow: TextOverflow.visible,
                                            fontSize:
                                                Sizes.twelveInt.toDouble(),
                                            fontFamily: VisaFontWeight.regular,
                                            colorTheme:
                                                VisaTextTheme.customTextColor,
                                            customColor:
                                                VisaColors.textFieldBorder,
                                            lineHeight: (16 / 12).toDouble(),
                                            letterSpacing: 0,
                                          )
                                        ],
                                      )
                                    : const SizedBox.shrink(),
                              ],
                            ),
                          ),
                          VisaSizeBox(
                            height: Sizes.thirtySixInt.toDouble(),
                          ),
                          widget.isSingleButtonVisible
                              ? VisaButton(
                                  text: widget.startButtonText,
                                  width: context.screenWidth,
                                  variant: VisaButtonVariant.primary,
                                  fontWeight: VisaFontWeight.medium,
                                  fontSize: AppSizes.fontMedium,
                                  letterSpacing: AppSizes.zero,
                                  lineHeight: (25 / 18).toDouble(),
                                  borderRadius: AppSizes.sixteenRadius,
                                  onPressed: widget.onStart,
                                  addDefaultAnalyticsEvent: false,
                                  ignoreDoubleClick: true,
                                )
                              : CustomTwoButtons(
                                  leftButtonText: widget.backButtonText,
                                  rightButtonText: widget.nextButtonText,
                                  rightButtonDisable: false,
                                  onLeftButtonPressed: widget.onBack,
                                  onRightButtonPressed: widget.onNext,
                                  isRightButtonLoading: false,
                                  isLeftButtonLoading: false,
                                  ignoreDoubleClick: true,
                                )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
