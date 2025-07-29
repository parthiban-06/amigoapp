import 'package:get_it/get_it.dart';
import 'package:visaamigo/features/select_languages/providers/language_selection_provider.dart';

void setupSelectLanguagesDependencies(GetIt getIt) {
  // Register SelectLanguageProvider
  getIt.registerFactory(() => SelectLanguageProvider());
}
