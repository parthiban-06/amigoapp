import 'package:get_it/get_it.dart';
import 'package:visaamigo/features/profile/model/change_password_model.dart';
import 'package:visaamigo/features/profile/model/edit_profile_model.dart';
import 'package:visaamigo/features/profile/model/profile_model.dart';
import 'package:visaamigo/features/profile/provider/delete_account_provider.dart';
import 'package:visaamigo/features/profile/provider/faq_provider.dart';
import 'package:visaamigo/features/splash_screen/repo/user_detail_repo.dart'
    show UserDetailRepo;

void setupProfileDependencies(GetIt getIt) {
  // Register ChangePasswordModel as a factory
  getIt.registerFactory(() => ChangePasswordModel());

  // Register DeleteAccountProvider as a factory
  getIt.registerFactory(
      () => DeleteAccountProvider(userDetailRepo: getIt<UserDetailRepo>()));

  // Register ProfileModel as a factory
  getIt.registerFactory(() => ProfileViewModel());

  // Register EditProfileModel as a factory
  getIt.registerFactory(() => EditProfileModel());

  // Register FaqProvider as a factory
  getIt.registerFactory(() => FaqProvider());
}
