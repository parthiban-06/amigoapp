import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart' show GetIt;
import 'package:visaamigo/analytics/firebase_analytics_service.dart';
import 'package:visaamigo/core/base/view/base_view.dart';
import 'package:visaamigo/core/theme/theme.dart';
import 'package:visaamigo/custom_widgets/visa_button.dart';
import 'package:visaamigo/custom_widgets/visa_font_family.dart';
import 'package:visaamigo/custom_widgets/visa_size_box.dart';
import 'package:visaamigo/custom_widgets/visa_textview.dart';
import 'package:visaamigo/features/profile/model/profile_model.dart';
import 'package:visaamigo/features/profile/screens/profile_card_screen.dart';
import 'package:visaamigo/features/profile/widgets/profile_companion_details.dart';
import 'package:visaamigo/features/profile/widgets/profile_help.dart';
import 'package:visaamigo/features/profile/widgets/profile_setting.dart';
import 'package:visaamigo/features/profile/widgets/profile_your_wallet_card.dart';
import 'package:visaamigo/generated/l10n.dart';
import 'package:visaamigo/utils/app_extensions.dart';
import 'package:visaamigo/utils/const_screen_size.dart';
import 'package:visaamigo/utils/utils.dart';

import '../../../custom_widgets/visa_appbar.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ProfileViewState createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  late ProfileViewModel profileViewModel;
  late S s;
  late double ten;

  @override
  void initState() {
    super.initState();
    profileViewModel = GetIt.I<ProfileViewModel>();
    // profileViewModel.init();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    s = S.of(context);
    ten = AppSizes.ten;
  }

  @override
  Widget build(BuildContext context) {
    return BaseView<ProfileViewModel>(
      viewModel: profileViewModel,
      setTopSafeArea: false,
      addDefaultPadding: false,
      onlyDesktop: true,
      onModelReady: (model) {
        model.init();
      },
      // onPopInvokedWithResult: (didPop, result) {
      //   closeSnackBar(context: context);
      // },
      buildAppBar: VisaAppBar(
        isActionButtonShow: true,
        isCancelWithTextButtonShow: true,
        onCancelPress: () {
          Navigator.of(context).pop();
        },
      ),
      onPageBuilderMobileView:
          (BuildContext context, ProfileViewModel viewModel) {
        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // AppBar

              Padding(
                padding: EdgeInsets.symmetric(horizontal: AppSizes.dimSmall),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Profile Title
                    VisaSizeBox(
                      height: ten,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: ten),
                      child: VisaTextView(
                        text: S.of(context).profile,
                        softWrap: true,
                        overflow: TextOverflow.visible,
                        style: VisaTextStyle.customLarge,
                        fontFamily: VisaFontWeight.semibold,
                        fontSize: AppSizes.fontXSmall,
                        maxLines: 1,
                        customColor: VisaColors.black,
                        colorTheme: VisaTextTheme.customTextColor,
                        letterSpacing: -1,
                      ),
                    ),
                    VisaSizeBox(
                      height: ten,
                    ),
                    ProfileCardView(
                      onChange: () {
                        viewModel.init();
                      },
                      userModel: viewModel.userModel,
                    ),

                    (viewModel.isCompanion)
                        ? const SizedBox()
                        : Column(
                            children: [
                              viewModel.showWallet
                                  ? const ProfileYourWalletCard()
                                  : const SizedBox(),
                              (viewModel.showCompanion)
                                  ? ProfileCompanionDetails(
                                      viewModel: viewModel,
                                    )
                                  : const SizedBox(),
                            ],
                          ),

                    ProfileSetting(
                      notificationSectionGlobalKey:
                          viewModel.notificationSectionKey,
                      onChangeMFA: (_) {
                        viewModel.changeMFA();
                      },
                      onChangeNotificationPermission: (val) {
                        viewModel.toggleNotificationPermission(val);
                      },
                      showBiometrics: viewModel.showBiometrics,
                      onChangeBiometrics: (_) {
                        viewModel.changeBiometrics();
                      },
                      dateTime24Hrs: viewModel.dateTime24Hrs,
                      analyticsConsent: viewModel.analyticsConcern,
                      onChange24Hrs: (_) {
                        viewModel.update24hoursDateTime();
                      },
                      onChangeAnalyticsConsent: (value) {
                        viewModel.updateAnalyticsConcern(value);
                      },
                      mfa: viewModel.mfa,
                      notificationPermission: viewModel.notificationPermission,
                      biometric: viewModel.biometrics,
                    ),
                    ProfileHelp(
                      viewModel: viewModel,
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: AppSizes.heightSmall),
                      child: VisaButton(
                        text: S.of(context).logout,
                        onPressed: () {
                          viewModel.logout();
                        },
                        height: 57,
                        isOutlined: true,
                        fontWeight: VisaFontWeight.semibold,
                        variant: VisaButtonVariant.transparent,
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        viewModel.navigateToDeleteAccount();
                      },
                      child: SizedBox(
                        height: AppSizes.heightSeventySeven,
                        width: context.screenWidth,
                        child: Center(
                          child: Semantics(
                            button: true,
                            label: S.of(context).delete_my_account,
                            excludeSemantics: true,
                            child: Text(
                              S.of(context).delete_my_account,
                              textScaler:
                                  TextScaler.linear(Utils.getCappedScale(
                                context,
                                AppSizes.fontMedium,
                              )),
                              style: TextStyle(
                                fontFamily: VisaFontFamily.getFontFamily(
                                    VisaFontWeight.medium, false),
                                color: VisaColors.red,
                                fontSize: AppSizes.fontMedium,
                                fontWeight: FontWeight.w500,
                                decoration: TextDecoration.underline,
                                decorationColor: VisaColors.red,
                                decorationThickness: 2.0,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    AppSizes.smallVS,
                    Align(
                      alignment: Alignment.center,
                      child: VisaTextView(
                        text:
                            "${S.of(context).app_version} ${FirebaseAnalyticsService.packageInfo?.version} (${FirebaseAnalyticsService.packageInfo?.buildNumber})",
                        style: VisaTextStyle.displayBodyXs,
                        fontFamily: VisaFontWeight.regular,
                        overflow: TextOverflow.fade,
                        textAlign: TextAlign.center,
                        customColor: VisaColors.textFieldBorder,
                        colorTheme: VisaTextTheme.customTextColor,
                      ),
                    ),
                    AppSizes.mediumVS,
                  ],
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
