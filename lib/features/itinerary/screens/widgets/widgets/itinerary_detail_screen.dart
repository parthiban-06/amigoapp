import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:visaamigo/core/base/view/base_view.dart';
import 'package:visaamigo/custom_widgets/visa_svg_icon.dart';
import 'package:visaamigo/features/itinerary/providers/itinerary_detail_provider.dart';
import 'package:visaamigo/generated/assets.dart';
import 'package:visaamigo/utils/app_const.dart';
import 'package:visaamigo/utils/app_extensions.dart';
import 'package:visaamigo/utils/utils.dart';

import '../../../../../core/theme/theme.dart';
import '../../../../../custom_widgets/visa_appbar.dart';
import '../../../../../custom_widgets/visa_button.dart';
import '../../../../../custom_widgets/visa_rich_text.dart';
import '../../../../../custom_widgets/visa_size_box.dart';
import '../../../../../custom_widgets/visa_textview.dart';
import '../../../../../generated/l10n.dart';
import '../../../../../utils/const_screen_size.dart';
import '../../../../../utils/date_util.dart';
import '../../../../../utils/responsive_util.dart';
import '../../../models/event_list_model.dart';

/// Data class for time information
class _TimeInfo {
  final String start;
  final String end;

  const _TimeInfo({
    required this.start,
    required this.end,
  });
}

const String kTimeFormat24 = 'HH:mm';
const String kTimeFormat12 = 'hh:mm a';

class ItineraryDetailScreen extends StatelessWidget {
  EventList? eventDetail;

  ItineraryDetailScreen(this.eventDetail, {super.key});

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final responsive = Provider.of<ResponsiveUtil>(context, listen: false);

    return BaseView<ItineraryDetailProvider>(
      viewModel: ItineraryDetailProvider(),
      screenBackgroundColor: Colors.white,
      extendBodyBehindAppBar: false,
      addDefaultPadding: false,
      wrapWithSafeArea: false,
      resizeToAvoidBottomInset: true,
      systemNavigationBarColor: context.theme.primaryColor,
      onModelReady: (model) => model.init(context),
      buildAppBar: _buildAppBar(context, responsive),
      onPageBuilderMobileView:
          (BuildContext context, ItineraryDetailProvider viewModel) {
        return _buildMainContent(context, viewModel, s);
      },
    );
  }

  PreferredSizeWidget _buildAppBar(
      BuildContext context, ResponsiveUtil responsive) {
    return VisaAppBar(
      isHamburgerIconShow: _shouldShowHamburgerIcon(responsive, context),
      isActionButtonShow: true,
      onCancelPress: () => responsive.navPop(),
      isRightSideHamburgerIconShow: false,
      isCancelWithTextButtonShow: true,
      rightSideHamburgerIconColor: context.theme.primaryColor,
    );
  }

  bool _shouldShowHamburgerIcon(
      ResponsiveUtil responsive, BuildContext context) {
    return responsive.kISWeb() &&
        (responsive.isMobile(context: context) ||
            responsive.isTablet(context: context));
  }

  Widget _buildMainContent(
      BuildContext context, ItineraryDetailProvider viewModel, S s) {
    return Padding(
      padding: EdgeInsets.only(top: viewModel.appBarTotalHeight),
      child: SingleChildScrollView(
        padding: EdgeInsets.all(Sizes.sixteen),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeaderSection(context, viewModel),
            _buildEventDetailsSection(context, viewModel, s),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderSection(
      BuildContext context, ItineraryDetailProvider viewModel) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildEventTitle(),
        SizedBox(width: AppSizes.dimXSmall),
        _buildEditButton(context, viewModel),
      ],
    );
  }

  Widget _buildEventTitle() {
    return Flexible(
      child: VisaTextView(
        text: eventDetail?.title ?? "",
        colorTheme: VisaTextTheme.textColorBlack,
        style: VisaTextStyle.displayTitleMedium,
        fontFamily: VisaFontWeight.semibold,
        lineHeight: 1.04,
        textLineHeight: 1.04,
        letterSpacing: -1,
        maxLines: 100,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  Widget _buildEditButton(
      BuildContext context, ItineraryDetailProvider viewModel) {
    if (eventDetail?.type != AppConst.ITINERARY_TYPE_EVENT) {
      return const SizedBox.shrink();
    }

    // Check if event date is in the past
    if (eventDetail?.eventDate != null) {
      final eventDateTime = DateTime.parse(eventDetail!.eventDate!);
      final now = DateTime.now();

      // Check if startTime contains timezone offset (+ or -)
      if (!eventDetail!.startTime.contains(RegExp(r'[+-]'))) {
        return const SizedBox.shrink();
      }

      // Split by timezone offset (+ or -) to get the time part
      List<String> startTime = eventDetail!.startTime.split(RegExp(r'[+-]'));

      if (startTime.isEmpty) {
        return const SizedBox.shrink();
      }

      startTime = startTime[0].split(":");
      DateTime updated = eventDateTime.add(Duration(
          hours: int.parse(startTime[0]), minutes: int.parse(startTime[1])));

      // If event date is in the past, hide the edit button
      if (updated.isBefore(now)) {
        return const SizedBox.shrink();
      }
    }

    return VisaSvgIcon(
      assetPath: Assets.iconsEditProfile,
      semanticsLabel: S.of(context).edit_event_details_button,
      onTap: () => viewModel.openAddToItineary(eventDetail),
    );
  }

  Widget _buildEventDetailsSection(
      BuildContext context, ItineraryDetailProvider viewModel, S s) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: Sizes.twentyInt.h),
        _buildEventInfoRow(context, viewModel),
        _buildLocationButton(context, viewModel, s),
        _buildNotesSection(context),
        _buildEvaSection(context, viewModel),
      ],
    );
  }

  Widget _buildEventInfoRow(
      BuildContext context, ItineraryDetailProvider viewModel) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        _buildTimelineImage(),
        SizedBox(width: Sizes.sixteenInt.w),
        Expanded(child: _buildEventInfoColumn(context, viewModel)),
      ],
    );
  }

  Widget _buildTimelineImage() {
    return Image.asset(
      Assets.imagesImageAccordionGradient,
      width: Sizes.sixInt.w,
      height: 85.h,
      fit: BoxFit.fill,
    );
  }

  Widget _buildEventInfoColumn(
      BuildContext context, ItineraryDetailProvider viewModel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildEventDate(context),
        SizedBox(height: Sizes.twelveInt.h),
        _buildEventTime(context, viewModel),
        SizedBox(height: Sizes.twelveInt.h),
        _buildEventAddress(),
      ],
    );
  }

  Widget _buildEventDate(BuildContext context) {
    return VisaTextView(
      text: DateUtil.formatFull(
              context, DateTime.parse(eventDetail!.eventDate!)) ??
          "",
      style: VisaTextStyle.displayBodyL,
      textAlign: TextAlign.start,
      maxLines: 3,
      fontFamily: VisaFontWeight.semibold,
      colorTheme: VisaTextTheme.textColorBlack,
      textLineHeight: 1.12,
      lineHeight: 1.12,
    );
  }

  Widget _buildEventTime(
      BuildContext context, ItineraryDetailProvider viewModel) {
    return VisaTextView(
      text: _formatEventTime(context, viewModel),
      style: VisaTextStyle.displayBodyXs,
      textAlign: TextAlign.start,
      maxLines: 3,
      fontFamily: VisaFontWeight.medium,
      colorTheme: VisaTextTheme.textColorBlack,
      textLineHeight: 1.40,
      lineHeight: 1.40,
      letterSpacing: 2,
    );
  }

  String _formatEventTime(
      BuildContext context, ItineraryDetailProvider viewModel) {
    final timeInfo = _extractTimeInfo();
    if (timeInfo.start.isEmpty && timeInfo.end.isEmpty) return "";

    final timeZone = _getTimeZone(context);
    final timeFormat =
        viewModel.is24hrsClockEnable ? kTimeFormat24 : kTimeFormat12;

    if (timeInfo.start.isNotEmpty && timeInfo.end.isNotEmpty) {
      final startTime = _formatTime(timeInfo.start, timeFormat);
      final endTime = _formatTime(timeInfo.end, timeFormat);
      return "$startTime - $endTime ($timeZone ${S.of(context).title_utc})";
    } else if (timeInfo.start.isNotEmpty) {
      final startTime = _formatTime(timeInfo.start, timeFormat);
      return "$startTime ($timeZone ${S.of(context).title_utc})";
    }

    return "";
  }

  _TimeInfo _extractTimeInfo() {
    String start = "";
    String end = "";
    if (eventDetail != null) {
      if (eventDetail?.startTime != null) {
        start = eventDetail!.startTime!.split(RegExp(r'[+-]')).first;
      }
      if (eventDetail?.endTime != null) {
        end = eventDetail!.endTime!.split(RegExp(r'[+-]')).first;
      }
    }
    return _TimeInfo(start: start, end: end);
  }

  String _getTimeZone(BuildContext context) {
    if (eventDetail != null &&
        eventDetail!.type == AppConst.ITINERARY_TYPE_MATCH) {
      return DateUtil.getTimezoneOffset(
          DateUtil.mapTimezoneNameToIANA(eventDetail!.timezone));
    }
    return Utils.extractTimeZone(context, eventDetail?.startTime ?? "");
  }

  String _formatTime(String time, String format) {
    final dt = DateTime.parse("2025-01-01T$time");
    return DateFormat(format).format(dt);
  }

  Widget _buildEventAddress() {
    return VisaTextView(
      text: eventDetail?.address ?? "",
      style: VisaTextStyle.displayBodyS,
      textAlign: TextAlign.start,
      maxLines: 3,
      fontFamily: VisaFontWeight.regular,
      colorTheme: VisaTextTheme.textColorBlack,
      textLineHeight: 1.29,
      lineHeight: 1.29,
    );
  }

  Widget _buildLocationButton(
      BuildContext context, ItineraryDetailProvider viewModel, S s) {
    if (!_hasLocationData()) return const SizedBox.shrink();

    return Column(
      children: [
        VSpacings.small,
        VisaButton(
          text: s.open_in_maps,
          onPressed: () => viewModel.openMaps(
            eventDetail?.lat ?? 0.0,
            eventDetail?.lan ?? 0.0,
          ),
          fontWeight: VisaFontWeight.medium,
          variant: VisaButtonVariant.primary,
          lineHeight: 1.39,
        ),
      ],
    );
  }

  bool _hasLocationData() {
    return eventDetail?.lat != null || eventDetail?.lan != null;
  }

  Widget _buildNotesSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        VSpacings.medium,
        _buildNotesTitle(context),
        SizedBox(height: Sizes.tenInt.h),
        _buildNotesContent(context),
        VSpacings.medium,
        _buildItineraryLabel(context),
        VSpacings.medium,
        _buildDivider(),
        VSpacings.medium,
      ],
    );
  }

  Widget _buildNotesTitle(BuildContext context) {
    return VisaTextView(
      text: S.of(context).notes,
      style: VisaTextStyle.displayBodyXl,
      fontFamily: VisaFontWeight.semibold,
      colorTheme: VisaTextTheme.textColorBlack,
      textLineHeight: 1.39,
      maxLines: 10,
      lineHeight: 1.39,
    );
  }

  Widget _buildNotesContent(BuildContext context) {
    final desc = eventDetail?.description;
    return VisaTextView(
      text: (desc == null || desc.isEmpty) ? "-" : desc,
      style: VisaTextStyle.displayBodyXl,
      fontFamily: VisaFontWeight.regular,
      colorTheme: VisaTextTheme.textColorBlack,
      textLineHeight: 1.29,
      lineHeight: 1.29,
      maxLines: 100,
    );
  }

  Widget _buildItineraryLabel(BuildContext context) {
    return VisaTextView(
      text: S.of(context).adding_to_your_itinerary,
      softWrap: true,
      overflow: TextOverflow.visible,
      style: VisaTextStyle.customLarge,
      fontSize: 12.sp,
      fontFamily: VisaFontWeight.regular,
      customColor: VisaColors.dividerColor,
      colorTheme: VisaTextTheme.customTextColor,
      letterSpacing: 0,
      lineHeight: (16 / 12.sp).h,
    );
  }

  Widget _buildDivider() {
    return Divider(
      color: VisaColors.dividerColor,
      thickness: Sizes.one.w,
      height: 0,
    );
  }

  Widget _buildEvaSection(
      BuildContext context, ItineraryDetailProvider viewModel) {
    return Semantics(
      label: S.of(context).explore_activity_eva,
      button: true,
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
          onTap: () => viewModel.openEvaChat(),
          child: Row(
            children: [
              _buildEvaIcon(context),
              VisaSizeBox(width: Sizes.twelveInt.w),
              _buildEvaText(context),
              VisaSizeBox(
                  width: Sizes.sixteenInt.h, height: Sizes.sixteenInt.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEvaIcon(BuildContext context) {
    return VisaSvgIcon(
      semantics: false,
      height: Sizes.twentySixInt.h,
      width: Sizes.twentySixInt.w,
      assetPath: Assets.iconsEva,
      color: context.theme.primaryColor,
    );
  }

  Widget _buildEvaText(BuildContext context) {
    return Expanded(
      child: VisaRichText(
        semantics: false,
        maxLines: 3,
        textSpans: [
          VisaTextSpan(
            text: S.of(context).explore_activity_eva,
            style: VisaTextStyle.displayBodyXl,
            fontSize: Sizes.eighteenInt.sp,
            letterSpacing: -0.5,
            lineHeight: Sizes.twenty,
            fontFamily: VisaFontWeight.semibold,
            colorTheme: VisaTextTheme.customTextColor,
            customColor: VisaColors.black,
            iconHeight: Sizes.tenInt.h,
            iconWidth: Sizes.fourteenInt.w,
            iconPath: Assets.iconsIcRichTextRightArrow,
          ),
        ],
      ),
    );
  }
}
