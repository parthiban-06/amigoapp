import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:provider/provider.dart';
import 'package:visaamigo/core/theme/theme.dart';
import 'package:visaamigo/utils/const_screen_size.dart' show AppSizes;

import '../generated/l10n.dart';
import '../ui/provider/theme_provider.dart';

enum VisaCheckboxVariant { primary, secondary, grey, white }

class VisaCheckbox extends StatefulWidget {
  final bool? value;
  final bool? isPadding;
  final ValueChanged<bool?>? onChanged;
  final bool tristate;
  final String? label;
  final VisaCheckboxVariant variant;
  final bool semantics;
  final int? semanticsIndex;
  final String? semanticsLabel;

  const VisaCheckbox({
    super.key,
    required this.value,
    this.onChanged,
    this.tristate = false,
    this.label,
    this.variant = VisaCheckboxVariant.primary,
    this.isPadding,
    this.semantics = true,
    this.semanticsIndex,
    this.semanticsLabel,
  });

  @override
  State<VisaCheckbox> createState() => _VisaCheckboxState();
}

class _VisaCheckboxState extends State<VisaCheckbox> {
  bool isHovered = false;
  bool isFocused = false;

  Color _getActiveColor(ThemeProvider themeProvider) {
    // Handle specific variants first
    if (widget.variant == VisaCheckboxVariant.grey) {
      return VisaColors.textFieldBorder;
    }

    if (widget.variant == VisaCheckboxVariant.white) {
      return VisaColors.primary;
    }

    // Handle disabled state
    if (widget.onChanged == null) {
      return _getDisabledActiveColor(themeProvider);
    }

    // Handle hover state
    if (isHovered) {
      return _getHoveredActiveColor(themeProvider);
    }

    // Handle default state
    return _getDefaultActiveColor(themeProvider);
  }

  Color _getDisabledActiveColor(ThemeProvider themeProvider) {
    if (widget.variant == VisaCheckboxVariant.primary) {
      return themeProvider.isDarkMode
          ? VisaColors.darkPrimary.withValues(alpha: 128)
          : VisaColors.primary;
    }
    return themeProvider.isDarkMode
        ? VisaColors.darkSecondary.withValues(alpha: 128)
        : VisaColors.secondary.withValues(alpha: 128);
  }

  Color _getHoveredActiveColor(ThemeProvider themeProvider) {
    if (widget.variant == VisaCheckboxVariant.primary) {
      return themeProvider.isDarkMode
          ? VisaColors.darkPrimaryLight
          : VisaColors.primaryLight;
    }
    return themeProvider.isDarkMode
        ? VisaColors.darkSecondaryLight
        : VisaColors.secondaryLight;
  }

  Color _getDefaultActiveColor(ThemeProvider themeProvider) {
    if (widget.variant == VisaCheckboxVariant.primary) {
      return themeProvider.isDarkMode
          ? VisaColors.darkPrimary
          : VisaColors.primary;
    }
    return themeProvider.isDarkMode
        ? VisaColors.darkSecondary
        : VisaColors.secondary;
  }

  Color _getStrokeColor(ThemeProvider themeProvider) {
    if (widget.onChanged == null) {
      return themeProvider.isDarkMode
          ? Colors.white.withValues(alpha: 0.3)
          : Colors.black.withValues(alpha: 0.3);
    }
    if (widget.variant == VisaCheckboxVariant.white) {
      return VisaColors.primary;
    }
    if (widget.value == true || widget.value == null) {
      return Colors.transparent;
    }
    if (isHovered) {
      return themeProvider.isDarkMode
          ? Colors.white.withValues(alpha: 0.7)
          : Colors.black.withValues(alpha: 0.4);
    }
    return themeProvider.isDarkMode
        ? Colors.white.withValues(alpha: 128)
        : Colors.black.withValues(alpha: 0.2);
  }

  Color _getCheckColor(ThemeProvider themeProvider) {
    if (widget.variant == VisaCheckboxVariant.primary) {
      return Colors.white;
    }
    if (widget.variant == VisaCheckboxVariant.grey) {
      return VisaColors.white;
    }
    if (widget.variant == VisaCheckboxVariant.white) {
      return VisaColors.white;
    }
    return themeProvider.isDarkMode ? Colors.black : VisaColors.primaryDark;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        final checkboxContent = _buildCheckboxContent(themeProvider);

        if (!widget.semantics) {
          return ExcludeSemantics(child: checkboxContent);
        }

        return _buildSemanticsWrapper(checkboxContent);
      },
    );
  }

  Widget _buildCheckboxContent(ThemeProvider themeProvider) {
    return MouseRegion(
      onEnter: (_) => setState(() => isHovered = true),
      onExit: (_) => setState(() => isHovered = false),
      child: Focus(
        onFocusChange: (focused) => setState(() => isFocused = focused),
        child: GestureDetector(
          onTap: _handleTap,
          child: Container(
            height: 40,
            padding: EdgeInsets.symmetric(
                horizontal: (widget.isPadding ?? true) ? 8 : 0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildCheckboxIcon(themeProvider),
                if (widget.label != null) ...[
                  const SizedBox(width: 8),
                  _buildLabel(themeProvider),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _handleTap() {
    if (widget.onChanged == null) return;

    if (widget.tristate) {
      _handleTristateTap();
    } else {
      widget.onChanged!(!widget.value!);
    }
  }

  void _handleTristateTap() {
    if (widget.value == null) {
      widget.onChanged!(true);
    } else if (widget.value == true) {
      widget.onChanged!(false);
    } else {
      widget.onChanged!(null);
    }
  }

  Widget _buildCheckboxIcon(ThemeProvider themeProvider) {
    return Stack(
      children: [
        _buildCheckboxContainer(themeProvider),
        if (isFocused) _buildFocusIndicator(themeProvider),
      ],
    );
  }

  Widget _buildCheckboxContainer(ThemeProvider themeProvider) {
    return Container(
      width: 20,
      height: 20,
      decoration: BoxDecoration(
        color: _getCheckboxBackgroundColor(themeProvider),
        border: Border.all(
          color: _getStrokeColor(themeProvider),
          width: _getBorderWidth(),
        ),
        borderRadius: BorderRadius.circular(4),
      ),
      child: _buildCheckboxInnerContent(themeProvider),
    );
  }

  Color _getCheckboxBackgroundColor(ThemeProvider themeProvider) {
    if (widget.value == true || widget.value == null) {
      return _getActiveColor(themeProvider);
    }
    if (widget.variant == VisaCheckboxVariant.white) {
      return VisaColors.chatHistorySelectionColor;
    }
    return Colors.transparent;
  }

  double _getBorderWidth() {
    return widget.variant == VisaCheckboxVariant.white ? 1 : 2;
  }

  Widget? _buildCheckboxInnerContent(ThemeProvider themeProvider) {
    if (widget.value == true) {
      return Icon(
        Icons.check,
        size: 16,
        color: _getCheckColor(themeProvider),
      );
    }
    if (widget.value == null) {
      return Container(
        margin: const EdgeInsets.all(4),
        color: _getCheckColor(themeProvider),
      );
    }
    return null;
  }

  Widget _buildFocusIndicator(ThemeProvider themeProvider) {
    return Container(
      width: 20,
      height: 20,
      decoration: BoxDecoration(
        border: Border.all(
          color: _getFocusBorderColor(themeProvider),
          width: 2,
          style: BorderStyle.solid,
        ),
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }

  Color _getFocusBorderColor(ThemeProvider themeProvider) {
    return themeProvider.isDarkMode ? Colors.white : VisaColors.primaryDark;
  }

  Widget _buildLabel(ThemeProvider themeProvider) {
    return Text(
      widget.label!,
      style: TextStyle(
        color: _getLabelColor(themeProvider),
        fontSize: AppSizes.fontfourteen,
      ),
    );
  }

  Color _getLabelColor(ThemeProvider themeProvider) {
    if (widget.onChanged == null) {
      return themeProvider.isDarkMode
          ? Colors.white.withValues(alpha: 128)
          : Colors.black.withValues(alpha: 128);
    }
    return themeProvider.isDarkMode ? Colors.white : Colors.black;
  }

  Widget _buildSemanticsWrapper(Widget checkboxContent) {
    return Semantics(
      container: true,
      checked: widget.value == true,
      inMutuallyExclusiveGroup: false,
      label: _getSemanticsLabel(),
      enabled: true,
      sortKey: _getSemanticsSortKey(),
      child: checkboxContent,
    );
  }

  String _getSemanticsLabel() {
    final baseLabel = widget.semanticsLabel ?? S.of(context).checkbox;
    final status =
        widget.value == true ? S.of(context).checked : S.of(context).unchecked;
    return "$baseLabel, $status";
  }

  OrdinalSortKey? _getSemanticsSortKey() {
    return widget.semanticsIndex != null
        ? OrdinalSortKey(widget.semanticsIndex!.toDouble())
        : null;
  }
}
