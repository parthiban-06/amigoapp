class AppConst {
  AppConst._();

  static const int TEXTFIELD_EMAIL_LENGTH = 256;
  static const int TEXTFIELD_GENERIC_LENGTH = 200;
  static const int TEXTFIELD_PASSWORD_LENGTH = 6;
  static const int TEXTFIELD_DEFAULT_LENGTH = 20;

  static const String AES_ENC_KEY = "AES_ENC_KEY";
  static const String AES_ENC_IV = "AES_ENC_IV";

  // AWS KEYS
  static const String AWS_USER_POOL_ID = "AWS_USER_POOL_ID";
  static const String AWS_USER_CLIENT_ID = "AWS_USER_CLIENT_ID";

  static const String APP_NAME = "APP_NAME";
  static const String APP_BASE_URL = "APP_BASE_URL";
  static const String PRIVACY_POLICY =
      "https://usa.visa.com/legal/global-privacy-notice.html";
  static const String TERMS_AND_CONDITIONS = "TERMS_AND_CONDITIONS";
  static const String PREFERRED_LANGUAGE = "preferred_language";
  static const String ITINERARY_TYPE_EVENT = "event";
  static const String ITINERARY_TYPE_MATCH = "match";
  static const String ITINERARY_CATEGORY_ACCOMMODATION = "accommodation";
  static const String ITINERARY_CATEGORY_ACTIVITY = "activity";
  static const String ITINERARY_CATEGORY_FOOD = "food_and_drink";
  static const String ITINERARY_CATEGORY_MISCELLANEOUS = "miscellaneous";
  static const String ITINERARY_CATEGORY_SIGHTSEEING = "sightseeing";
  static const String ITINERARY_CATEGORY_TRANSPORTATION = "transportation";
  static const String ITINERARY_CATEGORY_FLIGHT = "flights";

  // Privacy Policies URL's In Different Languages
  static const String privacyPolicyEN =
      "https://usa.visa.com/legal/global-privacy-notice.html"; //(English)
  static const String privacyPolicyZH =
      "https://www.visa.cn/legal/global-privacy-notice.html"; //(Chinese)
  static const String privacyPolicyJA =
      "https://www.visa.co.jp/legal/global-privacy-notice.html"; //(Japanese)
  static const String privacyPolicyKO =
      "https://www.visakorea.com/legal/global-privacy-notice.html"; //(Korean)
  static const String privacyPolicyAR =
      "https://ae.visamiddleeast.com/ar_AE/legal/global-privacy-notice.html"; //(Arabic)
  static const String privacyPolicyES =
      "https://www.visa.es/legal/global-privacy-notice.html"; //(Spanish)
  static const String privacyPolicyPT =
      "https://www.visa.pt/legal/global-privacy-notice.html"; //(Portuguese)
  static const String privacyPolicyFR =
      "https://www.visa.fr/legal/global-privacy-notice.html"; //(French)
  static const String privacyPolicyGR =
      "https://www.visa.de/legal/global-privacy-notice.html"; //(German)

  static const String appUrlAndroid =
      "https://play.google.com/store/apps/details?id=com.visa.eva";

  static const String appUrlIOS =
      "https://apps.apple.com/app/visa-airport-companion/id1079940624";

  static const String playStoreLink =
      "https://play.google.com/store/apps/details?id=com.visa.visamobileapp&pcampaignid=web_share";
  static const String appStoreLink =
      "https://apps.apple.com/by/app/visa-events/id1620609681";

  static const String bookingComLink = "https://www.booking.com/";
  static const String visaContactSupport =
      "https://www.visa.co.in/contact-us.html";

  static String bookingTnc(String langCode) =>
      "https://www.booking.com/content/terms.$langCode.html";

  static String evaGoogleLocation(
          String location, String languageCode, String key) =>
      "https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$location&types=(cities)&language=$languageCode&key=$key";

  static String ticketSupport(String langCode) {
    if (langCode != "zh") {
      return "https://www.fifa.com/$langCode";
    } else {
      return "https://www.fifa.com/en";
    }
  }

  static String bookingSupport(String langCode) =>
      "https://www.booking.com/customer-service.$langCode.html";

  static String prepaidSupport(String langCode) =>
      "https://dashsolutions.com/customer-service/#paycardform";

  // static const String FIFATicketURL = "https://www.fifa.com/"; //(English)
  // static const String FIFA_FAQ =
  //     "https://fifa.powerappsportals.com/en-US/qatar2022/";
  //
  // static const String FIFA_FAQ_TICKET =
  //     "https://fifa.powerappsportals.com/en-US/qatar2022/faq/category/?id=CAT-01074";
  //
  // static const String FIFA_FAQ_TICKET_INFO =
  //     "https://fifa.powerappsportals.com/en-US/qatar2022/faq/category/?id=CAT-01099"; //(English)

  static const Map<String, String> privacyPolicies = {
    'en': privacyPolicyEN,
    'es': privacyPolicyES,
    'zh': privacyPolicyZH,
    'ja': privacyPolicyJA,
    'ko': privacyPolicyKO,
    'pt': privacyPolicyPT,
    'de': privacyPolicyGR,
    'ar': privacyPolicyAR,
    'fr': privacyPolicyFR,
  };

  // API_GATEWAY_PATH
  static const String PATH_USER_PROFILE = "/items";

  // API_ENDPOINT
  static const String HEADER_AUTHORIZATION = "Authorization";
  static const String HEADER_BEARER = "Bearer";
  static const String HEADER_ACCESS_CONTROL_ALLOW_ORIGIN =
      "Access-Control-Allow-Origin";
  static const String HEADER_ACCESS_CONTROL_ALLOW_CREDENTIALS =
      "Access-Control-Allow-Credentials";

  static const String USER_SERVICE = "/user-service";
  static const String AI_SERVICE = "/ai-service";
  static const String ITINERARY_SERVICE = "/itinerary-service";
  static const String NOTIFICATION_SERVICE = "/notification-service";

  // USER SERVICES API\'s
  static const String USER_VALIDATION = "$USER_SERVICE/user-validation";
  static const String USER_PROFILES = "$USER_SERVICE/user-profiles";
  static const String USER_PREFERENCE = "$USER_SERVICE/user-preferences";
  static const String COMPANIONS = "$USER_SERVICE/users/companions";
  static const String COMPANIONS_RESEND_EMAIL =
      "$USER_SERVICE/users/companions/invite/resend?companion_id=";
  static const String MATCHES = "$ITINERARY_SERVICE/users/matches";
  static const String WALLET = "$USER_SERVICE/users/wallet";
  static const String EVENT = "$ITINERARY_SERVICE/users/custom-events";
  static const String EVENT_ITINERARIES =
      "$ITINERARY_SERVICE/users/itineraries";
  static const String FAQ = "$USER_SERVICE/users/faq?";
  static const String OPEN_FAQ = "$USER_SERVICE/users/open-faq?";
  static const String SEND_OTP_RESET_PASSWORD =
      "$USER_SERVICE/users/reset-password/send-otp";

  static const String VERIFY_OTP_FORGOT_PASSWORD =
      "$USER_SERVICE/users/reset-password/verify-otp";
  static const String USER_NOTIFICATIONS =
      "$NOTIFICATION_SERVICE/users/notifications";
  static const String APP_VERSION =
      "$NOTIFICATION_SERVICE/users/app-version?platform_key=";
  static const String USER_PREFERENCE_GET =
      "$USER_SERVICE/user-preferences/know-your-user";
  static const String getTeams = "$USER_SERVICE/teams";
  static const String userPreferences = "/user-preferences";
  static const String userType = "?update_type";
  static const String getPreferencesQuestions =
      "$USER_SERVICE$userPreferences/preference-questions";
  static const String updatePreferenceOption =
      "$USER_SERVICE$userPreferences$userType=preferences";
  static const String getUserPreferences = "$USER_SERVICE/user-preferences";
  static const String updateTeamsPreference =
      "$USER_SERVICE$userPreferences$userType=know_your_user";
  static const String deleteAccount = "$USER_SERVICE$users/delete";
  static const String authenticatePassword = "$USER_SERVICE$users/authenticate";
  static const String greetingScreenData = "$USER_PREFERENCE";
  static const String changeGreetingScreenData =
      "/user-service/user-preferences?update_type=personalization";
  static const String sendEmail = "$NOTIFICATION_SERVICE$users/send-email?";
  static const String emailType = "email_type=";
  static const String mfaUpdate = "mfa_update";
  static const String changePassword = "change_password";
  static const String prefLang = "&preferred_language=";

  // AI SERVICES API\'s
  static const String GET_MESSAGE = "$AI_SERVICE/messages";
  static const String GET_SESSION = "$AI_SERVICE/sessions";
  static const String submitMessageFeedback = "$AI_SERVICE/feedbacks";

  // Itinerary SERVICES API\'s
  static const String users = "/users";
  static const String getUserMatches = "$ITINERARY_SERVICE$users/matches";

  // Notification SERVICES API\'s
  static const String preferredLanguage = "?preferred_language=";
  static const String getTermAndConditions =
      "$USER_SERVICE$users/terms-and-conditions$preferredLanguage";

  //API_MESSAGE_KEY
  static const String VALID_USER =
      "valid_user"; //Present in Companion DB - new_user (Show signup page)
  static const String EXISTING_USER =
      "existing_user"; //Present in Companion DB - new_user (Show signup page)
  static const String NEW_USER =
      "new_user"; // Present in Companion DB OR in Orchstrate/GMR DB
  static const String CREATE_USER =
      "create_user"; // Present in Companion DB OR in Orchstrate/GMR DB
  static const String INVALID_USER = "invalid_user"; // NON Invite User
  static const String OK = "OK";

  static const String WALLET_DETAILS_RETREIVED =
      "wallet_details_retreived"; // WALLET_DETAILS_RETREIVED

  static const String invalidPassword = "invalid_pass";
  static const String userNotFound = "user_not_found";
  static const String userIsNotConfirmed = "user_is_not_confirmed";
  static const String primaryUser = "primary_user";
  static const String alreadyAdded = "already_added";
  static const String maxAttemptsExceeded = "max_attempts_exceeded";
  static const String self_companion_not_allowed = "self_companion_not_allowed";
  static const String copyUrl = "copy_url";
  static const String faqRetrieved = "faq_retrieved";
  static const String web = "web";
  static const String mobile = "mobile";
  static const String ios = "ios";
  static const String android = "android";
  static const String externalBrowser = "external_browser";
  static const String unknownAuthenticationError =
      "unknown_authentication_error";

// API CHAT RESPONSE KEYS
  static const String getTextKey = "text";
  static const String getTextKeyEva = "eva";
  static const String getTextKeyBookingFlights = "booking_flights";
  static const String getWeatherKey =
      "get_weather"; // Key is for handling response from api to handle weather related UI in the app
  static const String getSearchPlacesKey = "search_places";
  static const String bookingKey = "hotel_search";
  static const String flightKey = "booking_flights";
  static const String directionsKey = "directions";
  static const String assistant = "assistant";
  static const String llmError = "LLM error";
  static const String llmTimeOut = "LLM timeout";
  static const String eva = "EVA";
  static const String faqRetriever = "faq_retriever";

  static const String like = 'like';
  static const String dislike = 'dislike';
  static const String getWeatherSevenDayKey = "get_weather_seven_day";
  static const String RATE_US = "$USER_SERVICE/users/rate-us";
  static const String USER_CONFIG = "$USER_SERVICE/users/configs";

  // Faq's Url Keys
  static const String openAppStore = "openAppStore"; // URL
  static const String openPlayStore = "openPlayStore"; // URL
  static const String openContactVisa = "openContactVisa"; // URL
  static const String openVisaGO = "openVisaGO"; // URL
  static const String openResetPassword = "openResetPassword"; // InApp
  static const String openProfileBiometric = "openProfile/Biometric"; // InApp
  static const String openWallet = "openWallet"; // InApp
  static const String openFAQ = "openFAQ"; // InApp
  static const String openPrepaidCard = "openPrepaidCard"; // InApp
  static const String openEvaChat = "openEvaChat"; // InApp
  static const String openTicket = "openTicket"; // InApp
  static const String openCompanion = "openCompanion"; // InApp
  static const String openBookTravel = "openBookTravel"; // InApp
  static const String openBookingCom = "openBookingcom"; // URL
}
