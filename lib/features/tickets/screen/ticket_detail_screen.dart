import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart' show GetIt;
import 'package:provider/provider.dart';
import 'package:visaamigo/custom_widgets/visa_rich_text.dart';
import 'package:visaamigo/features/profile/provider/user_generic_detail_provider.dart';
import 'package:visaamigo/utils/app_const.dart';
import 'package:visaamigo/utils/app_extensions.dart';
import 'package:visaamigo/utils/shared_preferences.dart';
import 'package:visaamigo/utils/theme_extension.dart';

import '../../../analytics/firebase_analytics_service.dart';
import '../../../core/base/view/base_view.dart';
import '../../../core/theme/theme.dart';
import '../../../custom_widgets/visa_appbar.dart';
import '../../../custom_widgets/visa_size_box.dart';
import '../../../custom_widgets/visa_svg_icon.dart';
import '../../../custom_widgets/visa_textview.dart';
import '../../../generated/assets.dart';
import '../../../generated/l10n.dart';
import '../../../router/app_routes_const.dart';
import '../../../utils/const_screen_size.dart';
import '../../../utils/responsive_util.dart';
import '../../../utils/utils.dart';
import '../../home/providers/navigation_provider.dart';
import '../provider/ticket_provider.dart';
import '../widgets/match_tickets_accrodion_widget.dart';
import '../widgets/ticket_count_down_widget.dart';
import '../widgets/ticket_details_widget.dart';

class TicketDetailScreen extends StatefulWidget {
  const TicketDetailScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _TicketDetailScreenState createState() => _TicketDetailScreenState();
}

class _TicketDetailScreenState extends State<TicketDetailScreen> {
  late TicketProvider ticketProvider;
  late ResponsiveUtil responsive;
  late UserGenericProvider userProvider;
  late S s;
  late double fontSize;
  late double boxSize;

  @override
  void initState() {
    super.initState();
    ticketProvider = GetIt.I<TicketProvider>();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    responsive = GetIt.I<ResponsiveUtil>(param1: context);
    userProvider = Provider.of<UserGenericProvider>(context);
    s = S.of(context);
    fontSize = AppSizes.fontfourteen;
    boxSize = AppSizes.heightSmall;

    // if (ticketProvider.ticketController.hasClients) {
    //   ticketProvider.ticketController.jumpTo(0);
    // }
  }

  @override
  Widget build(BuildContext context) {
    return BaseView<TicketProvider>(
      onlyDesktop: true,
      screenBackgroundColor: VisaColors.white,
      extendBodyBehindAppBar: true,
      addDefaultPadding: false,
      wrapWithSafeArea: false,
      resizeToAvoidBottomInset: true,
      systemNavigationBarColor: context.theme.primaryColor,
      viewModel: ticketProvider,
      onModelReady: (model) {
        model.init(context);
      },
      screenBackgroundImage: null,
      buildAppBar: VisaAppBar(
        isHamburgerIconShow: responsive.kISWeb() &&
            (responsive.isMobile(context: context) ||
                responsive.isTablet(context: context)),
        isActionButtonShow: true,
        isRightSideHamburgerIconShow: true,
        isCancelWithTextButtonShow: false,
        rightSideHamburgerIconColor: context.theme.primaryColor,
        onCancelPress: () {},
      ),
      onPageBuilderMobileView:
          (BuildContext context, TicketProvider viewModel) {
        return SingleChildScrollView(
          controller: Provider.of<NavigationProvider>(context, listen: false)
              .tabScrollControllers[AppRoutes.ticketScreenIndex],
          child: Padding(
            padding: EdgeInsets.all(Sizes.sixteen),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(height: 200.h, child: const TicketsCountDownWidget()),
                AppSizes.mediumVS,
                TicketDetailsWidget(viewModel),
                // AppSizes.mediumVS,

                if (viewModel.userMatches != null &&
                    viewModel.userMatches?.data != null &&
                    viewModel.userMatches!.data.isNotEmpty)
                  MatchTicketsAccordionWidget(
                      viewModel.userMatches!.data, viewModel),
                AppSizes.mediumVS,

                Visibility(
                    visible: (viewModel.userMatches != null &&
                        viewModel.userMatches?.data != null &&
                        viewModel.userMatches!.data.isNotEmpty),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        VisaTextView(
                          text: s.preparing_match_title,
                          style: VisaTextStyle.displayBodyXl,
                          textAlign: TextAlign.start,
                          maxLines: 3,
                          fontFamily: VisaFontWeight.semibold,
                          colorTheme: VisaTextTheme.textColorBlack,
                          textLineHeight: 1.39,
                          lineHeight: 1.39,
                        ),
                        VSpacings.xxsmall,
                        VisaRichText(
                          maxLines: 3,
                          textAlign: TextAlign.start,
                          textSpans: [
                            VisaTextSpan(
                                text:
                                    '${S.of(context).preparing_match_description} ',
                                style: VisaTextStyle.custom,
                                fontSize: fontSize,
                                fontFamily: VisaFontWeight.regular,
                                colorTheme: VisaTextTheme.textColorBlack,
                                lineHeight: 1.29,
                                textLineHeight: 1.29),
                            VisaTextSpan(
                              text: S.of(context).check_fifa_faqs,
                              style: VisaTextStyle.custom,
                              lineHeight: 1.29,
                              textLineHeight: 1.29,
                              decoration: TextDecoration.underline,
                              fontSize: fontSize,
                              fontFamily: VisaFontWeight.bold,
                              // colorTheme: VisaTextTheme.,
                              onTap: () async {
                                String ln = await Preferences.getString(
                                    Preferences.keyLanguageCode);
                                if (context.mounted) {
                                  viewModel.openFifaFaq(
                                      S.of(context).you_redirection_fifa,
                                      AppConst.ticketSupport(ln));
                                }
                              },
                            ),
                            VisaTextSpan(
                              text:
                                  " ${S.of(context).preparing_match_postlink}",
                              style: VisaTextStyle.custom,
                              fontSize: fontSize,
                              fontFamily: VisaFontWeight.regular,
                              colorTheme: VisaTextTheme.textColorBlack,
                              lineHeight: 1.29,
                              textLineHeight: 1.29,
                            ),
                          ],
                        ),
                        AppSizes.mediumVS,
                        VisaTextView(
                          text: s.where_my_ticket_title,
                          style: VisaTextStyle.displayBodyXl,
                          textAlign: TextAlign.start,
                          maxLines: 3,
                          fontFamily: VisaFontWeight.semibold,
                          colorTheme: VisaTextTheme.textColorBlack,
                          textLineHeight: 1.39,
                          lineHeight: 1.39,
                        ),
                        VSpacings.xxsmall,
                        VisaRichText(
                          maxLines: 10,
                          textAlign: TextAlign.start,
                          textSpans: [
                            VisaTextSpan(
                              text: (userProvider.isCompanion ?? false)
                                  ? '${S.of(context).where_my_ticket_description_companion} '
                                  : '${S.of(context).where_my_ticket_description} ',
                              style: VisaTextStyle.custom,
                              fontSize: fontSize,
                              fontFamily: VisaFontWeight.regular,
                              colorTheme: VisaTextTheme.textColorBlack,
                              lineHeight: 1.29,
                              textLineHeight: 1.29,
                            ),
                            VisaTextSpan(
                              text: (userProvider.isCompanion ?? false)
                                  ? ""
                                  : S.of(context).ticketing_team,
                              style: VisaTextStyle.custom,
                              fontSize: fontSize,
                              fontFamily: VisaFontWeight.bold,
                              decoration: TextDecoration.underline,
                              lineHeight: 1.29,
                              textLineHeight: 1.29,
                              onTap: () async {
                                // open support
                                String ln = await Preferences.getString(
                                    Preferences.keyLanguageCode);
                                if (context.mounted) {
                                  viewModel.openFifaFaq(
                                      S.of(context).you_redirection_fifa,
                                      AppConst.ticketSupport(ln));
                                }
                              },
                            ),
                          ],
                        ),
                        VSpacings.medium,
                        VisaTextView(
                          text: s.other_ticket_question_title,
                          style: VisaTextStyle.displayBodyXl,
                          textAlign: TextAlign.start,
                          maxLines: 3,
                          fontFamily: VisaFontWeight.semibold,
                          colorTheme: VisaTextTheme.textColorBlack,
                          textLineHeight: 1.39,
                          lineHeight: 1.39,
                        ),
                        VSpacings.xxsmall,
                        VisaRichText(
                          maxLines: 3,
                          textAlign: TextAlign.start,
                          textSpans: [
                            VisaTextSpan(
                              text: S.of(context).check_fifa,
                              style: VisaTextStyle.custom,
                              fontSize: fontSize,
                              fontFamily: VisaFontWeight.bold,
                              decoration: TextDecoration.underline,
                              lineHeight: 1.29,
                              textLineHeight: 1.29,
                              onTap: () async {
                                // open FIFA
                                String ln = await Preferences.getString(
                                    Preferences.keyLanguageCode);
                                if (context.mounted) {
                                  viewModel.openFifaFaq(
                                      S.of(context).you_redirection_fifa,
                                      AppConst.ticketSupport(ln));
                                }
                              },
                            ),
                            VisaTextSpan(
                              text: ' ${S.of(context).check_fifa_tail}',
                              style: VisaTextStyle.custom,
                              fontSize: fontSize,
                              fontFamily: VisaFontWeight.regular,
                              colorTheme: VisaTextTheme.textColorBlack,
                              lineHeight: 1.29,
                              textLineHeight: 1.29,
                            ),
                          ],
                        ),
                        AppSizes.mediumVS,
                        Container(
                          height: 1.h,
                          // width: 600,
                          // Thickness of the line
                          color: VisaColors.dividerColor,
                        ),
                        AppSizes.mediumVS,
                        Semantics(
                          label:
                              "${s.ask_eva_about_upcoming_match}, ${S.of(context).double_tap_to_activate}",
                          container: true,
                          enabled: true,
                          excludeSemantics: true,
                          child: Container(
                            width: context.screenWidth,
                            padding: EdgeInsets.only(
                              left: Sizes.sixteenInt.w,
                              right: Sizes.sixteenInt.w,
                              top: Sizes.twentyFour,
                              bottom: Sizes.twentyFour,
                            ),
                            decoration: BoxDecoration(
                              color: VisaColors.blueBackgroundLightNew,
                              // Light blue background color
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: GestureDetector(
                              onTap: () {
                                // navigationProvider.goBranch(1);
                              },
                              child: Row(
                                children: [
                                  // Star icon
                                  VisaSvgIcon(
                                    semantics: false,
                                    height: Sizes.twentySixInt.h,
                                    width: Sizes.twentySixInt.w,
                                    assetPath: Assets.iconsEva,
                                    color: context.theme.primaryColor,
                                  ),
                                  VisaSizeBox(
                                    width: Sizes.twelveInt.w,
                                  ),

                                  // Text content with arrow using RichText
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: () {
                                        FirebaseAnalyticsService.logEvent(
                                          eventName: AnalyticsEventConst
                                              .EVENT_NAME_EVAASSISTANT_OPENED,
                                          parameters: {
                                            AnalyticsEventConst
                                                    .PARAM_NAME_UI_ELEMENT_LOCATION:
                                                AppRoutes.homeNav,
                                            AnalyticsEventConst
                                                    .PARAM_NAME_UI_ELEMENT:
                                                AppRoutes.evaNav,
                                          },
                                        );
                                        FirebaseAnalyticsService.logEvent(
                                          eventName: AnalyticsEventConst
                                              .EVENT_NAME_EVAASSISTANT_SCREENVIEWED,
                                        );
                                        // First switch to tickets tab (index 3), then navigate to EVA chat
                                        Provider.of<NavigationProvider>(context,
                                                listen: false)
                                            .goBranch(
                                                AppRoutes.ticketScreenIndex,
                                                showGreetingScreen: false);

                                        // Navigate to EVA chat screen with ticket-related context
                                        viewModel.navGo(
                                            AppRoutes.evaChatScreenNav,
                                            extra: {
                                              "eva_question": Utils
                                                  .getErrorMessageFromString(
                                                      'match_day'),
                                              "location": "",
                                              "section": "match_day",
                                            });

                                        FirebaseAnalyticsService.logEvent(
                                          eventName: AnalyticsEventConst
                                              .EVENT_NAME_EVAASSISTANT_OPENED,
                                          parameters: {
                                            AnalyticsEventConst
                                                    .PARAM_NAME_UI_ELEMENT_LOCATION:
                                                AppRoutes.ticketsNav,
                                            AnalyticsEventConst
                                                    .PARAM_NAME_UI_ELEMENT:
                                                AppRoutes.evaNav,
                                          },
                                        );

                                        FirebaseAnalyticsService.logEvent(
                                          eventName: AnalyticsEventConst
                                              .EVENT_NAME_EVAASSISTANT_SCREENVIEWED,
                                        );
                                      },
                                      child: VisaRichText(
                                        maxLines: 3,
                                        semantics: false,
                                        textSpans: [
                                          VisaTextSpan(
                                              text: s
                                                  .ask_eva_about_upcoming_match,
                                              style:
                                                  VisaTextStyle.displayBodyXl,
                                              fontSize: AppSizes.fontMedium,
                                              letterSpacing: -0.5,
                                              onTap: () {},
                                              lineHeight: 1.11,
                                              fontFamily:
                                                  VisaFontWeight.semibold,
                                              colorTheme:
                                                  VisaTextTheme.customTextColor,
                                              customColor: VisaColors.black,
                                              iconHeight: Sizes.tenInt.h,
                                              iconPadding:
                                                  EdgeInsets.only(top: 3.h),
                                              iconWidth: Sizes.fourteenInt.w,
                                              iconPath: Assets
                                                  .iconsIcRichTextRightArrow),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        AppSizes.mediumVS,
                      ],
                    ))
              ],
            ),
          ),
        );
      },
    );
  }
}
