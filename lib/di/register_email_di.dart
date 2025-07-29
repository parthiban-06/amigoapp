import 'package:get_it/get_it.dart';
import 'package:visaamigo/features/registered_email/providers/registered_email_providers.dart';

void setupRegisterEmailDependencies(GetIt getIt) {
  // Register RegisteredEmailModel as a factory
  getIt.registerFactory(() => RegisteredEmailModel());
}
