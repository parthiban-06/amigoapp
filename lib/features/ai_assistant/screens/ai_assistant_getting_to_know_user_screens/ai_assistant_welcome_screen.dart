import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart' show GetIt;
import 'package:provider/provider.dart';
import 'package:visaamigo/analytics/firebase_analytics_service.dart';
import 'package:visaamigo/custom_widgets/visa_appbar.dart';
import 'package:visaamigo/custom_widgets/visa_svg_icon.dart';
import 'package:visaamigo/features/ai_assistant/providers/ai_assistant_welcome_screen_provider.dart';
import 'package:visaamigo/features/ai_assistant/screens/ai_assistant_getting_to_know_user_screens/widgets/ai_assistant_animated_text.dart';
import 'package:visaamigo/utils/app_extensions.dart';
import 'package:visaamigo/utils/utils.dart';

import '../../../../core/base/view/base_view.dart';
import '../../../../core/theme/theme.dart';
import '../../../../custom_widgets/visa_button.dart';
import '../../../../custom_widgets/visa_textview.dart';
import '../../../../generated/assets.dart';
import '../../../../generated/l10n.dart';
import '../../../../utils/const_screen_size.dart';
import '../../../../utils/test_style_util.dart';
import '../../providers/ai_assistant_main_provider.dart';

class AiAssistantWelcomeScreen extends StatefulWidget {
  const AiAssistantWelcomeScreen({super.key});

  @override
  State<AiAssistantWelcomeScreen> createState() =>
      _AiAssistantWelcomeScreenState();
}

class _AiAssistantWelcomeScreenState extends State<AiAssistantWelcomeScreen> {
  late final AiAssistantWelcomeScreenProvider viewModel;
  late final AiAssistantMainProvider aiAssistantProvider;
  late S s;
  late double fontXXSmall;
  late double fontLarge;
  late double heightTweentyEight;
  late double nameFontSize;

  @override
  void initState() {
    super.initState();
    // Retrieve dependencies using GetIt
    viewModel = GetIt.I<AiAssistantWelcomeScreenProvider>();
    aiAssistantProvider =
        Provider.of<AiAssistantMainProvider>(context, listen: false);

    //   gtkyintro.screenview
    FirebaseAnalyticsService.logEvent(eventName: "gtkyintro_screenview");
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    s = S.of(context);
    aiAssistantProvider.setContext(context);
    fontXXSmall = AppSizes.fontXXSmall;
    heightTweentyEight = AppSizes.heightTweentyEight;
    nameFontSize = aiAssistantProvider.isDesktopView
        ? AppSizes.fontLarge
        : AppSizes.fontSixty;
  }

  @override
  Widget build(BuildContext context) {
    aiAssistantProvider.calculateBubbleSize();

    return BaseView<AiAssistantWelcomeScreenProvider>(
      screenBackgroundColor: VisaColors.primary,
      extendBodyBehindAppBar: false,
      addDefaultPadding: false,
      wrapWithSafeArea: false,
      onlyDesktop: true,
      screenBackgroundImage: Positioned.fill(
        child: Image.asset(
          Assets.imagesBackground3, // Replace with your image path
          fit: BoxFit.fill,
        ),
      ),
      viewModel: viewModel,
      onModelReady: (model) {
        model.init(isComeFromWelcomeScreen: true);
        aiAssistantProvider.getAppConfiguration();
        Utils.announceMessage(s.welcome_screen);
      },
      buildAppBar: const VisaAppBar(
        brandingLogoColor: VisaColors.white,
      ),
      onPageBuilderMobileView:
          (BuildContext context, AiAssistantWelcomeScreenProvider viewModel) {
        var isDesktop = viewModel.isDesktopView;
        var isTab = viewModel.isTabletWebFromBase;

        return SizedBox(
          height: context.screenHeight,
          width: context.screenWidth,
          child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: AppSizes.sixteenRadius,
              ),
              child: isDesktop
                  ? Center(
                      child: _buildWelcomeWidget(isDesktop, isTab),
                    )
                  : _buildWelcomeWidget(isDesktop, isTab)),
        );
      },
    );
  }

  Widget _buildWelcomeWidget(bool isDesktop, bool isTab) => SizedBox(
        width: isDesktop ? AppSizes.fourTwentyEightWidth : null,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            isDesktop
                ? _buildWelcomeContent(context, isDesktop, isTab)
                : Expanded(
                    child: Align(
                      alignment: viewModel.packageContents.isNotEmpty
                          ? Alignment.center
                          : Alignment.topLeft,
                      // Use ListView For handling bottom overflow error
                      child: ListView(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          padding: viewModel.packageContents.isNotEmpty
                              ? EdgeInsets.zero
                              : null,
                          children: [
                            _buildWelcomeContent(
                              context,
                              isDesktop,
                              isTab,
                            )
                          ]),
                    ),
                  ),
            Padding(
              padding: EdgeInsets.only(
                  top: isDesktop ? AppSizes.heightFourty : heightTweentyEight,
                  bottom: heightTweentyEight,
                  left: isDesktop ? AppSizes.thirtySixWidth : 0),
              child: SizedBox(
                width: isDesktop ? AppSizes.threeTwoEightWidth : null,
                child: VisaAnimatedText(
                  delay: const Duration(milliseconds: 450),
                  child: VisaButton(
                    text: s.let_get_started,
                    onPressed: () {
                      if (aiAssistantProvider.pages.isNotEmpty) {
                        aiAssistantProvider
                            .navigateToAiAssistantCommonStepsScreen();
                      } else {
                        viewModel.navigateToHomeScreen();
                      }
                    },
                    // height: 54,
                    fontWeight: VisaFontWeight.medium,
                    variant: VisaButtonVariant.primary,
                  ),
                ),
              ),
            ),
          ],
        ),
      );

  Widget _buildHiText(bool semantics) {
    return VisaAnimatedText(
      delay: const Duration(milliseconds: 150),
      child: VisaTextView(
        semantics: semantics,
        text: s.hi,
        softWrap: true,
        overflow: TextOverflow.visible,
        style: VisaTextStyle.customLarge,
        fontFamily: VisaFontWeight.bold,
        fontSize: nameFontSize,
        customColor: VisaColors.white,
        colorTheme: VisaTextTheme.customTextColor,
        letterSpacing: -1,
        lineHeight: 0.87,
      ),
    );
  }

  Widget _buildNameText(bool semantics) {
    return VisaAnimatedText(
      delay: const Duration(milliseconds: 250),
      child: semantics
          ? _autoSizeText()
          : ExcludeSemantics(
              child: _autoSizeText(),
            ),
    );
  }

  Widget _autoSizeText() {
    return AutoSizeText(
        "${(viewModel.userModel != null ? "${viewModel.userModel?.firstName}" : "")}!",
        maxLines: 1,
        textScaleFactor: Utils.getCappedScale(context, nameFontSize),
        // semanticsLabel: semantics
        //     ? "${(viewModel.userModel != null ? "${viewModel.userModel?.firstName}" : "")}!"
        //     : "",
        minFontSize: viewModel.isDesktopView
            ? AppSizes.fontLarge
            : Sizes.thirty.roundToDouble(),
        overflow: TextOverflow.ellipsis,
        stepGranularity: 0.1,
        style: VisaTextUtils.getVisaTextStyle(
          VisaTextStyle.custom,
          context: context,
          isDarkMode: false,
          letterSpacing: -1,
          fontSize: nameFontSize,
          lineHeight: 0.87,
          fontFamily: VisaFontWeight.bold,
          fontColor: VisaColors.white,
        ));
  }

  Widget _buildHiAndName(BuildContext context, bool isDesktop) {
    return isDesktop
        ? Semantics(
            label: "${s.hi} ${viewModel.userModel?.firstName ?? ""}",
            excludeSemantics: false,
            focused: true,
            focusable: true,
            sortKey: const OrdinalSortKey(1.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(width: AppSizes.thirtySixWidth),
                _buildHiText(false),
                SizedBox(width: AppSizes.dimSmall),
                _buildNameText(false),
              ],
            ),
          )
        : Semantics(
            label: "${s.hi} ${viewModel.userModel?.firstName ?? ""}!",
            enabled: true,
            container: true,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHiText(false),
                AppSizes.xxsmallVS,
                _buildNameText(false),
              ],
            ),
          );
  }

  Widget _buildWelcomeContent(
      BuildContext context, bool isDesktop, bool isTab) {
    return Container(
      margin: EdgeInsets.only(
        top: isDesktop ? AppSizes.zero : AppSizes.heightHundrad,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHiAndName(context, isDesktop),
          SizedBox(
            height: isDesktop
                ? AppSizes.thirtyTwoHeight
                : AppSizes.heightFourtyThree,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(top: isDesktop ? 6 : 0),
                child: VisaAnimatedText(
                  delay: const Duration(milliseconds: 350),
                  child: VisaSvgIcon(
                    semantics: false,
                    assetPath: Assets.iconsIcEvaGeneric,
                    color: VisaColors.white,
                    width: AppSizes.dimMedium,
                  ),
                ),
              ),
              SizedBox(
                width: 11.54.w,
              ),
              Flexible(
                child: VisaAnimatedText(
                  delay: const Duration(milliseconds: 350),
                  child: Semantics(
                    container: true,
                    enabled: true,
                    excludeSemantics: true,
                    label: S.of(context).welcome_message_semantic_label,
                    child: VisaTextView(
                      semantics: false,
                      text: s.welcome_message,
                      softWrap: true,
                      semanticsIndex: 2,
                      overflow: TextOverflow.visible,
                      style: VisaTextStyle.customLarge,
                      fontFamily: isDesktop
                          ? VisaFontWeight.regular
                          : VisaFontWeight.bold,
                      fontSize: isDesktop
                          ? AppSizes.fontThirtyTwo
                          : AppSizes.fontMedium,
                      customColor: VisaColors.white,
                      colorTheme: VisaTextTheme.customTextColor,
                      lineHeight: 1.17,
                    ),
                  ),
                ),
              ),
            ],
          ),
          _buildPackageDetailsWidget(context, isDesktop),
        ],
      ),
    );
  }

  Widget _buildPackageDetailsWidget(BuildContext context, bool isDesktop) {
    return viewModel.packageContents.isNotEmpty
        ? VisaAnimatedText(
            delay: const Duration(milliseconds: 420),
            child: Column(
              children: [
                SizedBox(height: AppSizes.heightTweentyEight),
                Container(
                  width: context.screenWidth,
                  constraints: BoxConstraints(
                    minHeight: 100.h,
                    maxHeight: context.screenHeight * 0.3,
                  ),
                  padding: EdgeInsets.symmetric(
                    horizontal: Sizes.twenty,
                    vertical: Sizes.twentyFour,
                  ),
                  decoration: ShapeDecoration(
                    color: VisaColors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(Sizes.ten),
                    ),
                    shadows: [
                      BoxShadow(
                        color: Colors.black
                            .withValues(alpha: 0.1), // soft black shadow
                        blurRadius: 4,
                        offset: const Offset(0, 4), // shadow position: x=0, y=4
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Semantics(
                        label: s.your_package_includes,
                        enabled: true,
                        container: true,
                        child: VisaTextView(
                          semantics: false,
                          text: s.your_package_includes,
                          softWrap: true,
                          overflow: TextOverflow.visible,
                          style: VisaTextStyle.customLarge,
                          fontFamily: VisaFontWeight.semibold,
                          fontSize: AppSizes.fontXXSmall,
                          customColor: VisaColors.black,
                          colorTheme: VisaTextTheme.customTextColor,
                          lineHeight: 1.50,
                          letterSpacing: -1,
                        ),
                      ),
                      SizedBox(height: Sizes.eight),
                      Flexible(
                        child: SingleChildScrollView(
                          child: Column(
                            children: viewModel.packageContents.map((item) {
                              return Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ExcludeSemantics(
                                    child: Padding(
                                      padding:
                                          EdgeInsets.only(top: Sizes.three),
                                      child: Text(
                                        '\u2022 ',
                                        style: TextStyle(
                                          fontSize: AppSizes.fontXXSmall,
                                          color: VisaColors.black,
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: Sizes.three),
                                  Flexible(
                                    child: Semantics(
                                      label: item,
                                      enabled: true,
                                      container: true,
                                      child: VisaTextView(
                                        semantics: false,
                                        text: item,
                                        softWrap: true,
                                        overflow: TextOverflow.visible,
                                        style: VisaTextStyle.customMedium,
                                        fontFamily: VisaFontWeight.regular,
                                        fontSize: AppSizes.fontXXSmall,
                                        customColor: VisaColors.black,
                                        colorTheme:
                                            VisaTextTheme.customTextColor,
                                        lineHeight: 1.25,
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            }).toList(),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          )
        : const SizedBox.shrink();
  }
}
