import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:visaamigo/core/theme/theme.dart';
import 'package:visaamigo/custom_widgets/visa_appbar.dart';
import 'package:visaamigo/custom_widgets/visa_button.dart';
import 'package:visaamigo/custom_widgets/visa_rich_text.dart';
import 'package:visaamigo/custom_widgets/visa_size_box.dart';
import 'package:visaamigo/custom_widgets/visa_svg_icon.dart';
import 'package:visaamigo/custom_widgets/visa_textview.dart';
import 'package:visaamigo/features/itinerary/providers/itinerary_provider.dart';
import 'package:visaamigo/features/itinerary/providers/itinerary_provider_generic.dart';
import 'package:visaamigo/features/itinerary/screens/widgets/widgets/itinerary_calandar_view.dart';
import 'package:visaamigo/features/select_languages/providers/language_selection_generic_provider.dart';
import 'package:visaamigo/generated/assets.dart';
import 'package:visaamigo/generated/l10n.dart';
import 'package:visaamigo/utils/app_extensions.dart';
import 'package:visaamigo/utils/const_screen_size.dart';
import 'package:visaamigo/utils/responsive_util.dart';

import '../../../core/base/view/base_view.dart';
import '../../../router/app_routes_const.dart';
import '../../../utils/date_util.dart';
import '../../../utils/utils.dart';
import '../../home/providers/navigation_provider.dart';
import '../../profile/provider/user_generic_detail_provider.dart';
import 'widgets/widgets/itinerary_items.dart';

class ItineraryHomeScreen extends StatefulWidget {
  const ItineraryHomeScreen({super.key});

  @override
  State<ItineraryHomeScreen> createState() => _ItineraryHomeScreenState();
}

class _ItineraryHomeScreenState extends State<ItineraryHomeScreen>
    with WidgetsBindingObserver {
  late ItineraryProvider _itineraryProvider;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  // the calendar should automatically scroll to the nearest upcoming event
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    // When app is resumed, auto-scroll to nearest upcoming event
    if (state == AppLifecycleState.resumed) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        try {
          if (mounted &&
              _itineraryProvider.mContext != null &&
              _itineraryProvider.mContext!.mounted) {
            _itineraryProvider.onAppResumed();
          }
        } catch (e) {
          Utils.logPrint("Error in itinerary auto-scroll on app resume: $e");
        }
      });
    }
  }

  // the calendar should automatically scroll to the nearest upcoming event
  /// Handle initial auto-scroll when itinerary screen is first loaded
  void _handleInitialAutoScroll() {
    // Add a small delay to ensure widget is fully built
    Future.delayed(const Duration(milliseconds: 500), () {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        try {
          if (mounted &&
              _itineraryProvider.mContext != null &&
              _itineraryProvider.mContext!.mounted) {
            _itineraryProvider.onAppLaunched();
          }
        } catch (e) {
          Utils.logPrint("Error in initial itinerary auto-scroll: $e");
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    var languageProvider =
        Provider.of<SelectLanguageGenericProvider>(context, listen: true);
    final responsive = Provider.of<ResponsiveUtil>(context, listen: false);
    final userGeneric = Provider.of<UserGenericProvider>(context);
    _itineraryProvider = Provider.of<ItineraryProvider>(context, listen: true);

    return BaseView<ItineraryProviderGeneric>(
      viewModel: ItineraryProviderGeneric(),
      screenBackgroundColor: Colors.transparent,
      extendBodyBehindAppBar: false,
      addDefaultPadding: false,
      wrapWithSafeArea: false,
      resizeToAvoidBottomInset: true,
      onlyDesktop: true,
      systemNavigationBarColor: context.theme.primaryColor,
      onModelReady: (model) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _itineraryProvider.init(context, languageProvider, userGeneric);
          Utils.announceMessage(S.of(context).itinerary_screen);

          // the calendar should automatically scroll to the nearest upcoming event
          // Handle initial auto-scroll after initialization
          _handleInitialAutoScroll();
        });
      },
      screenBackgroundImage: Positioned.fill(
        child: Image.asset(
          Assets.bgsItineraryBg,
          fit: BoxFit.fitWidth,
          alignment: Alignment.topCenter,
        ),
      ),
      buildAppBar: _buildAppBar(context, responsive) as PreferredSizeWidget,
      onDispose: () {
        // Dispose Scroll Controller
        // _itineraryProvider.scrollController.dispose();
      },
      onPageBuilderMobileView:
          (BuildContext context, ItineraryProviderGeneric viewModel) {
        return _buildMobileView(context);
      },
    );
  }

  Widget _buildAppBar(BuildContext context, ResponsiveUtil responsive) {
    return VisaAppBar(
      isHamburgerIconShow: responsive.kISWeb() &&
          (responsive.isMobile(context: context) ||
              responsive.isTablet(context: context)),
      isActionButtonShow: true,
      isRightSideHamburgerIconShow: true,
      rightSideHamburgerIconColor: context.theme.primaryColor,
      useWithShadow: true,
    );
  }

  Widget _buildMobileView(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top: _itineraryProvider.appBarTotalHeight,
      ),
      child: Container(
        padding: EdgeInsets.fromLTRB(
            Sizes.sixteen, Sizes.sixteen, Sizes.sixteen, Sizes.zero),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context),
            VSpacings.medium,
            Expanded(
              child: SingleChildScrollView(
                  controller:
                      Provider.of<NavigationProvider>(context, listen: false)
                          .tabScrollControllers[AppRoutes.itineraryScreenIndex],
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ItineraryCalandarView(),
                      _buildDateNavigation(context),
                      VSpacings.small,
                      _buildTimeZoneText(context),
                      VSpacings.medium,
                      _buildEventsSection(context),
                      _buildAddEventButton(context),
                      _buildDivider(),
                      VSpacings.medium,
                      _buildBookAndMoreSection(context),
                      _buildBackToTopButton(context),
                      VSpacings.small,
                    ],
                  )),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return VisaTextView(
      text: S.of(context).itinerary,
      style: VisaTextStyle.displayTitleMedium,
      colorTheme: VisaTextTheme.textColorBlack,
      fontFamily: VisaFontWeight.semibold,
      lineHeight: 1.04,
      textLineHeight: 1.04,
      letterSpacing: -1,
    );
  }

  Widget _buildDateNavigation(BuildContext context) {
    return GestureDetector(
      onHorizontalDragEnd: (details) {
        if (details.primaryVelocity != null) {
          if (details.primaryVelocity! > 0) {
            _itineraryProvider.onPreviousDayClicked();
          } else if (details.primaryVelocity! < 0) {
            _itineraryProvider.onNextDayClicked();
          }
        }
      },
      child: Row(
        children: [
          _buildPreviousDayButton(context),
          _buildDateText(context),
          _buildNextDayButton(context),
        ],
      ),
    );
  }

  Widget _buildPreviousDayButton(BuildContext context) {
    return Semantics(
      label: S.of(context).previous_day,
      button: true,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          _itineraryProvider.onPreviousDayClicked();
        },
        child: Padding(
          padding: EdgeInsets.only(
              top: Sizes.eight, bottom: Sizes.eight, right: Sizes.sixteen),
          child: VisaSvgIcon(
            semantics: false,
            assetPath: Assets.iconsIcArrowLeft,
            height: Sizes.twelve.h,
            width: Sizes.twelve.w,
          ),
        ),
      ),
    );
  }

  Widget _buildDateText(BuildContext context) {
    return VisaTextView(
      text: DateUtil.formatGetWithFormat(context, _itineraryProvider.focusedDay,
          DateUtil.DATE_FORMAT_WEEKDAY_DAY_MONTH),
      style: VisaTextStyle.custom,
      fontSize: 22.sp,
      colorTheme: VisaTextTheme.textColorBlack,
      fontFamily: VisaFontWeight.bold,
      lineHeight: 1.09,
      textLineHeight: 1.09,
      letterSpacing: -1,
    );
  }

  Widget _buildNextDayButton(BuildContext context) {
    return Semantics(
      label: S.of(context).next_day,
      button: true,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          _itineraryProvider.onNextDayClicked();
        },
        onDoubleTap: () {
          _itineraryProvider.onNextDayClicked();
        },
        child: Padding(
          padding: EdgeInsets.only(
              top: Sizes.eight,
              bottom: Sizes.eight,
              right: Sizes.eight,
              left: Sizes.sixteen),
          child: VisaSvgIcon(
            semantics: false,
            assetPath: Assets.iconsIcArrowRight,
            height: Sizes.twelve.h,
            width: Sizes.twelve.w,
          ),
        ),
      ),
    );
  }

  Widget _buildTimeZoneText(BuildContext context) {
    return VisaTextView(
      text: S.of(context).events_local_time_zone,
      style: VisaTextStyle.displayBodyXs,
      colorTheme: VisaTextTheme.customTextColor,
      customColor: VisaColors.textFieldBorder,
      lineHeight: 1.33,
      maxLines: 3,
      textLineHeight: 1.33,
    );
  }

  Widget _buildEventsSection(BuildContext context) {
    if (_itineraryProvider.selectedDateEvent.isEmpty) {
      return _buildNoEventsMessage(context);
    }
    return Itineraryitems();
  }

  Widget _buildNoEventsMessage(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
          left: Sizes.twentyTwo,
          right: Sizes.twentyTwo,
          bottom: Sizes.twentyTwo),
      child: VisaTextView(
        text: (_itineraryProvider.focusedDay.isTodayOrFuture)
            ? S.of(context).no_event_for_day
            : S.of(context).past_time,
        style: VisaTextStyle.displayBodyS,
        colorTheme: VisaTextTheme.customTextColor,
        customColor: VisaColors.textFieldBorder,
        fontFamily: VisaFontWeight.medium,
        lineHeight: 1.14,
        maxLines: 3,
        textLineHeight: 1.14,
        letterSpacing: -0.28,
      ),
    );
  }

  Widget _buildAddEventButton(BuildContext context) {
    if (!_itineraryProvider.focusedDay.isTodayOrFuture) {
      return const SizedBox.shrink();
    }

    return Column(
      children: [
        VisaButton(
          text: S.of(context).add_new_event,
          onPressed: () {
            _itineraryProvider.openAddToItineary();
          },
          fontWeight: VisaFontWeight.medium,
          variant: VisaButtonVariant.primary,
          lineHeight: 1.39,
        ),
        VSpacings.medium,
      ],
    );
  }

  Widget _buildDivider() {
    return Divider(
      color: VisaColors.dividerColor,
      thickness: Sizes.one.w,
      height: 0,
    );
  }

  Widget _buildBookAndMoreSection(BuildContext context) {
    return Semantics(
      button: true,
      label: S.of(context).book_and_more,
      child: Container(
        width: context.screenWidth,
        padding: EdgeInsets.only(
          left: Sizes.sixteenInt.w,
          right: Sizes.sixteenInt.w,
          top: Sizes.twenty,
          bottom: Sizes.twenty,
        ),
        decoration: BoxDecoration(
          color: VisaColors.blueBackgroundLightNew,
          borderRadius: BorderRadius.circular(16),
        ),
        child: GestureDetector(
          onTap: () {
            _itineraryProvider.openBookingcom();
          },
          child: Row(
            children: [
              _buildTravelIcon(context),
              VisaSizeBox(width: Sizes.twelveInt.w),
              _buildBookAndMoreText(context),
              VisaSizeBox(
                width: Sizes.sixteenInt.h,
                height: Sizes.sixteenInt.h,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTravelIcon(BuildContext context) {
    return VisaSvgIcon(
      semantics: false,
      height: Sizes.twentySixInt.h,
      width: Sizes.twentySixInt.w,
      assetPath: Assets.iconsIcTravel,
      color: context.theme.primaryColor,
    );
  }

  Widget _buildBookAndMoreText(BuildContext context) {
    return Expanded(
      child: VisaRichText(
        semantics: false,
        maxLines: 3,
        textSpans: [
          VisaTextSpan(
              text: S.of(context).book_and_more,
              style: VisaTextStyle.displayBodyXl,
              fontSize: Sizes.eighteenInt.sp,
              letterSpacing: -0.5,
              lineHeight: Sizes.twenty,
              fontFamily: VisaFontWeight.semibold,
              colorTheme: VisaTextTheme.customTextColor,
              customColor: VisaColors.black,
              iconHeight: Sizes.tenInt.h,
              iconWidth: Sizes.fourteenInt.w,
              iconPath: Assets.iconsIcRichTextRightArrow),
        ],
      ),
    );
  }

  Widget _buildBackToTopButton(BuildContext context) {
    if (_itineraryProvider.selectedDateEvent.isEmpty ||
        _itineraryProvider.selectedDateEvent.length <= 3) {
      return const SizedBox.shrink();
    }

    return SizedBox(
      width: context.screenWidth,
      child: Semantics(
        enabled: true,
        button: true,
        container: true,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            VSpacings.small,
            VisaRichText(
              maxLines: 1,
              semanticsLabel: S.of(context).back_to_top.toLowerCase(),
              textSpans: [
                VisaTextSpan(
                    text: S.of(context).back_to_top,
                    style: VisaTextStyle.custom,
                    fontSize: Sizes.twelveInt.sp,
                    letterSpacing: 2,
                    lineHeight: 1.33,
                    decoration: TextDecoration.underline,
                    fontFamily: VisaFontWeight.medium,
                    colorTheme: VisaTextTheme.customTextColor,
                    customColor: VisaColors.primary,
                    onTap: () {
                      _itineraryProvider.scrollToTop();
                    }),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
