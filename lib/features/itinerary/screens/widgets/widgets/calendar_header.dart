import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:visaamigo/custom_widgets/visa_auto_size_text.dart';
import 'package:visaamigo/utils/const_screen_size.dart';

import '../../../../../core/theme/theme.dart';
import '../../../../../custom_widgets/visa_textview.dart';
import '../../../../../generated/l10n.dart';
import '../../../../../utils/test_style_util.dart';
import '../customization/header_style.dart';
import '../shared/calendar_utils.dart' show CalendarFormat, DayBuilder;
import 'custom_icon_button.dart';

/// Data class for header texts
class _HeaderTexts {
  final String monthText;
  final String yearText;

  const _HeaderTexts({
    required this.monthText,
    required this.yearText,
  });
}

class CalendarHeader extends StatelessWidget {
  final String? locale;
  final DateTime focusedMonth;
  final CalendarFormat calendarFormat;
  final HeaderStyle headerStyle;
  final VoidCallback onLeftChevronTap;
  final VoidCallback onLeftYearChevronTap;
  final VoidCallback onRightChevronTap;
  final VoidCallback onRightYearChevronTap;
  final VoidCallback onHeaderTap;
  final VoidCallback onHeaderLongPress;
  final ValueChanged<CalendarFormat> onFormatButtonTap;
  final Map<CalendarFormat, String> availableCalendarFormats;
  final DayBuilder? headerTitleBuilder;

  const CalendarHeader({
    super.key,
    this.locale,
    required this.focusedMonth,
    required this.calendarFormat,
    required this.headerStyle,
    required this.onLeftChevronTap,
    required this.onLeftYearChevronTap,
    required this.onRightChevronTap,
    required this.onRightYearChevronTap,
    required this.onHeaderTap,
    required this.onHeaderLongPress,
    required this.onFormatButtonTap,
    required this.availableCalendarFormats,
    this.headerTitleBuilder,
  });

  @override
  Widget build(BuildContext context) {
    final headerTexts = _buildHeaderTexts();

    return Container(
      padding: _getHeaderPadding(),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildMonthSection(context, headerTexts.monthText),
          _buildYearSection(context, headerTexts.yearText),
        ],
      ),
    );
  }

  _HeaderTexts _buildHeaderTexts() {
    final monthText =
        headerStyle.titleTextFormatter?.call(focusedMonth, locale) ??
            DateFormat.MMMM(locale).format(focusedMonth);
    final yearText = DateFormat('yyyy', locale).format(focusedMonth);

    return _HeaderTexts(monthText: monthText, yearText: yearText);
  }

  EdgeInsets _getHeaderPadding() {
    return EdgeInsets.only(
      top: Sizes.sixteen,
      bottom: Sizes.sixteen,
      left: Sizes.ten,
      right: Sizes.ten,
    );
  }

  Widget _buildMonthSection(BuildContext context, String monthText) {
    return Expanded(
      flex: 4,
      child: GestureDetector(
        onHorizontalDragEnd: (details) => _handleMonthDrag(details),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            _buildLeftChevron(context, true),
            _buildMonthTitle(context, monthText),
            _buildRightChevron(context, true),
          ],
        ),
      ),
    );
  }

  Widget _buildYearSection(BuildContext context, String yearText) {
    return Expanded(
      flex: 3,
      child: GestureDetector(
        onHorizontalDragEnd: (details) => _handleYearDrag(details),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            _buildLeftChevron(context, false),
            _buildYearTitle(context, yearText),
            _buildRightChevron(context, false),
          ],
        ),
      ),
    );
  }

  void _handleMonthDrag(DragEndDetails details) {
    if (details.primaryVelocity != null) {
      if (details.primaryVelocity! > 0) {
        onLeftChevronTap();
      } else if (details.primaryVelocity! < 0) {
        onRightChevronTap();
      }
    }
  }

  void _handleYearDrag(DragEndDetails details) {
    if (details.primaryVelocity != null) {
      if (details.primaryVelocity! > 0) {
        onLeftYearChevronTap();
      } else if (details.primaryVelocity! < 0) {
        onRightYearChevronTap();
      }
    }
  }

  Widget _buildLeftChevron(BuildContext context, bool isMonth) {
    if (!headerStyle.leftChevronVisible) return const SizedBox.shrink();

    final label = isMonth
        ? _getMonthChevronLabel(context, true)
        : S.of(context).previous_year;

    return Semantics(
      enabled: true,
      button: true,
      label: label,
      child: CustomIconButton(
        icon: headerStyle.leftChevronIcon,
        onTap: isMonth ? onLeftChevronTap : onLeftYearChevronTap,
        padding: EdgeInsets.only(right: Sizes.ten),
      ),
    );
  }

  Widget _buildRightChevron(BuildContext context, bool isMonth) {
    if (!headerStyle.rightChevronVisible) return const SizedBox.shrink();

    final label = isMonth
        ? _getMonthChevronLabel(context, false)
        : S.of(context).next_year;

    return Semantics(
      enabled: true,
      button: true,
      label: label,
      child: CustomIconButton(
        icon: headerStyle.rightChevronIcon,
        onTap: isMonth ? onRightChevronTap : onRightYearChevronTap,
        padding: EdgeInsets.only(left: Sizes.ten),
      ),
    );
  }

  String _getMonthChevronLabel(BuildContext context, bool isPrevious) {
    return calendarFormat == CalendarFormat.week
        ? (isPrevious ? S.of(context).previous_week : S.of(context).next_week)
        : (isPrevious
            ? S.of(context).previous_month
            : S.of(context).next_month);
  }

  Widget _buildMonthTitle(BuildContext context, String monthText) {
    return Flexible(
      child: headerTitleBuilder?.call(context, focusedMonth) ??
          _buildDefaultMonthTitle(monthText),
    );
  }

  Widget _buildDefaultMonthTitle(String monthText) {
    return GestureDetector(
      onTap: onHeaderTap,
      onLongPress: onHeaderLongPress,
      child: VisaAutoSizeText(
        text: monthText,
        stepGranularity: 0.1,
        textAlign: TextAlign.justify,
        colorTheme: VisaTextTheme.customTextColor,
        maxFontSize: Sizes.twentyTwoInt.sp,
        fontSize: Sizes.twentyTwoInt.sp,
        lineHeight: 1.09,
        minFontSize: Sizes.twelve.sp,
        maxLines: 1,
        letterSpacing: -1,
        fontFamily: VisaFontWeight.bold,
        customColor: VisaColors.black,
        style: VisaTextStyle.custom,
      ),
    );
  }

  Widget _buildYearTitle(BuildContext context, String yearText) {
    return Flexible(
      child: Container(
        width: 62.w,
        padding:
            EdgeInsets.symmetric(horizontal: Sizes.zero, vertical: Sizes.ten),
        decoration: _getYearContainerDecoration(),
        child: headerTitleBuilder?.call(context, focusedMonth) ??
            _buildDefaultYearTitle(yearText),
      ),
    );
  }

  ShapeDecoration _getYearContainerDecoration() {
    return ShapeDecoration(
      color: Colors.black,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(100),
      ),
    );
  }

  Widget _buildDefaultYearTitle(String yearText) {
    return Semantics(
      enabled: true,
      child: Builder(
        builder: (context) => Text(
          yearText,
          textAlign: TextAlign.center,
          maxLines: 1,
          style: VisaTextUtils.getVisaTextStyle(
            VisaTextStyle.displayBodyS,
            context: context,
            isDarkMode: false,
            letterSpacing: 0,
            lineHeight: 0.87,
            fontFamily: VisaFontWeight.bold,
            fontColor: VisaColors.blueBackgroundLight2,
          ),
        ),
      ),
    );
  }
}
