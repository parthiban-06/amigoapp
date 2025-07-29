import 'package:get_it/get_it.dart';
import 'package:visaamigo/features/login/model/login_model.dart';
import 'package:visaamigo/features/splash_screen/repo/user_detail_repo.dart'
    show UserDetailRepo;
import 'package:visaamigo/utils/shared_preferences.dart';
import 'package:visaamigo/utils/utils.dart';

import '../features/confirm_code/model/confirm_code_model.dart';

void setupLoginDependencies(GetIt getIt) {
  // Register Preferences as a singleton
  // Register Preferences as a singleton
  getIt.registerLazySingleton(() => Preferences());

  // Register Utils as a singleton
  getIt.registerLazySingleton(() => Utils());

  // Register LoginViewModel as a factory with its dependencies
  getIt.registerFactory(() => LoginViewModel(
        userDetailRepo: getIt<UserDetailRepo>(),
      ));
}

void setUpConfirmCodeProvider(GetIt getIt) {
  getIt.registerFactory(() => ConfirmCodeModel());
}
