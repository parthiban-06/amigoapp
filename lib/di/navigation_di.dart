import 'package:get_it/get_it.dart' show GetIt;
import 'package:visaamigo/features/home/providers/navigation_provider.dart'
    show NavigationProvider;

void setupNavigationProvider(GetIt getIt) {
  getIt.registerLazySingleton(() => NavigationProvider());
}
