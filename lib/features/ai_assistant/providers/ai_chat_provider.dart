import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:visaamigo/features/ai_assistant/models/ai_chat_history.dart';
import 'package:visaamigo/features/ai_assistant/models/ai_search_places_model.dart';
import 'package:visaamigo/features/home/providers/home_provider.dart';
import 'package:visaamigo/features/rate_us/widgets/rateus_popup.dart';
import 'package:visaamigo/features/splash_screen/repo/user_detail_repo.dart';
import 'package:visaamigo/remote/api_response.dart';
import 'package:visaamigo/ui/base/base_provider.dart';
import 'package:visaamigo/utils/amplify_service.dart';
import 'package:visaamigo/utils/app_const.dart';
import 'package:visaamigo/utils/app_extensions.dart';
import 'package:visaamigo/utils/date_util.dart';
import 'package:visaamigo/utils/utils.dart';

import '../../../analytics/firebase_analytics_service.dart';
import '../../../custom_widgets/visa_snack_bar.dart';
import '../../../generated/l10n.dart';
import '../../../router/app_routes_const.dart';
import '../../../utils/shared_preferences.dart';
import '../../home/providers/navigation_provider.dart';
import '../../wallet/widgets/wallet_popup_travel_credit.dart';
import '../models/ai_assist_question.dart';
import '../models/ai_chat_response.dart';
import '../models/ai_get_preferences_questions_model.dart';
import '../models/ai_submit_feedback_model.dart';
import '../repo/ai_assistant_repo.dart';
import '../screens/ai_assistant_chat_screens/ai_message.dart';
import 'message_loading_more_list.dart';

/// Data class to hold message information for typewriter effect
class MessageInfo {
  final Message message;
  final int index;
  final String fullText;
  int currentIndex;

  MessageInfo({
    required this.message,
    required this.index,
    required this.fullText,
    this.currentIndex = 0,
  });
}

class ChatProvider extends BaseProvider {
  MessageLoadingMoreList? _messagesList;
  bool _isChatloading = false;
  bool isTyping = false;
  String? _editingMessageId;
  Timer? _typewriterTimer;
  String? userNameInitial = '';
  String? sessionId = '';
  String? userLocation = '';
  String? previousQuestion = '';
  String? section = '';
  UserDetailRepo? userDetailRepo;
  List<Questions>? filteredQuestions = [];

  ValueNotifier<bool> isAtBottom = ValueNotifier<bool>(false);
  ValueNotifier<double> loaderOpacity = ValueNotifier<double>(1.0);

  bool isContinueButtonSelected = false;

  bool get continueSelected => isContinueButtonSelected;

  final TextEditingController textController = TextEditingController();
  final TextEditingController textEditController = TextEditingController();
  final ScrollController scrollController = ScrollController();
  final FocusNode editFocusNode = FocusNode();

  MessageLoadingMoreList? get messagesList => _messagesList;

  List<Message> get messages => _messagesList?.map((e) => e).toList() ?? [];

  bool get isChatloading => _isChatloading;

  String? get editingMessageId => _editingMessageId;

  AiAssistantRepo? aiAssistantRepo;

  double oldScrollOffset = 0;
  bool likeDislikePressed = false;

  // Message? loaderItem;
  Message? loaderShimmerEffect;
  bool? isEdit = false;

  List<Message> editedMessage = [];

  String firstSection = "";

  Future<void> init(BuildContext context, String evaQuestion, String location,
      String section, String fetchSessionId) async {
    setContext(context);
    FirebaseAnalyticsService.firstEvaSection = section;
    firstSection = section;
    aiAssistantRepo = AiAssistantRepo(apiClient);
    userNameInitial = await amplifyService.getUserIntial();
    scrollController.addListener(_onScroll);
    _messagesList = MessageLoadingMoreList(sessionId!, aiAssistantRepo!);

    Utils.logPrint("isEdit $isEdit -- $isTyping");
    isTyping = false;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (scrollController.hasClients) {
        oldScrollOffset = scrollController.offset;
      }
    });
    textController.text = evaQuestion;
    userLocation = location;
    this.section = section;

    loaderShimmerEffect = Message(
        id: "loaderShimmerEffect",
        editId: "loaderShimmerEffect",
        text: "loaderShimmerEffect",
        isUser: false,
        timestamp: DateTime.now(),
        aiChatResponse: null);

    // sessionId = "e7de8786-7dd6-4c6a-b425-260f57889699";
    if (!fetchSessionId.isNullOrEmpty) {
      sessionId = fetchSessionId;
      _messagesList = MessageLoadingMoreList(sessionId!, aiAssistantRepo!);

      updateChatLoadingStatus(true);
      await _messagesList?.refresh(false);
    }

    if (evaQuestion.isNotEmpty) {
      sessionId = "";
      _messagesList?.clear();
      // sessionId = "38dad742-d94e-4367-909a-5a4799918d61";
      sendMessage(evaQuestion, section, editMessageId: evaQuestion);
    }

    setState();
  }

  @override
  void dispose() {
    _typewriterTimer?.cancel();
    super.dispose();
  }

  void setEditingMessageId(String? id) {
    _editingMessageId = id;
    setState();
  }

  void updateChatLoadingStatus(bool status) {
    _isChatloading = status;

    if (loaderShimmerEffect != null && _messagesList != null) {
      if (_isChatloading) {
        if (!_messagesList!.contains(loaderShimmerEffect)) {
          // _messagesList!.insert(0, loaderItem!);
        }
        _messagesList!.insert(0, loaderShimmerEffect!);
      } else {
        _messagesList?.remove(loaderShimmerEffect!);
        // messagesList?.remove(loaderShimmerEffect!);
      }
      setState();
    }
  }

  // Function To Send Message
  Future<void> sendMessage(String text, String section,
      {String? editMessageId, bool isUpdateMessage = false}) async {
    if (text.trim().isEmpty) return;

    Utils.logPrint("editingMessageId wewe $editMessageId");
    // Announce Question
    Utils.announceMessage("$text ${S.of(getContext()).message_sent}");

    previousQuestion = text;
    isTyping = true;
    likeDislikePressed = false;
    this.section = section;
    setState();
    isEdit = false;

    editMessageId = (editMessageId == null || editMessageId.isEmpty)
        ? DateTime.now().millisecondsSinceEpoch.toString()
        : editMessageId;
    handleUserMessage(text, editMessageId);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      scrollToTop();
    });

    try {
      if (section.isEmpty || section == 'match_day') {
        await handleAiChatFlow(text.trim(), editMessageId, isUpdateMessage);
      } else {
        await handleSectionBasedQuestions(section, editMessageId);
      }
    } catch (e) {
      Utils.logPrint("error - $e");
      _handleChatError();
    }
  }

  void scrollToTopNew() {
    if (scrollController.hasClients) {
      scrollController.jumpTo(0.0);
    }
  }

  void removeChatWithMessageId(String? editMessageId) {
    final indexesToRemove = <int>[];
    for (int i = 0; i < messages.length; i++) {
      if (messages[i].editId == editMessageId) {
        indexesToRemove.add(i);
      }
    }

    Utils.logPrint("indexesToRemove $indexesToRemove");
    // Remove in reverse order to avoid shifting indices
    for (final index in indexesToRemove.reversed) {
      _messagesList?.removeAt(index);
    }
    _editingMessageId = null;
    sendMessage(textEditController.text.trim(), '',
        editMessageId: editMessageId, isUpdateMessage: true);
  }

  void handleUserMessage(String text, String editMessageId) {
    /* if (editMessageId != null) {
      final index = messages.indexWhere((msg) => msg.id == editMessageId);
      if (index != -1) {
        final updatedMessage = messages[index].copyWith(text: text);
        // We need to update the message in the LoadingMoreList
        if (_messagesList != null) {
          _messagesList![index] = updatedMessage;
        }
      }
      _editingMessageId = null;
    } else {

    }*/
    final newMessage = Message(
      id: editMessageId,
      editId: editMessageId,
      text: text,
      isUser: true,
      timestamp: DateTime.now(),
      aiChatResponse: null,
      displayText: text,
    );

    // Initialize the _messagesList if it's null (first message)
    // _messagesList ??= MessageLoadingMoreList(sessionId ?? "", aiAssistantRepo!);

    // Add the new message - using add for reversed list
    _messagesList!.addMessage(newMessage);

    textController.clear();
    textEditController.clear();
    updateChatLoadingStatus(true);
    setState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      scrollToTop();
    });
  }

  void clearAllPreviousState(bool showRateUs) {
    isTyping = false;
    editedMessage.clear();
    textController.clear();
    textEditController.clear();
    messages.clear();
    messagesList?.clear();
    _messagesList?.clear();
    filteredQuestions?.clear();
    sessionId = "";
    isTyping = false;
    previousQuestion = "";
    _editingMessageId = null;
    apiClient.cancelCurrentRequest();
    _typewriterTimer?.cancel();
    clearPagination();
    cancelEditChat();
    if (showRateUs) {
      getChatHistory();
    }
  }

  getChatHistory() async {
    final rateUs = await Preferences.getBool(Preferences.isRateUs);
    if (rateUs == false) {
      var response =
          await aiAssistantRepo?.getChatHistory(AiChatHistory.fromDataJson);

      if (response != null &&
          response.isSuccess &&
          response.data != null &&
          response.data!.isNotEmpty &&
          response.data!.length >= 3) {
        userDetailRepo = UserDetailRepo(apiClient);
        await Preferences.setBool(Preferences.isRateUs, true);
        userDetailRepo?.updateUserPreferenceKnowYourUser({
          "rate_us": ["true"]
        }, (json) => (), false);

        Future.delayed(const Duration(milliseconds: 200), () {
          Utils.rateUsPopup(
              context: AmplifyService.context!,
              child: const RateUsPopup(
                isDouble: false,
              ));
        });
      }
    }
  }

  Future<void> handleAiChatFlow(
      String text, String messageId, bool isUpdateMessage) async {
    final responses =
        await _fetchResponsesFromServer(text, isUpdateMessage, messageId);
    if (responses == null) {
      Utils.logPrint(Utils.getErrorMessageFromString('null_ai_response'));
      Utils.announceMessage(
          Utils.getErrorMessageFromString('null_ai_response'));
      return;
    }

    Utils.logPrint("responses ${responses.questionId}");

    if (responses.initialText!.isEmpty && responses.finalText!.isEmpty) {
      _handleChatError();
      visaSnackBar(
          context: getContext(),
          title: "${S.of(getContext()).error}!",
          type: SnackBarType.failure,
          subtitle: S.of(getContext()).problem_processing);
      return;
    }

    // final lastIndex = _messagesList!.length - 1;
    final updated = _messagesList![1].copyWith(editId: responses.questionId!);
    _messagesList![1] = updated;

    // 1. Show initialText with typewriter effect
    await _addTypewriterBotMessage(responses.initialText ?? "", responses,
        msgId: responses.questionId,
        isInitialTextEmpty: responses.initialText?.isNullOrEmpty ?? false);

    await Future.delayed(const Duration(milliseconds: 500));

    // 2. Show finalText with typewriter effect
    await _addTypewriterBotMessage(responses.finalText ?? "", responses,
        isFinal: true,
        msgId: responses.questionId,
        isInitialTextEmpty: responses.initialText?.isNullOrEmpty ?? false);
  }

  Future<void> handleSectionBasedQuestions(
      String section, String? messageId) async {
    final questionsList = await Preferences.getQuestionsList();
    final filteredQuestions =
        getQuestionsBySection(section, questionsList ?? []);

    if (filteredQuestions.isEmpty) return;

    // Find the first primary question (if any)
    final primaryQuestion = filteredQuestions.firstWhere(
      (q) => q.isPrimary == true,
      orElse: () => filteredQuestions.first,
    );

    //await Future.delayed(const Duration(milliseconds: 500));

    await _addTypewriterBotMessage(
        Utils.getErrorMessageFromString(primaryQuestion.questionKey ?? ""),
        null,
        msgId: messageId);

    await Future.delayed(const Duration(milliseconds: 500));
    await _addTypewriterBotMessage(getPrompts(section) ?? '', null,
        isFinal: true, question: primaryQuestion, msgId: messageId);
  }

  Future<void> _addTypewriterBotMessage(
    String text,
    AiChatResponse? response, {
    bool isFinal = false,
    bool isInitialTextEmpty = false,
    String? msgId,
    Questions? question,
  }) async {
    final trimmedText = text.trim();

    final id = msgId ?? DateTime.now().millisecondsSinceEpoch.toString();

    final botMessage = Message(
      id: id,
      editId: id,
      text: trimmedText,
      isUser: false,
      timestamp: DateTime.now(),
      isTyping: true,
      displayText: "",
      aiChatResponse: response,
      questions: question,
      isFinalText: trimmedText.isEmpty ? false : isFinal,
      isFinalTextEmpty: isFinal ? trimmedText.isEmpty : false,
      isInitialTextEmpty: isInitialTextEmpty,
    );

    _messagesList!.addMessage(botMessage, position: 1);
    updateChatLoadingStatus(false);
    setState();

    if (isFinal && response?.type == AppConst.getSearchPlacesKey) {
      await _addPlacesProgressively(trimmedText, response, messageId: id);
    } else if (isFinal && response?.type == AppConst.bookingKey) {
      await _addBookingHotelsProgressively(trimmedText, response,
          messageId: id);
    } else {
      await _startTypewriterEffect(id);
    }

    if (isFinal) {
      isTyping = false;
      setState();
    }
  }

  Future<void> _addPlacesProgressively(
    String text,
    AiChatResponse? response, {
    required String messageId,
  }) async {
    final index = _messagesList!.indexWhere((m) => m.id == messageId);
    if (index == -1) return;

    final originalMessage = _messagesList![index];
    final places = response!.data.first.items.places;

    for (int i = 0; i < places.length; i++) {
      final currentPlaces = places.sublist(0, i + 1);

      final updatedItems = response.data.first.items.copyWith(
        places: currentPlaces,
      );

      final updatedDatum = response.data.first.copyWith(
        items: updatedItems,
      );

      final updatedResponse = response.copyWith(
        data: [updatedDatum],
      );

      final updatedAnimatedIndexes = Map<String, Set<int>>.from(
          originalMessage.animatedPlaceIndexes ?? {});
      final currentAnimatedSet =
          Set<int>.from(updatedAnimatedIndexes[messageId] ?? {});
      currentAnimatedSet.add(i);
      updatedAnimatedIndexes[messageId] = currentAnimatedSet;

      final updatedMessage = originalMessage.copyWith(
        response: updatedResponse,
        animatedPlaceIndexes: updatedAnimatedIndexes,
        isTyping: true,
        displayText: "",
        showTextWithAnimation: false,
      );

      _messagesList![index] = updatedMessage;
      setState();

      if (i == places.length - 1) {
        await Future.delayed(const Duration(milliseconds: 500));

        // Update only showTextWithAnimation to true
        final finalUpdate = updatedMessage.copyWith(
          isTyping: false,
          displayText: (i == places.length - 1) ? text : "",
        );
        _messagesList![index] = finalUpdate;
        setState();

        await Future.delayed(const Duration(milliseconds: 500));

        // Update only showTextWithAnimation to true
        final finalUpdate2 = updatedMessage.copyWith(
          isTyping: false,
          showTextWithAnimation: (i == places.length - 1) ? true : false,
        );
        _messagesList![index] = finalUpdate2;
        setState();
      }
      await Future.delayed(const Duration(milliseconds: 800));
    }
  }

  Future<void> _addBookingHotelsProgressively(
    String text,
    AiChatResponse? response, {
    required String messageId,
  }) async {
    final index = _messagesList!.indexWhere((m) => m.id == messageId);
    if (index == -1) return;

    final originalMessage = _messagesList![index];
    final hotels = response!.data.first.items.hotels;

    for (int i = 0; i < hotels.length; i++) {
      final currentHotel = hotels.sublist(0, i + 1);

      final updatedItems = response.data.first.items.copyWith(
        hotels: currentHotel,
      );

      final updatedDatum = response.data.first.copyWith(
        items: updatedItems,
      );

      final updatedResponse = response.copyWith(
        data: [updatedDatum],
      );

      final updatedAnimatedIndexes = Map<String, Set<int>>.from(
          originalMessage.animatedPlaceIndexes ?? {});
      final currentAnimatedSet =
          Set<int>.from(updatedAnimatedIndexes[messageId] ?? {});
      currentAnimatedSet.add(i);
      updatedAnimatedIndexes[messageId] = currentAnimatedSet;

      final updatedMessage = originalMessage.copyWith(
        response: updatedResponse,
        animatedPlaceIndexes: updatedAnimatedIndexes,
        isTyping: true,
        displayText: "",
        showTextWithAnimation: false,
      );

      _messagesList![index] = updatedMessage;
      setState();

      if (i == hotels.length - 1) {
        await Future.delayed(const Duration(milliseconds: 500));

        // Update only showTextWithAnimation to true
        final finalUpdate = updatedMessage.copyWith(
          isTyping: false,
          displayText: (i == hotels.length - 1) ? text : "",
        );
        _messagesList![index] = finalUpdate;
        setState();

        await Future.delayed(const Duration(milliseconds: 500));

        // Update only showTextWithAnimation to true
        final finalUpdate2 = updatedMessage.copyWith(
          isTyping: false,
          showTextWithAnimation: (i == hotels.length - 1) ? true : false,
        );
        _messagesList![index] = finalUpdate2;
        setState();
      }
      await Future.delayed(const Duration(milliseconds: 800));
    }
  }

  void _handleChatError() {
    updateChatLoadingStatus(false);

    // Remove the last user message if there was an error
    if (_messagesList != null && _messagesList!.isNotEmpty) {
      final lastMessage = _messagesList!.first;
      if (lastMessage.isUser) {
        _messagesList!.remove(lastMessage);
      }
    }

    textController.text = previousQuestion ?? "";

    // Add error message
    final errorMessage = Message(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      editId: DateTime.now().millisecondsSinceEpoch.toString(),
      text: Utils.getErrorMessageFromString('failed_response'),
      isUser: false,
      timestamp: DateTime.now(),
      aiChatResponse: null,
      displayText: Utils.getErrorMessageFromString('failed_response'),
    );

    // _messagesList ??= MessageLoadingMoreList(sessionId ?? "", aiAssistantRepo!);

    // _messagesList?.addMessage(errorMessage);
    isTyping = false;
    setState();
  }

  Future<void> _startTypewriterEffect(String messageId) async {
    final completer = Completer<void>();
    final messageInfo = _getMessageInfo(messageId);

    if (messageInfo == null) {
      completer.complete();
      return completer.future;
    }

    _announceMessage(messageInfo.fullText);
    _startTypewriterTimer(messageInfo, completer);

    return completer.future;
  }

  /// Gets message information for typewriter effect
  MessageInfo? _getMessageInfo(String messageId) {
    final index = messages.indexWhere((msg) => msg.id == messageId);
    if (index == -1) return null;

    final message = messages[index];
    return MessageInfo(
      message: message,
      index: index,
      fullText: message.text,
    );
  }

  /// Announces the message for accessibility
  void _announceMessage(String fullText) {
    Utils.announceMessage("$fullText ${S.of(getContext()).message_received}");
  }

  /// Starts the typewriter timer with the effect
  void _startTypewriterTimer(
      MessageInfo messageInfo, Completer<void> completer) {
    _typewriterTimer?.cancel();
    _typewriterTimer = Timer.periodic(
      const Duration(milliseconds: 20),
      (timer) => _handleTypewriterTick(timer, messageInfo, completer),
    );
  }

  /// Handles each tick of the typewriter timer
  void _handleTypewriterTick(
    Timer timer,
    MessageInfo messageInfo,
    Completer<void> completer,
  ) {
    if (!_isTimerActive()) {
      _cancelTimerAndClear(timer);
      return;
    }

    if (_shouldContinueTyping(messageInfo)) {
      _updateTypingProgress(messageInfo);
    } else {
      _completeTypewriterEffect(timer, messageInfo, completer);
    }
  }

  /// Checks if the typewriter timer is still active
  bool _isTimerActive() {
    return _typewriterTimer?.isActive == true;
  }

  /// Cancels timer and clears message list
  void _cancelTimerAndClear(Timer timer) {
    timer.cancel();
    _messagesList?.clear();
  }

  /// Checks if typing should continue
  bool _shouldContinueTyping(MessageInfo messageInfo) {
    return messageInfo.currentIndex < messageInfo.fullText.length;
  }

  /// Updates the typing progress
  void _updateTypingProgress(MessageInfo messageInfo) {
    final updatedMessage = messageInfo.message.copyWith(
      displayText:
          messageInfo.fullText.substring(0, messageInfo.currentIndex + 1),
    );

    if (_canUpdateMessageList(messageInfo.index)) {
      _messagesList![messageInfo.index] = updatedMessage;
      setState();
    }

    messageInfo.currentIndex++;
  }

  /// Checks if message list can be updated
  bool _canUpdateMessageList(int index) {
    return _messagesList != null && index < _messagesList!.length;
  }

  /// Completes the typewriter effect
  void _completeTypewriterEffect(
    Timer timer,
    MessageInfo messageInfo,
    Completer<void> completer,
  ) {
    if (_isTimerActive()) {
      _finalizeMessage(messageInfo);
    } else {
      _messagesList?.clear();
    }

    timer.cancel();
    completer.complete();
  }

  /// Finalizes the message with complete text
  void _finalizeMessage(MessageInfo messageInfo) {
    final completedMessage = messageInfo.message.copyWith(
      isTyping: false,
      displayText: messageInfo.fullText,
    );

    if (_canUpdateMessageList(messageInfo.index)) {
      _messagesList![messageInfo.index] = completedMessage;
    }
    setState();
  }

  // Function to Build Option Summary To Send
  void buildOptionSummary(List<Options> listOptions, String messageId) {
    isContinueButtonSelected = true;
    isTyping = true;
    updateChatLoadingStatus(false);
    setState();
    final selectedOptionIds = listOptions
        .where((option) => option.isSelected == true)
        .map((option) => Utils.getErrorMessageFromString(option.optionId!))
        .whereType<String>() // filters out nulls safely
        .toList();

    if (selectedOptionIds.isEmpty) return;

    // removeChatWithMessageId(messageId);
    // Remove the last message
    // if (_messagesList != null && _messagesList!.isNotEmpty) {
    //   _messagesList!.removeAt(_messagesList!.length - 1);
    // }
    // _messagesList?.removeLast();
    // _messagesList!.removeAt(0);
    // removeChatWithMessageId(messageId);

    final joinedIds = selectedOptionIds.join(', ');

    FirebaseAnalyticsService.logEvent(
      eventName: "evapreferences_selected",
      parameters: {
        AnalyticsEventConst.PARAM_NAME_UI_ELEMENT: "txt_continue",
        "selected_preferences": joinedIds,
        AnalyticsEventConst.PARAM_NAME_TILE_NAME: section ?? ""
      },
    );

    String text = '${Utils.getErrorMessageFromString(section!)}: $joinedIds';
    sendMessage(text, '');
  }

  Future<AiChatResponse?> _fetchResponsesFromServer(
      String message, bool isUpdateMessage, String messageId) async {
    AiAssistQuestion aiAssistQuestion = AiAssistQuestion(
        query: message, city: userLocation, sessionId: sessionId);

    ApiResponse<AiChatResponse>? response;

    if (isUpdateMessage) {
      // aiAssistQuestion.messageId = messageId;
      response = await aiAssistantRepo?.updateMessage(
          aiAssistQuestion.toApiJson(), AiChatResponse.fromJson, messageId);
    } else {
      response = await aiAssistantRepo?.getMessage(
          aiAssistQuestion.toApiJson(), AiChatResponse.fromJson);
    }

    if (response != null && response.isSuccess && response.data != null) {
      sessionId = response.data?.sessionId ?? "";
      return response.data;
    } else {
      Utils.logPrint("response ${response?.messageKey}");

      _handleChatError();

      visaSnackBar(
          context: getContext(),
          title: S.of(getContext()).error,
          type: SnackBarType.failure,
          subtitle:
              Utils.getErrorMessageFromString(response?.messageKey ?? ""));
    }

    return null;
  }

  void editLastUserMessage(
      TextEditingController textController, String messageId) {
    if (_messagesList == null || _messagesList!.isEmpty) return;

    // Find the last user message
    Message? lastUserMessage;
    int? lastUserMessageIndex;

    for (int i = _messagesList!.length - 1; i >= 0; i--) {
      if (_messagesList![i].isUser && _messagesList![i].editId == messageId) {
        lastUserMessage = _messagesList![i];
        lastUserMessageIndex = i;
        break;
      }
    }

    Utils.logPrint("messageId $messageId");
    if (lastUserMessage == null) return;

    _editingMessageId = messageId;
    textController.text = lastUserMessage.text;

    isEdit = true;

    // Remove messages after the last user message
    // if (lastUserMessageIndex != null) {
    //   while (_messagesList!.length > lastUserMessageIndex) {
    //     _messagesList!.removeAt(_messagesList!.length - 1);
    //   }
    // }

    //removeChatWithMessageId(messageId);

    setState();
  }

  copyEVAText(Message message) {
    Utils.hideKeyboard(mContext);
    if (message.aiChatResponse == null) {
      visaSnackBar(
          context: getContext(),
          type: SnackBarType.failure,
          title: "${S.of(getContext()).error}!",
          subtitle: S.of(getContext()).something_went_wrong,
          showAtBottom: true);
      return;
    }

    message.isCopy = true;
    setState();

    Future.delayed(const Duration(milliseconds: 2500), () {
      message.isCopy = false;
      setState();
    });

    Utils.logPrint(message.aiChatResponse!.toJson());

    String text = getEvaCopy(message.aiChatResponse!);
    text = removeTrailingNewlines(text);

    Clipboard.setData(ClipboardData(text: text));

    visaSnackBar(
        context: getContext(),
        type: SnackBarType.success,
        title: "${S.of(getContext()).success}!",
        subtitle: S.of(getContext()).eva_copy,
        showAtBottom: true);
  }

  String removeTrailingNewlines(String input) {
    while (input.endsWith('\n')) {
      input = input.substring(0, input.length - 1);
    }
    return input;
  }

  getEvaCopy(AiChatResponse aiChatResponse) {
    switch (aiChatResponse.type) {
      case AppConst.getTextKey:
        return getCopyText(aiChatResponse);
      case AppConst.getWeatherKey:
        return getCopyWeather(aiChatResponse);
      case AppConst.bookingKey:
        return getCopyHotels(aiChatResponse);
      case AppConst.getSearchPlacesKey:
        return getCopyPlaces(aiChatResponse);
      case AppConst.flightKey ||
            AppConst.directionsKey ||
            AppConst.faqRetriever:
        return getCopyFlights(aiChatResponse);
      default:
        return getCopyText(aiChatResponse);
    }
  }

  getCopyText(AiChatResponse aiChatResponse) {
    String text = "";
    if (aiChatResponse.initialText != null) {
      text = "${aiChatResponse.initialText ?? ""}\n\n";
    }
    return text + (aiChatResponse.finalText ?? "");
  }

  getCopyWeather(AiChatResponse aiChatResponse) {
    String text = "";

    if (aiChatResponse.initialText != null) {
      text = "${aiChatResponse.initialText ?? ""}\n\n";
    }

    final s = S.of(getContext());
    final temp = aiChatResponse.data[0].items.forecast[0];
    text =
        "$text${aiChatResponse.data[0].items.location} - ${temp.tempF}${s.fahrenheit}\n\n";

    text = "$text${temp.weatherType}\n\n";

    text =
        '$text${s.low}${temp.minTempF}${s.fahrenheit} ${s.high}${temp.maxTempF}${s.fahrenheit}\n\n';

    for (var day in aiChatResponse.data[0].items.forecast) {
      final shortDay = DateUtil.getShortDayOfWeek(getContext(), day.date);
      final highTemp = "${day.maxTempF.toInt()}${s.fahrenheit}";
      final lowTemp = "${day.minTempF.toInt()}${s.fahrenheit}";
      final weatherType = day.weatherType;

      text =
          '$text $shortDay - ${s.high}$highTemp : ${s.low}$lowTemp : $weatherType\n\n';
    }

    return text + (aiChatResponse.finalText ?? "");
  }

  getCopyHotels(AiChatResponse aiChatResponse) {
    String text = "";
    if (aiChatResponse.initialText != null) {
      text = "${aiChatResponse.initialText ?? ""}\n\n";
    }

    for (var hotels in aiChatResponse.data.first.items.hotels) {
      text =
          "$text${hotels.name ?? ""} - ${hotels.location!.address}, ${S.of(getContext()).rating}: ${hotels.rating!.stars}, ${S.of(getContext()).price(hotels.price!.total!)}\n${hotels.url}\n\n";
    }

    return text + (aiChatResponse.finalText ?? "");
  }

  getCopyPlaces(AiChatResponse aiChatResponse) {
    String text = "";
    if (aiChatResponse.initialText != null) {
      text = "${aiChatResponse.initialText ?? ""}\n\n";
    }

    for (var places in aiChatResponse.data.first.items.places) {
      text =
          "$text${places.displayName} - ${places.editorialSummary!.text!}, ${S.of(getContext()).rating}: ${places.rating}, ${places.formattedAddress} \n${places.googleMapsUri}\n\n";
    }

    return text + (aiChatResponse.finalText ?? "");
  }

  getCopyFlights(AiChatResponse aiChatResponse) {
    String text = "";
    if (aiChatResponse.initialText != null) {
      text = "${aiChatResponse.initialText ?? ""}\n\n";
    }

    text = text + (aiChatResponse.finalText ?? "") + "\n\n";

    for (var flight in aiChatResponse.data) {
      if (flight.items.flightUrl.isNotEmpty) {
        text = "$text${flight.items.flightUrl}";
      } else if (flight.items.googleMapUrl.isNotEmpty) {
        text = "$text${flight.items.googleMapUrl}";
      }
    }

    return text;
  }

  // Helper function to update like dislike UI
  void updateLikeDislike(String id, int currentState, bool isLike) {
    Utils.hideKeyboard(mContext);
    if (_messagesList == null) return;
    likeDislikePressed = true;

    int newState;

    if (isLike) {
      // Like Button Clicked
      if (currentState == 0) {
        newState = 1; // 0 → 1 (Like)
        Utils.announceMessage(S.of(getContext()).liked_the_message);
      } else if (currentState == 1) {
        newState = 0; // 1 → 0 (Undo Like)
        Utils.announceMessage(S.of(getContext()).removed_like);
      } else {
        newState = 1; // 2 → 1 (Switch from Dislike to Like)
        Utils.announceMessage(S.of(getContext()).changed_to_like);
      }
    } else {
      // Dislike Button Clicked
      if (currentState == 1) {
        newState = 2; // 1 → 2 (Like to Dislike)
        Utils.announceMessage(S.of(getContext()).changed_to_dislike);
      } else if (currentState == 2) {
        newState = 0; // 2 → 0 (Undo Dislike)
        Utils.announceMessage(S.of(getContext()).removed_dislike);
      } else {
        newState = 2; // 0 → 2 (Neutral to Dislike)
        Utils.announceMessage(S.of(getContext()).disliked_the_message);
      }
    }

    final index = messages.indexWhere((msg) => msg.id == id);
    if (index != -1) {
      final updatedMessage = _messagesList![index].copyWith(state: newState);
      _messagesList![index] = updatedMessage;
      setState();
    }
  }

  void setExpand(String id, int index) {
    final msgIndex = messages.indexWhere((msg) => msg.id == id);

    if (msgIndex != -1) {
      final originalMessage = _messagesList![msgIndex];
      final originalItems = originalMessage.aiChatResponse!.data[0].items;
      final originalPlaces = originalItems.places;

      if (index >= 0 && index < originalPlaces.length) {
        final toggledPlace = originalPlaces[index].copyWith(
          isExpand: !originalPlaces[index].isExpand,
        );

        final updatedPlaces = List<Place>.from(originalPlaces);
        updatedPlaces[index] = toggledPlace;

        final updatedItems = originalItems.copyWith(places: updatedPlaces);
        final updatedData = originalMessage.aiChatResponse!.data[0].copyWith(
          items: updatedItems,
        );
        final updatedResponse = originalMessage.aiChatResponse!.copyWith(
          data: [updatedData],
        );

        _messagesList![msgIndex] = originalMessage.copyWith(
          response: updatedResponse,
        );

        setState();
      }
    }
  }

  // Helper method to scroll to bottom after messages update
  void scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (scrollController.hasClients) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void scrollToTop() {
    if (scrollController.hasClients) {
      scrollController.animateTo(
        scrollController.position.minScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  Future<void> scrollToBottomWithRetry({int retries = 5}) async {
    for (int i = 0; i < retries; i++) {
      await Future.delayed(const Duration(milliseconds: 150));
      if (!scrollController.hasClients) continue;

      final maxExtent = scrollController.position.maxScrollExtent;
      final currentOffset = scrollController.offset;

      // Jump if not at the bottom
      if ((maxExtent - currentOffset).abs() > 50) {
        scrollController.jumpTo(1);
      } else {
        break;
      }
    }
  }

  void cancelEditing() {
    _editingMessageId = null;
    setState();
  }

  void _onScroll() {
    // For a reversed list, the top is now where new messages appear (bottom of chat)
    // and the bottom is where older messages load (top of chat)
    final isAtTop = scrollController.position.pixels >=
        scrollController.position.maxScrollExtent - 50;

    final isAtTheBottom = scrollController.position.pixels <=
        scrollController.position.minScrollExtent + 100;

    // Update isAtBottom value based on position (reversed from before)
    isAtBottom.value = isAtTop || isAtTheBottom;
  }

  // Get Question By Sections
  List<Questions> getQuestionsBySection(
    String sectionName,
    List<Questions> allQuestions,
  ) {
    return allQuestions
        .where((question) => question.section == sectionName)
        .toList();
  }

  // Function to check the Prompts Description
  String? getPrompts(String prompt) {
    final localizedMap = {
      "match_day": Utils.getErrorMessageFromString('select_interest_message'),
      "hidden_gems": Utils.getErrorMessageFromString('select_interest_message'),
      "exceptional_menus":
          Utils.getErrorMessageFromString('select_interest_message'),
      "stay_your_way":
          Utils.getErrorMessageFromString('select_interest_message'),
      "must_see_attractions":
          Utils.getErrorMessageFromString('select_interest_message'),
    };

    return localizedMap[prompt];
  }

  // Function to send AI every message feedback
  Future<AiChatResponse?> submitMessageFeedback(
      String feedback, String sessionId, String messageId) async {
    Utils.hideKeyboard(mContext);
    FirebaseAnalyticsService.logEvent(
      eventName: "evasuggestion_feedback",
      parameters: {
        AnalyticsEventConst.PARAM_NAME_TILE_NAME: firstSection,
        "nonInteraction": "0",
        "uiInteraction": "1",
        "feedback_type":
            (feedback == AppConst.like) ? "thumbs_up" : "thumbs_down",
      },
    );

    if (messageId.isNotEmpty &&
        (feedback == AppConst.like || feedback == AppConst.dislike)) {
      AiSubmitFeedbackModel aiSubmitFeedbackModel = AiSubmitFeedbackModel(
        feedback: feedback,
        messageId: messageId,
        sessionId: sessionId,
      );

      await aiAssistantRepo?.submitMessageFeedback(
        aiSubmitFeedbackModel.toApiJson(),
        AiChatResponse.fromJson,
      );
      likeDislikePressed = false;
    }
    return null;
  }

  void navigateToRedirectingScreen(String url,
      {String deeplink = "", bool isRedirectToBooking = false}) {
    navPush(AppRoutes.redirecting, extra: {
      "url": url,
      "deeplink": deeplink,
      "openInternalBrowser": isRedirectToBooking ? true : false,
      "bottomMessage": isRedirectToBooking
          ? S.of(mContext).you_are_being_redirect_booking
          : S.of(mContext).you_redirection_maps,
    });
  }

  void cancelEditChat() {
    if (isEdit != null && isEdit!) {
      _messagesList?.insertAll(0, editedMessage);
      editedMessage.clear();
      textController.clear();
      textEditController.clear();

      isEdit = false;
      setState();
    }
  }

  void requestEditTextFocus() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      editFocusNode.requestFocus();
    });
  }

  Future<void> navigateFaqUrls(String appUrl) async {
    if (appUrl.trim().isEmpty) return;

    final navigationHandler = _getNavigationHandler(appUrl);
    if (navigationHandler != null) {
      await navigationHandler();
    }
  }

  /// Gets the appropriate navigation handler for the given URL
  Future<void> Function()? _getNavigationHandler(String appUrl) {
    final handlers = {
      AppConst.openAppStore: _handleAppStoreNavigation,
      AppConst.openPlayStore: _handleAppStoreNavigation,
      AppConst.openContactVisa: _handleContactVisaNavigation,
      AppConst.openVisaGO: _handleVisaGoNavigation,
      AppConst.openResetPassword: _handleResetPasswordNavigation,
      AppConst.openProfileBiometric: _handleProfileBiometricNavigation,
      AppConst.openWallet: _handleWalletNavigation,
      AppConst.openFAQ: _handleFaqNavigation,
      AppConst.openPrepaidCard: _handleWalletNavigation,
      AppConst.openEvaChat: _handleEvaChatNavigation,
      AppConst.openTicket: _handleTicketNavigation,
      AppConst.openCompanion: _handleCompanionNavigation,
      AppConst.openBookTravel: _handleBookTravelNavigation,
      AppConst.openBookingCom: _handleBookingComNavigation,
    };

    return handlers[appUrl];
  }

  /// Handles app store navigation
  Future<void> _handleAppStoreNavigation() async {
    if (_isMobilePlatform()) {
      final isIOS = Platform.isIOS;
      _navigateToRedirecting(
        url: isIOS ? AppConst.appStoreLink : AppConst.playStoreLink,
        bottomMessage: isIOS
            ? S.of(mContext).redirect_app_store
            : S.of(mContext).redirect_play_store,
        openInternalBrowser: false,
      );
    } else {
      Utils.openExternalApplication(AppConst.appStoreLink, "");
    }
  }

  /// Handles contact Visa navigation
  Future<void> _handleContactVisaNavigation() async {
    final url = AppConst.visaContactSupport;
    if (!kIsWeb) {
      _navigateToRedirecting(
        url: url,
        bottomMessage: S
            .of(getContext())
            .you_are_being_redirect_to_visa_contact_us_support,
        openInternalBrowser: true,
      );
    } else {
      Utils.openExternalApplication(url, "");
    }
  }

  /// Handles Visa Go navigation
  Future<void> _handleVisaGoNavigation() async {
    final url = "${dotenv.env["WEB_URL"]}";
    if (!kIsWeb) {
      _navigateToRedirecting(
        url: url,
        bottomMessage: S.of(mContext).redirect_to_visa_go_website,
        openInternalBrowser: false,
      );
    } else {
      Utils.openExternalApplication(url, "");
    }
  }

  /// Handles reset password navigation
  Future<void> _handleResetPasswordNavigation() async {
    navPush(AppRoutes.changePassword);
  }

  /// Handles profile biometric navigation
  Future<void> _handleProfileBiometricNavigation() async {
    navPush(AppRoutes.profilePage);
  }

  /// Handles wallet navigation
  Future<void> _handleWalletNavigation() async {
    await Provider.of<NavigationProvider>(getContext(), listen: false)
        .goBranch(AppRoutes.homeScreenIndex);
    navGo(AppRoutes.homeNestedWallet);
  }

  /// Handles FAQ navigation
  Future<void> _handleFaqNavigation() async {
    navPush(AppRoutes.faq);
  }

  /// Handles EVA chat navigation
  Future<void> _handleEvaChatNavigation() async {
    // No action needed for EVA chat
  }

  /// Handles ticket navigation
  Future<void> _handleTicketNavigation() async {
    Provider.of<NavigationProvider>(getContext(), listen: false)
        .goBranch(AppRoutes.ticketScreenIndex);
  }

  /// Handles companion navigation
  Future<void> _handleCompanionNavigation() async {
    GetIt.I<HomeViewProvider>().getCompanionScreen();
  }

  /// Handles book travel navigation
  Future<void> _handleBookTravelNavigation() async {
    Utils.walletPopupTravelCredit(
      context: getContext(),
      child: const WalletPopupTravelScreen(
        list: null,
        isBookTravel: true,
      ),
    );
  }

  /// Handles booking.com navigation
  Future<void> _handleBookingComNavigation() async {
    final languageCode =
        await Preferences.getString(Preferences.keyLanguageCode);
    final url = "${AppConst.bookingComLink}index.$languageCode.html";

    if (!kIsWeb) {
      _navigateToRedirecting(
        url: url,
        bottomMessage: S.of(getContext()).you_are_being_redirect_booking,
        openInternalBrowser: true,
      );
    } else {
      Utils.openExternalApplication(url, "");
    }
  }

  /// Checks if running on mobile platform
  bool _isMobilePlatform() {
    return !kIsWeb && (Platform.isIOS || Platform.isAndroid);
  }

  /// Helper method to navigate to redirecting screen
  void _navigateToRedirecting({
    required String url,
    required String bottomMessage,
    required bool openInternalBrowser,
    String deeplink = "",
  }) {
    navPush(AppRoutes.redirecting, extra: {
      "url": url,
      "deeplink": deeplink,
      "openInternalBrowser": openInternalBrowser,
      "bottomMessage": bottomMessage,
    });
  }
}
