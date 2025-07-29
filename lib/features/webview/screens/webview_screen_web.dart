import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:visaamigo/core/base/view/base_view.dart';
import 'package:visaamigo/custom_widgets/visa_appbar.dart';
import 'package:visaamigo/utils/utils.dart';

import '../../../utils/const_screen_size.dart';
import '../providers/webview_provider_web.dart';

class WebViewScreenWeb extends StatelessWidget {
  final String? url;
  final bool? openWeb;
  final bool? showVisaIcon;

  const WebViewScreenWeb(
      {super.key, this.url, this.openWeb, this.showVisaIcon});

  @override
  Widget build(BuildContext context) {
    Utils.logPrint("hideVisaIcon $showVisaIcon");
    return BaseView<WebViewProviderWeb>(
      viewModel: WebViewProviderWeb(),
      addDefaultPadding: false,
      wrapWithSafeArea: false,
      setTopSafeArea: false,
      onlyDesktop: true,
      onModelReady: (model) {
        model.setContext(context);
        model.init(myUrl: url, openWeb: openWeb);
      },
      onPageBuilderMobileView:
          (BuildContext context, WebViewProviderWeb viewModel) {
        return Column(
          children: [
            VisaAppBar(
              isCancelWithTextButtonShow: true,
              isActionButtonShow: true,
              isVisIconShow: showVisaIcon ?? true,
              onCancelPress: viewModel.cancelButton,
            ),
            if (kIsWeb && openWeb!)
              const Expanded(
                child: HtmlElementView(
                  viewType: 'iframe-view',
                ),
              ),
            if (kIsWeb && !openWeb!)
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: Sizes.zeroInt.h,
                    horizontal: Sizes.twoInt.w,
                  ),
                  child: viewModel.webPage.isNotEmpty
                      ? Column(
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
                        )
                      : const SizedBox.shrink(),
                ),
              )
          ],
        );
      },
    );
  }
}
