import 'package:get_it/get_it.dart';
import 'package:visaamigo/features/forgot_pass/model/forgot_pass_model.dart';
import 'package:visaamigo/features/splash_screen/repo/user_detail_repo.dart'
    show UserDetailRepo;

void setupForgotPassDependencies(GetIt getIt) {
  // Register ForgotPassModel
  getIt.registerFactory(
      () => ForgotPassModel(splashScreenRepo: getIt<UserDetailRepo>()));
}
