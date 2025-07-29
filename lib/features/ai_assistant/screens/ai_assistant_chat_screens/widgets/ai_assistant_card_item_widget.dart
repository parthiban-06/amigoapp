import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:visaamigo/custom_widgets/visa_ai_chat_title_widget.dart';
import 'package:visaamigo/features/ai_assistant/models/ai_messages_model.dart';
import 'package:visaamigo/features/ai_assistant/providers/ai_assistant_threads_screen_provider.dart';

import '../../../../../core/theme/theme.dart';
import '../../../../../custom_widgets/visa_ai_chat_response_widget.dart';
import '../../../../../custom_widgets/visa_custom_inital_letter.dart';
import '../../../../../custom_widgets/visa_textview.dart';
import '../../../../../generated/assets.dart';
import '../../../../../utils/const_screen_size.dart';
import '../../../models/ai_chat_model.dart';

class AiAssistantCardItemWidget extends StatelessWidget {
  final AiAssistantThreadsScreenProvider viewModel;
  final bool isSentByMe;
  final bool isLastItem;
  final bool isAiLastItem;
  final Message message;

  const AiAssistantCardItemWidget({
    super.key,
    required this.isSentByMe,
    required this.message,
    required this.viewModel,
    required this.isLastItem,
    required this.isAiLastItem,
  });

  @override
  Widget build(BuildContext context) {
    return (isSentByMe)
        ? Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.end,
            mainAxisSize: MainAxisSize.min, // Prevent infinite expansion
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: VisaColors.blueBackgroundLight,
                    borderRadius: BorderRadius.circular(Sizes.sixteen),
                  ),
                  padding: EdgeInsets.all(
                    Sizes.twenty,
                  ),
                  child: VisaChatTitleWidget(
                    showEditIcon: isLastItem,
                    iconHeight: Sizes.eighteen,
                    iconPath: Assets.iconsEva,
                    iconColor: VisaColors.error,
                    text: message.message,
                    style: VisaTextStyle.displayBodyL,
                    colorTheme: VisaTextTheme.customTextColor,
                    customColor: VisaColors.black,
                    fontFamily: VisaFontWeight.bold,
                    lineHeight: 1.20,
                    letterSpacing: -0.16,
                    onEditTap: () {
                      viewModel.removeLastConversionToEdit(message.message);
                    },
                  ),
                ),
              ),
              AppSizes.xxsmallVS,
              CircleLetterWidget(
                letter: viewModel.userNameInitial ?? "",
              )
            ],
          )
        : Container(
            padding: EdgeInsets.symmetric(vertical: Sizes.twelve),
            margin: EdgeInsets.only(right: Sizes.fifty),
            child: Column(
              mainAxisSize: MainAxisSize.min, // ✅ Fix: Prevents infinite height

              children: [
                VisaChatResponseWidget(
                  showEditIcon: false,
                  isLastIndex: isAiLastItem,
                  iconHeight: Sizes.eighteen,
                  iconPath: Assets.iconsEva,
                  iconMargin: EdgeInsets.all(Sizes.six),
                  iconColor: VisaColors.black,
                  text: utf8.decode(RegExp(r'\\x([0-9a-fA-F]{2})')
                      .allMatches(message.message)
                      .map((match) => int.parse(match.group(1)!, radix: 16))
                      .toList()),
                  style: VisaTextStyle.displayBodyL,
                  colorTheme: VisaTextTheme.customTextColor,
                  customColor: VisaColors.black,
                  fontFamily: VisaFontWeight.bold,
                  lineHeight: 1.20,
                ),
                AppSizes.xxsmallVS,
                Container(
                  margin: EdgeInsets.only(left: Sizes.twentyEight),
                  child: VisaChatResponseWidget(
                    showEditIcon: false,
                    isLastIndex: isAiLastItem,
                    showGlitterIcon: false,
                    iconHeight: Sizes.eighteen,
                    iconPath: Assets.iconsEva,
                    iconMargin: EdgeInsets.all(Sizes.six),
                    iconColor: VisaColors.black,
                    text: message.aiCharResponse?.finalText ?? "",
                    style: VisaTextStyle.displayBodyS,
                    colorTheme: VisaTextTheme.customTextColor,
                    customColor: VisaColors.black,
                    fontFamily: VisaFontWeight.medium,
                    lineHeight: 1.29,
                  ),
                ),
              ],
            ),
          );
  }

  // Widget to build card chips
  Widget _buildChoices(dynamic question) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        ...question.choices?.map((choice) {
              return ElevatedButton(
                  onPressed: () => viewModel.handleUserChoice(choice),
                  child: VisaTextView(
                    text: choice.text ?? "",
                    colorTheme: VisaTextTheme.primary,
                    style: VisaTextStyle.custom,
                  ));
            }).toList() ??
            [],
      ],
    );
  }

  // Build the weather forecast card
  Widget _buildWeatherForecast(DynamicResponse? dynamicResponse) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (dynamicResponse?.forecast == null ||
            dynamicResponse!.forecast!.isNotEmpty)
          // 7-Day Forecast Card
          _build7DayForecast(dynamicResponse?.forecast),
        if (dynamicResponse?.temperature != null)
          // Current Weather Card
          Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            elevation: 1,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        "${dynamicResponse?.temperature?.value}° ${dynamicResponse?.temperature?.unit}",
                        style: TextStyle(
                            fontSize: 32.sp, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(width: 10),
                      Text(_getWeatherIcon(dynamicResponse?.conditions),
                          style: const TextStyle(fontSize: 32)),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(dynamicResponse?.date ?? "",
                      style: TextStyle(fontSize: 16.sp, color: Colors.grey)),
                  const SizedBox(height: 8),
                  Text(dynamicResponse?.conditions ?? "",
                      style: TextStyle(
                          fontSize: AppSizes.fontMedium,
                          fontWeight: FontWeight.w600)),
                  const SizedBox(height: 8),
                  Text(
                    "Humidity: ${dynamicResponse?.humidity} | Wind: ${dynamicResponse?.windSpeed}",
                    style: TextStyle(
                        fontSize: AppSizes.fontfourteen,
                        color: Colors.grey[700]),
                  ),
                ],
              ),
            ),
          ),
        const SizedBox(height: 12),
        if (!isSentByMe && message.followUpQuestions != null)
          _buildChoices(message.followUpQuestions!),
      ],
    );
  }

  // Weather Icon Mapping
  String _getWeatherIcon(String? condition) {
    if (condition == null) return "☀️"; // Default icon
    if (condition.toLowerCase().contains("clear")) return "☀️";
    if (condition.toLowerCase().contains("cloud")) return "☁️";
    if (condition.toLowerCase().contains("rain")) return "🌧️";
    if (condition.toLowerCase().contains("storm")) return "⛈️";
    if (condition.toLowerCase().contains("snow")) return "❄️";
    if (condition.toLowerCase().contains("fog")) return "🌫️";
    return "☀️";
  }

  // Widget to build the 7-day forecast list
  Widget _build7DayForecast(List<WeatherForecast>? forecast) {
    if (forecast == null || forecast.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("7-Day Forecast",
            style: TextStyle(
                fontSize: AppSizes.fontMedium, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: forecast.length,
          itemBuilder: (context, index) {
            var dayForecast = forecast[index];
            return ListTile(
              leading: Text(_getWeatherIcon(dayForecast.condition),
                  style: const TextStyle(fontSize: 24)),
              title: Text(dayForecast.day!,
                  style:
                      TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w500)),
              trailing: Text(
                "${dayForecast.temperature?.high}° / ${dayForecast.temperature?.low}°",
                style: const TextStyle(fontSize: 16),
              ),
            );
          },
        ),
      ],
    );
  }
}
