import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:visaamigo/analytics/firebase_analytics_service.dart';

import '../../../core/theme/theme.dart';
import '../../../custom_widgets/visa_text_field.dart';
import '../../../custom_widgets/visa_textview.dart';
import '../../../generated/l10n.dart';
import '../../../utils/app_const.dart';
import '../../../utils/const_screen_size.dart';
import '../../../utils/validation.dart';
import '../providers/registered_email_providers.dart';

class RegisteredEmailTextFieldsWidget extends StatelessWidget {
  final RegisteredEmailModel viewModel;

  const RegisteredEmailTextFieldsWidget({
    super.key,
    required this.viewModel,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          VisaTextView(
            text: S.of(context).welcome_please,
            softWrap: true,
            overflow: TextOverflow.visible,
            style: VisaTextStyle.displayTitleMedium,
            fontFamily: VisaFontWeight.semibold,
            customColor: VisaColors.black,
            colorTheme: VisaTextTheme.customTextColor,
            letterSpacing: -1,
            lineHeight: 1.04,
          ),
          AppSizes.xsmallVS,
          VisaTextView(
            text: S.of(context).guide_for_email,
            softWrap: true,
            overflow: TextOverflow.visible,
            style: VisaTextStyle.custom,
            fontSize: AppSizes.fontTwelve,
            fontFamily: VisaFontWeight.regular,
            customColor: VisaColors.dividerColor,
            colorTheme: VisaTextTheme.customTextColor,
            letterSpacing: 0,
            lineHeight: (16 / 12.sp).h,
          ),
          AppSizes.mediumVS,
          VisaTextView(
            semantics: false,
            text: S.of(context).required_field,
            softWrap: true,
            overflow: TextOverflow.visible,
            style: VisaTextStyle.custom,
            fontSize: AppSizes.fontTwelve,
            fontFamily: VisaFontWeight.regular,
            customColor: VisaColors.dividerColor,
            colorTheme: VisaTextTheme.customTextColor,
            letterSpacing: 0,
            lineHeight: (16 / 12.sp).h,
          ),
          AppSizes.xsmallVS,
          VisaTextField(
            isLowerCase: true,
            semanticsLabel:
                "${S.of(context).edit_box}, ${S.of(context).your_registered_email}, "
                "${S.of(context).double_tap_to_edit}",
            controller: viewModel.emailTextController,
            hint: S.of(context).your_registered_email,
            label: S.of(context).login_username,
            eventName: AnalyticsEventConst.EVENT_NAME_EMAIL_AUTH_ERROR,
            textInputType: TextInputType.emailAddress,
            maxLength: AppConst.TEXTFIELD_EMAIL_LENGTH,
            disableError: false,
            letterSpacing: 0,
            errorText: viewModel.errorText ??
                (viewModel.emailTextController.text.trim().isEmpty
                    ? S.of(context).email_is_required
                    : S.of(context).invalid_email),
            onTap: (_) {
              if (!_) {
                viewModel.validate();
              }
            },
            onChanged: (_) {
              viewModel.validStateChange();
            },
            isValid: viewModel.errorText == null &&
                Validation.emailValid
                    .hasMatch(viewModel.emailTextController.text.trim()),
          ),
        ],
      ),
    );
  }
}
