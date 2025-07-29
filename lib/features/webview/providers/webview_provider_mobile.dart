import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:visaamigo/custom_widgets/visa_button.dart';
import 'package:visaamigo/custom_widgets/visa_dialog.dart'
    show VisaDialog, VisaDialogShowConfig;
import 'package:visaamigo/generated/l10n.dart';
import 'package:visaamigo/ui/base/base_provider.dart';
import 'package:visaamigo/utils/utils.dart';

import '../../../utils/app_const.dart';
import '../../../utils/shared_preferences.dart';
import '../../splash_screen/repo/user_detail_repo.dart';

class WebViewProviderMobile extends BaseProvider {
  final GlobalKey webViewKey = GlobalKey();
  InAppWebViewController? webViewController;
  String url = "";
  double progress = 0;
  String webPage = "";

  InAppWebViewSettings settings = InAppWebViewSettings(
    // Security Settings
    javaScriptEnabled: true,
    // Explicitly enable JavaScript for functionality
    javaScriptCanOpenWindowsAutomatically: false,
    // Prevent popup windows
    domStorageEnabled: true,
    // Allow DOM storage for web functionality
    databaseEnabled: false,
    // Disable database access for security
    useWideViewPort: true,
    loadWithOverviewMode: true,

    // Media Settings (current settings are acceptable)
    isInspectable: kDebugMode,
    // Only enable in debug mode
    mediaPlaybackRequiresUserGesture: false,
    allowsInlineMediaPlayback: true,

    // Content Security - Secure mixed content policy
    mixedContentMode: MixedContentMode.MIXED_CONTENT_COMPATIBILITY_MODE,
    // Never allow mixed content by default for security
    safeBrowsingEnabled: true,
    // Enable safe browsing

    // File Access - Allow content access for images
    allowFileAccess: true,
    // Allow file access for image loading
    allowContentAccess: true,
    // Allow content access for images and media
    allowFileAccessFromFileURLs: false,
    // Disable file access from file URLs for security
    allowUniversalAccessFromFileURLs: false,
    // Disable universal access from file URLs for security

    // Form Data
    saveFormData: false,
    // Disable form data saving for privacy

    // Geolocation (restrictive)
    geolocationEnabled: false,
    // Disable geolocation unless specifically needed

    // Camera and Microphone (restrictive but allow basic iframe content)
    iframeAllow: "fullscreen",
    // Allow fullscreen but not camera/microphone
    iframeAllowFullscreen: true,
    // Allow iframe fullscreen for legitimate content

    // Additional Security
    cacheMode: CacheMode.LOAD_NO_CACHE,
    // Don't cache sensitive data
    clearCache: false,

    // Image Loading
    loadsImagesAutomatically: true,
    // Ensure images load automatically
    blockNetworkImage: false,
    // Don't block network images

    // Enhanced JavaScript Security
    supportZoom: false,
    // Disable zoom to prevent UI manipulation
    builtInZoomControls: false,
    // Disable built-in zoom controls
    displayZoomControls: false,
    // Hide zoom controls
    supportMultipleWindows: false,
    // Prevent multiple window creation
  );

  PullToRefreshController? pullToRefreshController;

  late ContextMenu contextMenu;

  // Security: URL validation for safe JavaScript execution
  bool _isUrlSafe(String url) {
    if (url.isEmpty) return false;

    // Only allow HTTPS URLs or trusted domains
    final uri = Uri.tryParse(url);
    if (uri == null) return false;

    // Allow HTTPS
    if (uri.scheme == 'https') return true;

    // Allow specific trusted domains (add your trusted domains here)
    final trustedDomains = [
      'fifa.com',
      'visa.com',
      'your-trusted-domain.com',
      // Add more trusted domains as needed
    ];

    return trustedDomains.any((domain) => uri.host.contains(domain));
  }

  // Security: Check if domain is trusted for mixed content
  bool _isTrustedForMixedContent(String domain) {
    final trustedDomainsForMixedContent = [
      'fifa.com',
      'visa.com',
      'booking.com',
      // Add only domains that absolutely need mixed content
    ];

    return trustedDomainsForMixedContent
        .any((trustedDomain) => domain.contains(trustedDomain));
  }

  // Security: Handle mixed content requests securely
  void _handleMixedContentRequest(
      InAppWebViewController controller, String url) {
    final uri = Uri.tryParse(url);
    if (uri == null) return;

    // Only allow mixed content for trusted domains
    if (_isTrustedForMixedContent(uri.host)) {
      Utils.logPrint(
          "SECURITY: Allowing mixed content for trusted domain: ${uri.host}");
      // Allow the request to proceed
    } else {
      Utils.logPrint(
          "SECURITY: Blocking mixed content for untrusted domain: ${uri.host}");
      // Block the request - it will be blocked by the MIXED_CONTENT_NEVER_ALLOW setting
    }
  }

  // Security: Show warning for unsafe URLs
  void _showSecurityWarning() {
    VisaDialog.show(
      context: getContext(),
      title: S.of(getContext()).security_warning,
      message: S.of(getContext()).security_warning_message,
      config: VisaDialogShowConfig(
        primaryButtonText: "OK",
        barrierDismissible: false,
        onPrimaryPressed: () {
          navPop();
        },
      ),
    );
  }

  // Initialize Method
  void init({String? myUrl, bool? openWeb}) {
    if (!openWeb!) {
      _handleNonWebMode(myUrl);
      return;
    }

    if (!_isValidUrl(myUrl)) {
      _showUrlNotFoundDialog();
      return;
    }

    if (!_isUrlSafe(myUrl!)) {
      Utils.logPrint("SECURITY WARNING: Attempted to load unsafe URL: $myUrl");
      _showSecurityWarning();
      return;
    }

    _initializeWebView(myUrl);
  }

  bool _isValidUrl(String? myUrl) {
    return myUrl != null && myUrl.isNotEmpty;
  }

  void _handleNonWebMode(String? myUrl) {
    if (_isValidUrl(myUrl) && myUrl == AppConst.TERMS_AND_CONDITIONS) {
      getTermsAndConditions();
    }
  }

  void _showUrlNotFoundDialog() {
    Future.delayed(const Duration(milliseconds: 250), () {
      VisaDialog.show(
        context: getContext(),
        title: S.of(getContext()).url_not_found,
        message: S.of(getContext()).something_went_wrong,
        config: VisaDialogShowConfig(
          primaryButtonVariant: VisaButtonVariant.primary,
          barrierDismissible: true,
          primaryButtonText: S.of(getContext()).return_text,
          onPrimaryPressed: () {
            navPop();
            navPop();
          },
        ),
      );
    });
  }

  void _initializeWebView(String myUrl) {
    url = myUrl;
    Utils.logPrint("Loading safe URL: ${url ?? ""}");
    setState();

    _setupContextMenu();
    _setupPullToRefresh();
  }

  void _setupContextMenu() {
    contextMenu = ContextMenu(
      menuItems: [
        ContextMenuItem(
          id: 1,
          title: "Special",
          action: () async {
            Utils.logPrint("Menu item Special clicked!");
            Utils.logPrint(await webViewController?.getSelectedText());
            await webViewController?.clearFocus();
          },
        ),
      ],
      settings: ContextMenuSettings(hideDefaultSystemContextMenuItems: false),
      onCreateContextMenu: (hitTestResult) async {
        Utils.logPrint("onCreateContextMenu");
        Utils.logPrint(hitTestResult.extra);
        Utils.logPrint(await webViewController?.getSelectedText());
      },
      onHideContextMenu: () {
        Utils.logPrint("onHideContextMenu");
      },
      onContextMenuActionItemClicked: (contextMenuItemClicked) async {
        var id = contextMenuItemClicked.id;
        Utils.logPrint("onContextMenuActionItemClicked: " +
            id.toString() +
            " " +
            contextMenuItemClicked.title);
      },
    );
  }

  void _setupPullToRefresh() {
    final shouldCreatePullToRefresh = _shouldCreatePullToRefresh();

    if (!shouldCreatePullToRefresh) {
      pullToRefreshController = null;
      return;
    }

    pullToRefreshController = PullToRefreshController(
      settings: PullToRefreshSettings(
        color: Colors.blue,
      ),
      onRefresh: () async {
        await _handlePullToRefresh();
      },
    );
  }

  bool _shouldCreatePullToRefresh() {
    return !kIsWeb &&
        [TargetPlatform.iOS, TargetPlatform.android]
            .contains(defaultTargetPlatform);
  }

  Future<void> _handlePullToRefresh() async {
    if (defaultTargetPlatform == TargetPlatform.android) {
      webViewController?.reload();
    } else if (defaultTargetPlatform == TargetPlatform.iOS) {
      webViewController?.loadUrl(
        urlRequest: URLRequest(url: await webViewController?.getUrl()),
      );
    }
  }

  onWebViewCreated(InAppWebViewController controller) {
    webViewController = controller;
    setState();
  }

  onLoadStart(InAppWebViewController controller, WebUri? uri) {
    url = (uri ?? "").toString();

    // Security: Validate URL on load start
    if (!_isUrlSafe(url)) {
      Utils.logPrint(
          "SECURITY WARNING: Attempted to navigate to unsafe URL: $url");
      controller.stopLoading();
      _showSecurityWarning();
      return;
    }

    setState();
  }

  onLoadStop(InAppWebViewController controller, WebUri? uri) {
    url = (uri ?? "").toString();
    setState();
  }

  onProgressChanged(InAppWebViewController controller, int pro) {
    progress = (pro / 100);
    setState();
  }

  // Function to Get Terms And Condition HTML
  Future<void> getTermsAndConditions() async {
    isLoading = true;
    UserDetailRepo? userDetailRepo = UserDetailRepo(apiClient);
    final langCode = await Preferences.getString(Preferences.keyLanguageCode);
    webPage = await userDetailRepo.getTermsAndConditions(langCode);
    isLoading = false;
    setState();
  }

  cancelButton() {
    setContext(mContext);
    navPop();
  }
}
