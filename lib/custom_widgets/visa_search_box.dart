import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/theme/theme.dart';
import '../ui/provider/theme_provider.dart';

enum VisaSearchVariant {
  primary,
  secondary,
}

class VisaSearchBox extends StatefulWidget {
  final String? initialValue;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onClear;
  final VoidCallback? onSearch;
  final String hintText;
  final bool autofocus;
  final VisaSearchVariant variant;
  final TextEditingController? controller;

  const VisaSearchBox({
    super.key,
    this.initialValue,
    this.onChanged,
    this.onClear,
    this.onSearch,
    this.hintText = 'Search visa.com',
    this.autofocus = false,
    this.variant = VisaSearchVariant.primary,
    this.controller,
  });

  @override
  State<VisaSearchBox> createState() => _VisaSearchBoxState();
}

class _VisaSearchBoxState extends State<VisaSearchBox> {
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
    if (themeProvider.isDarkMode) {
      return _getDarkModeIconBackgroundColor();
    } else {
      return _getLightModeIconBackgroundColor();
    }
  }

  Color _getDarkModeIconBackgroundColor() {
    if (widget.variant == VisaSearchVariant.primary) {
      return _getDarkPrimaryIconBackgroundColor();
    } else {
      return _getDarkSecondaryIconBackgroundColor();
    }
  }

  Color _getLightModeIconBackgroundColor() {
    if (widget.variant == VisaSearchVariant.primary) {
      return _getLightPrimaryIconBackgroundColor();
    } else {
      return _getLightSecondaryIconBackgroundColor();
    }
  }

  Color _getDarkPrimaryIconBackgroundColor() {
    return _isHovered || _isFocused
        ? VisaColors.darkPrimaryLight
        : VisaColors.darkPrimary;
  }

  Color _getDarkSecondaryIconBackgroundColor() {
    return _isHovered || _isFocused
        ? VisaColors.darkSecondaryLight
        : VisaColors.darkSecondary;
  }

  Color _getLightPrimaryIconBackgroundColor() {
    return _isHovered || _isFocused
        ? VisaColors.primaryLight
        : VisaColors.primary;
  }

  Color _getLightSecondaryIconBackgroundColor() {
    return _isHovered || _isFocused
        ? VisaColors.secondaryLight
        : VisaColors.secondary;
  }

  Color _getBorderColor(ThemeProvider themeProvider) {
    if (_isFocused) {
      return themeProvider.isDarkMode
          ? widget.variant == VisaSearchVariant.primary
              ? VisaColors.darkPrimary
              : VisaColors.darkSecondary
          : widget.variant == VisaSearchVariant.primary
              ? VisaColors.primary
              : VisaColors.secondary;
    }
    return themeProvider.isDarkMode
        ? Colors.white.withValues(alpha: _isHovered ? 0.7 : 0.5)
        : Colors.black.withValues(alpha: _isHovered ? 0.3 : 0.2);
  }

  Color _getIconColor(ThemeProvider themeProvider) {
    if (widget.variant == VisaSearchVariant.primary) {
      return Colors.white;
    }
    return themeProvider.isDarkMode ? Colors.black : VisaColors.primaryDark;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        final backgroundColor = themeProvider.isDarkMode
            ? VisaColors.darkPrimaryDark
            : Colors.white;

        final textColor =
            themeProvider.isDarkMode ? Colors.white : Colors.black;

        final hintColor = themeProvider.isDarkMode
            ? Colors.white.withValues(alpha: 128)
            : Colors.black.withValues(alpha: 128);

        return MouseRegion(
          onEnter: (_) => setState(() => _isHovered = true),
          onExit: (_) => setState(() => _isHovered = false),
          child: Focus(
            onFocusChange: (focused) => setState(() => _isFocused = focused),
            child: Container(
              height: 48,
              decoration: BoxDecoration(
                color: backgroundColor,
                border: Border.all(
                  color: _getBorderColor(themeProvider),
                  width: _isFocused ? 2 : 1,
                ),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      autofocus: widget.autofocus,
                      style: TextStyle(
                        color: textColor,
                        fontSize: 16,
                      ),
                      decoration: InputDecoration(
                        hintText: widget.hintText,
                        hintStyle: TextStyle(
                          color: hintColor,
                          fontSize: 16,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        border: InputBorder.none,
                        isDense: true,
                      ),
                    ),
                  ),
                  if (_controller.text.isNotEmpty)
                    IconButton(
                      icon: Icon(
                        Icons.close,
                        size: 20,
                        color: hintColor,
                      ),
                      onPressed: _clearSearch,
                      splashRadius: 20,
                    ),
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: widget.onSearch,
                      child: Container(
                        width: 48,
                        height: double.infinity,
                        decoration: BoxDecoration(
                          color: _getIconBackgroundColor(themeProvider),
                          borderRadius: const BorderRadius.only(
                            topRight: Radius.circular(4),
                            bottomRight: Radius.circular(4),
                          ),
                        ),
                        child: Center(
                          child: Icon(
                            Icons.search,
                            color: _getIconColor(themeProvider),
                            size: 24,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
