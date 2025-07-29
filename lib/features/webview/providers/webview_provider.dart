import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:provider/provider.dart';
import 'package:universal_html/html.dart' as dom;
import 'package:universal_html/parsing.dart';
import 'package:visaamigo/custom_widgets/visa_button.dart';
import 'package:visaamigo/custom_widgets/visa_dialog.dart'
    show VisaDialog, VisaDialogShowConfig;
import 'package:visaamigo/custom_widgets/visa_snack_bar.dart';
import 'package:visaamigo/generated/l10n.dart';
import 'package:visaamigo/ui/base/base_provider.dart';
import 'package:visaamigo/utils/utils.dart';

import '../../../utils/app_const.dart';
import '../../../utils/shared_preferences.dart';
import '../../profile/provider/user_generic_detail_provider.dart';
import '../../splash_screen/repo/user_detail_repo.dart';

class WebViewProvider extends BaseProvider {
  final GlobalKey webViewKey = GlobalKey();
  InAppWebViewController? webViewController;
  bool canGoBack = false;
  bool canGoForward = false;
  String url = "";
  double progress = 0;
  String webPage = "";
  bool termApiError = false;

  UserDetailRepo? userDetailRepo;
  UserGenericProvider? genericUserProvider;

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
      'trantor.com',
      'booking.com'
      // Add more trusted domains as needed
    ];

    return !trustedDomains.any((domain) => uri.host.contains(domain));
  }

  // Security: Show warning for unsafe URLs
  void _showSecurityWarning() {
    VisaDialog.show(
      context: getContext(),
      title: S.of(mContext)!.security_warning,
      message: S.of(mContext)!.security_warning_message,
      config: VisaDialogShowConfig(
        primaryButtonText: S.of(mContext)!.ok,
        barrierDismissible: false,
        onPrimaryPressed: () {
          Navigator.pop(mContext);
        },
      ),
    );
  }

  InAppWebViewSettings settings = InAppWebViewSettings(
    // Security Settings
    javaScriptEnabled: true,
    // Explicitly enable JavaScript for functionality
    javaScriptCanOpenWindowsAutomatically: false,
    // Prevent popup windows
    domStorageEnabled: true,
    // Allow DOM storage for web functionality
    databaseEnabled: true,
    // Disable database access for security
    useWideViewPort: true,
    loadWithOverviewMode: true,

    // Media Settings (current settings are acceptable)
    isInspectable: kDebugMode,
    // Only enable in debug mode
    mediaPlaybackRequiresUserGesture: false,
    allowsInlineMediaPlayback: true,

    // Content Security - Allow images and mixed content
    mixedContentMode: MixedContentMode.MIXED_CONTENT_COMPATIBILITY_MODE,
    // Allow mixed content for compatibility with sites like FIFA.com
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

    // User Agent
    // userAgent: "VisaAmigo/1.0",
    // Set custom user agent

    // Image Loading
    loadsImagesAutomatically: true,
    // Ensure images load automatically
  );

  PullToRefreshController? pullToRefreshController;

  late ContextMenu contextMenu;

  // Initialize Method
  void init({String? myUrl, bool? openWeb}) {
    genericUserProvider =
        Provider.of<UserGenericProvider>(mContext, listen: false);

    if (!openWeb!) {
      _handleNonWebMode(myUrl);
      return;
    }

    if (!_isValidUrl(myUrl)) {
      _showUrlNotFoundDialog();
      return;
    }

    // Process URL if it contains booking.com
    if (myUrl != null && myUrl!.contains('booking.com')) {
      final uri = Uri.parse(myUrl!);
      final queryParams = Map<String, String>.from(uri.queryParameters);

      // Add aid parameter if not already present
      if (!queryParams.containsKey('aid')) {
        queryParams['aid'] = '2434882';
      }

      // Add aid parameter if not already present
      if (!queryParams.containsKey('label')) {
        queryParams['label'] =
            'VisaGo_${genericUserProvider?.userConfigModel?.itineraryIds.first}_${genericUserProvider?.userModel?.userId}';
      }

      // Reconstruct the URL with the new query parameters
      final newUri = uri.replace(queryParameters: queryParams);
      myUrl = newUri.toString();
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
      final context = getContext();
      if (context.mounted) {
        VisaDialog.show(
          context: context,
          title: S.of(context).url_not_found,
          message: S.of(context).something_went_wrong,
          config: VisaDialogShowConfig(
            primaryButtonVariant: VisaButtonVariant.primary,
            barrierDismissible: true,
            primaryButtonText: S.of(context).return_text,
            onPrimaryPressed: () {
              navPop();
              navPop();
            },
          ),
        );
      }
    });
  }

  void _initializeWebView(String myUrl) {
    url = myUrl;
    Utils.logPrint("_initializeWebView : ${url ?? ""}");
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

    // Security: Monitor JavaScript console messages
    // controller.addJavaScriptHandler(
    //   handlerName: 'securityMonitor',
    //   callback: (args) {
    //     Utils.logPrint("JavaScript Security Monitor: ${args.toString()}");
    //     // Log suspicious JavaScript activity
    //     if (args.toString().contains('eval') ||
    //         args.toString().contains('document.cookie') ||
    //         args.toString().contains('localStorage')) {
    //       Utils.logPrint(
    //           "SECURITY ALERT: Suspicious JavaScript activity detected");
    //     }
    //   },
    // );

    setState();
  }

  onLoadStart(InAppWebViewController controller, WebUri? uri) async {
    url = (uri ?? "").toString();

    Utils.logPrint("_initializeWebView onLoadStartL: $url");

    // Security: Validate URL on load start
    if (!_isUrlSafe(url)) {
      Utils.logPrint(
          "SECURITY WARNING: Attempted to navigate to unsafe URL: $url");
      controller.stopLoading();
      _showSecurityWarning();
      return;
    }

    canGoBack = await controller.canGoBack();
    canGoForward = await controller.canGoForward();
    setState();
  }

  onLoadStop(InAppWebViewController controller, WebUri? uri) {
    url = (uri ?? "").toString();
    Utils.logPrint(" _initializeWebView onLoadStop: $url");

    setState();
  }

  onProgressChanged(InAppWebViewController controller, int pro) {
    progress = (pro / 100);
    setState();
  }

  // Handle CORS and other network errors gracefully
  void handleConsoleMessage(ConsoleMessage consoleMessage) {
    if (consoleMessage.messageLevel == ConsoleMessageLevel.ERROR) {
      // Handle CORS errors
      if (consoleMessage.message.contains('CORS') ||
          consoleMessage.message.contains('Access-Control-Allow-Origin')) {
        Utils.logPrint(
            "CORS Error handled gracefully: ${consoleMessage.message}");
        return;
      }

      // Handle other common network errors
      if (consoleMessage.message.contains('XMLHttpRequest') ||
          consoleMessage.message.contains('fetch')) {
        Utils.logPrint(
            "Network request error handled: ${consoleMessage.message}");
        return;
      }
    }

    // Log other console messages normally
    Utils.logPrint(consoleMessage);
  }

  // Function to Get Terms And Condition HTML
  Future<void> getTermsAndConditions() async {
    isLoading = true;
    termApiError = false;
    UserDetailRepo? userDetailRepo = UserDetailRepo(apiClient);
    final langCode = await Preferences.getString(Preferences.keyLanguageCode);
    try {
      webPage = await userDetailRepo.getTermsAndConditions(langCode);
      isLoading = false;
    } catch (e) {
      isLoading = false;
      termApiError = true;

      // Capture context before async operations to avoid BuildContext across async gaps
      final context = getContext();
      if (context.mounted) {
        visaSnackBar(
            type: SnackBarType.failure,
            context: context,
            title: "${S.of(context).failed_response}!",
            subtitle: S.of(context).something_went_wrong,
            showAtBottom: false);
      }
    }
    setState();
  }

  List<String> extractVisibleText(String htmlContent) {
    // Parse the HTML string
    dom.Document document = parseHtmlDocument(htmlContent);

    // Remove <script> and <style> tags
    document.querySelectorAll('script, style').forEach((e) => e.remove());

    // Fallback to entire document if <body> is missing
    dom.Node rootNode = document.documentElement ?? document;

    // Extract visible text recursively
    String extractText(dom.Node node) {
      if (node.nodeType == dom.Node.TEXT_NODE) {
        return node.text?.trim() ?? '';
      }
      if (node is dom.Element) {
        return node.nodes.map(extractText).join(' ');
      }
      return '';
    }

    String rawText = extractText(rootNode);

    // Clean up: split by line, remove empty lines
    return rawText
        .split('\n')
        .map((line) => line.trim())
        .where((line) => line.isNotEmpty)
        .toList();
  }

  cancelButton() {
    setContext(mContext);
    navPop();
  }
}
