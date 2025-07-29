import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:visaamigo/custom_widgets/visa_size_box.dart';

import '../../../../../core/theme/theme.dart';
import '../../../../../custom_widgets/visa_textview.dart';
import '../../../../../generated/l10n.dart';
import '../../../../../utils/const_screen_size.dart';
import '../../../providers/ai_chat_provider.dart';
import '../ai_message.dart';
import 'ai_place_widget.dart';

class AiAssistantSearchPlacesCardWidget extends StatelessWidget {
  final Message message;
  final ChatProvider chatProvider;

  const AiAssistantSearchPlacesCardWidget({
    super.key,
    required this.message,
    required this.chatProvider,
  });

  @override
  Widget build(BuildContext context) {
    var listSearchPlaces = message.aiChatResponse!.data[0].items.places;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (!message.isFinalText &&
            message.isFinalTextEmpty &&
            (!message.isTyping || message.isTyping)) ...[
          listSearchPlaces.isNotEmpty
              ? VisaSizeBox(height: AppSizes.eightHeight)
              : const SizedBox.shrink(),
          GooglePlacesListWidget(
            message: message,
            chatProvider: chatProvider,
          ),
          if (message.aiChatResponse!.data[0].tag.isNotEmpty)
            SourceWidget(message: message),
          VisaSizeBox(height: AppSizes.tweentyHeight),
        ],
        if (message.isFinalText && (!message.isTyping || message.isTyping)) ...[
          listSearchPlaces.isNotEmpty
              ? VisaSizeBox(height: AppSizes.eightHeight)
              : const SizedBox.shrink(),
          GooglePlacesListWidget(
            message: message,
            chatProvider: chatProvider,
          ),
          if (message.aiChatResponse!.data[0].tag.isNotEmpty)
            SourceWidget(message: message),
          VisaSizeBox(height: AppSizes.tweentyHeight),
        ],
      ],
    );
  }
}

class SourceWidget extends StatelessWidget {
  final Message message;

  const SourceWidget({
    super.key,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: Sizes.ten),
      child: Semantics(
        container: true,
        child: VisaTextView(
          text:
              "${S.of(context).source} - ${message.aiChatResponse!.data[0].tag}",
          softWrap: true,
          overflow: TextOverflow.visible,
          style: VisaTextStyle.displayBodyXs,
          fontFamily: VisaFontWeight.regular,
          customColor: VisaColors.chatTextColor,
          colorTheme: VisaTextTheme.customTextColor,
          lineHeight: 18 / 16,
          textAlign: TextAlign.start,
          letterSpacing: 0,
        ),
      ),
    );
  }
}

class GooglePlacesListWidget extends StatelessWidget {
  final Message message;
  final ChatProvider chatProvider;

  const GooglePlacesListWidget(
      {required this.message, required this.chatProvider, super.key});

  @override
  Widget build(BuildContext context) {
    var listSearchPlaces = message.aiChatResponse!.data[0].items.places;
    return listSearchPlaces.isNotEmpty
        ? Column(
            children: listSearchPlaces.asMap().entries.map((entry) {
              final index = entry.key;
              final places = entry.value;
              final animatedIndexes =
                  message.animatedPlaceIndexes?[message.id] ?? {};
              final alreadyAnimated = animatedIndexes.contains(index);
              return alreadyAnimated
                  ? PlacesWidget(
                      chatProvider: chatProvider,
                      places: places,
                      message: message,
                      index: index,
                      isBottomSheet: false)
                  : AnimationConfiguration.staggeredList(
                      position: index,
                      duration: const Duration(milliseconds: 800),
                      child: ScaleAnimation(
                        scale: 1.0,
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.easeInOut,
                        // Smoother animation curve
                        child: PlacesWidget(
                          chatProvider: chatProvider,
                          places: places,
                          isBottomSheet: false,
                          message: message,
                          index: index,
                        ),
                      ),
                    );
            }).toList(),
          )
        : const SizedBox.shrink();
  }
}
