import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:visaamigo/custom_widgets/visa_button.dart';
import 'package:visaamigo/custom_widgets/visa_textview.dart';
import 'package:visaamigo/utils/app_extensions.dart';
import 'package:visaamigo/utils/const_screen_size.dart' show AppSizes;
import 'package:visaamigo/utils/responsive_util.dart';

class CustomTwoButtons extends StatelessWidget {
  final String leftButtonText;
  final String rightButtonText;
  final VoidCallback onLeftButtonPressed;
  final VoidCallback onRightButtonPressed;
  final bool isRightButtonLoading;
  final bool isLeftButtonLoading;
  final bool rightButtonDisable;
  final bool isButtonPrimary;
  final bool ignoreDoubleClick;
  final bool addButtonTopPadding;
  final bool semantics;
  final int? semanticsIndex;
  final double width;

  const CustomTwoButtons({
    super.key,
    required this.leftButtonText,
    required this.rightButtonText,
    required this.onLeftButtonPressed,
    required this.onRightButtonPressed,
    this.isRightButtonLoading = false,
    this.isLeftButtonLoading = false,
    this.rightButtonDisable = true,
    this.isButtonPrimary = true,
    this.ignoreDoubleClick = false,
    this.addButtonTopPadding = true,
    this.semantics = true,
    this.semanticsIndex,
    this.width = 0,
  });

  /// Get the button variant based on isButtonPrimary flag
  VisaButtonVariant get _buttonVariant {
    return isButtonPrimary
        ? VisaButtonVariant.primary
        : VisaButtonVariant.secondary;
  }

  /// Get the left button width based on screen size
  double _getLeftButtonWidth(BuildContext context) {
    final isDesktop =
        Provider.of<ResponsiveUtil>(context).isDesktop(context: context);
    return isDesktop ? context.screenWidth * 0.075 : context.screenWidth * 0.25;
  }

  /// Get the right button width based on screen size
  double _getRightButtonWidth(BuildContext context) {
    final isDesktop =
        Provider.of<ResponsiveUtil>(context).isDesktop(context: context);
    return isDesktop ? context.screenWidth * 0.15 : context.screenWidth * 0.65;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
          top: addButtonTopPadding ? AppSizes.heightXSmall : AppSizes.zero),
      child: MediaQuery.of(context).textScaler.scale(1) > 1.25
          ? Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                VisaButton(
                  text: leftButtonText,
                  semantics: semantics,
                  semanticsIndex: semanticsIndex,
                  onPressed: onLeftButtonPressed,
                  isLoading: isLeftButtonLoading,
                  variant: _buttonVariant,
                  isOutlined: true,
                  width: context.screenWidth,
                  // height: 54,
                  // fontSize: 18,
                  letterSpacing: 0,
                  fontWeight: VisaFontWeight.medium,
                  ignoreDoubleClick: ignoreDoubleClick,
                ),
                SizedBox(
                  height: AppSizes.dimSmall,
                ),
                VisaButton(
                  text: rightButtonText,
                  semantics: semantics,
                  semanticsIndex: semanticsIndex,
                  onPressed: onRightButtonPressed,
                  width: context.screenWidth,
                  isLoading: isRightButtonLoading,
                  variant: _buttonVariant,
                  // height: 54,
                  // fontSize: 18,
                  letterSpacing: 0,
                  fontWeight: VisaFontWeight.medium,
                  isDisable: rightButtonDisable,
                  ignoreDoubleClick: ignoreDoubleClick,
                ),
              ],
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                VisaButton(
                  text: leftButtonText,
                  semantics: semantics,
                  semanticsIndex: semanticsIndex,
                  onPressed: onLeftButtonPressed,
                  isLoading: isLeftButtonLoading,
                  width: width != 0 ? width : _getLeftButtonWidth(context),
                  variant: _buttonVariant,
                  isOutlined: true,
                  // height: 54,
                  // fontSize: 18,
                  letterSpacing: 0,
                  fontWeight: VisaFontWeight.medium,
                  ignoreDoubleClick: ignoreDoubleClick,
                ),
                SizedBox(
                  width: AppSizes.dimSmall,
                ),
                Expanded(
                  child: VisaButton(
                    semantics: semantics,
                    semanticsIndex: semanticsIndex,
                    text: rightButtonText,
                    onPressed: onRightButtonPressed,
                    width: _getRightButtonWidth(context),
                    isLoading: isRightButtonLoading,
                    variant: _buttonVariant,
                    // height: 54,
                    // fontSize: 18,
                    letterSpacing: 0,
                    fontWeight: VisaFontWeight.medium,
                    isDisable: rightButtonDisable,
                    ignoreDoubleClick: ignoreDoubleClick,
                  ),
                ),
              ],
            ),
    );
  }
}
