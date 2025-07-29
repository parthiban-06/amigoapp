import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:visaamigo/core/base/view/base_view.dart';
import 'package:visaamigo/custom_widgets/visa_appbar.dart';
import 'package:visaamigo/features/webview/providers/webview_provider_mobile.dart';
import 'package:visaamigo/utils/utils.dart';

import '../../../generated/l10n.dart';
import '../../../utils/const_screen_size.dart';

class WebViewScreenMobile extends StatelessWidget {
  final String? url;
  final bool? openWeb;
  final bool? showVisaIcon;

  const WebViewScreenMobile(
      {super.key, this.url, this.openWeb, this.showVisaIcon});

  @override
  Widget build(BuildContext context) {
    Utils.logPrint("hideVisaIcon $showVisaIcon");
    var s = S.of(context);
    return BaseView<WebViewProviderMobile>(
      viewModel: WebViewProviderMobile(),
      addDefaultPadding: false,
      wrapWithSafeArea: false,
      setTopSafeArea: false,
      onlyDesktop: true,
      onModelReady: (model) {
        model.setContext(context);
        model.init(myUrl: url, openWeb: openWeb);
      },
      onPageBuilderMobileView:
          (BuildContext context, WebViewProviderMobile viewModel) {
        return Column(
          children: [
            _buildAppBar(viewModel),
            _buildWebContent(context, viewModel),
          ],
        );
      },
    );
  }

  Widget _buildAppBar(WebViewProviderMobile viewModel) {
    return VisaAppBar(
      isCancelWithTextButtonShow: true,
      isActionButtonShow: true,
      isVisIconShow: showVisaIcon ?? true,
      onCancelPress: viewModel.cancelButton,
    );
  }

  Widget _buildWebContent(
      BuildContext context, WebViewProviderMobile viewModel) {
    if (kIsWeb && openWeb!) {
      return const Expanded(
        child: HtmlElementView(viewType: 'iframe-view'),
      );
    }

    if (!kIsWeb) {
      return _buildMobileContent(context, viewModel);
    }

    return const SizedBox();
  }

  Widget _buildMobileContent(
      BuildContext context, WebViewProviderMobile viewModel) {
    return Column(
      children: [
        _buildProgressIndicator(context, viewModel),
        _buildMainContent(context, viewModel),
      ],
    );
  }

  Widget _buildProgressIndicator(
      BuildContext context, WebViewProviderMobile viewModel) {
    if (viewModel.progress > 0 && viewModel.progress < 1) {
      return LinearProgressIndicator(
        value: viewModel.progress,
        color: Theme.of(context).colorScheme.primary,
        backgroundColor: Theme.of(context).colorScheme.secondary,
      );
    }
    return const SizedBox();
  }

  Widget _buildMainContent(
      BuildContext context, WebViewProviderMobile viewModel) {
    if (openWeb!) {
      return Expanded(
        child: _buildWebView(context, viewModel),
      );
    }

    return Expanded(
      child: _buildHtmlContent(context, viewModel),
    );
  }

  Widget _buildWebView(BuildContext context, WebViewProviderMobile viewModel) {
    return InAppWebView(
      initialUrlRequest: URLRequest(url: WebUri(url ?? "")),
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
        Utils.logPrint(consoleMessage);
      },
    );
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

  Widget _buildHtmlContent(
      BuildContext context, WebViewProviderMobile viewModel) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: Sizes.zeroInt.h,
        horizontal: Sizes.twoInt.w,
      ),
      child: _buildHtmlContentBody(viewModel),
    );
  }

  Widget _buildHtmlContentBody(WebViewProviderMobile viewModel) {
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
              ),
            ),
          ),
        ],
      );
    }

    return const SizedBox.shrink();
  }
}
