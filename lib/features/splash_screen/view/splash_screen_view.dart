import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:visaamigo/core/base/view/base_view.dart';
import 'package:visaamigo/core/theme/theme.dart';
import 'package:visaamigo/custom_widgets/visa_image.dart';
import 'package:visaamigo/custom_widgets/visa_textview.dart';
import 'package:visaamigo/di/service_locator.dart' show getIt;
import 'package:visaamigo/features/splash_screen/model/splash_screen_model.dart';
import 'package:visaamigo/generated/assets.dart';
import 'package:visaamigo/generated/l10n.dart';
import 'package:visaamigo/utils/app_extensions.dart';
import 'package:visaamigo/utils/const_screen_size.dart';
import 'package:visaamigo/utils/utils.dart';

class SplashScreenView extends StatefulWidget {
  final String email;

  const SplashScreenView(this.email, {super.key});

  @override
  SplashScreenViewState createState() => SplashScreenViewState();
}

class SplashScreenViewState extends State<SplashScreenView> {
  late final SplashScreenViewModel splashScreenViewModel;

  @override
  void initState() {
    super.initState();
    splashScreenViewModel =
        getIt<SplashScreenViewModel>(); // Retrieve the model using DI
    splashScreenViewModel.setContext(context);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    splashScreenViewModel
        .init(widget.email); // Initialize the model with the email
  }

  @override
  Widget build(BuildContext context) {
    return BaseView<SplashScreenViewModel>(
      viewModel: splashScreenViewModel,
      wrapWithSafeArea: false,
      showInternetDialog: false,
      onModelReady: (model) {
        Utils.announceMessage(S.of(context).splash_screen);
      },
      onlyDesktop: true,
      addDefaultPadding: false,
      statusBarDarkTheme: false,
      onPageBuilderMobileView:
          (BuildContext context, SplashScreenViewModel viewModel) {
        return Scaffold(
          resizeToAvoidBottomInset: false,
          body: SizedBox(
            height: context.screenHeight,
            width: context.screenWidth,
            child: Stack(
              children: [
                VisaImageIcon(
                  semantics: false,
                  assetPath: Assets.imagesSplashBackground,
                  height: context.screenHeight,
                  width: context.screenWidth,
                  fit: BoxFit.fill,
                ),
                Container(
                  margin: const EdgeInsets.only(top: 100).r,
                  child: Image.asset(
                    Assets.imagesBackground2,
                    height: context.screenHeight,
                    width: context.screenWidth,
                    fit: BoxFit.fill,
                  ),
                ),
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      VisaTextView(
                        text: S.of(context).goal,
                        softWrap: true,
                        semantics: false,
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.visible,
                        style: VisaTextStyle.custom,
                        fontSize: 60.sp,
                        fontFamily: VisaFontWeight.bold,
                        customColor: VisaColors.white,
                        colorTheme: VisaTextTheme.customTextColor,
                        letterSpacing: -1,
                        lineHeight: (52 / 60).toDouble(),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                                vertical: Sizes.twentyNine,
                                horizontal: Sizes.sixteen)
                            .r,
                        child: VisaTextView(
                          text: S.of(context).you_are_going_fifa,
                          softWrap: true,
                          semantics: false,
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.visible,
                          style: VisaTextStyle.custom,
                          fontSize: 32.sp,
                          fontFamily: VisaFontWeight.bold,
                          lineHeight: (32 / 32).toDouble(),
                          letterSpacing: -1,
                          customColor: VisaColors.white,
                          colorTheme: VisaTextTheme.customTextColor,
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  bottom: 36,
                  child: SizedBox(
                    width: context.screenWidth,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SvgPicture.asset(Assets.iconsIcVisaLogo),
                        AppSizes.xxsmallVS,
                        VisaTextView(
                          text: S
                              .of(context)
                              .everywhere_you_want
                              .capitalizeEachWord(),
                          softWrap: true,
                          semantics: false,
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.visible,
                          style: VisaTextStyle.customMedium,
                          fontFamily: VisaFontWeight.medium,
                          customColor: VisaColors.white,
                          colorTheme: VisaTextTheme.customTextColor,
                          lineHeight: (18 / 14).toDouble(),
                          letterSpacing: -0.5,
                        ),
                      ],
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
