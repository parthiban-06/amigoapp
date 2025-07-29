import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:visaamigo/utils/app_extensions.dart';
import 'package:visaamigo/utils/const_screen_size.dart';
import 'package:visaamigo/utils/utils.dart';

import '../../../../../core/theme/theme.dart';
import '../../../../../custom_widgets/visa_font_family.dart';
import '../../../../../custom_widgets/visa_textview.dart';
import '../../../../../generated/l10n.dart';
import '../../../../../utils/app_const.dart';
import '../../../providers/ai_chat_provider.dart';
import '../ai_message.dart';
import 'ai_assistant_booking_com_card_widget.dart';
import 'ai_assistant_nav_button_widget.dart';
import 'ai_assistant_rate_eva_widget.dart';
import 'ai_assistant_search_places_card_widget.dart';
import 'ai_assistant_weather_card_widget.dart';

class AiAssistantEvaChatMessageWidget extends StatelessWidget {
  final Message message;
  final ChatProvider chatProvider;

  const AiAssistantEvaChatMessageWidget({
    required this.message,
    required this.chatProvider,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    var type = message.aiChatResponse?.type ?? "";
    if (message.aiChatResponse == null || type.isNotEmpty) {
      return ChatTextWidget(
        message: message,
        chatProvider: chatProvider,
        type: type,
      );
    }
    return const SizedBox.shrink();
  }
}

class ChatTextWidget extends StatelessWidget {
  final Message message;
  final ChatProvider chatProvider;
  final String type;

  const ChatTextWidget(
      {required this.message,
      required this.chatProvider,
      required this.type,
      super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        if (_shouldShowInitialText()) _buildInitialText(context)!,
        if (_shouldShowInitialButton()) _buildInitialButton(context)!,
        buildCardByType(type, message, chatProvider),
        if (_shouldShowFinalText()) _buildFinalText(context)!,
        if (_shouldShowFinalButton()) _buildFinalButton(context)!,
      ],
    );
  }

  /// Builds the initial text display
  Widget? _buildInitialText(BuildContext context) {
    if (!_shouldShowInitialText()) return null;

    return Semantics(
      enabled: true,
      container: true,
      child: Text(
        _getDisplayText(),
        textAlign: TextAlign.start,
        textScaler: TextScaler.linear(
            Utils.getCappedScale(context, FontSizes(context).displayBodyL)),
        style: _getInitialTextStyle(context),
      ),
    );
  }

  /// Checks if initial text should be shown
  bool _shouldShowInitialText() {
    return !message.isFinalText &&
        ((message.isTyping && message.displayText.trim().isNotEmpty) ||
            (!message.isTyping && message.text.trim().isNotEmpty));
  }

  /// Gets the text to display
  String _getDisplayText() {
    return message.isTyping ? message.displayText : message.text;
  }

  /// Gets the initial text style
  TextStyle _getInitialTextStyle(BuildContext context) {
    return TextStyle(
      color: VisaColors.chatTextColor,
      fontSize: FontSizes(context).displayBodyL,
      fontFamily: VisaFontFamily.getFontFamily(VisaFontWeight.semibold, false),
      fontWeight: FontWeight.w600,
      letterSpacing: 0,
      height: (18 / 16).toDouble(),
    );
  }

  /// Builds the initial button
  Widget? _buildInitialButton(BuildContext context) {
    if (!_shouldShowInitialButton()) return null;

    return buildButtonByType(context, type, message, chatProvider);
  }

  /// Checks if initial button should be shown
  bool _shouldShowInitialButton() {
    return !message.isInitialTextEmpty &&
        !message.isFinalText &&
        message.isFinalTextEmpty &&
        (!message.isTyping || message.isTyping);
  }

  /// Builds the final text display
  Widget? _buildFinalText(BuildContext context) {
    if (!_shouldShowFinalText()) return null;

    return AnimatedOpacity(
      duration: const Duration(milliseconds: 800),
      opacity: _getFinalTextOpacity(),
      child: Semantics(
        enabled: true,
        container: true,
        child: Text(
          _getDisplayText(),
          textAlign: TextAlign.start,
          textScaler: TextScaler.linear(Utils.getCappedScale(
            context,
            _getFinalTextFontSize(context),
          )),
          style: _getFinalTextStyle(context),
        ),
      ),
    );
  }

  /// Checks if final text should be shown
  bool _shouldShowFinalText() {
    return message.isFinalText &&
        ((message.isTyping && message.displayText.trim().isNotEmpty) ||
            (!message.isTyping && message.text.trim().isNotEmpty));
  }

  /// Gets the opacity for final text
  double _getFinalTextOpacity() {
    if (_isSpecialType()) {
      return message.showTextWithAnimation ? 1.0 : 0.0;
    }
    return 1.0;
  }

  /// Checks if the type is special (search places or booking)
  bool _isSpecialType() {
    return type == AppConst.getSearchPlacesKey || type == AppConst.bookingKey;
  }

  /// Gets the font size for final text
  double _getFinalTextFontSize(BuildContext context) {
    return _isLargeType()
        ? FontSizes(context).displayBodyL
        : FontSizes(context).displayBodyS;
  }

  /// Checks if the type should use large font
  bool _isLargeType() {
    return type == AppConst.getWeatherKey ||
        type == AppConst.getSearchPlacesKey ||
        type == AppConst.bookingKey;
  }

  /// Gets the final text style
  TextStyle _getFinalTextStyle(BuildContext context) {
    return TextStyle(
      color: VisaColors.chatTextColor,
      fontSize: _getFinalTextFontSize(context),
      fontFamily: VisaFontFamily.getFontFamily(
        _isLargeType() ? VisaFontWeight.semibold : VisaFontWeight.regular,
        false,
      ),
      fontWeight: _isLargeType() ? FontWeight.w600 : FontWeight.w400,
      letterSpacing: 0,
      height: _isLargeType() ? (18 / 16).toDouble() : (18 / 14).toDouble(),
    );
  }

  /// Builds the final button
  Widget? _buildFinalButton(BuildContext context) {
    if (!_shouldShowFinalButton()) return null;

    return buildButtonByType(context, type, message, chatProvider);
  }

  /// Checks if final button should be shown
  bool _shouldShowFinalButton() {
    return !message.isTyping && message.isFinalText;
  }
}

// Helper method to return the correct widget based on type
Widget buildButtonByType(BuildContext context, String? type, Message message,
    ChatProvider chatProvider) {
  final s = S.of(context);

  // Handle faqRetriever with non-empty appUrls before switch
  if (_isFaqRetrieverWithValidUrls(type, message)) {
    return _buildFaqRetrieverButton(context, message, chatProvider, s);
  }

  // Handle standard types
  return _buildStandardTypeButton(context, type, message, chatProvider, s);
}

/// Checks if this is a faqRetriever with valid URLs
bool _isFaqRetrieverWithValidUrls(String? type, Message message) {
  return type == AppConst.faqRetriever &&
      message.aiChatResponse?.data[0].items.appUrls.isNotEmpty == true &&
      message.aiChatResponse?.data[0].items.appUrls != AppConst.openEvaChat;
}

/// Builds the faqRetriever button
Widget _buildFaqRetrieverButton(
    BuildContext context, Message message, ChatProvider chatProvider, S s) {
  final appUrl = message.aiChatResponse!.data[0].items.appUrls;
  final ctaText = _getCtaText(appUrl, s);

  return Column(
    children: [
      AiAssistantNavButtonWidget(
        message: message,
        chatProvider: chatProvider,
        ctaText: ctaText,
        url: appUrl,
        isRedirectToBooking: false,
        isComeFromFAQ: true,
      ),
      AiAssistantRateEvaWidget(
        message: message,
        chatProvider: chatProvider,
        isComeFromFaq: true,
        showLike: true,
      )
    ],
  );
}

/// Gets the CTA text based on app URL and platform
String _getCtaText(String appUrl, S s) {
  final isIOS = !kIsWeb && Platform.isIOS;
  final isAndroid = !kIsWeb && Platform.isAndroid;

  final ctaLabelMap = {
    AppConst.openAppStore: isIOS
        ? s.open_app_store
        : isAndroid
            ? s.open_play_store
            : s.open_app_store,
    AppConst.openPlayStore: s.open_play_store,
    AppConst.openContactVisa: s.contact_visa_support,
    AppConst.openVisaGO: s.visa_go,
    AppConst.openResetPassword: s.reset_password,
    AppConst.openProfileBiometric: s.open_profile,
    AppConst.openWallet: s.open_wallet,
    AppConst.openFAQ: s.open_faq,
    AppConst.openPrepaidCard: s.open_prepaid_card,
    AppConst.openEvaChat: s.open_eva_chat,
    AppConst.openTicket: s.open_ticket,
    AppConst.openCompanion: s.open_companion,
    AppConst.openBookTravel: s.open_book_travel,
    AppConst.openBookingCom: s.booking_com,
  };

  return ctaLabelMap[appUrl] ?? s.txt_continue;
}

/// Builds standard type buttons
Widget _buildStandardTypeButton(BuildContext context, String? type,
    Message message, ChatProvider chatProvider, S s) {
  switch (type) {
    case AppConst.flightKey:
      return _buildFlightButton(message, chatProvider, s);
    case AppConst.directionsKey:
      return _buildDirectionsButton(message, chatProvider, s);
    case AppConst.flightKey ||
          AppConst.directionsKey ||
          AppConst.getWeatherKey ||
          AppConst.getSearchPlacesKey ||
          AppConst.bookingKey ||
          "":
      return _buildDefaultButton(type, message, chatProvider);
    default:
      return _buildDefaultRateWidget(message, chatProvider);
  }
}

/// Builds the flight button
Widget _buildFlightButton(Message message, ChatProvider chatProvider, S s) {
  return Column(
    children: [
      AiAssistantNavButtonWidget(
        message: message,
        chatProvider: chatProvider,
        ctaText: s.view_and_book_flights,
        url: message.aiChatResponse!.data[0].items.flightUrl,
        isRedirectToBooking: true,
        isComeFromFAQ: false,
      ),
      AiAssistantRateEvaWidget(
        message: message,
        chatProvider: chatProvider,
        showLike: false,
      )
    ],
  );
}

/// Builds the directions button
Widget _buildDirectionsButton(Message message, ChatProvider chatProvider, S s) {
  return Column(
    children: [
      AiAssistantNavButtonWidget(
        message: message,
        chatProvider: chatProvider,
        ctaText: s.open_in_maps,
        url: message.aiChatResponse!.data[0].items.googleMapUrl,
        isRedirectToBooking: false,
        isComeFromFAQ: false,
      ),
      AiAssistantRateEvaWidget(
        message: message,
        chatProvider: chatProvider,
        showLike: false,
      )
    ],
  );
}

/// Builds the default button for certain types
Widget _buildDefaultButton(
    String? type, Message message, ChatProvider chatProvider) {
  return Column(
    children: [
      const SizedBox.shrink(),
      type.isNullOrEmpty
          ? const SizedBox.shrink()
          : AiAssistantRateEvaWidget(
              message: message,
              chatProvider: chatProvider,
              showLike: false,
            )
    ],
  );
}

/// Builds the default rate widget
Widget _buildDefaultRateWidget(Message message, ChatProvider chatProvider) {
  return AiAssistantRateEvaWidget(
    message: message,
    chatProvider: chatProvider,
    showLike: true,
  );
}

// Helper method to return the correct widget based on type
Widget buildCardByType(
    String? mType, Message message, ChatProvider chatProvider) {
  final type = mType;
  final data = message.aiChatResponse?.data;

  if (type == null || data == null || data.isEmpty) {
    return const SizedBox.shrink();
  }

  switch (type) {
    case AppConst.getWeatherKey:
      return AiAssistantWeatherCardWidget(
        message: message,
      );

    case AppConst.getSearchPlacesKey:
      return AiAssistantSearchPlacesCardWidget(
        message: message,
        chatProvider: chatProvider,
      );

    case AppConst.bookingKey:
      return AiAssistantBookingComCardWidget(
        message: message,
        chatProvider: chatProvider,
      );

    default:
      return const SizedBox.shrink();
  }
}
