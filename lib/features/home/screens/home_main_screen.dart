import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:visaamigo/core/theme/theme.dart';
import 'package:visaamigo/features/home/providers/navigation_provider.dart';
import 'package:visaamigo/features/profile/provider/user_generic_detail_provider.dart';
import 'package:visaamigo/utils/responsive_util.dart';

import '../../../core/base/view/base_view.dart';
import '../../ai_assistant/screens/ai_assistant_chat_screens/widgets/ai_assistant_prompt_screen_tutorial_widget.dart';
import '../providers/main_screen_provider.dart';
import '../widgets/bottom_navigation_bar_widget.dart';
import 'home_main_web_screen.dart';
import 'home_screens/widgets/home_screen_tutorial_widget.dart';

class HomeMainScreen extends StatefulWidget {
  final StatefulNavigationShell navigationShell;

  const HomeMainScreen({
    super.key,
    required this.navigationShell,
  });

  @override
  State<HomeMainScreen> createState() => HomeMainScreenState();
}

class HomeMainScreenState extends State<HomeMainScreen> {
  late MainScreenProvider mainScreenProvider;

  @override
  void initState() {
    super.initState();
    mainScreenProvider = GetIt.I<MainScreenProvider>();
    // Initialize provider with navigation shell reference
    // Provider.of<NavigationProvider>(context, listen: false)
    //     .initialize(widgets.navigationShell);
  }

  @override
  Widget build(BuildContext context) {
    final responsive = Provider.of<ResponsiveUtil>(context, listen: false);
    // Set the shell in the provider
    Provider.of<NavigationProvider>(context, listen: false)
        .initialize(context, widget.navigationShell);
    Provider.of<UserGenericProvider>(context, listen: false)
        .setContext(context);
    Provider.of<UserGenericProvider>(context, listen: false).updateUserModel();
    return Stack(
      children: [
        BaseView<MainScreenProvider>(
          onlyDesktop: true,
          systemNavigationBarColor: VisaColors.primary,
          extendBodyBehindAppBar: false,
          addDefaultPadding: false,
          wrapWithSafeArea: false,
          onModelReady: (model) {
            model.checkUserLoginOnce(context);
          },
          viewModel: mainScreenProvider,
          buildBottomNavigationBar:
              (mainScreenProvider.isUserLogin && responsive.isMobileWebView) ||
                      responsive.isMobile(context: context)
                  ? const BottomNavigationBarWidget()
                  : null,
          onPageBuilderMobileView:
              (BuildContext context, MainScreenProvider viewModel) {
            // Show Main Content On Mobile View/Tablet View
            return widget.navigationShell;
          },
          drawer: mainScreenProvider.isUserLogin &&
                  responsive.kISWeb() &&
                  (responsive.isMobile(context: context) ||
                      responsive.isTablet(context: context))
              // Full Web View With Hamburger Icon For Web Only
              ? Drawer(
                  child: HomeMainWebScreen(
                    isFullDesktopView: false,
                    isUserLogin: mainScreenProvider.isUserLogin,
                  ),
                )
              : null,
          onPageBuilderDesktopView:
              (BuildContext context, MainScreenProvider viewModel) {
            // Full Desktop View
            return HomeMainWebScreen(
              isUserLogin: viewModel.isUserLogin,
            );
          },
        ),
        Consumer<NavigationProvider>(builder: (context, viewModel, child) {
          return viewModel.selectedIndex == 0
              ? const HomeScreenTutorialWidget()
              : viewModel.selectedIndex == 1
                  ? const AiAssistantPromptScreenTutorialWidget()
                  : const SizedBox.shrink();
        }),
      ],
    );
  }
}
