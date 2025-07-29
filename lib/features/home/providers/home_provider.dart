import 'dart:io';

import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify_flutter.dart' hide AnalyticsEvent;
import 'package:carousel_slider/carousel_controller.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:visaamigo/features/companion/model/list_companion.dart';
import 'package:visaamigo/features/home/model/match_details.dart';
import 'package:visaamigo/features/home/providers/tutorial_provider.dart';
import 'package:visaamigo/features/profile/provider/user_generic_detail_provider.dart';
import 'package:visaamigo/features/rate_us/model/user_visit_model.dart';
import 'package:visaamigo/features/rate_us/widgets/rateus_popup.dart';
import 'package:visaamigo/features/signup/model/user_model.dart';
import 'package:visaamigo/features/wallet/model/wallet_model.dart';
import 'package:visaamigo/utils/amplify_service.dart';
import 'package:visaamigo/utils/shared_preferences.dart';
import 'package:visaamigo/utils/utils.dart';

import '../../../analytics/firebase_analytics_service.dart';
import '../../../custom_widgets/snackbar.dart';
import '../../../custom_widgets/visa_snack_bar.dart';
import '../../../generated/assets.dart';
import '../../../generated/l10n.dart';
import '../../../router/app_router.dart';
import '../../../router/app_routes_const.dart';
import '../../../token_service.dart';
import '../../../ui/base/base_provider.dart';
import '../../../utils/app_const.dart';
import '../../../utils/date_util.dart';
import '../../../utils/firebase_background_handler.dart';
import '../../signup/model/user_config_model.dart';
import '../../splash_screen/repo/user_detail_repo.dart';

class HomeViewProvider extends BaseProvider {
  final UserDetailRepo userDetailRepo;
  final AmplifyAuthCognito? authPlugin;

  // poc code for cognito user data
  HomeViewProvider({required this.userDetailRepo, this.authPlugin});

  GlobalKey tutorialOneKey = GlobalKey();
  GlobalKey tutorialTwoKey = GlobalKey();
  GlobalKey tutorialThreeKey = GlobalKey();

  bool tutorialStatus = false;
  bool showHomePage = true;

  bool isVoucherFound = false;
  bool isPrePaidCardFound = false;

  // bool isBiometricsSetupProgress = false;
  WalletResponse? walletResponse;
  UserModel? userModel;
  MatchResponse? matchResponse;
  double appBarTotalHeight = 0.0;
  MatchData? closestMatch;
  bool iCompanion = false;
  bool isCompanion = false;
  List<WalletData> voucherList = [];

  UserGenericProvider? genericUserProvider;

  Future<void> init(BuildContext context) async {
    setContext(context);
    appBarTotalHeight = MediaQuery.paddingOf(context).top + kToolbarHeight;
    iCompanion = await Preferences.getBool(Preferences.isCompanion);

    isCompanion = await Preferences.getBool(Preferences.listCompanion);
    setState();

    try {
      // Capture context before async operations to avoid BuildContext across async gaps
      final capturedContext = context;
      genericUserProvider =
          Provider.of<UserGenericProvider>(capturedContext, listen: false);
      userModel = await Preferences.getModelData(
          Preferences.KeyUserModel, UserModel.fromJson);
      isLoading = true;
      // isBiometricsEnable();
      // await callconfigApi();

      addToTitle();
      await getAuth();
      checkMFA();

      if (capturedContext.mounted) {
        genericUserProvider?.setUserModel(userModel);
      }

      checkisUSerValid();
    } catch (e) {
      Utils.logPrint("init exception $e ");
    }

    // Capture context before async operations to avoid BuildContext across async gaps
    final capturedContext = getContext();
    final responses = await Future.wait(
      [
        callconfigApi(),
        walletApi(),
        matchApi(),
        getCompanion(),
        checkuser24hrsSetting(capturedContext)
      ],
    );

    if (capturedContext.mounted) {
      startHomeTutorial(capturedContext);
    }

    isLoading = false;

    await FirebaseAnalyticsService.setUserid(
        userID: userModel?.userAnalyticsId ?? "");
    await FirebaseAnalyticsService.setUserProperty(
        name: 'aws_user_id', value: userModel?.userAnalyticsId ?? "");

    FirebaseAnalyticsService.userAnalyticsId = userModel?.userAnalyticsId ?? "";

    //no loader require at home screen
    getMFA();
    getUserDetail();
    setupNotification();
    checkRateUs();
  }

  Future<void> getFirebaseToken() async {
    Utils.logPrint('notificationToken: getFirebaseToken');

    String? notificationToken = (Platform.isIOS)
        ? await TokenService.getFCMToken()
        : await FirebaseMessaging.instance.getToken();

    Utils.logPrint('notificationToken: $notificationToken');

    if (notificationToken != null && notificationToken.isNotEmpty) {
      //update notification to server

      if (userModel != null) {
        // Check if token already exists for any platform
        bool tokenExists = userModel!.registrationTokens
            .any((token) => token.token == notificationToken);

        if (!tokenExists) {
          // Determine platform
          String platform;
          if (Platform.isIOS) {
            platform = 'ios';
          } else if (Platform.isAndroid) {
            platform = 'android';
          } else {
            platform = 'web';
          }

          // Create new device registration token
          DeviceRegistrationToken newToken = DeviceRegistrationToken(
            platform: platform,
            token: notificationToken,
          );

          userModel!.registrationTokens.add(newToken);

          userDetailRepo.updateUserDetail(
              userModel!.toAwsJson(), UserModel.fromJson);
        }
      }
    }
  }

  void _getTokens() async {
    // Get FCM Token
    final fcmToken = await TokenService.getFCMToken();
    Utils.logPrint('FCM Token: $fcmToken');

    // Get APNS Token
    final apnsToken = await TokenService.getAPNSToken();
    Utils.logPrint('APNS Token: $apnsToken');

    // Get notification settings
    final settings = await TokenService.getNotificationSettings();
    Utils.logPrint('Notification Settings: $settings');
  }

  // Function to start home screen tutorial
  void startHomeTutorial(BuildContext context) {
    if (AppRouter.currentRoute == AppRoutes.homeNav) {
      final tutorialProvider =
          Provider.of<TutorialProvider>(context, listen: false);
      //Utils.logPrint('isVoucherFound>>${isVoucherFound}');
      //Utils.logPrint('isPrePaidCardFound>>${isPrePaidCardFound}');
      final bothCardsFound = isPrePaidCardFound && isVoucherFound;
      //Utils.logPrint('bothCardsFound>>${bothCardsFound}');
      //Utils.logPrint('iCompanion>>${iCompanion}');
      tutorialProvider.getHomeTutorialStatus(
        context,
        isComeFromHome: true,
        isCompanion: iCompanion,
        walletCardShow: !iCompanion,
        companionCardShow: !iCompanion,
        walletPrePaidCardShow: bothCardsFound ? false : isPrePaidCardFound,
        walletTravelCardShow: bothCardsFound ? false : isVoucherFound,
        walletBothCardShow: bothCardsFound,
      );
    }
  }

  // getTutorialStatus() async {
  //   tutorialStatus = await Preferences.getBool(Preferences.tutorialStatus);
  //   setState();
  //   if (!tutorialStatus) {
  //     ShowCaseWidget.of(getContext())
  //         .startShowCase([tutorialOneKey, tutorialTwoKey, tutorialThreeKey]);
  //   }
  // }
  //
  // closeTutorial() {
  //   ShowCaseWidget.of(getContext()).dismiss();
  //   tutorialStatus = true;
  //   setState();
  //   Preferences.setBool(Preferences.tutorialStatus, true);
  // }
  //
  // nextTutorial() {
  //   ShowCaseWidget.of(getContext()).next();
  //   setState();
  // }
  //
  // previousTutorial() {
  //   ShowCaseWidget.of(getContext()).previous();
  //   setState();
  // }
  String toTitleCase(String text) {
    return text
        .split(',')
        .map((segment) => segment
            .trim()
            .split(' ')
            .map((word) => word.isNotEmpty
                ? word[0].toUpperCase() + word.substring(1).toLowerCase()
                : '')
            .join(' '))
        .join(', ');
  }

  checkMFA() async {
    final bool mfa = await Preferences.getBool(Preferences.enableMfaTemp);
    if (mfa == true) {
      final cognitoPlugin =
          Amplify.Auth.getPlugin(AmplifyAuthCognito.pluginKey);
      await cognitoPlugin.updateMfaPreference(
          sms: MfaPreference.disabled, email: MfaPreference.enabled);
      await Preferences.setBool(Preferences.enableMfa, true);
      await Preferences.setBool(Preferences.enableMfaTemp, false);
    }
  }

  Future<void> checkRateUs() async {
    final rep =
        await userDetailRepo.getUserPreference2(UserVisitModel.fromJson);

    if (!_isValidResponse(rep)) {
      Utils.logPrint("checkRateUs: false");
      return;
    }

    final isRateUsSet = _isRateUsAlreadySet(rep);
    final isTutorialSet = _checkTutorialStatus(rep);

    if (isRateUsSet) {
      await _setRateUsPreference(true);
    }

    if (isTutorialSet) {
      await _setTutorialPreference(true);
    }

    if (!isRateUsSet) {
      await _setRateUsPreference(false);
    }

    if (!isTutorialSet) {
      await _setTutorialPreference(false);
    }

    await _processUserVisit(rep);
  }

  bool _isValidResponse(dynamic rep) {
    return rep.isSuccess && rep.data != null && rep.data!.data != null;
  }

  bool _isRateUsAlreadySet(dynamic rep) {
    return rep.data!.data!.rateUs != null &&
        rep.data!.data!.rateUs!.isNotEmpty &&
        rep.data!.data!.rateUs!.contains("true");
  }

  bool _checkTutorialStatus(dynamic rep) {
    return kIsWeb
        ? rep.data!.data!.tutorialWeb != null &&
            rep.data!.data!.tutorialWeb!.isNotEmpty &&
            rep.data!.data!.tutorialWeb!.contains("true")
        : rep.data!.data!.tutorialMobile != null &&
            rep.data!.data!.tutorialMobile!.isNotEmpty &&
            rep.data!.data!.tutorialMobile!.contains("true");
  }

  Future<void> _setRateUsPreference(bool value) async {
    await Preferences.setBool(Preferences.isRateUs, value);
  }

  Future<void> _setTutorialPreference(bool value) async {
    await Preferences.setBool(Preferences.tutorialStatus, value);
    await Preferences.setBool(Preferences.tutorialEvaScreenStatus, value);
  }

  Future<void> _processUserVisit(dynamic rep) async {
    final currentDate = _getCurrentDateString();

    if (_hasExistingUserVisits(rep)) {
      await _handleExistingUserVisits(rep, currentDate);
    } else {
      await _createNewUserVisit(currentDate);
    }
  }

  String _getCurrentDateString() {
    final DateTime dt = DateTime.now();
    return dt.year.toString() +
        "/" +
        dt.month.toString().padLeft(2, "0") +
        "/" +
        dt.day.toString().padLeft(2, "0");
  }

  bool _hasExistingUserVisits(dynamic rep) {
    return rep.data!.data!.userVisit != null &&
        rep.data!.data!.userVisit!.isNotEmpty;
  }

  Future<void> _handleExistingUserVisits(
      dynamic rep, String currentDate) async {
    List<String> userVisit = rep.data!.data!.userVisit ?? [];

    if (_isDateAlreadyVisited(userVisit, currentDate)) {
      return;
    }

    userVisit.add(currentDate);
    await _updateUserVisits(userVisit);
  }

  bool _isDateAlreadyVisited(List<String> userVisit, String currentDate) {
    return userVisit.contains(currentDate);
  }

  Future<void> _updateUserVisits(List<String> userVisit) async {
    if (_shouldShowRateUsPopup(userVisit)) {
      await _showRateUsPopup(userVisit);
    } else {
      await _updateUserVisitOnly(userVisit);
    }
  }

  bool _shouldShowRateUsPopup(List<String> userVisit) {
    return userVisit.length >= 4;
  }

  Future<void> _showRateUsPopup(List<String> userVisit) async {
    await _setRateUsPreference(true);
    await _updateUserPreferenceWithRateUs(userVisit);
    _displayRateUsPopup();
  }

  Future<void> _updateUserPreferenceWithRateUs(List<String> userVisit) async {
    await userDetailRepo.updateUserPreferenceKnowYourUser({
      "rate_us": ["true"],
      "user_visit": userVisit
    }, (json) => (), false);
  }

  void _displayRateUsPopup() {
    Utils.rateUsPopup(
        context: AmplifyService.context!, child: const RateUsPopup());
  }

  Future<void> _updateUserVisitOnly(List<String> userVisit) async {
    await userDetailRepo.updateUserPreferenceKnowYourUser(
        {"user_visit": userVisit}, (json) => (), false);
  }

  Future<void> _createNewUserVisit(String currentDate) async {
    await userDetailRepo.updateUserPreferenceKnowYourUser({
      "user_visit": [currentDate]
    }, (json) => (), false);
  }

  Future<void> getCompanion() async {
    final listCompanion =
        await userDetailRepo.listCompanion(CompanionListResponse.fromJson);
    if (listCompanion != null &&
        listCompanion.data != null &&
        listCompanion.data!.data != null &&
        listCompanion.data!.data!.isNotEmpty) {
      // await Preferences.setBool(Preferences.listCompanion, true);
      genericUserProvider?.updateCompanion(true);
      isCompanion = true;
      setState();
    } else {
      // await Preferences.setBool(Preferences.listCompanion, false);
      genericUserProvider?.updateCompanion(false);
      isCompanion = false;
      setState();
    }
  }

  Future<void> walletApi() async {
    try {
      if (genericUserProvider?.walletResponses == null) {
        final rep = await userDetailRepo.getWallet(WalletResponse.fromJson);

        if (_isValidWalletResponse(rep)) {
          await _processWalletSuccess(rep);
        } else {
          await _handleWalletFailure();
        }
      } else {
        walletResponse = genericUserProvider?.walletResponses;
        _processWalletItems();
        setState();
      }
    } catch (e) {
      Utils.logPrint("Error: $e");
    }
  }

  bool _isValidWalletResponse(dynamic rep) {
    return rep != null &&
        rep.data != null &&
        rep.data!.messageKey == AppConst.WALLET_DETAILS_RETREIVED;
  }

  Future<void> _processWalletSuccess(dynamic rep) async {
    await Preferences.setBool(Preferences.isWallet, true);
    walletResponse = rep.data;
    genericUserProvider?.walletResponse = walletResponse;

    _processWalletItems();
    setState();
  }

  void _processWalletItems() {
    for (int i = 0; i < walletResponse!.data.length; i++) {
      final item = walletResponse!.data[i];
      _processVoucherItem(item);
      _processCardDetection(item);
    }
  }

  void _processVoucherItem(dynamic item) {
    if (_isVoucherNotRedeemed(item)) {
      voucherList.add(item);
    }
  }

  bool _isVoucherNotRedeemed(dynamic item) {
    return item.voucher.voucherRedeemed == false;
  }

  void _processCardDetection(dynamic item) {
    if (_shouldCheckForCards()) {
      _detectVoucherCard(item);
      _detectPrepaidCard(item);
    }
  }

  bool _shouldCheckForCards() {
    return !isVoucherFound || !isPrePaidCardFound;
  }

  void _detectVoucherCard(dynamic item) {
    if (!isVoucherFound && _hasVoucherCode(item)) {
      isVoucherFound = true;
    }
  }

  bool _hasVoucherCode(dynamic item) {
    return item.voucher.voucherCode.isNotEmpty;
  }

  void _detectPrepaidCard(dynamic item) {
    if (!isPrePaidCardFound && _hasPrepaidToken(item)) {
      isPrePaidCardFound = true;
    }
  }

  bool _hasPrepaidToken(dynamic item) {
    return item.prepaidCard.provisioningToken.isNotEmpty;
  }

  Future<void> _handleWalletFailure() async {
    await Preferences.setBool(Preferences.isWallet, false);
  }

  Future<void> matchApi() async {
    try {
      if (genericUserProvider?.userMatchDetail == null) {
        final match = await userDetailRepo?.getMatches(
          MatchResponse.fromJson,
        );

        if (match != null && match.data != null) {
          matchResponse = match.data;
          closestMatch = getClosestDateIndex(matchResponse!.data);
          genericUserProvider?.userMatchDetail = matchResponse;
          setState();
        }
      } else {
        matchResponse = genericUserProvider?.userMatchDetail;
        closestMatch = getClosestDateIndex(matchResponse!.data);
      }
    } catch (e) {
      Utils.logPrint("Error: $e");
    }
  }

  MatchData? getClosestDateIndex(List<MatchData> dateTimes) {
    if (dateTimes.isEmpty) {
      return null;
    }

    DateTime now = DateTime.now();
    int closestIndex = 0;
    Duration smallestDifference = dateTimes[0].matchTime.difference(now).abs();

    for (int i = 1; i < dateTimes.length; i++) {
      Duration currentDifference = dateTimes[i].matchTime.difference(now).abs();
      if (currentDifference < smallestDifference) {
        smallestDifference = currentDifference;
        closestIndex = i;
      }
    }

    return dateTimes[closestIndex];
  }

  // poc code for cognito user data
  String myMFA = "select MFA";

  CarouselSliderController carouselControllerHomeTitle =
      CarouselSliderController();
  CarouselSliderController carouselControllerHomeBody =
      CarouselSliderController();

  List<HomeTitles> recentHomeTitlesFromJsonList(List<dynamic> data) {
    return List<HomeTitles>.from(data.map((item) => HomeTitles.fromJson(item)));
  }

  List<HomeTitles> homeTitle = [];
  List<List<Color>> homeTitleColor = [];

  addToTitle() async {
    homeTitle = recentHomeTitlesFromJsonList(
        await Utils.loadJson(Assets.jsonHomePageTitles));

    final context = getContext();
    if (context.mounted) {
      homeTitleColor.add([
        Theme.of(context).colorScheme.primary,
        Theme.of(context).colorScheme.primary
      ]);
      homeTitleColor.add([
        Theme.of(context).colorScheme.secondary,
        Theme.of(context).colorScheme.secondary
      ]);
      homeTitleColor.add([
        Theme.of(context).colorScheme.secondary,
        Theme.of(context).colorScheme.secondary
      ]);

      setState();
    }
  }

  onPrimaryTitleScroll(int inx) {
    carouselControllerHomeBody.animateToPage(inx);
    setState();
  }

  onSecondaryTitleScroll(int inx) {
    carouselControllerHomeTitle.animateToPage(inx);
    setState();
  }

  isBiometricsEnable() async {
    bool isBiometric = await Preferences.getBool(Preferences.enableBiometric);

    if (isBiometric) {
      final rep = await Utils.enableBioMetrics();
      if (!rep) {
        signOutButtonPressed();
      }
    }
  }

  //these are the cognito functions
  Future<void> getAuth() async {
    try {
      await amplifyService?.getCurrentUser();
    } catch (e) {
      Utils.logPrint('Error fetching session: $e');
    }
  }

  Future<void> getMFA() async {
    final cognitoPlugin =
        authPlugin ?? Amplify.Auth.getPlugin(AmplifyAuthCognito.pluginKey);

    final currentPreference = await cognitoPlugin.fetchMfaPreference();

    //poc code for cognito user data
    if (currentPreference.preferred.toString() != "null") {
      await Preferences.setBool(Preferences.enableMfa, true);
    } else {
      await Preferences.setBool(Preferences.enableMfa, false);
    }
  }

  Future<void> getCompanionScreen() async {
    final bool hasListCompanion = genericUserProvider?.listCompanion ?? false;

    final String uiElement =
        hasListCompanion ? "companion_details" : "add_companion";
    const String uiElementLocation = "home";

    if (!hasListCompanion) {
      FirebaseAnalyticsService.logEvent(
        eventName: "addYourCompanion_interaction",
        parameters: {
          AnalyticsEventConst.PARAM_NAME_UI_ELEMENT: uiElement,
          AnalyticsEventConst.PARAM_NAME_UI_ELEMENT_LOCATION: uiElementLocation,
        },
      );
    }

    final String route =
        hasListCompanion ? AppRoutes.listCompanion : AppRoutes.addCompanion;
    final dynamic rep = await navPush(route);

    if (hasListCompanion) {
      if (rep == false) {
        isCompanion = false;
        genericUserProvider?.updateCompanion(false);
        setState();
      }
    } else {
      if (rep == true) {
        isCompanion = true;
        genericUserProvider?.updateCompanion(true);
        setState();
      }
    }
  }

  void loadGreetingScreen() {
    navPush(AppRoutes.aiAssistantWelcomeScreen);
    // navPush(AppRoutes.evaChatHistory);
  }

  void copyToken() {
    Clipboard.setData(ClipboardData(
        text: amplifyService.authToken ?? "authToken is empty try again"));

    Utils.logPrint(amplifyService.authToken);
    /* VisaNativeDialog.show(
      title: S.of(mContext).enable_biometric,
      context: mContext,
      message: S.of(mContext).get_faster_access,
      positiveButtonText: S.of(mContext).enable,
      negativeButtonText: S.of(mContext).skip,
      barrierDismissible: true,
      closeDialogPositiveClick: false,
      onPositivePressed: () async {
        // Handle confirmation

        final rep = await Utils.enableBioMetrics();
        if (rep) {
          await Preferences.setBool(Preferences.enableBiometric, true);

          // await Preferences.setBool(
          //     Preferences.isBiometricsSetupProgress, true);
          navPop();
        }
      },
      onNegativePressed: () asyn {
        await Preferences.setBool(Preferences.enableBiometric, false);

        // await Preferences.setBool(
        //     Preferences.isBiometricsSetupProgress, true);
      },
    );*/

    // navGo(AppRoutes.aiAssistantWelcomeScreen);
  }

  void changeLanguage() {
    navPush(AppRoutes.languageselection);
  }

  setMFA(bool mfaStatus) async {
    isLoading = true;
    await Future.delayed(const Duration(seconds: 2));

    await amplifyService.setupMFA(mfaStatus);
    isLoading = false;
  }

  enableBiometrics() async {
    // Capture context before async operations to avoid BuildContext across async gaps
    final context = getContext();

    final rep = await Utils.enableBioMetrics();
    if (rep) {
      await Preferences.setBool(Preferences.enableBiometric, true);
      if (context.mounted) {
        snackBar(context, S.of(context).bioAuthSuccess);
      }
    } else {
      if (context.mounted) {
        snackBar(context, S.of(context).bioAuthFail);
      }
    }
  }

  removeBioMetrics() async {
    isLoading = true;
    await Future.delayed(const Duration(seconds: 2));

    await Preferences.removeKey(Preferences.enableBiometric);

    isLoading = false;
  }

  signOutButtonPressed() async {
    isLoading = true;

    Utils.logoutUser();
    // await amplifyService.signOutUser();
    isLoading = false;
  }

  void homeNavDetailsScreen() {
    navPush(AppRoutes.homeNavDetails);
  }

  void homeDetailsScreen() {
    navPush(AppRoutes.homeNestedDetails);
  }

  void homeDetailsScreen2() {
    navPush(AppRoutes.homeNavDetails2);
  }

  void homeNestedDetailsScreen() {
    navPush(AppRoutes.homeNavNestedDetails);
  }

  void evaNavDetailsScreen() {
    navPush(AppRoutes.evaNavDetails);
  }

  void evaDetailsScreen() {
    navPush(AppRoutes.evaChatScreenNav);
  }

  void itineraryNavDetailsScreen() {
    navPush(AppRoutes.itineraryNavDetails);
  }

  void itineraryDetailsScreen() {
    navPush(AppRoutes.itineraryDetails);
  }

  void ticketsNavDetailsScreen() {
    navPush(AppRoutes.ticketsNavDetails);
  }

  void ticketsDetailsScreen() {
    navPush(AppRoutes.ticketsDetails);
  }

  void openTicketDetailPage() {}

  void checkisUSerValid() async {
    if (userModel != null && userModel!.email != null) {
      var apiResponse = await userDetailRepo?.getIsValidUser(
          userModel!.email, UserModel.fromJson, AppConst.USER_VALIDATION);

      if (apiResponse != null && apiResponse.isSuccess) {
        switch (apiResponse.messageKey) {
          case AppConst.VALID_USER: // open Login PAGE
          case AppConst.EXISTING_USER: // open Login PAGE

            break;

          case AppConst.NEW_USER: // open signup page
          case AppConst.CREATE_USER:
          case AppConst.INVALID_USER:
// open signup page
            Utils.logoutUser();

            break;
        }
      } else {
        Utils.logoutUser();
      }
    } else {
      Utils.logoutUser();
    }
  }

  void getUserDetail() async {
    final apiResponse = await userDetailRepo?.getUserInfo(
        UserModel.fromJson, AppConst.USER_PROFILES);

    if (apiResponse != null &&
        apiResponse.isSuccess &&
        apiResponse.data != null) {
      userModel = apiResponse.data;
      var results = await Future.wait([
        amplifyService.getUserEmail(),
        amplifyService.getUserGivenName(),
        amplifyService.getUserFamilyName(),
      ]);

      iCompanion = apiResponse.data!.companion;

      userModel?.email = results[0] ?? "";
      userModel?.firstName = results[1] ?? "";
      userModel?.lastName = results[2] ?? "";

      genericUserProvider?.setUserModel(userModel);

      setState();
      Preferences.setModelData(Preferences.KeyUserModel, userModel!.toJson());
      Preferences.setBool(Preferences.isCompanion, iCompanion);
    } else {
      userModel = await Preferences.getModelData(
          Preferences.KeyUserModel, UserModel.fromJson);
    }
  }

  Future<void> setupNotification() async {
    // Capture context before async operations to avoid BuildContext across async gaps
    final context = getContext();

    //replace with config api
    /*   final rep = await userDetailRepo?.getNotifications(
      NotificationResponse.fromJson,
    );

    if (rep != null && rep.isSuccess && rep.data != null) {
      List<NotificationData>? notificationResponse = rep.data?.data;

      int readNotificationCount = notificationResponse
              ?.where((n) => !(n.read ?? false))
              .toList()
              .length ??
          0;

      if (context.mounted) {
        genericUserProvider?.readNotificationCount = readNotificationCount;
      }
    }*/

    TokenService.setupTokenListener(mContext);

    // Set up foreground notification callback AFTER setting up the listener
    TokenService.setForegroundNotificationCallback((notificationData) {
      Utils.logPrint(
          'Foreground notification received in home provider: $notificationData');

      // Extract notification information
      String title = 'Notification';
      String body = 'You have a new notification';

      // Try to extract title and body from the notification data
      if (notificationData.containsKey('aps')) {
        final aps = notificationData['aps'];
        if (aps is Map && aps.containsKey('alert')) {
          final alert = aps['alert'];
          if (alert is Map) {
            title = alert['title']?.toString() ?? title;
            body = alert['body']?.toString() ?? body;
          }
        }
      }

      // Handle foreground notification here
      // You can show a custom UI, update badge count, etc.
      if (context.mounted) {
        showVisaToast(
            context: context, title: title, subtitle: body, showAtTop: true);
      }
    });

    await Permission.notification.request();

    final settings = await FirebaseMessaging.instance.getNotificationSettings();

    bool isGranted =
        settings.authorizationStatus == AuthorizationStatus.authorized;

    Utils.logPrint(
        "iOS Notification permission status: ${settings.authorizationStatus}");

    // final isGranted = await Permission.notification.status.isGranted;

    if (!await Preferences.getBool(Preferences.isNotificationSetupProgress)) {
      Utils.logPrint("isNotificationSetupProgress");
      Preferences.setBool(
          Preferences.isNotificationPermissionEnable, isGranted);
      Preferences.setBool(Preferences.isNotificationSetupProgress, true);
    }

    Utils.logPrint("isNotificationSetupProgress isGranted ${isGranted}");

    if (isGranted) {
      getFirebaseToken();
    }

    if (context.mounted) {
      FirebaseNotificationHandler().initializeFirebaseMessaging(context);
    }
  }

  Future<void> checkuser24hrsSetting(BuildContext capturedContext) async {
    bool is24hrs = await Preferences.getBool(Preferences.KeyIs24Time);
    DateUtil.is24Time = is24hrs;
    if (capturedContext.mounted) {
      genericUserProvider?.is24hrsClockEnable = is24hrs;
    }
  }

  Future<void> callconfigApi() async {
    var response = await userDetailRepo.getUserConfig(UserConfigModel.fromJson);

    if (response != null && response.isSuccess && response.data != null) {
      genericUserProvider?.userConfigModel = response.data;
      genericUserProvider?.readNotificationCount =
          response.data?.unreadNotification ?? 0;

      setState();
    }
  }
}

class HomeTitles {
  final String title;
  final int type;
  final List<SubEvent> subTitle;

  HomeTitles({
    required this.title,
    required this.type,
    required this.subTitle,
  });

  factory HomeTitles.fromJson(Map<String, dynamic> json) {
    return HomeTitles(
      title: json['title'],
      type: json['type'],
      subTitle: (json['subTitle'] as List)
          .map((item) => SubEvent.fromJson(item))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'type': type,
      'subTitle': subTitle.map((item) => item.toJson()).toList(),
    };
  }
}

class SubEvent {
  final String name;
  final String title;
  final String subTitle;

  SubEvent({
    required this.name,
    required this.title,
    required this.subTitle,
  });

  // Factory method to create a SubEvent from JSON
  factory SubEvent.fromJson(Map<String, dynamic> json) {
    return SubEvent(
      name: json['name'],
      title: json['title'],
      subTitle: json['subTitle'],
    );
  }

  // Convert a SubEvent object to JSON
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'title': title,
      'subTitle': subTitle,
    };
  }
}
