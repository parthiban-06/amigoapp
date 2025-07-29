import 'package:get_it/get_it.dart';
import 'package:visaamigo/features/splash_screen/repo/user_detail_repo.dart';
import 'package:visaamigo/features/wallet/providers/wallet_provider.dart';

void setupWalletDependencies(GetIt getIt) {
  // Register WalletProvider
  getIt.registerFactory(
      () => WalletProvider(userDetailRepo: getIt<UserDetailRepo>()));
}
