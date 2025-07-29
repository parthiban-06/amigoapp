import 'package:get_it/get_it.dart';
import 'package:visaamigo/features/splash_screen/model/splash_screen_model.dart';
import 'package:visaamigo/features/splash_screen/repo/user_detail_repo.dart';

void setupSplashScreenDependencies(GetIt getIt) {
  // Register UserDetailRepo

  // Register SplashScreenViewModel
  getIt.registerFactory(
      () => SplashScreenViewModel(splashScreenRepo: getIt<UserDetailRepo>()));
}
