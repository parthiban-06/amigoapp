import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:visaamigo/features/ai_assistant/models/ai_assist_question.dart';
import 'package:visaamigo/ui/base/base_provider.dart';

import '../../../utils/utils.dart';
import '../models/ai_chat_model.dart';
import '../models/ai_chat_response.dart';
import '../models/ai_messages_model.dart';
import '../repo/ai_assistant_repo.dart';

/// Data class to hold scroll position information
class ScrollInfo {
  final double currentScroll;
  final bool isAtBottom;
  final bool isAtTop;

  ScrollInfo({
    required this.currentScroll,
    required this.isAtBottom,
    required this.isAtTop,
  });
}

class AiAssistantThreadsScreenProvider extends BaseProvider {
  // Thread Screen Declarations
  final TextEditingController threadController = TextEditingController();
  final List<Message> messages = [];
  final ScrollController aiChatScrollController = ScrollController();

  // Mock AIChatModel
  AIChatModel? aiChatModel;
  AiAssistantRepo? aiAssistantRepo;
  var isAiLoading = true;
  var isFabVisible = false;

  String sessionID = "c9bd7d39-3611-4f73-a02a-e9cd5120c52b";
  String location = "";
  String? userNameInitial = '';

  // Set to true if the list should load in reverse order (bottom to top), false for normal order (top to bottom)
  var isListReverse = false;

  // Set to true to enable animation on the list, false to disable animation
  var isShowListAnimation = false;

  void init(String evaQuestion, String userLocation) async {
    Utils.logPrint("message init -- $evaQuestion --- $userLocation");

    threadController.text = evaQuestion;
    location = userLocation;
    aiAssistantRepo = AiAssistantRepo(apiClient);
    userNameInitial = await amplifyService.getUserIntial();
    sendMessage();
    setState();
  }

  // Load Mock AIChat From JSON File
  Future<void> loadAiChatFromJsonFile() async {
    // if (aiChatModel != null) return; // Exit if AIChatModel is already loaded
    //
    // // Load and parse AIChatModel from JSON
    // final jsonData = await Utils.loadJsonMap(Assets.jsonAiMockChat);
    // aiChatModel = AIChatModel.fromJson(jsonData);
    //
    // // Add the first initial question to messages, if available
    // final initialQuestion = aiChatModel?.initialQuestions?.first;
    // if (initialQuestion != null) {
    //   addMessage('ai', initialQuestion.text ?? "",
    //       initialQuestion: initialQuestion,
    //       followUpQuestions: null,
    //       dynamicResponse: null);
    // }
    // Trigger UI update
    // setState();
  }

  // Handle user choice and update chat
  void handleUserChoice(Choices choice) {
    // Add user's choice to the chat
    addMessage('user', choice.text ?? "",
        initialQuestion: null, followUpQuestions: null, dynamicResponse: null);
    scrollToBottomThreads();

    // Show loading indicator
    isAiLoading = true;
    // Trigger UI update
    // setState();

    // Simulate delay for AI response
    Future.delayed(const Duration(seconds: 3)).then((_) {
      // Find matching AI response for the user's choice
      final response = aiChatModel?.responses?.firstWhere(
        (resp) => resp.choiceId == choice.id,
        orElse: () => Responses(), // Default empty response
      );

      // Add AI response to the chat
      if (response != null) {
        final followUp = response.followUpQuestions?.first;
        final dynamicRes = response.dynamicResponse;
        final aiText = [
          response.responseText, // AI response text
          followUp?.text // Follow-up question (if any)
        ].where((text) => text?.isNotEmpty ?? false).join("\n");

        addMessage('ai', aiText,
            initialQuestion: null,
            followUpQuestions: followUp,
            dynamicResponse: dynamicRes);
        scrollToBottomThreads();
      }

      // Hide loading indicator
      isAiLoading = false;
      // Trigger UI update
      // setState();
    });
  }

  // Sends a message, updates the UI, clears the input, and scrolls to the bottom.
  Future<void> sendMessage() async {
    if (threadController.text.trim().isNotEmpty) {
      isAiLoading = true;
      // isLoading = true;
      addMessage('user', threadController.text.trim(),
          initialQuestion: null,
          followUpQuestions: null,
          dynamicResponse: null);

      AiAssistQuestion aiAssistQuestion = AiAssistQuestion(
          query: threadController.text.trim(),
          city: location,
          sessionId: sessionID);

      Utils.logPrint("response ${aiAssistQuestion.toApiJson()}");

      addMessage('ai', threadController.text.trim(),
          initialQuestion: null,
          followUpQuestions: null,
          dynamicResponse: null);
      return;
      threadController.clear();
      final response = await aiAssistantRepo?.getMessage(
          aiAssistQuestion!.toApiJson(), AiChatResponse.fromJson);

      if (response != null && response.isSuccess) {
        sessionID = response.data?.sessionId ?? "";

        validateAiResponse(response.data);
      } else {}
      isAiLoading = false;
      setState();
    }
  }

  // Add a new message to the conversation
  void addMessage(
    String role,
    String message, {
    InitialQuestions? initialQuestion,
    FollowUpQuestions? followUpQuestions,
    DynamicResponse? dynamicResponse,
    AiChatResponse? aiChatResponse,
  }) {
    // Validate the role to ensure it is either 'user' or 'ai'
    if (role != "user" && role != "ai") {
      throw ArgumentError("Role must be either 'user' or 'ai'.");
    }

    // isAiLoading = false;
    // setState();
    // Create and add the new message to the messages list
    messages.add(
      Message(
          sessionId: "",
          role: role,
          message: message,
          initialQuestions: initialQuestion,
          followUpQuestions: followUpQuestions,
          dynamicResponse: dynamicResponse,
          aiCharResponse: aiChatResponse),
    );
    scrollToBottomThreads();
    setState();
  }

  /// Listener method to monitor the scroll direction of the ListView and control the visibility
  /// of the Floating Action Button (FAB).
  void scrollControllerListener() {
    aiChatScrollController.addListener(() {
      final position = aiChatScrollController.position;
      final scrollInfo = _getScrollInfo(position);
      final isUserScrolling = _isUserScrolling(position);

      _handleAnimationStateUpdate(isUserScrolling);
      _handleLoadMoreData(scrollInfo);
      _handleFabVisibilityAndAnimation(scrollInfo, isUserScrolling, position);
    });
  }

  /// Extracts scroll position information
  ScrollInfo _getScrollInfo(ScrollPosition position) {
    final currentScroll = position.pixels;
    final isAtBottom = isListReverse
        ? currentScroll <= position.minScrollExtent
        : currentScroll >= position.maxScrollExtent;
    final isAtTop = isListReverse
        ? currentScroll >= position.maxScrollExtent
        : currentScroll <= position.minScrollExtent;

    return ScrollInfo(
      currentScroll: currentScroll,
      isAtBottom: isAtBottom,
      isAtTop: isAtTop,
    );
  }

  /// Checks if user is actively scrolling
  bool _isUserScrolling(ScrollPosition position) {
    return position.userScrollDirection != ScrollDirection.idle;
  }

  /// Updates animation state when user stops scrolling
  void _handleAnimationStateUpdate(bool isUserScrolling) {
    if (!isUserScrolling && !isShowListAnimation) {
      isShowListAnimation = true;
      setState();
    }
  }

  /// Handles loading more data when reaching scroll boundaries
  void _handleLoadMoreData(ScrollInfo scrollInfo) {
    final shouldLoadMore = (isListReverse && scrollInfo.isAtTop) ||
        (!isListReverse && scrollInfo.isAtBottom);
    if (shouldLoadMore) {
      // loadMoreData();
    }
  }

  /// Controls FAB visibility and list animation state
  void _handleFabVisibilityAndAnimation(
      ScrollInfo scrollInfo, bool isUserScrolling, ScrollPosition position) {
    final shouldShowFab = _shouldShowFab(position);

    if (scrollInfo.isAtBottom) {
      _handleBottomScrollAnimation();
    } else {
      _handleNonBottomScrollAnimation(isUserScrolling, shouldShowFab);
    }
  }

  /// Determines if FAB should be shown based on scroll direction
  bool _shouldShowFab(ScrollPosition position) {
    return isListReverse
        ? position.userScrollDirection == ScrollDirection.reverse
        : position.userScrollDirection == ScrollDirection.forward;
  }

  /// Handles animation state when at bottom
  void _handleBottomScrollAnimation() {
    if (!isShowListAnimation) {
      isShowListAnimation = true;
      // setState();
    }
  }

  /// Handles animation state when not at bottom
  void _handleNonBottomScrollAnimation(
      bool isUserScrolling, bool shouldShowFab) {
    if (!isUserScrolling) {
      isShowListAnimation = !isFabVisible;
    } else {
      isShowListAnimation = false;
    }

    if (shouldShowFab != isFabVisible) {
      isFabVisible = shouldShowFab;
      // setState();
    }
  }

  /// Smoothly scrolls the ListView to the bottom to show the latest message.
  void scrollToBottomThreads() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (aiChatScrollController.hasClients) {
        final targetPosition = isListReverse
            ? aiChatScrollController
                .position.minScrollExtent // For reverse, scroll to the top
            : aiChatScrollController
                .position.maxScrollExtent; // For normal, scroll to the bottom

        aiChatScrollController
            .jumpTo(targetPosition); // ✅ Instant scroll (no animation)

        // aiChatScrollController.animateTo(targetPosition,
        //     duration: const Duration(milliseconds: 300),
        //     curve: Easing.standard);
      }
    });
  }

  void validateAiResponse(AiChatResponse? aiChatResponse) {
    addMessage('ai', aiChatResponse!.initialText!,
        initialQuestion: null,
        followUpQuestions: null,
        aiChatResponse: aiChatResponse,
        dynamicResponse: null);
  }

  void removeLastConversionToEdit(String message) {
    messages.removeLast();
    messages.removeLast();
    scrollToBottomThreads();
    threadController.text = message;

    setState();
  }

  @override
  void dispose() {
    aiChatScrollController.dispose();
    threadController.dispose();
    super.dispose();
  }
}
