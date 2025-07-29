import 'package:visaamigo/generated/l10n.dart';

import '../../../router/app_routes_const.dart';
import '../../../ui/base/base_provider.dart';
import '../../../utils/utils.dart';

class RedirectingProvider extends BaseProvider {
  void init() {}

  void openExternalApplication(String url, String deeplink) async {
    if (url.isNotEmpty) {
      Utils.announceMessage(S.of(mContext).loading_wait);

      Utils.openExternalApplication(url, deeplink);
      // announce message

      closeScreen();
    }
  }

  void openInternalApplication(String url) async {
    if (url.isNotEmpty) {
      // Utils.openExternalApplication(url);
      // closeScreen();
      Utils.announceMessage(S.of(mContext).loading_wait);

      navPushReplace(AppRoutes.webView, extra: {"url": url, "openWeb": true});
      // announce message
    }
  }

  // Navigate to the Close Screen
  void closeScreen() {
    navPop();
  }
}
