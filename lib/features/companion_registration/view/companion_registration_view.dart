import 'package:flutter/material.dart';
import 'package:visaamigo/core/base/view/base_view.dart';
import 'package:visaamigo/core/theme/theme.dart';
import 'package:visaamigo/custom_widgets/visa_appbar.dart';
import 'package:visaamigo/custom_widgets/visa_button.dart';
import 'package:visaamigo/custom_widgets/visa_checkbox.dart';
import 'package:visaamigo/custom_widgets/visa_text_field.dart';
import 'package:visaamigo/custom_widgets/visa_textview.dart';
import 'package:visaamigo/features/companion_registration/model/companion_registration_model.dart';
import 'package:visaamigo/generated/l10n.dart';
import 'package:visaamigo/utils/const_screen_size.dart';
import 'package:visaamigo/utils/validation.dart';

import '../../../utils/app_const.dart';

class CompanionRegistrationView extends StatelessWidget {
  const CompanionRegistrationView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BaseView<CompanionRegistrationModel>(
      viewModel: CompanionRegistrationModel(),
      onModelReady: (model) {
        model.init();
      },
      buildAppBar: const VisaAppBar(),
      onPageBuilderMobileView:
          (BuildContext context, CompanionRegistrationModel viewModel) {
        return Form(
          key: viewModel.formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: AppSizes.smallVS.height!.toDouble(),
                children: [
                  VisaTextView(
                    text: S.of(context).companion_registration,
                    style: VisaTextStyle.customLarge,
                    customColor: VisaColors.textTertiary7,
                    colorTheme: VisaTextTheme.customTextColor,
                  ),
                  VisaTextField(
                    controller: viewModel.firstName,
                    isRequired: true,
                    hint: S.of(context).first_name,
                    errorText: S.of(context).invalid_name,
                    onChanged: (_) {
                      viewModel.validStateChange();
                    },
                    isValid: viewModel.firstName.text.isNotEmpty,
                  ),
                  VisaTextField(
                    controller: viewModel.lastName,
                    isRequired: true,
                    hint: S.of(context).last_name,
                    errorText: S.of(context).invalid_name,
                    onChanged: (_) {
                      viewModel.validStateChange();
                    },
                    isValid: viewModel.lastName.text.isNotEmpty,
                  ),
                  VisaTextField(
                    controller: viewModel.email,
                    isRequired: true,
                    hint: "S.of(context).email",
                    errorText: S.of(context).invalid_email,
                    maxLength: AppConst.TEXTFIELD_EMAIL_LENGTH,
                    textInputType: TextInputType.emailAddress,
                    onChanged: (_) {
                      viewModel.validStateChange();
                    },
                    isValid:
                        (Validation.emailValid.hasMatch(viewModel.email.text)),
                  ),
                  Row(
                    children: [
                      VisaCheckbox(
                        value: viewModel.isMinor,
                        onChanged: (_) => viewModel.minorCheckBox,
                      ),
                      VisaTextView(
                        text: S.of(context).isMinor,
                        style: VisaTextStyle.customSmall,
                        customColor: VisaColors.textTertiary7,
                        colorTheme: VisaTextTheme.customTextColor,
                      ),
                    ],
                  ),
                ],
              ),
              Column(
                children: [
                  VisaButton(
                    text: S.of(context).submit,
                    onPressed: viewModel.companionRegistrationSubmitButton,
                    height: 50,
                    variant: VisaButtonVariant.primary,
                  ),
                ],
              )
            ],
          ),
        );
      },
    );
  }
}
