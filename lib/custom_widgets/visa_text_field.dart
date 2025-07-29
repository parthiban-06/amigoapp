import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:visaamigo/analytics/firebase_analytics_service.dart';
import 'package:visaamigo/custom_widgets/upper_case_formatter.dart';
import 'package:visaamigo/custom_widgets/visa_font_family.dart';
import 'package:visaamigo/custom_widgets/visa_svg_icon.dart';
import 'package:visaamigo/custom_widgets/visa_textview.dart';
import 'package:visaamigo/generated/l10n.dart';
import 'package:visaamigo/utils/app_extensions.dart';
import 'package:visaamigo/utils/theme_extension.dart';
import 'package:visaamigo/utils/utils.dart';

import '../../core/theme/theme.dart';
import '../features/select_languages/providers/language_selection_generic_provider.dart';
import '../generated/assets.dart';
import '../ui/provider/theme_provider.dart';
import '../utils/app_const.dart';
import '../utils/const_screen_size.dart';

enum VisaTextFieldVariant {
  primary,
  secondary,
}

class VisaTextField extends StatefulWidget {
  final Key? fieldKey;
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
  final String? formName;
  final String? eventName;
  final bool? otpErrorType;
  final String? formId;
  final Color? hintColor;
  final ValueChanged<String>? onChanged;
  final bool isPassword;
  final bool? readOnly;
  final bool isBiometrics;
  final bool isValid;
  final bool? disableError;
  final Widget? prefixIcon;
  final bool? underlineInputBorder;
  final bool? borderTransparent;
  final bool isRequired;
  String? errorText;
  final VisaTextFieldVariant variant;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final TextInputAction? textInputAction;
  final VoidCallback? onEditingComplete;
  final VoidCallback? onBiometricCall;
  final ValueChanged<String>? onSubmitted;
  final ValueChanged<Map<String, dynamic>>? onError;
  final ValueChanged<bool>? onTap;
  final bool showSuccessIcon;
  final bool showErrorIcon;
  final bool isEnable;
  final bool isUpperCase;
  final bool isLowerCase;
  final TextCapitalization textCapitalization;
  final TextInputType? textInputType;
  final int? maxLength;
  final int? maxLines;
  final int? minLines;
  final FontWeight fontWeight;
  final EdgeInsetsGeometry? contentPadding;
  final bool useCustomObscureCharacter;
  final bool semantics;
  final int? semanticsIndex;
  final int? labelSemanticsIndex;
  final String? semanticsLabel;
  final bool isDense;
  final Map<String, Object>? analyticsParameters;
  final bool isCapitalFirstLetter;

  VisaTextField({
    super.key,
    this.label,
    this.hint,
    this.value,
    this.onChanged,
    this.isPassword = false,
    this.isBiometrics = false,
    this.isRequired = true, // to add * mark
    this.isUpperCase = false,
    this.isLowerCase = false,
    this.textCapitalization = TextCapitalization.none, // to add * mark
    this.errorText,
    this.underlineInputBorder,
    this.variant = VisaTextFieldVariant.primary,
    this.controller,
    this.focusNode,
    this.textInputAction,
    this.onEditingComplete,
    this.onBiometricCall,
    this.onSubmitted,
    required this.isValid,
    this.vPadding = 12,
    this.maxLength = AppConst.TEXTFIELD_DEFAULT_LENGTH,
    this.hPadding = 0,
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
    this.maxLines = 1,
    this.minLines = 1,
    this.letterSpacing,
    this.borderTransparent,
    this.contentPadding,
    this.fontWeight = FontWeight.w400,
    this.useCustomObscureCharacter = false,
    this.hPaddingInside,
    this.semantics = true,
    this.semanticsIndex,
    this.labelSemanticsIndex,
    this.readOnly,
    this.hintColor = VisaColors.textFieldBorder,
    this.formName,
    this.formId,
    this.eventName,
    this.otpErrorType,
    this.analyticsParameters,
    this.semanticsLabel,
    this.isDense = true,
    this.fieldKey,
    this.onError,
    this.isCapitalFirstLetter = false,
  });

  @override
  State<VisaTextField> createState() => _VisaTextFieldState();
}

class _VisaTextFieldState extends State<VisaTextField> {
  late TextEditingController _controller;
  bool isHovered = false;
  bool isFocused = false;
  bool isObscured = true;
  late double sixteen;
  late double eight;
  late double fontTwelve;
  late double fontSize;
  late double borderRadius;

  final forbiddenCharactersRegex = RegExp(r'[<>{}]');

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
  void didChangeDependencies() {
    super.didChangeDependencies();
    sixteen = AppSizes.sixteenRadius;
    eight = AppSizes.eightRadius;
    fontTwelve = AppSizes.fontTwelve;
    fontSize = widget.fontSize?.sp ?? AppSizes.fontXXSmall;
    borderRadius = AppSizes.eightRadius;
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

  Widget? _buildStatusIcon() {
    if (widget.showSuccessIcon) {
      return Padding(
        padding: EdgeInsetsDirectional.only(end: Sizes.two.r),
        child: VisaSvgIcon(
            assetPath: Assets.iconsIcCheck,
            semantics: false,
            setColorFilter: false,
            padding: EdgeInsets.only(right: sixteen.r, left: eight.r),
            height: sixteen,
            width: sixteen),
      );
    } else if (widget.showErrorIcon) {
      return VisaSvgIcon(
          semantics: false,
          assetPath: Assets.iconsIcError,
          padding: EdgeInsets.only(right: sixteen.r, left: eight.r),
          color: VisaColors.error,
          height: sixteen,
          width: sixteen);
    }
    return const SizedBox.shrink();
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
        ? Colors.white.withValues(alpha: 0.3)
        : Colors.black.withValues(alpha: 0.3);
  }

  Color _getUnderlineBorderColor(bool isDarkMode) {
    return isDarkMode ? Colors.white.withValues(alpha: 0.7) : Colors.black;
  }

  Color _getFocusedBorderColor(bool isDarkMode) {
    if (isDarkMode) {
      return widget.variant == VisaTextFieldVariant.primary
          ? VisaColors.darkPrimary
          : VisaColors.darkSecondary;
    }
    return widget.variant == VisaTextFieldVariant.primary
        ? VisaColors.primary
        : VisaColors.secondary;
  }

  Color _getHoveredBorderColor(bool isDarkMode) {
    return isDarkMode
        ? Colors.white.withValues(alpha: 0.7)
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
        padding: _getTopPadding(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget.label != null) _buildLabelSection(themeProvider),
            _buildTextFieldSection(themeProvider),
          ],
        ),
      );
    });
  }

  EdgeInsetsGeometry _getTopPadding() {
    return EdgeInsets.only(top: (widget.vPadding ?? 12) > 0 ? 6 : 0);
  }

  Widget _buildLabelSection(ThemeProvider themeProvider) {
    return Padding(
      padding: EdgeInsets.only(bottom: AppSizes.heightTwo),
      child: _buildLabelWithSemantics(themeProvider),
    );
  }

  Widget _buildLabelWithSemantics(ThemeProvider themeProvider) {
    if (widget.semantics == true) {
      return Semantics(
        sortKey: widget.labelSemanticsIndex != null
            ? OrdinalSortKey(widget.labelSemanticsIndex!.toDouble())
            : null,
        enabled: widget.semantics != false,
        hidden: widget.semantics == false,
        excludeSemantics: true,
        label: _getLabelText(),
        child: _labelWidget(themeProvider),
      );
    } else {
      return ExcludeSemantics(child: _labelWidget(themeProvider));
    }
  }

  String _getLabelText() {
    return (widget.label ?? "") +
        (widget.isRequired ? " ${S.of(context).is_required}" : "");
  }

  Widget _buildTextFieldSection(ThemeProvider themeProvider) {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: widget.hPadding!, vertical: widget.vPadding!),
      child: MouseRegion(
        onEnter: (_) => setState(() => isHovered = true),
        onExit: (_) => setState(() => isHovered = false),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTextFormField(themeProvider),
            if (_shouldShowErrorText()) _buildErrorTextSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildTextFormField(ThemeProvider themeProvider) {
    return Semantics(
      sortKey: widget.semanticsIndex != null
          ? OrdinalSortKey(widget.semanticsIndex!.toDouble())
          : null,
      textField: widget.semanticsLabel == null,
      excludeSemantics: widget.semanticsLabel != null,
      container: true,
      label: (widget.semanticsLabel ?? ""),
      child: SizedBox(
        height: _getSizedBoxHeight(),
        child: MediaQuery(
          data: _getMediaQueryData(context),
          child: _buildFormField(themeProvider),
        ),
      ),
    );
  }

  double? _getSizedBoxHeight() {
    return _isUnderlineBorder()
        ? AppSizes.heightThrityFive
        : !widget.isValid && widget.label == S.of(context).start
            ? AppSizes.heightFiftyFour
            : null;
  }

  MediaQueryData _getMediaQueryData(BuildContext context) {
    return MediaQuery.of(context).copyWith(
      textScaler: TextScaler.linear(
          Utils.getCappedScale(context, (widget.fontSize ?? 14).sp)),
    );
  }

  TextFormField _buildFormField(ThemeProvider themeProvider) {
    return TextFormField(
      key: widget.fieldKey,
      keyboardType: widget.textInputType ?? TextInputType.text,
      maxLength: widget.maxLength ?? AppConst.TEXTFIELD_DEFAULT_LENGTH,
      controller: _controller,
      readOnly: widget.readOnly ?? false,
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
      maxLines: widget.maxLines,
      minLines: widget.minLines,
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
    widget.onChanged!(value);
    setState(() {
      errorIcon = false;
    });
  }

  List<TextInputFormatter> _getInputFormatters() {
    if (widget.isUpperCase) {
      return [UpperCaseTextFormatter()];
    } else if (widget.isLowerCase) {
      return [LowerCaseTextFormatter()];
    } else if (widget.isCapitalFirstLetter) {
      return [CapitalizeFirstLetterFormatter()];
    }
    return [];
  }

  TextStyle _getTextStyle(ThemeProvider themeProvider) {
    return TextStyle(
      color: _getTextColor(themeProvider),
      fontSize: widget.fontSize?.sp ?? 16.sp,
      fontFamily: "VisaDialectUI",
      letterSpacing: widget.letterSpacing?.sp ?? 1.sp,
      fontWeight: widget.fontWeight,
      height: 0.94,
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
      filled: true,
      counterText: "",
      hintText: widget.hint,
      fillColor: _getFillColor(themeProvider),
      suffixIcon: _buildSuffixIcon(),
      prefixIcon: widget.prefixIcon,
      prefixIconConstraints: _getPrefixIconConstraints(),
      hintStyle: _getHintStyle(themeProvider),
      errorMaxLines: 1,
      errorStyle: _getErrorStyle(),
      enabledBorder: _createBorder(themeProvider.isDarkMode),
      focusedBorder: _createBorder(themeProvider.isDarkMode),
      errorBorder: _createErrorBorder(themeProvider.isDarkMode),
      focusedErrorBorder: _createErrorBorder(themeProvider.isDarkMode),
      border: _createBorder(themeProvider.isDarkMode),
      contentPadding: _getContentPadding(),
      isDense: widget.isDense,
    );
  }

  Color _getFillColor(ThemeProvider themeProvider) {
    if (_isDisabled()) {
      return themeProvider.isDarkMode
          ? VisaColors.greyBackGround
          : Colors.grey[200]!;
    }
    return Colors.transparent;
  }

  bool _isDisabled() {
    return widget.onChanged == null || !widget.isEnable;
  }

  Widget? _buildSuffixIcon() {
    if (!_shouldShowSuffixIcon()) {
      return null;
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (_shouldShowErrorIcon()) _buildErrorIcon(),
        _buildMainSuffixIcon(),
      ],
    );
  }

  bool _shouldShowSuffixIcon() {
    return _shouldShowErrorIcon() ||
        widget.suffixIcon != null ||
        widget.isPassword ||
        widget.showSuccessIcon ||
        widget.showErrorIcon;
  }

  bool _shouldShowErrorIcon() {
    return widget.errorText != null && widget.isValid == false && errorIcon;
  }

  Widget _buildErrorIcon() {
    final hasForbiddenChars =
        forbiddenCharactersRegex.hasMatch(_controller.text);
    final errorMessage = hasForbiddenChars
        ? S.of(context).invalid_char
        : widget.errorText ?? S.of(context).invalid_text;
    if (widget.semantics == true) {
      final semantics = "${S.of(context).error.toLowerCase()}: $errorMessage";
      return Semantics(
        enabled: true,
        container: true,
        excludeSemantics: true,
        label: semantics,
        child: _errorIcon(),
      );
    } else {
      return ExcludeSemantics(
        child: _errorIcon(),
      );
    }
  }

  Widget _errorIcon() {
    return VisaSvgIcon(
      semantics: false,
      assetPath: Assets.iconsIcError,
      padding: EdgeInsets.only(right: Sizes.eight.r, left: Sizes.eight.r),
      color: VisaColors.error,
      height: Sizes.sixteenInt.h,
      width: Sizes.sixteenInt.w,
    );
  }

  Widget _buildMainSuffixIcon() {
    if (widget.suffixIcon != null) {
      return widget.suffixIcon!;
    }
    if (widget.isPassword) {
      return _buildPasswordIcon();
    }
    return _buildStatusIcon() ?? const SizedBox.shrink();
  }

  Widget _buildPasswordIcon() {
    if (isObscured) {
      return GestureDetector(
        onTap: _toggleObscure,
        child: _buildEyeIcon(
            Assets.iconsRiEyeFill, S.of(context).disable_to_hide_password),
      );
    } else {
      return GestureDetector(
        onTap: _toggleObscure,
        child: _buildEyeIcon(
            Assets.iconsRiEyeOffFill, S.of(context).enable_to_view_password),
      );
    }
  }

  BoxConstraints? _getPrefixIconConstraints() {
    if (widget.prefixIcon == null) {
      return null;
    }
    return BoxConstraints(maxWidth: 170.w, minWidth: 30.w);
  }

  TextStyle _getHintStyle(ThemeProvider themeProvider) {
    return TextStyle(
      color: _getHintColor(themeProvider),
    );
  }

  Color _getHintColor(ThemeProvider themeProvider) {
    if (themeProvider.isDarkMode) {
      return Colors.white.withValues(alpha: 128);
    }
    if (_isUnderlineBorder()) {
      return Colors.black;
    }
    return widget.hintColor ?? VisaColors.textFieldBorder;
  }

  TextStyle _getErrorStyle() {
    return TextStyle(
      fontFamily: VisaFontFamily.getFontFamily(VisaFontWeight.semibold, false),
      overflow: TextOverflow.fade,
      color: VisaColors.error,
      fontSize: 0,
      fontWeight: FontWeight.w600,
    );
  }

  InputBorder _createBorder(bool isDarkMode) {
    final borderColor = _getBorderColor(isDarkMode);
    final borderSide = BorderSide(color: borderColor, width: 1.h);

    if (_isUnderlineBorder()) {
      return UnderlineInputBorder(borderSide: borderSide);
    }
    return OutlineInputBorder(
      borderSide: borderSide,
      borderRadius: BorderRadius.circular(8.r),
    );
  }

  InputBorder _createErrorBorder(bool isDarkMode) {
    final borderColor = _shouldShowErrorBorder()
        ? VisaColors.error
        : _getBorderColor(isDarkMode);
    final borderSide = BorderSide(
      color: borderColor,
      width: 2.h,
    );

    if (_isUnderlineBorder()) {
      return UnderlineInputBorder(borderSide: borderSide);
    }
    return OutlineInputBorder(
      borderSide: borderSide,
      borderRadius: BorderRadius.circular(8.r),
    );
  }

  bool _shouldShowErrorBorder() {
    return (errorIcon &&
            widget.isValid == false &&
            widget.errorText?.isNotEmpty == true) ||
        forbiddenCharactersRegex.hasMatch(_controller.text);
  }

  EdgeInsetsGeometry _getContentPadding() {
    if (widget.contentPadding != null) {
      return widget.contentPadding!;
    }

    return EdgeInsets.symmetric(
      horizontal: (widget.hPaddingInside ?? 16).w,
      vertical: _getVerticalPadding(),
    );
  }

  double _getVerticalPadding() {
    if (_isUnderlineBorder()) {
      return 9.h;
    }
    return 16.h;
  }

  String? _getValidator(String? value) {
    final text = _controller.text.trim();

    if (forbiddenCharactersRegex.hasMatch(text)) {
      setState(() {
        widget.errorText = S.of(context).invalid_char;
        errorIcon = true;
      });
      return S.of(context).error + ": " + S.of(context).invalid_char;
    }

    if (widget.isValid == false) {
      setState(() {
        errorIcon = true;
      });
      callAnalytics();
      return S.of(context).error +
          ": " +
          (widget.errorText ?? S.of(context).invalid_text);
    }

    setState(() {
      errorIcon = false;
    });
    return null;
  }

  bool _shouldShowErrorText() {
    return (errorIcon &&
            widget.isValid == false &&
            widget.errorText?.isNotEmpty == true) ||
        forbiddenCharactersRegex.hasMatch(_controller.text);
  }

  Widget _buildErrorTextSection() {
    return Padding(
      padding: const EdgeInsets.only(top: 5, left: 2),
      child: Focus(
        focusNode: FocusNode(),
        child: _buildErrorTextWithSemantics(),
      ),
    );
  }

  Widget _buildErrorTextWithSemantics() {
    final hasForbiddenChars =
        forbiddenCharactersRegex.hasMatch(_controller.text);
    final errorMessage = hasForbiddenChars
        ? S.of(context).invalid_char
        : widget.errorText ?? S.of(context).invalid_text;
    if (widget.semantics == true) {
      final semantics =
          "${S.of(context).text_field.toLowerCase()}, ${S.of(context).error.toLowerCase()}: $errorMessage";
      return Semantics(
        enabled: true,
        hidden: false,
        container: true,
        label: semantics,
        excludeSemantics: true,
        child: _errorTextWidget(errorMessage),
      );
    } else {
      return ExcludeSemantics(child: _errorTextWidget(errorMessage));
    }
  }

  void callAnalytics() {
    final SelectLanguageGenericProvider localLanguageProvider =
        Provider.of<SelectLanguageGenericProvider>(context, listen: false);

    if (widget.onError != null) {
      widget.onError!({
        "label": localLanguageProvider.getKeyFromValue(widget.label ?? ""),
        "error": localLanguageProvider.getKeyFromValue(widget.errorText ?? "")
      });
      return;
    }

    if (widget.eventName.isNullOrEmpty) return;

    // final SelectLanguageGenericProvider localLanguageProvider =
    //     Provider.of<SelectLanguageGenericProvider>(context, listen: false);

    final String error =
        localLanguageProvider.getKeyFromValue(widget.errorText ?? "") ??
            "invalid_text";
    final String widgetLabel =
        localLanguageProvider.getKeyFromValue(widget.label ?? "") ?? "";

    // Base map with initial parameters
    final Map<String, Object> value = {...?widget.analyticsParameters};

    if (widget.formName == null || widget.formId == null) {
      if (widget.otpErrorType != null) {
        value.addAll({
          "ui_element_location":
              widget.otpErrorType == true ? "registration" : "login",
          "error_message": widget.errorText ?? "invalid_text",
        });
      } else {
        value.addAll({
          "error_field": widgetLabel,
          "error_type": error,
          "error_message": widget.errorText ?? "invalid_text",
        });
      }
    } else {
      value.addAll({
        "form_name": widget.formName!,
        "form_id": widget.formId!,
        "error_field": widgetLabel,
        "error_type": error,
        "error_message": widget.errorText ?? "invalid_text",
      });
    }

    // Log the event
    FirebaseAnalyticsService.logEvent(
      eventName: widget.eventName!,
      parameters: value,
    );
  }

  void _toggleObscure() {
    FocusManager.instance.primaryFocus?.unfocus();
    setState(() => isObscured = !isObscured);
    Utils.hideKeyboard(context);
    Utils.announceMessage(
      isObscured
          ? S.of(context).password_hidden
          : S.of(context).password_visible,
    );
  }

  Widget _labelWidget(ThemeProvider themeProvider) {
    return Text(
      widget.label!.toUpperCase() + (widget.isRequired ? "*" : ""),
      textScaler: TextScaler.linear(Utils.getCappedScale(context, 12.sp)),
      overflow: TextOverflow.ellipsis,
      style: widget.labelStyle ??
          TextStyle(
            fontSize: 12.sp,
            fontWeight: FontWeight.w500,
            fontFamily: "VisaDialectUI",
            letterSpacing: 2,
            height: 1.40,
            color: themeProvider.isDarkMode ? Colors.white : Colors.black,
          ),
    );
  }

  Widget _errorTextWidget(String errorMessage) {
    return VisaTextView(
      text: errorMessage,
      softWrap: true,
      overflow: TextOverflow.visible,
      style: VisaTextStyle.customLarge,
      fontFamily: VisaFontWeight.semibold,
      customColor: VisaColors.error,
      fontSize: AppSizes.fontfourteen,
      colorTheme: VisaTextTheme.customTextColor,
    );
  }

  Widget _buildEyeIcon(String asset, String label) {
    return Padding(
      padding: EdgeInsetsDirectional.only(end: Sizes.sixteen.r),
      child: SizedBox(
        width: Sizes.twentyFourInt.w,
        height: Sizes.twentyFourInt.h,
        child: VisaSvgIcon(
          assetPath: asset,
          semanticsLabel: label,
          width: Sizes.twentyFourInt.w,
          height: Sizes.twentyFourInt.h,
          color: context.theme.primaryColor,
        ),
      ),
    );
  }
}
