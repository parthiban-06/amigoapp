import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_utils/src/extensions/export.dart';
import 'package:provider/provider.dart';
import 'package:visaamigo/core/theme/theme.dart';
import 'package:visaamigo/custom_widgets/visa_svg_icon.dart';
import 'package:visaamigo/features/itinerary/providers/itinerary_provider.dart';
import 'package:visaamigo/features/itinerary/screens/widgets/customization/calendar_style.dart';
import 'package:visaamigo/features/itinerary/screens/widgets/customization/days_of_week_style.dart';
import 'package:visaamigo/features/itinerary/screens/widgets/customization/header_style.dart';
import 'package:visaamigo/features/itinerary/screens/widgets/shared/calendar_utils.dart';
import 'package:visaamigo/features/itinerary/screens/widgets/visa_calendar.dart';
import 'package:visaamigo/features/select_languages/providers/language_selection_generic_provider.dart';
import 'package:visaamigo/generated/assets.dart';
import 'package:visaamigo/utils/const_screen_size.dart';
import 'package:visaamigo/utils/test_style_util.dart';

import '../../../../../custom_widgets/visa_textview.dart';
import '../../../../../generated/l10n.dart';

class ItineraryCalandarView extends StatelessWidget {
  late ItineraryProvider itineraryProvider;
  late SelectLanguageGenericProvider lanagueProvider;

  ItineraryCalandarView({super.key});

  @override
  Widget build(BuildContext context) {
    itineraryProvider = Provider.of<ItineraryProvider>(context, listen: false);
    lanagueProvider =
        Provider.of<SelectLanguageGenericProvider>(context, listen: true);

    return Stack(children: [
      Container(
        margin: EdgeInsets.only(bottom: Sizes.thirty),
        child: VisaCalendar(
          firstDay: kFirstDay,
          lastDay: kLastDay,
          locale: lanagueProvider.locale?.languageCode ?? "en",
          focusedDay: itineraryProvider.focusedDay,
          selectedDayPredicate: (day) =>
              isSameDay(itineraryProvider.selectedDay, day),
          calendarFormat: itineraryProvider.calendarFormat,
          rangeSelectionMode: itineraryProvider.rangeSelectionMode,
          calendarBgColor: VisaColors.blueBackgroundLight2,
          calendarBgRadius: Sizes.sixteen,
          startingDayOfWeek: StartingDayOfWeek.sunday,
          eventLoader: (day) {
            return itineraryProvider.getEventsForDay(day);
          },
          onNextYearClicked: (date) {
            itineraryProvider.onNextYearClicked(date);
          },
          onPreviousYearClicked: (date) {
            itineraryProvider.onPreviousYearClicked(date);
          },
          calendarStyle: CalendarStyle(
            weekendTextStyle: VisaTextUtils.getVisaTextStyle(
              VisaTextStyle.displayBodyXs,
              context: context,
              isDarkMode: false,
              letterSpacing: -1,
              lineHeight: 0.87,
              fontFamily: VisaFontWeight.medium,
              fontColor: VisaColors.primaryDark,
            ),
            selectedTextStyle: VisaTextUtils.getVisaTextStyle(
              VisaTextStyle.displayBodyS,
              context: context,
              isDarkMode: false,
              letterSpacing: -1,
              lineHeight: 0.87,
              fontFamily: VisaFontWeight.medium,
              fontColor: VisaColors.white,
            ),
            weekNumberTextStyle: const TextStyle(
              color: VisaColors.black,
              fontWeight: FontWeight.w500,
            ),
            withinRangeTextStyle: const TextStyle(
              color: VisaColors.primaryDark,
              fontWeight: FontWeight.w500,
            ),
            todayTextStyle: itineraryProvider.getDaysTextStyle(context),
            defaultTextStyle: itineraryProvider.getDaysTextStyle(context),
            todayDecoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: VisaColors.primaryDark, // Border color
                width: 1.0.w, // Border width
              ),
            ),
            outsideDaysVisible: false,
            selectedDecoration: BoxDecoration(
              shape: BoxShape.circle,
              color: VisaColors.black,
              border: Border.all(
                color: VisaColors.black, // Border color
                width: 1.0.w, // Border width
              ),
            ),
            rangeStartDecoration: BoxDecoration(
              shape: BoxShape.circle,
              color: VisaColors.primaryDark,
              border: Border.all(
                color: VisaColors.primaryDark, // Border color
                width: 1.0.w, // Border width
              ),
            ),
            rangeEndDecoration: BoxDecoration(
              shape: BoxShape.circle,
              color: VisaColors.primaryDark,
              border: Border.all(
                color: VisaColors.primaryDark, // Border color
                width: 1.0.w, // Border width
              ),
            ),
            withinRangeDecoration: BoxDecoration(
              shape: BoxShape.circle,
              color: VisaColors.primaryDark,
              border: Border.all(
                color: VisaColors.primaryDark, // Border color
                width: 1.0.w, // Border width
              ),
            ),
          ),
          daysOfWeekStyle: DaysOfWeekStyle(
            weekdayStyle: itineraryProvider.getDaysTitleTextStyle(context),
            weekendStyle: itineraryProvider.getDaysTitleTextStyle(context),
          ),
          daysOfWeekHeight: Sizes.forty,
          headerStyle: HeaderStyle(
            titleCentered: true,
            formatButtonTitleCentered: true,
            headerDateBgColor: context.theme.primaryColor,
            headerDateBgColorCornerRadius: Sizes.five,
            formatButtonPadding: EdgeInsets.only(
              left: Sizes.ten,
              top: Sizes.five,
              bottom: Sizes.five,
            ),
            titleTextStyle: VisaTextUtils.getVisaTextStyle(
              VisaTextStyle.custom,
              fontSize: Sizes.twentyTwoInt.sp,
              context: context,
              isDarkMode: false,
              lineHeight: 1.09,
              letterSpacing: -1,
              fontFamily: VisaFontWeight.bold,
              fontColor: VisaColors.black,
            ),
            leftChevronIcon: const Icon(
              Icons.chevron_left,
              color: VisaColors.black,
            ),
            rightChevronIcon: const Icon(
              Icons.chevron_right,
              color: VisaColors.black,
            ),
            dropDownTopIcon: Icon(
              Icons.keyboard_arrow_up,
              color: context.theme.secondaryHeaderColor,
            ),
            dropDownBottomIcon: Icon(
              Icons.keyboard_arrow_down,
              color: context.theme.secondaryHeaderColor,
            ),
            formatButtonTextStyle: TextStyle(
              color: VisaColors.red,
              fontSize: Sizes.twelve,
              fontWeight: FontWeight.w400,
            ),
            formatButtonDecoration: BoxDecoration(
              color: context.theme.primaryColor,
              borderRadius: BorderRadius.all(
                Radius.circular(
                  Sizes.five,
                ),
              ),
            ),
          ),
          onDaySelected: (selectedDay, focusedDay) {
            itineraryProvider.onDaySelected(selectedDay, focusedDay);
          },
          onRangeSelected: (start, end, focusedDay) {
            itineraryProvider.onRangeSelected(start, end, focusedDay);
          },
          onFormatChanged: (format) {
            itineraryProvider.onFormatChanged(format);
          },
          onPageChanged: (focusedDay) {
            focusedDay = focusedDay;
          },
        ),
      ),
      Positioned(
        bottom: Sizes.fifteen,
        left: 0,
        right: 0,
        child: GestureDetector(
          onTap: () {
            itineraryProvider.updateCalendarFormat();
          },
          child: Semantics(
            enabled: true,
            container: true,
            excludeSemantics: true,
            label: (itineraryProvider.calendarFormat == CalendarFormat.month)
                ? S.of(context).calendar.toLowerCase() +
                    S.of(context).expanded.toLowerCase() +
                    S.of(context).double_tap_to_collapse
                : S.of(context).calendar.toLowerCase() +
                    S.of(context).collapsed.toLowerCase() +
                    S.of(context).double_tap_to_expand,
            child: Container(
              width: Sizes.thirtySixInt.w,
              height: Sizes.thirtySixInt.h,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color:
                    VisaColors.blueBackgroundLight2, // light blue or any color
              ),
              child: Center(
                child: VisaSvgIcon(
                  semantics: false,
                  assetPath:
                      (itineraryProvider.calendarFormat == CalendarFormat.month)
                          ? Assets.iconsIcSubtract
                          : Assets.iconsIcAdd,
                  height: Sizes.fourteen.h,
                  width: Sizes.fourteen.w,
                ),
              ),
            ),
          ),
        ),
      ),
    ]);
  }
}
