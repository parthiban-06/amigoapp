import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:visaamigo/core/theme/theme.dart';
import 'package:visaamigo/custom_widgets/visa_font_family.dart';
import 'package:visaamigo/custom_widgets/visa_textview.dart';
import 'package:visaamigo/features/ai_assistant/models/ai_get_preferences_questions_model.dart';
import 'package:visaamigo/utils/utils.dart';

import '../generated/l10n.dart';

class VisaCustomChipColumnWidget extends StatelessWidget {
  final List<Options> chips;
  final int parentIndex;
  final Function(int parentIndex, int chipIndex) onChipTap;
  final double spacing;
  final bool isOpacity;
  final double runSpacing;
  final double borderRadius;
  final double borderWidth;
  final double lineHeight;
  final double letterSpacing;
  final double textLineHeight;
  final EdgeInsets padding;
  final VisaTextStyle textStyle;
  final FontWeight selectedFontWeight;
  final FontWeight unselectedFontWeight;
  final double fontSize;
  final Color selectedTextColor;
  final Color unselectedTextColor;
  final Color borderColor;
  final LinearGradient? selectedGradient;

  const VisaCustomChipColumnWidget({
    super.key,
    required this.parentIndex,
    required this.chips,
    required this.onChipTap,
    this.spacing = 10.0,
    this.isOpacity = false,
    this.runSpacing = 10.0,
    this.borderRadius = 50.0,
    this.borderWidth = 1.0,
    this.lineHeight = 1.79,
    this.letterSpacing = 0.0,
    this.textLineHeight = 0.0,
    this.padding = const EdgeInsets.all(12.0),
    required this.textStyle,
    required this.selectedFontWeight,
    required this.unselectedFontWeight,
    required this.selectedTextColor,
    required this.unselectedTextColor,
    required this.borderColor,
    this.fontSize = 14,
    this.selectedGradient,
  });

  @override
  Widget build(BuildContext context) {
    _handleSingleChipSelection();
    return Wrap(
      spacing: spacing,
      children: List.generate(chips.length, (chipIndex) {
        return _buildChip(context, chipIndex);
      }),
    );
  }

  void _handleSingleChipSelection() {
    if (chips.length == 1) {
      chips[0].isSelected = true;
    }
  }

  Widget _buildChip(BuildContext context, int chipIndex) {
    final option = chips[chipIndex];
    final isSelected = option.isSelected ?? false;
    final permanentSelected = option.permanentSelected ?? false;
    final chipLabel = (option.optionName ?? "").trim();

    return Opacity(
      opacity: permanentSelected ? 0.8 : 1,
      child: Semantics(
        label: _getSemanticsLabel(context, chipLabel, isSelected),
        excludeSemantics: true,
        child: ChoiceChip(
          selected: isSelected,
          onSelected: (_) =>
              _handleChipSelection(context, permanentSelected, chipIndex),
          shape: _getChipShape(),
          backgroundColor: VisaColors.transparent,
          selectedColor: VisaColors.transparent,
          labelPadding: EdgeInsets.zero,
          showCheckmark: false,
          padding: EdgeInsets.zero,
          label: _buildChipLabel(chipLabel, isSelected),
        ),
      ),
    );
  }

  String _getSemanticsLabel(
      BuildContext context, String chipLabel, bool isSelected) {
    if (isSelected) {
      return "$chipLabel, ${S.of(context).selected}, ${S.of(context).double_tap_to_unselect}";
    } else {
      return "$chipLabel, ${S.of(context).unselected}, ${S.of(context).double_tap_to_select}";
    }
  }

  void _handleChipSelection(
      BuildContext context, bool permanentSelected, int chipIndex) {
    Utils.hideKeyboard(context);
    if (permanentSelected == false) {
      onChipTap(parentIndex, chipIndex);
    }
  }

  RoundedRectangleBorder _getChipShape() {
    return RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(borderRadius),
      side: const BorderSide(
        color: VisaColors.transparent,
        width: 0.0,
      ),
    );
  }

  Widget _buildChipLabel(String chipLabel, bool isSelected) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        gradient: isSelected ? selectedGradient : null,
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(
          width: borderWidth,
          color: isSelected ? VisaColors.transparent : borderColor,
        ),
      ),
      child: AnimatedDefaultTextStyle(
        duration: const Duration(milliseconds: 0),
        style: _getTextStyle(isSelected),
        child: Text(
          chipLabel,
          softWrap: true,
          overflow: TextOverflow.visible,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  TextStyle _getTextStyle(bool isSelected) {
    return TextStyle(
      fontWeight:
          // isSelected ? selectedFontWeight :
          unselectedFontWeight,
      color: isSelected ? selectedTextColor : unselectedTextColor,
      height: lineHeight,
      letterSpacing: letterSpacing,
      fontSize: fontSize.sp,
      fontFamily: VisaFontFamily.getFontFamily(
        VisaFontWeight.medium,
        false,
      ),
    );
  }
}
