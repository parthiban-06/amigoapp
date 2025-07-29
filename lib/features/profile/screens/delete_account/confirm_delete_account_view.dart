import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart' show GetIt;
import 'package:visaamigo/custom_widgets/visa_size_box.dart';
import 'package:visaamigo/features/profile/provider/delete_account_provider.dart';

import '../../../../core/base/view/base_view.dart';
import '../../../../core/theme/theme.dart';
import '../../../../custom_widgets/custom_visa_two_button.dart';
import '../../../../custom_widgets/visa_appbar.dart';
import '../../../../custom_widgets/visa_text_field.dart';
import '../../../../custom_widgets/visa_textview.dart';
import '../../../../generated/l10n.dart';
import '../../../../utils/const_screen_size.dart';
import '../../../../utils/responsive_util.dart';
import '../../../../utils/utils.dart';
import '../../../../utils/validation.dart';

class ConfirmDeleteAccountView extends StatefulWidget {
  const ConfirmDeleteAccountView({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ConfirmDeleteAccountViewState createState() =>
      _ConfirmDeleteAccountViewState();
}

class _ConfirmDeleteAccountViewState extends State<ConfirmDeleteAccountView> {
  late DeleteAccountProvider deleteAccountProvider;
  late ResponsiveUtil responsiveUtil;
  late S s;

  @override
  void initState() {
    super.initState();
    // Retrieve DeleteAccountProvider from get_it
    deleteAccountProvider = GetIt.I<DeleteAccountProvider>();
    // Initialize the provider
    deleteAccountProvider.getUserEmail();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    responsiveUtil = GetIt.I<ResponsiveUtil>(param1: context);
    s = S.of(context);
  }

  @override
  Widget build(BuildContext context) {
    return BaseView<DeleteAccountProvider>(
      viewModel: deleteAccountProvider,
      setTopSafeArea: false,
      addDefaultPadding: false,
      buildAppBar: VisaAppBar(
        isActionButtonShow: true,
        isCancelWithTextButtonShow: true,
        onCancelPress: () {
          Navigator.of(context).pop();
        },
      ),
      onPageBuilderMobileView: (context, viewModel) {
        return Padding(
          padding: EdgeInsets.symmetric(
            horizontal: AppSizes.dimSmall,
            vertical: AppSizes.heightSmall,
          ),
          child: SizedBox(
            child: Form(
              key: viewModel.formKey,
              child: Column(
                mainAxisAlignment: responsiveUtil.isDesktop(context: context)
                    ? MainAxisAlignment.center
                    : MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          VisaTextView(
                            text: s.confirm_account_deletion,
                            softWrap: true,
                            overflow: TextOverflow.visible,
                            style: VisaTextStyle.customLarge,
                            fontFamily: VisaFontWeight.semibold,
                            fontSize: AppSizes.fontXSmall,
                            maxLines: 1,
                            customColor: VisaColors.black,
                            colorTheme: VisaTextTheme.customTextColor,
                            letterSpacing: -1,
                            lineHeight: 1.04,
                          ),
                          VisaSizeBox(
                            height: Sizes.sixteenInt.toDouble(),
                          ),
                          VisaTextView(
                            text: s.enter_password_to_confirm,
                            softWrap: true,
                            overflow: TextOverflow.visible,
                            style: VisaTextStyle.customLarge,
                            fontFamily: VisaFontWeight.medium,
                            fontSize: AppSizes.fontfourteen,
                            customColor: VisaColors.black,
                            colorTheme: VisaTextTheme.customTextColor,
                            lineHeight: 1.29,
                          ),
                          AppSizes.mediumVS,
                          VisaTextView(
                            semantics: false,
                            text: S.of(context).required_field,
                            softWrap: true,
                            overflow: TextOverflow.visible,
                            style: VisaTextStyle.customLarge,
                            fontSize: 12.sp,
                            fontFamily: VisaFontWeight.regular,
                            customColor: VisaColors.dividerColor,
                            colorTheme: VisaTextTheme.customTextColor,
                            letterSpacing: 0,
                            lineHeight: (16 / 12.sp).h,
                          ),
                          AppSizes.xxsmallVS,
                          VisaTextField(
                            controller: viewModel.password,
                            hint: s.enter_your_password,
                            isPassword: true,
                            label: s.password,
                            useCustomObscureCharacter: false,
                            errorText: viewModel.errorText ??
                                (viewModel.password.text.trim().isEmpty
                                    ? s.password_is_required
                                    : s.invalid_pass),
                            disableError: true,
                            onTap: (_) {
                              if (!_) {
                                viewModel.validate(s.enter_your_password);
                              } else {
                                viewModel.onShowError();
                              }
                            },
                            onChanged: (_) {
                              viewModel.validPassState(s.enter_your_password);
                            },
                            isValid: viewModel.errorText == null &&
                                    (Validation.password.hasMatch(
                                        viewModel.password.text.trim())) ||
                                (!viewModel.formValid
                                        .contains(s.enter_your_password) &&
                                    viewModel.formValid.isNotEmpty),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CustomTwoButtons(
                        leftButtonText: S.of(context).back,
                        rightButtonText: S.of(context).txt_continue,
                        rightButtonDisable: viewModel.isDisable,
                        onLeftButtonPressed: () {
                          viewModel.closeScreen();
                        },
                        onRightButtonPressed: () {
                          Utils.removeFocus();
                          viewModel.checkConfirmPassword();
                        },
                        isRightButtonLoading: false,
                        isLeftButtonLoading: false,
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
