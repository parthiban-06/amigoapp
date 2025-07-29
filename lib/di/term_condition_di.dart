import 'package:get_it/get_it.dart';

import '../features/signup/providers/termsAndPrivacyProvider.dart';

void setupTermAndConditionDependencies(GetIt getIt) {
  // Register TermsAndPrivacyProvider as a factory
  getIt.registerFactory(() => TermsAndPrivacyProvider());
}
