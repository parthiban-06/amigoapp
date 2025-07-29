import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:visaamigo/core/base/view/base_view.dart';
import 'package:visaamigo/custom_widgets/visa_button.dart';
import 'package:visaamigo/features/confirm_code/model/confirm_code_model.dart';
import 'package:visaamigo/features/signup/model/user_model.dart';
import 'package:visaamigo/generated/l10n.dart';
import 'package:visaamigo/utils/utils.dart';

import '../../../custom_widgets/visa_appbar.dart';
import 'confirm_code_text_fields_widget.dart';

class ConfirmCodeView extends StatefulWidget {
  final UserModel? userModel;

  const ConfirmCodeView(
    this.userModel, {
    super.key,
  });

  @override
  State<ConfirmCodeView> createState() => _ConfirmCodeViewState();
}

class _ConfirmCodeViewState extends State<ConfirmCodeView> {
  late final ConfirmCodeModel confirmCodeModel;
  //late final AiAssistantMainProvider aiAssistantProvider;

  @override
  void initState() {
    super.initState();
    confirmCodeModel =
        GetIt.I<ConfirmCodeModel>(); // Retrieve the model using DI
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // aiAssistantProvider =
    //     Provider.of<AiAssistantMainProvider>(context, listen: false);
    // confirmCodeModel.init(widget.userModel, aiAssistantProvider);
  }

  @override
  Widget build(BuildContext context) {
    return BaseView<ConfirmCodeModel>(
      viewModel: confirmCodeModel,
      setTopSafeArea: false,
      buildAppBar: const VisaAppBar(),
      onModelReady: (model) {
        model.init(widget.userModel);
        Utils.announceMessage(S.of(context).confirm_code_screen);
      },
      onPageBuilderMobileView:
          (BuildContext context, ConfirmCodeModel viewModel) {
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
                        child: ConfirmCodeTextFieldsWidget(
                          isDesktop: isDesktop,
                          isMobileWeb: isMobileWeb,
                          viewModel: viewModel,
                        ),
                      )
                    : Expanded(
                        child: ConfirmCodeTextFieldsWidget(
                          isDesktop: isDesktop,
                          isMobileWeb: isMobileWeb,
                          viewModel: viewModel,
                        ),
                      ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    VisaButton(
                      text: S.of(context).txt_continue,
                      onPressed: viewModel.confirmCodeButton,
                      height: 54,
                      isDisable: viewModel.code.text.isEmpty,
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
