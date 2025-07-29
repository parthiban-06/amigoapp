import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:visaamigo/core/theme/theme.dart';
import 'package:visaamigo/custom_widgets/visa_svg_icon.dart';

import '../analytics/firebase_analytics_service.dart';
import '../features/select_languages/providers/language_selection_generic_provider.dart';
import '../generated/l10n.dart';
import '../utils/const_screen_size.dart';
import 'visa_textview.dart';

class VisaAppBarActions extends StatefulWidget {
  final String text;
  final VoidCallback? onPressed;
  final VisaTextStyle visaTextStyle;
  final VisaTextTheme visaTextTheme;
  final VisaFontWeight fontFamily;
  final bool isIconShow;
  final bool isTextShow;
  final IconData? icons;
  final String? svgIconPath;
  final Color iconColor;
  final double iconSize;
  final double letterSpacing;
  final double lineHeight;
  final Color? customColor;
  final EdgeInsetsGeometry? padding; // New padding property
  final bool? isComeFromAppBar;
  final bool semantics;
  final int? semanticsIndex;
  final bool semanticsFocused;

  const VisaAppBarActions({
    super.key,
    this.text = '',
    this.visaTextStyle = VisaTextStyle.bodyMedium,
    this.visaTextTheme = VisaTextTheme.primaryDark,
    this.fontFamily = VisaFontWeight.medium,
    this.icons,
    this.svgIconPath,
    this.isIconShow = true,
    this.isTextShow = false,
    this.onPressed,
    this.iconColor = Colors.black,
    this.iconSize = 24,
    this.letterSpacing = 0.0,
    this.lineHeight = 1.02,
    this.customColor,
    this.padding, // Padding parameter added
    this.isComeFromAppBar = true,
    this.semantics = true,
    this.semanticsIndex,
    this.semanticsFocused = false,
  });

  @override
  State<VisaAppBarActions> createState() => _VisaAppBarActionsState();
}

class _VisaAppBarActionsState extends State<VisaAppBarActions> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    Widget textButton() {
      return TextButton(
        style: ButtonStyle(
            overlayColor: WidgetStateProperty.all(Colors.transparent),
            padding: !widget.isComeFromAppBar!
                ? const WidgetStatePropertyAll(EdgeInsets.zero)
                : null),
        /*onPressed: () {
            setState(() {
              _isPressed = true;
            });
            widget.onPressed!();
          },*/
        onPressed: widget.onPressed != null
            ? () {
                setState(() {
                  _isPressed = true;
                });
                widget.onPressed!();
                final localLanguageProvider =
                    Provider.of<SelectLanguageGenericProvider>(context,
                        listen: false);
                FirebaseAnalyticsService.logEventButtonClick(
                  btnName: localLanguageProvider
                          .getKeyFromValue(widget.text.toLowerCase()) ??
                      "",
                );
              }
            : null,
        child: Row(
          children: [
            if (widget.isIconShow)
              (widget.svgIconPath != null)
                  ? VisaSvgIcon(
                      semantics: false,
                      assetPath: widget.svgIconPath!,
                      height: widget.iconSize,
                      width: widget.iconSize,
                      color: _isPressed ? VisaColors.black : widget.iconColor,
                    )
                  : ExcludeSemantics(
                      child: Icon(
                        widget.icons,
                        color: _isPressed ? VisaColors.black : widget.iconColor,
                        size: widget.iconSize.r,
                      ),
                    ),
            if (widget.isTextShow && widget.text.isNotEmpty)
              Padding(
                  padding: EdgeInsets.only(left: Sizes.four),
                  child: VisaTextView(
                    semantics: false,
                    text: widget.text,
                    style: widget.visaTextStyle,
                    colorTheme: widget.visaTextTheme,
                    letterSpacing: widget.letterSpacing,
                    customColor: widget.customColor!,
                    lineHeight: widget.lineHeight,
                    fontFamily:
                        _isPressed ? VisaFontWeight.bold : widget.fontFamily,
                  )),
          ],
        ),
      );
    }

    return Padding(
      padding:
          widget.padding ?? EdgeInsets.symmetric(horizontal: AppSizes.zero),
      child: widget.semantics
          ? Semantics(
              enabled: true,
              container: true,
              excludeSemantics: true,
              focused: widget.semanticsFocused,
              focusable: widget.semanticsFocused,
              label: '${widget.text},${S.of(context).double_tap_to_activate}',
              sortKey: widget.semanticsIndex != null
                  ? OrdinalSortKey(widget.semanticsIndex!.toDouble())
                  : null,
              child: textButton(),
            )
          : ExcludeSemantics(
              child: textButton(),
            ),
    );
  }
}
