import 'package:flutter/material.dart';

import '../../../core/base/view/base_view.dart';
import '../providers/language_selection_provider.dart';

class LanguageGrid extends StatelessWidget {
  const LanguageGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseView<SelectLanguageProvider>(
      viewModel: SelectLanguageProvider(),
      onModelReady: (model) {
        model.loadSavedLocale();
        model.init();
      },
      onlyDesktop: true,
      addDefaultPadding: false,
      onPageBuilderMobileView:
          (BuildContext context, SelectLanguageProvider languageProvider) {
        return Container();
      },
    );
  }
}
