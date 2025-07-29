import 'package:visaamigo/custom_widgets/snackbar.dart';
import 'package:visaamigo/generated/l10n.dart';
import 'package:visaamigo/router/app_routes_const.dart';

import '../../../ui/base/base_provider.dart';
import '../../../utils/shared_preferences.dart';
import '../../../utils/utils.dart';

class BiometricProviderApple extends BaseProvider {
  void init() {}

  onCancelButton() async {
    await Preferences.setBool(Preferences.enableBiometric, false);
    navGo(AppRoutes.homeNav);
  }

  enableBiometrics() async {
    final rep = await Utils.enableBioMetrics();

    if (rep) {
      await Preferences.setBool(Preferences.enableBiometric, true);

      snackBar(getContext(), S.of(getContext()).bioAuthSuccess);
      navGo(AppRoutes.homeNav);
    } else {
      snackBar(getContext(), S.of(getContext()).bioAuthFail);
    }
  }
}
