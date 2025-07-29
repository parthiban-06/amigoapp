import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:visaamigo/core/base/view/base_view.dart';
import 'package:visaamigo/features/home/providers/animated_bottom_bar_provider.dart';
import 'package:visaamigo/utils/app_extensions.dart';

import 'animated_bottom_bar.dart';

class AnimatedNavigationView extends StatefulWidget {
  const AnimatedNavigationView({super.key});

  @override
  State<AnimatedNavigationView> createState() => _AnimatedNavigationViewState();
}

class _AnimatedNavigationViewState extends State<AnimatedNavigationView> {
  late AnimatedBottomBarProvider animatedBottomBarProvider;

  @override
  void initState() {
    super.initState();
    animatedBottomBarProvider = GetIt.I<AnimatedBottomBarProvider>();
  }

  @override
  Widget build(BuildContext context) {
    return BaseView<AnimatedBottomBarProvider>(
      viewModel: animatedBottomBarProvider,
      buildBottomNavigationBar: AnimatedBottomBar(
          iconSize: 28,
          selectedIndex: animatedBottomBarProvider.currentIndex,
          width: context.screenWidth - 20,
          items: animatedBottomBarProvider.navigationItems
              .map((item) => AnimatedBarItem(
                    icon: item.icon,
                    title: item.title,
                  ))
              .toList(),
          onItemSelected: animatedBottomBarProvider.setCurrentIndex),
      onPageBuilderMobileView: (context, viewModel) =>
          animatedBottomBarProvider.currentScreen,
    );
  }
}
