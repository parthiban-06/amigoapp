import 'package:get_it/get_it.dart';
import 'package:visaamigo/features/redirecting/model/redirecting_provider.dart';

void setupRedirectingDependencies(GetIt getIt) {
  // Register RedirectingProvider as a factory
  getIt.registerFactory(() => RedirectingProvider());
}
