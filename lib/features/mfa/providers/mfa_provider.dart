import 'package:local_auth/local_auth.dart';
import 'package:visaamigo/router/app_routes_const.dart';

import '../../../ui/base/base_provider.dart';
import '../../../utils/utils.dart';

class MFAProvider extends BaseProvider {
  void init() {}

  onSkipButton() async {
    final LocalAuthentication auth = LocalAuthentication();

    if (await Utils.isBioMetricsSupported()) {
      navGo(AppRoutes.homeNav);
    } else {
      navGo(AppRoutes.biometric);
    }
  }

  enableMFA() async {
    isLoading = true;
    await amplifyService.setupMFA(true);
    isLoading = false;
    onSkipButton();
  }
}
