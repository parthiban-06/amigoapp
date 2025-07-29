import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:visaamigo/analytics/firebase_analytics_service.dart';
import 'package:visaamigo/core/config/env_config.dart';
import 'package:visaamigo/features/ai_assistant/models/ai_assistance_place_api.dart';
import 'package:visaamigo/features/ai_assistant/models/ai_prompt_model.dart';
import 'package:visaamigo/features/splash_screen/repo/user_detail_repo.dart';
import 'package:visaamigo/generated/l10n.dart';
import 'package:visaamigo/ui/base/base_provider.dart';
import 'package:visaamigo/utils/app_const.dart';
import 'package:visaamigo/utils/app_extensions.dart';

import '../../../generated/assets.dart';
import '../../../router/app_router.dart';
import '../../../router/app_routes_const.dart';
import '../../../utils/shared_preferences.dart';
import '../../../utils/utils.dart';
import '../../home/model/match_details.dart';
import '../../home/providers/navigation_provider.dart';
import '../../home/providers/tutorial_provider.dart';
import '../models/ai_get_preferences_questions_model.dart';
import '../models/ai_suggestions_model.dart';
import '../models/get_user_matches_model.dart';
import '../repo/ai_assistant_repo.dart';

class AiAssistantPromptsScreenProvider extends BaseProvider
    with WidgetsBindingObserver {
  // Prompts Screen Declarations
  final TextEditingController selectLocationController =
      TextEditingController();
  final TextEditingController promptsController = TextEditingController();
  ScrollController? promptsScrollController = ScrollController();
  UserDetailRepo? userDetailRepo;
  ValueNotifier<bool> isAtBottom = ValueNotifier<bool>(false);
  ValueNotifier<int> isSelectedPrompt = ValueNotifier<int>(-1);
  ValueNotifier<double> evaBottom = ValueNotifier<double>(0);
  ValueNotifier<bool> showSearch = ValueNotifier<bool>(false);
  ValueNotifier<bool> onTapSearch = ValueNotifier<bool>(false);
  ValueNotifier<PlacePredictions?> placePredictions =
      ValueNotifier<PlacePredictions?>(null);

  // PlacePredictions? placePredictions;
  final FocusNode focusNode = FocusNode();

  // Bool\'s for Suggestions Screen
  var isFadeAnimationEndForName = false;
  var isFadeAnimationEndForDescription = false;
  var isShowGridWidget = false;
  AiPromptModel? selectedPrompts;

  // bool showSearch = false;
  bool showTopFade = false;
  List<AiPromptModel>? initialPrompts;
  List<AiPromptModel>? prompts;
  List<MatchData>? uniqueStadiumMatch;
  String selectedLocation = "";
  String? languageCode;

  Timer? _debounce;

  // Mock Suggestion List
  List<AISuggestions>? listSuggestions = [];

  AiAssistantRepo? aiAssistantRepo;
  List<Questions>? listQuestions = [];

  List<Prediction> prefilledCities = [];

  //["1","2","6"]

  void init(BuildContext context) async {
    setContext(context);
    WidgetsBinding.instance.addObserver(this);
    isLoading = true;
    aiAssistantRepo = AiAssistantRepo(apiClient);
    focusChange();

    // Capture context before async operations to avoid BuildContext across async gaps
    final capturedContext = getContext();
    if (capturedContext.mounted) {
      promptsScrollController =
          Provider.of<NavigationProvider>(capturedContext, listen: false)
              .tabScrollControllers[AppRoutes.evaScreenIndex];
      promptsScrollController?.addListener(_onScroll);
    }

    await fetchPrompt();

    languageCode = await Preferences.getString(Preferences.keyLanguageCode);
    isLoading = false;
    await getUserMatches();
    await getPreferencesQuestions();
  }

  // Function to Get User Preferences Questions
  Future<void> getPreferencesQuestions() async {
    final response = await aiAssistantRepo
        ?.getPreferencesQuestions(AiGetPreferencesQuestionModel.fromJson);

    if (_isValidResponse(response)) {
      await _processValidResponse(response!);
    } else {
      _setEmptyQuestionsList();
    }
  }

  bool _isValidResponse(dynamic response) {
    return response != null && response.isSuccess && response.data != null;
  }

  Future<void> _processValidResponse(dynamic response) async {
    listQuestions = _processQuestions(response.data!.questions);
    await _saveQuestionsToPreferences();
    setState();
  }

  List<Questions> _processQuestions(List<Questions>? questions) {
    return questions?.map((question) => _processQuestion(question)).toList() ??
        [];
  }

  Questions _processQuestion(Questions question) {
    if (question.options != null) {
      final sortedOptions = _sortOptions(question.options!);
      return question.copyWith(options: sortedOptions);
    }
    return question;
  }

  List<Options> _sortOptions(List<Options> options) {
    final sortedOptions = List<Options>.from(options);
    sortedOptions.sort(_compareOptions);
    return sortedOptions;
  }

  int _compareOptions(Options a, Options b) {
    if (a.optionId == "no_preference") return 1;
    if (b.optionId == "no_preference") return -1;
    return 0;
  }

  Future<void> _saveQuestionsToPreferences() async {
    await Preferences.saveQuestionsList(listQuestions!);
  }

  void _setEmptyQuestionsList() {
    listQuestions = [];
  }

  void loadEvaTutorial() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Future.delayed(const Duration(milliseconds: 1500));
      if (AppRouter.currentRoute == AppRoutes.evaNav) {
        final tutorialProvider =
            Provider.of<TutorialProvider>(getContext(), listen: false);
        tutorialProvider.getEvaTutorialStatus(getContext());
      }
    });
  }

  // Function to Get User Matches
  Future<void> getUserMatches() async {
    final response =
        await aiAssistantRepo?.getUserMatches(GetUserMatchesModel.fromJson);

    if (response != null && response.isSuccess) {
      if (response.data != null) {
        final matches = response.data!.data!;

        // Create a set to keep track of added stadiums
        final Set<String> seenStadiums = {};

        // Filter only one match per stadium
        final uniqueStadiumMatches = <MatchData>[];

        for (final match in matches) {
          if (!seenStadiums.contains(
              "${match.matchCity}, ${match.matchState}, ${match.matchCountry}")) {
            seenStadiums.add(
                "${match.matchCity}, ${match.matchState}, ${match.matchCountry}");
            uniqueStadiumMatches.add(match);
          }
        }

        uniqueStadiumMatch = uniqueStadiumMatches;
        setState();
        // Pass only unique stadium matches to the function
        addMatchCities(uniqueStadiumMatches);
      }
    }
  }

  // Add Match Cities
  void addMatchCities(List<MatchData> matchCities) {
    var s = S.of(mContext);
    // Define prefilled cities list
    prefilledCities = matchCities.map((match) {
      return Prediction(
        description:
            "${match.matchCity!}, ${match.matchState!}, ${match.matchCountry!} [${s.match_city}]",
        matchedSubstrings: [],
        placeId: '',
        reference: '',
        structuredFormatting: StructuredFormatting(
          mainText: "${match.matchCity!} [${s.match_city}]",
          mainTextMatchedSubstrings: [],
          secondaryText: '',
        ),
        terms: [],
        types: [],
      );
    }).toList();

    getMatchCities();
  }

  // Get Match Cities
  void getMatchCities() {
    placePredictions.value = null;
    if (prefilledCities.isNotEmpty) {
      List<Prediction> allPredictions = [
        ...prefilledCities,
        ...?placePredictions.value?.predictions
      ];

      placePredictions.value =
          PlacePredictions(predictions: allPredictions, status: "OK");
    }
  }

  @override
  void didChangeMetrics() {
    evaBottom.value = WidgetsBinding
        .instance.platformDispatcher.views.first.viewInsets.bottom;
  }

  @override
  void dispose() {
    // promptsScrollController.removeListener(_onScroll);
    // promptsScrollController.dispose();
    _debounce?.cancel();
    focusNode.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  setTextData(BuildContext context) {
    return {
      "ticket_access": S.of(context).ticket_access,
      "find_hotels": S.of(context).find_hotels,
      "explore_off": S.of(context).explore_off,
      "dining_experience": S.of(context).dining_experience,
      "keep_customizing": S.of(context).keep_customizing,
      "highlights_you": S.of(context).highlights_you,
      "match_day": S.of(context).match_day,
      "hidden_gems": S.of(context).hidden_gems,
      "exceptional_menus": S.of(context).exceptional_menus,
      "stay_your_way": S.of(context).stay_your_way,
      "personal_preferences": S.of(context).personal_preferences,
      "must_see_attractions": S.of(context).must_see_attractions
    };
  }

  String? getPrompts(BuildContext context, String prompt) {
    final s = S.of(context);

    final localizedMap = {
      "match_day": s.match_day,
      "hidden_gems": s.hidden_gems,
      "exceptional_menus": s.exceptional_menus,
      "stay_your_way": s.stay_your_way,
      "must_see_attractions": s.must_see_attractions,
    };

    return localizedMap[prompt];
  }

  focusChange() {
    focusNode.addListener(() {
      onTapSearch.value = focusNode.hasFocus;
      if (onTapSearch.value) {
        if (uniqueStadiumMatch != null && uniqueStadiumMatch!.isNotEmpty) {
          addMatchCities(uniqueStadiumMatch!);
        }
        // getMatchCities();
        // EVENT_NAME_EVAASSISTANT_SEARCHINITIATE

        FirebaseAnalyticsService.logEvent(
            eventName:
                AnalyticsEventConst.EVENT_NAME_EVAASSISTANT_SEARCHINITIATE,
            parameters: {
              AnalyticsEventConst.PARAM_NAME_UI_ELEMENT: "search_bar"
            });
      }
    });
  }

  onTapSearchChange(bool _) {
    if (!_ && evaBottom.value > 50) {
      return;
    }
    onTapSearch.value = _;
  }

  clearLocationSearch() {
    selectLocationController.clear();
    showSearch.value = false;
    setState();
    placePredictions.value = null;
    setState();
  }

  changeLocation(String location) {
    FirebaseAnalyticsService.logEvent(
        eventName: "evaassistant_searchsubmitted",
        parameters: {
          AnalyticsEventConst.PARAM_NAME_UI_ELEMENT: "search_bar",
          "search_query": selectLocationController.text.toString()
        });

    selectedLocation = location.split('[').first.trim();
    selectLocationController.text = selectedLocation;
    setState();
    showSearch.value = false;
    Future.delayed(const Duration(milliseconds: 250), () {
      placePredictions.value = null;
      // selectedLocation = "";
      FocusManager.instance.primaryFocus?.unfocus();
      setState();
    });

    locationSave(selectedLocation);
  }

  // Load Goals From Json File
  Future<void> loadPromptsListFromJsonFile() async {
    if (initialPrompts == null || initialPrompts!.isEmpty) {
      initialPrompts =
          promptsFromJsonList(await Utils.loadJson(Assets.jsonPrompts));
    }
  }

  searchLocation() async {
    if (!selectLocationController.text.isNullOrEmpty) {
      if (_debounce?.isActive ?? false) _debounce!.cancel();
      _debounce = Timer(const Duration(milliseconds: 500), () {
        _fetchSuggestions();
      });
    } else {
      placePredictions.value = null;
      getMatchCities();
    }
  }

  void changePrompt(
      BuildContext context, AiPromptModel aiModelPrompts, int inx) async {
    // Capture context before async operations to avoid BuildContext across async gaps
    final capturedContext = context;
    selectedPrompts = aiModelPrompts;
    Utils.logPrint("selectedPrompts " + (selectedPrompts?.toJson()).toString());

    isSelectedPrompt.value = inx;
    // await Future.delayed(const Duration(milliseconds: 300));
    // isSelectedPrompt.value = -1;

    setState();
  }

  void resetPromtIndex() {
    isSelectedPrompt.value = -1;
    setState();
  }

  void changePromptOpenChat(
      BuildContext context, AiPromptModel aiModelPrompts, int inx) async {
    // Capture context before async operations to avoid BuildContext across async gaps
    final capturedContext = context;
    // await Future.delayed(const Duration(milliseconds: 300));
    isSelectedPrompt.value = -1;

    setState();

    switch (selectedPrompts?.id) {
      case 5:
        navigateToPersonalPreferenceScreen();
        break;
      case 1:
        navigateToAiAssistantThreadsScreen(
          Utils.getErrorMessageFromString('match_day'),
          selectLocationController.text.trim(),
          'match_day',
        );
        break;
      default:
        if (capturedContext.mounted) {
          navigateToAiAssistantThreadsScreen(
            getPrompts(capturedContext, selectedPrompts!.prompt)!,
            selectLocationController.text.trim(),
            selectedPrompts!.prompt,
          );
        }
    }

    FirebaseAnalyticsService.logEvent(
        eventName: "evaassistant_tilesclicked",
        parameters: {
          AnalyticsEventConst.PARAM_NAME_TILE_NAME:
              selectedPrompts?.prompt ?? "",
        });

    FirebaseAnalyticsService.logEvent(
      eventName: "evapreferences_screenview",
      parameters: {
        AnalyticsEventConst.PARAM_NAME_TILE_NAME: selectedPrompts?.prompt ?? ""
      },
    );
  }

  // Load Mock Suggestions From Json File
  Future<void> loadSuggestionsFromJsonFile() async {
    if (listSuggestions == null || listSuggestions!.isEmpty) {
      listSuggestions =
          suggestionFromJsonList(await Utils.loadJson(Assets.jsonSuggestions));
      setFadeAnimationEndForName(true);
      // Trigger UI update
      setState();
    }
  }

  // Function to set FadeAnimation Value set to true when finished
  void setFadeAnimationEndForName(bool value) {
    isFadeAnimationEndForName = value;
    // Trigger UI update
    setState();
  }

  // Function to set FadeAnimation Value set to true when finished
  void setFadeAnimationEndForDescription(bool value) {
    isFadeAnimationEndForDescription = value;
    // Trigger UI update
    setState();
  }

  // Function to set GridWidget Value set to true when finished
  void showGridWidget(bool value) {
    isShowGridWidget = value;
    // Trigger UI update
    setState();
  }

  locationSave(String location) async {
    await userDetailRepo?.updateUserPreference(
        "?update_type=know_your_user",
        {
          "preferences": {
            "location": ["$location"]
          }
        },
        (json) => (),
        false);
  }

  void _onScroll() {
    if (promptsScrollController != null &&
        promptsScrollController!.position.pixels - 10 >
            promptsScrollController!.position.minScrollExtent) {
      if (!isAtBottom.value) {
        isAtBottom.value = true;
      }
    } else {
      if (isAtBottom.value) {
        isAtBottom.value = false;
      }
    }
  }

  // Dynamically calculates item height based on index and screen width
  double calculateHeight(int index, BuildContext context) {
    // Base height based on screen width
    double baseHeight = context.screenWidth / 2;

    // Create variations based on the index
    if (index % 3 == 0) {
      return baseHeight * 0.8; // 0.8 times the base height
    } else if (index % 2 == 1) {
      return baseHeight * 0.7; // 0.7 times the base height
    } else {
      return baseHeight; // Standard base height
    }
  }

  void navigateToPersonalPreferenceScreen() {
    navPush(AppRoutes.personalPreferencesScreen);
  }

  void clearEditTextField() {
    promptsController.clear();
    // selectLocationController.clear();
  }

  Future<void> _fetchSuggestions() async {
    if (selectLocationController.text.trim().isEmpty) {
      placePredictions.value = null;
      getMatchCities();
      return;
    }

    showSearch.value = true;

    final rep = await http.get(Uri.parse(AppConst.evaGoogleLocation(
        selectLocationController.text.trim(),
        languageCode!,
        EnvConfig.googlePlacesApiKey)));
    if (rep.statusCode == 200 || rep.statusCode == 201) {
      final json = jsonDecode(rep.body);
      placePredictions.value = PlacePredictions.fromJson(json);
    } else {
      getMatchCities();
    }
  }

  void animateScrollBackToOriginalPosition() {
    final context = getContext();
    final controller = Provider.of<NavigationProvider>(context, listen: false)
        .tabScrollControllers[AppRoutes.evaScreenIndex];

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (controller.hasClients) {
        controller.animateTo(
          0.0,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      } else {
        Utils.logPrint("ScrollController has no clients.");
      }
    });
  }

  // Navigate to the AiAssistant Thread's(Q/A) Screen
  void navigateToAiAssistantThreadsScreen(
      String evaQuestion, String location, String sectionId) {
    navGo(AppRoutes.evaChatScreenNav, extra: {
      "eva_question": evaQuestion.replaceAll("\n", " "),
      "location": location,
      "section": sectionId,
    });
  }

  updatePrompts() {
    prompts = prompts;
    setState();
  }

  Future<void> fetchPrompt({bool isComeFromOutsideProvider = false}) async {
    Utils.logPrint("fetchPromt ");
    await loadPromptsListFromJsonFile();

    userDetailRepo = UserDetailRepo(apiClient);

    final rep = await userDetailRepo?.getUserPreference((json) => {});
    Utils.logPrint("fetchPromt rep $rep");

    Map<dynamic, dynamic> data = rep?.data ?? {};
    focusNode.addListener(() {
      if (!focusNode.hasFocus) {
        // _removeOverlay();
      }
    });

    Utils.logPrint("fetchPromt data $data");

    if (data.isNotEmpty &&
        data.containsKey("status_code") &&
        data["status_code"] == 200 &&
        data.containsKey("data")) {
      if (data["data"].containsKey("location")) {
        selectLocationController.text =
            decodeIfHex(data["data"]["location"][0]);
        selectedLocation = data["data"]["location"][0];
      }
      initialPrompts?.insert(
          4,
          AiPromptModel(
              id: 5, prompt: "personal_preferences", desc: "keep_customizing"));

      if (data["data"].containsKey("trip_goal")) {
        List<int> ids = (data["data"]["trip_goal"] as List)
            .map((id) => int.tryParse(id.toString()) ?? -1)
            .where((id) => id != -1)
            .toList();

        List<AiPromptModel> existingPrompts = List.from(initialPrompts ?? []);

        Map<int, AiPromptModel> promptMap = {
          for (var model in existingPrompts) model.id: model
        };

        prompts = ids
            .map((id) => promptMap[id])
            .where((model) => model != null)
            .cast<AiPromptModel>()
            .toList();
      } else {
        prompts = initialPrompts;
      }

      setState();
    } else {
      initialPrompts?.insert(
          4,
          AiPromptModel(
              id: 5, prompt: "personal_preferences", desc: "keep_customizing"));
      prompts = initialPrompts;
      setState();
    }

    // Only set preferences and load tutorial if prompts are not empty
    if (prompts != null && prompts!.isNotEmpty && !isComeFromOutsideProvider) {
      // Load EVA Tutorial For First Time Load
      await Preferences.setBool(Preferences.isPromptListLoaded, true);
      loadEvaTutorial();
    }

    Utils.logPrint(
        "fetchPromt userDetailRepo ${userDetailRepo == null ? "null" : "not null"} ");
  }

  String decodeIfHex(String? value) {
    if (value == null) return '';
    // Check if the string matches hex pattern: only \xNN sequences
    final hexPattern = RegExp(r'^(\\x[0-9a-fA-F]{2})+?$');
    if (hexPattern.hasMatch(value)) {
      return Utils.convrtStringUtf(value);
    } else {
      return value;
    }
  }
}
