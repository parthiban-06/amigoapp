import 'dart:io';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:visaamigo/features/ai_assistant/screens/ai_assistant_getting_to_know_user_screens/ai_assistant_greeting_screen.dart';
import 'package:visaamigo/features/ai_assistant/screens/ai_assistant_getting_to_know_user_screens/ai_assistant_thanks_screen.dart';
import 'package:visaamigo/features/ai_assistant/screens/ai_prompt_personal_preferences_screens/ai_prompt_personal_preferences_screen.dart';
import 'package:visaamigo/features/biometric/screens/biometric_screen_android.dart';
import 'package:visaamigo/features/biometric/screens/biometric_screen_apple.dart';
import 'package:visaamigo/features/companion/screens/list_companion_screen.dart';
import 'package:visaamigo/features/companion_registration/view/companion_registration_view.dart';
import 'package:visaamigo/features/enable_mfa/screens/enable_mfa_code_view.dart';
import 'package:visaamigo/features/itinerary/screens/add_itinerary_screen.dart';
import 'package:visaamigo/features/itinerary/screens/itinerary_location_screen.dart';
import 'package:visaamigo/features/mfa/screens/mfa_screen.dart';
import 'package:visaamigo/features/notification/screens/notification_screen.dart';
import 'package:visaamigo/features/profile/screens/change_password_screen.dart';
import 'package:visaamigo/features/profile/screens/delete_account/confirm_delete_account_view.dart';
import 'package:visaamigo/features/profile/screens/delete_account/delete_account_view.dart';
import 'package:visaamigo/features/profile/screens/delete_account/deleted_account_view.dart';
import 'package:visaamigo/features/profile/screens/edit_profile_screen.dart';
import 'package:visaamigo/features/profile/screens/faq_screen.dart';
import 'package:visaamigo/features/profile/screens/profile_screen.dart';
import 'package:visaamigo/features/rate_us/screens/rate_us_screen.dart'
    show RateUs;
import 'package:visaamigo/features/redirecting/view/redirecting_view.dart';
import 'package:visaamigo/features/registered_email/screens/registered_email_screen.dart';
import 'package:visaamigo/features/wallet/model/wallet_model.dart';
import 'package:visaamigo/features/wallet/screens/wallet_leaving_visa_screen.dart';
import 'package:visaamigo/features/wallet/screens/wallet_prepaid_card_screen.dart';
import 'package:visaamigo/features/wallet/screens/wallet_screen.dart';
import 'package:visaamigo/features/wallet/screens/wallet_travel_credit_screen.dart';
import 'package:visaamigo/features/webview/screens/webview_screen.dart';
import 'package:visaamigo/utils/Inactive_session.dart';
import 'package:visaamigo/utils/amplify_service.dart';
import 'package:visaamigo/utils/utils.dart';

import '../analytics/firebase_analytics_observer.dart';
import '../analytics/firebase_analytics_service.dart';
import '../features/ai_assistant/screens/ai_assistant_chat_screens/ai_assistant_prompts_screen.dart';
import '../features/ai_assistant/screens/ai_assistant_chat_screens/ai_assistant_recent_queries_screen.dart';
import '../features/ai_assistant/screens/ai_assistant_chat_screens/ai_thread_list_screen.dart';
import '../features/ai_assistant/screens/ai_assistant_getting_to_know_user_screens/ai_assistant_common_steps_screen.dart';
import '../features/ai_assistant/screens/ai_assistant_getting_to_know_user_screens/ai_assistant_welcome_screen.dart';
import '../features/ai_assistant/screens/ai_history/ai_chat_history_screen.dart'
    show AiChatHistoryScreen;
import '../features/companion/model/list_companion.dart';
import '../features/companion/screens/add_companion_screen.dart';
import '../features/confirm_code/view/confirm_code_view.dart';
import '../features/confirm_forgot_pass_code/view/confirm_forgot_pass_code_view.dart';
import '../features/drawer/screen/drawer_screen.dart';
import '../features/forgot_pass/view/forgot_pass_view.dart';
import '../features/home/screens/animated_bottom_bar/animated_bottom_bar_view.dart';
import '../features/home/screens/eva_chat_screens/eva_detail_screen.dart';
import '../features/home/screens/home_main_screen.dart';
import '../features/home/screens/home_screens/home_detail_screen.dart';
import '../features/home/screens/home_screens/home_screen.dart';
import '../features/home/screens/itinerary_screens/itinerary_screen.dart';
import '../features/itinerary/models/event_list_model.dart';
import '../features/itinerary/screens/itinerary_home_screen.dart';
import '../features/itinerary/screens/widgets/widgets/itinerary_detail_screen.dart';
import '../features/login/view/login_view.dart';
import '../features/select_languages/providers/language_selection_generic_provider.dart';
import '../features/select_languages/screens/language_selection_screen.dart';
import '../features/signup/model/user_model.dart';
import '../features/signup/screens/signup_screen.dart';
import '../features/splash_screen/view/splash_screen_view.dart';
import '../features/tickets/screen/ticket_detail_screen.dart';
import 'app_routes_const.dart';

enum TransitionType {
  fade,
  scale,
  rotation,
  slideLeft,
  slideLeftToRight,
  slideRight,
  slideUp,
  slideDown,
  none, // Add the 'none' type to the enum
}

class AppRouter {
  // Add Firebase Analytics instance
  static late FirebaseAnalytics _analytics;
  static late FirebaseAnalyticsService _analyticsListener;

  // Initialize analytics (call this in your main.dart)
  static void initializeAnalytics(FirebaseAnalytics analytics) {
    _analytics = analytics;
    _analyticsListener = FirebaseAnalyticsService();
  }

  static CustomTransitionPage<void> buildPageWithAnimation<T>({
    required Widget child,
    required GoRouterState state,
    required BuildContext context,
    Duration duration = const Duration(
        milliseconds: 100), // add 100 instead of 300 for resolve Flashes issue
    TransitionType transitionType = TransitionType.fade,
  }) {
    final bool isRTL =
        Provider.of<SelectLanguageGenericProvider>(context).isRTL;

    return CustomTransitionPage<void>(
      key: state.pageKey,
      child: child,
      name: state.matchedLocation,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        switch (transitionType) {
          case TransitionType.fade:
          case TransitionType.slideLeft:
            return FadeTransition(opacity: animation, child: child);
          case TransitionType.scale:
            return ScaleTransition(scale: animation, child: child);
          case TransitionType.rotation:
            return RotationTransition(turns: animation, child: child);
          case TransitionType.slideLeftToRight:
            return !(isRTL)
                ? SlideTransition(
                    position: animation.drive(
                      Tween(begin: const Offset(1.0, 0.0), end: Offset.zero)
                          .chain(CurveTween(curve: Curves.easeInOut)),
                    ),
                    child: child,
                  )
                : SlideTransition(
                    position: animation.drive(
                      Tween(begin: const Offset(-1.0, 0.0), end: Offset.zero)
                          .chain(CurveTween(curve: Curves.easeInOut)),
                    ),
                    child: child,
                  );
          case TransitionType.slideRight:
            return !(isRTL)
                ? SlideTransition(
                    position: animation.drive(
                      Tween(begin: const Offset(1.0, 0.0), end: Offset.zero)
                          .chain(CurveTween(curve: Curves.easeInOut)),
                    ),
                    child: child,
                  )
                : SlideTransition(
                    position: animation.drive(
                      Tween(begin: const Offset(-1.0, 0.0), end: Offset.zero)
                          .chain(CurveTween(curve: Curves.easeInOut)),
                    ),
                    child: child,
                  );
          case TransitionType.slideUp:
            return SlideTransition(
              position: animation.drive(
                Tween(begin: const Offset(0.0, 1.0), end: Offset.zero)
                    .chain(CurveTween(curve: Curves.easeInOut)),
              ),
              child: child,
            );
          case TransitionType.slideDown:
            return SlideTransition(
              position: animation.drive(
                Tween(begin: const Offset(0.0, -1.0), end: Offset.zero)
                    .chain(CurveTween(curve: Curves.easeInOut)),
              ),
              child: child,
            );
          case TransitionType.none:
            return child;
        }
      },
    );
  }

  static GoRouter router = AppRouter.createRouter(
    navigatorKey: AmplifyService.navigatorKey,
    routes: [
      GoRoute(
        path: AppRoutes.initial,
        name: AppRoutes.initial,
        pageBuilder: (context, state) {
          var email = "";

          if (state.extra != null &&
              (state.extra is Map) &&
              (state.extra as Map).containsKey("email")) {
            email = (state.extra as Map)["email"]!;
          }

          return AppRouter.buildPageWithAnimation(
            child: SplashScreenView(email),
            state: state,
            context: context,
            transitionType: TransitionType.fade,
          );
        },
      ),
      GoRoute(
          path: AppRoutes.splashScreen,
          name: AppRoutes.splashScreen,
          pageBuilder: (context, state) {
            var email = "";

            if (state.extra != null &&
                (state.extra is Map) &&
                (state.extra as Map).containsKey("email")) {
              email = (state.extra as Map)["email"]!;
            }

            return AppRouter.buildPageWithAnimation(
              child: SplashScreenView(email),
              state: state,
              context: context,
              transitionType: TransitionType.fade,
            );
          }),
      GoRoute(
        path: AppRoutes.confirmForgotPassword,
        name: AppRoutes.confirmForgotPassword,
        pageBuilder: (context, state) => AppRouter.buildPageWithAnimation(
          child: const ConfirmForgotPassCodeView(),
          state: state,
          context: context,
          transitionType: TransitionType.slideLeft,
        ),
      ),
      GoRoute(
          path: AppRoutes.forgotPass,
          name: AppRoutes.forgotPass,
          pageBuilder: (context, state) => AppRouter.buildPageWithAnimation(
                child: const ForgotPassView(),
                state: state,
                context: context,
                transitionType: TransitionType.slideLeft,
              )),
      GoRoute(
          path: AppRoutes.aiAssistantCommonStepsScreen,
          name: AppRoutes.aiAssistantCommonStepsScreen,
          pageBuilder: (context, state) => AppRouter.buildPageWithAnimation(
                child: const AiAssistantCommonStepsScreen(),
                state: state,
                context: context,
                transitionType: TransitionType.slideUp,
              )),

      GoRoute(
          path: AppRoutes.registeredEmail,
          name: AppRoutes.registeredEmail,
          pageBuilder: (context, state) {
            var email = "";

            if (state.extra != null && (state.extra is String)) {
              email = (state.extra as String);
            }

            return AppRouter.buildPageWithAnimation(
              child: RegisteredEmail(email),
              state: state,
              context: context,
              transitionType: TransitionType.fade,
            );
          }),
      GoRoute(
          path: AppRoutes.mfa,
          name: AppRoutes.mfa,
          pageBuilder: (context, state) => AppRouter.buildPageWithAnimation(
                child: const MFAScreen(),
                state: state,
                context: context,
                transitionType: TransitionType.slideLeft,
              )),
      GoRoute(
          path: AppRoutes.addItineraryLocation,
          name: AppRoutes.addItineraryLocation,
          pageBuilder: (context, state) {
            String location = "";
            if (state.extra != null && (state.extra is String)) {
              location = (state.extra as String);
            }
            return AppRouter.buildPageWithAnimation(
              child: AddItineraryLocation(location),
              state: state,
              context: context,
              transitionType: TransitionType.slideLeftToRight,
            );
          }),
      GoRoute(
        path: AppRoutes.drawer,
        name: AppRoutes.drawer,
        pageBuilder: (context, state) => AppRouter.buildPageWithAnimation(
            child: const DrawerScreen(),
            state: state,
            context: context,
            transitionType: TransitionType.slideLeftToRight),
      ),
      GoRoute(
        path: AppRoutes.addCompanion,
        name: AppRoutes.addCompanion,
        pageBuilder: (context, state) => _buildCompanionPage(state, context),
      ),
      GoRoute(
        path: AppRoutes.editCompanion,
        name: AppRoutes.editCompanion,
        pageBuilder: (context, state) => _buildCompanionPage(state, context),
      ),
      GoRoute(
        path: AppRoutes.listCompanion,
        name: AppRoutes.listCompanion,
        pageBuilder: (context, state) => AppRouter.buildPageWithAnimation(
            child: const ListCompanionScreen(),
            state: state,
            context: context,
            transitionType: TransitionType.slideLeftToRight),
      ),
      GoRoute(
          path: AppRoutes.biometric,
          name: AppRoutes.biometric,
          pageBuilder: (context, state) => AppRouter.buildPageWithAnimation(
                child: Platform.isAndroid
                    ? const BiometricScreenAndroid()
                    : const BiometricScreenApple(),
                state: state,
                context: context,
                transitionType: TransitionType.slideLeft,
              )),
      GoRoute(
          path: AppRoutes.login,
          name: AppRoutes.login,
          pageBuilder: (context, state) {
            UserModel? userModel;

            if (state.extra != null && (state.extra is UserModel)) {
              userModel = (state.extra as UserModel);
            }

            return AppRouter.buildPageWithAnimation(
              child: LoginView(
                (state.extra is Map &&
                        (state.extra as Map).containsKey("userModel"))
                    ? (state.extra as Map)["userModel"]
                    : null,
                showBiometrics: (state.extra is Map &&
                        (state.extra as Map).containsKey("showBiometrics"))
                    ? (state.extra as Map)["showBiometrics"]
                    : null,
              ),
              state: state,
              context: context,
              transitionType: TransitionType.slideLeft,
            );
          }),
      GoRoute(
          path: AppRoutes.companion_registration,
          name: AppRoutes.companion_registration,
          pageBuilder: (context, state) => AppRouter.buildPageWithAnimation(
                child: const CompanionRegistrationView(),
                state: state,
                context: context,
                transitionType: TransitionType.slideLeft,
              )),
      GoRoute(
          path: AppRoutes.webView,
          name: AppRoutes.webView,
          pageBuilder: (context, state) => AppRouter.buildPageWithAnimation(
                child: WebViewScreen(
                  url: (state.extra as Map)["url"],
                  openWeb: (state.extra as Map)["openWeb"],
                  showVisaIcon: (state.extra as Map)["showVisaIcon"] ?? true,
                ),
                state: state,
                context: context,
                transitionType:
                    kIsWeb ? TransitionType.fade : TransitionType.slideUp,
              )),
      GoRoute(
          path: AppRoutes.redirecting,
          name: AppRoutes.redirecting,
          pageBuilder: (context, state) {
            FirebaseAnalyticsService.logEvent(
                eventName: AnalyticsEventConst.EVENT_NAME_EXIT_SCREENVIEWED,
                parameters: {
                  AnalyticsEventConst.PARAM_NAME_UI_ELEMENT_LOCATION:
                      FirebaseAnalyticsService.previousPage
                });
            return AppRouter.buildPageWithAnimation(
              child: RedirectingView(
                url: (state.extra is Map &&
                        (state.extra as Map).containsKey("url"))
                    ? (state.extra as Map)["url"]
                    : "",
                deeplink: (state.extra is Map &&
                        (state.extra as Map).containsKey("deeplink"))
                    ? (state.extra as Map)["deeplink"]
                    : "",
                openInternalBrowser: (state.extra is Map &&
                        (state.extra as Map).containsKey("openInternalBrowser"))
                    ? (state.extra as Map)["openInternalBrowser"]
                    : true,
                bottomMessage: (state.extra is Map &&
                        (state.extra as Map).containsKey("bottomMessage"))
                    ? (state.extra as Map)["bottomMessage"]
                    : "",
              ),
              state: state,
              context: context,
              transitionType: TransitionType.slideUp,
            );
          }),
      GoRoute(
          path: AppRoutes.animatedNavigationBar,
          name: AppRoutes.animatedNavigationBar,
          pageBuilder: (context, state) => AppRouter.buildPageWithAnimation(
                child: const AnimatedNavigationView(),
                state: state,
                context: context,
                transitionType: TransitionType.slideLeft,
              )),
      GoRoute(
          path: AppRoutes.signup,
          name: AppRoutes.signup,
          pageBuilder: (context, state) {
            UserModel? userModel;

            if (state.extra != null && (state.extra is UserModel)) {
              userModel = (state.extra as UserModel);
            }
            return AppRouter.buildPageWithAnimation(
              child: SignUpScreen(userModel),
              state: state,
              context: context,
              transitionType: TransitionType.slideLeft,
            );
          }),
      GoRoute(
          path: AppRoutes.confirmCode,
          name: AppRoutes.confirmCode,
          pageBuilder: (context, state) => AppRouter.buildPageWithAnimation(
                child: ConfirmCodeView((state.extra is UserModel)
                    ? state.extra as UserModel
                    : null),
                state: state,
                context: context,
                transitionType: TransitionType.slideLeft,
              )),
      if (!kIsWeb)
        GoRoute(
            path: AppRoutes.profilePage,
            name: AppRoutes.profilePage,
            pageBuilder: (context, state) => AppRouter.buildPageWithAnimation(
                  child: const ProfileView(),
                  state: state,
                  context: context,
                  transitionType: TransitionType.slideLeftToRight,
                )),
      GoRoute(
        path: AppRoutes.addItinerary,
        name: AppRoutes.addItinerary,
        pageBuilder: (context, state) =>
            _buildAddOrEditItineraryRoute(context, state, false),
      ),
      GoRoute(
        path: AppRoutes.editItinerary,
        name: AppRoutes.editItinerary,
        pageBuilder: (context, state) =>
            _buildAddOrEditItineraryRoute(context, state, true),
      ),
      if (!kIsWeb)
        GoRoute(
            path: AppRoutes.notification,
            name: AppRoutes.notification,
            pageBuilder: (context, state) => AppRouter.buildPageWithAnimation(
                  child: const NotificationScreen(),
                  state: state,
                  context: context,
                  transitionType: TransitionType.slideLeftToRight,
                )),
      GoRoute(
          path: AppRoutes.editProfile,
          name: AppRoutes.editProfile,
          pageBuilder: (context, state) => AppRouter.buildPageWithAnimation(
                child: const EditProfile(),
                state: state,
                context: context,
                transitionType: TransitionType.slideLeftToRight,
              )),
      GoRoute(
          path: AppRoutes.leavingVisaScreen,
          name: AppRoutes.leavingVisaScreen,
          pageBuilder: (context, state) {
            String url = "";
            if (state.extra != null && (state.extra is String)) {
              url = state.extra as String;
            }

            return AppRouter.buildPageWithAnimation(
              child: WalletLeavingVisaScreen(url),
              state: state,
              context: context,
              transitionType: TransitionType.slideLeftToRight,
            );
          }),
      GoRoute(
          path: AppRoutes.changePassword,
          name: AppRoutes.changePassword,
          pageBuilder: (context, state) => AppRouter.buildPageWithAnimation(
                child: const ChangePassword(),
                state: state,
                context: context,
                transitionType: TransitionType.slideLeftToRight,
              )),
      GoRoute(
          path: AppRoutes.rateUs,
          name: AppRoutes.rateUs,
          pageBuilder: (context, state) {
            int? stars;
            if (state.extra != null && (state.extra is int)) {
              // walletData = (state.extra as WalletData);
              stars = (state.extra as int);
            }
            return AppRouter.buildPageWithAnimation(
              child: RateUs(
                selectedStars: stars,
              ),
              state: state,
              context: context,
              transitionType: TransitionType.slideLeftToRight,
            );
          }),
      if (!kIsWeb)
        GoRoute(
            path: AppRoutes.faq,
            name: AppRoutes.faq,
            pageBuilder: (context, state) => AppRouter.buildPageWithAnimation(
                  child: const FaqScreen(),
                  state: state,
                  context: context,
                  transitionType: TransitionType.slideLeftToRight,
                )),

      GoRoute(
          path: AppRoutes.enableMfaCode,
          name: AppRoutes.enableMfaCode,
          pageBuilder: (context, state) => AppRouter.buildPageWithAnimation(
                child: const EnableMfaCodeView(),
                state: state,
                context: context,
                transitionType: TransitionType.slideUp,
              )),
      GoRoute(
        path: AppRoutes.languageSelection,
        name: AppRoutes.languageSelection,
        pageBuilder: _buildLanguageSelectionRoute,
      ),
      GoRoute(
        path: AppRoutes.changeLanguageSelection,
        name: AppRoutes.changeLanguageSelection,
        pageBuilder: _buildLanguageSelectionRoute,
      ),
      // This GoRoute navigates to the AiAssistantWelcomeScreen
      // The route uses a slideLeft transition animation while navigating to the screen.
      GoRoute(
          path: AppRoutes.aiAssistantWelcomeScreen,
          name: AppRoutes.aiAssistantWelcomeScreen,
          pageBuilder: (context, state) => AppRouter.buildPageWithAnimation(
                child: const AiAssistantWelcomeScreen(),
                state: state,
                context: context,
                transitionType: TransitionType.slideLeft,
              )),

      // This GoRoute navigates to the AiAssistantPromptsScreen
      // The route uses a slideLeft transition animation while navigating to the screen.
      GoRoute(
        path: AppRoutes.aiAssistantPromptsScreen,
        name: AppRoutes.aiAssistantPromptsScreen,
        pageBuilder: (context, state) => AppRouter.buildPageWithAnimation(
          child: const AiAssistantPromptsScreen(),
          state: state,
          context: context,
          transitionType: TransitionType.slideLeft,
        ),
      ),

      // This GoRoute navigates to the AiAssistantRecentQueriesScreen
      // The route uses a slideLeft transition animation while navigating to the screen.
      GoRoute(
        path: AppRoutes.aiAssistantRecentQueriesScreen,
        name: AppRoutes.aiAssistantRecentQueriesScreen,
        pageBuilder: (context, state) => AppRouter.buildPageWithAnimation(
          child: const AiAssistantRecentQueriesScreen(),
          state: state,
          context: context,
          transitionType: TransitionType.slideLeft,
        ),
      ),

      // This GoRoute navigates to the AiAssistantThanksScreen
      // The route uses a slideLeft transition animation while navigating to the screen.
      GoRoute(
        path: AppRoutes.aiAssistantThanksScreen,
        name: AppRoutes.aiAssistantThanksScreen,
        pageBuilder: (context, state) => AppRouter.buildPageWithAnimation(
          child: const AiAssistantThanksScreen(),
          state: state,
          context: context,
          transitionType: TransitionType.slideLeft,
        ),
      ),

      GoRoute(
        path: AppRoutes.aiAssistantGreetingScreen,
        name: AppRoutes.aiAssistantGreetingScreen,
        pageBuilder: (context, state) => AppRouter.buildPageWithAnimation(
          child: const AiAssistantGreetingScreen(),
          state: state,
          context: context,
          transitionType: TransitionType.slideLeft,
        ),
      ),
      // This GoRoute navigates to the AiPromptPersonalPreferencesScreen
      // The route uses a slideLeft transition animation while navigating to the screen.
      GoRoute(
        path: AppRoutes.personalPreferencesScreen,
        name: AppRoutes.personalPreferencesScreen,
        pageBuilder: (context, state) => AppRouter.buildPageWithAnimation(
          child: const AiPromptPersonalPreferencesScreen(),
          state: state,
          context: context,
          transitionType: TransitionType.slideUp,
        ),
      ),
      if (!kIsWeb)
        GoRoute(
          path: AppRoutes.evaChatHistory,
          name: AppRoutes.evaChatHistory,
          pageBuilder: (context, state) => AppRouter.buildPageWithAnimation(
            child: const AiChatHistoryScreen(),
            state: state,
            context: context,
            transitionType: TransitionType.slideLeftToRight,
          ),
        ),
      GoRoute(
          path: AppRoutes.deleteAccount,
          name: AppRoutes.deleteAccount,
          pageBuilder: (context, state) => AppRouter.buildPageWithAnimation(
                child: const DeleteAccountView(),
                state: state,
                context: context,
                transitionType: TransitionType.slideLeftToRight,
              )),

      GoRoute(
          path: AppRoutes.confirmDeleteAccount,
          name: AppRoutes.confirmDeleteAccount,
          pageBuilder: (context, state) => AppRouter.buildPageWithAnimation(
                child: const ConfirmDeleteAccountView(),
                state: state,
                context: context,
                transitionType: TransitionType.slideLeftToRight,
              )),
      GoRoute(
          path: AppRoutes.deletedAccount,
          name: AppRoutes.deletedAccount,
          pageBuilder: (context, state) => AppRouter.buildPageWithAnimation(
                child: const DeletedAccountView(),
                state: state,
                context: context,
                transitionType: TransitionType.slideLeftToRight,
              )),

      GoRoute(
          path: AppRoutes.appExtraOption,
          name: AppRoutes.appExtraOption,
          pageBuilder: (context, state) => AppRouter.buildPageWithAnimation(
                child: const ItineraryScreen(),
                state: state,
                context: context,
                transitionType: TransitionType.fade,
              )),

      GoRoute(
          path: AppRoutes.walletTravelCredit,
          name: AppRoutes.walletTravelCredit,
          pageBuilder: (context, state) {
            WalletData walletData;
            String index;

            walletData = (state.extra as Map)["wallet"];
            index = (state.extra as Map)["index"];
            return AppRouter.buildPageWithAnimation(
              child: WalletTravelCredit(
                walletData: walletData,
                index: index,
              ),
              state: state,
              context: context,
              transitionType: TransitionType.fade,
            );
          }),

      GoRoute(
          path: AppRoutes.walletPrepaidCard,
          name: AppRoutes.walletPrepaidCard,
          pageBuilder: (context, state) {
            WalletData walletData;
            String index;
            walletData = (state.extra as Map)["wallet"];
            index = (state.extra as Map)["index"];
            return AppRouter.buildPageWithAnimation(
              child: WalletPrepaidCardScreen(
                walletData: walletData,
                index: index,
              ),
              state: state,
              context: context,
              transitionType: TransitionType.fade,
            );
          }),

      // Stateful nested navigation based on:
      // https://github.com/flutter/packages/blob/main/packages/go_router/example/lib/stateful_shell_route.dart
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          // the UI shell
          return HomeMainScreen(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            navigatorKey: GlobalKey<NavigatorState>(),
            // ✅ Ensures each tab has an independent navigator

            routes: [
              // top route inside branch
              GoRoute(
                path: AppRoutes.homeNav,
                pageBuilder: (context, state) =>
                    AppRouter.buildPageWithAnimation(
                  child: const HomeScreen(),
                  state: state,
                  context: context,
                  transitionType: TransitionType.slideLeft,
                ),
                routes: [
                  GoRoute(
                    path: AppRoutes.wallet,
                    pageBuilder: (context, state) =>
                        AppRouter.buildPageWithAnimation(
                      child: const WalletScreen(),
                      state: state,
                      context: context,
                      transitionType: TransitionType.slideLeft,
                    ),
                  ),
                  GoRoute(
                      path: AppRoutes.walletTravelCredit,
                      pageBuilder: (context, state) {
                        WalletData walletData;
                        String index;

                        walletData = (state.extra as Map)["wallet"];
                        index = (state.extra as Map)["index"];
                        // if (state.extra != null && (state.extra is WalletData)) {
                        //
                        // }
                        return AppRouter.buildPageWithAnimation(
                          child: WalletTravelCredit(
                            walletData: walletData,
                            index: index,
                          ),
                          state: state,
                          context: context,
                          transitionType: TransitionType.fade,
                        );
                      }),
                  GoRoute(
                      path: AppRoutes.walletPrepaidCard,
                      pageBuilder: (context, state) {
                        WalletData walletData;
                        String index;
                        walletData = (state.extra as Map)["wallet"];
                        index = (state.extra as Map)["index"];
                        return AppRouter.buildPageWithAnimation(
                          child: WalletPrepaidCardScreen(
                            walletData: walletData,
                            index: index,
                          ),
                          state: state,
                          context: context,
                          transitionType: TransitionType.fade,
                        );
                      }),
                  GoRoute(
                      path: AppRoutes.homeDetails,
                      name: '${AppRoutes.homeNav}${AppRoutes.homeDetails}',
                      pageBuilder: (context, state) =>
                          AppRouter.buildPageWithAnimation(
                            child: const HomeDetailScreen(),
                            state: state,
                            context: context,
                            transitionType: TransitionType.slideLeft,
                          ),
                      routes: [
                        GoRoute(
                          path: AppRoutes.homeNestedDetails,
                          name:
                              '${AppRoutes.homeNav}${AppRoutes.homeDetails}${AppRoutes.homeNestedDetails}',
                          pageBuilder: (context, state) =>
                              AppRouter.buildPageWithAnimation(
                            child: const HomeDetailScreen(),
                            state: state,
                            context: context,
                            transitionType: TransitionType.slideLeft,
                          ),
                        ),
                      ]),
                  GoRoute(
                    path: AppRoutes.homeDetails2,
                    name: '${AppRoutes.homeNav}${AppRoutes.homeDetails2}',
                    pageBuilder: (context, state) =>
                        AppRouter.buildPageWithAnimation(
                      child: const HomeDetailScreen(),
                      state: state,
                      context: context,
                      transitionType: TransitionType.slideLeft,
                    ),
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: GlobalKey<NavigatorState>(),
            // ✅ Ensures each tab has an independent navigator

            routes: [
              // top route inside branch
              GoRoute(
                path: AppRoutes.evaNav,
                name: AppRoutes.evaNav,
                pageBuilder: (context, state) =>
                    AppRouter.buildPageWithAnimation(
                  child: const AiAssistantPromptsScreen(),
                  state: state,
                  context: context,
                  transitionType: TransitionType.none,
                ),
                routes: [
                  // child route
                  GoRoute(
                    path: AppRoutes.evaDetails,
                    name: '${AppRoutes.evaNav}${AppRoutes.evaDetails}',
                    pageBuilder: (context, state) =>
                        AppRouter.buildPageWithAnimation(
                      child: const EvaDetailScreen(),
                      state: state,
                      context: context,
                      transitionType: TransitionType.fade,
                    ),
                  ),

                  GoRoute(
                    path: AppRoutes.evaChatScreen,
                    name: '${AppRoutes.evaNav}${AppRoutes.evaChatScreen}',
                    pageBuilder: (context, state) {
                      var evaQuestion = "";
                      var location = "";
                      var section = "";
                      var sessionId = "";

                      Utils.logPrint("state.extra ${state.extra}");

                      if (state.extra != null && (state.extra is Map)) {
                        evaQuestion =
                            (state.extra as Map)["eva_question"] ?? "";
                        location = (state.extra as Map)["location"] ?? "";
                        section = (state.extra as Map)["section"] ?? "";
                        sessionId = (state.extra as Map)["sessionId"] ?? "";
                      } else if (state.extra is String) {
                        sessionId = (state.extra as String);
                      }

                      return AppRouter.buildPageWithAnimation(
                        child: AiChatScreen(
                            evaQuestion, location, section, sessionId),
                        state: state,
                        context: context,
                        transitionType: TransitionType.slideUp,
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: GlobalKey<NavigatorState>(),
            // ✅ Ensures each tab has an independent navigator

            routes: [
              // top route inside branch
              GoRoute(
                path: AppRoutes.itineraryNav,
                name: AppRoutes.itineraryNav,
                pageBuilder: (context, state) =>
                    AppRouter.buildPageWithAnimation(
                  child: const ItineraryHomeScreen(),
                  state: state,
                  context: context,
                  transitionType: TransitionType.slideLeft,
                ),
                routes: [
                  // child route
                  GoRoute(
                    path: AppRoutes.itineraryDetails,
                    name:
                        '${AppRoutes.itineraryNav}${AppRoutes.itineraryDetails}',
                    pageBuilder: (context, state) =>
                        AppRouter.buildPageWithAnimation(
                      child: ItineraryDetailScreen(state.extra as EventList?),
                      state: state,
                      context: context,
                      transitionType: TransitionType.slideUp,
                    ),
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: GlobalKey<NavigatorState>(),
            // ✅ Ensures each tab has an independent navigator
            routes: [
              // top route inside branch
              GoRoute(
                path: AppRoutes.ticketsNav,
                name: AppRoutes.ticketsNav,
                pageBuilder: (context, state) =>
                    AppRouter.buildPageWithAnimation(
                  child: const TicketDetailScreen(),
                  state: state,
                  context: context,
                  transitionType: TransitionType.slideLeft,
                ),
                routes: [
                  // child route
                  GoRoute(
                    path: AppRoutes.ticketsDetails,
                    name: '${AppRoutes.ticketsNav}${AppRoutes.ticketsDetails}',
                    pageBuilder: (context, state) =>
                        AppRouter.buildPageWithAnimation(
                      child: const TicketDetailScreen(),
                      state: state,
                      context: context,
                      transitionType: TransitionType.slideLeft,
                    ),
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: GlobalKey<NavigatorState>(),
            // ✅ Ensures each tab has an independent navigator

            routes: [
              // top route inside branch
              GoRoute(
                path: AppRoutes.profilePage,
                //name: AppRoutes.profilePage,
                pageBuilder: (context, state) =>
                    AppRouter.buildPageWithAnimation(
                  child: const ProfileView(),
                  state: state,
                  context: context,
                  transitionType: TransitionType.fade,
                ),
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: GlobalKey<NavigatorState>(),
            // ✅ Ensures each tab has an independent navigator

            routes: [
              // top route inside branch
              GoRoute(
                path: AppRoutes.notification,
                //name: AppRoutes.notification,
                pageBuilder: (context, state) =>
                    AppRouter.buildPageWithAnimation(
                  child: const NotificationScreen(),
                  state: state,
                  context: context,
                  transitionType: TransitionType.fade,
                ),
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: GlobalKey<NavigatorState>(),
            // ✅ Ensures each tab has an independent navigator

            routes: [
              // top route inside branch
              GoRoute(
                path: AppRoutes.evaChatHistory,
                //name: AppRoutes.evaChatHistory,
                pageBuilder: (context, state) =>
                    AppRouter.buildPageWithAnimation(
                  child: const AiChatHistoryScreen(),
                  state: state,
                  context: context,
                  transitionType: TransitionType.fade,
                ),
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: GlobalKey<NavigatorState>(),
            // ✅ Ensures each tab has an independent navigator

            routes: [
              // top route inside branch
              GoRoute(
                path: AppRoutes.faq,
                //name: AppRoutes.faq,
                pageBuilder: (context, state) =>
                    AppRouter.buildPageWithAnimation(
                  child: const FaqScreen(),
                  state: state,
                  context: context,
                  transitionType: TransitionType.fade,
                ),
              ),
            ],
          ),
        ],
      ),
    ],
    initialLocation: AppRoutes.splashScreen,
  );

  static GoRouter createRouter({
    required List<RouteBase> routes,
    String? initialLocation,
    void Function(String)? redirectLogic,
    GlobalKey<NavigatorState>? navigatorKey,
  }) {
    return GoRouter(
        routes: routes,
        initialLocation: initialLocation,
        debugLogDiagnostics: kDebugMode,
        navigatorKey: navigatorKey ?? GlobalKey<NavigatorState>(),
        observers: [
          FirebaseAnalyticsRouteObserver(analyticsListener: _analyticsListener),
        ],
        redirect: (context, state) {
          _logRouting(state);
          if (redirectLogic != null) {
            redirectLogic(state.uri.toString());
          }

          if (_analyticsListener != null) {
            // FirebaseAnalytics.instance.setAnalyticsCollectionEnabled(true);
            _analyticsListener.onRouteChanged(state.matchedLocation);
          }
          return null;
        },
        errorBuilder: (context, state) {
          // use a post frame callback to perform your navigation after
          // the build frame has finished
          if (_analytics != null) {
            _analytics.logEvent(
              name: 'navigation_error',
              parameters: {
                'error_route': state.uri.toString(),
                'error_type': 'route_not_found',
              },
            );
          }
          Utils.logPrint("errorBuilder ${state.uri}");
          WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
            router.go(AppRoutes.initial);
          });

          // you must return a widgets anyway
          return const SizedBox.shrink();
        });
  }

  static String currentRoute = "";
  static List<String> nonAuth = [
    AppRoutes.login,
    AppRoutes.registeredEmail,
    AppRoutes.signup,
    AppRoutes.forgotPass,
    AppRoutes.confirmForgotPassword,
    AppRoutes.confirmCode,
    AppRoutes.mfa,
    AppRoutes.biometric,
    AppRoutes.languageselection,
    AppRoutes.enableMfaCode
  ];

  static void _logRouting(GoRouterState state) {
    currentRoute = state.uri.path;
    if (AmplifyService.context != null && AmplifyService.context!.mounted) {
      Provider.of<InactivityService>(AmplifyService.context!, listen: false)
          .userInteraction(AmplifyService.context!);
    }
    if (kDebugMode) {
      debugPrint('🚀 Navigation: ${state.uri}');
      debugPrint('📍 Path: ${state.matchedLocation}');
      debugPrint('🔑 Params: ${state.pathParameters}');
      debugPrint('❓ Query: ${state.uri.queryParameters}');
      debugPrint('📦 Extra: ${state.extra}');
      debugPrint('🔄 Method: ${state.fullPath}');
      // debugPrint('🎯 Name: ${state.name}');
    }
  }

  static Page<dynamic> _buildLanguageSelectionRoute(
      BuildContext context, GoRouterState state) {
    var email = "";
    bool showBack = false;

    if (state.extra != null && state.extra is String) {
      email = state.extra as String;
    }

    if (state.extra != null &&
        state.extra is Map &&
        (state.extra as Map).containsKey("showBack")) {
      showBack = (state.extra as Map)["showBack"] == true;
    }

    return AppRouter.buildPageWithAnimation(
      child: LanguageSelectionScreen(email, showBack: showBack),
      state: state,
      context: context,
      transitionType:
          showBack ? TransitionType.slideLeftToRight : TransitionType.fade,
    );
  }

  static Page<dynamic> _buildAddOrEditItineraryRoute(
      BuildContext context, GoRouterState state, bool isEdit) {
    EventList? eventModel;
    String location = "";
    String date = "";

    if (state.extra != null && state.extra is EventList) {
      eventModel = state.extra as EventList;
    }

    if (state.extra != null && state.extra is String) {
      location = state.extra as String;
    }

    if (state.extra != null &&
        state.extra is Map &&
        (state.extra as Map).containsKey("date")) {
      date = (state.extra as Map)["date"];
    }

    return AppRouter.buildPageWithAnimation(
      child: AddItineraryScreen(
        eventModel: eventModel,
        location: location,
        dateTime: date,
      ),
      state: state,
      context: context,
      transitionType: TransitionType.slideUp,
    );
  }

  static Page<dynamic> _buildCompanionPage(
    GoRouterState state,
    BuildContext context,
  ) {
    CompanionProfile? userModel;

    if (state.extra != null && (state.extra is CompanionProfile)) {
      userModel = (state.extra as CompanionProfile);
    }

    return AppRouter.buildPageWithAnimation(
        child: AddCompanionScreen(
          companionProfile: userModel,
        ),
        state: state,
        context: context,
        transitionType: TransitionType.slideLeftToRight);
  }
}
