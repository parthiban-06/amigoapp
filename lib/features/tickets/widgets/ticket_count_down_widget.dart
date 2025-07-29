import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:visaamigo/core/theme/theme.dart';
import 'package:visaamigo/custom_widgets/visa_auto_size_text.dart';
import 'package:visaamigo/custom_widgets/visa_image.dart';
import 'package:visaamigo/custom_widgets/visa_size_box.dart';
import 'package:visaamigo/custom_widgets/visa_textview.dart';
import 'package:visaamigo/utils/const_screen_size.dart';
import 'package:visaamigo/utils/date_util.dart';
import 'package:visaamigo/utils/utils.dart';

import '../../../core/base/view/base_view.dart';
import '../../../generated/assets.dart';
import '../../../generated/l10n.dart';
import '../provider/ticket_counter_provider.dart';

class TicketsCountDownWidget extends StatelessWidget {
  const TicketsCountDownWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);

    return BaseView<TicketCounterProvider>(
        onlyDesktop: false,
        screenBackgroundColor: VisaColors.white,
        extendBodyBehindAppBar: false,
        addDefaultPadding: false,
        wrapWithSafeArea: false,
        resizeToAvoidBottomInset: false,
        viewModel: TicketCounterProvider(),
        onModelReady: (model) {
          model.init(context);
        },
        screenBackgroundImage: null,
        onPageBuilderMobileView:
            (BuildContext context, TicketCounterProvider viewModel) {
          final strings = S.of(context);
          final now = DateTime.now();

          String semanticLabel;

          if (now.isBefore(viewModel.fifaStartTime)) {
            semanticLabel = "${strings.countdown_to_fifa_word_cup} "
                "${viewModel.timeLeft!.inDays}${strings.days.toLowerCase()}, "
                "${viewModel.timeLeft!.inHours % 24}${strings.hours.toLowerCase()}, "
                "${viewModel.timeLeft!.inMinutes % 60}${strings.minutes.toLowerCase()}";
          } else if (DateUtil.isBetweenInclusive(
              now, viewModel.fifaStartTime, viewModel.fifaLeagueStart)) {
            semanticLabel = strings.match_officially_begun;
          } else if (DateUtil.isBetweenInclusive(
              now, viewModel.fifaLeagueStart, viewModel.fifaEndTime)) {
            semanticLabel = strings.playoff_underway;
          } else {
            semanticLabel = strings.match_thanks_joining;
          }

          return Semantics(
            label: semanticLabel,
            container: true,
            enabled: true,
            excludeSemantics: true,
            focused: true,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: AppSizes.borderRadiusSmall,
                image: const DecorationImage(
                  image: AssetImage(Assets.imagesBgTicketDetails),
                  // Replace with your image path
                  fit: BoxFit.cover,
                ),
              ),
              child: Stack(children: [
                Container(
                  // Layer for gradient over the image
                  decoration: BoxDecoration(
                    borderRadius: AppSizes.borderRadiusSmall,
                    gradient: const LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      stops: [0.5107, 0.694],
                      colors: [
                        // Color(0xFF000000),
                        Color.fromRGBO(0, 0, 0, 0.7),
                        Color.fromRGBO(0, 0, 0, 0.0),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  bottom: Sizes.sixteen +
                      (Utils.getFontSize(context) ? Sizes.twentyInt.h : 0),
                  left: !DateTime.now().isBefore(viewModel.fifaStartTime)
                      ? Sizes.zero
                      : AppSizes.fiftyFiveRadius,
                  right: !DateTime.now().isBefore(viewModel.fifaStartTime)
                      ? Sizes.zero
                      : AppSizes.fiftyFiveRadius,
                  child: Container(
                    // color: Colors.blue,
                    height: Sizes.hundredInt.h,
                    alignment: Alignment.center,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.end,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Center(
                          child: VisaImageIcon(
                            semantics: false,
                            assetPath: Assets.imagesFifaTrophyWithWhiteBg,
                            height: Sizes.fiftyInt.h,
                            width: Sizes.thirtyTwoInt.w,
                          ),
                        ),
                        SizedBox(
                          width: AppSizes.fifteenDim,
                        ),
                        Flexible(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              DateTime.now().isBefore(viewModel.fifaStartTime)
                                  ? VisaSizeBox(
                                      height: Sizes.threeInt.h,
                                    )
                                  : VisaSizeBox(
                                      height: Sizes.tenInt.h,
                                    ),
                              Flexible(
                                child: FittedBox(
                                  child: VisaAutoSizeText(
                                    semantics: false,
                                    text: s.fifa_word_cup_26,
                                    fontSize: AppSizes.fontNineteen,
                                    fontFamily: VisaFontWeight.bold,
                                    style: VisaTextStyle.custom,
                                    colorTheme: VisaTextTheme.customTextColor,
                                    customColor: VisaColors.white,
                                    lineHeight: 1.06,
                                    letterSpacing: -0.81,
                                  ),
                                ),
                              ),
                              VisaSizeBox(
                                height: DateTime.now()
                                        .isBefore(viewModel.fifaStartTime)
                                    ? AppSizes.sixHeight
                                    : 0,
                              ),
                              DateTime.now().isBefore(
                                      viewModel.fifaStartTime) // before start
                                  ? Row(
                                      mainAxisSize: MainAxisSize.max,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Expanded(
                                            flex: 1,
                                            child: customCounterTime(
                                                context,
                                                s.days.toUpperCase(),
                                                (viewModel.timeLeft!.inDays)
                                                    .toString(),
                                                1)),
                                        Expanded(
                                            flex: 1,
                                            child: customCounterTime(
                                                context,
                                                "${s.hrs} ",
                                                (viewModel.timeLeft!.inHours %
                                                        24)
                                                    .toString(),
                                                2)),
                                        Expanded(
                                            flex: 1,
                                            child: customCounterTime(
                                                context,
                                                s.mins,
                                                (viewModel.timeLeft!.inMinutes %
                                                        60)
                                                    .toString(),
                                                3)),
                                      ],
                                    )
                                  : DateUtil.isBetweenInclusive(
                                          DateTime.now(),
                                          viewModel.fifaStartTime,
                                          viewModel
                                              .fifaLeagueStart) // between start and league state
                                      ? Padding(
                                          padding:
                                              const EdgeInsets.only(top: 0),
                                          child: FittedBox(
                                            child: VisaTextView(
                                              semantics: false,
                                              text: s.match_officially_begun
                                                  .toUpperCase(),
                                              colorTheme:
                                                  VisaTextTheme.customTextColor,
                                              fontFamily:
                                                  VisaFontWeight.semibold,
                                              lineHeight: 1.34,
                                              textLineHeight: 1.34,
                                              letterSpacing: 2,
                                              style:
                                                  VisaTextStyle.displayBodyXs,
                                              customColor: VisaColors.white,
                                            ),
                                          ),
                                        )
                                      : DateUtil.isBetweenInclusive(
                                              DateTime.now(),
                                              viewModel.fifaLeagueStart,
                                              viewModel.fifaEndTime) // playoff
                                          ? Padding(
                                              padding:
                                                  const EdgeInsets.only(top: 0),
                                              child: FittedBox(
                                                child: VisaTextView(
                                                  semantics: false,
                                                  text: s.playoff_underway
                                                      .toUpperCase(),
                                                  colorTheme: VisaTextTheme
                                                      .customTextColor,
                                                  fontFamily:
                                                      VisaFontWeight.semibold,
                                                  lineHeight: 1.34,
                                                  textLineHeight: 1.34,
                                                  letterSpacing: 2,
                                                  style: VisaTextStyle
                                                      .displayBodyXs,
                                                  customColor: VisaColors.white,
                                                ),
                                              ),
                                            )
                                          : (DateTime.now().isAfter(viewModel
                                                  .fifaEndTime)) // event end
                                              ? Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 0),
                                                  child: FittedBox(
                                                    child: VisaTextView(
                                                      semantics: false,
                                                      text: s
                                                          .match_thanks_joining
                                                          .toUpperCase(),
                                                      colorTheme: VisaTextTheme
                                                          .customTextColor,
                                                      fontFamily: VisaFontWeight
                                                          .semibold,
                                                      lineHeight: 1.34,
                                                      textLineHeight: 1.34,
                                                      letterSpacing: 2,
                                                      style: VisaTextStyle
                                                          .displayBodyXs,
                                                      customColor:
                                                          VisaColors.white,
                                                    ),
                                                  ),
                                                )
                                              : Padding(
                                                  //event started
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 0),
                                                  child: FittedBox(
                                                    child: VisaTextView(
                                                      semantics: false,
                                                      text: s
                                                          .match_thanks_joining
                                                          .toUpperCase(),
                                                      colorTheme: VisaTextTheme
                                                          .customTextColor,
                                                      fontFamily: VisaFontWeight
                                                          .semibold,
                                                      lineHeight: 1.34,
                                                      textLineHeight: 1.34,
                                                      letterSpacing: 2,
                                                      style: VisaTextStyle
                                                          .displayBodyXs,
                                                      customColor:
                                                          VisaColors.white,
                                                    ),
                                                  ),
                                                )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ]),
            ),
          );
        });
  }

  Widget customCounterTime(
      BuildContext context, String title, String remainingTime, int position) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        position == 1
            ? SizedBox(
                width: Utils.getFontSize(context) ? 10.w : 0,
              )
            : SizedBox(
                width: Utils.getFontSize(context) ? 10.w : 8.w,
              ),
        Flexible(
          child: Column(
            crossAxisAlignment: (position == 1)
                ? CrossAxisAlignment.center
                : CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FittedBox(
                child: VisaAutoSizeText(
                  semantics: false,
                  text: title,
                  fontSize: AppSizes.fontTwelve,
                  fontFamily: VisaFontWeight.medium,
                  style: VisaTextStyle.custom,
                  colorTheme: VisaTextTheme.customTextColor,
                  customColor: VisaColors.white,
                  lineHeight: 1.42,
                  letterSpacing: 2.03,
                ),
              ),
              // AppSizes.xxsmallVS,
              FittedBox(
                child: VisaTextView(
                  semantics: false,
                  text: remainingTime,
                  fontSize: AppSizes.fontTwelve,
                  fontFamily: VisaFontWeight.medium,
                  style: VisaTextStyle.custom,
                  colorTheme: VisaTextTheme.customTextColor,
                  customColor: VisaColors.white,
                  lineHeight: 1.42,
                  letterSpacing: 2.03,
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          width: Sizes.sixteenInt.w,
        ),
        if (position != 3)
          Container(
            color: Colors.white,
            height: AppSizes.thirtyHeight,
            width: AppSizes.oneWidth,
          )
      ],
    );
  }
}
