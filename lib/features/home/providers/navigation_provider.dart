import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:visaamigo/features/home/providers/tutorial_provider.dart';

import '../../../analytics/firebase_analytics_service.dart';
import '../../../generated/l10n.dart';
import '../../../router/app_router.dart';
import '../../../router/app_routes_const.dart';
import '../../../ui/base/base_provider.dart';
import '../../../utils/shared_preferences.dart';
import '../../../utils/utils.dart';
import '../../ai_assistant/providers/ai_assistant_prompts_screen_provider.dart';

class NavigationProvider extends BaseProvider {
  int selectedIndex = 0;
  late StatefulNavigationShell? navigationShell;

  List<ScrollController> tabScrollControllers = List.generate(
    4,
    (_) => ScrollController(),
  );

  void initialize(BuildContext context, StatefulNavigationShell shell) {
    Utils.logPrint("initialize StatefulNavigationShell");
    setContext(context);
    navigationShell = shell;
    selectedIndex = navigationShell!.currentIndex;
  }

  void triggerFirebaseEventBottomOption(int index) {
    var uiElement = "";
    switch (index) {
      case AppRoutes.homeScreenIndex:
        uiElement = AppRoutes.homeNav;
        break;
      case AppRoutes.evaScreenIndex:
        uiElement = AppRoutes.evaNav;

        FirebaseAnalyticsService.logEvent(
          eventName: AnalyticsEventConst.EVENT_NAME_EVAASSISTANT_OPENED,
          parameters: {
            AnalyticsEventConst.PARAM_NAME_UI_ELEMENT_LOCATION:
            "home_tab",
            AnalyticsEventConst.PARAM_NAME_UI_ELEMENT: AppRoutes.evaNav,
          },
        );
        FirebaseAnalyticsService.logEvent(
          eventName: AnalyticsEventConst.EVENT_NAME_EVAASSISTANT_SCREENVIEWED,
        );
        break;
      case AppRoutes.itineraryScreenIndex:
        uiElement = AppRoutes.itineraryNav;

        FirebaseAnalyticsService.logEvent(
          eventName: AnalyticsEventConst.EVENT_NAME_HOME_ITINERARY,
          parameters: {
            AnalyticsEventConst.PARAM_NAME_UI_ELEMENT_LOCATION: "home_tab",
            AnalyticsEventConst.PARAM_NAME_UI_ELEMENT: uiElement,
          },
        );

        break;
      case AppRoutes.ticketScreenIndex:
        uiElement = AppRoutes.ticketsNav;

        FirebaseAnalyticsService.logEvent(
          eventName: " ticketdetails_opened",
          parameters: {
            AnalyticsEventConst.PARAM_NAME_UI_ELEMENT: "ticket_details",
            AnalyticsEventConst.PARAM_NAME_UI_ELEMENT_LOCATION: "home_tab",
          },
        );

        final screenName = AppRoutes.ticketsDetails;
        FirebaseAnalyticsService.logEvent(
          eventName: " ticketdetails_screenview",
          screenName: screenName,
          parameters: {
            AnalyticsEventConst.PARAM_NAME_UI_ELEMENT_LOCATION: "home_tab"
          },
        );
        break;
    }

    FirebaseAnalyticsService.logEventButtonClick(btnName: uiElement);
  }

  void resetNavigationState() {
    Utils.logPrint("Resetting navigation state");
    // Reset selected index or any other navigation-related state
    selectedIndex = 0;
    // Reset navigation shell if needed
    navigationShell?.goBranch(0, initialLocation: true);
    // Reset tutorial or preferences if applicable
    Preferences.setBool(Preferences.isWelcomeScreenSet, false);
    setState(); // Notify listeners about the state change
  }

  Future<void> goBranch(int index,
      {bool loadInitial = false,
      bool showGreetingScreen = true,
      bool scolltoPosition = false}) async {
    Utils.logPrint(
        "goBranchIndex>>> $index , --- selectedIndex -- $selectedIndex");

    if (showGreetingScreen) {
      var isWelcomeScreenShown =
          await Preferences.getBool(Preferences.isWelcomeScreenSet);
      if (index == 1 && !isWelcomeScreenShown) {
        navPush(AppRoutes.aiAssistantGreetingScreen);
        return;
      }
      Utils.announceMessage(
          Utils.getSemanticsLabel(S.of(getContext()), index, true));
    } else {
      Preferences.setBool(Preferences.isWelcomeScreenSet, true);
    }

    // Prevent reloading the same screen
    if (index == 1) {
      GetIt.I<AiAssistantPromptsScreenProvider>().updatePrompts();
    }
    if (index == selectedIndex && !loadInitial) return;

    Utils.logPrint("initialize StatefulNavigationShell $navigationShell");

    navigationShell?.goBranch(
      index,
      initialLocation: index == selectedIndex,
    );

    Utils.logPrint("selectedIndex $index");
    selectedIndex = index;
    reStartTutorial();

    if (scolltoPosition) {
      scrollPositionToBottom(index);
    }

    setState();
  }

  // Function to check Greeting Screen Are Open Once when user click on
  // EVA Tab and it will visible again when restart the app
  Future<void> checkGreetingScreenOpen(int index) async {
    var isWelcomeScreenShown =
        await Preferences.getBool(Preferences.isWelcomeScreenSet);
    if (index == 1 && !isWelcomeScreenShown) {
      navPush(AppRoutes.aiAssistantGreetingScreen);
      return;
    }
  }

  void reStartTutorial() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (selectedIndex == 0) {
        bool isComeFromReWatchHomeTutorial = await Preferences.getBool(
            Preferences.isComeFromReWatchHomeTutorial);
        if (isComeFromReWatchHomeTutorial) {
          final tutorialProvider =
              Provider.of<TutorialProvider>(getContext(), listen: false);
          tutorialProvider
              .reStartHomeTutorial(tutorialProvider.getHomeShowCaseContext!);
        }
      } else if (selectedIndex == 1 &&
          AppRouter.currentRoute == AppRoutes.evaNav) {
        bool isComeFromReWatchEVATutorial =
            await Preferences.getBool(Preferences.isComeFromReWatchEVATutorial);
        if (isComeFromReWatchEVATutorial) {
          final tutorialProvider =
              Provider.of<TutorialProvider>(getContext(), listen: false);
          tutorialProvider
              .reStartEVATutorial(tutorialProvider.getEVAShowCaseContext!);
        }
      }
    });
  }

  void scrollPositionToBottom(int index) {
    final controller = tabScrollControllers[index];
    if (controller.hasClients) {
      controller.animateTo(
        0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }
}
