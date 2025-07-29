import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:visaamigo/analytics/firebase_analytics_service.dart';
import 'package:visaamigo/ui/provider/theme_provider.dart';
import 'package:visaamigo/utils/theme_extension.dart';
import 'package:visaamigo/utils/utils.dart';

import '../../../core/theme/theme.dart';
import '../../../custom_widgets/visa_navigation_semantics.dart';
import '../../../custom_widgets/visa_svg_icon.dart';
import '../../../custom_widgets/visa_textview.dart';
import '../../../generated/assets.dart';
import '../../../generated/l10n.dart';
import '../../../router/app_routes_const.dart';
import '../../../utils/const_screen_size.dart';
import '../../../utils/test_style_util.dart';
import '../providers/navigation_provider.dart';

class BottomNavigationBarWidget extends StatelessWidget {
  const BottomNavigationBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return NavigationBarTheme(
      data: _buildNavigationBarTheme(context, themeProvider),
      child: Consumer<NavigationProvider>(
        builder: (context, viewModel, child) {
          return NavigationBar(
            selectedIndex: viewModel.selectedIndex,
            destinations: _buildDestinations(context, viewModel),
            onDestinationSelected: (index) =>
                _handleDestinationSelected(context, viewModel, index),
            backgroundColor: VisaColors.primary,
            indicatorColor: VisaColors.transparent,
            surfaceTintColor: Colors.transparent,
            indicatorShape: null,
            height: Sizes.eightyInt.h,
          );
        },
      ),
    );
  }

  NavigationBarThemeData _buildNavigationBarTheme(
      BuildContext context, ThemeProvider themeProvider) {
    return NavigationBarThemeData(
      labelTextStyle: _buildLabelTextStyle(context, themeProvider),
      iconTheme: _buildIconTheme(context),
    );
  }

  WidgetStateProperty<TextStyle> _buildLabelTextStyle(
      BuildContext context, ThemeProvider themeProvider) {
    return WidgetStateProperty.resolveWith<TextStyle>(
      (Set<WidgetState> states) {
        return VisaTextUtils.getVisaTextStyle(
          VisaTextStyle.displayBodyXs,
          fontFamily: VisaFontWeight.medium,
          context: context,
          letterSpacing: 0,
          lineHeight: 1.17,
          isDarkMode: !themeProvider.isDarkMode,
        );
      },
    );
  }

  WidgetStateProperty<IconThemeData> _buildIconTheme(BuildContext context) {
    return WidgetStateProperty.resolveWith<IconThemeData>(
      (Set<WidgetState> states) {
        if (states.contains(WidgetState.selected)) {
          return IconThemeData(color: context.theme.primaryColor);
        }
        return const IconThemeData(color: VisaColors.white);
      },
    );
  }

  List<Widget> _buildDestinations(
      BuildContext context, NavigationProvider viewModel) {
    final s = S.of(context);
    final iconHeight = 20.r;
    final iconWidth = 20.r;

    final labels = [s.home, s.eva, s.itinerary, s.tickets];
    final iconAssets = [
      Assets.iconsHome,
      Assets.iconsEva,
      Assets.iconsItinerary,
      Assets.iconsIcTicket,
    ];

    return List.generate(4, (index) {
      final isSelected = viewModel.selectedIndex == index;
      final semanticsLabel = Utils.getSemanticsLabel(s, index, isSelected);

      return VisaNavigationSemantics(
        label: semanticsLabel,
        child: NavigationDestination(
          label: labels[index],
          icon: _buildDestinationIcon(
              iconAssets[index], isSelected, iconHeight, iconWidth),
        ),
      );
    });
  }

  Widget _buildDestinationIcon(
      String assetPath, bool isSelected, double iconHeight, double iconWidth) {
    return Container(
      padding: const EdgeInsets.all(6).r,
      decoration: isSelected ? _getSelectedDecoration() : null,
      child: VisaSvgIcon(
        semantics: false,
        height: iconHeight,
        width: iconWidth,
        assetPath: assetPath,
      ),
    );
  }

  BoxDecoration _getSelectedDecoration() {
    return const BoxDecoration(
      shape: BoxShape.circle,
      color: VisaColors.white,
    );
  }

  void _handleDestinationSelected(
      BuildContext context, NavigationProvider viewModel, int index) {
    if (_isSameTabSelected(viewModel, index)) {
      _scrollToTop(viewModel, index);
    } else {
      _navigateToNewTab(context, viewModel, index);
    }
    viewModel.triggerFirebaseEventBottomOption(index);
  }

  bool _isSameTabSelected(NavigationProvider viewModel, int index) {
    return index == viewModel.selectedIndex;
  }

  void _scrollToTop(NavigationProvider viewModel, int index) {
    _handleHomeTabNavigation(viewModel, index);
    _animateScrollToTop(viewModel, index);
  }

  void _handleHomeTabNavigation(NavigationProvider viewModel, int index) {
    if (index != AppRoutes.homeScreenIndex) return;

    final previousPage = FirebaseAnalyticsService.previousPage;
    if (!_isWalletRelatedPage(previousPage)) return;

    viewModel.navPop();

    if (_requiresDoubleNavigation(previousPage)) {
      viewModel.navPop();
    }
  }

  bool _isWalletRelatedPage(String? previousPage) {
    if (previousPage == null) return false;

    return previousPage ==
            FirebaseAnalyticsService.cleanRoutePath(AppRoutes.wallet) ||
        previousPage == AppRoutes.homeNestedWalletTravelCredit ||
        previousPage == AppRoutes.walletPrepaidCard;
  }

  bool _requiresDoubleNavigation(String? previousPage) {
    if (previousPage == null) return false;

    return previousPage == AppRoutes.homeNestedWalletTravelCredit ||
        previousPage == AppRoutes.walletPrepaidCard;
  }

  void _animateScrollToTop(NavigationProvider viewModel, int index) {
    final controller = viewModel.tabScrollControllers[index];
    if (!controller.hasClients) return;

    controller.animateTo(
      0,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _navigateToNewTab(
      BuildContext context, NavigationProvider viewModel, int index) {
    viewModel.goBranch(index, loadInitial: true);
    viewModel.selectedIndex = index;
  }
}
