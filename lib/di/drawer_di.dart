import 'package:get_it/get_it.dart';
import 'package:visaamigo/features/drawer/provider/drawer_provider.dart';
import 'package:visaamigo/features/home/providers/main_screen_provider.dart';

void setupDrawerDependencies(GetIt getIt) {
  // Register DrawerProvider as a factory with its dependencies
  getIt.registerFactory(() => DrawerProvider(
      // userGenericProvider: getIt<UserGenericProvider>(),
      ));
  getIt.registerFactory(() => MainScreenProvider());
}
