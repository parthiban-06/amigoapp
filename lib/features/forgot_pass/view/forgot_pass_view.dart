import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:visaamigo/core/base/view/base_view.dart';
import 'package:visaamigo/custom_widgets/custom_visa_two_button.dart';
import 'package:visaamigo/features/forgot_pass/model/forgot_pass_model.dart';
import 'package:visaamigo/features/signup/widgets/termsAndPolicy.dart';
import 'package:visaamigo/generated/l10n.dart';
import 'package:visaamigo/utils/utils.dart';

import '../../../custom_widgets/visa_appbar.dart';
import '../../../custom_widgets/visa_size_box.dart';
import '../../../utils/const_screen_size.dart';
import 'forgot_pass_text_fields_widget.dart';

class ForgotPassView extends StatefulWidget {
  const ForgotPassView({super.key});

  @override
  ForgotPassViewState createState() => ForgotPassViewState();
}

class ForgotPassViewState extends State<ForgotPassView> {
  late final ForgotPassModel forgotPassModel;

  @override
  void initState() {
    super.initState();
    forgotPassModel = GetIt.I<ForgotPassModel>();
  }

  @override
  Widget build(BuildContext context) {
    return BaseView<ForgotPassModel>(
      viewModel: forgotPassModel,
      setTopSafeArea: false,
      allowBackPress: true,
      buildAppBar: const VisaAppBar(),
      onModelReady: (model) {
        Utils.announceMessage(S.of(context).forgot_password_screen);
      },
      onPageBuilderMobileView:
          (BuildContext context, ForgotPassModel viewModel) {
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
                        child: ForgotPassTextFieldsWidget(
                          viewModel: viewModel,
                        ),
                      )
                    : Expanded(
                        child: ForgotPassTextFieldsWidget(
                          viewModel: viewModel,
                        ),
                      ),
                isDesktop
                    ? AppSizes.mediumVS
                    : isMobileWeb
                        ? VisaSizeBox(
                            height: Sizes.tenInt.toDouble(),
                          )
                        : const SizedBox.shrink(),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    MediaQuery.viewInsetsOf(context).bottom > 15
                        ? const SizedBox()
                        : const TermsAndPolicy(),

                    CustomTwoButtons(
                      leftButtonText: S.of(context).back,
                      rightButtonText: S.of(context).txt_continue,
                      rightButtonDisable: viewModel.isContinueButtonDisable,
                      onLeftButtonPressed: () {
                        viewModel.navPop();
                      },
                      onRightButtonPressed: () async {
                        await viewModel.forgotPassCodeButton();
                      },
                      isRightButtonLoading: false,
                      isLeftButtonLoading: false,
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
