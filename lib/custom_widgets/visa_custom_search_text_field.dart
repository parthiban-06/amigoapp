import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:visaamigo/core/theme/theme.dart';
import 'package:visaamigo/custom_widgets/upper_case_formatter.dart';
import 'package:visaamigo/utils/const_screen_size.dart' show AppSizes;
import 'package:visaamigo/utils/utils.dart';

// ignore: must_be_immutable
class VisaCustomSearchTextField extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode? focusNode;
  final VoidCallback? onTap;
  final ValueChanged<String>? onChanged;
  final String? hintText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool filled;
  final Color? fillColor;
  final InputBorder? border;
  final TextStyle? textStyle;
  final TextStyle? hintStyle;
  final TextStyle? labelStyle;
  final EdgeInsetsGeometry? contentPadding;
  final EdgeInsetsGeometry? prefixIconPadding;
  final EdgeInsetsGeometry? suffixIconPadding;
  final bool isUpperCase;
  final bool semantics;
  final int? semanticsIndex;
  final int? labelSemanticsIndex;
  final String? semanticsLabel;
  final ValueChanged<String>? onSubmitted;

  VisaCustomSearchTextField({
    super.key,
    required this.controller,
    this.focusNode,
    this.onTap,
    this.onChanged,
    this.hintText,
    this.prefixIcon,
    this.suffixIcon,
    this.filled = false,
    this.fillColor,
    this.border,
    this.textStyle,
    this.hintStyle,
    this.labelStyle,
    this.contentPadding,
    this.isUpperCase = false,
    this.prefixIconPadding,
    this.suffixIconPadding,
    this.semantics = true,
    this.semanticsIndex,
    this.labelSemanticsIndex,
    this.semanticsLabel,
    this.onSubmitted,
  });

  late double width;
  late double fontTwelve;

  @override
  Widget build(BuildContext context) {
    width = AppSizes.iconXXSmall;
    fontTwelve = AppSizes.fontTwelve;
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(
        textScaler: TextScaler.linear(Utils.getCappedScale(
            context, fontTwelve)), // Adjust scale factor as needed
      ),
      child: semantics == true
          ? Semantics(
              sortKey: semanticsIndex != null
                  ? OrdinalSortKey(semanticsIndex!.toDouble())
                  : null,
              enabled: semantics != false,
              hidden: semantics == false,
              excludeSemantics: true,
              container: true,
              label: semanticsLabel ?? hintText,
              child: _textFiledWidget(),
            )
          : ExcludeSemantics(
              child: _textFiledWidget(),
            ),
    );
  }

  Widget _textFiledWidget() {
    return TextField(
      controller: controller,
      focusNode: focusNode,
      onTap: onTap,
      onChanged: onChanged,
      inputFormatters: isUpperCase ? [UpperCaseTextFormatter()] : [],
      onSubmitted: onSubmitted,
      style: textStyle ??
          TextStyle(
            color: VisaColors.black,
            fontWeight: FontWeight.w500,
            fontSize: fontTwelve,
            letterSpacing: 2.0,
          ),
      decoration: InputDecoration(
        hintText: hintText,
        prefixIcon: prefixIcon != null
            ? Padding(
                padding: prefixIconPadding ??
                    EdgeInsets.only(left: 0.0, right: width),
                child: prefixIcon,
              )
            : null,
        prefixIconConstraints: prefixIcon != null
            ? BoxConstraints(
                maxWidth: AppSizes.oneSeventyWidth,
                minWidth: AppSizes.thirtyWidth)
            : null,
        suffixIcon: suffixIcon != null
            ? Padding(
                padding: suffixIconPadding ??
                    EdgeInsets.only(left: width, right: 0.0),
                child: suffixIcon,
              )
            : null,
        suffixIconConstraints: const BoxConstraints(
          minWidth: 0,
          minHeight: 0,
        ),
        filled: filled,
        fillColor: fillColor,
        contentPadding: contentPadding ??
            EdgeInsets.symmetric(
              vertical: AppSizes.tweleveWidth,
              horizontal: 8.h,
            ),
        isDense: true,
        labelStyle: labelStyle ??
            TextStyle(
              color: VisaColors.black,
              fontWeight: FontWeight.w500,
              fontSize: fontTwelve,
              letterSpacing: 2.0,
            ),
        hintStyle: hintStyle ??
            TextStyle(
              color: VisaColors.black,
              fontWeight: FontWeight.w500,
              fontSize: fontTwelve,
              letterSpacing: 2.0,
            ),
        enabledBorder: border,
        focusedBorder: border,
      ),
    );
  }
}
