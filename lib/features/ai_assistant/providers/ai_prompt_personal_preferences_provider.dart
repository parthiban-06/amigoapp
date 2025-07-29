import 'dart:async';

import 'package:flutter/material.dart';
import 'package:visaamigo/ui/base/base_provider.dart';
import 'package:visaamigo/utils/shared_preferences.dart';
import 'package:visaamigo/utils/utils.dart';

import '../../../analytics/firebase_analytics_service.dart';
import '../models/ai_get_preferences_questions_model.dart';
import '../repo/ai_assistant_repo.dart';

class AiPromptPersonalPreferencesProvider extends BaseProvider {
  AiAssistantRepo? aiAssistantRepo;
  List<Questions>? listQuestions = [];
  double appBarTotalHeight = 0.0;
  ScrollController promptsScrollController = ScrollController();
  ValueNotifier<bool> isAtBottom = ValueNotifier<bool>(false);
  Timer? _debounceTimer; // Declare at the class level

  void init(BuildContext context) {
    appBarTotalHeight = MediaQuery.paddingOf(context).top + kToolbarHeight;
    aiAssistantRepo = AiAssistantRepo(apiClient);
    promptsScrollController.addListener(_onScroll);
    // FUnction To Get Personal Preferences Question List From Preferences
    getPersonalPreferencesQuestions();
  }

  // Function to toggle chip selection
  void toggleChipSelection(int parentIndex, int chipIndex) {
    if (parentIndex < 0 || parentIndex >= listQuestions!.length) return;
    if (chipIndex < 0 ||
        chipIndex >= listQuestions![parentIndex].options!.length) {
      return;
    }

    final selectedOption = listQuestions![parentIndex].options![chipIndex];

    // Create a new list of options to update state immutably
    List<Options> updatedOptions =
        listQuestions![parentIndex].options!.map((option) {
      if (selectedOption.optionId == "no_preference") {
        // If "no_preference" is selected, all others must be deselected
        return option.copyWith(isSelected: option.optionId == "no_preference");
      } else {
        // Deselect "no_preference" and toggle the selected option
        if (option.optionId == "no_preference") {
          return option.copyWith(isSelected: false);
        } else if (option.optionId == selectedOption.optionId) {
          return option.copyWith(
              isSelected: !(selectedOption.isSelected ?? false));
        }
        return option;
      }
    }).toList();

    // Update the parent question with new options list
    listQuestions![parentIndex] =
        listQuestions![parentIndex].copyWith(options: updatedOptions);

    setState();
  }

// Fetches user preference questions from local storage
  Future<void> getPersonalPreferencesQuestions() async {
    // isLoading = true;
    // await Future.delayed(
    //     const Duration(seconds: 1)); // Brief delay for smoother UX
    // Load questions from SharedPreferences
    listQuestions = await Preferences.getQuestionsList();
    // isLoading = false;
    setState(); // Refresh UI with updated data
  }

  // Function to Update User Preferences Options
  Future<void> updatePreferenceOption(List<Questions>? listQuestions) async {
    Map<String, dynamic> convertedMap =
        generateSelectedPreferencesJson(listQuestions);
    isLoading = true;
    final response = await aiAssistantRepo?.updatePreferenceOption(
        AiGetPreferencesQuestionModel.fromJson, convertedMap);

    if (response != null && response.isSuccess) {
      if (response.data != null) {
        // Save Questions List In Shared Preferences After Update
        await Preferences.saveQuestionsList(listQuestions!);
        isLoading = false;
      } else {
        isLoading = false;
      }
      navPop();
    } else {
      isLoading = false;
    }
  }

  // Function to Generate Selected Preferences
  Map<String, dynamic> generateSelectedPreferencesJson(
      List<Questions>? listQuestions) {
    String selectedPreferences = "";
    if (listQuestions == null) {
      return {'preferences': []}; // Return empty if no questions
    }

    List<Map<String, dynamic>> preferences = listQuestions.map((question) {
      // Get only selected options (where isSelected == true)
      List<String> selectedOptions = question.options
              ?.where((option) => option.isSelected == true)
              .map((option) => option.optionId ?? '')
              .where((id) => id.isNotEmpty)
              .toList() ??
          [];

      if (selectedOptions.isNotEmpty) {
        selectedPreferences =
            "$selectedPreferences${(question.questionKey ?? "")}-${selectedOptions?.join(',').toString().trim() ?? ''}|";
      }

      Utils.logPrint("selectedPreferences ${selectedPreferences}");
      // selectedPreferences = selectedOptions

      // If no options are selected, still include question_id with empty array
      return {
        'question_id': question.questionId,
        'selected_options': selectedOptions,
        // Will be [] if nothing is selected
      };
    }).toList();

    FirebaseAnalyticsService.logEvent(
      eventName: "evapreferences_saved",
      parameters: {
        AnalyticsEventConst.PARAM_NAME_TILE_NAME: "personal_preferences",
        "selected_preferences": selectedPreferences
      },
    );
    return {'preferences': preferences};
  }

  void _onScroll() {
    final position = promptsScrollController.position;
    const threshold = 100.0; // Adjust sensitivity

    // Cancel the previous timer if still running
    _debounceTimer?.cancel();

    _debounceTimer = Timer(const Duration(milliseconds: 100), () {
      final isNearBottom =
          position.pixels >= position.maxScrollExtent - threshold;

      if (isAtBottom.value != isNearBottom) {
        isAtBottom.value = isNearBottom;
      }
    });
  }

  @override
  void dispose() {
    promptsScrollController.removeListener(_onScroll);
    promptsScrollController.dispose();
    _debounceTimer?.cancel();
    super.dispose();
  }
}
