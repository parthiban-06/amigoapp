import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:visaamigo/analytics/firebase_analytics_service.dart';
import 'package:visaamigo/utils/app_extensions.dart';

import '../../../core/theme/theme.dart';
import '../../../custom_widgets/visa_text_field.dart';
import '../../../custom_widgets/visa_textview.dart';
import '../../../generated/l10n.dart';
import '../../../utils/const_screen_size.dart';
import '../../../utils/utils.dart';
import '../model/confirm_code_model.dart';

class ConfirmCodeTextFieldsWidget extends StatelessWidget {
  final ConfirmCodeModel viewModel;
  final bool isDesktop;
  final bool isMobileWeb;

  const ConfirmCodeTextFieldsWidget({
    super.key,
    required this.viewModel,
    required this.isDesktop,
    required this.isMobileWeb,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          VisaTextView(
            text: S.of(context).we_sent_an_auth,
            softWrap: true,
            overflow: TextOverflow.visible,
            style: VisaTextStyle.displayTitleMedium,
            fontFamily: VisaFontWeight.semibold,
            customColor: VisaColors.black,
            colorTheme: VisaTextTheme.customTextColor,
            letterSpacing: -1,
            lineHeight: 1.04,
          ),
          AppSizes.mediumVS,
          VisaTextView(
            semantics: false,
            text: S.of(context).required_field,
            softWrap: true,
            overflow: TextOverflow.visible,
            style: VisaTextStyle.custom,
            fontSize: Sizes.twelveInt.toDouble(),
            fontFamily: VisaFontWeight.regular,
            customColor: VisaColors.dividerColor,
            colorTheme: VisaTextTheme.customTextColor,
            letterSpacing: 0,
            lineHeight: (16 / 12.sp).h,
          ),
          AppSizes.xsmallVS,
          VisaTextField(
            controller: viewModel.code,
            textInputType: TextInputType.number,
            maxLength: 6,
            eventName: AnalyticsEventConst.EVENT_NAME_OTP_VERIFICATIONERROR,
            otpErrorType: viewModel.isSignUp,
            isEnable: !viewModel.isDisableField,
            errorText: viewModel.errorText ??
                (viewModel.code.text.trim().isEmpty
                    ? S.of(context).verification_code_is_required
                    : S.of(context).invalid_verification_code),
            hint: S.of(context).enter_your_verification_code,
            label: S.of(context).verification_code,
            letterSpacing: 0,
            onTap: (_) {
              if (!_) {
                viewModel.validate();
              } else {
                viewModel.onShowError();
              }
            },
            onChanged: (_) {
              viewModel.validStateChange();
            },
            isValid: viewModel.errorText == null &&
                (viewModel.code.text.trim().length == 6),
          ),
          viewModel.codeSent
              ? Column(
                  children: [
                    VisaTextView(
                      text: S.of(context).your_code_was_resent,
                      softWrap: true,
                      overflow: TextOverflow.visible,
                      style: VisaTextStyle.customMedium,
                      fontFamily: VisaFontWeight.semibold,
                      customColor: VisaColors.green,
                      colorTheme: VisaTextTheme.customTextColor,
                    ),
                    AppSizes.smallVS,
                  ],
                )
              : const SizedBox(),
          if (!isDesktop || !isMobileWeb)
            // VSpacings.small,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                VisaTextView(
                  text: S.of(context).did_not_receive_a_code,
                  softWrap: true,
                  overflow: TextOverflow.visible,
                  style: VisaTextStyle.customMedium,
                  fontFamily: VisaFontWeight.regular,
                  customColor: VisaColors.black,
                  lineHeight: 2,
                  textLineHeight: 2,
                  colorTheme: VisaTextTheme.customTextColor,
                ),
                viewModel.canSendOtp
                    ? InkWell(
                        onTap: () {
                          viewModel.startCountdown();
                          Utils.hideKeyboard(context);
                        },
                        child: Semantics(
                          excludeSemantics: true,
                          container: true,
                          label:
                              "${S.of(context).reSend_code}, ${S.of(context).double_tap_to_activate_link}",
                          child: VisaTextView(
                            semantics: false,
                            text: S.of(context).reSend_code,
                            softWrap: true,
                            overflow: TextOverflow.visible,
                            style: VisaTextStyle.link,
                            lineHeight: 2,
                            textLineHeight: 2,
                            fontFamily: VisaFontWeight.semibold,
                            colorTheme: VisaTextTheme.primary,
                          ),
                        ),
                      )
                    : VisaTextView(
                        text:
                            "${(viewModel.duration / 60).floor().toString().padLeft(2, "0")}:${(viewModel.duration % 60).floor().toString().padLeft(2, "0")}",
                        softWrap: true,
                        overflow: TextOverflow.visible,
                        style: VisaTextStyle.customMedium,
                        fontFamily: VisaFontWeight.semibold,
                        customColor: VisaColors.grey,
                        lineHeight: 2,
                        textLineHeight: 2,
                        colorTheme: VisaTextTheme.customTextColor,
                      ),
              ],
            ),
          if (isDesktop || isMobileWeb)
            Column(
              children: [
                const SizedBox(
                  height: 30,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Semantics(
                      enabled: true,
                      excludeSemantics: true,
                      checked: viewModel.checkBoxMFA,
                      label:
                          "${S.of(context).mfa_auth} ${S.of(context).check_box} ${viewModel.checkBoxMFA == true ? S.of(context).checked : S.of(context).unchecked}",
                      child: Checkbox(
                        value: viewModel.checkBoxMFA,
                        onChanged: (_) {
                          viewModel.mfaCheckBoxChange();
                        },
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            VisaTextView(
                              text: S.of(context).mfa_auth,
                              softWrap: true,
                              overflow: TextOverflow.visible,
                              style: VisaTextStyle.customMedium,
                              fontFamily: VisaFontWeight.semibold,
                              fontSize: 14.sp,
                              colorTheme: VisaTextTheme.customTextColor,
                            ),
                            SizedBox(
                              width: context.screenWidth,
                              child: VisaTextView(
                                text: S.of(context).help_protect_ur_acc,
                                softWrap: true,
                                overflow: TextOverflow.visible,
                                style: VisaTextStyle.customMedium,
                                fontFamily: VisaFontWeight.regular,
                                fontSize: 14.sp,
                                colorTheme: VisaTextTheme.customTextColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
                const SizedBox(
                  height: 30,
                ),
              ],
            )
        ],
      ),
    );
  }
}
