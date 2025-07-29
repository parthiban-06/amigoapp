import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/navigation_provider.dart';
import '../widgets/web_navigation_drawer_widget.dart';

class HomeMainWebScreen extends StatelessWidget {
  final bool isFullDesktopView;
  final bool isUserLogin;

  const HomeMainWebScreen({
    super.key,
    this.isFullDesktopView = true,
    required this.isUserLogin,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<NavigationProvider>(builder: (context, viewModel, child) {
      return isFullDesktopView
          ? Row(
              children: [
                // Sidebar Navigation
                isUserLogin
                    ? _sideBarWidget(viewModel)
                    : const SizedBox.shrink(),

                // Main Content
                Expanded(
                  child: Container(
                    color: Colors.white, // Main content background
                    child: viewModel.navigationShell,
                  ),
                ),
              ],
            )
          : isUserLogin
              ? _sideBarWidget(viewModel)
              : const SizedBox.shrink();
    });
  }

  // Widget is for showing Sidebar Navigation
  Widget _sideBarWidget(NavigationProvider viewModel) {
    return WebNavigationDrawer(
      selectedIndex: viewModel.selectedIndex,
      onItemSelected: viewModel.goBranch,
    );
  }
}
