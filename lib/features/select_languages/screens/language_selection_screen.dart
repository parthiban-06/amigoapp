import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:visaamigo/di/service_locator.dart' show getIt;
import 'package:visaamigo/features/select_languages/providers/language_selection_generic_provider.dart';
import 'package:visaamigo/features/select_languages/screens/language_selection_mobile_view.dart';
import 'package:visaamigo/utils/shared_preferences.dart';
import 'package:visaamigo/utils/utils.dart';

import '../../../core/base/view/base_view.dart';
import '../../../custom_widgets/visa_appbar.dart';
import '../../../generated/l10n.dart';
import '../providers/language_selection_provider.dart';

class LanguageSelectionScreen extends StatefulWidget {
  final String deeplinkEmail;
  final bool? showBack;

  const LanguageSelectionScreen(this.deeplinkEmail, {super.key, this.showBack});

  @override
  // ignore: library_private_types_in_public_api
  _LanguageSelectionScreenState createState() =>
      _LanguageSelectionScreenState();
}

class _LanguageSelectionScreenState extends State<LanguageSelectionScreen> {
  late final SelectLanguageProvider languageProvider;

  @override
  void initState() {
    super.initState();
    languageProvider = getIt<
        SelectLanguageProvider>(); // Retrieve SelectLanguageProvider using getIt
    languageProvider.loadSavedLocale(); // Load saved locale
    languageProvider.init(); // Initialize the provider
  }

  @override
  Widget build(BuildContext context) {
    return BaseView<SelectLanguageProvider>(
      viewModel: languageProvider,
      resizeToAvoidBottomInset: true,
      setTopSafeArea: false,
      setBottomSafeArea: false,
      isVisaLogoSemanticsShowFirstTime: true,
      buildAppBar: VisaAppBar(
        isActionButtonShow: widget.showBack ?? false,
        isCancelWithTextButtonShow: widget.showBack ?? false,
        onCancelPress: () async {
          String code =
              await Preferences.getString(Preferences.keyLanguageCode);
          // ignore: use_build_context_synchronously
          Provider.of<SelectLanguageGenericProvider>(context, listen: false)
              .setLanguage(code);
          // ignore: use_build_context_synchronously
          Navigator.of(context).pop();
        },
      ),
      onModelReady: (model) {
        Utils.announceMessage((widget.showBack ?? false)
            ? S.of(context).change_language
            : S.of(context).language_selection_screen);
      },
      onPageBuilderMobileView:
          (BuildContext context, SelectLanguageProvider viewModel) {
        var isDesktop = viewModel.isDesktopView;
        var isMobileWeb = viewModel.isMobileWebView;
        return PopScope(
          canPop: true,
          onPopInvokedWithResult: (b, f) {
            viewModel.onBack();
          },
          child: LanguageSelectionMobile(
            viewModel,
            widget.deeplinkEmail,
            showBack: widget.showBack,
            isDesktop: isDesktop,
            isMobileWeb: isMobileWeb,
          ),
        );
      },
    );
  }
}
