import 'package:universal_html/html.dart' as html;
import 'package:visaamigo/ui/base/base_provider.dart';

import '../../../utils/platform_view_registry.dart';
import '../../../utils/shared_preferences.dart';
import '../../../utils/utils.dart';
import '../../splash_screen/repo/user_detail_repo.dart';

class WebViewProviderWeb extends BaseProvider {
  String webPage = "";

  // Initialize Method
  void init({String? myUrl, bool? openWeb}) {
    if (openWeb!) {
      registerIframeView(myUrl);
    } else {
      getTermsAndConditions();
    }
  }

  void registerIframeView(String? url) {
    platformViewRegistry.registerViewFactory(
      'iframe-view',
      (int viewId) {
        final iframe = html.IFrameElement()
          ..src = url
          ..style.border = 'none'
          ..width = '100%'
          ..height = '100%'
          ..style.overflow = 'hidden';
        return iframe;
      },
    );
  }

  // Function to Get Terms And Condition HTML
  Future<void> getTermsAndConditions() async {
    isLoading = true;
    setState();
    try {
      UserDetailRepo? userDetailRepo = UserDetailRepo(apiClient);
      final langCode = await Preferences.getString(Preferences.keyLanguageCode);

      final response = await userDetailRepo.getTermsAndConditions(langCode);
      webPage = response;
    } catch (e, stackTrace) {
      Utils.logPrint("❌ Failed to load T&C: $e");
      Utils.logPrint("📍 StackTrace: $stackTrace");

      // Optionally, set fallback message
      webPage =
          "<p>Failed to load Terms and Conditions. Please try again later.</p>";
    } finally {
      isLoading = false;
      setState();
    }
  }

  cancelButton() {
    setContext(mContext);
    navPop();
  }
}
