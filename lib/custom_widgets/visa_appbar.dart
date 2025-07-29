import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:visaamigo/custom_widgets/visa_svg_icon.dart';
import 'package:visaamigo/features/profile/provider/user_generic_detail_provider.dart';
import 'package:visaamigo/generated/l10n.dart';
import 'package:visaamigo/router/app_routes_const.dart';
import 'package:visaamigo/utils/app_extensions.dart';
import 'package:visaamigo/utils/theme_extension.dart';

import '../analytics/firebase_analytics_service.dart';
import '../core/theme/theme.dart';
import '../generated/assets.dart';
import '../router/app_router.dart';
import '../utils/const_screen_size.dart';
import '../utils/responsive_util.dart';
import 'visa_appbar_actions.dart';
import 'visa_textview.dart';

class VisaAppBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback? onRecentPress;
  final VoidCallback? onCancelPress;
  final VoidCallback? onRightSideHamburgerIconPress;
  final String visaIcon;
  final FocusNode? focusNode;
  final bool isActionButtonShow;
  final bool isRecentButtonShow;
  final bool isCancelButtonShow;
  final bool isCancelWithTextButtonShow;
  final bool isVisIconShow;
  final bool isBackButtonShow;
  final bool isHamburgerIconShow;
  final bool isRightSideHamburgerIconShow;
  final double visaIconHeight;
  final Color? hamburgerIconColor;
  final double visaIconWidth;
  final Color? visaIconColor;
  final Color? brandingLogoColor;
  final Color? cancelIconColor;
  final Color? cancelTextColor;
  final Color? rightSideHamburgerIconColor;
  final double rightSideHamburgerIconWidth;
  final double rightSideHamburgerIconHeight;
  final bool semanticsForVisaLogo;
  final bool isLoginButtonShow;
  final bool semantics;
  final int? semanticsIndex;
  final bool semanticsFocused;
  final bool useWithShadow;
  final bool isComeFromAppBar;

  const VisaAppBar({
    super.key,
    this.onRecentPress,
    this.onCancelPress,
    this.onRightSideHamburgerIconPress,
    this.visaIcon = Assets.iconsVisaLogo,
    this.isVisIconShow = true,
    this.isBackButtonShow = false,
    this.isActionButtonShow = false,
    this.isRecentButtonShow = false,
    this.isCancelButtonShow = false,
    this.isHamburgerIconShow = false,
    this.isCancelWithTextButtonShow = false,
    this.visaIconHeight = 22.0,
    this.visaIconWidth = 22.0,
    this.visaIconColor,
    this.hamburgerIconColor,
    this.brandingLogoColor,
    this.cancelIconColor,
    this.cancelTextColor,
    this.isRightSideHamburgerIconShow = false,
    this.rightSideHamburgerIconColor = Colors.white,
    this.rightSideHamburgerIconWidth = 32.0,
    this.rightSideHamburgerIconHeight = 32.0,
    this.semanticsForVisaLogo = false,
    this.isLoginButtonShow = false,
    this.semantics = true,
    this.semanticsIndex,
    this.semanticsFocused = false,
    this.focusNode,
    this.useWithShadow = false,
    this.isComeFromAppBar = true,
  });

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final double zero = AppSizes.zero;
    final double sixteen = AppSizes.sixteenRadius;
    final double twentyEight = AppSizes.twentyEightRadius;
    int readNotificationCount =
        Provider.of<UserGenericProvider>(context, listen: true)
            .readNotificationCount;
    final responsive = Provider.of<ResponsiveUtil>(context, listen: false);
    final showLeading = isBackButtonShow || isHamburgerIconShow;
    return Container(
      // margin: EdgeInsets.only(
      //   top: 30,
      // ),
      child: AppBar(
        backgroundColor: VisaColors.transparent,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor:
              Colors.transparent, // Ensure status bar is transparent
          statusBarIconBrightness:
              Brightness.dark, // Black icons for status bar
          statusBarBrightness: Brightness.light, // iOS-specific setting
        ),
        surfaceTintColor: VisaColors.transparent,
        // shadowColor: Colors.transparent,
        elevation: zero,
        centerTitle: false,
        title: _buildTitle(s, context),
        // leading: isBackButtonShow? const SizedBox.shrink():,
        leadingWidth:
            showLeading ? (responsive.isMobileWebView ? zero : sixteen) : zero,
        titleSpacing: showLeading
            ? (responsive.isMobileWebView ? sixteen : zero)
            : sixteen,
        automaticallyImplyLeading: showLeading,
        iconTheme: IconThemeData(
            color: hamburgerIconColor ?? context.theme.primaryColor),
        actions: isActionButtonShow
            ? _buildActions(s, context, readNotificationCount)
            : [],
      ),
    );
  }

  Widget _buildTitle(S s, BuildContext context) {
    if (!isVisIconShow) {
      return const SizedBox.shrink();
    }

    return VisaSvgIcon(
      semantics: semanticsForVisaLogo,
      semanticsLabel: s.visa_logo,
      assetPath: Assets.iconsIcVisaLogo,
      height: visaIconHeight.h,
      width: 68.w,
      isIconFlip: false,
      color: brandingLogoColor ?? context.theme.primaryColor,
    );
  }

  List<Widget> _buildActions(
      S s, BuildContext context, int readNotificationCount) {
    final actions = <Widget>[];

    if (isRecentButtonShow) {
      actions.add(_buildRecentButton(s, context));
    }

    if (isCancelButtonShow) {
      actions.add(_buildCancelButton(context));
    }

    if (isCancelWithTextButtonShow) {
      actions.add(_buildCancelWithTextButton(s, context));
    }

    if (isRightSideHamburgerIconShow) {
      actions.add(_buildHamburgerIcon(context, readNotificationCount));
    } else if (isLoginButtonShow) {
      actions.add(_buildLoginButton(s));
    }

    return actions;
  }

  Widget _buildRecentButton(S s, BuildContext context) {
    return VisaAppBarActions(
      text: s.recents,
      onPressed: onRecentPress,
      visaTextStyle: VisaTextStyle.bodyMedium,
      visaTextTheme: VisaTextTheme.primaryDark,
      isIconShow: true,
      isTextShow: true,
      icons: Icons.replay_circle_filled,
      iconColor: context.theme.primaryColor,
      iconSize: AppSizes.twentyEightRadius,
      semantics: semantics,
      semanticsIndex: semanticsIndex,
      isComeFromAppBar: isComeFromAppBar,
    );
  }

  Widget _buildCancelButton(BuildContext context) {
    return VisaAppBarActions(
      onPressed: onCancelPress,
      isIconShow: true,
      isTextShow: false,
      icons: Icons.cancel,
      iconColor: cancelIconColor ?? context.theme.primaryColor,
      iconSize: AppSizes.twentyEightRadius,
      semantics: semantics,
      semanticsIndex: semanticsIndex,
      semanticsFocused: semanticsFocused,
      isComeFromAppBar: isComeFromAppBar,
    );
  }

  Widget _buildCancelWithTextButton(S s, BuildContext context) {
    final textTheme = cancelTextColor != null
        ? VisaTextTheme.customTextColor
        : VisaTextTheme.primaryDark;

    return Focus(
      focusNode: focusNode,
      child: VisaAppBarActions(
        onPressed: onCancelPress,
        visaTextStyle: VisaTextStyle.bodyMedium,
        visaTextTheme: textTheme,
        isIconShow: true,
        isTextShow: true,
        text: s.close.toUpperCase(),
        icons: Icons.close,
        iconColor: cancelIconColor ?? VisaColors.black,
        iconSize: AppSizes.sixteenRadius,
        letterSpacing: AppSizes.twoRadius,
        customColor: cancelTextColor ?? VisaColors.black,
        padding: EdgeInsetsDirectional.only(end: Sizes.eight),
        semantics: semantics,
        semanticsIndex: semanticsIndex,
        semanticsFocused: semanticsFocused,
        isComeFromAppBar: isComeFromAppBar,
      ),
    );
  }

  Widget _buildHamburgerIcon(BuildContext context, int readNotificationCount) {
    return InkWell(
      onTap: () {
        FirebaseAnalyticsService.logEventButtonClick(btnName: "drawer");
        AppRouter.router.pushRoute(AppRoutes.drawer);
      },
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          VisaSvgIcon(
            padding: EdgeInsets.symmetric(
              horizontal: AppSizes.sixteenRadius,
            ),
            assetPath: Assets.iconsIcMenu,
            semanticsLabel:
                "${S.of(context).menu.toLowerCase()} ${S.of(context).double_tap_to_activate}",
            semantics: semantics,
            semanticsIndex: semanticsIndex,
            semanticsFocused: semanticsFocused,
            height: rightSideHamburgerIconHeight,
            width: rightSideHamburgerIconWidth,
            color: rightSideHamburgerIconColor ?? context.theme.primaryColor,
            useWithShadow: useWithShadow ? true : false,
          ),
          if (readNotificationCount != 0)
            Positioned(
              top: 2,
              right: 14,
              child: Container(
                width: 10,
                height: 10,
                decoration: const BoxDecoration(
                  color: VisaColors.orageColor,
                  shape: BoxShape.circle,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildLoginButton(S s) {
    return InkWell(
      onTap: () {
        AppRouter.router.goRoute(AppRoutes.login);
      },
      child: Padding(
        padding: EdgeInsets.only(right: AppSizes.dimSmall),
        child: VisaTextView(
          text: s.login_to_view_full_faqs,
          softWrap: true,
          overflow: TextOverflow.visible,
          style: VisaTextStyle.link,
          fontFamily: VisaFontWeight.semibold,
          fontSize: AppSizes.fontfourteen,
          customColor: VisaColors.primary,
          colorTheme: VisaTextTheme.customTextColor,
          lineHeight: 1.29,
          semantics: semantics,
          semanticsIndex: semanticsIndex,
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
