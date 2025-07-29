import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:visaamigo/core/base/view/base_view.dart';
import 'package:visaamigo/custom_widgets/visa_button.dart';
import 'package:visaamigo/custom_widgets/visa_textview.dart';
import 'package:visaamigo/features/confirm_forgot_pass_code/model/confirm_forgot_pass_code_model.dart';
import 'package:visaamigo/generated/l10n.dart';
import 'package:visaamigo/utils/utils.dart';

import '../../../custom_widgets/visa_appbar.dart';
import 'confirm_forgot_pass_text_fields_widget.dart';

class ConfirmForgotPassCodeView extends StatefulWidget {
  const ConfirmForgotPassCodeView({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ConfirmForgotPassCodeViewState createState() =>
      _ConfirmForgotPassCodeViewState();
}

class _ConfirmForgotPassCodeViewState extends State<ConfirmForgotPassCodeView> {
  late final ConfirmForgotPassCodeModel confirmForgotPassCodeModel;

  @override
  void initState() {
    super.initState();
    confirmForgotPassCodeModel =
        GetIt.I<ConfirmForgotPassCodeModel>(); // Retrieve the model using DI
  }

  @override
  Widget build(BuildContext context) {
    return BaseView<ConfirmForgotPassCodeModel>(
      setTopSafeArea: false,
      viewModel: confirmForgotPassCodeModel,
      buildAppBar: const VisaAppBar(),
      onModelReady: (model) {
        Utils.announceMessage(S.of(context).confirm_forgot_password_screen);
      },
      onPageBuilderMobileView:
          (BuildContext context, ConfirmForgotPassCodeModel viewModel) {
        var isDesktop = viewModel.isDesktopView;
        var isMobileWeb = viewModel.isMobileWebView;
        return SizedBox(
          child: Form(
            key: viewModel.formKey,
            child: Column(
              mainAxisAlignment: isDesktop
                  ? MainAxisAlignment.center
                  : isMobileWeb
                      ? MainAxisAlignment.start
                      : MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                isDesktop || isMobileWeb
                    ? Flexible(
                        child: ConfirmForgotPassTextFieldsWidget(
                          viewModel: viewModel,
                          isDesktop: isDesktop,
                          isMobileWeb: isMobileWeb,
                        ),
                      )
                    : Expanded(
                        child: ConfirmForgotPassTextFieldsWidget(
                          viewModel: viewModel,
                          isDesktop: isDesktop,
                          isMobileWeb: isMobileWeb,
                        ),
                      ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    VisaButton(
                      text: S.of(context).confirm,
                      onPressed: viewModel.confirmCodeButton,
                      isDisable: viewModel.isDisable,
                      fontWeight: VisaFontWeight.medium,
                      variant: VisaButtonVariant.primary,
                    ),
                    // AppSizes.xxsmallVS,
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
