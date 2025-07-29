import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:visaamigo/core/theme/theme.dart';
import 'package:visaamigo/custom_widgets/visa_textview.dart';
import 'package:visaamigo/generated/l10n.dart';

import '../../../utils/const_screen_size.dart';
import '../providers/termsAndPrivacyProvider.dart';

class TermsAndPolicy extends StatefulWidget {
  const TermsAndPolicy({super.key});

  @override
  State<TermsAndPolicy> createState() => _TermsAndPolicyState();
}

class _TermsAndPolicyState extends State<TermsAndPolicy> {
  late final TermsAndPrivacyProvider termsAndPrivacyProvider;

  @override
  void initState() {
    super.initState();
    // Initialize TermsAndPrivacyProvider once
    termsAndPrivacyProvider = GetIt.I<TermsAndPrivacyProvider>();
    termsAndPrivacyProvider.setContext(context);
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => termsAndPrivacyProvider,
      child: Consumer<TermsAndPrivacyProvider>(
        builder: (context, viewModel, _) {
          var isDesktop = viewModel.isDesktopView;
          var isMobileWeb = viewModel.isMobileWebView;
          return Align(
            alignment: isDesktop || isMobileWeb
                ? Alignment.centerLeft
                : Alignment.center,
            child: Padding(
              padding: EdgeInsets.only(
                bottom: Sizes.twenty.toDouble().h,
                right: isDesktop || isMobileWeb
                    ? Sizes.zero
                    : Sizes.six.toDouble().w,
              ),
              child: Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  InkWell(
                    onTap: () {
                      viewModel.goToTermAndCondition();
                    },
                    child: Semantics(
                      excludeSemantics: true,
                      container: true,
                      label:
                          "${S.of(context).termConditions}, ${S.of(context).double_tap_to_activate_link}",
                      child: VisaTextView(
                        semantics: false,
                        text: S.of(context).termConditions,
                        overflow: TextOverflow.fade,
                        style: VisaTextStyle.link,
                        letterSpacing: 0,
                        fontFamily: VisaFontWeight.semibold,
                        // fontSize: 14,
                        lineHeight: 1.29,
                        customColor: VisaColors.primary,
                        colorTheme: VisaTextTheme.customTextColor,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10.w),
                    child: Container(
                      height: 10.h,
                      width: 1.w,
                      color: Theme.of(context).colorScheme.tertiary,
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      viewModel.goToPrivacyPolicy();
                    },
                    child: Semantics(
                      excludeSemantics: true,
                      container: true,
                      label:
                          "${S.of(context).privacy_notice}, ${S.of(context).double_tap_to_activate_link}",
                      child: VisaTextView(
                        semantics: false,
                        text: S.of(context).privacy_notice,
                        overflow: TextOverflow.fade,
                        style: VisaTextStyle.link,
                        letterSpacing: 0,
                        lineHeight: 1.29,
                        fontFamily: VisaFontWeight.semibold,
                        // fontSize: 14,
                        customColor: VisaColors.primary,
                        colorTheme: VisaTextTheme.customTextColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
