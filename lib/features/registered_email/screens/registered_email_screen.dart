import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart' show GetIt;
import 'package:visaamigo/core/base/view/base_view.dart';
import 'package:visaamigo/custom_widgets/visa_size_box.dart';
import 'package:visaamigo/features/registered_email/providers/registered_email_providers.dart';
import 'package:visaamigo/features/signup/widgets/termsAndPolicy.dart';
import 'package:visaamigo/generated/l10n.dart';
import 'package:visaamigo/utils/app_extensions.dart';
import 'package:visaamigo/utils/utils.dart';

import '../../../custom_widgets/custom_visa_two_button.dart';
import '../../../custom_widgets/visa_appbar.dart';
import '../../../custom_widgets/visa_button.dart';
import '../../../utils/const_screen_size.dart';
import 'registered_email_text_fields_widget.dart';

class RegisteredEmail extends StatefulWidget {
  final String deeplinkEmail;

  const RegisteredEmail(this.deeplinkEmail, {super.key});

  @override
  // ignore: library_private_types_in_public_api
  _RegisteredEmailState createState() => _RegisteredEmailState();
}

class _RegisteredEmailState extends State<RegisteredEmail> {
  late final RegisteredEmailModel registeredEmailModel;

  @override
  void initState() {
    super.initState();
    // Initialize RegisteredEmailModel once
    registeredEmailModel = GetIt.I<RegisteredEmailModel>();
    registeredEmailModel.setContext(context);
    registeredEmailModel.showAnalyticsConsentDialog();
  }

  @override
  didChangeDependencies() {
    super.didChangeDependencies();
    registeredEmailModel.init(widget.deeplinkEmail);
  }

  @override
  Widget build(BuildContext context) {
    return BaseView<RegisteredEmailModel>(
      viewModel: registeredEmailModel,
      setTopSafeArea: false,
      onModelReady: (model) {
        Utils.announceMessage(S.of(context).registered_email_screen);
      },
      onDispose: () {},
      addDefaultPadding: true,
      buildAppBar: const VisaAppBar(),
      onPageBuilderMobileView:
          (BuildContext context, RegisteredEmailModel viewModel) {
        return _buildMobileView(context, viewModel);
      },
    );
  }

  Widget _buildMobileView(
      BuildContext context, RegisteredEmailModel viewModel) {
    final isDesktop = viewModel.isDesktopView;
    final isMobileWeb = viewModel.isMobileWebView;

    return SizedBox(
      child: Form(
        key: viewModel.formKey,
        child: Column(
          mainAxisAlignment: _getMainAxisAlignment(isDesktop, isMobileWeb),
          children: [
            _buildTextFieldsSection(context, viewModel, isDesktop, isMobileWeb),
            _buildSpacingSection(isDesktop, isMobileWeb),
            _buildBottomSection(context, viewModel),
          ],
        ),
      ),
    );
  }

  MainAxisAlignment _getMainAxisAlignment(bool isDesktop, bool isMobileWeb) {
    if (isDesktop) {
      return MainAxisAlignment.center;
    } else if (isMobileWeb) {
      return MainAxisAlignment.start;
    } else {
      return MainAxisAlignment.spaceBetween;
    }
  }

  Widget _buildTextFieldsSection(BuildContext context,
      RegisteredEmailModel viewModel, bool isDesktop, bool isMobileWeb) {
    final textFieldsWidget = RegisteredEmailTextFieldsWidget(
      viewModel: viewModel,
    );

    if (isDesktop || isMobileWeb) {
      return Flexible(child: textFieldsWidget);
    } else {
      return Expanded(child: textFieldsWidget);
    }
  }

  Widget _buildSpacingSection(bool isDesktop, bool isMobileWeb) {
    if (isDesktop) {
      return AppSizes.mediumVS;
    } else if (isMobileWeb) {
      return VisaSizeBox(height: Sizes.tenInt.toDouble());
    } else {
      return const SizedBox.shrink();
    }
  }

  Widget _buildBottomSection(
      BuildContext context, RegisteredEmailModel viewModel) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _buildTermsAndPolicy(context),
        SizedBox(
          height: AppSizes.eightHeight,
        ),
        _buildButtonsSection(context, viewModel),
      ],
    );
  }

  Widget _buildTermsAndPolicy(BuildContext context) {
    if (context.viewInsets.bottom > 15) {
      return const SizedBox();
    }
    return const TermsAndPolicy();
  }

  Widget _buildButtonsSection(
      BuildContext context, RegisteredEmailModel viewModel) {
    if (!viewModel.isLocalLanguageSupport) {
      return _buildSingleButton(context, viewModel);
    } else {
      return _buildTwoButtons(context, viewModel);
    }
  }

  Widget _buildSingleButton(
      BuildContext context, RegisteredEmailModel viewModel) {
    return VisaButton(
      text: S.of(context).txt_continue,
      onPressed: viewModel.continueButton,
      isDisable: viewModel.isContinueButtonDisable,
      variant: VisaButtonVariant.primary,
    );
  }

  Widget _buildTwoButtons(
      BuildContext context, RegisteredEmailModel viewModel) {
    return CustomTwoButtons(
      addButtonTopPadding: false,
      leftButtonText: S.of(context).back,
      rightButtonText: S.of(context).txt_continue,
      rightButtonDisable: viewModel.isContinueButtonDisable,
      onLeftButtonPressed: () {
        viewModel.navigateToLanguageSelectionScreen();
      },
      onRightButtonPressed: () {
        viewModel.continueButton();
      },
      isRightButtonLoading: false,
      isLeftButtonLoading: false,
    );
  }
}
