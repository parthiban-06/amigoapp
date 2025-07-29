import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:visaamigo/core/theme/theme.dart' show VisaColors;
import 'package:visaamigo/generated/l10n.dart' show S;

import '../../../../../custom_widgets/visa_slide_up_text_view_animation.dart';
import '../../../../../custom_widgets/visa_textview.dart';
import '../../../../../utils/const_screen_size.dart';
import '../../../providers/ai_assistant_common_steps_provider.dart';
import '../../../providers/ai_assistant_main_provider.dart';

class AiBuildPageContentWidget extends StatefulWidget {
  final int pageIndex;
  final double yOffset;
  final AiAssistantCommonStepsProvider viewModel;
  final double appBarTotalHeight;

  const AiBuildPageContentWidget({
    super.key,
    required this.pageIndex,
    required this.yOffset,
    required this.viewModel,
    required this.appBarTotalHeight,
  });

  @override
  State<AiBuildPageContentWidget> createState() =>
      _AiBuildPageContentWidgetState();
}

class _AiBuildPageContentWidgetState extends State<AiBuildPageContentWidget> {
  late AiAssistantMainProvider aiAssistantProvider;
  late bool isDesktop;
  bool isKeyboardOpen = false;
  late S s;

// write build code inside didChangeDependencies
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Access the provider and initialize variables
    aiAssistantProvider =
        Provider.of<AiAssistantMainProvider>(context, listen: false);
    aiAssistantProvider.setContext(context);
    // Provider.of<AiAssistantMainProvider>(context);
    isDesktop = aiAssistantProvider.isDesktopView;
    s = S.of(context);
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardVisibilityBuilder(
      builder: (context, isKeyboardVisible) {
        isKeyboardOpen = isKeyboardOpen || isKeyboardVisible;
        if (isKeyboardVisible) {
          return const SizedBox.shrink();
        }

        return Transform.translate(
          offset: Offset(0, widget.yOffset),
          child: IgnorePointer(
            child: Center(
              child: SizedBox(
                width: isDesktop ? 650.w : null,
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 0, sigmaY: 0),
                  child: Padding(
                    padding: _getContentPadding(),
                    child: _buildContentColumn(),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  EdgeInsets _getContentPadding() {
    final hasMultiplePages = aiAssistantProvider.pages.length > 1;
    final verticalPadding = hasMultiplePages
        ? (widget.appBarTotalHeight + Sizes.seventyThree.h)
        : (widget.appBarTotalHeight + Sizes.twentyInt);

    return EdgeInsets.symmetric(
      horizontal: Sizes.sixteen,
      vertical: verticalPadding,
    );
  }

  Widget _buildContentColumn() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment:
          isDesktop ? CrossAxisAlignment.center : CrossAxisAlignment.start,
      children: [
        _buildTitleAnimation(),
        _buildTitleSpacing(),
        _buildSubtitleAnimation(),
      ],
    );
  }

  Widget _buildTitleAnimation() {
    final stepText = aiAssistantProvider.getStepText(context, widget.pageIndex);
    final semanticsLabel = _getSemanticsLabel(stepText);

    return Semantics(
      enabled: true,
      excludeSemantics: true,
      focusable: !isKeyboardOpen,
      focused: !isKeyboardOpen,
      label: semanticsLabel,
      sortKey: const OrdinalSortKey(3.0),
      child: VisaSlideUpTextViewAnimation(
        semantics: !isDesktop,
        text: stepText,
        style: VisaTextStyle.displayTitleMedium,
        customColor: _getTitleColor(),
        colorTheme: VisaTextTheme.customTextColor,
        fontFamily: VisaFontWeight.bold,
        duration: const Duration(milliseconds: 500),
        overflow: TextOverflow.visible,
        letterSpacing: AppSizes.zero,
        lineHeight: Sizes.twentySix,
        textAlign: _getTitleTextAlign(),
        isTextAnimationFinished: _onTextAnimationFinished,
      ),
    );
  }

  String _getSemanticsLabel(String stepText) {
    final isGoalOfTrip = stepText == S.of(context).goal_of_trip;
    final stepNumber = widget.pageIndex + 1;

    if (isGoalOfTrip) {
      return " ${s.step} $stepNumber${S.of(context).goal_of_the_trip}";
    }

    return "${s.step} $stepNumber$stepText";
  }

  Color _getTitleColor() {
    return isDesktop ? VisaColors.white : VisaColors.primaryDark;
  }

  TextAlign _getTitleTextAlign() {
    return isDesktop ? TextAlign.center : TextAlign.start;
  }

  void _onTextAnimationFinished(bool isFinished) {
    aiAssistantProvider.setTextAnimationFinished(isFinished);
  }

  Widget _buildTitleSpacing() {
    if (aiAssistantProvider.isTextAnimationFinished) {
      return AppSizes.xxsmallVS;
    }

    return const SizedBox.shrink();
  }

  Widget _buildSubtitleAnimation() {
    if (!aiAssistantProvider.isTextAnimationFinished) {
      return const SizedBox.shrink();
    }

    return VisaSlideUpTextViewAnimation(
      text: _getSubtitleText(),
      style: VisaTextStyle.displayBodyS,
      customColor: _getTitleColor(),
      colorTheme: VisaTextTheme.customTextColor,
      fontFamily: VisaFontWeight.regular,
      overflow: TextOverflow.visible,
      letterSpacing: AppSizes.zero,
      lineHeight: AppSizes.eightteenRadius,
      semanticsIndex: 4,
    );
  }

  String _getSubtitleText() {
    final bottomText =
        aiAssistantProvider.getStepTextBottom(context, widget.pageIndex);

    if (isDesktop && bottomText == s.tap_or_drag_make_selection) {
      return s.click_or_drag_make_selection;
    }

    return bottomText;
  }
}
