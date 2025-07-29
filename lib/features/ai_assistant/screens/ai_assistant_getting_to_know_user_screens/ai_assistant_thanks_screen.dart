import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart' show GetIt;
import 'package:visaamigo/custom_widgets/visa_textview.dart';
import 'package:visaamigo/features/ai_assistant/screens/ai_assistant_getting_to_know_user_screens/widgets/ai_assistant_animated_text.dart';
import 'package:visaamigo/utils/app_extensions.dart';
import 'package:visaamigo/utils/utils.dart';

import '../../../../core/base/view/base_view.dart';
import '../../../../core/theme/theme.dart';
import '../../../../custom_widgets/visa_appbar.dart';
import '../../../../custom_widgets/visa_button.dart';
import '../../../../custom_widgets/visa_svg_icon.dart';
import '../../../../generated/assets.dart';
import '../../../../generated/l10n.dart';
import '../../../../utils/const_screen_size.dart';
import '../../../../utils/test_style_util.dart';
import '../../providers/ai_assistant_welcome_screen_provider.dart';

class AiAssistantThanksScreen extends StatefulWidget {
  const AiAssistantThanksScreen({super.key});

  @override
  State<AiAssistantThanksScreen> createState() =>
      _AiAssistantThanksScreenState();
}

class _AiAssistantThanksScreenState extends State<AiAssistantThanksScreen> {
  late final AiAssistantWelcomeScreenProvider viewModel;
  late S s;

  @override
  void initState() {
    super.initState();
    // Retrieve dependencies using GetIt
    viewModel = GetIt.I<AiAssistantWelcomeScreenProvider>();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    s = S.of(context);
  }

  @override
  Widget build(BuildContext context) {
    return BaseView<AiAssistantWelcomeScreenProvider>(
      screenBackgroundColor: VisaColors.primary,
      extendBodyBehindAppBar: false,
      addDefaultPadding: false,
      wrapWithSafeArea: false,
      screenBackgroundImage: Positioned.fill(
        child: Image.asset(
          Assets.imagesBackground3, // Replace with your image path
          fit: BoxFit.fill,
        ),
      ),
      viewModel: viewModel,
      onModelReady: (model) {
        model.init();
        Utils.announceMessage(s.thanks_screen);
      },
      buildAppBar: const VisaAppBar(
        brandingLogoColor: VisaColors.white,
      ),
      onPageBuilderMobileView:
          (BuildContext context, AiAssistantWelcomeScreenProvider viewModel) {
        return SizedBox(
          height: context.screenHeight,
          width: context.screenWidth,
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: Sizes.sixteen,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Semantics(
                        enabled: true,
                        container: true,
                        excludeSemantics: true,
                        label:
                            "${s.thanks}, ${(viewModel.userModel != null ? "${viewModel.userModel?.firstName}!" : "")}",
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            VisaAnimatedText(
                              delay: const Duration(milliseconds: 150),
                              child: VisaTextView(
                                text: s.thanks,
                                softWrap: true,
                                overflow: TextOverflow.visible,
                                style: VisaTextStyle.customLarge,
                                fontFamily: VisaFontWeight.bold,
                                fontSize: Sizes.sixtyInt.toDouble(),
                                customColor: VisaColors.white,
                                colorTheme: VisaTextTheme.customTextColor,
                                letterSpacing: -1,
                                lineHeight: 0.87,
                              ),
                            ),
                            AppSizes.xxsmallVS,
                            VisaAnimatedText(
                              delay: const Duration(milliseconds: 250),
                              child: AutoSizeText(
                                "${(viewModel.userModel != null ? "${viewModel.userModel?.firstName}" : "")}!",
                                maxLines: 1,
                                minFontSize: Sizes.thirty.roundToDouble(),
                                textScaleFactor: Utils.getCappedScale(
                                  context,
                                  Sizes.sixtyInt.toDouble(),
                                ),
                                // maxFontSize: Sizes.sixtyInt.roundToDouble(),
                                overflow: TextOverflow.ellipsis,
                                stepGranularity: 0.1,
                                // Allows decimal stepping
                                style: VisaTextUtils.getVisaTextStyle(
                                  VisaTextStyle.custom,
                                  context: context,
                                  isDarkMode: false,
                                  letterSpacing: -1,
                                  fontSize: Sizes.sixtyInt.toDouble(),
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
                          letterSpacing: -1,
                          lineHeight: 0.87,
                        )*/
                              ,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: Sizes.fortyThreeInt.h,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const VisaAnimatedText(
                            delay: Duration(milliseconds: 350),
                            child: VisaSvgIcon(
                              semantics: false,
                              assetPath: Assets.iconsIcEvaGeneric,
                              color: VisaColors.white,
                            ),
                          ),
                          SizedBox(
                            width: 11.54.w,
                          ),
                          Flexible(
                            child: VisaAnimatedText(
                              delay: const Duration(milliseconds: 350),
                              child: VisaTextView(
                                text: s.i_know_more_about,
                                softWrap: true,
                                overflow: TextOverflow.visible,
                                style: VisaTextStyle.customLarge,
                                fontFamily: VisaFontWeight.bold,
                                fontSize: AppSizes.fontMedium,
                                customColor: VisaColors.white,
                                colorTheme: VisaTextTheme.customTextColor,
                                lineHeight: 1.17,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 28.h), //28.h
                  child: VisaAnimatedText(
                    delay: const Duration(milliseconds: 450),
                    child: VisaButton(
                      text: s.txt_continue,
                      onPressed: () {
                        viewModel.navigateToHomeScreen();
                      },
                      fontWeight: VisaFontWeight.medium,
                      variant: VisaButtonVariant.primary,
                      // fontSize: Sizes.sixteenInt.toDouble(),
                      // lineHeight: 1.50,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
