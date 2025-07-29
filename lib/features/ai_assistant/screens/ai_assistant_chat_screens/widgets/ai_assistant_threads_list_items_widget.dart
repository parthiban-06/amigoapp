import 'package:flutter/material.dart';
import 'package:visaamigo/utils/app_extensions.dart';

import '../../../../../custom_widgets/visa_animated_list_items.dart';
import '../../../providers/ai_assistant_threads_screen_provider.dart';
import 'ai_assistant_card_item_widget.dart';

class AiAssistantThreadsListItemsWidget extends StatefulWidget {
  final AiAssistantThreadsScreenProvider viewModel;
  final int index;

  const AiAssistantThreadsListItemsWidget({
    super.key,
    required this.viewModel,
    required this.index,
  });

  @override
  State<AiAssistantThreadsListItemsWidget> createState() =>
      _AiAssistantThreadsListItemsWidgetState();
}

class _AiAssistantThreadsListItemsWidgetState
    extends State<AiAssistantThreadsListItemsWidget> {
  @override
  Widget build(BuildContext context) {
    if (widget.viewModel.isListReverse) {
      int lastIndex = widget.viewModel.messages.length - 1 - widget.index;
      final message = widget.viewModel.messages[lastIndex];
      final isSentByMe = message.role == 'user'; // Determine sender
      if (message.message.isEmpty) {
        return const SizedBox.shrink();
      }

      Widget child = AiAssistantCardItemWidget(
        isSentByMe: isSentByMe,
        message: message,
        isLastItem: true,
        isAiLastItem: true,
        viewModel: widget.viewModel,
      );

      if (lastIndex == widget.viewModel.messages.length - 1 &&
          widget.viewModel.isShowListAnimation) {
        child = VisaAnimatedListItems(
          animationType: isSentByMe
              ? AnimationType.slideFromRight
              : AnimationType.slideFromLeft,
          child: child,
        );
      }

      return child;
    } else {
      final message = widget.viewModel.messages[widget.index];
      final isSentByMe = message.role == 'user'; // Determine sender
      final isSentByAi = message.role == 'ai'; // Determine sender

      if (message.message.isEmpty) {
        return const SizedBox.shrink();
      }

      return AiAssistantCardItemWidget(
        isSentByMe: isSentByMe,
        message: message,
        isLastItem: isSentByMe &&
            widget.viewModel.messages.isSecondLastItems(message) &&
            widget.viewModel.threadController.text.isEmpty,
        isAiLastItem: isSentByAi &&
            widget.viewModel.messages.isLastItem(message) &&
            widget.viewModel.threadController.text.isEmpty,
        viewModel: widget.viewModel,
      );
    }
  }
}
