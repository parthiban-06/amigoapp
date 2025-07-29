import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:visaamigo/analytics/firebase_analytics_service.dart';
import 'package:visaamigo/app_initializer.dart';
import 'package:visaamigo/features/ai_assistant/providers/ai_assistant_greeting_provider.dart';
import 'package:visaamigo/features/ai_assistant/providers/ai_assistant_main_provider.dart';
import 'package:visaamigo/features/ai_assistant/providers/ai_assistant_prompts_screen_provider.dart';
import 'package:visaamigo/features/ai_assistant/providers/ai_assistant_threads_screen_provider.dart';
import 'package:visaamigo/features/ai_assistant/providers/ai_chat_provider.dart';
import 'package:visaamigo/features/home/providers/animated_bottom_bar_provider.dart';
import 'package:visaamigo/features/home/providers/navigation_provider.dart';
import 'package:visaamigo/features/home/providers/tutorial_provider.dart';
import 'package:visaamigo/features/itinerary/providers/itinerary_provider.dart';
import 'package:visaamigo/features/profile/provider/user_generic_detail_provider.dart';
import 'package:visaamigo/features/select_languages/providers/language_selection_generic_provider.dart';
import 'package:visaamigo/ui/provider/theme_provider.dart';
import 'package:visaamigo/ui/userdashboard/user_dashboard_provider.dart';
import 'package:visaamigo/utils/Inactive_session.dart';
import 'package:visaamigo/utils/app_extensions.dart';
import 'package:visaamigo/utils/connectivity_service.dart';
import 'package:visaamigo/utils/customSnackBar.dart';
import 'package:visaamigo/utils/responsive_util.dart';
import 'package:visaamigo/utils/startup_performance.dart';
import 'package:visaamigo/utils/utils.dart';

import 'core/theme/theme.dart';
import 'custom_widgets/loader/loading_provider.dart';
import 'custom_widgets/loader/loading_widget.dart';
import 'custom_widgets/permission/permission_provider.dart';
import 'custom_widgets/visa_no_scroll_behavior_web.dart';
import 'generated/l10n.dart';
import 'router/app_router.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  bool _isBackgroundHandlerRegistered = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    StartupPerformance.markMilestone('main_app_init_start');

    // Defer background handler registration to improve startup time
    WidgetsBinding.instance.addPostFrameCallback((_) {
      StartupPerformance.markMilestone('first_frame_rendered');
      _registerBackgroundHandler();
      StartupPerformance.markMilestone('background_handler_registered');
    });
  }

  void _registerBackgroundHandler() {
    if (!_isBackgroundHandlerRegistered) {
      // Register background handler after the first frame is rendered
      AppInitializer.registerBackgroundMessageHandler();
      _isBackgroundHandlerRegistered = true;
      Utils.logPrint('🚀 Background handler registered after app startup');
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      try {
        // Safely access router state to avoid web issues
        final routerState = AppRouter.router.state;
        final matchedLocation = routerState.matchedLocation;

        Utils.logPrintAnalytics(
            "didChangeAppLifecycleState with ${matchedLocation.isNullOrEmpty}");

        if (!matchedLocation.isNullOrEmpty) {
          FirebaseAnalyticsService.logEvent(
              eventName: AnalyticsEventConst.EVENT_NAME_APP_OPEN,
              parameters: {
                AnalyticsEventConst.PARAM_NAME_SOURCE_SCREEN: matchedLocation,
              });
        }
      } catch (e) {
        // Handle web-specific router state issues gracefully
        Utils.logPrint("Router state access error on web: $e");
        FirebaseAnalyticsService.logEvent(
            eventName: AnalyticsEventConst.EVENT_NAME_APP_OPEN,
            parameters: {
              AnalyticsEventConst.PARAM_NAME_SOURCE_SCREEN: "unknown",
            });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      enableScaleWH: () => kIsWeb ? false : true,
      useInheritedMediaQuery: true,
      builder: (_, child) {
        return MultiProvider(
            providers: [
              ChangeNotifierProvider(create: (_) => LoadingProvider()),
              ChangeNotifierProvider(create: (_) => UserDashboardProvider()),
              ChangeNotifierProvider(create: (_) => ThemeProvider()),
              ChangeNotifierProvider(create: (_) => UserGenericProvider()),
              ChangeNotifierProvider(create: (_) => PermissionProvider()),
              ChangeNotifierProvider(
                  create: (_) =>
                      SelectLanguageGenericProvider()..setContext(context)),
              ChangeNotifierProvider(
                  create: (context) => InactivityService(context)),
              ChangeNotifierProvider(
                  create: (_) => ResponsiveUtil(context)..setContext(context)),
              ChangeNotifierProvider(create: (_) => AiAssistantMainProvider()),
              ChangeNotifierProvider(
                  create: (_) => AiAssistantPromptsScreenProvider()),
              ChangeNotifierProvider(create: (_) => NavigationProvider()),
              ChangeNotifierProvider(create: (_) => ChatProvider()),
              ChangeNotifierProvider(create: (_) => TutorialProvider()),
              ChangeNotifierProvider(create: (_) => ItineraryProvider()),
              ChangeNotifierProvider(
                  create: (_) => AiAssistantThreadsScreenProvider()),
              ChangeNotifierProvider(
                  create: (_) => AnimatedBottomBarProvider()),
              ChangeNotifierProvider(create: (_) => ConnectivityService()),
              ChangeNotifierProvider(
                  create: (_) => AiAssistantGreetingProvider()),
            ],
            child: Consumer2<ThemeProvider, SelectLanguageGenericProvider>(
              builder: (context, themeProvider, languageProvider, child) {
                return GestureDetector(
                  onTap: () {
                    FocusManager.instance.primaryFocus?.unfocus();
                  },
                  child: MaterialApp.router(
                    scrollBehavior: VisaNoScrollBehaviorWeb(),
                    scaffoldMessengerKey: VisaSnackBar.scaffoldMessengerKey,
                    debugShowCheckedModeBanner: false,
                    locale: languageProvider.locale,
                    supportedLocales: S.delegate.supportedLocales,
                    localizationsDelegates: const [
                      S.delegate,
                      GlobalMaterialLocalizations.delegate,
                      GlobalWidgetsLocalizations.delegate,
                      GlobalCupertinoLocalizations.delegate,
                    ],
                    title: "Visa-DHE",
                    theme: VisaTheme.lightTheme,
                    darkTheme: VisaTheme.lightTheme,
                    themeMode: Provider.of<ThemeProvider>(context).themeMode,
                    routerConfig: AppRouter.router,
                    builder: (context, child) {
                      child = LoadingScreen.init()(context, child);
                      return Directionality(
                        textDirection: languageProvider.isRTL
                            ? TextDirection.rtl
                            : TextDirection.ltr,
                        child: child,
                      );
                    },
                  ),
                );
              },
            ));
      },
    );
  }
}
