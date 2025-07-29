import 'package:flutter/material.dart';
import 'package:visaamigo/core/theme/theme.dart';
import 'package:visaamigo/custom_widgets/visa_font_family.dart';
import 'package:visaamigo/custom_widgets/visa_textview.dart';
import 'package:visaamigo/features/ai_assistant/models/ai_get_preferences_questions_model.dart';

import '../features/ai_assistant/screens/ai_assistant_getting_to_know_user_screens/widgets/ai_assistant_animated_text.dart';
import '../utils/utils.dart';

class VisaCustomChipWrapWidget extends StatelessWidget {
  final List<Options> chips;
  final int parentIndex;
  final Function(int parentIndex, int chipIndex) onChipTap;
  final double spacing;
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
  final bool? showAnimation;
  final int? animationDuration;

  const VisaCustomChipWrapWidget({
    super.key,
    required this.parentIndex,
    required this.chips,
    required this.onChipTap,
    this.spacing = 10.0,
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
    this.showAnimation,
    this.animationDuration,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: spacing,
      runSpacing: runSpacing,
      children: List.generate(chips.length, (chipIndex) {
        final option = chips[chipIndex];
        final isSelected = option.isSelected ?? false;
        final displayText = Utils.getErrorMessageFromString(option.optionId!);
        return VisaAnimatedText(
          showAnimation:
              showAnimation != null && showAnimation == true ? true : false,
          // begin: 0,
          delay: Duration(
              milliseconds: (50 * chipIndex) + (animationDuration ?? 0)),
          child: ChoiceChip(
            selected: isSelected,
            onSelected: (_) => onChipTap(parentIndex, chipIndex),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(borderRadius),
              side: const BorderSide(
                color: VisaColors.transparent,
                width: 0.0,
              ),
            ),
            backgroundColor: VisaColors.transparent,
            selectedColor: VisaColors.transparent,
            labelPadding: EdgeInsets.zero,
            showCheckmark: false,
            padding: EdgeInsets.zero,
            label: Container(
              padding: padding,
              decoration: ShapeDecoration(
                gradient: isSelected ? selectedGradient : null,
                shape: RoundedRectangleBorder(
                  side: BorderSide(
                    width: borderWidth,
                    color: isSelected ? VisaColors.transparent : borderColor,
                  ),
                  borderRadius: BorderRadius.circular(borderRadius),
                ),
              ),
              child: AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 0),
                style: TextStyle(
                  fontFamily: VisaFontFamily.getFontFamily(
                      VisaFontWeight.medium, false),
                  fontWeight:
                      isSelected ? selectedFontWeight : unselectedFontWeight,
                  color: isSelected ? selectedTextColor : unselectedTextColor,
                  height: lineHeight,
                  letterSpacing: letterSpacing,
                  fontSize: fontSize,
                ),
                child: Text(
                  displayText,
                  style: TextStyle(
                    fontFamily: VisaFontFamily.getFontFamily(
                        VisaFontWeight.medium, false),
                  ),
                  textScaler: TextScaler.linear(
                      Utils.getCappedScale(context, fontSize)),
                  softWrap: true,
                  overflow: TextOverflow.visible,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}
