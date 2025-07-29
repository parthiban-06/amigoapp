import 'package:flutter/material.dart';
import 'package:visaamigo/features/home/screens/home_view.dart';
import 'package:visaamigo/ui/base/base_provider.dart';

import '../screens/animated_bottom_bar/animated_bottom_bar.dart';

class AnimatedBottomBarProvider extends BaseProvider {
  int _currentIndex = 0;

  int get currentIndex => _currentIndex;

  final List<AnimatedBarItem> _navigationItems = [
    AnimatedBarItem(
        icon: const Icon(Icons.home),
        title: const Text("home"),
        screen: const HomeView()),
    AnimatedBarItem(
        icon: const Icon(Icons.search),
        title: const Text("Search"),
        screen: const HomeView()),
    AnimatedBarItem(
        icon: const Icon(Icons.person),
        title: const Text("Person"),
        screen: const HomeView()),
    AnimatedBarItem(
        icon: const Icon(Icons.settings),
        title: const Text("Settings"),
        screen: const HomeView()),
  ];

  List<AnimatedBarItem> get navigationItems => _navigationItems;

  void setCurrentIndex(int index) {
    _currentIndex = index;
    notifyListeners();
  }

  Widget get currentScreen =>
      _navigationItems[_currentIndex].screen ??
      const Text("Something went wrong");
}
