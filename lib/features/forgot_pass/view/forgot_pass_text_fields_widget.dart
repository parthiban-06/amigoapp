import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/theme/theme.dart';
import '../../../custom_widgets/visa_text_field.dart';
import '../../../custom_widgets/visa_textview.dart';
import '../../../generated/l10n.dart';
import '../../../utils/app_const.dart';
import '../../../utils/const_screen_size.dart';
import '../../../utils/validation.dart';
import '../model/forgot_pass_model.dart';

class ForgotPassTextFieldsWidget extends StatelessWidget {
  final ForgotPassModel viewModel;

  const ForgotPassTextFieldsWidget({
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
            text: S.of(context).forgot_password_please_ent,
            softWrap: true,
            overflow: TextOverflow.visible,
            style: VisaTextStyle.displayTitleMedium,
            fontFamily: VisaFontWeight.semibold,
            customColor: VisaColors.black,
            colorTheme: VisaTextTheme.customTextColor,
            letterSpacing: -1,
            lineHeight: 1.04,
          ),
          AppSizes.smallVS,
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
            controller: viewModel.email,
            semanticsLabel:
                "${S.of(context).edit_box}, ${S.of(context).your_registered_email}, "
                "${S.of(context).double_tap_to_edit}",
            isLowerCase: true,
            hint: S.of(context).your_registered_email,
            label: S.of(context).login_username,
            textInputType: TextInputType.emailAddress,
            maxLength: AppConst.TEXTFIELD_EMAIL_LENGTH,
            errorText: viewModel.errorText ??
                (viewModel.email.text.trim().isEmpty
                    ? S.of(context).email_is_required
                    : S.of(context).invalid_email),
            disableError: true,
            letterSpacing: 0,
            onChanged: (_) {
              viewModel.validStateChange();
            },
            onTap: (_) {
              if (!_) {
                viewModel.validate();
              }
            },
            isValid: viewModel.errorText == null &&
                Validation.emailValid.hasMatch(viewModel.email.text),
          ),
        ],
      ),
    );
  }
}
