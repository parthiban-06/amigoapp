import 'package:loading_more_list/loading_more_list.dart';
import 'package:visaamigo/features/ai_assistant/repo/ai_assistant_repo.dart';
import 'package:visaamigo/features/ai_assistant/screens/ai_assistant_chat_screens/ai_message.dart';
import 'package:visaamigo/remote/api_response.dart';
import 'package:visaamigo/utils/app_extensions.dart';
import 'package:visaamigo/utils/utils.dart';

import '../../../utils/app_const.dart';
import '../models/ai_chat_response.dart';
import '../models/ai_thread_list_model.dart';

class MessageLoadingMoreList extends LoadingMoreBase<Message> {
  String sessionId;
  bool isFirstLoad = true;
  AiAssistantRepo aiAssistantRepo;
  int _currentPage = 1;

  MessageLoadingMoreList(this.sessionId, this.aiAssistantRepo);

  @override
  bool get hasMore => _hasMore;
  bool _hasMore = true;

  @override
  Future<bool> refresh([bool notifyStateChanged = false]) async {
    _hasMore = true;
    _currentPage = 1;
    clear();
    return await super.refresh(notifyStateChanged);
  }

  @override
  Future<bool> loadData([bool isloadMoreAction = false]) async {
    try {
      if (_shouldSkipLoading()) {
        return _handleSkipLoading();
      }

      final page = _calculatePage(isloadMoreAction);

      if (_shouldRefreshFirstPage(page)) {
        return _handleRefreshFirstPage();
      }

      final response = await _fetchMessages(page);

      if (_isValidResponse(response)) {
        final messagesSet = _processMessages(response.paginatedData!.items);
        _addMessagesToCollection(messagesSet, isloadMoreAction);
        _updatePaginationState(response, page);
        return true;
      } else {
        _hasMore = false;
        return true;
      }
    } catch (e) {
      Utils.logPrint("MessageLoadingMoreList error: $e");
      _hasMore = false;
      return false;
    }
  }

  bool _shouldSkipLoading() {
    return sessionId.isEmpty;
  }

  bool _handleSkipLoading() {
    _hasMore = false;
    return true;
  }

  int _calculatePage(bool isloadMoreAction) {
    return isloadMoreAction ? _currentPage + 1 : 1;
  }

  bool _shouldRefreshFirstPage(int page) {
    return page == 1 && !isFirstLoad;
  }

  bool _handleRefreshFirstPage() {
    clear();
    _hasMore = true;
    return true;
  }

  Future<ApiResponse<MessageItem>> _fetchMessages(int page) async {
    return await aiAssistantRepo.getMessagesList(
      sessionId: sessionId,
      page: page,
      fromJson: MessageItem.fromJson,
    );
  }

  bool _isValidResponse(ApiResponse<MessageItem> response) {
    return response.isSuccess && response.paginatedData != null;
  }

  List<Message> _processMessages(List<MessageItem> items) {
    List<Message> messagesSet = [];
    String questionMsgId = "";

    for (MessageItem messageItem in items) {
      final messages = _createMessagesFromItem(messageItem, questionMsgId);
      messagesSet.addAll(messages);

      if (messageItem.sender == "user") {
        questionMsgId = messageItem.messageId ?? "";
      }
    }

    return messagesSet;
  }

  List<Message> _createMessagesFromItem(
      MessageItem messageItem, String questionMsgId) {
    if (messageItem.sender == "user") {
      return [_createUserMessage(messageItem)];
    } else {
      return _createAssistantMessages(messageItem);
    }
  }

  Message _createUserMessage(MessageItem messageItem) {
    AiChatResponse? content = messageItem.content;
    _updateContentMetadata(content, messageItem.messageId ?? "");

    return Message(
      editId: messageItem.messageId ?? "",
      id: messageItem.messageId ?? "",
      aiChatResponse: content,
      isUser: true,
      timestamp: DateTime.parse(messageItem.timestamp!),
      isFinalTextEmpty: false,
      displayText: messageItem.content?.initialText ?? "",
      state: 0,
      text: messageItem.content?.text ?? "",
    );
  }

  List<Message> _createAssistantMessages(MessageItem messageItem) {
    final messages = <Message>[];

    // Create initial message
    final initialMessage = _createInitialMessage(messageItem);
    messages.add(initialMessage);

    // Create final message
    final finalMessage = _createFinalMessage(messageItem);
    messages.insert(0, finalMessage);

    return messages;
  }

  Message _createInitialMessage(MessageItem messageItem) {
    AiChatResponse? content = messageItem.content;
    _updateContentMetadata(content, messageItem.messageId ?? "");

    return Message(
      id: messageItem.messageId ?? "",
      editId: messageItem.questionId ?? "",
      aiChatResponse: content,
      isUser: false,
      timestamp: DateTime.parse(messageItem.timestamp!),
      isTyping: false,
      state: _calculateMessageState(messageItem.feedback),
      isFinalText: false,
      isFinalTextEmpty: false,
      isInitialTextEmpty:
          messageItem.content?.initialText?.isNullOrEmpty ?? false,
      displayText: messageItem.content?.initialText ?? "",
      text: messageItem.content?.initialText ?? "",
      showTextWithAnimation: true,
    );
  }

  Message _createFinalMessage(MessageItem messageItem) {
    AiChatResponse? content = messageItem.content;
    _updateContentMetadata(content, messageItem.messageId ?? "");

    final isFinalTextEmpty = messageItem.content!.finalText!.isEmpty;

    return Message(
      id: messageItem.messageId ?? "",
      editId: messageItem.questionId ?? "",
      aiChatResponse: content,
      isUser: false,
      state: _calculateMessageState(messageItem.feedback),
      timestamp: DateTime.parse(messageItem.timestamp!),
      isTyping: false,
      isFinalText: !isFinalTextEmpty,
      isFinalTextEmpty: isFinalTextEmpty,
      isInitialTextEmpty:
          messageItem.content?.initialText?.isNullOrEmpty ?? false,
      text: messageItem.content?.finalText ?? "",
      showTextWithAnimation: true,
    );
  }

  void _updateContentMetadata(AiChatResponse? content, String messageId) {
    content?.sessionId = sessionId;
    content?.messageId = messageId;
  }

  int _calculateMessageState(String? feedback) {
    if (feedback == null) return 0;
    return feedback == AppConst.like ? 1 : 2;
  }

  void _addMessagesToCollection(
      List<Message> messagesSet, bool isloadMoreAction) {
    Utils.logPrint("messagesSet ${messagesSet.length}");
    addAll(messagesSet);

    if (!isloadMoreAction) {
      isFirstLoad = false;
    }
  }

  void _updatePaginationState(ApiResponse<MessageItem> response, int page) {
    _hasMore = response.paginatedData?.hasNextPage ?? false;
    _currentPage = page;
  }

  // Method to add a new message (for real-time messaging)
  void addMessage(Message message, {int position = 1}) {
    // When adding a new message to a reversed list,
    // we add it at the end (it will appear at the bottom)
    insert(0, message);
  }
}
