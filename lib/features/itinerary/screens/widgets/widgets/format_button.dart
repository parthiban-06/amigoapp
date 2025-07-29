import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../../../utils/const_screen_size.dart';
import '../shared/calendar_utils.dart' show CalendarFormat;

class FormatButton extends StatelessWidget {
  final CalendarFormat calendarFormat;
  final ValueChanged<CalendarFormat> onTap;
  final TextStyle textStyle;
  final BoxDecoration decoration;
  final EdgeInsets padding;
  final bool showsNextFormat;
  final Map<CalendarFormat, String> availableCalendarFormats;
  final Widget dropDownBottomIcon;
  final Widget dropDownTopIcon;
  final bool formatButtonTitleCentered;

  const FormatButton(
      {super.key,
      required this.calendarFormat,
      required this.onTap,
      required this.textStyle,
      required this.decoration,
      required this.padding,
      required this.showsNextFormat,
      required this.availableCalendarFormats,
      required this.dropDownBottomIcon,
      required this.dropDownTopIcon,
      this.formatButtonTitleCentered = true});

  @override
  Widget build(BuildContext context) {
    final child = Container(
      decoration: decoration,
      padding: padding,
      child: Row(
        mainAxisAlignment: formatButtonTitleCentered
            ? MainAxisAlignment.center
            : MainAxisAlignment.start,
        children: [
          Text(
            _formatButtonText,
            style: textStyle,
          ),
          SizedBox(
            width: AppSizes.fiveRadius,
          ),
          _formatButtonText == 'Expand' ? dropDownBottomIcon : dropDownTopIcon,
        ],
      ),
    );

    final platform = Theme.of(context).platform;

    return !kIsWeb &&
            (platform == TargetPlatform.iOS || platform == TargetPlatform.macOS)
        ? CupertinoButton(
            onPressed: () => onTap(_nextFormat()),
            padding: EdgeInsets.zero,
            child: child,
          )
        : InkWell(
            borderRadius:
                decoration.borderRadius?.resolve(Directionality.of(context)),
            onTap: () => onTap(_nextFormat()),
            child: child,
          );
  }

  String get _formatButtonText => showsNextFormat
      ? availableCalendarFormats[_nextFormat()]!
      : availableCalendarFormats[calendarFormat]!;

  CalendarFormat _nextFormat() {
    final formats = availableCalendarFormats.keys.toList();
    int id = formats.indexOf(calendarFormat);
    id = (id + 1) % formats.length;

    return formats[id];
  }
}
