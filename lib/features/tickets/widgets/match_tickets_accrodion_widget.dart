import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:visaamigo/features/home/model/match_details.dart';
import 'package:visaamigo/features/tickets/provider/ticket_provider.dart';
import 'package:visaamigo/utils/utils.dart';

import '../../../analytics/firebase_analytics_service.dart';
import '../../../core/theme/theme.dart';
import '../../../custom_widgets/accordion/accordion.dart';
import '../../../custom_widgets/visa_button.dart';
import '../../../custom_widgets/visa_svg_icon.dart';
import '../../../custom_widgets/visa_textview.dart';
import '../../../generated/assets.dart';
import '../../../generated/l10n.dart';
import '../../../utils/const_screen_size.dart';
import '../../../utils/date_util.dart';
import '../../select_languages/providers/language_selection_generic_provider.dart';

// ignore: must_be_immutable
class MatchTicketsAccordionWidget extends StatelessWidget {
  final List<MatchData> userMatches;
  final TicketProvider viewModel;
  late double tweleveHeight;
  late double tweleveWidth;
  late double tweentyHeight;
  late double fontfourteen;

  MatchTicketsAccordionWidget(this.userMatches, this.viewModel, {super.key});

  @override
  Widget build(BuildContext context) {
    SelectLanguageGenericProvider localLanguageProvider =
        Provider.of<SelectLanguageGenericProvider>(context, listen: false);
    tweleveHeight = AppSizes.tweleveHeight;
    tweleveWidth = AppSizes.tweleveWidth;
    tweentyHeight = AppSizes.tweentyHeight;
    fontfourteen = AppSizes.fontfourteen;
    return
      (userMatches.length == 1)
        ? Column(
            children: [
              getHeaderItem(userMatches[0], 0, context, viewModel),
              getContentItem(userMatches[0], 0, context, viewModel),
            ],
          )
        :
    Accordion(
            maxOpenSections: userMatches.length,
            // no open/close behavior if 1 item
            headerBackgroundColorOpened: Colors.white,
            contentBackgroundColor: Colors.white,
            paddingListTop: 0,
            contentHorizontalPadding: 0,
            contentVerticalPadding: 0,
            disableScrolling: true,
            openAndCloseAnimation: true,
            headerPadding: EdgeInsets.zero,
            paddingBetweenOpenSections: 0,
            paddingBetweenClosedSections: 0,
            contentBorderRadius: 0,
            paddingListHorizontal: 0,
            contentBorderColor: Colors.white,
            headerBackgroundColor: Colors.white,
            paddingListBottom: 0,
            scaleWhenAnimating: false,
            flipRightIconIfOpen: true,
            flipLeftIconIfOpen: true,
            children: List.generate(
              userMatches.length,
              (index) {
                final item = userMatches[index];

                return AccordionSection(
                  moveUpIcon: Padding(
                    padding: EdgeInsets.only(
                        top: !(localLanguageProvider.isRTL)
                            ? AppSizes.tweleveHeight
                            : AppSizes.heightFourty),
                    child: VisaSvgIcon(
                      semantics: true,
                      semanticsLabel: S.of(context).collapse_details,
                      height: tweleveHeight,
                      width: tweleveWidth,
                      assetPath: Assets.iconsMoveUp,
                    ),
                  ),
                  rightIcon: !(localLanguageProvider.isRTL)
                      ? Padding(
                          padding: EdgeInsets.only(top: AppSizes.tweleveHeight),
                          child: VisaSvgIcon(
                            semantics: true,
                            semanticsLabel: S.of(context).expand_details,
                            height: tweleveHeight,
                            width: tweleveWidth,
                            assetPath: Assets.iconsMoveDown,
                          ),
                        )
                      : const SizedBox.shrink(),
                  paddingBetweenOpenSections: 0,
                  paddingBetweenClosedSections: 0,
                  contentHorizontalPadding: 0,
                  contentVerticalPadding: 0,
                  leftIcon: (localLanguageProvider.isRTL)
                      ? Padding(
                          padding: EdgeInsets.only(top: AppSizes.heightFourty),
                          child: VisaSvgIcon(
                            semantics: true,
                            semanticsLabel: S.of(context).expand_details,
                            height: tweleveHeight,
                            width: tweleveWidth,
                            assetPath: Assets.iconsMoveDown,
                          ),
                        )
                      : const SizedBox.shrink(),
                  headerPadding: EdgeInsets.zero,
                  header: getHeaderItem(item, index, context, viewModel),
                  content: getContentItem(item, index, context, viewModel),
                  onCloseSection: () {
                    sendFirebaseANalytics("collapse", item.matchTeams);
                  },
                  onOpenSection: () {
                    sendFirebaseANalytics("expand", item.matchTeams);
                  },
                );
              },
            ).toList(),
          );
  }

  Widget getHeaderItem(MatchData item, int index, BuildContext context,
      TicketProvider viewModel) {
    return Stack(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: tweentyHeight),
                  VisaTextView(
                    text:
                        "${item.matchCity.toUpperCase()} (${item.tickets.length} ${S.of(context).ticket_count(item.tickets.length).toUpperCase()})",
                    style: VisaTextStyle.displayBodyXs,
                    fontSize: AppSizes.fontTweenty,
                    textAlign: TextAlign.center,
                    maxLines: 3,
                    fontFamily: VisaFontWeight.medium,
                    colorTheme: VisaTextTheme.textColorBlack,
                    textLineHeight: 1.40,
                    lineHeight: 1.40,
                    letterSpacing: 2,
                  ),
                  SizedBox(
                    height: Sizes.threeInt.h,
                  ),
                  Row(
                    children: [
                      // if (item.isTicketExpired)
                      //   Padding(
                      //     padding: EdgeInsetsDirectional.only(end: 5.r),
                      //     child: const VisaSvgIcon(
                      //       assetPath: Assets.iconsIcError,
                      //       setColorFilter: true,
                      //       color: VisaColors.red,
                      //       useWithoutColor: false,
                      //     ),
                      //   ),
                      Expanded(
                        child: VisaTextView(
                          text: "${item.eventName}  ${item.matchTeams}",
                          style: VisaTextStyle.custom,
                          fontSize: Sizes.twentyTwoInt.toDouble(),
                          textAlign: TextAlign.start,
                          maxLines: 2,
                          fontFamily: VisaFontWeight.bold,
                          colorTheme: VisaTextTheme.textColorBlack,
                          textLineHeight: 1.09,
                          lineHeight: 1.09,
                          letterSpacing: -1,
                        ),
                      ),
                    ],
                  ),
                  AppSizes.xxsmallVS,
                ],
              ),
            ),
          ],
        ),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            height: 1.h,
            // width: 600,
            // Thickness of the line
            color: VisaColors.dividerColor,
          ),
        ),
      ],
    );
  }

  Widget getContentItem(MatchData item, int index, BuildContext context,
      TicketProvider viewModel) {
    var s = S.of(context);

    return (item.isTicketExpired)
        ? const SizedBox.shrink()
        // Container(
        //         width: context.screenWidth,
        //         padding: EdgeInsets.all(Sizes.twenty),
        //         margin: EdgeInsets.only(top: Sizes.twenty),
        //         decoration: ShapeDecoration(
        //           color: VisaColors.white,
        //           shape: RoundedRectangleBorder(
        //             side: BorderSide(width: 1.w),
        //             borderRadius: BorderRadius.circular(Sizes.ten),
        //           ),
        //         ),
        //         child: Row(
        //           mainAxisAlignment: MainAxisAlignment.start,
        //           crossAxisAlignment: CrossAxisAlignment.center,
        //           children: [
        //             VisaSvgIcon(
        //               assetPath: Assets.iconsIcTicket,
        //               color: VisaColors.black,
        //               width: Sizes.twentyInt.w,
        //               height: tweentyHeight,
        //             ),
        //             AppSizes.smallVS,
        //             Expanded(
        //               child: Column(
        //                 mainAxisAlignment: MainAxisAlignment.start,
        //                 crossAxisAlignment: CrossAxisAlignment.start,
        //                 children: [
        //                   VisaTextView(
        //                     text: S.of(context).missed_match_ticket,
        //                     style: VisaTextStyle.displayBodyS,
        //                     textAlign: TextAlign.start,
        //                     maxLines: 3,
        //                     fontFamily: VisaFontWeight.bold,
        //                     colorTheme: VisaTextTheme.textColorBlack,
        //                     textLineHeight: 1.12,
        //                     lineHeight: 1.12,
        //                   ),
        //                   AppSizes.xxsmallVS,
        //                   VisaRichText(
        //                     maxLines: 3,
        //                     textAlign: TextAlign.start,
        //                     textSpans: [
        //                       VisaTextSpan(
        //                         text: ' ${S.of(context).see_our}',
        //                         style: VisaTextStyle.custom,
        //                         fontSize: fontfourteen,
        //                         fontFamily: VisaFontWeight.regular,
        //                         colorTheme: VisaTextTheme.textColorBlack,
        //                         lineHeight: 1.29,
        //                         textLineHeight: 1.29,
        //                       ),
        //                       VisaTextSpan(
        //                         text: S.of(context).faq,
        //                         style: VisaTextStyle.custom,
        //                         fontSize: fontfourteen,
        //                         fontFamily: VisaFontWeight.bold,
        //                         decoration: TextDecoration.underline,
        //                         lineHeight: 1.29,
        //                         textLineHeight: 1.29,
        //                         onTap: () {
        //                           viewModel.openFaq();
        //
        //                           // open FIFA
        //                         },
        //                       ),
        //                       VisaTextSpan(
        //                         text: ' ${S.of(context).more_information}',
        //                         style: VisaTextStyle.custom,
        //                         fontSize: fontfourteen,
        //                         fontFamily: VisaFontWeight.regular,
        //                         colorTheme: VisaTextTheme.textColorBlack,
        //                         lineHeight: 1.29,
        //                         textLineHeight: 1.29,
        //                       ),
        //                     ],
        //                   ),
        //                 ],
        //               ),
        //             )
        //           ],
        //         ),
        //       )
        : Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: tweentyHeight),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Image.asset(
                    Assets.imagesImageAccordionGradient,
                    // replace with your actual asset
                    width: AppSizes.sixHeight,
                    height: AppSizes.heightXXLarge,
                    fit: BoxFit.fill,
                  ),
                  SizedBox(width: AppSizes.tweleveWidth),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        VisaTextView(
                          text: DateUtil.formatFull(context, item.matchTime),
                          style: VisaTextStyle.displayBodyL,
                          textAlign: TextAlign.start,
                          maxLines: 3,
                          fontFamily: VisaFontWeight.semibold,
                          colorTheme: VisaTextTheme.textColorBlack,
                          textLineHeight: 1.12,
                          lineHeight: 1.12,
                        ),
                        SizedBox(height: tweleveHeight),
                        VisaTextView(
                          text:
                              "${DateUtil.formatTime(context, item.matchTime)}"
                              " ${item.matchEndTime == null ? "" : '- ${DateUtil.formatTime(context, item.matchTime)}'}"
                              "(${DateUtil.getTimezoneOffset(DateUtil.mapTimezoneNameToIANA(item.matchTimezone))} ${S.of(context).title_utc})",
                          semanticsLabel:
                              "${DateUtil.formatTime(context, item.matchTime)},"
                              "${item.matchEndTime == null ? "" : '- ${DateUtil.formatTime(context, item.matchTime)}'},"
                              "${item.matchTimezone}",
                          style: VisaTextStyle.displayBodyXs,
                          textAlign: TextAlign.start,
                          maxLines: 3,
                          fontFamily: VisaFontWeight.medium,
                          colorTheme: VisaTextTheme.textColorBlack,
                          textLineHeight: 1.40,
                          lineHeight: 1.40,
                          letterSpacing: 2,
                        ),
                        SizedBox(height: tweleveHeight),
                        VisaTextView(
                          text:
                              "${item.matchCity} ${item.matchState} ${item.matchCountry}",
                          style: VisaTextStyle.custom,
                          fontSize: fontfourteen,
                          textAlign: TextAlign.start,
                          maxLines: 3,
                          fontFamily: VisaFontWeight.regular,
                          colorTheme: VisaTextTheme.textColorBlack,
                          textLineHeight: 1.29,
                          lineHeight: 1.29,
                        ),
                        SizedBox(height: tweleveHeight),
                        VisaTextView(
                          text:
                              "${s.ticket_status} : ${s.txt_available} ${DateUtil.formatDateMonth(context, (item.matchTime).subtract(Duration(days: viewModel.noOfDaysDifference)))}",
                          style: VisaTextStyle.custom,
                          fontSize: fontfourteen,
                          textAlign: TextAlign.start,
                          maxLines: 3,
                          fontFamily: VisaFontWeight.semibold,
                          colorTheme: VisaTextTheme.textColorBlack,
                          textLineHeight: 1.29,
                          lineHeight: 1.29,
                        ),
                        // AppSizes.xxsmallVS,
                      ],
                    ),
                  ),
                ],
              ),
              AppSizes.smallVS,
              VisaButton(
                text: s.open_in_maps,
                onPressed: () {
                  viewModel.openMaps(item.matchLatitude, item.matchLongitude);
                },
                fontWeight: VisaFontWeight.medium,
                variant: VisaButtonVariant.primary,
                lineHeight: 1.39,
              ),
            ],
          );
  }

  void sendFirebaseANalytics(String eventName, String matchName) {
    // match_selected

    Utils.logPrintAnalytics("eventName ${eventName}");

    FirebaseAnalyticsService.logEventButtonClick(
      btnName: eventName,
      parameters: {"match_selected": matchName},
    );
  }
}
