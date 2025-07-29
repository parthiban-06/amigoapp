import 'package:get_it/get_it.dart';
import 'package:visaamigo/features/confirm_forgot_pass_code/model/confirm_forgot_pass_code_model.dart';
import 'package:visaamigo/features/splash_screen/repo/user_detail_repo.dart'
    show UserDetailRepo;

void setupConfirmForgotPassCodeDependencies(GetIt getIt) {
  // Register ConfirmForgotPassCodeModel
  getIt.registerFactory(
      () => ConfirmForgotPassCodeModel(userDetails: getIt<UserDetailRepo>()));
}
