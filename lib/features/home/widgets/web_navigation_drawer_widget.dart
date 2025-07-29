import 'package:flutter/material.dart';
import 'package:visaamigo/core/theme/theme.dart';
import 'package:visaamigo/custom_widgets/visa_svg_icon.dart';
import 'package:visaamigo/custom_widgets/visa_textview.dart';
import 'package:visaamigo/generated/assets.dart';
import 'package:visaamigo/router/app_routes_const.dart';
import 'package:visaamigo/utils/const_screen_size.dart' show AppSizes;

import '../../../custom_widgets/visa_navigation_semantics.dart';
import '../../../generated/l10n.dart';

class WebNavigationDrawer extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemSelected;

  const WebNavigationDrawer({
    super.key,
    required this.selectedIndex,
    required this.onItemSelected,
  });

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);

    return Container(
      width: AppSizes.navBarWidth,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage(Assets.bgsBgSideNav),
          fit: BoxFit.cover,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // VISA Logo
          Padding(
            padding: EdgeInsets.symmetric(
              vertical: AppSizes.fiftyWidth,
              horizontal: AppSizes.ten,
            ),
            child: const VisaSvgIcon(
              semantics: false,
              assetPath: Assets.iconsIcVisaLogo,
              color: VisaColors.white,
              isIconFlip: false,
              setColorFilter: false,
            ),
          ),

          // Navigation Items
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final isSmallHeight = constraints.maxHeight < 600;

                final content = Column(
                  children: [
                    _buildNavItem(context, Assets.iconsHome, s.home,
                        AppRoutes.homeScreenIndex),
                    _buildNavItem(context, Assets.iconsEva, s.eva,
                        AppRoutes.evaScreenIndex),
                    _buildNavItem(context, Assets.iconsItinerary, s.itinerary,
                        AppRoutes.itineraryScreenIndex),
                    _buildNavItem(context, Assets.iconsIcTicket, s.tickets,
                        AppRoutes.ticketScreenIndex),
                    isSmallHeight ? AppSizes.xxlargeVS : const Spacer(),
                    Padding(
                      padding: EdgeInsets.only(bottom: AppSizes.heightFifty),
                      child: Column(
                        children: [
                          _buildMenuNavItem(
                              context, s.profile, AppRoutes.profileScreenIndex),
                          _buildMenuNavItem(context, s.notifications,
                              AppRoutes.notificationScreenIndex),
                          _buildMenuNavItem(context, s.eva_history,
                              AppRoutes.evaHistoryScreenIndex),
                          _buildMenuNavItem(
                              context, s.faq, AppRoutes.faqScreenIndex),
                        ],
                      ),
                    ),
                  ],
                );

                return isSmallHeight
                    ? SingleChildScrollView(
                        padding: EdgeInsets.only(top: AppSizes.heightFour),
                        child: content,
                      )
                    : content;
              },
            ),
          ),
        ],
      ),
    );
  }

  /// Nav item with icon (top items)
  Widget _buildNavItem(
      BuildContext context, String icon, String label, int index) {
    final isSelected = selectedIndex == index;
    final semanticsLabel =
        _getSemanticsLabel(context, label, index, isSelected, isMenu: false);

    return _buildNavTile(
      context: context,
      semanticsLabel: semanticsLabel,
      onTap: () => onItemSelected(index),
      isSelected: isSelected,
      child: ListTile(
        leading: VisaSvgIcon(
          semantics: false,
          assetPath: icon,
          width: AppSizes.dimMedium,
          height: AppSizes.heightTweentyFour,
          color: isSelected ? VisaColors.black : VisaColors.white,
        ),
        title: VisaTextView(
          text: label,
          colorTheme: VisaTextTheme.customTextColor,
          style: VisaTextStyle.displayBodyL,
          fontFamily: VisaFontWeight.medium,
          customColor: isSelected ? VisaColors.black : VisaColors.white,
          lineHeight: 1.07,
        ),
      ),
    );
  }

  /// Nav item without icon (bottom items)
  Widget _buildMenuNavItem(BuildContext context, String label, int index) {
    final isSelected = selectedIndex == index;
    final semanticsLabel =
        _getSemanticsLabel(context, label, index, isSelected, isMenu: true);

    return _buildNavTile(
      context: context,
      semanticsLabel: semanticsLabel,
      onTap: () => onItemSelected(index),
      isSelected: isSelected,
      child: ListTile(
        dense: true,
        title: VisaTextView(
          text: label,
          colorTheme: VisaTextTheme.customTextColor,
          style: VisaTextStyle.displayBodyL,
          fontSize: AppSizes.fifteen,
          fontFamily: VisaFontWeight.semibold,
          customColor: VisaColors.black,
          lineHeight: 1.07,
        ),
      ),
    );
  }

  /// Common tile builder with ink + rounded style + semantics
  Widget _buildNavTile({
    required BuildContext context,
    required String semanticsLabel,
    required VoidCallback onTap,
    required bool isSelected,
    required Widget child,
  }) {
    return VisaNavigationSemantics(
      label: semanticsLabel,
      child: InkWell(
        onTap: onTap,
        child: Container(
          margin: EdgeInsets.only(
            left: AppSizes.dimXSmall,
            top: AppSizes.heightTwo,
            bottom: AppSizes.heightTwo,
          ),
          decoration: BoxDecoration(
            color: isSelected ? VisaColors.white : VisaColors.transparent,
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(10),
              topLeft: Radius.circular(10),
            ),
          ),
          child: child,
        ),
      ),
    );
  }

  /// Semantics label logic
  String _getSemanticsLabel(
    BuildContext context,
    String label,
    int index,
    bool isSelected, {
    required bool isMenu,
  }) {
    final s = S.of(context);
    final status = isSelected ? s.selected : s.unselected;

    if (isMenu) {
      switch (index) {
        case AppRoutes.profileScreenIndex:
          return "${s.profile_tab}, $status";
        case AppRoutes.notificationScreenIndex:
          return "${s.notification_tab}, $status";
        case AppRoutes.evaHistoryScreenIndex:
          return "${s.eva_history_tab}, $status";
        case AppRoutes.faqScreenIndex:
          return "${s.faq_tab}, $status";
      }
    } else {
      switch (index) {
        case AppRoutes.homeScreenIndex:
          return "${s.home_tab}, $status";
        case AppRoutes.evaScreenIndex:
          return "${s.eva_tab}, $status";
        case AppRoutes.itineraryScreenIndex:
          return "${s.itinerary_tab}, $status";
        case AppRoutes.ticketScreenIndex:
          return "${s.tickets_tab}, $status";
      }
    }

    return "$label, $status"; // fallback
  }
}
