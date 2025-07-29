import 'package:get_it/get_it.dart';
import 'package:visaamigo/features/rate_us/model/rate_us_model.dart';
import 'package:visaamigo/features/splash_screen/repo/user_detail_repo.dart'
    show UserDetailRepo;

void setupRateUsDependencies(GetIt getIt) {
  // Register RateUsModel
  getIt.registerFactory(
      () => RateUsModel(userDetailRepo: getIt<UserDetailRepo>()));
}
