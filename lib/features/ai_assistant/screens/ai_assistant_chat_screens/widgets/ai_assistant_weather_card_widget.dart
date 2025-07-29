import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/theme/theme.dart';
import '../../../../../custom_widgets/visa_size_box.dart';
import '../../../../../custom_widgets/visa_textview.dart';
import '../../../../../generated/l10n.dart';
import '../../../../../utils/const_screen_size.dart';
import '../ai_message.dart';
import 'ai_assistant_weather_report_card_widget.dart';
import 'ai_assistant_weather_seven_day_forecast_card_widget.dart';

class AiAssistantWeatherCardWidget extends StatelessWidget {
  final Message message;

  const AiAssistantWeatherCardWidget({required this.message, super.key});

  @override
  Widget build(BuildContext context) {
    final shouldShowWeather = (!message.isFinalText &&
            message.isFinalTextEmpty &&
            (!message.isTyping || message.isTyping)) ||
        (message.isFinalText && (!message.isTyping || message.isTyping));

    if (!shouldShowWeather) return const SizedBox.shrink();

    final items = message.aiChatResponse!.data[0].items;

    var listWeatherForecast = items.forecast;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        listWeatherForecast.isNotEmpty
            ? VisaSizeBox(height: Sizes.twelveInt.h)
            : const SizedBox.shrink(),
        AiAssistantWeatherReportCardWidget(aiChatItems: items),
        listWeatherForecast.isNotEmpty
            ? VisaSizeBox(height: AppSizes.tweentyHeight)
            : const SizedBox.shrink(),
        AiAssistantWeatherSevenDayForecastCardWidget(aiChatItems: items),
        if (message.aiChatResponse!.data[0].tag.isNotEmpty)
          SourceWidget(message: message),
        VisaSizeBox(height: AppSizes.tweentyHeight),
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
    final sourceTag =
        "${S.of(context).source} - ${message.aiChatResponse!.data[0].tag}";
    return Padding(
      padding: EdgeInsets.only(top: Sizes.ten),
      child: Semantics(
        container: true,
        child: VisaTextView(
          text: sourceTag,
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
