import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:visaamigo/core/theme/theme.dart';
import 'package:visaamigo/custom_widgets/visa_size_box.dart';
import 'package:visaamigo/custom_widgets/visa_textview.dart';
import 'package:visaamigo/generated/l10n.dart';
import 'package:visaamigo/ui/provider/theme_provider.dart';
import 'package:visaamigo/utils/const_screen_size.dart';
import 'package:visaamigo/utils/utils.dart';

import '../analytics/firebase_analytics_service.dart';
import '../features/select_languages/providers/language_selection_generic_provider.dart';

/// Enum to define the position of the icon in the button
enum IconButtonPosition {
  left,
  right,
  none,
}

/// Enum to define the button variant
enum VisaButtonVariant {
  primary,
  secondary,
  black,
  white,
  transparent,
  custom,
  delete
}

class VisaButton extends StatefulWidget {
  final String text;
  final String? semanticTitle;
  final String? widgetKey;
  final Function? onPressed;
  final IconData? icon;
  final IconButtonPosition iconPosition;
  final VisaButtonVariant variant;
  final double? width;
  final double? height;
  final double? iconSize;
  final double? fontSize;
  final double? borderRadius;
  final bool isLoading;
  final bool isOutlined;
  final bool isDisable;
  final bool ignoreDoubleClick;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? contentPadding;
  final VisaFontWeight fontWeight;
  final double? letterSpacing;
  final double? lineHeight;
  final Color? buttonColor;
  final Color? buttonTextColor;
  final bool semantics;
  final bool addDefaultAnalyticsEvent;
  final int? semanticsIndex;
  final Map<String,Object>? options;

  const VisaButton({
    super.key,
    required this.text,
    this.onPressed,
    this.icon,
    this.iconPosition = IconButtonPosition.none,
    this.variant = VisaButtonVariant.primary,
    this.width,
    this.height = 57,
    this.iconSize = 24,
    this.fontSize = 18,
    this.borderRadius = 16,
    this.isLoading = false,
    this.ignoreDoubleClick = false,
    this.isOutlined = false,
    this.isDisable = false,
    this.padding,
    this.contentPadding,
    this.fontWeight = VisaFontWeight.medium,
    this.letterSpacing = 0,
    this.lineHeight = 1.38,
    this.widgetKey,
    this.buttonColor = Colors.transparent,
    this.buttonTextColor = Colors.white,
    this.semantics = true,
    this.addDefaultAnalyticsEvent = true,
    this.semanticsIndex,
    this.semanticTitle, this.options,
  });

  @override
  State<VisaButton> createState() => _VisaButtonState();
}

class _VisaButtonState extends State<VisaButton> {
  bool _isHovered = false;
  DateTime? _lastClickTime;
  bool _isPressed = false;
  bool _isLoad = false;

  @override
  void initState() {
    super.initState();
  }

  // Minimum time between clicks (milliseconds)
  static const int _minimumClickInterval = 1000;

  bool get _canClick {
    if (widget.onPressed == null) {
      return false;
    }

    if (_lastClickTime != null) {
      final timeSinceLastClick = DateTime.now().difference(_lastClickTime!);
      if (timeSinceLastClick.inMilliseconds < _minimumClickInterval) {
        return false;
      }
    }

    return true;
  }

  Color _getBackgroundColor(ThemeProvider themeProvider) {
    // Handle outlined button cases first
    if (widget.isOutlined) {
      return _getOutlinedBackgroundColor();
    }

    // Handle specific variants
    if (widget.variant == VisaButtonVariant.delete) {
      return VisaColors.red;
    }

    if (widget.variant == VisaButtonVariant.transparent) {
      return VisaColors.transparent;
    }

    // Handle disabled state
    if (widget.isDisable == null || widget.isDisable) {
      return VisaColors.textFieldBorder;
    }

    // Handle static color variants
    if (widget.variant == VisaButtonVariant.black) {
      return VisaColors.black;
    }

    if (widget.variant == VisaButtonVariant.white) {
      return VisaColors.white;
    }

    if (widget.variant == VisaButtonVariant.custom) {
      return widget.buttonColor!;
    }

    // Handle loading/disabled state
    if (widget.onPressed == null || widget.isLoading) {
      return _getDisabledBackgroundColor();
    }

    // Handle hover state
    if (_isHovered) {
      return _getHoveredBackgroundColor(themeProvider);
    }

    // Default state
    return _getDefaultBackgroundColor();
  }

  Color _getOutlinedBackgroundColor() {
    if (widget.text == S.of(context).skip) {
      return VisaColors.primary;
    }
    return Colors.transparent;
  }

  Color _getDisabledBackgroundColor() {
    if (widget.variant == VisaButtonVariant.primary) {
      return Theme.of(context).colorScheme.primary.withValues(alpha: 128);
    }
    return Theme.of(context).colorScheme.secondary.withValues(alpha: 128);
  }

  Color _getHoveredBackgroundColor(ThemeProvider themeProvider) {
    if (widget.variant == VisaButtonVariant.primary) {
      return themeProvider.isDarkMode
          ? VisaColors.darkPrimaryLight
          : VisaColors.primaryLight;
    }
    return themeProvider.isDarkMode
        ? VisaColors.darkSecondaryLight
        : VisaColors.secondaryLight;
  }

  Color _getDefaultBackgroundColor() {
    if (widget.variant == VisaButtonVariant.primary) {
      return Theme.of(context).colorScheme.primary;
    }
    return Theme.of(context).colorScheme.secondary;
  }

  Color _getBorderColor(ThemeProvider themeProvider) {
    // Handle outlined button cases
    if (widget.isOutlined) {
      return _getOutlinedBorderColor(themeProvider);
    }

    // Handle loading/disabled state
    if (widget.onPressed == null || widget.isLoading) {
      return _getDisabledBorderColor();
    }

    // Handle transparent variant
    if (widget.variant == VisaButtonVariant.transparent) {
      return VisaColors.primary;
    }

    // Handle default state
    return _getDefaultBorderColor(themeProvider);
  }

  Color _getOutlinedBorderColor(ThemeProvider themeProvider) {
    switch (widget.variant) {
      case VisaButtonVariant.primary:
        return themeProvider.isDarkMode
            ? VisaColors.darkPrimary
            : VisaColors.primary;
      case VisaButtonVariant.secondary:
        return themeProvider.isDarkMode
            ? VisaColors.darkSecondary
            : VisaColors.secondaryDark;
      case VisaButtonVariant.black:
        return themeProvider.isDarkMode ? VisaColors.white : VisaColors.black;
      case VisaButtonVariant.white:
        return themeProvider.isDarkMode ? VisaColors.black : VisaColors.white;
      case VisaButtonVariant.custom:
        return widget.buttonColor!;
      default:
        return VisaColors.primary;
    }
  }

  Color _getDisabledBorderColor() {
    switch (widget.variant) {
      case VisaButtonVariant.primary:
        return VisaColors.primaryDark.withValues(alpha: 0.5);
      case VisaButtonVariant.secondary:
        return VisaColors.secondaryDark.withValues(alpha: 0.5);
      case VisaButtonVariant.black:
      case VisaButtonVariant.white:
        return VisaColors.transparent;
      case VisaButtonVariant.custom:
        return widget.buttonColor!.withValues(alpha: 0.5);
      default:
        return VisaColors.secondaryDark.withValues(alpha: 0.5);
    }
  }

  Color _getDefaultBorderColor(ThemeProvider themeProvider) {
    switch (widget.variant) {
      case VisaButtonVariant.primary:
        return themeProvider.isDarkMode
            ? VisaColors.darkPrimary
            : VisaColors.primaryDark;
      case VisaButtonVariant.secondary:
        return themeProvider.isDarkMode
            ? VisaColors.darkSecondary
            : VisaColors.secondaryDark;
      case VisaButtonVariant.black:
      case VisaButtonVariant.white:
        return VisaColors.transparent;
      case VisaButtonVariant.custom:
        return widget.buttonColor!;
      default:
        return themeProvider.isDarkMode
            ? VisaColors.darkSecondary
            : VisaColors.secondaryDark;
    }
  }

  Color _getTextColor(ThemeProvider themeProvider) {
    // Handle pressed state
    if (_isPressed) {
      return _getPressedTextColor(themeProvider);
    }

    // Handle outlined button cases
    if (widget.isOutlined) {
      return _getOutlinedTextColor(themeProvider);
    }

    // Handle specific variants
    if (widget.variant == VisaButtonVariant.transparent) {
      return Theme.of(context).colorScheme.primary;
    }

    if (widget.variant == VisaButtonVariant.delete) {
      return VisaColors.white;
    }

    // Handle disabled state
    if (widget.isDisable == null || widget.isDisable) {
      return Colors.white;
    }

    // Handle default state
    return _getDefaultTextColor(themeProvider);
  }

  Color _getPressedTextColor(ThemeProvider themeProvider) {
    switch (widget.variant) {
      case VisaButtonVariant.primary:
        return Colors.white;
      case VisaButtonVariant.black:
        return VisaColors.white;
      case VisaButtonVariant.white:
        return VisaColors.black;
      case VisaButtonVariant.custom:
        return widget.buttonTextColor!;
      case VisaButtonVariant.secondary:
        return (themeProvider.isDarkMode
                ? Colors.black
                : VisaColors.primaryDark)
            .withValues(alpha: 0.7);
      default:
        if (widget.isOutlined) {
          return _getOutlinedPressedTextColor(themeProvider);
        }
        return Colors.white;
    }
  }

  Color _getOutlinedPressedTextColor(ThemeProvider themeProvider) {
    if (widget.variant == VisaButtonVariant.primary) {
      return (themeProvider.isDarkMode
              ? VisaColors.darkPrimary
              : VisaColors.primary)
          .withValues(alpha: 0.7);
    }
    return (themeProvider.isDarkMode
            ? VisaColors.darkSecondary
            : VisaColors.secondaryDark)
        .withValues(alpha: 0.7);
  }

  Color _getOutlinedTextColor(ThemeProvider themeProvider) {
    switch (widget.variant) {
      case VisaButtonVariant.primary:
        return themeProvider.isDarkMode
            ? VisaColors.darkPrimary
            : VisaColors.primary;
      case VisaButtonVariant.secondary:
        return themeProvider.isDarkMode
            ? VisaColors.darkSecondary
            : VisaColors.secondaryDark;
      case VisaButtonVariant.black:
        return themeProvider.isDarkMode ? VisaColors.white : VisaColors.black;
      case VisaButtonVariant.white:
        return themeProvider.isDarkMode ? VisaColors.black : VisaColors.white;
      default:
        return VisaColors.primary;
    }
  }

  Color _getDefaultTextColor(ThemeProvider themeProvider) {
    switch (widget.variant) {
      case VisaButtonVariant.primary:
        return Colors.white;
      case VisaButtonVariant.black:
        return VisaColors.white;
      case VisaButtonVariant.white:
        return VisaColors.black;
      case VisaButtonVariant.custom:
        return widget.buttonTextColor!;
      default:
        return themeProvider.isDarkMode ? Colors.black : VisaColors.primaryDark;
    }
  }

  Color _getIconColor(ThemeProvider themeProvider) {
    return _getTextColor(themeProvider);
  }

  Widget _buildIcon(ThemeProvider themeProvider) {
    if (widget.iconPosition == IconButtonPosition.none || widget.icon == null) {
      return Container();
    }

    return Icon(
      widget.icon,
      size: widget.iconSize?.r,
      color: _getIconColor(themeProvider),
    );
  }

  Widget _buildContent(ThemeProvider themeProvider) {
    final textWidget = VisaTextView(
      text: widget.text,
      semantics: false,
      customColor: _getTextColor(themeProvider),
      colorTheme: VisaTextTheme.customTextColor,
      fontSize: widget.fontSize?.sp ?? 18.sp,
      fontFamily: _isPressed ? VisaFontWeight.bold : widget.fontWeight,
      letterSpacing: widget.letterSpacing,
    );
    if (widget.iconPosition == IconButtonPosition.none) {
      return Padding(
        padding: widget.contentPadding ?? EdgeInsets.zero,
        child: textWidget,
      );
    }

    return Padding(
      padding: widget.contentPadding ?? EdgeInsets.zero,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: (widget.iconPosition == IconButtonPosition.none ||
                widget.icon == null)
            ? [
                textWidget,
              ]
            : widget.iconPosition == IconButtonPosition.left
                ? [
                    _buildIcon(themeProvider),
                    VisaSizeBox(width: 8.w),
                    textWidget,
                  ]
                : [
                    textWidget,
                    VisaSizeBox(width: 8.w),
                    _buildIcon(themeProvider),
                  ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        final showSemantics = widget.semantics == true;
        final buttonContent = _buildButtonContent(themeProvider);

        return Padding(
          padding: widget.padding ?? EdgeInsets.zero,
          child: showSemantics
              ? Semantics(
                  button: false,
                  sortKey: widget.semanticsIndex != null
                      ? OrdinalSortKey(widget.semanticsIndex!.toDouble())
                      : null,
                  enabled: true,
                  hidden: false,
                  excludeSemantics: true,
                  container: true,
                  // keep semantics
                  label: "${widget.text}"
                      "${widget.isDisable == true ? ', ${S.of(context).button}, ${S.of(context).disable}, ${S.of(context).disabled_button_text_field_label}' : ', ${S.of(context).double_tap_to_activate}'}",
                  child: buttonContent,
                )
              : ExcludeSemantics(child: buttonContent),
        );
      },
    );
  }

  Widget _buildButtonContent(ThemeProvider themeProvider) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(Sizes.sixteen),
      child: InkWell(
        onTap: _handlePress,
        onTapDown: _handleTapDown,
        onTapUp: _handleTapUp,
        onTapCancel: _handleTapCancel,
        borderRadius: BorderRadius.circular(Sizes.sixteen),
        splashColor: _getSplashColor(),
        child: MouseRegion(
          onEnter: (_) => setState(() => _isHovered = true),
          onExit: (_) => setState(() => _isHovered = false),
          child: _buildInkContainer(themeProvider),
        ),
      ),
    );
  }

  Future<void> _handleTapDown(TapDownDetails details) async {
    if (widget.isDisable == null || widget.isDisable) {
      Utils.logPrint("isDisable true");
    } else {
      Utils.logPrint("isDisable false");
      if (mounted) {
        setState(() {
          _isPressed = true;
        });
      }
      await Future.delayed(const Duration(milliseconds: 200));

      if (mounted) {
        setState(() {
          _isPressed = false;
        });
      }
    }
  }

  Future<void> _handleTapUp(TapUpDetails details) async {
    // await Future.delayed(const Duration(milliseconds: 200));
    // setState(() => _isPressed = false);
  }

  Future<void> _handleTapCancel() async {
    // await Future.delayed(const Duration(milliseconds: 200));
    // setState(() => _isPressed = false);
  }

  Color _getSplashColor() {
    if (widget.isDisable == null || widget.isDisable) {
      return Colors.transparent;
    }

    if (widget.isOutlined) {
      return _getOutlinedSplashColor();
    }

    return _getFilledSplashColor();
  }

  Color _getOutlinedSplashColor() {
    if (widget.variant == VisaButtonVariant.white) {
      return Colors.white54;
    }
    return Theme.of(context).colorScheme.primary;
  }

  Color _getFilledSplashColor() {
    if (widget.variant == VisaButtonVariant.white) {
      return Theme.of(context).colorScheme.secondary;
    }
    if (widget.variant == VisaButtonVariant.primary) {
      return Colors.black;
    }
    return Colors.white54;
  }

  Widget _buildInkContainer(ThemeProvider themeProvider) {
    return Ink(
      width: widget.width?.w,
      height: widget.height!.h,
      decoration: BoxDecoration(
        color: _getBackgroundColor(themeProvider),
        borderRadius: BorderRadius.circular(Sizes.sixteen),
        border: Border.all(
          color: _getBorderColor(themeProvider),
          width: widget.isOutlined ? 1.w : 0,
        ),
      ),
      child: Center(
        child: _buildContent(themeProvider),
      ),
    );
  }

  Future<void> _handlePress() async {
    if (!widget.ignoreDoubleClick && !_canClick) return;

    setState(() {
      _lastClickTime = DateTime.now();
    });

    if (widget.addDefaultAnalyticsEvent) {
      SelectLanguageGenericProvider localLanguageProvider =
          Provider.of<SelectLanguageGenericProvider>(context, listen: false);

      FirebaseAnalyticsService.logEventButtonClick(
          btnName: localLanguageProvider.getKeyFromValue(widget.text) ?? "",
      parameters: widget.options ?? {}
      );
    }

    try {
      Utils.hideKeyboard(context);
      await widget.onPressed!();
    } finally {}

    //setAnalytics
  }
}
