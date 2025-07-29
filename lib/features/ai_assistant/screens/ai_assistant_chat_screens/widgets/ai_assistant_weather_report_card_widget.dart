import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:visaamigo/core/theme/theme.dart';
import 'package:visaamigo/custom_widgets/visa_size_box.dart';
import 'package:visaamigo/custom_widgets/visa_textview.dart';
import 'package:visaamigo/features/ai_assistant/models/ai_chat_items_model.dart';

import '../../../../../generated/l10n.dart';
import '../../../../../utils/const_screen_size.dart';

class AiAssistantWeatherReportCardWidget extends StatelessWidget {
  final AiChatItems aiChatItems;

  const AiAssistantWeatherReportCardWidget(
      {super.key, required this.aiChatItems});

  @override
  Widget build(BuildContext context) {
    var listWeatherForecast = aiChatItems.forecast;
    var s = S.of(context);
    return listWeatherForecast.isNotEmpty
        ? Semantics(
            container: true,
            enabled: true,
            label:
                '${s.city}: ${aiChatItems.location}. ${s.temp_text}: ${listWeatherForecast[0].tempF} ${s.fahrenheit}. '
                '${listWeatherForecast[0].weatherType}. ${s.low_text} ${listWeatherForecast[0].minTempF} ${s.fahrenheit}, '
                '${s.high_text} ${listWeatherForecast[0].maxTempF} ${s.fahrenheit}.',
            child: Container(
              padding: EdgeInsets.symmetric(
                vertical: AppSizes.tweentyHeight,
                horizontal: Sizes.twentyInt.w,
              ),
              decoration: BoxDecoration(
                color: VisaColors.weatherCardColor,
                borderRadius: BorderRadius.circular(Sizes.sixteen),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Left Section
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        VisaTextView(
                          semantics: false,
                          text: aiChatItems.location,
                          colorTheme: VisaTextTheme.customTextColor,
                          style: VisaTextStyle.custom,
                          customColor: VisaColors.chatTextColor,
                          fontSize: Sizes.fourteenInt.toDouble(),
                          fontFamily: VisaFontWeight.medium,
                        ),
                        VisaSizeBox(height: AppSizes.heightSmall),
                        VisaTextView(
                          semantics: false,
                          text:
                              '${listWeatherForecast[0].tempF}${s.fahrenheit}',
                          colorTheme: VisaTextTheme.customTextColor,
                          style: VisaTextStyle.custom,
                          customColor: VisaColors.chatTextColor,
                          fontSize: Sizes.thirtyInt.toDouble(),
                          fontFamily: VisaFontWeight.bold,
                          letterSpacing: -1,
                        ),
                        VisaSizeBox(height: Sizes.fiveInt.h),
                        VisaTextView(
                          semantics: false,
                          text: listWeatherForecast[0].weatherType,
                          colorTheme: VisaTextTheme.customTextColor,
                          style: VisaTextStyle.custom,
                          customColor: VisaColors.chatTextColor,
                          fontSize: Sizes.twelveInt.toDouble(),
                          fontFamily: VisaFontWeight.medium,
                        ),
                        VisaSizeBox(height: AppSizes.heightSmall),
                        Row(
                          children: [
                            VisaTextView(
                              semantics: false,
                              text:
                                  '${s.low}${listWeatherForecast[0].minTempF}${s.fahrenheit}',
                              colorTheme: VisaTextTheme.customTextColor,
                              style: VisaTextStyle.custom,
                              customColor: VisaColors.chatTextColor,
                              fontSize: Sizes.fourteenInt.toDouble(),
                              fontFamily: VisaFontWeight.medium,
                            ),
                            VisaSizeBox(width: AppSizes.eightWidth),
                            VisaTextView(
                              semantics: false,
                              text:
                                  '${s.high}${listWeatherForecast[0].maxTempF}${s.fahrenheit}',
                              colorTheme: VisaTextTheme.customTextColor,
                              style: VisaTextStyle.custom,
                              customColor: VisaColors.chatTextColor,
                              fontSize: Sizes.fourteenInt.toDouble(),
                              fontFamily: VisaFontWeight.medium,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  // Weather Icon
                  ExcludeSemantics(
                    child: Align(
                      alignment: Alignment.topRight,
                      child: Image.network(
                        "https:${listWeatherForecast[0].icon}",
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        : const SizedBox.shrink();
  }
}
