import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:visaamigo/custom_widgets/visa_svg_icon.dart';
import 'package:visaamigo/custom_widgets/visa_textview.dart';
import 'package:visaamigo/features/itinerary/models/event_list_model.dart';
import 'package:visaamigo/features/itinerary/providers/itinerary_provider.dart';
import 'package:visaamigo/generated/assets.dart';
import 'package:visaamigo/generated/l10n.dart';
import 'package:visaamigo/utils/app_const.dart';
import 'package:visaamigo/utils/utils.dart';

import '../../../../../core/theme/theme.dart';
import '../../../../../utils/const_screen_size.dart';
import '../../../../../utils/date_util.dart';
import '../../../../profile/provider/user_generic_detail_provider.dart';

class Itineraryitems extends StatelessWidget {
  Itineraryitems({super.key});

  late ItineraryProvider viewModel;
  late UserGenericProvider userGeneric;

  @override
  Widget build(BuildContext context) {
    _initializeProviders(context);
    return _buildListView();
  }

  void _initializeProviders(BuildContext context) {
    viewModel = Provider.of<ItineraryProvider>(context);
    userGeneric = Provider.of<UserGenericProvider>(context);
  }

  Widget _buildListView() {
    return ListView.builder(
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: viewModel?.selectedDateEvent.length ?? 0,
      itemBuilder: _buildListItem,
    );
  }

  Widget _buildListItem(BuildContext context, int index) {
    final EventList? event = viewModel?.selectedDateEvent[index];
    return event != null ? _buildEventCard(event) : const SizedBox.shrink();
  }

  Widget _buildEventCard(EventList event) {
    return Padding(
      padding: EdgeInsets.only(bottom: Sizes.twentyFourInt.r),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildEventIcon(event),
          HSpacings.xsmall,
          Expanded(child: _buildEventContent(event)),
        ],
      ),
    );
  }

  Widget _buildEventIcon(EventList event) {
    return Container(
      width: Sizes.twentyFour.w,
      height: Sizes.twentyFour.h,
      padding: EdgeInsets.all(Sizes.six),
      decoration: ShapeDecoration(
        color: Colors.black,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Sizes.thirty),
        ),
      ),
      child: VisaSvgIcon(
        assetPath: getItinearyType(event.eventCategory, event.type),
        color: VisaColors.white,
      ),
    );
  }

  Widget _buildEventContent(EventList event) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildEventTitle(event),
        _buildDivider(),
        if (_hasTimeInfo(event)) _buildEventTime(event),
        _buildEventAddress(event),
        _buildDetailsLink(event),
      ],
    );
  }

  Widget _buildEventTitle(EventList event) {
    return VisaTextView(
      text: event.title,
      colorTheme: VisaTextTheme.textColorBlack,
      style: VisaTextStyle.displayBodyL,
      fontFamily: VisaFontWeight.semibold,
      lineHeight: 1.12,
      maxLines: 3,
      textLineHeight: 1.12,
    );
  }

  Widget _buildDivider() {
    return Column(
      children: [
        SizedBox(height: Sizes.sixInt.h),
        const Divider(
          color: VisaColors.dividerColor,
          thickness: 1.0,
          height: 0,
        ),
        SizedBox(height: Sizes.sixInt.h),
      ],
    );
  }

  bool _hasTimeInfo(EventList event) {
    return (event.startTime.isNotEmpty) ||
        (event.eventDate?.isNotEmpty ?? false);
  }

  Widget _buildEventTime(EventList event) {
    final timeText = _formatTimeText(event);
    final timeTextSemantics = _formatTimeTextSemantics(event);
    if (timeText.isEmpty) return const SizedBox.shrink();

    return VisaTextView(
      text: timeText,
      semanticsLabel: "$timeTextSemantics,"
          "${event.timezone}",
      colorTheme: VisaTextTheme.textColorBlack,
      style: VisaTextStyle.displayBodyXs,
      fontFamily: VisaFontWeight.medium,
      lineHeight: 1.40,
      textLineHeight: 1.40,
      letterSpacing: 2,
    );
  }

  String _formatTimeText(EventList event) {
    final start = _extractTime(event.startTime);
    final end = _extractTime(event.endTime ?? "");
    final timeZone = _getTimeZone(event);

    if (start.isEmpty && end.isEmpty) return "";

    final timeFormat = userGeneric.is24hrsClockEnable ? 'HH:mm' : 'hh:mm a';

    if (start.isNotEmpty && end.isNotEmpty) {
      return _formatTimeRange(start, end, timeZone, timeFormat);
    } else if (start.isNotEmpty) {
      return _formatSingleTime(start, timeZone, timeFormat);
    }

    return "";
  }

  String _extractTime(String timeString) {
    return timeString.split(RegExp(r'[+-]')).first;
  }

  String _getTimeZone(EventList event) {
    if (event.type == AppConst.ITINERARY_TYPE_MATCH) {
      return DateUtil.getTimezoneOffset(
        DateUtil.mapTimezoneNameToIANA(event.timezone),
      );
    }
    return Utils.extractTimeZone(viewModel.mContext, event.startTime);
  }

  String _formatTimeRange(
      String start, String end, String timeZone, String format) {
    final dtStart = DateTime.parse("2025-01-01T$start");
    final dtEnd = DateTime.parse("2025-01-01T$end");
    final startFormatted = DateFormat(format).format(dtStart);
    final endFormatted = DateFormat(format).format(dtEnd);
    return "$startFormatted - $endFormatted ($timeZone UTC)";
  }

  String _formatSingleTime(String time, String timeZone, String format) {
    final dt = DateTime.parse("2025-01-01T$time");
    final formatted = DateFormat(format).format(dt);
    return "$formatted ($timeZone UTC)";
  }

  String _formatTimeTextSemantics(EventList event) {
    final start = _extractTime(event.startTime);
    final end = _extractTime(event.endTime ?? "");

    if (start.isEmpty && end.isEmpty) return "";

    final timeFormat = userGeneric.is24hrsClockEnable ? 'HH:mm' : 'hh:mm a';

    if (start.isNotEmpty && end.isNotEmpty) {
      return _formatTimeRangeSemantics(start, end, timeFormat);
    } else if (start.isNotEmpty) {
      return _formatSingleTimeSemantics(start, timeFormat);
    }

    return "";
  }

  String _formatTimeRangeSemantics(String start, String end, String format) {
    final dtStart = DateTime.parse("2025-01-01T$start");
    final dtEnd = DateTime.parse("2025-01-01T$end");
    final startFormatted = DateFormat(format).format(dtStart);
    final endFormatted = DateFormat(format).format(dtEnd);
    return "$startFormatted - $endFormatted";
  }

  String _formatSingleTimeSemantics(String time, String format) {
    final dt = DateTime.parse("2025-01-01T$time");
    final formatted = DateFormat(format).format(dt);
    return formatted;
  }

  Widget _buildEventAddress(EventList event) {
    return Column(
      children: [
        SizedBox(height: Sizes.eightInt.h),
        VisaTextView(
          text: event.address.isEmpty ? "-" : event.address,
          colorTheme: VisaTextTheme.textColorBlack,
          style: VisaTextStyle.displayBodyS,
          fontFamily: VisaFontWeight.semibold,
          lineHeight: 1.30,
          maxLines: 5,
          textLineHeight: 1.30,
        ),
        SizedBox(height: Sizes.sixInt.h),
      ],
    );
  }

  Widget _buildDetailsLink(EventList event) {
    return Semantics(
      label:
          "${S.of(viewModel.mContext).more_details_button} ${event.title} ${S.of(viewModel.mContext).event_information}",
      enabled: true,
      container: true,
      child: GestureDetector(
        onTap: () => viewModel?.openItineraryDetail(event),
        child: VisaTextView(
          semantics: false,
          text: S.of(viewModel.mContext).more_details,
          colorTheme: VisaTextTheme.customTextColor,
          customColor: VisaColors.primary,
          style: VisaTextStyle.link,
          fontFamily: VisaFontWeight.semibold,
          lineHeight: 1.29,
          textLineHeight: 1.29,
        ),
      ),
    );
  }

  String getItinearyType(String? eventCategory, String? type) {
    switch (type) {
      case AppConst.ITINERARY_TYPE_MATCH:
        return Assets.iconsIcItinearyMatch;

      case AppConst.ITINERARY_CATEGORY_FLIGHT:
        return Assets.iconsIcTravel;
    }

    switch (eventCategory) {
      case AppConst.ITINERARY_CATEGORY_FLIGHT:
        return Assets.iconsIcTravel;

      case AppConst.ITINERARY_CATEGORY_ACTIVITY:
        return Assets.iconsIcActivity;

      case AppConst.ITINERARY_CATEGORY_FOOD:
        return Assets.iconsIcFood;

      case AppConst.ITINERARY_CATEGORY_MISCELLANEOUS:
        return Assets.iconsIcItineraryLocation;

      case AppConst.ITINERARY_CATEGORY_ACCOMMODATION:
        return Assets.iconsIcAccomadation;

      case AppConst.ITINERARY_CATEGORY_SIGHTSEEING:
        return Assets.iconsIcSightseeing;

      case AppConst.ITINERARY_CATEGORY_TRANSPORTATION:
        return Assets.iconsIcTransportation;

      default:
        return Assets.iconsIcItineraryLocation;
    }
  }
}
