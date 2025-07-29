import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/theme/theme.dart';
import '../../../../../custom_widgets/visa_size_box.dart';
import '../../../../../custom_widgets/visa_textview.dart';
import '../../../../../generated/l10n.dart';
import '../../../../../utils/const_screen_size.dart';
import '../../../../../utils/date_util.dart';
import '../../../models/ai_chat_items_model.dart';

class AiAssistantWeatherSevenDayForecastCardWidget extends StatelessWidget {
  final AiChatItems aiChatItems;

  const AiAssistantWeatherSevenDayForecastCardWidget({
    super.key,
    required this.aiChatItems,
  });

  @override
  Widget build(BuildContext context) {
    var listWeatherForecast = aiChatItems.forecast;
    var s = S.of(context);
    return listWeatherForecast.isNotEmpty
        ? Semantics(
            container: true,
            enabled: true,
            label: "${s.seven_day_forecast_for} ${aiChatItems.location}",
            child: Container(
              padding: EdgeInsets.symmetric(
                vertical: AppSizes.tweentyHeight,
                horizontal: AppSizes.dimSmall,
              ),
              decoration: BoxDecoration(
                color: VisaColors.weatherCardColor, // Light blue background
                borderRadius: BorderRadius.circular(
                  Sizes.sixteen,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    spacing: 20.r,
                    children: listWeatherForecast.map((day) {
                      final shortDay =
                          DateUtil.getShortDayOfWeek(context, day.date);
                      final highTemp = "${day.maxTempF.toInt()}${s.fahrenheit}";
                      final lowTemp = "${day.minTempF.toInt()}${s.fahrenheit}";
                      final weatherType = day.weatherType;

                      return Semantics(
                        container: true,
                        enabled: true,
                        label:
                            '$shortDay: $weatherType. ${s.high_text} $highTemp, ${s.low_text} $lowTemp.',
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // Day abbreviation (Su, Mo, Tu, etc.)
                            Expanded(
                              flex: 2,
                              child: Container(
                                color: Colors.transparent,
                                child: VisaTextView(
                                  semantics: false,
                                  text: shortDay,
                                  colorTheme: VisaTextTheme.customTextColor,
                                  style: VisaTextStyle.custom,
                                  customColor: VisaColors.chatTextColor,
                                  fontSize: Sizes.fourteenInt.toDouble(),
                                  fontFamily: VisaFontWeight.bold,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                            // Weather icon
                            Expanded(
                              flex: 4,
                              child: ExcludeSemantics(
                                child: Container(
                                  color: Colors.transparent,
                                  child: Image.network(
                                    "https:${day.icon}",
                                    height: 42.h,
                                    width: 42.w,
                                    alignment: Alignment.center,
                                  ),
                                ),
                              ),
                            ),
                            // High & Low Temperatures
                            Expanded(
                              flex: 4,
                              child: Container(
                                color: Colors.transparent,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    // High Temp
                                    VisaTextView(
                                      semantics: false,
                                      text: highTemp,
                                      colorTheme: VisaTextTheme.customTextColor,
                                      style: VisaTextStyle.custom,
                                      customColor: VisaColors.chatTextColor,
                                      fontSize: Sizes.fourteenInt.toDouble(),
                                      fontFamily: VisaFontWeight.bold,
                                      textAlign: TextAlign.center,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    VisaSizeBox(width: AppSizes.eightWidth),
                                    // Low Temp
                                    Flexible(
                                      child: VisaTextView(
                                        semantics: false,
                                        text: lowTemp,
                                        colorTheme:
                                            VisaTextTheme.customTextColor,
                                        style: VisaTextStyle.custom,
                                        customColor:
                                            VisaColors.weatherCardTextGreyColor,
                                        fontSize: Sizes.fourteenInt.toDouble(),
                                        fontFamily: VisaFontWeight.medium,
                                        textAlign: TextAlign.center,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          )
        : const SizedBox.shrink();
  }
}
