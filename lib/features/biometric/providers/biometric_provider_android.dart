import 'package:visaamigo/custom_widgets/snackbar.dart';
import 'package:visaamigo/generated/l10n.dart';
import 'package:visaamigo/router/app_routes_const.dart';
import 'package:visaamigo/utils/utils.dart';

import '../../../ui/base/base_provider.dart';
import '../../../utils/shared_preferences.dart';

class BiometricProviderAndroid extends BaseProvider {
  void init() {}

  onCancelButton() async {
    await Preferences.setBool(Preferences.enableBiometric, false);
    navGo(AppRoutes.homeNav);
  }

  enableBiometrics() async {
    final rep = await Utils.enableBioMetrics();
    if (rep) {
      // Capture context before async operations to avoid BuildContext across async gaps
      final context = getContext();
      await Preferences.setBool(Preferences.enableBiometric, true);
      if (context.mounted) {
        snackBar(context, S.of(context).bioAuthSuccess);
      }
      navGo(AppRoutes.homeNav);
    } else {
      snackBar(getContext(), S.of(getContext()).bioAuthFail);
    }
  }
}
