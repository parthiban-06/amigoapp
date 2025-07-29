import 'package:get_it/get_it.dart';
import 'package:visaamigo/features/companion/providers/add_companion_provider.dart';
import 'package:visaamigo/features/companion/providers/list_companion_provider.dart'
    show ListCompanionProvider;
import 'package:visaamigo/features/splash_screen/repo/user_detail_repo.dart';

void setupCompanionDependencies(GetIt getIt) {
  // Register AddCompanionProvider as a factory with its dependencies
  getIt.registerFactory(() => AddCompanionProvider(
        userDetailRepo: getIt<UserDetailRepo>(),
      ));
  getIt.registerFactory(() => ListCompanionProvider(
        userDetailRepo: getIt<UserDetailRepo>(),
      ));
}
