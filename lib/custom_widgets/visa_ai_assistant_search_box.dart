import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:visaamigo/generated/assets.dart';
import 'package:visaamigo/utils/const_screen_size.dart' show AppSizes;
import 'package:visaamigo/utils/lanuage_watch_extention.dart';
import 'package:visaamigo/utils/utils.dart';

import '../../core/theme/theme.dart';
import '../generated/l10n.dart';
import '../ui/provider/theme_provider.dart';
import '../utils/app_const.dart';

enum VisaSearchVariant {
  primary,
  secondary,
}

class VisaAiAssistantSearchBox extends StatefulWidget {
  final String? initialValue;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onClear;
  final VoidCallback? onSearch;
  final VoidCallback? onTap;
  final String hintText;
  final bool autofocus;
  final bool? isEanble;
  final bool isEdit;
  final int? maxLines;
  final int? maxLength;
  final VisaSearchVariant variant;
  final TextEditingController? controller;

  const VisaAiAssistantSearchBox({
    super.key,
    this.initialValue,
    this.onChanged,
    this.onClear,
    this.onSearch,
    this.onTap,
    this.isEanble = true,
    this.isEdit = false,
    this.hintText = '',
    this.maxLines = 1,
    this.maxLength = AppConst.TEXTFIELD_EMAIL_LENGTH,
    this.autofocus = false,
    this.variant = VisaSearchVariant.primary,
    this.controller,
  });

  @override
  State<VisaAiAssistantSearchBox> createState() => _VisaSearchBoxState();
}

class _VisaSearchBoxState extends State<VisaAiAssistantSearchBox> {
  late TextEditingController _controller;
  bool _isHovered = false;
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _controller =
        widget.controller ?? TextEditingController(text: widget.initialValue);
    _controller.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _controller.dispose();
    }
    super.dispose();
  }

  void _onTextChanged() {
    widget.onChanged?.call(_controller.text);
  }

  void _clearSearch() {
    _controller.clear();
    widget.onClear?.call();
  }

  Color _getIconBackgroundColor(ThemeProvider themeProvider) {
    final isInteractive = _isHovered || _isFocused;

    if (themeProvider.isDarkMode) {
      return _getDarkModeColor(isInteractive);
    } else {
      return _getLightModeColor(isInteractive);
    }
  }

  Color _getDarkModeColor(bool isInteractive) {
    if (widget.variant == VisaSearchVariant.primary) {
      return isInteractive
          ? VisaColors.darkPrimaryLight
          : VisaColors.darkPrimary;
    } else {
      return isInteractive
          ? VisaColors.darkSecondaryLight
          : VisaColors.darkSecondary;
    }
  }

  Color _getLightModeColor(bool isInteractive) {
    if (widget.variant == VisaSearchVariant.primary) {
      return isInteractive ? VisaColors.primaryLight : VisaColors.primary;
    } else {
      return isInteractive ? VisaColors.secondaryLight : VisaColors.secondary;
    }
  }

  // Color _getBorderColor(ThemeProvider themeProvider) {
  //   if (_isFocused) {
  //     return themeProvider.isDarkMode
  //         ? widget.variant == VisaSearchVariant.primary
  //             ? VisaColors.darkPrimary
  //             : VisaColors.darkSecondary
  //         : widget.variant == VisaSearchVariant.primary
  //             ? VisaColors.primary
  //             : VisaColors.secondary;
  //   }
  //   return themeProvider.isDarkMode
  //       ? Colors.white.withValues(alpha: _isHovered ? 0.7 : 0.5)
  //       : Colors.black.withValues(alpha: _isHovered ? 0.3 : 0.2);
  // }

  Color _getIconColor(ThemeProvider themeProvider) {
    if (widget.variant == VisaSearchVariant.primary) {
      return Colors.white;
    }
    return themeProvider.isDarkMode ? Colors.black : VisaColors.primaryDark;
  }

  late double fontXXSmall;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    fontXXSmall = AppSizes.fontXXSmall;
  }

  @override
  Widget build(BuildContext context) {
    final isRtl = context.watchIsRTL;
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        final themeColors = _getThemeColors(themeProvider);

        return MouseRegion(
          onEnter: (_) => setState(() => _isHovered = true),
          onExit: (_) => setState(() => _isHovered = false),
          child: Focus(
            onFocusChange: (focused) => setState(() => _isFocused = focused),
            child: SizedBox(
              height: 56.h,
              child: MediaQuery(
                data: MediaQuery.of(context).copyWith(
                  textScaler:
                      TextScaler.linear(Utils.getCappedScale(context, 16.sp)),
                ),
                child: TextFormField(
                  controller: _controller,
                  autofocus: widget.autofocus,
                  cursorColor: themeColors.hintColor,
                  onTap: widget.onTap,
                  minLines: 1,
                  maxLines: widget.maxLines,
                  maxLength: widget.maxLength,
                  textCapitalization: TextCapitalization.sentences,
                  style: _getTextStyle(themeColors.textColor),
                  decoration:
                      _buildInputDecoration(themeColors, isRtl, themeProvider),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  /// Get theme colors based on current theme mode
  _ThemeColors _getThemeColors(ThemeProvider themeProvider) {
    final backgroundColor =
        themeProvider.isDarkMode ? VisaColors.darkPrimaryDark : Colors.white;

    final textColor = themeProvider.isDarkMode ? Colors.white : Colors.black;

    final hintColor = themeProvider.isDarkMode
        ? Colors.white.withValues(alpha: 128)
        : Colors.black.withValues(alpha: 128);

    return _ThemeColors(
      backgroundColor: backgroundColor,
      textColor: textColor,
      hintColor: hintColor,
    );
  }

  /// Get text style for the TextFormField
  TextStyle _getTextStyle(Color textColor) {
    return TextStyle(
      color: textColor,
      fontSize: fontXXSmall,
      fontWeight: FontWeight.w400,
      fontFamily: "VisaDialectUI",
    );
  }

  /// Build the InputDecoration for the TextFormField
  InputDecoration _buildInputDecoration(
      _ThemeColors colors, bool isRtl, ThemeProvider themeProvider) {
    return InputDecoration(
      hintText: widget.hintText,
      counterText: "",
      hintStyle: TextStyle(
        color: colors.hintColor,
        fontSize: fontXXSmall,
        fontWeight: FontWeight.w400,
        fontFamily: "VisaDialectUI",
      ),
      filled: true,
      fillColor: VisaColors.white,
      suffixIcon: _buildSuffixIcon(isRtl, themeProvider),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 24,
        vertical: 0,
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: VisaColors.primary, width: 1.25),
        borderRadius: BorderRadius.circular(100),
      ),
      border: OutlineInputBorder(
        borderSide: const BorderSide(color: VisaColors.primary),
        borderRadius: BorderRadius.circular(100),
      ),
      isDense: true,
    );
  }

  /// Build the suffix icon row
  Widget _buildSuffixIcon(bool isRtl, ThemeProvider themeProvider) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.end,
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildSearchButton(isRtl, themeProvider),
      ],
    );
  }

  /// Build the search button
  Widget _buildSearchButton(bool isRtl, ThemeProvider themeProvider) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0).r,
      child: Semantics(
        label: "${S.of(context).send}, ${S.of(context).double_tap_to_activate}",
        enabled: true,
        container: true,
        excludeSemantics: true,
        child: InkWell(
          onTap: _handleSearchTap,
          child: Container(
            width: 38.w,
            height: 38.h,
            margin: EdgeInsets.symmetric(
              vertical: 8,
              horizontal: isRtl ? 8 : 0,
            ),
            decoration: _getSearchButtonDecoration(themeProvider),
            child: Center(
              child: Padding(
                padding: EdgeInsets.only(right: 2.w, top: 2.h),
                child: SvgPicture.asset(
                  Assets.iconsIcSent,
                  width: AppSizes.dimSmall,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Handle search button tap
  void _handleSearchTap() {
    if ((widget.isEanble ?? false) && widget.onSearch != null) {
      widget.onSearch!();
    }
  }

  /// Get search button decoration
  BoxDecoration _getSearchButtonDecoration(ThemeProvider themeProvider) {
    final isEnabled = widget.isEanble ?? true;

    if (isEnabled) {
      return BoxDecoration(
        color: _getIconBackgroundColor(themeProvider),
        borderRadius: BorderRadius.all(const Radius.circular(20).r),
      );
    } else {
      return BoxDecoration(
        color: Colors.grey,
        borderRadius: BorderRadius.all(const Radius.circular(20).r),
      );
    }
  }
}

/// Helper class to hold theme colors
class _ThemeColors {
  final Color backgroundColor;
  final Color textColor;
  final Color hintColor;

  _ThemeColors({
    required this.backgroundColor,
    required this.textColor,
    required this.hintColor,
  });
}
