import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../features/select_languages/providers/language_selection_generic_provider.dart';

extension LanguageWatchExtension on BuildContext {
  bool get watchIsRTL => watch<SelectLanguageGenericProvider>().isRTL;
}
