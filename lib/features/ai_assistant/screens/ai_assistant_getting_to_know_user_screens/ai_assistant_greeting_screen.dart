import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart' show GetIt;
import 'package:provider/provider.dart';
import 'package:visaamigo/core/theme/theme.dart';
import 'package:visaamigo/custom_widgets/visa_button.dart'
    show VisaButton, VisaButtonVariant;
import 'package:visaamigo/custom_widgets/visa_svg_icon.dart';
import 'package:visaamigo/custom_widgets/visa_textview.dart';
import 'package:visaamigo/features/ai_assistant/providers/ai_assistant_greeting_provider.dart';
import 'package:visaamigo/features/ai_assistant/screens/ai_assistant_getting_to_know_user_screens/widgets/ai_assistant_animated_text.dart';
import 'package:visaamigo/features/profile/provider/user_generic_detail_provider.dart';
import 'package:visaamigo/generated/assets.dart';
import 'package:visaamigo/generated/l10n.dart' show S;
import 'package:visaamigo/utils/app_extensions.dart';
import 'package:visaamigo/utils/const_screen_size.dart';
import 'package:visaamigo/utils/date_util.dart';

import '../../../../core/base/view/base_view.dart';
import '../../../../utils/test_style_util.dart';
import '../../../home/providers/navigation_provider.dart';

class AiAssistantGreetingScreen extends StatefulWidget {
  const AiAssistantGreetingScreen({super.key});

  @override
  State<AiAssistantGreetingScreen> createState() =>
      _AiAssistantGreetingScreenState();
}

class _AiAssistantGreetingScreenState extends State<AiAssistantGreetingScreen> {
  late final AiAssistantGreetingProvider viewModel;
  late NavigationProvider navigationBar;
  late S s;

  @override
  void initState() {
    super.initState();
    // Retrieve dependencies using GetIt
    viewModel = GetIt.I<AiAssistantGreetingProvider>();

    navigationBar = Provider.of<NavigationProvider>(context, listen: false);

    viewModel.setContext(context);
    viewModel.init(navigationBar);
  }

  navigateHomeScreen() {
    if (viewModel.evaIntroNode != "true") {
      viewModel.navPop();
    }
  }

  @override
  Widget build(BuildContext context) {
    s = S.of(context);
    final evaIntroNode =
        Provider.of<UserGenericProvider>(context, listen: false).evaIntroNode;

    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        if (!didPop) {
          navigateHomeScreen();
        }
        // For Android Back Button Handling
      },
      child: BaseView<AiAssistantGreetingProvider>(
        viewModel: viewModel,
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
        onModelReady: (model) {},
        onPageBuilderMobileView:
            (BuildContext context, AiAssistantGreetingProvider viewModel) {
          return SizedBox(
            height: context.screenHeight,
            width: context.screenWidth,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.r),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppSizes.largeVS,
                  Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: AppSizes.heightSmall),
                    child: VisaSvgIcon(
                      semantics: false,
                      assetPath: Assets.iconsIcVisaLogo,
                      width: AppSizes.fiftyTwoWidth,
                      color: VisaColors.white,
                      isIconFlip: false,
                      setColorFilter: false,
                      height: AppSizes.heightTweentyFour,
                    ),
                  ),
                  evaIntroNode == "true"
                      ? SizedBox(
                          height: (context.screenHeight * 0.212).h,
                        )
                      : SizedBox(
                          height: AppSizes.heightFiftyFive,
                        ),
                  Semantics(
                    enabled: true,
                    container: true,
                    excludeSemantics: true,
                    label:
                        "${DateUtil.getTimeOfDayGreetingWithPreFix(context, true)}, ${(viewModel.userModel != null ? "${viewModel.userModel?.firstName}!" : "")}",
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        VisaAnimatedText(
                          child: VisaTextView(
                            text:
                                "${DateUtil.getTimeOfDayGreetingWithPreFix(context, true)},",
                            softWrap: true,
                            overflow: TextOverflow.visible,
                            style: VisaTextStyle.customLarge,
                            fontFamily: VisaFontWeight.bold,
                            fontSize: Sizes.sixtyInt.toDouble(),
                            customColor: VisaColors.white,
                            colorTheme: VisaTextTheme.customTextColor,
                          ),
                        ),
                        SizedBox(
                          height: AppSizes.fiveRadius.h,
                        ),
                        VisaAnimatedText(
                          delay: const Duration(milliseconds: 250),
                          child: AutoSizeText(
                            (viewModel.userModel != null
                                ? "${viewModel.userModel?.firstName}!"
                                : ""),
                            maxLines: 1,
                            minFontSize: AppSizes.thirtyradius.roundToDouble(),
                            // maxFontSize: Sizes.sixtyInt.roundToDouble(),
                            overflow: TextOverflow.ellipsis,
                            stepGranularity: 0.1,

                            // Allows decimal stepping
                            style: VisaTextUtils.getVisaTextStyle(
                              VisaTextStyle.custom,
                              context: context,
                              isDarkMode: false,
                              letterSpacing: -1,
                              fontSize: AppSizes.sixtyInt.toDouble(),
                              lineHeight: 0.87,
                              fontFamily: VisaFontWeight.bold,
                              // colorTheme: VisaTextTheme.customTextColor,
                              fontColor: VisaColors.white,
                            ),
                          ) /*VisaTextView(
                          text:
                              "${(viewModel.userModel != null ? (viewModel.userModel?.firstName) : "")}!",
                          softWrap: true,
                          overflow: TextOverflow.visible,
                          style: VisaTextStyle.customLarge,
                          fontFamily: VisaFontWeight.bold,
                          fontSize: Sizes.sixtyInt.toDouble(),
                          customColor: VisaColors.white,
                          colorTheme: VisaTextTheme.customTextColor,
                        )*/
                          ,
                        ),
                      ],
                    ),
                  ),
                  evaIntroNode == "true"
                      ? const SizedBox.shrink()
                      : contentWidget(),
                  Expanded(child: Container()),
                  evaIntroNode == "true"
                      ? const SizedBox.shrink()
                      : buttonsWidget(viewModel)
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget buttonsWidget(AiAssistantGreetingProvider viewModel) =>
      VisaAnimatedText(
        delay: const Duration(milliseconds: 450),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: AppSizes.sixteenRadius,
            vertical: AppSizes.twentyEightRadius,
          ),
          child: Row(
            // spacing: Sizes.eighteen,
            children: [
              Expanded(
                flex: 1,
                child: VisaButton(
                  text: s.back,
                  height: AppSizes.fiftySevenInt.toDouble(),
                  width: AppSizes.oneThirtyTwo.toDouble(),
                  variant: viewModel.isDesktopView
                      ? VisaButtonVariant.primary
                      : VisaButtonVariant.black,
                  fontWeight: VisaFontWeight.medium,
                  letterSpacing: AppSizes.zero,
                  buttonTextColor: VisaColors.black,
                  isOutlined: viewModel.isDesktopView ? false : true,
                  onPressed: () async {
                    navigateHomeScreen();
                  },
                ),
              ),
              SizedBox(
                width: 22.w,
              ),
              Expanded(
                flex: 2,
                child: VisaButton(
                  text: s.txt_continue,
                  height: AppSizes.fiftySevenInt.toDouble(),
                  width: context.screenWidth,
                  variant: VisaButtonVariant.primary,
                  fontWeight: VisaFontWeight.medium,
                  letterSpacing: AppSizes.zero,
                  onPressed: () async {
                    viewModel.changeGreetingScreenData();
                    viewModel.onNavigateEva(navigationBar);
                  },
                ),
              ),
            ],
          ),
        ),
      );

  Widget contentWidget() => Padding(
        padding: EdgeInsets.only(top: AppSizes.thirtyHeight),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            VisaAnimatedText(
              delay: const Duration(milliseconds: 350),
              child: VisaSvgIcon(
                semantics: false,
                assetPath: Assets.iconsIcEvaGeneric,
                color: VisaColors.white,
                width: AppSizes.dimMedium,
              ),
            ),
            SizedBox(
              width: 11.54.w,
            ),
            Flexible(
              child: VisaAnimatedText(
                delay: const Duration(milliseconds: 350),
                child: VisaTextView(
                  text: s.greeting_screen_content,
                  softWrap: true,
                  semanticsIndex: 2,
                  overflow: TextOverflow.visible,
                  style: VisaTextStyle.customLarge,
                  fontFamily: viewModel.isDesktopView
                      ? VisaFontWeight.regular
                      : VisaFontWeight.bold,
                  fontSize: viewModel.isDesktopView
                      ? AppSizes.fontThirtyTwo
                      : AppSizes.fontMedium,
                  customColor: VisaColors.white,
                  colorTheme: VisaTextTheme.customTextColor,
                  lineHeight: 1.17,
                ),
              ),
            ),
          ],
        ),
      );
}
