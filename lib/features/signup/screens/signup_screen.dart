import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart' show GetIt;
import 'package:visaamigo/core/base/view/base_view.dart';
import 'package:visaamigo/custom_widgets/visa_button.dart';
import 'package:visaamigo/features/signup/providers/signup_provider.dart';
import 'package:visaamigo/features/signup/screens/signup_text_fields_widget.dart';
import 'package:visaamigo/generated/l10n.dart';
import 'package:visaamigo/utils/utils.dart';

import '../../../custom_widgets/visa_appbar.dart';
import '../../../utils/const_screen_size.dart';
import '../model/user_model.dart';

class SignUpScreen extends StatefulWidget {
  final UserModel? userModel;

  const SignUpScreen(this.userModel, {super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  late final SignUpViewProvider signUpViewProvider;

  @override
  void initState() {
    super.initState();
    signUpViewProvider =
        GetIt.I<SignUpViewProvider>(); // Retrieve the model using DI
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    signUpViewProvider.init(widget.userModel);
  }

  @override
  Widget build(BuildContext context) {
    return BaseView<SignUpViewProvider>(
      viewModel: signUpViewProvider,
      setTopSafeArea: false,
      onModelReady: (model) {
        Utils.announceMessage(S.of(context).sign_up_screen);
      },
      buildAppBar: const VisaAppBar(),
      onPageBuilderMobileView:
          (BuildContext context, SignUpViewProvider viewModel) {
        var isDesktop = viewModel.isDesktopView;
        var isMobileWeb = viewModel.isMobileWebView;
        return SizedBox(
          child: Form(
            key: viewModel.formKey,
            child: Column(
              mainAxisAlignment: isDesktop
                  ? MainAxisAlignment.center
                  : MainAxisAlignment.start,
              children: [
                isDesktop || isMobileWeb
                    ? Flexible(
                        child: SignupTextFieldsWidget(
                          viewModel: viewModel,
                        ),
                      )
                    : Expanded(
                        child: SignupTextFieldsWidget(
                          viewModel: viewModel,
                        ),
                      ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: AppSizes.heightXSmall,
                    ),
                    VisaButton(
                      text: S.of(context).submit,
                      onPressed: viewModel.signUpButton,
                      variant: VisaButtonVariant.primary,
                      isDisable: !viewModel.isDisable,
                    ),
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
