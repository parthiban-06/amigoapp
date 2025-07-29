import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:share_plus/share_plus.dart';
import 'package:visaamigo/core/base/view/base_view.dart';
import 'package:visaamigo/core/theme/theme.dart';
import 'package:visaamigo/custom_widgets/visa_appbar.dart';
import 'package:visaamigo/custom_widgets/visa_retry_button_widget.dart';
import 'package:visaamigo/features/webview/providers/webview_provider.dart';
import 'package:visaamigo/utils/app_extensions.dart';
import 'package:visaamigo/utils/utils.dart';

import '../../../custom_widgets/webview_appbar.dart';
import '../../../generated/l10n.dart';
import '../../../utils/const_screen_size.dart';

class WebViewScreen extends StatelessWidget {
  final String? url;
  final bool? openWeb;
  final bool? showVisaIcon;

  const WebViewScreen({super.key, this.url, this.openWeb, this.showVisaIcon});

  @override
  Widget build(BuildContext context) {
    Utils.logPrint("hideVisaIcon ${showVisaIcon}");
    var s = S.of(context);
    return BaseView<WebViewProvider>(
      viewModel: WebViewProvider(),
      addDefaultPadding: false,
      wrapWithSafeArea: false,
      setTopSafeArea: false,
      onlyDesktop: true,
      onModelReady: (model) {
        model.setContext(context);
        model.init(myUrl: url, openWeb: openWeb);
      },
      onPageBuilderMobileView:
          (BuildContext context, WebViewProvider viewModel) {
        return Column(
          children: [
            _buildAppBar(context, viewModel),
            _buildProgressIndicator(context, viewModel),
            _buildMainContent(context, viewModel),
            _buildBottomNavigation(context, viewModel),
          ],
        );
      },
    );
  }

  Widget _buildAppBar(BuildContext context, WebViewProvider viewModel) {
    if (openWeb!) {
      return WebViewAppbar(
        url: viewModel.url,
        show: viewModel.webPage.isEmpty,
      );
    }

    return VisaAppBar(
      isActionButtonShow: true,
      isCancelWithTextButtonShow: true,
      onCancelPress: () {
        Navigator.of(context).pop();
      },
    );
  }

  Widget _buildProgressIndicator(
      BuildContext context, WebViewProvider viewModel) {
    if (viewModel.progress > 0 && viewModel.progress < 1) {
      return LinearProgressIndicator(
        value: viewModel.progress,
        color: Theme.of(context).colorScheme.primary,
        backgroundColor: Theme.of(context).colorScheme.secondary,
      );
    }
    return const SizedBox();
  }

  Widget _buildMainContent(BuildContext context, WebViewProvider viewModel) {
    if (openWeb!) {
      return Expanded(
        child: _buildWebView(context, viewModel),
      );
    }

    return Expanded(
      child: _buildHtmlContent(context, viewModel),
    );
  }

  Widget _buildWebView(BuildContext context, WebViewProvider viewModel) {
    return InAppWebView(
      gestureRecognizers: _createGestureRecognizers(),
      initialUrlRequest: URLRequest(url: WebUri(viewModel.url ?? "")),
      initialSettings: viewModel.settings,
      pullToRefreshController: viewModel.pullToRefreshController,
      onWebViewCreated: (controller) async {
        viewModel.onWebViewCreated(controller);
      },
      onLoadStart: (controller, url) {
        viewModel.onLoadStart(controller, url);
      },
      shouldOverrideUrlLoading: (controller, navigationAction) async {
        return _handleUrlLoading(navigationAction);
      },
      onLoadStop: (controller, url) {
        viewModel.onLoadStart(controller, url);
      },
      onProgressChanged: (controller, progress) {
        viewModel.onProgressChanged(controller, progress);
      },
      onConsoleMessage: (controller, consoleMessage) {
        viewModel.handleConsoleMessage(consoleMessage);
      },
    );
  }

  Set<Factory<OneSequenceGestureRecognizer>> _createGestureRecognizers() {
    return Set()
      ..add(Factory<VerticalDragGestureRecognizer>(
          () => VerticalDragGestureRecognizer()))
      ..add(Factory<HorizontalDragGestureRecognizer>(
          () => HorizontalDragGestureRecognizer()));
  }

  NavigationActionPolicy _handleUrlLoading(NavigationAction navigationAction) {
    var uri = navigationAction.request.url!;

    if (!_isAllowedScheme(uri.scheme)) {
      // Handle disallowed schemes if needed
    }

    return NavigationActionPolicy.ALLOW;
  }

  bool _isAllowedScheme(String scheme) {
    return ["http", "https", "file", "chrome", "data", "javascript", "about"]
        .contains(scheme);
  }

  Widget _buildHtmlContent(BuildContext context, WebViewProvider viewModel) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: Sizes.zeroInt.h,
        horizontal: Sizes.twoInt.w,
      ),
      child: _buildHtmlContentBody(context, viewModel),
    );
  }

  Widget _buildHtmlContentBody(
      BuildContext context, WebViewProvider viewModel) {
    if (viewModel.webPage.isNotEmpty) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Html(
                data: viewModel.webPage,
                shrinkWrap: true,
                style: _getHtmlStyles(context),
              ),
            ),
          ),
        ],
      );
    }

    if (viewModel.termApiError) {
      return Center(
        child: VisaRetryButtonWidget(
          label: S.of(context).retry,
          onRetry: () {
            viewModel.getTermsAndConditions();
          },
        ),
      );
    }

    return const SizedBox.shrink();
  }

  Map<String, Style> _getHtmlStyles(BuildContext context) {
    return {
      "h1": _scaledStyle(context, 24),
      "h2": _scaledStyle(context, 20),
      "h3": _scaledStyle(context, 16),
      "p": _scaledStyle(context, 14),
      "li": _scaledStyle(context, 13),
      "a": _scaledStyle(context, 14, underline: true),
    };
  }

  Widget _buildBottomNavigation(
      BuildContext context, WebViewProvider viewModel) {
    if (!openWeb! || viewModel.webViewController == null) {
      return const SizedBox();
    }

    return Container(
      height: Sizes.eightyInt.h,
      width: context.screenWidth,
      color: VisaColors.white,
      child: Padding(
        padding: EdgeInsets.only(bottom: Sizes.twenty.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _buildBackButton(viewModel),
            _buildForwardButton(viewModel),
            _buildShareButton(viewModel),
            _buildRefreshButton(viewModel),
            _buildExternalButton(viewModel),
          ],
        ),
      ),
    );
  }

  Widget _buildBackButton(WebViewProvider viewModel) {
    return IconButton(
      onPressed: viewModel.canGoBack == false
          ? null
          : () async {
              if (await viewModel.webViewController!.canGoBack()) {
                await viewModel.webViewController!.goBack();
              }
            },
      icon: Icon(
        Icons.arrow_back_ios,
        size: Sizes.twentyFourInt.h,
      ),
    );
  }

  Widget _buildForwardButton(WebViewProvider viewModel) {
    return IconButton(
      onPressed: viewModel.canGoForward == false
          ? null
          : () async {
              if (await viewModel.webViewController!.canGoForward()) {
                await viewModel.webViewController!.goForward();
              }
            },
      icon: Icon(
        Icons.arrow_forward_ios,
        size: Sizes.twentyFourInt.h,
      ),
    );
  }

  Widget _buildShareButton(WebViewProvider viewModel) {
    return IconButton(
      onPressed: () async {
        SharePlus.instance.share(ShareParams(text: viewModel.url));
      },
      icon: Icon(
        Icons.ios_share_outlined,
        size: Sizes.twentyFourInt.h,
      ),
    );
  }

  Widget _buildRefreshButton(WebViewProvider viewModel) {
    return Transform.rotate(
      angle: 4.7124, // 270 degrees in radians
      child: IconButton(
        onPressed: () async {
          await viewModel.webViewController!.reload();
        },
        icon: Icon(
          Icons.refresh,
          size: Sizes.twentyFourInt.h,
        ),
      ),
    );
  }

  Widget _buildExternalButton(WebViewProvider viewModel) {
    return IconButton(
      onPressed: () async {
        if (url != null) {
          Utils.openExternalApplication(viewModel.url, "");
        }
      },
      icon: Icon(
        Icons.output,
        size: Sizes.twentyFourInt.h,
      ),
    );
  }

  Style _scaledStyle(BuildContext context, double baseFontSize,
      {bool underline = false}) {
    return Style(
      fontSize: FontSize(baseFontSize * getCappedScale(context, baseFontSize)),
      textDecoration: underline ? TextDecoration.underline : null,
    );
  }

  double getCappedScale(BuildContext context, double fontSize) {
    final currentScale = MediaQuery.of(context).textScaler.scale(1);
    if (currentScale >= 3) return 0.45;
    if (currentScale >= 2) return 0.55;
    if (currentScale >= 1.5) return 0.7;
    if (currentScale >= 1.25) return 0.8;
    if (currentScale > 1) return 0.95;
    return currentScale;
  }
}
