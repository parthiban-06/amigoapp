import 'package:get_it/get_it.dart' show GetIt;
import 'package:visaamigo/features/enable_mfa/providers/enable_mfa_code_provider.dart'
    show EnableMfaCodeProvider;

void setupEnableMfaDependencies(GetIt getIt) {
  getIt.registerFactory(() => EnableMfaCodeProvider());
}
