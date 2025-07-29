import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:visaamigo/core/base/view/base_view.dart';
import 'package:visaamigo/core/theme/theme.dart';
import 'package:visaamigo/custom_widgets/visa_button.dart';
import 'package:visaamigo/custom_widgets/visa_text_field.dart';
import 'package:visaamigo/custom_widgets/visa_textview.dart';
import 'package:visaamigo/features/enable_mfa/providers/enable_mfa_code_provider.dart';
import 'package:visaamigo/generated/l10n.dart';
import 'package:visaamigo/utils/const_screen_size.dart' show AppSizes;

import '../../../custom_widgets/visa_appbar.dart';
import '../../../utils/utils.dart';

class EnableMfaCodeView extends StatefulWidget {
  const EnableMfaCodeView({super.key});

  @override
  State<EnableMfaCodeView> createState() => _EnableMfaCodeViewState();
}

class _EnableMfaCodeViewState extends State<EnableMfaCodeView> {
  late EnableMfaCodeProvider enableMfaCodeProvider;

  @override
  void initState() {
    super.initState();
    enableMfaCodeProvider = GetIt.I<EnableMfaCodeProvider>();
  }

  @override
  Widget build(BuildContext context) {
    return BaseView<EnableMfaCodeProvider>(
      viewModel: enableMfaCodeProvider,
      onModelReady: (model) {
        // Perform any initialization if needed
      },
      buildAppBar: const VisaAppBar(
        isActionButtonShow: true,
        isCancelButtonShow: true,
      ),
      onPageBuilderMobileView:
          (BuildContext context, EnableMfaCodeProvider viewModel) {
        return Form(
          key: viewModel.formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  VisaTextView(
                    overflow: TextOverflow.fade,
                    text: S.of(context).mfa_authentication,
                    style: VisaTextStyle.customLarge,
                    customColor: VisaColors.textTertiary7,
                    colorTheme: VisaTextTheme.customTextColor,
                  ),
                  VisaTextView(
                    text: S.of(context).send_auth_code,
                    style: VisaTextStyle.customMedium,
                    customColor: VisaColors.textTertiary7,
                    colorTheme: VisaTextTheme.customTextColor,
                    softWrap: true,
                    overflow: TextOverflow.visible,
                    maxLines: null, // Allow unlimited lines
                  ),
                  VisaTextView(
                    text: S.of(context).enter_code_below,
                    style: VisaTextStyle.customMedium,
                    customColor: VisaColors.textTertiary7,
                    colorTheme: VisaTextTheme.customTextColor,
                  ),
                  VisaTextField(
                    label: S.of(context).ent_code,
                    labelStyle: TextStyle(
                      color: Colors.black,
                      fontSize: AppSizes.fontXXSmall,
                      fontWeight: FontWeight.w500,
                    ),
                    suffixIcon: TextButton(
                      onPressed: () {
                        viewModel.resendCode();
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
                          style: VisaTextStyle.link,
                          customColor: VisaColors.textTertiary7,
                          colorTheme: VisaTextTheme.customTextColor,
                        ),
                      ),
                    ),
                    vPadding: 0,
                    letterSpacing: 0,
                    controller: viewModel.code,
                    hint: "",
                    onChanged: (_) {
                      viewModel.validStateChange();
                    },
                    isValid: viewModel.code.text.length == 6,
                  ),
                ],
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  VisaButton(
                    text: S.of(context).verify_mfa,
                    onPressed: viewModel.verifyMfaCode,
                    variant: VisaButtonVariant.primary,
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
