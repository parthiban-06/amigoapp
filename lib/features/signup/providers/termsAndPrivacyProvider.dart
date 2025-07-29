import 'package:flutter/foundation.dart';
import 'package:visaamigo/utils/app_const.dart';
import 'package:visaamigo/utils/utils.dart';

import '../../../router/app_routes_const.dart';
import '../../../ui/base/base_provider.dart';
import '../../../utils/shared_preferences.dart';

class TermsAndPrivacyProvider extends BaseProvider {
  void init() {}

  void goToPrivacyPolicy() async {
    final langCode = await Preferences.getString(Preferences.keyLanguageCode);
    final url = AppConst.privacyPolicies[langCode] ?? AppConst.privacyPolicyEN;
    if (!kIsWeb) {
      navPush(AppRoutes.webView,
          extra: {"url": url, "openWeb": true, "showVisaIcon": false});
    } else {
      Utils.openExternalApplication(url, "");
    }
  }

  void goToTermAndCondition() {
    navPush(AppRoutes.webView,
        extra: {"url": AppConst.TERMS_AND_CONDITIONS, "openWeb": false});
  }
}
