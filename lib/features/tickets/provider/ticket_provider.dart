import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:visaamigo/custom_widgets/visa_button.dart';
import 'package:visaamigo/ui/base/base_provider.dart';
import 'package:visaamigo/utils/shared_preferences.dart';

import '../../../analytics/firebase_analytics_service.dart';
import '../../../core/theme/theme.dart';
import '../../../custom_widgets/visa_svg_icon.dart';
import '../../../custom_widgets/visa_textview.dart';
import '../../../generated/assets.dart';
import '../../../generated/l10n.dart';
import '../../../router/app_routes_const.dart';
import '../../../utils/app_const.dart';
import '../../../utils/const_screen_size.dart';
import '../../../utils/utils.dart';
import '../../home/model/match_details.dart';
import '../../profile/provider/user_generic_detail_provider.dart';
import '../../signup/model/user_model.dart';

class TicketProvider extends BaseProvider {
  double appBarTotalHeight = 0.0;
  UserModel? userData;
  String? userEmail;

  int noOfDaysDifference = 3;

  MatchResponse? userMatches;

  final ScrollController ticketController = ScrollController();

  Future<void> init(BuildContext context) async {
    appBarTotalHeight = MediaQuery.paddingOf(context).top + kToolbarHeight;

    userMatches =
        Provider.of<UserGenericProvider>(context, listen: true).userMatchDetail;

    userData = Provider.of<UserGenericProvider>(context).userModel;

    userEmail = userData?.email;
    // _startCountdown();
    setState();

    // Get the local timezone
    final DateTime now = DateTime.now();

    // Get the timezone offset in hours and minutes
    final Duration offset = now.timeZoneOffset;

    // Format the offset as a string
    final String offsetHours = (offset.inHours).toString().padLeft(2, '0');
    final String offsetMinutes =
        (offset.inMinutes % 60).abs().toString().padLeft(2, '0');
    final String offsetSign = offset.isNegative ? '-' : '+';
    final String formattedOffset = '$offsetSign$offsetHours:$offsetMinutes UTC';

    // Calculate hours and minutes for display
    final int hours = offset.inHours;
    final int minutes = offset.inMinutes % 60;

    Utils.logPrint(
        'Current Time: ${DateFormat('yyyy-MM-dd HH:mm:ss').format(now)}');
    Utils.logPrint('Timezone: $formattedOffset');
    Utils.logPrint('Offset from UTC: ${hours}h ${minutes.abs()}m');
  }

  void openMaps(double lat, double lng) {
    navPush(AppRoutes.redirecting, extra: {
      "url": Utils.openMaps(lat, lng),
      "bottomMessage": S.of(mContext).you_redirection_maps,
      "openInternalBrowser": false
    });
  }

  void openRedirection(String msg) async {
    String ln = await Preferences.getString(Preferences.keyLanguageCode);
    navPush(AppRoutes.redirecting,
        extra: {"url": AppConst.ticketSupport(ln), "bottomMessage": msg});
  }

  void openFifaFaq(String msg, String url) {
    navPush(AppRoutes.redirecting, extra: {"url": url, "bottomMessage": msg});
  }

  Future<void> showReminderDialog(BuildContext context, UserModel? userData) {
    Utils.logPrint("userData ${userEmail}");

    bool isCopiedText = false;

    FirebaseAnalyticsService.logEvent(
      eventName: "ticketdetails_bannerseen",
    );

    return showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      pageBuilder: (context, animation, secondaryAnimation) {
        return SafeArea(
          child: Material(
            color: Colors.transparent,
            child: Center(child: StatefulBuilder(builder: (context, setState) {
              return Container(
                width: MediaQuery.of(context).size.width,
                margin: EdgeInsets.symmetric(horizontal: AppSizes.dimSmall),
                padding: EdgeInsets.symmetric(
                    vertical: 24.h, horizontal: AppSizes.tweentyWidth),
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(16.r),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Align(
                          alignment: Alignment.topRight,
                          child: GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            onTap: () {
                              Navigator.of(context).pop();
                            },
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                VisaSvgIcon(
                                  assetPath: Assets.iconsIcClose,
                                  color: VisaColors.white,
                                  width: Sizes.twelveInt.w,
                                  height: Sizes.twelveInt.h,
                                ),
                                AppSizes.xsmallHS,
                                VisaTextView(
                                  text: S.of(context).close.toUpperCase(),
                                  style: VisaTextStyle.custom,
                                  colorTheme: VisaTextTheme.customTextColor,
                                  customColor: VisaColors.white,
                                  lineHeight: 1.40,
                                  fontSize: AppSizes.fontTwelve,
                                  fontFamily: VisaFontWeight.bold,
                                  letterSpacing: 2,
                                )
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: AppSizes.heightSmall),
                        Container(
                            padding: EdgeInsets.all(Sizes.eight),
                            decoration: ShapeDecoration(
                              color: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(Sizes.twentySix),
                              ),
                            ),
                            child: VisaSvgIcon(
                              assetPath: Assets.iconsIcTicket,
                              color: VisaColors.black,
                              width: Sizes.thirtySixInt.w,
                              height: Sizes.thirtySixInt.h,
                            )),
                        SizedBox(height: AppSizes.tweentyHeight),
                        VisaTextView(
                          text: S.of(context).reminder_title,
                          style: VisaTextStyle.custom,
                          colorTheme: VisaTextTheme.customTextColor,
                          customColor: VisaColors.white,
                          fontFamily: VisaFontWeight.medium,
                          fontSize: Sizes.thirtySixInt.sp,
                          lineHeight: 0.72,
                          letterSpacing: -0.72,
                        ),
                        SizedBox(height: AppSizes.heightTweentyFour),
                        VisaTextView(
                          text:
                              "${S.of(context).reminder_message} \n ${userEmail}",
                          style: VisaTextStyle.custom,
                          colorTheme: VisaTextTheme.customTextColor,
                          customColor: VisaColors.white,
                          fontFamily: VisaFontWeight.medium,
                          fontSize: AppSizes.fontfourteen,
                          maxLines: 5,
                          textAlign: TextAlign.center,
                          lineHeight: 1.29,
                        ),
                        SizedBox(height: AppSizes.heightTweentyFour),
                        Container(
                          height: Sizes.fiftySevenInt.h,
                          padding: EdgeInsets.symmetric(
                              horizontal: AppSizes.tweleveWidth,
                              vertical: 12.h),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: VisaTextView(
                                  text: "${userEmail}",
                                  style: VisaTextStyle.custom,
                                  colorTheme: VisaTextTheme.customTextColor,
                                  customColor: VisaColors.black,
                                  fontFamily: VisaFontWeight.semibold,
                                  fontSize: 16.sp,
                                  maxLines: 1,
                                  lineHeight: 1.12,
                                  letterSpacing: 1.12,
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    isCopiedText = true;
                                  });
                                  Clipboard.setData(
                                      ClipboardData(text: userEmail ?? ""));

                                  // ticketdetails.codecopied

                                  FirebaseAnalyticsService.logEvent(
                                    eventName: " ticketdetails_codecopied",
                                    parameters: {
                                      AnalyticsEventConst.PARAM_NAME_UI_ELEMENT:
                                          "copy_code",
                                    },
                                  );
                                },
                                child: isCopiedText
                                    ? Row(
                                        children: [
                                          VisaSvgIcon(
                                            height: AppSizes.heightEighteen,
                                            assetPath: Assets.iconsIcCheck,
                                            setColorFilter: false,
                                          ),
                                          SizedBox(
                                            width: AppSizes.eightWidth,
                                          ),
                                          VisaTextView(
                                            text: S.of(context).copied,
                                            style: VisaTextStyle.displayBodyS,
                                            colorTheme:
                                                VisaTextTheme.customTextColor,
                                            customColor: VisaColors.green,
                                            fontFamily: VisaFontWeight.semibold,
                                            fontSize: AppSizes.fontfourteen,
                                            maxLines: 1,
                                            lineHeight: 1.29,
                                            letterSpacing: 1.29,
                                          )
                                        ],
                                      )
                                    : Row(
                                        children: [
                                          VisaSvgIcon(
                                            height: AppSizes.heightEighteen,
                                            assetPath: Assets.iconsIcCopy,
                                            setColorFilter: false,
                                          ),
                                          SizedBox(
                                            width: AppSizes.eightWidth,
                                          ),
                                          VisaTextView(
                                            text: S.of(context).copy,
                                            style: VisaTextStyle.displayBodyS,
                                            colorTheme: VisaTextTheme.primary,
                                            fontFamily: VisaFontWeight.semibold,
                                            fontSize: AppSizes.fontfourteen,
                                            maxLines: 1,
                                            lineHeight: 1.29,
                                            letterSpacing: 1.29,
                                          )
                                        ],
                                      ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: AppSizes.heightTweentyFour),
                        SizedBox(
                          width: double.infinity,
                          child: VisaButton(
                            text: S.of(context).lets_go,
                            variant: VisaButtonVariant.custom,
                            buttonColor: VisaColors.secondary,
                            buttonTextColor: VisaColors.black,
                            fontWeight: VisaFontWeight.semibold,
                            onPressed: () {
                              Navigator.of(context).pop();

                              // ticketdetails.bannerclicked

                              FirebaseAnalyticsService.logEvent(
                                eventName: "ticketdetails_bannerclicked",
                              );
                              openRedirection(
                                  S.of(context).you_redirection_fifa);
                            },
                          ),
                        )
                      ],
                    )
                  ],
                ),
              );
            })),
          ),
        );
      },
    );
  }

  void openFaq() {
    navPush(AppRoutes.faq);
  }
}
