import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:visaamigo/features/home/model/tutorial_steps_model.dart';
import 'package:visaamigo/ui/base/base_provider.dart';
import 'package:visaamigo/utils/utils.dart';

import '../../../analytics/firebase_analytics_service.dart';
import '../../../custom_widgets/hole_painter.dart';
import '../../../generated/assets.dart';
import '../../../generated/l10n.dart';
import '../../../utils/shared_preferences.dart';
import '../../ai_assistant/providers/ai_assistant_prompts_screen_provider.dart';
import '../../splash_screen/repo/user_detail_repo.dart';

class TutorialProvider extends BaseProvider {
  // GlobalKeys For Home Tutorial
  GlobalKey tutorialBlank = GlobalKey();
  GlobalKey tutorialTicketKey = GlobalKey();
  GlobalKey tutorialEvaTravelKey = GlobalKey();
  GlobalKey tutorialWalletKey = GlobalKey();
  GlobalKey tutorialBookTravelKey = GlobalKey();
  GlobalKey tutorialCompanionKey = GlobalKey();

  GlobalKey tutorialBlankSC = GlobalKey();
  GlobalKey tutorialTicketKeySC = GlobalKey();
  GlobalKey tutorialEvaTravelKeySC = GlobalKey();
  GlobalKey tutorialWalletKeySC = GlobalKey();
  GlobalKey tutorialBookTravelKeySC = GlobalKey();
  GlobalKey tutorialCompanionKeySC = GlobalKey();

  // GlobalKeys For EVA Tutorial
  GlobalKey tutorialPersonalPref = GlobalKey();

  bool tutorialStatus = false;
  bool tutorialLoaded = false;
  bool _isTutorialStarted = false;

  bool tutorialEvaScreenStatus = false;
  bool tutorialEVALoaded = false;

  bool? walletCardShow;
  bool? companionCardShow;
  bool? isCompanion;

  bool? walletPrePaidCardShow;
  bool? walletTravelCardShow;
  bool? walletBothCardShow;

  UserDetailRepo? userDetailRepo;

  int index = 0;

  String uiElementLocation = "registration"; //analytics key

  // New Initialization
  List<GlobalKey> homeShowcaseKeys = [];
  OverlayEntry? overlayEntry;

  BuildContext? _buildContextHome;

  BuildContext? get getHomeShowCaseContext => _buildContextHome;

  void initHomeContext(BuildContext context) {
    _buildContextHome = context;
  }

  BuildContext? _buildContextEVA;

  BuildContext? get getEVAShowCaseContext => _buildContextEVA;

  void initEVAContext(BuildContext context) {
    _buildContextEVA = context;
  }

  bool get isTutorialStarted => _isTutorialStarted;

  void setTutorialStarted(bool value) {
    _isTutorialStarted = value;
    setState();
  }

  // Function to Re-Start Home Tutorial
  void reStartHomeTutorial(BuildContext context) async {
    uiElementLocation = "profile"; //analytics key

    setContext(context);
    bool isComeFromReWatchHomeTutorial =
        await Preferences.getBool(Preferences.isComeFromReWatchHomeTutorial);
    if (isComeFromReWatchHomeTutorial) {
      homeShowcaseKeys.clear();
      await Preferences.setBool(
          Preferences.isComeFromReWatchHomeTutorial, false);
      WidgetsBinding.instance.addPostFrameCallback((_) {
        getHomeTutorialStatus(context);
      });
    }
  }

  // Function to get Home Tutorial Status
  void getHomeTutorialStatus(
    BuildContext context, {
    bool isComeFromHome = false,
    bool walletCardShow = true,
    bool companionCardShow = true,
    bool walletTravelCardShow = true,
    bool walletPrePaidCardShow = true,
    bool walletBothCardShow = true,
    bool isCompanion = false,
  }) async {
    setContext(context);
    Utils.hideKeyboard(context);
    homeShowcaseKeys.clear();
    index = 0;
    setTutorialStarted(false);
    if (isComeFromHome) {
      resetValues();
    }
    this.walletCardShow = this.walletCardShow ?? walletCardShow;
    this.companionCardShow = this.companionCardShow ?? companionCardShow;
    this.isCompanion = this.isCompanion ?? isCompanion;
    this.walletTravelCardShow =
        this.walletTravelCardShow ?? walletTravelCardShow;
    this.walletPrePaidCardShow =
        this.walletPrePaidCardShow ?? walletPrePaidCardShow;
    this.walletBothCardShow = this.walletBothCardShow ?? walletBothCardShow;
    tutorialStatus = await Preferences.getBool(Preferences.tutorialStatus);
    tutorialLoaded = true;
    startHomeTutorial();
  }

  // Function to start Tutorial
  void startHomeTutorial() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_shouldSkipTutorial()) return;

      _logTutorialAnalytics();
      _initializeTutorialSteps();
      _executeTutorial();
    });
  }

  bool _shouldSkipTutorial() {
    return tutorialStatus;
  }

  void _logTutorialAnalytics() {
    FirebaseAnalyticsService.nonInteraction = true;
    FirebaseAnalyticsService.logEvent(
      eventName: "tutorialbanner_seen",
      parameters: {
        AnalyticsEventConst.PARAM_NAME_UI_ELEMENT_LOCATION: uiElementLocation,
      },
    );
  }

  void _initializeTutorialSteps() {
    final stepsSC = _buildShowCaseSteps();
    final stepCP = _buildCustomPainterSteps();

    ShowCaseWidget.of(getHomeShowCaseContext!).startShowCase(stepsSC);
    homeShowcaseKeys.addAll(stepCP);
  }

  List<GlobalKey> _buildShowCaseSteps() {
    final steps = <GlobalKey>[
      tutorialBlankSC,
      tutorialTicketKeySC,
    ];

    _addEvaTravelSteps(steps);
    _addWalletSteps(steps);
    _addCompanionSteps(steps);

    return steps;
  }

  void _addEvaTravelSteps(List<GlobalKey> steps) {
    if (!isCompanion!) {
      steps.add(tutorialEvaTravelKeySC);
    } else {
      steps.addAll([
        tutorialEvaTravelKeySC,
        tutorialBookTravelKeySC,
      ]);
    }
  }

  void _addWalletSteps(List<GlobalKey> steps) {
    if (!_shouldShowWalletSteps()) return;

    if (walletTravelCardShow!) {
      steps.add(tutorialWalletKeySC);
    }
    if (walletPrePaidCardShow!) {
      steps.add(tutorialWalletKeySC);
    }
    if (walletBothCardShow!) {
      steps.add(tutorialWalletKeySC);
    }
  }

  bool _shouldShowWalletSteps() {
    return walletCardShow! && !isCompanion!;
  }

  void _addCompanionSteps(List<GlobalKey> steps) {
    if (_shouldShowCompanionOnlySteps()) {
      steps.add(tutorialCompanionKeySC);
      steps.add(tutorialBookTravelKeySC);
    } else if (_shouldShowCompanionSteps()) {
      steps.add(tutorialCompanionKeySC);
      steps.add(tutorialCompanionKeySC);
    } else if (!isCompanion!) {
      steps.add(tutorialBookTravelKeySC);
    }
  }

  bool _shouldShowCompanionOnlySteps() {
    return !walletCardShow! && companionCardShow! && !isCompanion!;
  }

  bool _shouldShowCompanionSteps() {
    return companionCardShow! && !isCompanion!;
  }

  List<GlobalKey> _buildCustomPainterSteps() {
    final steps = <GlobalKey>[
      tutorialBlank,
      tutorialTicketKey,
    ];

    _addEvaTravelStepsCP(steps);
    _addWalletStepsCP(steps);
    _addCompanionStepsCP(steps);

    return steps;
  }

  void _addEvaTravelStepsCP(List<GlobalKey> steps) {
    if (!isCompanion!) {
      steps.add(tutorialEvaTravelKey);
    } else {
      steps.addAll([
        tutorialEvaTravelKey,
        tutorialBookTravelKey,
      ]);
    }
  }

  void _addWalletStepsCP(List<GlobalKey> steps) {
    if (!_shouldShowWalletSteps()) return;

    if (walletTravelCardShow!) {
      steps.add(tutorialWalletKey);
    }
    if (walletPrePaidCardShow!) {
      steps.add(tutorialWalletKey);
    }
    if (walletBothCardShow!) {
      steps.add(tutorialWalletKey);
    }
  }

  void _addCompanionStepsCP(List<GlobalKey> steps) {
    if (_shouldShowCompanionOnlySteps()) {
      steps.add(tutorialCompanionKey);
      steps.add(tutorialBookTravelKey);
    } else if (_shouldShowCompanionSteps()) {
      steps.add(tutorialBookTravelKey);
      steps.add(tutorialCompanionKey);
    } else if (!isCompanion!) {
      steps.add(tutorialBookTravelKey);
    }
  }

  void _executeTutorial() {
    startTutorial();
    setState();
  }

  List<TutorialStepsModel> get tutorialSteps => getTutorialSteps();

  List<TutorialStepsModel> getTutorialSteps() {
    var s = S.of(getContext());
    final steps = [
      TutorialStepsModel(
        title: s.tutorial,
        subtitle: s.tutorial_quick_tour,
        description: '',
        iconAsset: Assets.iconsTutorialIcon,
      ),
      TutorialStepsModel(
        title: s.ticket_details,
        subtitle: s.ticket_details_info,
        description: '',
        iconAsset: Assets.iconsIcTicket,
      ),
      TutorialStepsModel(
        title: s.eva_ai_powered_concierge,
        subtitle: s.eva_ai_powered_concierge_info,
        description: '',
        iconAsset: Assets.iconsEva,
      )
    ];

    if (walletCardShow! && !isCompanion!) {
      if (walletTravelCardShow!) {
        steps.add(TutorialStepsModel(
          title: s.wallet,
          subtitle: s.wallet_info_travel_credit,
          description: '',
          iconAsset: Assets.iconsWallet,
          isTextSpan: true,
          boldWords: [s.travel_credits],
        ));
      }
      if (walletPrePaidCardShow!) {
        steps.add(TutorialStepsModel(
          title: s.wallet,
          subtitle: s.wallet_info_prepaid,
          description: s.wallet_sub_info_both,
          iconAsset: Assets.iconsWallet,
          isTextSpan: true,
          boldWords: [s.prepaid_card],
        ));
      }
      if (walletBothCardShow!) {
        steps.add(TutorialStepsModel(
          title: s.wallet,
          subtitle: s.wallet_info_both,
          description: s.wallet_sub_info_both,
          iconAsset: Assets.iconsWallet,
          isTextSpan: true,
          boldWords: [
            s.travel_credits,
            s.prepaid_card,
          ],
        ));
      }
    }

    steps.add(
      TutorialStepsModel(
        title: s.plan_your_trip,
        subtitle: s.plan_your_trip_info,
        description: '',
        iconAsset: Assets.iconsPlanTripIcon,
      ),
    );

    // if (companionCardTutorialShow) {
    //   steps.add(
    //     TutorialStepsModel(
    //       title: s.plan_your_trip,
    //       subtitle: s.plan_your_trip_info,
    //       description: '',
    //       iconAsset: Assets.iconsPlanTripIcon,
    //     ),
    //   );
    // }

    return steps;
  }

  // New Overlay Steps Initialization Start From Here
  void startTutorial() {
    _showStep();
  }

  void next() {
    final maxIndex = _calculateMaxIndex();

    if (!_canProceedToNext(maxIndex)) {
      closeOverlayTutorial();
      return;
    }

    _proceedToNextStep();
  }

  int _calculateMaxIndex() {
    return isCompanion! || !companionCardShow!
        ? homeShowcaseKeys.length - 1
        : homeShowcaseKeys.length - 2;
  }

  bool _canProceedToNext(int maxIndex) {
    return index < maxIndex;
  }

  void _proceedToNextStep() {
    final oldKey = homeShowcaseKeys[index];
    _incrementIndex();
    final newKey = homeShowcaseKeys[index];

    _handleStepTransition(oldKey, newKey);
  }

  void _incrementIndex() {
    index++;
    setTutorialStarted(true);
    // Semantics Announce Message Title
    Utils.announceMessage(tutorialSteps[index].title);
  }

  void _handleStepTransition(GlobalKey oldKey, GlobalKey newKey) {
    final shouldDelay = _shouldApplyDelay();

    if (_keysAreDifferent(oldKey, newKey)) {
      _showStepWithDelay(shouldDelay);
    }

    _advanceShowCaseWidget();
    _handleDelayedStepDisplay(oldKey, newKey, shouldDelay);
  }

  bool _shouldApplyDelay() {
    return index > 0 || (isCompanion! && index > 0);
  }

  bool _keysAreDifferent(GlobalKey oldKey, GlobalKey newKey) {
    return oldKey != newKey;
  }

  void _showStepWithDelay(bool shouldDelay) {
    _showStep(showHole: !shouldDelay);
  }

  void _advanceShowCaseWidget() {
    ShowCaseWidget.of(getHomeShowCaseContext!).next();
  }

  void _handleDelayedStepDisplay(
      GlobalKey oldKey, GlobalKey newKey, bool shouldDelay) {
    if (shouldDelay) {
      _scheduleDelayedStepDisplay(oldKey, newKey);
    } else if (_keysAreDifferent(oldKey, newKey)) {
      _showStep();
    }
  }

  void _scheduleDelayedStepDisplay(GlobalKey oldKey, GlobalKey newKey) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(milliseconds: 500), () {
        if (_keysAreDifferent(oldKey, newKey)) {
          _showStep(showHole: true);
        }
        setState();
      });
    });
  }

  void previous() {
    if (index > 0) {
      if (index == 1) {
        setTutorialStarted(false);
      }

      GlobalKey oldKey = homeShowcaseKeys[index]; // store old key

      index--;
      // Semantics Announce Message Title
      Utils.announceMessage(tutorialSteps[index].title);

      GlobalKey newKey = homeShowcaseKeys[index]; // new key

      if (oldKey != newKey) {
        _showStep(showHole: false);
      }

      ShowCaseWidget.of(getHomeShowCaseContext!).previous();
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Future.delayed(const Duration(milliseconds: 500), () {
          if (oldKey != newKey) {
            _showStep(showHole: true);
          }
          setState();
        });
      });
    }
  }

  // Function to Close Tutorial
  void closeOverlayTutorial() {
    index = 0;
    ShowCaseWidget.of(getHomeShowCaseContext!).dismiss();
    removeOverlay();
    tutorialStatus = true;
    tutorialLoaded = false;
    Preferences.setBool(Preferences.tutorialStatus, tutorialStatus);
    homeShowcaseKeys.clear();
    Utils.announceMessage(S.of(getHomeShowCaseContext!).close_tutorial);
    setState();
    updateTutorialPreference();
  }

  void _showStep({bool showHole = true}) {
    removeOverlay();

    List<Rect> highlightRects = [];

    if (companionCardShow! && !isCompanion!) {
      if (index == homeShowcaseKeys.length - 2) {
        highlightRects.addAll(
            _getRects([homeShowcaseKeys[index], homeShowcaseKeys[index + 1]]));
      } else {
        highlightRects.addAll(_getRects([homeShowcaseKeys[index]]));
      }
    } else {
      highlightRects.addAll(_getRects([homeShowcaseKeys[index]]));
    }

    overlayEntry = OverlayEntry(
      builder: (context) => Positioned.fill(
        child: CustomPaint(
          painter: HolePainter(
            highlightRects,
            showHole: showHole,
          ),
        ),
      ),
    );

    Overlay.of(getContext()).insert(overlayEntry!);
  }

  List<Rect> _getRects(List<GlobalKey> keys) {
    List<Rect> rects = [];
    for (var key in keys) {
      final renderBox = key.currentContext?.findRenderObject() as RenderBox?;
      if (renderBox != null) {
        final position = renderBox.localToGlobal(Offset.zero);
        rects.add(Rect.fromLTWH(
          position.dx,
          position.dy,
          renderBox.size.width,
          renderBox.size.height,
        ));
      }
    }
    return rects;
  }

  void removeOverlay() {
    overlayEntry?.remove();
    overlayEntry = null;
  }

  // EVA Screen Tutorial Declaration Start
  void getEvaTutorialStatus(BuildContext context) async {
    Utils.hideKeyboard(context);
    setContext(context);
    setState();
    tutorialEVALoaded = false;
    tutorialEvaScreenStatus =
        await Preferences.getBool(Preferences.tutorialEvaScreenStatus);
    tutorialEVALoaded = true;
    startEVATutorial();
  }

  // Function to start EVA Tutorial
  void startEVATutorial() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (tutorialEvaScreenStatus) return;
      ShowCaseWidget.of(getEVAShowCaseContext!)
          .startShowCase([tutorialPersonalPref]);
      setState();
    });
  }

  // Function to Close EVA Tutorial
  void closeEVATutorial() {
    ShowCaseWidget.of(getEVAShowCaseContext!).dismiss();
    tutorialEvaScreenStatus = true;
    tutorialEVALoaded = false;
    Preferences.setBool(
        Preferences.tutorialEvaScreenStatus, tutorialEvaScreenStatus);
    Utils.announceMessage(S.of(getEVAShowCaseContext!).close_tutorial);
    setState();
    GetIt.I<AiAssistantPromptsScreenProvider>()
        .animateScrollBackToOriginalPosition();
    updateTutorialPreference();
  }

  List<TutorialStepsModel> get tutorialEVASteps => getTutorialEVASteps();

  List<TutorialStepsModel> getTutorialEVASteps() {
    var s = S.of(getContext());
    final steps = [
      TutorialStepsModel(
        title: s.lets_get_personal,
        subtitle: s.lets_get_personal_info,
        description: '',
        iconAsset: Assets.iconsEva,
      ),
    ];

    return steps;
  }

  // Function to Re-Start EVA Tutorial
  void reStartEVATutorial(BuildContext context) async {
    setContext(context);
    bool isComeFromReWatchEVATutorial =
        await Preferences.getBool(Preferences.isComeFromReWatchEVATutorial);
    bool isPromptListLoaded =
        await Preferences.getBool(Preferences.isPromptListLoaded);
    if (isComeFromReWatchEVATutorial) {
      await Preferences.setBool(
          Preferences.isComeFromReWatchEVATutorial, false);
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        if (isPromptListLoaded) {
          getEvaTutorialStatus(getContext());
        }
      });
    }
  }

  // Function to reset values
  void resetValues() {
    tutorialStatus = false;
    tutorialLoaded = false;
    _isTutorialStarted = false;

    tutorialEvaScreenStatus = false;
    tutorialEVALoaded = false;

    walletCardShow = null;
    companionCardShow = null;
    isCompanion = null;

    walletPrePaidCardShow = null;
    walletTravelCardShow = null;
    walletBothCardShow = null;
  }

  Future<void> updateTutorialPreference() async {
    userDetailRepo = UserDetailRepo(apiClient);
    Map<String, List<String>> preferences;
    if (kIsWeb) {
      preferences = {
        "tutorial_web": ["true"],
      };
    } else {
      preferences = {
        "tutorial_mobile": ["true"],
      };
    }

    await userDetailRepo?.updateUserPreferenceKnowYourUser(
        preferences, (json) => (), false);
  }
}
