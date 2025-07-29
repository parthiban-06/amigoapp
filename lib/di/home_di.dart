import 'package:get_it/get_it.dart';
import 'package:visaamigo/features/home/providers/animated_bottom_bar_provider.dart'
    show AnimatedBottomBarProvider;
import 'package:visaamigo/features/home/providers/home_provider.dart';
import 'package:visaamigo/features/splash_screen/repo/user_detail_repo.dart';

void setupHomeDependencies(GetIt getIt) {
  getIt.registerFactory(() => AnimatedBottomBarProvider());
  // Register HomeViewProvider as a factory with its dependencies
  getIt.registerFactory(() => HomeViewProvider(
        userDetailRepo: getIt<UserDetailRepo>(),
      ));
}
