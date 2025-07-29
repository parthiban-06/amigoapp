import 'package:get_it/get_it.dart';
import 'package:visaamigo/features/signup/providers/signup_provider.dart';

void setupSignUpDependencies(GetIt getIt) {
  // Register SignUpViewProvider as a factory
  getIt.registerFactory(() => SignUpViewProvider());
}
