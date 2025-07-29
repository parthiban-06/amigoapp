import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:visaamigo/core/theme/theme.dart';
import 'package:visaamigo/custom_widgets/visa_font_family.dart';
import 'package:visaamigo/custom_widgets/visa_svg_icon.dart';
import 'package:visaamigo/custom_widgets/visa_textview.dart';
import 'package:visaamigo/generated/assets.dart';

import '../utils/const_screen_size.dart';

class VisaChatResponseWidget extends StatelessWidget {
  // SVG Icon Properties
  final String iconPath;
  final double? iconWidth;
  final double? iconHeight;
  final Color? iconColor;
  final BoxFit iconFit;
  final double iconOpacity;
  final EdgeInsets? iconPadding;
  final EdgeInsets? iconMargin;
  final VoidCallback? onFinishhed;

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
  final bool? showGlitterIcon;
  final VisaFontWeight fontFamily;
  final bool softWrap;
  final bool isLastIndex;
  final TextWidthBasis textWidthBasis;
  final double? textLineHeight;

  const VisaChatResponseWidget({
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
    this.isLastIndex = true,
    this.onFinishhed,

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
    this.showGlitterIcon = true,
    required this.fontFamily,
    this.softWrap = true,
    this.textWidthBasis = TextWidthBasis.parent,
    this.textLineHeight,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        (showGlitterIcon ?? false)
            ? VisaSvgIcon(
                assetPath: iconPath,
                width: iconWidth,
                height: iconHeight,
                color: iconColor,
                fit: iconFit,
                opacity: iconOpacity,
              )
            : const SizedBox(),
        AppSizes.xxsmallVS,
        Expanded(
          child: /*TypeWriterText(
            play: isLastIndex,
            onFinished: onFinishhed,
            text: Text(
              text,
              style: TextStyle(
                color: VisaColors.black,
                fontSize: FontSizes(context).displayBodyL,
                fontFamily:
                    VisaFontFamily.getFontFamily(VisaFontWeight.medium, false),
                fontWeight: FontWeight.w600,
                height: 1.12,
              ),
            ),
            duration: Duration(milliseconds: 20), // Typing speed
          )*/
              AnimatedTextKit(
            animatedTexts: [
              TypewriterAnimatedText(
                text,
                textStyle: TextStyle(
                  color: VisaColors.black,
                  fontSize: FontSizes(context).displayBodyL,
                  fontFamily: VisaFontFamily.getFontFamily(
                      VisaFontWeight.medium, false),
                  fontWeight: FontWeight.w600,
                  height: 1.12,
                ),
                speed: const Duration(milliseconds: 20),
              ),
            ],
            totalRepeatCount: 1,
            onFinished: onFinishhed,
          ),
        ),
        AppSizes.xxsmallVS,
        (showEditIcon ?? false)
            ? Padding(
                padding: iconPadding ?? EdgeInsets.zero,
                child: InkWell(
                  onTap: () {},
                  child: VisaSvgIcon(
                    assetPath: Assets.iconsIcEdit,
                    width: iconWidth,
                    height: iconHeight,
                    color: iconColor,
                    fit: iconFit,
                    onTap: () {},
                    opacity: iconOpacity,
                  ),
                ),
              )
            : const SizedBox(),
      ],
    );
  }
}
