import 'package:flutter/cupertino.dart';
import 'package:visaamigo/ui/base/base_provider.dart';
import 'package:visaamigo/utils/utils.dart';

import '../../../../analytics/firebase_analytics_service.dart';
import '../../../../custom_widgets/visa_snack_bar.dart';
import '../../../../generated/l10n.dart';
import '../../../../router/app_routes_const.dart';
import '../../../home/providers/navigation_provider.dart';
import '../../models/ai_chat_history.dart';
import '../../models/ai_delete_response.dart';
import '../../repo/ai_assistant_repo.dart';
import '../ai_chat_provider.dart';

class AiChatHistoryProvider extends BaseProvider {
  bool _isDeleteHistoryEnable = false;

  bool get isDeleteHistoryEnable => _isDeleteHistoryEnable;
  ScrollController scrollController = ScrollController();
  ValueNotifier<bool> isAtBottom = ValueNotifier<bool>(false);

  List<AiChatHistory>? aiHistoryList;

  AiAssistantRepo? aiAssistantRepo;

  Set<int> _selectedItems = {}; // Stores indices of selected items

  Set<int> get selectedItems => _selectedItems;

  set isDeleteHistoryEnable(bool value) {
    _isDeleteHistoryEnable = value;
    setState();
  }

  Future<void> init() async {
    // setContext(context);
    scrollController.addListener(_onScroll);

    isLoading = true;
    aiAssistantRepo = AiAssistantRepo(apiClient);

    await fetchChatHistory();
    isLoading = false;
  }

  Future<void> fetchChatHistory() async {
    // AiChatHistory.fromJsonList(jsonList);

    var response =
        await aiAssistantRepo?.getChatHistory(AiChatHistory.fromDataJson);
    Utils.logPrint("aiHistoryList data ${response?.data}");

    if (response != null && response.isSuccess && response.data != null) {
      aiHistoryList = response?.data!;
    } else {
      aiHistoryList = [];
    }
    Utils.logPrint("aiHistoryList size ${response?.data?.length}");

    if (aiHistoryList != null) {
      for (var item in aiHistoryList!) {
        Utils.logPrint("aiHistoryList ${item.sessionid}");
      }
    }
  }

  void toggleSelection(int index) {
    if (selectedItems.contains(index)) {
      selectedItems.remove(index);
      Utils.announceMessage(S.of(getContext()).unchecked);
    } else {
      selectedItems.add(index);
      Utils.announceMessage(S.of(getContext()).checked);
    }
    notifyListeners(); // Notify the UI of selection change
  }

  void clearSelectionItem() {
    selectedItems.clear();
    setState();
  }

  void openChatDetailScreen(NavigationProvider navigationBar,
      ChatProvider chatProvider, AiChatHistory chatItem) {
    FirebaseAnalyticsService.logEventButtonClick(
        btnName: "eva_conversation_history",
        parameters: {
          AnalyticsEventConst.PARAM_NAME_UI_ELEMENT_LABEL: chatItem?.topic ?? "",
          AnalyticsEventConst.PARAM_NAME_UI_ELEMENT: "eva_conversation_history"
        });

    chatProvider.clearAllPreviousState(false);
    navigationBar.goBranch(AppRoutes.evaScreenIndex,
        loadInitial: true, showGreetingScreen: false);

    Utils.logPrint("threadId ${chatItem.toJson()}");

    navGo(AppRoutes.evaChatScreenNav, extra: chatItem.sessionid);
  }

  void showDeleteChatUi() {
    clearSelectionItem();
    if (isDeleteHistoryEnable) {
      isDeleteHistoryEnable = false;
    } else {
      navPop();
    }

    notifyListeners();
  }

  void deleteChatConversation() async {
    FirebaseAnalyticsService.logEventButtonClick(
        btnName: "delete",
        parameters: {AnalyticsEventConst.PARAM_NAME_UI_ELEMENT: "delete"});

    if (_selectedItems.isEmpty) {
      visaSnackBar(
          context: getContext(),
          title: S.of(getContext()).error,
          type: SnackBarType.failure,
          subtitle: S.of(getContext()).conversation_delete_error,
          showAtBottom: true);
      return;
    }

    isLoading = true;
    List<String> deeltedId = [];

    for (final index in _selectedItems) {
      final id = aiHistoryList?[index].sessionid;
      if (id != null) deeltedId.add(id);
    }

    var resposne = await aiAssistantRepo?.deleteChatHistory(
      SessionDeleteResponse.fromDataJson,
      deeltedId,
    );

    clearSelectionItem();
    // isDeleteHistoryEnable = false;
    // _isDeleteHistoryEnable = false;
    aiHistoryList = null;

    setState();

    if (resposne != null && resposne.isSuccess) {
      visaSnackBar(
          context: getContext(),
          title: S.of(getContext()).success,
          type: SnackBarType.success,
          subtitle: S.of(getContext()).conversation_delete,
          showAtBottom: true);
      await fetchChatHistory();
    } else {
      await fetchChatHistory();
    }
    Utils.announceMessage(S.of(getContext()).chat_history_updated);
    isLoading = false;
  }

  void _onScroll() {
    if (scrollController.position.pixels - 10 >
        scrollController.position.minScrollExtent) {
      if (!isAtBottom.value) {
        isAtBottom.value = true;
      }
    } else {
      if (isAtBottom.value) {
        isAtBottom.value = false;
      }
    }
  }

  @override
  void dispose() {
    scrollController.removeListener(_onScroll);
    scrollController.dispose();
    super.dispose();
  }
}
