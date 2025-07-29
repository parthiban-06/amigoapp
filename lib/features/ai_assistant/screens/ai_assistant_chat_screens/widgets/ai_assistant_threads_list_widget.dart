import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:visaamigo/features/ai_assistant/screens/ai_assistant_chat_screens/widgets/ai_assistant_loading_widget.dart';

import '../../../providers/ai_assistant_threads_screen_provider.dart';
import 'ai_assistant_threads_list_items_widget.dart';

class AiAssistantThreadsListWidget extends StatelessWidget {
  final AiAssistantThreadsScreenProvider viewModel;

  const AiAssistantThreadsListWidget({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return Consumer<AiAssistantThreadsScreenProvider>(
      builder: (context, viewModel, child) {
        return ListView.builder(
          cacheExtent: 200,
          addAutomaticKeepAlives: true,
          addRepaintBoundaries: true,
          key: const PageStorageKey<String>('ai_threads_list'),
          controller: viewModel.aiChatScrollController,
          reverse: viewModel.isListReverse,
          itemCount: _calculateItemCount(viewModel),
          itemBuilder: (context, index) =>
              _buildListItem(context, viewModel, index),
        );
      },
    );
  }

  /// Calculates the total item count for the ListView
  int _calculateItemCount(AiAssistantThreadsScreenProvider viewModel) {
    if (viewModel.isListReverse) {
      return viewModel.isAiLoading
          ? viewModel.messages.length + 1
          : viewModel.messages.length;
    }
    return viewModel.messages.length + 1;
  }

  /// Builds individual list items
  Widget _buildListItem(BuildContext context,
      AiAssistantThreadsScreenProvider viewModel, int index) {
    if (_shouldShowLoadingWidget(viewModel, index)) {
      return _buildLoadingWidget();
    }

    final messageIndex = _calculateMessageIndex(viewModel, index);
    return _buildMessageItem(viewModel, messageIndex);
  }

  /// Determines if loading widget should be shown
  bool _shouldShowLoadingWidget(
      AiAssistantThreadsScreenProvider viewModel, int index) {
    if (viewModel.isListReverse) {
      return viewModel.isAiLoading && index == 0;
    }
    return index == viewModel.messages.length;
  }

  /// Builds the loading widget
  Widget _buildLoadingWidget() {
    return AiAssistantLoadingWidget();
  }

  /// Calculates the correct message index
  int _calculateMessageIndex(
      AiAssistantThreadsScreenProvider viewModel, int index) {
    if (viewModel.isListReverse) {
      return viewModel.isAiLoading ? index - 1 : index;
    }
    return index;
  }

  /// Builds the message item widget
  Widget _buildMessageItem(
      AiAssistantThreadsScreenProvider viewModel, int messageIndex) {
    return AiAssistantThreadsListItemsWidget(
      key: ValueKey(messageIndex),
      viewModel: viewModel,
      index: messageIndex,
    );
  }
}
