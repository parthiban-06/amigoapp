import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:visaamigo/custom_widgets/upper_case_formatter.dart';
import 'package:visaamigo/custom_widgets/visa_font_family.dart';
import 'package:visaamigo/custom_widgets/visa_textview.dart';
import 'package:visaamigo/utils/utils.dart';

import '../../core/theme/theme.dart';
import '../ui/provider/theme_provider.dart';
import '../utils/app_const.dart';

enum VisaEditTextFieldVariant {
  primary,
  secondary,
}

class VisaEditChatTextField extends StatefulWidget {
  final String? label;
  final TextStyle? labelStyle;
  final Widget? suffixIcon;
  final String? hint;
  final double? vPadding;
  final double? hPadding;
  final double? hPaddingInside;
  final double? fontSize;
  final double? letterSpacing;
  final String? value;
  final ValueChanged<String>? onChanged;
  final bool isPassword;
  final bool isBiometrics;
  final bool isValid;
  final bool? disableError;
  final Widget? prefixIcon;
  final bool? underlineInputBorder;
  final bool? borderTransparent;
  final bool isRequired;
  final String? errorText;
  final VisaEditTextFieldVariant variant;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final TextInputAction? textInputAction;
  final VoidCallback? onEditingComplete;
  final VoidCallback? onBiometricCall;
  final ValueChanged<String>? onSubmitted;
  final ValueChanged<bool>? onTap;
  final bool showSuccessIcon;
  final bool showErrorIcon;
  final bool isEnable;
  final bool isUpperCase;
  final TextCapitalization textCapitalization;
  final TextInputType? textInputType;
  final int? maxLength;
  final FontWeight fontWeight;
  final EdgeInsetsGeometry? contentPadding;
  final bool useCustomObscureCharacter;
  final bool filled;
  final Color fillColor;
  final int? maxLines;

  const VisaEditChatTextField({
    super.key,
    this.label,
    this.hint,
    this.value,
    this.onChanged,
    this.isPassword = false,
    this.isBiometrics = false,
    this.isRequired = true, // to add * mark
    this.isUpperCase = false,
    this.textCapitalization = TextCapitalization.none, // to add * mark
    this.errorText,
    this.underlineInputBorder,
    this.variant = VisaEditTextFieldVariant.primary,
    this.controller,
    this.focusNode,
    this.textInputAction,
    this.onEditingComplete,
    this.onBiometricCall,
    this.onSubmitted,
    required this.isValid,
    this.vPadding = 0.0,
    this.maxLength = AppConst.TEXTFIELD_DEFAULT_LENGTH,
    this.hPadding = 0.0,
    this.labelStyle,
    this.suffixIcon,
    this.showSuccessIcon = false,
    this.showErrorIcon = false,
    this.isEnable = true,
    this.disableError = true,
    this.textInputType,
    this.prefixIcon,
    this.onTap,
    this.fontSize,
    this.letterSpacing,
    this.borderTransparent,
    this.contentPadding = EdgeInsets.zero,
    this.fontWeight = FontWeight.w400,
    this.useCustomObscureCharacter = false,
    this.hPaddingInside = 0.0,
    this.filled = true,
    this.fillColor = Colors.transparent,
    this.maxLines = 1,
  });

  @override
  State<VisaEditChatTextField> createState() => _VisaEditChatTextFieldState();
}

class _VisaEditChatTextFieldState extends State<VisaEditChatTextField> {
  late TextEditingController _controller;
  bool isHovered = false;
  bool isFocused = false;
  bool isObscured = true;

  @override
  void initState() {
    super.initState();
    _controller =
        widget.controller ?? TextEditingController(text: widget.value);
    if (widget.focusNode != null) {
      widget.focusNode!.addListener(_handleFocusChange);
    }
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _controller.dispose();
    }
    if (widget.focusNode != null) {
      widget.focusNode!.removeListener(_handleFocusChange);
    }
    super.dispose();
  }

  void _handleFocusChange() {
    setState(() {
      isFocused = widget.focusNode?.hasFocus ?? false;
    });
  }

  Color _getBorderColor(bool isDarkMode) {
    if (_isBorderTransparent()) {
      return Colors.transparent;
    }
    if (_isOnChangedNull()) {
      return _getDisabledBorderColor(isDarkMode);
    }
    if (_isUnderlineBorder()) {
      return _getUnderlineBorderColor(isDarkMode);
    }
    if (isFocused) {
      return _getFocusedBorderColor(isDarkMode);
    }
    if (isHovered) {
      return _getHoveredBorderColor(isDarkMode);
    }
    return _getDefaultBorderColor(isDarkMode);
  }

  bool _isBorderTransparent() {
    return widget.borderTransparent != null && widget.borderTransparent == true;
  }

  bool _isOnChangedNull() {
    return widget.onChanged == null;
  }

  bool _isUnderlineBorder() {
    return widget.underlineInputBorder != null &&
        widget.underlineInputBorder == true;
  }

  Color _getDisabledBorderColor(bool isDarkMode) {
    return isDarkMode
        ? Colors.white.withOpacity(0.3)
        : Colors.black.withOpacity(0.3);
  }

  Color _getUnderlineBorderColor(bool isDarkMode) {
    return isDarkMode ? Colors.white.withOpacity(0.7) : Colors.black;
  }

  Color _getFocusedBorderColor(bool isDarkMode) {
    if (isDarkMode) {
      return widget.variant == VisaEditTextFieldVariant.primary
          ? VisaColors.darkPrimary
          : VisaColors.darkSecondary;
    }
    return widget.variant == VisaEditTextFieldVariant.primary
        ? VisaColors.primary
        : VisaColors.secondary;
  }

  Color _getHoveredBorderColor(bool isDarkMode) {
    return isDarkMode
        ? Colors.white.withOpacity(0.7)
        : VisaColors.textFieldBorder;
  }

  Color _getDefaultBorderColor(bool isDarkMode) {
    return isDarkMode
        ? Colors.white.withValues(alpha: 128)
        : VisaColors.textFieldBorder;
  }

  bool errorIcon = false;

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(builder: (context, themeProvider, child) {
      return Padding(
        padding: _getPadding(),
        child: MouseRegion(
          onEnter: (_) => setState(() => isHovered = true),
          onExit: (_) => setState(() => isHovered = false),
          child: SizedBox(
            height: _getSizedBoxHeight(),
            child: MediaQuery(
              data: _getMediaQueryData(context),
              child: _buildTextFormField(themeProvider),
            ),
          ),
        ),
      );
    });
  }

  EdgeInsetsGeometry _getPadding() {
    return EdgeInsets.symmetric(
        horizontal: widget.hPadding!, vertical: widget.vPadding!);
  }

  double? _getSizedBoxHeight() {
    return _isUnderlineBorder() ? 0.h : null;
  }

  MediaQueryData _getMediaQueryData(BuildContext context) {
    return MediaQuery.of(context).copyWith(
      textScaler: TextScaler.linear(
          Utils.getCappedScale(context, widget.fontSize?.sp ?? 16.sp)),
    );
  }

  TextFormField _buildTextFormField(ThemeProvider themeProvider) {
    return TextFormField(
      keyboardType: widget.textInputType ?? TextInputType.text,
      minLines: 1,
      maxLength: widget.maxLength ?? AppConst.TEXTFIELD_DEFAULT_LENGTH,
      maxLines: widget.maxLines,
      controller: _controller,
      focusNode: widget.focusNode,
      obscuringCharacter: _getObscuringCharacter(),
      onChanged: _handleOnChanged,
      cursorErrorColor: VisaColors.primary,
      cursorColor: VisaColors.primary,
      obscureText: widget.isPassword && isObscured,
      textCapitalization: widget.textCapitalization,
      inputFormatters: _getInputFormatters(),
      enabled: widget.isEnable,
      style: _getTextStyle(themeProvider),
      onTap: _handleOnTap,
      onTapOutside: _handleOnTapOutside,
      decoration: _getInputDecoration(themeProvider),
      textInputAction: widget.textInputAction,
      onEditingComplete: widget.onEditingComplete,
      validator: _getValidator,
      onFieldSubmitted: widget.onSubmitted,
    );
  }

  String _getObscuringCharacter() {
    return widget.useCustomObscureCharacter ? 'X' : '•';
  }

  void _handleOnChanged(String value) {
    setState(() {
      errorIcon = false;
    });
    widget.onChanged?.call(value);
  }

  List<TextInputFormatter> _getInputFormatters() {
    return widget.isUpperCase ? [UpperCaseTextFormatter()] : [];
  }

  TextStyle _getTextStyle(ThemeProvider themeProvider) {
    return TextStyle(
      color: _getTextColor(themeProvider),
      fontSize: widget.fontSize?.sp ?? 16.sp,
      fontFamily: VisaFontFamily.getFontFamily(VisaFontWeight.regular, false),
      letterSpacing: widget.letterSpacing?.sp ?? 1.sp,
      fontWeight: widget.fontWeight,
      height: (17 / 16).toDouble(),
    );
  }

  Color _getTextColor(ThemeProvider themeProvider) {
    if (themeProvider.isDarkMode) {
      return Colors.white;
    }
    return Colors.black;
  }

  void _handleOnTap() {
    widget.onTap?.call(true);
  }

  void _handleOnTapOutside(PointerDownEvent event) {
    widget.onTap?.call(false);
  }

  InputDecoration _getInputDecoration(ThemeProvider themeProvider) {
    return InputDecoration(
      filled: widget.filled,
      counterText: "",
      hintText: widget.hint,
      fillColor: _getFillColor(),
      enabledBorder: _createBorder(themeProvider.isDarkMode),
      focusedBorder: _createBorder(themeProvider.isDarkMode),
      errorBorder: _createErrorBorder(themeProvider.isDarkMode),
      focusedErrorBorder: _createErrorBorder(themeProvider.isDarkMode),
      border: _createBorder(themeProvider.isDarkMode),
      contentPadding: _getContentPadding(),
      isDense: true,
    );
  }

  Color _getFillColor() {
    return widget.filled ? widget.fillColor : Colors.transparent;
  }

  InputBorder _createBorder(bool isDarkMode) {
    final borderColor = _getBorderColor(isDarkMode);
    final borderSide = BorderSide(color: borderColor, width: 0.h);

    if (_isUnderlineBorder()) {
      return UnderlineInputBorder(borderSide: borderSide);
    }
    return OutlineInputBorder(
      borderSide: borderSide,
      borderRadius: BorderRadius.circular(0.r),
    );
  }

  InputBorder _createErrorBorder(bool isDarkMode) {
    final borderColor =
        errorIcon ? VisaColors.error : _getBorderColor(isDarkMode);
    final borderSide = BorderSide(color: borderColor, width: 0.h);

    if (_isUnderlineBorder()) {
      return UnderlineInputBorder(borderSide: borderSide);
    }
    return OutlineInputBorder(
      borderSide: borderSide,
      borderRadius: BorderRadius.circular(0.r),
    );
  }

  EdgeInsetsGeometry _getContentPadding() {
    if (widget.contentPadding != null) {
      return widget.contentPadding!;
    }

    return EdgeInsets.symmetric(
      horizontal: (widget.hPaddingInside ?? 0).w,
      vertical: 0.h,
    );
  }

  String? _getValidator(String? value) {
    if (widget.isValid == false) {
      setState(() {
        errorIcon = true;
      });
      return widget.errorText ?? "Invalid Text";
    }
    setState(() {
      errorIcon = false;
    });
    return null;
  }
}
