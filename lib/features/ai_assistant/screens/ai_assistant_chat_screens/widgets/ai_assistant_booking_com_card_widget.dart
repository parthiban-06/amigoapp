import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:visaamigo/custom_widgets/visa_size_box.dart';

import '../../../../../core/theme/theme.dart';
import '../../../../../custom_widgets/visa_textview.dart';
import '../../../../../generated/l10n.dart';
import '../../../../../utils/const_screen_size.dart';
import '../../../providers/ai_chat_provider.dart';
import '../ai_message.dart';
import 'ai_hotels_widget.dart';

class AiAssistantBookingComCardWidget extends StatelessWidget {
  final Message message;
  final ChatProvider chatProvider;

  const AiAssistantBookingComCardWidget({
    super.key,
    required this.message,
    required this.chatProvider,
  });

  @override
  Widget build(BuildContext context) {
    var listSearchHotels = message.aiChatResponse!.data[0].items.hotels;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (!message.isFinalText &&
            message.isFinalTextEmpty &&
            (!message.isTyping || message.isTyping)) ...[
          listSearchHotels.isNotEmpty
              ? VisaSizeBox(height: AppSizes.eightHeight)
              : const SizedBox.shrink(),
          BookingListWidget(
            message: message,
            chatProvider: chatProvider,
          ),
          if (message.aiChatResponse!.data[0].tag.isNotEmpty)
            SourceWidget(message: message),
          VisaSizeBox(height: AppSizes.tweentyHeight),
        ],
        if (message.isFinalText && (!message.isTyping || message.isTyping)) ...[
          listSearchHotels.isNotEmpty
              ? VisaSizeBox(height: AppSizes.eightHeight)
              : const SizedBox.shrink(),
          BookingListWidget(
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

class BookingListWidget extends StatelessWidget {
  final Message message;
  final ChatProvider chatProvider;

  const BookingListWidget(
      {required this.message, required this.chatProvider, super.key});

  @override
  Widget build(BuildContext context) {
    var listSearchHotels = message.aiChatResponse!.data[0].items.hotels;
    var checkIn = message.aiChatResponse!.data[0].items.checkin;
    var checkOut = message.aiChatResponse!.data[0].items.checkout;
    var guests = message.aiChatResponse!.data[0].items.guests;
    return listSearchHotels.isNotEmpty
        ? Column(
            children: listSearchHotels.asMap().entries.map((entry) {
              final index = entry.key;
              final hotels = entry.value;
              final animatedIndexes =
                  message.animatedPlaceIndexes?[message.id] ?? {};
              final alreadyAnimated = animatedIndexes.contains(index);
              return alreadyAnimated
                  ? HotelsWidget(
                      chatProvider: chatProvider,
                      hotels: hotels,
                      index: index,
                      isBottomSheet: false,
                      checkIn: checkIn,
                      checkOut: checkOut,
                      guests: guests,
                    )
                  : AnimationConfiguration.staggeredList(
                      position: index,
                      duration: const Duration(milliseconds: 800),
                      child: ScaleAnimation(
                        scale: 1.0,
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.easeInOut,
                        // Smoother animation curve
                        child: HotelsWidget(
                          chatProvider: chatProvider,
                          hotels: hotels,
                          isBottomSheet: false,
                          index: index,
                          checkIn: checkIn,
                          checkOut: checkOut,
                          guests: guests,
                        ),
                      ),
                    );
            }).toList(),
          )
        : const SizedBox.shrink();
  }
}
