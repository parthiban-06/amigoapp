import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:visaamigo/core/theme/theme.dart';
import 'package:visaamigo/custom_widgets/visa_button.dart';
import 'package:visaamigo/features/tickets/provider/ticket_provider.dart';
import 'package:visaamigo/utils/app_extensions.dart';

import '../../../custom_widgets/visa_rich_text.dart';
import '../../../custom_widgets/visa_svg_icon.dart';
import '../../../custom_widgets/visa_textview.dart';
import '../../../generated/assets.dart';
import '../../../generated/l10n.dart';
import '../../../utils/const_screen_size.dart';
import '../../profile/provider/user_generic_detail_provider.dart';

// ignore: must_be_immutable
class TicketDetailsWidget extends StatelessWidget {
  TicketProvider? ticketProvider;
  late double twentyFont;
  late double fontfourteen;

  TicketDetailsWidget(this.ticketProvider, {super.key});

  @override
  Widget build(BuildContext context) {
    var s = S.of(context);
    twentyFont = AppSizes.fontTweenty;
    fontfourteen = AppSizes.fontfourteen;
    final userProvider =
        Provider.of<UserGenericProvider>(context, listen: false);
    return Container(
      width: context.screenWidth,
      padding: EdgeInsets.all(Sizes.twentyFour),
      decoration: ShapeDecoration(
        color: VisaColors.white,
        shape: RoundedRectangleBorder(
          side: BorderSide(width: AppSizes.oneWidth),
          borderRadius: BorderRadius.circular(Sizes.ten),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(AppSizes.eightRadius),
            decoration: ShapeDecoration(
              color: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppSizes.twentySixRadius),
              ),
            ),
            child: VisaSvgIcon(
              semantics: false,
              assetPath: Assets.iconsIcTicket,
              color: VisaColors.white,
              width: AppSizes.tweentyWidth,
              height: AppSizes.tweentyHeight,
            ),
          ),
          AppSizes.mediumVS,
          (ticketProvider!.userMatches == null ||
                  ticketProvider!.userMatches?.data == null ||
                  ticketProvider!.userMatches!.data.isEmpty)
              ? Column(
                  children: [
                    VisaTextView(
                      text: s.nothing_to_see_here,
                      style: VisaTextStyle.displayTitleSmall,
                      fontSize: AppSizes.fontTweenty,
                      textLineHeight: 1.05,
                      textAlign: TextAlign.center,
                      letterSpacing: -1,
                      maxLines: 3,
                      fontFamily: VisaFontWeight.semibold,
                      colorTheme: VisaTextTheme.customTextColor,
                      customColor: VisaColors.chatTextColor,
                    ),
                    AppSizes.xxsmallVS,
                    VisaRichText(
                      maxLines: 3,
                      textAlign: TextAlign.center,
                      textSpans: [
                        VisaTextSpan(
                          text: ' ${S.of(context).no_match_ticket_message} \n',
                          style: VisaTextStyle.custom,
                          fontSize: AppSizes.fontfourteen,
                          fontFamily: VisaFontWeight.regular,
                          colorTheme: VisaTextTheme.textColorBlack,
                          lineHeight: 1.29,
                          textLineHeight: 1.29,
                        ),
                        VisaTextSpan(
                          text: ' ${S.of(context).see_our}',
                          style: VisaTextStyle.custom,
                          fontSize: AppSizes.fontfourteen,
                          fontFamily: VisaFontWeight.regular,
                          colorTheme: VisaTextTheme.textColorBlack,
                          lineHeight: 1.29,
                          textLineHeight: 1.29,
                        ),
                        VisaTextSpan(
                          text: S.of(context).faqs,
                          style: VisaTextStyle.custom,
                          fontSize: AppSizes.fontfourteen,
                          fontFamily: VisaFontWeight.bold,
                          decoration: TextDecoration.underline,
                          lineHeight: 1.29,
                          textLineHeight: 1.29,
                          onTap: () {
                            // open FIFA

                            ticketProvider?.openFaq();
                          },
                        ),
                        VisaTextSpan(
                          text: ' ${S.of(context).more_information}',
                          style: VisaTextStyle.custom,
                          fontSize: AppSizes.fontfourteen,
                          fontFamily: VisaFontWeight.regular,
                          colorTheme: VisaTextTheme.textColorBlack,
                          lineHeight: 1.29,
                          textLineHeight: 1.29,
                        ),
                      ],
                    ),
                  ],
                )
              : (ticketProvider!.userMatches!.data![0].matchTime
                          .difference(DateTime.now())
                          .inDays >=
                      ticketProvider!.noOfDaysDifference)
                  ? Column(
                      children: [
                        FittedBox(
                          child: VisaTextView(
                            text: (userProvider.isCompanion ?? false)
                                ? s.ticket_available_soon_companion
                                : s.ticket_released_days,
                            style: VisaTextStyle.displayTitleSmall,
                            fontSize: twentyFont,
                            textLineHeight: 1.05,
                            textAlign: TextAlign.center,
                            letterSpacing: -1,
                            maxLines: 3,
                            fontFamily: VisaFontWeight.semibold,
                            colorTheme: VisaTextTheme.customTextColor,
                            customColor: VisaColors.chatTextColor,
                          ),
                        ),
                        SizedBox(
                          height: AppSizes.ten,
                        ),
                        FittedBox(
                          child: VisaTextView(
                            text: (userProvider.isCompanion ?? false)
                                ? s.ticket_notifi_when_available_companion
                                : s.ticket_notify_when_available,
                            style: VisaTextStyle.displayBodyS,
                            fontSize: twentyFont,
                            textLineHeight: 1.29,
                            lineHeight: 1.29,
                            textAlign: TextAlign.center,
                            letterSpacing: 0,
                            maxLines: 3,
                            colorTheme: VisaTextTheme.textColorBlack,
                          ),
                        ),
                      ],
                    )
                  : Column(
                      children: [
                        VisaTextView(
                          text: s.ticket_ready,
                          style: VisaTextStyle.displayTitleSmall,
                          fontSize: twentyFont,
                          textLineHeight: 1.05,
                          textAlign: TextAlign.center,
                          letterSpacing: -1,
                          maxLines: 3,
                          fontFamily: VisaFontWeight.semibold,
                          colorTheme: VisaTextTheme.customTextColor,
                          customColor: VisaColors.chatTextColor,
                        ),
                        SizedBox(
                          height: AppSizes.ten,
                        ),
                        (userProvider.isCompanion ?? false)
                            ? VisaTextView(
                                text: s.ticket_by_host_avavaible_companion,
                                style: VisaTextStyle.displayBodyS,
                                fontSize: Sizes.twentyInt.toDouble(),
                                textLineHeight: 1.29,
                                lineHeight: 1.29,
                                textAlign: TextAlign.center,
                                letterSpacing: -1,
                                maxLines: 3,
                                colorTheme: VisaTextTheme.textColorBlack,
                              )
                            : Align(
                                alignment: Alignment.center,
                                child: VisaRichText(
                                  maxLines: 3,
                                  textAlign: TextAlign.center,
                                  textSpans: [
                                    VisaTextSpan(
                                      text: S.of(context).ticket_access_info_1,
                                      style: VisaTextStyle.displayBodyS,
                                      fontFamily: VisaFontWeight.regular,
                                      colorTheme: VisaTextTheme.textColorBlack,
                                      lineHeight: 1.29,
                                      textLineHeight: 1.29,
                                    ),
                                    VisaTextSpan(
                                      text: S.of(context).ticket_access_info_2,
                                      style: VisaTextStyle.bodyMedium,
                                      fontFamily: VisaFontWeight.bold,
                                      colorTheme: VisaTextTheme.textColorBlack,
                                      lineHeight: 1.29,
                                      textLineHeight: 1.29,
                                    ),
                                    VisaTextSpan(
                                      text: S.of(context).ticket_access_info_3,
                                      style: VisaTextStyle.displayBodyS,
                                      fontFamily: VisaFontWeight.regular,
                                      colorTheme: VisaTextTheme.textColorBlack,
                                      lineHeight: 1.29,
                                      textLineHeight: 1.29,
                                    ),
                                  ],
                                ),
                              ),
                        if (!(userProvider.isCompanion ?? false))
                          AppSizes.mediumVS,
                        (userProvider.isCompanion ?? false)
                            ? Container()
                            : VisaButton(
                                text: s.ticket_get_fifa_app,
                                fontSize: Sizes.eighteenInt.toDouble(),
                                lineHeight: 1.39,
                                onPressed: () {
                                  ticketProvider?.showReminderDialog(
                                      context, ticketProvider?.userData);
                                },
                                variant: VisaButtonVariant.black,
                              )
                      ],
                    )
        ],
      ),
    );
  }
}
