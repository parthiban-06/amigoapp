import 'package:flutter/material.dart';
import 'package:visaamigo/custom_widgets/visa_svg_icon.dart';
import 'package:visaamigo/custom_widgets/visa_textview.dart';
import 'package:visaamigo/generated/assets.dart';

import '../generated/l10n.dart';
import '../utils/const_screen_size.dart';

class VisaChatTitleWidget extends StatelessWidget {
  // SVG Icon Properties
  final String iconPath;
  final double? iconWidth;
  final double? iconHeight;
  final Color? iconColor;
  final BoxFit iconFit;
  final double iconOpacity;
  final EdgeInsets? iconPadding;
  final EdgeInsets? iconMargin;

  // Text Properties
  final String text;
  final VisaTextStyle style;
  final VisaTextTheme colorTheme;
  final TextAlign textAlign;
  final Color customColor;
  final int? maxLines;
  final TextOverflow overflow;
  final bool isItalic;
  final double? letterSpacing;
  final double? lineHeight;
  final double? fontSize;
  final bool? showEditIcon;
  final VisaFontWeight fontFamily;
  final bool softWrap;
  final TextWidthBasis textWidthBasis;
  final double? textLineHeight;
  final VoidCallback? onEditTap;

  const VisaChatTitleWidget({
    super.key,
    // SVG Icon Parameters
    required this.iconPath,
    this.iconWidth,
    this.iconHeight,
    this.iconColor,
    this.iconFit = BoxFit.contain,
    this.iconOpacity = 1.0,
    this.iconPadding,
    this.iconMargin,

    // Text Parameters
    required this.text,
    required this.style,
    required this.colorTheme,
    this.textAlign = TextAlign.start,
    required this.customColor,
    this.maxLines,
    this.overflow = TextOverflow.visible,
    this.isItalic = false,
    this.letterSpacing,
    this.lineHeight,
    this.fontSize,
    this.showEditIcon = false,
    required this.fontFamily,
    this.softWrap = true,
    this.textWidthBasis = TextWidthBasis.parent,
    this.textLineHeight,
    this.onEditTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: VisaTextView(
            semantics: false,
            text: text,
            style: style,
            colorTheme: colorTheme,
            textAlign: textAlign,
            customColor: customColor,
            maxLines: maxLines,
            overflow: overflow,
            isItalic: isItalic,
            letterSpacing: letterSpacing,
            lineHeight: lineHeight,
            fontSize: fontSize,
            fontFamily: fontFamily,
            softWrap: softWrap,
            textWidthBasis: textWidthBasis,
            textLineHeight: textLineHeight,
          ),
        ),
        AppSizes.xxsmallVS,
        (showEditIcon ?? false)
            ? Padding(
                padding: iconPadding ?? EdgeInsets.zero,
                child: Semantics(
                  label: S.of(context).edit_message_icon,
                  button: true,
                  enabled: true,
                  child: VisaSvgIcon(
                    semantics: false,
                    assetPath: Assets.iconsIcEdit,
                    width: iconWidth,
                    height: iconHeight,
                    color: iconColor,
                    fit: iconFit,
                    opacity: iconOpacity,
                    onTap: onEditTap,
                  ),
                ),
              )
            : const SizedBox(),
      ],
    );
  }
}
