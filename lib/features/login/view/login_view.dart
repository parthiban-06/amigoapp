import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart' show GetIt;
import 'package:visaamigo/core/base/view/base_view.dart';
import 'package:visaamigo/custom_widgets/visa_button.dart';
import 'package:visaamigo/custom_widgets/visa_textview.dart';
import 'package:visaamigo/features/login/model/login_model.dart';
import 'package:visaamigo/features/signup/widgets/termsAndPolicy.dart';
import 'package:visaamigo/generated/l10n.dart';
import 'package:visaamigo/utils/const_screen_size.dart' show AppSizes;
import 'package:visaamigo/utils/utils.dart';

import '../../../custom_widgets/visa_appbar.dart';
import '../../signup/model/user_model.dart';
import 'login_text_fields_widget.dart';

class LoginView extends StatefulWidget {
  final UserModel? userEmail;
  final bool? showBiometrics;

  const LoginView(this.userEmail, {super.key, this.showBiometrics});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late final LoginViewModel loginViewModel;

  //late final AiAssistantMainProvider aiAssistantProvider;

  @override
  void initState() {
    super.initState();
    loginViewModel = GetIt.I<LoginViewModel>();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // aiAssistantProvider =
    //     Provider.of<AiAssistantMainProvider>(context, listen: false);
    // loginViewModel.init(
    //     widget.userEmail, widget.showBiometrics, aiAssistantProvider);
  }

  @override
  Widget build(BuildContext context) {
    return BaseView<LoginViewModel>(
      viewModel: loginViewModel,
      setTopSafeArea: false,
      buildAppBar: const VisaAppBar(),
      onModelReady: (model) {
        // aiAssistantProvider =
        //     Provider.of<AiAssistantMainProvider>(context, listen: false);
        model.init(widget.userEmail, widget.showBiometrics);
        Utils.announceMessage(S.of(context).login_screen);
      },
      onPageBuilderMobileView:
          (BuildContext context, LoginViewModel viewModel) {
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
              children: [
                isDesktop || isMobileWeb
                    ? Flexible(
                        child: LoginTextFieldsWidget(
                          viewModel: viewModel,
                        ),
                      )
                    : Expanded(
                        child: LoginTextFieldsWidget(
                          viewModel: viewModel,
                        ),
                      ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    MediaQuery.viewInsetsOf(context).bottom > 15
                        ? const SizedBox()
                        : isDesktop || isMobileWeb
                            ? SizedBox(
                                height: AppSizes.thirtyHeight,
                              )
                            : const TermsAndPolicy(),
                    SizedBox(
                      height: AppSizes.eightHeight,
                    ),
                    VisaButton(
                      text: S.of(context).login_btn,
                      onPressed: viewModel.signInButton,
                      isDisable: viewModel.isLoginButtonDisable,
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
