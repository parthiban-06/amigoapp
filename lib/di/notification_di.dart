import 'package:get_it/get_it.dart';
import 'package:visaamigo/features/notification/provider/notification_provider.dart';
import 'package:visaamigo/features/splash_screen/repo/user_detail_repo.dart';

void setupNotificationDependencies(GetIt getIt) {
  // Register NotificationProvider
  getIt.registerFactory(
      () => NotificationProvider(userDetailRepo: getIt<UserDetailRepo>()));
}
