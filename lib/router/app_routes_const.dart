abstract class AppRoutes {
  // API Examples
  static const String getExample = "/get_example";
  static const String postExample = "/post_example";

  // Authentication & Onboarding Routes
  static const String signInScreen = "/sign_in";
  static const String initial = '/';
  static const String splashScreen = '/splash_screen';
  static const String languageSelection = '/language_selection';
  static const String changeLanguageSelection = '/change_language_selection';
  static const String login = '/login';
  static const String signup = '/signup';
  static const String confirmCode = '/confirm_code';
  static const String forgotPassword = '/forgot_password';
  static const String confirmForgotPassword = '/confirm_forgot_password';
  static const String registeredEmail = '/registered_email';
  static const String biometric = '/biometric';
  static const String mfa = '/mfa';
  static const String enableMfaCode = '/enable_mfa_code';

  // Companion & Registration Routes
  static const String companionRegistration = '/companion_registration';
  static const String addCompanion = '/add_companion';
  static const String editCompanion = '/edit_companion';
  static const String listCompanion = '/list_companion';

  // Navigation & Core App Routes
  static const String bottomBarHomePage = '/bottom_bar_home_page';
  static const String animatedNavigationBar = '/animated_navigation_bar';
  static const String drawer = '/drawer';
  static const String redirecting = '/redirecting';

  // Profile & Settings Routes
  static const String profile = '/profile';
  static const String profilePage = '/profile_page';
  static const String editProfile = '/edit_profile';
  static const String changePassword = '/change_password';
  static const String deleteAccount = '/delete_account';
  static const String confirmDeleteAccount = '/confirm_delete_account';
  static const String deletedAccount = '/deleted_account';
  static const String settings = '/settings';
  static const String faq = '/faq';
  static const String rateUs = '/rate_us';
  static const String notification = '/notification';

  // Wallet & Financial Routes
  static const String wallet = '/wallet';
  static const String walletTravelCredit = '/wallet_travel_credit';
  static const String walletPrepaidCard = '/wallet_prepaid_card';
  static const String leavingVisaScreen = '/leaving_visa_screen';

  // AI Assistant Routes
  static const String aiAssistantWelcomeScreen = "/ai_assistant_welcome_screen";
  static const String aiAssistantPromptsScreen = "/ai_assistant_prompts_screen";
  static const String aiAssistantGreetingScreen =
      "/ai_assistant_greeting_screen";
  static const String aiAssistantRecentQueriesScreen =
      "/ai_assistant_recent_queries_screen";
  static const String aiAssistantCommonStepsScreen =
      "/ai_assistant_common_steps_screen";
  static const String aiAssistantStepOneScreen =
      "/ai_assistant_step_one_screen";
  static const String aiAssistantStepTwoScreen =
      "/ai_assistant_step_two_screen";
  static const String aiAssistantStepThreeScreen =
      "/ai_assistant_step_three_screen";
  static const String aiAssistantThanksScreen = "/ai_assistant_thanks_screen";
  static const String evaChatHistory = "/eva_chat_history";
  static const String personalPreferencesScreen =
      "/personal_preferences_screen";

  // WebView Routes
  static const String webView = '/web_view';
  static const String inAppWebView = "/in_app_web_view";

  // StatefulShellRoute Navigation Routes
  static const String homeNav = "/home_nav";
  static const String homeDetails = "/home_details";
  static const String homeDetails2 = "/home_details_2";
  static const String homeNestedDetails = "/home_nested_details";

  // Home Navigation - Stacked Navigation From Home
  static const String homeNavDetails = "$homeNav$homeDetails";
  static const String homeNavDetails2 = "$homeNav$homeDetails2";

  static const String homeNestedWallet = "$homeNav$wallet";
  static const String homeNestedWalletTravelCredit =
      "$homeNav$walletTravelCredit";
  static const String homeNestedWalletPrepaidCredit =
      "$homeNav$walletPrepaidCard";
  static const String homeNestedWalletPrepaidCard =
      "$homeNav$walletPrepaidCard";
  static const String homeNavNestedDetails =
      "$homeNavDetails$homeNestedDetails";

  // EVA Navigation - Stacked Navigation From EVA
  static const String evaNav = "/eva_nav";
  static const String evaDetails = "/eva_details";
  static const String evaNavDetails = "$evaNav$evaDetails";
  static const String evaChatScreen = "/ai_assistant_threads_screen";
  static const String evaChatScreenNav = "$evaNav$evaChatScreen";
  static const String evaNavNestedWallet = "$evaNav$wallet";

  // Itinerary Navigation - Stacked Navigation From Itinerary
  // Itinerary & Travel Routes
  static const String addItinerary = '/add_itinerary';
  static const String editItinerary = '/edit_itinerary';
  static const String addItineraryLocation = '/add_itinerary_location';

  // static const String calendarScreen = '/calendar_screen';
  static const String itineraryNav = "/itinerary_nav";
  static const String itineraryDetails = "/itinerary_details";
  static const String itineraryNavNestedWallet = "$itineraryNav$wallet";
  static const String itineraryNavDetails = "$itineraryNav$itineraryDetails";
  static const String itineraryNavAddItinerary = "$itineraryNav$addItinerary";

  // Tickets Navigation - Stacked Navigation From Tickets
  static const String ticketsNav = "/tickets_nav";
  static const String ticketsDetails = "/tickets_details";
  static const String ticketsNavDetails = "$ticketsNav$ticketsDetails";
  static const String ticketsNavNestedWallet = "$ticketsNav$wallet";

  // Additional Routes
  static const String appExtraOption = "/app_extra_option";

  //dialog
  static const String dialogDeleteCompanion = "delete_companion_dialog";
  static const String dialogRateUs = "rate_us_dialog";
  static const String dialogWalletTravelCredit = "wallet_travel_credit_dialog";
  static const String dialogVisaItinerary = "visa_itinerary_dialog";

  // External Links
  static const String playStoreLink =
      "https://play.google.com/store/apps/details?id=com.visa.visamobileapp&pcampaignid=web_share";
  static const String appStoreLink =
      "https://apps.apple.com/by/app/visa-events/id1620609681";
  static const String bookingComLink = "https://www.booking.com/";
  static const String visaContactSupport =
      "https://www.visa.co.in/contact-us.html";

  // Screen Indices for Bottom Navigation
  static const int homeScreenIndex = 0;
  static const int evaScreenIndex = 1;
  static const int itineraryScreenIndex = 2;
  static const int ticketScreenIndex = 3;
  static const int profileScreenIndex = 4;
  static const int notificationScreenIndex = 5;
  static const int evaHistoryScreenIndex = 6;
  static const int faqScreenIndex = 7;

  @Deprecated('Use forgotPassword instead')
  static const String forgotPass = forgotPassword;

  @Deprecated('Use companionRegistration instead')
  static const String companion_registration = companionRegistration;

  @Deprecated('Use enableMfaCode instead')
  static const String enableMfaCodeView = enableMfaCode;

  @Deprecated('Use languageSelection instead')
  static const String languageselection = languageSelection;

  @Deprecated('Use signInScreen instead')
  static const String SIGN_IN_SCREEN = signInScreen;

  @Deprecated('Use inAppWebView instead')
  static const String inapp_web_view = inAppWebView;

  @Deprecated('Use homeScreenIndex instead')
  static const int HOME_SCREEN_INDEX = homeScreenIndex;

  @Deprecated('Use evaScreenIndex instead')
  static const int EVA_SCREEN_INDEX = evaScreenIndex;

  @Deprecated('Use itineraryScreenIndex instead')
  static const int ITINERARY_SCREEN_INDEX = itineraryScreenIndex;

  @Deprecated('Use ticketScreenIndex instead')
  static const int TICKET_SCREEN_INDEX = ticketScreenIndex;
}

// Optional: Create a route name mapping for Firebase Analytics
class RouteNames {
  // Clean route names for analytics (without leading slash and properly formatted)
  static const Map<String, String> analyticsNames = {
    AppRoutes.initial: 'home',
    AppRoutes.splashScreen: 'splash_screen',
    AppRoutes.login: 'login',
    AppRoutes.signup: 'signup',
    AppRoutes.confirmCode: 'confirm_code',
    AppRoutes.forgotPassword: 'forgot_password',
    AppRoutes.confirmForgotPassword: 'confirm_forgot_password',
    AppRoutes.registeredEmail: 'registered_email',
    AppRoutes.biometric: 'biometric_authentication',
    AppRoutes.mfa: 'multi_factor_authentication',
    AppRoutes.enableMfaCode: 'enable_mfa_code',
    AppRoutes.languageSelection: 'language_selection',
    AppRoutes.companionRegistration: 'companion_registration',
    AppRoutes.addCompanion: 'add_companion',
    AppRoutes.listCompanion: 'companion_list',
    AppRoutes.profile: 'user_profile',
    AppRoutes.profilePage: 'profile_page',
    AppRoutes.editProfile: 'edit_profile',
    AppRoutes.changePassword: 'change_password',
    AppRoutes.deleteAccount: 'delete_account',
    AppRoutes.confirmDeleteAccount: 'confirm_delete_account',
    AppRoutes.deletedAccount: 'account_deleted',
    AppRoutes.wallet: 'wallet',
    AppRoutes.walletTravelCredit: 'wallet_travel_credit',
    AppRoutes.walletPrepaidCard: 'wallet_prepaid_card',
    AppRoutes.addItinerary: 'add_itinerary',
    AppRoutes.addItineraryLocation: 'add_itinerary_location',
    AppRoutes.aiAssistantWelcomeScreen: 'ai_assistant_welcome',
    AppRoutes.aiAssistantPromptsScreen: 'ai_assistant_prompts',
    AppRoutes.aiAssistantGreetingScreen: 'ai_assistant_greeting',
    AppRoutes.aiAssistantRecentQueriesScreen: 'ai_assistant_recent_queries',
    AppRoutes.evaChatHistory: 'eva_chat_history',
    AppRoutes.personalPreferencesScreen: 'personal_preferences',
    AppRoutes.homeNav: 'home_tab',
    AppRoutes.evaNav: 'eva_tab',
    AppRoutes.itineraryNav: 'itinerary_tab',
    AppRoutes.ticketsNav: 'tickets_tab',
    AppRoutes.notification: 'notifications',
    AppRoutes.settings: 'settings',
    AppRoutes.faq: 'frequently_asked_questions',
    AppRoutes.rateUs: 'rate_app',
    AppRoutes.webView: 'web_view',
    AppRoutes.drawer: 'navigation_drawer',
    AppRoutes.aiAssistantCommonStepsScreen: "ai_assistant_step_one_screen",
  };

  // Get analytics-friendly name for a route
  static String getAnalyticsName(String route) {
    return analyticsNames[route] ?? _sanitizeRouteName(route);
  }

  // Fallback method to sanitize route names
  static String _sanitizeRouteName(String route) {
    return route
        .replaceFirst('/', '')
        .replaceAll('/', '_')
        .replaceAll(RegExp(r'[^a-zA-Z0-9_]'), '')
        .toLowerCase();
  }
}
