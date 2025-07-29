import 'package:flutter/material.dart';
import 'package:visaamigo/utils/const_screen_size.dart' show AppSizes;
import 'package:visaamigo/utils/utils.dart';

class TextWithEndIcon extends StatelessWidget {
  final List<String> text;
  final Widget widget;
  final bool selected;
  final TextStyle? textStyle;
  final Color? iconColor;

  const TextWithEndIcon({
    super.key,
    required this.text,
    this.textStyle,
    this.iconColor,
    required this.widget,
    required this.selected,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: List.generate(text.length, (index) {
        return Text(
          '${text[index]} ',
          style: textStyle ?? DefaultTextStyle.of(context).style,
          textScaler: TextScaler.linear(
              Utils.getCappedScale(context, AppSizes.fontfourteen)),
        );
      })
        ..add(widget),
    );
  }
}
