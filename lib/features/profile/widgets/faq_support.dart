import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:visaamigo/core/theme/theme.dart';
import 'package:visaamigo/custom_widgets/visa_size_box.dart';
import 'package:visaamigo/custom_widgets/visa_textview.dart';
import 'package:visaamigo/features/profile/provider/faq_provider.dart';
import 'package:visaamigo/features/profile/widgets/faq_support_widget.dart';
import 'package:visaamigo/features/profile/widgets/faq_visa_support_tool_tip_wrapper_widget.dart';
import 'package:visaamigo/generated/l10n.dart';
import 'package:visaamigo/utils/const_screen_size.dart';

class FaqSupport extends StatelessWidget {
  final FaqProvider faqViewModel;
  final bool isDesktop;
  final bool isMobileWeb;

  const FaqSupport({
    super.key,
    required this.faqViewModel,
    required this.isDesktop,
    required this.isMobileWeb,
  });

  @override
  Widget build(BuildContext context) {
    if (!_isUserLoggedIn()) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSupportTitle(context),
        VisaSizeBox(height: Sizes.sixteenInt.h),
        _buildSupportContent(context),
      ],
    );
  }

  bool _isUserLoggedIn() {
    return faqViewModel.isUserLogin != null &&
        faqViewModel.isUserLogin! == true;
  }

  Widget _buildSupportTitle(BuildContext context) {
    return VisaTextView(
      text: S.of(context).support_links.toUpperCase(),
      softWrap: true,
      overflow: TextOverflow.visible,
      style: VisaTextStyle.customLarge,
      fontFamily: VisaFontWeight.medium,
      fontSize: Sizes.twelveInt.toDouble(),
      customColor: VisaColors.textFieldBorder,
      lineHeight: (16.8 / Sizes.twelveInt.toDouble()).h,
      colorTheme: VisaTextTheme.customTextColor,
      letterSpacing: 2,
    );
  }

  Widget _buildSupportContent(BuildContext context) {
    if (isDesktop) {
      return _buildDesktopLayout(context);
    } else if (isMobileWeb) {
      return _buildMobileWebLayout(context);
    } else {
      return _buildMobileLayout(context);
    }
  }

  Widget _buildDesktopLayout(BuildContext context) {
    return Wrap(
      spacing: Sizes.sixteenInt.w,
      runSpacing: Sizes.sixteenInt.h,
      children: List.generate(
          4, (index) => _buildSupportButton(context, index, true)),
    );
  }

  Widget _buildMobileWebLayout(BuildContext context) {
    return Column(
      children: List.generate(
        4,
        (index) => _buildSupportButton(context, index, false),
      ),
    );
  }

  Widget _buildMobileLayout(BuildContext context) {
    return Column(
      children: [
        _buildMobileSupportButton(context, 0),
        Padding(
          padding: EdgeInsets.symmetric(vertical: Sizes.sixteenInt.h),
          child: _buildMobileSupportButton(context, 1),
        ),
        _buildMobileSupportButton(context, 2),
        VisaSizeBox(height: Sizes.twentyInt.h),
      ],
    );
  }

  Widget _buildSupportButton(BuildContext context, int index, bool isDesktop) {
    final isVisaSupport = index == 3;
    Widget faqButton = _createFaqSupportWidget(context, index, isDesktop);

    if (isVisaSupport) {
      faqButton = _wrapWithTooltip(faqButton);
    }

    if (isDesktop) {
      return _wrapWithConstraints(faqButton);
    }

    return Padding(
      padding: EdgeInsets.only(bottom: Sizes.sixteenInt.h),
      child: faqButton,
    );
  }

  Widget _buildMobileSupportButton(BuildContext context, int index) {
    return FaqSupportWidget(
      onTap: () => _handleSupportTap(index),
      txt: _getSupportText(context, index),
    );
  }

  Widget _createFaqSupportWidget(
      BuildContext context, int index, bool isDesktop) {
    return FaqSupportWidget(
      onTap: () => _handleSupportTap(index),
      txt: _getSupportText(context, index),
    );
  }

  Widget _wrapWithTooltip(Widget child) {
    return FaqVisaSupportToolTipWrapperWidget(
      superTooltipController: faqViewModel.superToolTipController,
      child: child,
    );
  }

  Widget _wrapWithConstraints(Widget child) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth: 0.185.sw,
        minWidth: 0.1.sw,
      ),
      child: child,
    );
  }

  void _handleSupportTap(int index) {
    switch (index) {
      case 0:
        faqViewModel.ticketSupportRedirect();
        break;
      case 1:
        faqViewModel.bookingSupportRedirect();
        break;
      case 2:
        faqViewModel.prepaidSupportRedirect();
        break;
      case 3:
        faqViewModel.superToolTipController.showTooltip();
        break;
    }
  }

  String _getSupportText(BuildContext context, int index) {
    final supportTexts = [
      S.of(context).fifa_ticket_support,
      S.of(context).booking_support,
      S.of(context).prepaid_card_support,
      S.of(context).visa_go_support,
    ];
    return supportTexts[index];
  }
}
