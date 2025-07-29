import 'package:get_it/get_it.dart';
import 'package:visaamigo/features/splash_screen/repo/user_detail_repo.dart';
import 'package:visaamigo/remote/api_client.dart';

void setupCoreDependencies(GetIt getIt) {
  // Register Core Dependencies
  getIt.registerLazySingleton(() => ApiClient());
  getIt.registerLazySingleton(() => UserDetailRepo(getIt<ApiClient>()));
}
