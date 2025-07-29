import 'dart:math';

import 'package:carousel_slider/carousel_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart' show Provider;
import 'package:visaamigo/analytics/firebase_analytics_service.dart';
import 'package:visaamigo/features/ai_assistant/models/ai_prompt_model.dart';
import 'package:visaamigo/features/ai_assistant/repo/ai_assistant_repo.dart';
import 'package:visaamigo/features/ai_assistant/screens/ai_assistant_getting_to_know_user_screens/widgets/ai_assistant_bubble_widget.dart';
import 'package:visaamigo/features/ai_assistant/screens/ai_assistant_getting_to_know_user_screens/widgets/ai_assistant_smiley_widget.dart';
import 'package:visaamigo/features/ai_assistant/screens/ai_assistant_getting_to_know_user_screens/widgets/ai_assistant_teams_widget.dart';
import 'package:visaamigo/features/splash_screen/repo/user_detail_repo.dart';
import 'package:visaamigo/utils/app_extensions.dart';
import 'package:visaamigo/utils/const_screen_size.dart' show AppSizes;

import '../../../custom_widgets/visa_textview.dart';
import '../../../generated/assets.dart';
import '../../../generated/l10n.dart';
import '../../../router/app_routes_const.dart';
import '../../../ui/base/base_provider.dart';
import '../../../utils/shared_preferences.dart';
import '../../../utils/utils.dart';
import '../models/ai_bubble_appearance.dart';
import '../models/ai_excitement_steps_model.dart';
import '../models/ai_get_preferences_questions_model.dart';
import '../models/ai_goal_model.dart';
import '../models/ai_teams_new_model.dart';
import 'ai_assistant_prompts_screen_provider.dart';

class AiAssistantMainProvider extends BaseProvider {
  int currentPage = 0;
  int nextPage = 0;
  int teamSelectedIndex = 0;
  bool isAnimationFinished = true;
  bool isTextAnimationFinished = false;
  bool isGauageAnimationStart = false;
  bool hasUserInteracted = false;
  bool hasEmptyText = false;
  bool hasSearchNotMatched = false;

  double? selectedSize;
  double? normalSize;
  double? surroundingSize;
  double paddingCalculationOne = 0;
  double paddingCalculationThree = 0;
  double bubbleWidth = 0;

  List<String> selectedGoalAnalytics = [];

  void calculateBubbleSize() {
    // Utils.logPrint("mContext.screenWidt ${mContext.screenWidth}");

    bubbleWidth = (mContext.screenWidth - 60.r) / 2;
    surroundingSize = bubbleWidth * 0.55;
    normalSize = bubbleWidth * 0.8;
    selectedSize = bubbleWidth * 0.95;

    paddingCalculationOne = bubbleWidth * 0.1;
    paddingCalculationThree = bubbleWidth * 0.35;

    // Utils.logPrint(
    //     "${bubbleWidth}--normalSize -- ${normalSize} selectedSize -- ${selectedSize} -- ${surroundingSize}}");
    // Utils.logPrint("${paddingCalculationOne}-- ${paddingCalculationThree}");
  }

  void isGauageAnimation(bool value) {
    isGauageAnimationStart = value;
    setState();
  }

  void stopAnimationToDragPoint(double value) {
    // isGauageAnimationStart = value;
    // setState();
    volumeValue = getNearestStep(value); // Snap to nearest step
    if (volumeValue > 0.92) {
      volumeValue = 1.0;
    }

    gaugeAnimationController.value = volumeValue;
    setState();
  }

  String languageCode = "en";

  //<<--- Conditions For Testing App Config Case --->>
  // true,true,false Correct  (Step1>-1.0, Step2>-0.5) Checked
  // false,true,true Correct  (Step2>-0.5, Step3>-1.0) Checked
  // true,false,true Correct  (Step1>-1.0, Step3>-1.0) Checked
  // true,true,true  Correct  (Step1>-1.0, Step2>-0.5, Step3>-1.0) Checked
  // true,false,false Correct (Step1>-1.0) Checked
  // false,true,false Correct (Step2>-0.5) Checked
  // false,false,true Correct (Step3>-1.0) Checked
  // false,false,false

  //App Config Bool Values
  bool isStepOneScreenShow = true;
  bool isStepTwoScreenShow = true;
  bool isStepThreeScreenShow = true;
  bool isAllStepsEnabled = true;

  bool isAllStepsNavEnabled = true;

  bool showCancelButton = false;
  bool showShowBackgroundGradient = true;

  // For Steps Screens Animations Init\'s
  late AnimationController controller;
  late Animation<double> animation;
  late Animation<double> backgroundAnimation;

  // GlobalKey to reliably access the gauge's RenderBox
  final GlobalKey gaugeKey = GlobalKey();

  // For Circular Gauge Animations Init\'s
  late AnimationController gaugeAnimationController;
  double volumeValue = 0.0;
  int _currentStep = 0; // Tracks current step index
  double _gaugeValue = 0.0; // Tracks gauge pointer value

  List<double> gaugeStepper = [
    0.0,
    0.178,
    0.305,
    0.455,
    0.599,
    0.711,
    0.861,
    1.0
  ];

  double appBarTotalHeight = 0.0;

  // Mock Excitements List
  List<AiExcitementStepsModel>? listExcitements = [];
  UserDetailRepo? userDetailRepo;

  AiAssistantRepo? aiAssistantRepo;

  // Load Mock Suggestions From Json File
  Future<void> loadExcitementsListFromJsonFile() async {
    if (listExcitements == null || listExcitements!.isEmpty) {
      listExcitements =
          excitementFromJsonList(await Utils.loadJson(Assets.jsonSmileyTitles));
      // Add a delay before updating the state
      //await Future.delayed(const Duration(milliseconds: 300));
      setState();
    }
  }

  // Getter to dynamically filter widgets
  List<Widget> get pages {
    final List<Widget> filteredPages = [];

    if (isAllStepsEnabled) {
      filteredPages.addAll([
        const AiAssistantSmileyWidget(),
        const AiAssistantBubbleWidget(),
        const AiAssistantTeamsWidget(),
      ]);
    } else {
      if (isStepOneScreenShow) {
        filteredPages.add(const AiAssistantSmileyWidget());
      }
      if (isStepTwoScreenShow) {
        filteredPages.add(const AiAssistantBubbleWidget());
      }
      if (isStepThreeScreenShow) {
        filteredPages.add(const AiAssistantTeamsWidget());
      }
    }
    return filteredPages;
  }

  // Computed property to check if all steps are hidden
  bool get areAllStepsHidden =>
      !isStepOneScreenShow && !isStepTwoScreenShow && !isStepThreeScreenShow;

  // Computed property for whether to use SingleChildScrollView
  bool get shouldWrapWithScrollView =>
      !areAllStepsHidden &&
      ((isAllStepsEnabled && currentPage == 1) ||
          (isStepOneScreenShow &&
              isStepTwoScreenShow &&
              isStepThreeScreenShow &&
              currentPage == 1) ||
          (isStepOneScreenShow &&
              isStepTwoScreenShow &&
              !isStepThreeScreenShow &&
              currentPage == 1) ||
          (!isStepOneScreenShow &&
              isStepTwoScreenShow &&
              isStepThreeScreenShow &&
              currentPage == 0) ||
          (!isStepOneScreenShow &&
              isStepTwoScreenShow &&
              !isStepThreeScreenShow &&
              currentPage == 0));

  // Function to change page text as per pageIndex Changed
  String getStepText(BuildContext context, int pageIndex) {
    final s = S.of(context);

    int currentStep = pageIndex + 1; // Dynamic step index

    // Ensure animation is finished before showing text
    if (!isAnimationFinished) return '';

    // If all steps are enabled, consider all steps as visible
    if (isAllStepsEnabled) {
      isStepOneScreenShow = true;
      isStepTwoScreenShow = true;
      isStepThreeScreenShow = true;
    }

    // **Ensure currentStep is properly indexed**
    int adjustedStep = currentStep - 1; // Convert to 0-based index if needed

    // **Dynamically map visible steps**
    List<String> availableTexts = [];
    if (isStepOneScreenShow) availableTexts.add(s.how_excited);
    if (isStepTwoScreenShow) availableTexts.add(s.goal_of_trip);
    if (isStepThreeScreenShow) availableTexts.add(s.team_want_for_fifa);

    // **Ensure `adjustedStep` is within range**
    if (adjustedStep >= 0 && adjustedStep < availableTexts.length) {
      return availableTexts[adjustedStep]; // Safe access
    }

    return ''; // Default fallback if nothing matches
  }

  // Function to change bottom steps page text as per pageIndex Changed
  String getStepTextBottom(BuildContext context, int pageIndex) {
    // var aiAssistantProvider = Provider.of<AiAssistantMainProvider>(context);
    // bool isDesktop = aiAssistantProvider.isDesktopView;
    final s = S.of(context);
    int currentStep = pageIndex + 1; // Dynamic step index

    // Ensure animation is finished before showing text
    if (!isAnimationFinished) return '';

    // If all steps are enabled, consider all steps as visible
    if (isAllStepsEnabled) {
      isStepOneScreenShow = true;
      isStepTwoScreenShow = true;
      isStepThreeScreenShow = true;
    }

    // **Ensure currentStep is properly indexed**
    int adjustedStep = currentStep - 1; // Convert to 0-based index if needed

    // **Dynamically map visible steps**
    List<String> availableTexts = [];
    if (isStepOneScreenShow) {
      availableTexts.add(s.tap_or_drag_make_selection);
    }
    if (isStepTwoScreenShow) availableTexts.add(s.select_all_the_interest_you);
    if (isStepThreeScreenShow) availableTexts.add('');

    // **Ensure `adjustedStep` is within range**
    if (adjustedStep >= 0 && adjustedStep < availableTexts.length) {
      return availableTexts[adjustedStep]; // Safe access
    }

    return ''; // Default fallback if nothing matches
  }

  // Function to Get Background Alignment When Page Changed
  Alignment getBackgroundAlignment(int pageIndex, bool isKeyboardVisible) {
    if (isKeyboardVisible) {
      return const Alignment(0, 0.54);
    }

    final yAlignment = _getYAlignmentForPage(pageIndex);
    return Alignment(0, yAlignment);
  }

  double _getYAlignmentForPage(int pageIndex) {
    const double yStep1 = -1.0; // Fixed for Step 1 (Yellow Top)
    const double yStep2 = -0.5; // Fixed for Step 2 (Blue)
    const double yStep3 =
        0.42; // Updated: Step 3 has its new position (Yellow Top)

    if (_isAllStepsEnabled()) {
      return _getYAlignmentForAllSteps(pageIndex, yStep1, yStep2, yStep3);
    } else if (_isStepOneAndTwoVisible()) {
      return _getYAlignmentForStepOneAndTwo(pageIndex, yStep1, yStep2);
    } else if (_isStepTwoAndThreeVisible()) {
      return _getYAlignmentForStepTwoAndThree(pageIndex, yStep2, yStep3);
    } else if (_isOnlyStepTwoVisible()) {
      return yStep2;
    } else if (_isStepOneAndThreeVisible()) {
      return _getYAlignmentForStepOneAndThree(pageIndex, yStep1, yStep3);
    }

    return yStep1; // Default fallback
  }

  bool _isAllStepsEnabled() {
    return isAllStepsEnabled ||
        (isStepOneScreenShow && isStepTwoScreenShow && isStepThreeScreenShow);
  }

  bool _isStepOneAndTwoVisible() {
    return isStepOneScreenShow && isStepTwoScreenShow && !isStepThreeScreenShow;
  }

  bool _isStepTwoAndThreeVisible() {
    return !isStepOneScreenShow && isStepTwoScreenShow && isStepThreeScreenShow;
  }

  bool _isOnlyStepTwoVisible() {
    return !isStepOneScreenShow &&
        isStepTwoScreenShow &&
        !isStepThreeScreenShow;
  }

  bool _isStepOneAndThreeVisible() {
    return isStepOneScreenShow && !isStepTwoScreenShow && isStepThreeScreenShow;
  }

  double _getYAlignmentForAllSteps(
      int pageIndex, double yStep1, double yStep2, double yStep3) {
    switch (pageIndex) {
      case 0:
        return yStep1;
      case 1:
        return yStep2;
      case 2:
        return yStep3;
      default:
        return yStep1;
    }
  }

  double _getYAlignmentForStepOneAndTwo(
      int pageIndex, double yStep1, double yStep2) {
    return pageIndex == 0 ? yStep1 : yStep2;
  }

  double _getYAlignmentForStepTwoAndThree(
      int pageIndex, double yStep2, double yStep3) {
    return pageIndex == 0 ? yStep2 : yStep3;
  }

  double _getYAlignmentForStepOneAndThree(
      int pageIndex, double yStep1, double yStep3) {
    return pageIndex == 0 ? yStep1 : yStep3;
  }

  // Initialize Method
  void init(TickerProvider tickerProvider) async {
    appBarTotalHeight = MediaQuery.paddingOf(mContext).top + kToolbarHeight;
    currentPage = 0;
    nextPage = 0;
    controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: tickerProvider,
    );

    animation = CurvedAnimation(
      parent: controller,
      curve: Curves.easeInOutCubic,
    );

    backgroundAnimation = CurvedAnimation(
      parent: controller,
      curve: Curves.easeInOutCubic,
    );

    controller.addStatusListener((status) {
      if (status == AnimationStatus.completed ||
          status == AnimationStatus.dismissed) {
        isAnimationFinished = true;
      } else if (status == AnimationStatus.forward) {
        isAnimationFinished = false;
      }
    });

    nextPage = currentPage;

    userDetailRepo = UserDetailRepo(apiClient);

    // Circular Gauge AnimationController Init\'s
    initializeGaugeAnimationController(tickerProvider);

    await loadPromptsListFromJsonFile();
    initializeShadowControllers(tickerProvider);

    languageCode = await Preferences.getString(Preferences.keyLanguageCode);

    final val = await Preferences.getBool(Preferences.isGettingToKnowNavigation);
    FirebaseAnalyticsService.previousPage = AppRoutes.aiAssistantGreetingScreen;
    FirebaseAnalyticsService.logEvent(eventName: "gtkystep1_screenview",
      parameters: {
        AnalyticsEventConst.PARAM_NAME_UI_ELEMENT_LOCATION: val ? "profile" : "registration"
      },);
  }

  void initializeGaugeAnimationController(TickerProvider tickerProvider) {
    volumeValue = 0.0;
    gaugeAnimationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: tickerProvider,
      value: 0.0,
    );
  }

  promptGroups(List<AiGoalModel> items) async {
    // Group items by 'group' and count occurrences
    Map<String, int> groupCount = {};
    for (var item in items.where((item) => item.isSelect == true)) {
      selectedGoalAnalytics.add(item.langNameKey);
      groupCount[item.langNameGroup] =
          (groupCount[item.langNameGroup] ?? 0) + 1;
    }

    // Sort groups based on selection count, keeping 'Match Day' first
    List<AiPromptModel> sortedGroups = [prompts!.first];

    var remainingGroups = prompts!
        .where((group) => group.prompt != prompts!.first.prompt)
        .toList();

    // Sort remaining groups based on selection count (higher first), then by default order
    remainingGroups.sort((a, b) {
      int countA = groupCount[a.prompt] ?? 0;
      int countB = groupCount[b.prompt] ?? 0;
      return countB.compareTo(countA); // Descending order based on count
    });

    sortedGroups.addAll(remainingGroups);

    // hard code data waiting for api
    sortedGroups.insert(
        4,
        AiPromptModel(
            id: 5,
            prompt: "Personal Preferences",
            desc: "Keep customizing your trip "));

    List<String> ids = sortedGroups.map((e) => e.id.toString()).toList();

    await userDetailRepo?.updateUserPreference(
        "?update_type=know_your_user",
        {
          "preferences": {"trip_goal": ids}
        },
        (json) => (),
        false);

    rearrangePrompts = sortedGroups;

    //update promt
    GetIt.I<AiAssistantPromptsScreenProvider>()
        .fetchPrompt(isComeFromOutsideProvider: true);
    setState();
  }

  // Function to Change Page
  Future<void> changePage(bool isContinue, int newPage) async {
    if (_isInvalidPage(newPage)) {
      navigateToAiAssistantThanksScreen();
      return;
    }

    _handlePageTransition(isContinue, newPage);
    await _performPageAnimation();
    _updatePageState(newPage);
    _handleAnalytics(isContinue, newPage);
  }

  bool _isInvalidPage(int newPage) {
    return newPage < 0 || newPage >= pages.length;
  }

  void _handlePageTransition(bool isContinue, int newPage) {
    if (isContinue && newPage == 2) {
      promptGroups(goals!);
    }
    nextPage = newPage;
    setState();
  }

  Future<void> _performPageAnimation() async {
    await controller.forward();
    isAnimationFinished = true;
    controller.reset();
  }

  void _updatePageState(int newPage) {
    currentPage = newPage;
    Utils.logPrint("newPage $newPage");

    if (newPage == 3) {
      resetAll();
    }
    setState();
  }

  void _handleAnalytics(bool isContinue, int newPage) {
    switch (newPage) {
      case 1:
        _logStepTwoAnalytics(isContinue);
        break;
      case 2:
        _logStepThreeAnalytics(isContinue);
        break;
    }
  }

  void _logStepTwoAnalytics(bool isContinue) {
    _logButtonClick(isContinue, "txt_continue",
        {"excitement_level": getExcitementStepsKey()}, "skip");

    final previousScreen = isStepOneScreenShow
        ? AppRoutes.aiAssistantStepOneScreen
        : FirebaseAnalyticsService.previousPage;

    _logScreenView(
      AppRoutes.aiAssistantStepTwoScreen,
      FirebaseAnalyticsService.cleanRoutePath(previousScreen),
      "gtkystep2_screenview",
    );
  }

  void _logStepThreeAnalytics(bool isContinue) {
    _logButtonClick(isContinue, "txt_continue",
        {"trip_goals": selectedGoalAnalytics.toString(),
          "screen_name": AppRoutes.aiAssistantStepTwoScreen
        }, "skip");

    final previousScreen = isStepTwoScreenShow
        ? AppRoutes.aiAssistantStepTwoScreen
        : (FirebaseAnalyticsService.previousPage =
            AppRoutes.aiAssistantStepOneScreen);

    _logScreenView(
      AppRoutes.aiAssistantStepThreeScreen,
      FirebaseAnalyticsService.cleanRoutePath(previousScreen),
      "gtkystep3_screenview",
    );
  }

  void _logButtonClick(bool isContinue, String continueBtnName,
      Map<String, Object>? parameters, String skipBtnName) {
    if (isContinue) {
      FirebaseAnalyticsService.logEventButtonClick(
        btnName: continueBtnName,
        parameters: parameters,
      );
    } else {
      FirebaseAnalyticsService.logEventButtonClick(btnName: skipBtnName);
    }
  }

  void _logScreenView(
      String screenName, String previousScreen, String customEventName) {
    FirebaseAnalyticsService.logEvent(
      eventName: AnalyticsEventConst.EVENT_NAME_SCREEN_VIEW,
      screenName: FirebaseAnalyticsService.cleanRoutePath(screenName),
      previousScreen: FirebaseAnalyticsService.cleanRoutePath(previousScreen),
    );

    FirebaseAnalyticsService.logEvent(
      eventName: customEventName,
      screenName: FirebaseAnalyticsService.cleanRoutePath(screenName),
      previousScreen: FirebaseAnalyticsService.cleanRoutePath(previousScreen),
    );
  }

  void setTextAnimationFinished(bool finished) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      isTextAnimationFinished = finished;
      setState();
    });
  }

  /// Find the nearest step for smoother snapping
  double getNearestStep(double value) {
    // This finds the closest step based on the point values.
    return listExcitements!
        .map((e) => e.point)
        .reduce((a, b) => (value - a).abs() < (value - b).abs() ? a : b);
  }

  /// Helper method to ensure proper step synchronization
  void syncSliderValues(double value, bool isTap) {
    if (isTap) {
      // For tap events, snap to nearest step
      double nearestStep = getNearestStep(value);
      volumeValue = nearestStep;
      _gaugeValue = nearestStep;
      _currentStep = gaugeStepper.indexOf(nearestStep);
    } else {
      // For drag events, use exact value
      volumeValue = value;
      _gaugeValue = value;
      _currentStep = gaugeStepper.indexOf(getNearestStep(value));
    }
  }

  void nextStep() {
    _currentStep = (_currentStep + 1) %
        gaugeStepper.length; // ✅ Loop back to start when at max
    _gaugeValue = gaugeStepper[_currentStep]; // ✅ Update gauge pointer
    Utils.logPrint("on next $_gaugeValue");

    onVolumeChanged(_gaugeValue, true);
  }

  void increaseStep() {
    if (_currentStep < gaugeStepper.length - 1) {
      _currentStep++;
    } else {
      _currentStep = 0; // ✅ Reset to 0 when reaching 1.0
    }
    _gaugeValue = gaugeStepper[_currentStep];
    onVolumeChanged(_gaugeValue, true);
  }

  void decreaseStep() {
    /*if (_currentStep >= 0) {
      _currentStep--;
    } else {
      _currentStep =
          gaugeStepper.length - 1; // ✅ Reset to 1.0 when reaching 0.0
    }
    _gaugeValue = gaugeStepper[_currentStep];*/
    if (_currentStep > 0) {
      _currentStep--;
      _gaugeValue = gaugeStepper[_currentStep];
      // notifyListeners();
    }

    Utils.logPrint("_gaugeValue $_gaugeValue");
    onVolumeChanged(_gaugeValue, true);
  }

  Future<void> onVolumeChanged(double value, bool isClicked) async {
    // Clamp value to valid range
    value = value.clamp(0.0, 1.0);

    // Handle edge case for maximum value
    if (value > 0.92) {
      value = 1.0;
    }

    bool isReset = volumeValue == 1.0 && value == 0.0; // Detect reset condition

    if (isReset) {
      // **RESET Immediately Without Animation**
      gaugeAnimationController.reset();
      volumeValue = 0.0;
      _gaugeValue = 0.0;
      _currentStep = 0;
    } else {
      // Use helper method to sync values properly
      syncSliderValues(value, isClicked);

      if (isClicked) {
        // Smooth animation for tap events
        gaugeAnimationController.animateTo(
          volumeValue,
          duration: const Duration(milliseconds: 700),
          curve: Curves.easeInOut,
        );
      } else {
        // Immediate update for drag events
        gaugeAnimationController.value = volumeValue;
      }
    }

    setState();
  }

  double? _previousAngle; // Stores the last tapped angle
  bool isForward = true; // Default

  void onGaugeTap(TapDownDetails details) {
    // Get the RenderBox from the gauge's key.
    final renderObject = gaugeKey.currentContext?.findRenderObject();
    if (renderObject is RenderBox) {
      final RenderBox box = renderObject;
      // Get the tap position relative to the gauge.
      final localOffset = box.globalToLocal(details.globalPosition);
      // Calculate the center of the gauge.
      final center = Offset(box.size.width / 2, box.size.height / 2);

      // Compute the difference from the center.
      final dx = localOffset.dx - center.dx;
      final dy = localOffset.dy - center.dy;

      // Calculate the angle in radians and then convert to degrees.
      final angleInRadians = atan2(dy, dx);
      final angleInDegrees = (angleInRadians * 180 / pi + 360) % 360;
      //Utils.logPrint('Tapped angle: $angleInDegrees');

      // Adjust the angle relative to the gauge's start (270°).
      final adjustedAngle = (angleInDegrees - 270 + 360) % 360;
      //Utils.logPrint('Tapped value: $tappedValue');

      // Determine Direction

      if (_previousAngle != null) {
        double angleDiff = adjustedAngle - _previousAngle!;

        // Handle edge case where movement crosses 0° boundary
        if (angleDiff > 180) {
          angleDiff -= 360;
        } else if (angleDiff < -180) {
          angleDiff += 360;
        }

        isForward = angleDiff > 0 ? true : false;
      }

      //Utils.logPrint('Direction: $isForward');

      // Update previous angle
      _previousAngle = adjustedAngle;

      // Call the callback to update the gauge value.
      // onVolumeChanged(tappedValue, true);
      nextStep();
    }
  }

  void resetAll() {
    volumeValue = 0;
    _gaugeValue = 0;
    _currentStep = 0;
    teamSelectedIndex = 0;
    teamName = "";
    selectedTeamKey = "";
    selectedGoalAnalytics = [];
    setState();
  }

  // Get Smiley Excitement Steps Title
  String getExcitementStepsTitle() {
    final title = listExcitements!
        .firstWhere((step) => step.point == getNearestStep(volumeValue))
        .title;

    final message = Utils.getErrorMessageFromString(title);

    Utils.announceMessage(message);

    return message;
  }

  String getExcitementStepsKey() {
    String title = listExcitements!
        .firstWhere((step) => step.point == getNearestStep(volumeValue))
        .title;

    return title ?? "";
  }

  //<<-----Step 2 Screen Init\'s---->>>//
  final Random random = Random();

  // Model for each bubble
  List<AiGoalModel>? goals;
  List<AiPromptModel>? prompts;
  List<AiPromptModel>? rearrangePrompts = [];
  final List<AnimationController> shadowControllers = [];

  final List<Animation<double>> shadowAnimations = [];
  final List<double> radii = []; // Radius for each shadow's circular motion

  // Load Goals From Json File
  Future<void> loadGoalsListFromJsonFile() async {
    if (goals == null || goals!.isEmpty) {
      goals = goalFromJsonList(await Utils.loadJson(Assets.jsonGoals));
      setState();
    }
  }

  // Load Goals From Json File
  Future<void> loadPromptsListFromJsonFile() async {
    if (prompts == null || prompts!.isEmpty) {
      prompts = promptsFromJsonList(await Utils.loadJson(Assets.jsonPrompts));
    }
  }

  void initializeShadowControllers(TickerProvider tickerProvider) {
// Clear old controllers and animations
    for (var controller in shadowControllers) {
      controller.dispose(); // Dispose safely
    }
    shadowControllers.clear();
    shadowAnimations.clear();
    radii.clear();

    if (goals != null && goals!.isNotEmpty) {
      for (int i = 0; i < goals!.length; i++) {
        // Controller for smooth circular motion
        final shadowController = AnimationController(
          duration: Duration(seconds: random.nextInt(3) + 3), // Random duration
          vsync: tickerProvider,
        );
        // ..repeat(); // Loop the motion

        final startAngle = Random().nextDouble() * 2 * pi;

        // Circular motion animation
        final shadowAnimation = Tween<double>(
          begin: startAngle,
          end: startAngle + 2 * pi,
        ).animate(
          CurvedAnimation(
            parent: shadowController,
            curve: Curves.linear,
          ),
        );
        shadowControllers.add(shadowController);
        shadowAnimations.add(shadowAnimation);

        // Assign a random radius for each shadow
        // radii.add(
        // random.nextDouble() * 10 + 10); // Random radius between 10 and 20
        radii.add(random.nextDouble() * 6 + 10); // 10–16 px radius
        // ❗ Delay start so each bubble begins at a different time
        Future.delayed(Duration(milliseconds: 800 * i), () {
          if (mContext.mounted) {
            shadowController.repeat();
          }
        });
      }
    }
  }

  void toggleSelection(int index) {
    if (index < 0 || index >= goals!.length) return;

    final goal = goals![index];
    goal.isSelect = !goal.isSelect;

    final status =
        goal.isSelect ? S.of(mContext).selected : S.of(mContext).unselected;
    Utils.announceMessage(
        "${Utils.getErrorMessageFromString(goal.langNameKey)}, $status");

    shadowControllers[index].repeat();

    setState();
  }

  // Update Bubble Appearance
  BubbleAppearance getBubbleAppearance(int index) {
    var aiAssistantProvider = Provider.of<AiAssistantMainProvider>(mContext);

    if (_isIndexOutOfBounds(index)) {
      return _createDefaultBubbleAppearance(aiAssistantProvider, index);
    }

    if (_isBubbleSelected(index)) {
      return _createSelectedBubbleAppearance(aiAssistantProvider, index);
    }

    if (_isNearSelectedBubble(index)) {
      return _createSurroundingBubbleAppearance(aiAssistantProvider, index);
    }

    return _createNormalBubbleAppearance(aiAssistantProvider, index);
  }

  bool _isIndexOutOfBounds(int index) {
    return index < 0 || index >= goals!.length;
  }

  bool _isBubbleSelected(int index) {
    return goals![index].isSelect;
  }

  bool _isNearSelectedBubble(int index) {
    bool leftNeighborSelected = _hasLeftNeighborSelected(index);
    bool rightNeighborSelected = _hasRightNeighborSelected(index);
    return leftNeighborSelected || rightNeighborSelected;
  }

  bool _hasLeftNeighborSelected(int index) {
    return (index - 1 >= 0 && goals![index - 1].isSelect) ||
        (index - 2 >= 0 && goals![index - 2].isSelect);
  }

  bool _hasRightNeighborSelected(int index) {
    return (index + 1 < goals!.length && goals![index + 1].isSelect) ||
        (index + 2 < goals!.length && goals![index + 2].isSelect);
  }

  BubbleAppearance _createDefaultBubbleAppearance(
      AiAssistantMainProvider aiAssistantProvider, int index) {
    return BubbleAppearance(
      size:
          _getBubbleSize(aiAssistantProvider, normalSize ?? goals![index].size),
      isSurrounding: false,
      fontSize: 18.0.sp,
      textStyle: VisaTextStyle.displayBodyXl,
    );
  }

  BubbleAppearance _createSelectedBubbleAppearance(
      AiAssistantMainProvider aiAssistantProvider, int index) {
    return BubbleAppearance(
      size: _getBubbleSize(
          aiAssistantProvider, selectedSize ?? goals![index].selectedSize),
      isSurrounding: false,
      fontSize: 20.0.sp,
      textStyle: VisaTextStyle.displayTitleSmall,
    );
  }

  BubbleAppearance _createSurroundingBubbleAppearance(
      AiAssistantMainProvider aiAssistantProvider, int index) {
    return BubbleAppearance(
      size: _getBubbleSize(
          aiAssistantProvider, surroundingSize ?? goals![index].surroundedSize),
      textStyle: VisaTextStyle.displayTitleSmall,
      fontSize: 12.0.sp,
      isSurrounding: true,
    );
  }

  BubbleAppearance _createNormalBubbleAppearance(
      AiAssistantMainProvider aiAssistantProvider, int index) {
    return BubbleAppearance(
      size:
          _getBubbleSize(aiAssistantProvider, normalSize ?? goals![index].size),
      isSurrounding: false,
      fontSize: 15.0.sp,
      textStyle: VisaTextStyle.displayBodyL,
    );
  }

  double _getBubbleSize(
      AiAssistantMainProvider aiAssistantProvider, double defaultSize) {
    return aiAssistantProvider.isDesktopView
        ? AppSizes.nintyWidth
        : defaultSize;
  }

  // Function to Clear List's
  void clearAllLists() {
    shadowControllers.clear();
    //shadowAnimations.clear();
    //radii.clear();
    goals?.forEach((goal) => goal.isSelect = false);
  }

  //<<-----Step Three Screen Init\'s----->>//
  CarouselSliderController carouselController = CarouselSliderController();

  List<Teams>? teamsList = [];
  String teamName = '';
  String selectedTeamKey = '';

  // Function to getTeams
  Future<void> getTeams() async {
    if (teamsList == null || teamsList!.isEmpty) {
      aiAssistantRepo = AiAssistantRepo(apiClient);
      final response =
          await aiAssistantRepo?.getTeams(AiTeamsNewModel.fromJson);

      if (response != null && response.isSuccess) {
        if (response.data != null) {
          teamsList = response.data!.teams;
          teamName = teamsList![0].name!;
          selectedTeamKey = teamsList![0].key!;
          Utils.logPrint('TeamNameUP>>$teamName');
          // Sorting teams alphabetically based on 'name'
          //teamsList!.sort((a, b) => (a.name ?? "").compareTo(b.name ?? ""));
        } else {
          teamsList = []; // Prevents null issues
        }
      } else {
        teamsList = [];
      }
    }
  }

  // Function to Change Team
  void changeTeam(int index) {
    teamSelectedIndex = index;
    hasUserInteracted = true;
    notifyListeners();
  }

  // Function to get Selected Index
  void getSelectedIndex(String value) {
    hasUserInteracted = true;
    hasEmptyText = false;
    hasSearchNotMatched = false;
    if (teamsList == null || teamsList!.isEmpty) return;

    // If value is empty, announce and return
    if (value.trim().isEmpty) {
      hasEmptyText = true;
      Utils.announceMessage(S.of(mContext).empty_team_text);
      return;
    }

    // Find the first team whose name starts with the pressed letter
    int matchedIndex = teamsList!.indexWhere(
      (item) =>
          item.name != null &&
          item.name!.toLowerCase().startsWith(value.toLowerCase()),
    );

    // If no match is found, announce and return
    if (matchedIndex == -1) {
      hasSearchNotMatched = true;
      Utils.announceMessage("${S.of(mContext).no_team_found} ${value.trim()}.");
      return;
    }

    teamName = teamsList![matchedIndex].name!;
    selectedTeamKey = teamsList![matchedIndex].key!;

    // Animate to the matched index in the carousel
    carouselController.animateToPage(
      matchedIndex,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeOut,
    );

    // Update selected team
    changeTeam(matchedIndex);
  }

  // Function to Update Team Preference
  Future<void> updateTeamPreference() async {
    if (teamName.isNotEmpty) {
      FirebaseAnalyticsService.logEventButtonClick(
          btnName: "txt_continue",
          parameters: {"country_interested": selectedTeamKey,
            "screen_name": AppRoutes.aiAssistantStepThreeScreen
          });

      Map<String, dynamic> teamsMap = {
        "preferences": {
          "team_name": [teamName]
        }
      };
      final response = await aiAssistantRepo?.updateTeamsPreference(
          AiGetPreferencesQuestionModel.fromJson, teamsMap);
      if (response != null && response.statusCode == 200) {
        Utils.logPrint('Teams Added Successfully');
      }
    }
  }

  // Function to get questions pages content as per configuration values
  Future<void> getAppConfiguration() async {
    // this bool is set for semantics focused
    hasUserInteracted = false;

    if (await _isGettingToKnowDone()) {
      return;
    }

    try {
      await _initializeConfiguration();
      final configuration = await _loadConfiguration();

      if (configuration == null) {
        await _handleNullConfiguration();
        return;
      }

      await _processConfiguration(configuration);
    } catch (e) {
      await _handleConfigurationError(e);
    }
  }

  Future<bool> _isGettingToKnowDone() async {
    return await Preferences.getBool(Preferences.isGettingToKnowDone);
  }

  Future<void> _initializeConfiguration() async {
    _loadAllDefaults();
    aiAssistantRepo = AiAssistantRepo(apiClient);
  }

  Future<Map<String, dynamic>?> _loadConfiguration() async {
    var configuration = await Preferences.getMapData(Preferences.keyAppConfig);
    Utils.logPrint("Configuration iin pref $configuration");

    configuration ??= await aiAssistantRepo?.getAppConfiguration();
    return configuration;
  }

  Future<void> _handleNullConfiguration() async {
    Utils.logPrint("Configuration is null — loading all defaults");
    await _loadAllDefaults();
  }

  Future<void> _processConfiguration(Map<String, dynamic> configuration) async {
    Utils.logPrint("Configuration -----: $configuration");

    _updateStepVisibility(configuration);
    _logConfigurationStatus();

    if (isAllStepsEnabled) {
      await _loadAllSteps();
    } else {
      await _loadConditionalSteps();
    }
  }

  void _updateStepVisibility(Map<String, dynamic> configuration) {
    final aiWelcomeScreens = configuration["ai-welcome-screens"] ?? {};

    isStepOneScreenShow = aiWelcomeScreens["step1"] ?? true;
    isStepTwoScreenShow = aiWelcomeScreens["step2"] ?? true;
    isStepThreeScreenShow = aiWelcomeScreens["step3"] ?? true;

    isAllStepsEnabled =
        isStepOneScreenShow && isStepTwoScreenShow && isStepThreeScreenShow;
    isAllStepsNavEnabled =
        isStepOneScreenShow || isStepTwoScreenShow || isStepThreeScreenShow;
  }

  void _logConfigurationStatus() {
    Utils.logPrint("Step 1: $isStepOneScreenShow");
    Utils.logPrint("Step 2: $isStepTwoScreenShow");
    Utils.logPrint("Step 3: $isStepThreeScreenShow");
    Utils.logPrint("Steps Enabled: $isAllStepsEnabled");
    Utils.logPrint("Nav Steps Enabled: $isAllStepsNavEnabled");
  }

  Future<void> _loadAllSteps() async {
    try {
      await Future.wait([
        loadExcitementsListFromJsonFile(),
        loadGoalsListFromJsonFile(),
        getTeams(),
      ]);
    } catch (e) {
      Utils.logPrint(
          "Error loading full steps. Loading all defaults. Error: $e");
      await _loadAllDefaults();
    }
  }

  Future<void> _loadConditionalSteps() async {
    try {
      await _loadStepOneIfEnabled();
      await _loadStepTwoIfEnabled();
      await _loadStepThreeIfEnabled();
    } catch (e) {
      Utils.logPrint(
          "Error loading conditional steps. Loading all defaults. Error: $e");
      await _loadAllDefaults();
    }
  }

  Future<void> _loadStepOneIfEnabled() async {
    if (isStepOneScreenShow) {
      await loadExcitementsListFromJsonFile();
      final val = await Preferences.getBool(Preferences.isGettingToKnowNavigation);
      FirebaseAnalyticsService.previousPage = AppRoutes.aiAssistantGreetingScreen;
      FirebaseAnalyticsService.logEvent(eventName: "gtkystep1_screenview",
        parameters: {
          AnalyticsEventConst.PARAM_NAME_UI_ELEMENT_LOCATION: val ? "profile" : "registration"
        },);
    }
  }

  Future<void> _loadStepTwoIfEnabled() async {
    if (isStepTwoScreenShow) {
      await loadGoalsListFromJsonFile();
    }
  }

  Future<void> _loadStepThreeIfEnabled() async {
    if (isStepThreeScreenShow) {
      await getTeams();
    }
  }

  Future<void> _handleConfigurationError(dynamic error) async {
    Utils.logPrint(
        "Unexpected error during configuration load. Loading all defaults. Error: $error");
    await _loadAllDefaults();
  }

  /// Fallback method to load everything in parallel
  Future<void> _loadAllDefaults() async {
    await Future.wait([
      loadExcitementsListFromJsonFile(),
      loadGoalsListFromJsonFile(),
      getTeams(),
    ]);
  }

  void showHeaderCancelButton(bool isShown) {
    showCancelButton = isShown;
    setState();
  }

  void showBackgroundGradient(bool isShown) {
    showShowBackgroundGradient = isShown;
    setState();
  }

  // Navigate to the AiAssistant Prompt Selection Screen
  void navigateToAiAssistantPromptScreen() {
    navPush(AppRoutes.aiAssistantPromptsScreen);
  }

  // Navigate to the AiAssistant Thread's(Q/A) Screen
  void navigateToAiAssistantThreadsScreen(String evaQuestion, String location) {
    navGo(AppRoutes.evaChatScreenNav, extra: {
      "eva_question": evaQuestion,
      "location": location,
      "section": '',
    });

    // evaquery.initiate

    FirebaseAnalyticsService.logEvent(
        eventName: "evaquery_submitted ",
        parameters: {
          AnalyticsEventConst.PARAM_NAME_UI_ELEMENT: "query_send",
          "query_text": evaQuestion,
        });
  }

  // Navigate to the AiAssistant Recent Queries Screen
  void navigateToAiAssistantRecentQueriesScreen() {
    navPush(AppRoutes.aiAssistantRecentQueriesScreen);
  }

  // Navigate to the AiAssistant Common Steps Screen
  Future<void> navigateToAiAssistantCommonStepsScreen() async {
    if (await Preferences.getBool(Preferences.isGettingToKnowNavigation)) {
      //navPop();
    }
    navPushReplace(AppRoutes.aiAssistantCommonStepsScreen);
  }

  // Navigate to the AiAssistant Step One Screen
  void navigateToAiAssistantStepOneScreen() {
    navPush(AppRoutes.aiAssistantStepOneScreen);
  }

  // Navigate to the AiAssistant Step Two Screen
  void navigateToAiAssistantStepTwoScreen() {
    navPush(AppRoutes.aiAssistantStepTwoScreen);
  }

  // Navigate to the AiAssistant Step Three Screen
  void navigateToAiAssistantStepThreeScreen() {
    navPush(AppRoutes.aiAssistantStepThreeScreen);
  }

  // Navigate to the AiAssistant Thanks Screen
  void navigateToAiAssistantThanksScreen() {
    resetAll();
    //navPop();
    navPushReplace(AppRoutes.aiAssistantThanksScreen);

    FirebaseAnalyticsService.logEvent(eventName: "gtky_confirmationscreen");
  }

  // Navigate to the Home Screen
  Future<void> navigateToHomeScreen() async {
    await Preferences.setBool(Preferences.isGettingToKnowDone, true);
    if (await Preferences.getBool(Preferences.isGettingToKnowNavigation)) {
      navPop();
    } else {
      navGo(AppRoutes.homeNav);
    }
  }

  // Navigate to the Close Screen
  void closeScreen() {
    navPop();
  }
}
