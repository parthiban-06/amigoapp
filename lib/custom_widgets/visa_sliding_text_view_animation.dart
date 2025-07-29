import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart' show OrdinalSortKey;
import 'package:visaamigo/custom_widgets/visa_textview.dart';
import 'package:visaamigo/utils/app_extensions.dart';
import 'package:visaamigo/generated/l10n.dart';

class VisaSlidingTextViewAnimation extends StatefulWidget {
  final String text;
  final TextStyle? textStyle;
  final Duration duration;
  final Duration delay; // Delay before animation starts
  final VisaTextStyle style;
  final VisaTextTheme colorTheme;
  final TextAlign textAlign;
  final Color customColor;
  final int? maxLines;
  final TextOverflow overflow;
  final bool isItalic;
  final double? letterSpacing;
  final double? lineHeight;
  final double? fontSize;
  final VisaFontWeight fontFamily;
  final bool softWrap;
  final TextWidthBasis textWidthBasis;
  final bool semantics;
  final int? semanticsIndex;
  final String? semanticsLabel;

  const VisaSlidingTextViewAnimation({
    super.key,
    required this.text,
    this.textStyle,
    this.duration = const Duration(milliseconds: 400),
    this.delay = const Duration(milliseconds: 200), // Default delay
    this.customColor = Colors.black,
    this.style = VisaTextStyle.bodyMedium,
    this.colorTheme = VisaTextTheme.primary,
    this.textAlign = TextAlign.start,
    this.maxLines,
    this.overflow = TextOverflow.ellipsis,
    this.isItalic = false,
    this.letterSpacing = 1.0,
    this.lineHeight = 1.02,
    this.fontSize,
    this.softWrap = true,
    this.textWidthBasis = TextWidthBasis.parent,
    this.fontFamily = VisaFontWeight.regular,
    this.semantics = true,
    this.semanticsIndex,
    this.semanticsLabel,
  });

  @override
  VisaSlidingTextViewAnimationState createState() =>
      VisaSlidingTextViewAnimationState();
}

class VisaSlidingTextViewAnimationState
    extends State<VisaSlidingTextViewAnimation> {
  late String _currentText;
  late String _previousText;
  bool _isAnimatingOldText = false;
  bool _isTextVisible = false; // Visibility flag

  @override
  void initState() {
    super.initState();
    _currentText = widget.text;
    _previousText = widget.text;

    // Delay before making the text visible
    Future.delayed(widget.delay, () {
      if (mounted) {
        setState(() {
          _isTextVisible = true;
        });
      }
    });
  }

  @override
  void didUpdateWidget(covariant VisaSlidingTextViewAnimation oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.text != widget.text) {
      setState(() {
        _isAnimatingOldText = true;
        _previousText = _currentText;
      });

      // Delay before updating the text
      Future.delayed(widget.delay, () {
        if (mounted) {
          setState(() {
            _isAnimatingOldText = false;
            _currentText = widget.text;
          });
        }
      });
    }
  }

  Widget _textWidget(String text) {
    return VisaTextView(
      text: text,
      style: widget.style,
      colorTheme: widget.colorTheme,
      customColor: widget.customColor,
      fontFamily: widget.fontFamily,
      overflow: widget.overflow,
      semantics: widget.semantics,
      semanticsLabel: widget.semanticsLabel,
      semanticsIndex: widget.semanticsIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    double offsetValue = context.screenWidth * 0.03; // 3% of screen width

    return Visibility(
      visible: _isTextVisible,
      maintainSize: true,
      maintainState: true,
      maintainAnimation: true,
      maintainSemantics: true,
      maintainInteractivity: true,
      child: widget.semantics == false
          ? ExcludeSemantics(child: buildSlidingText(offsetValue))
          : Semantics(
              sortKey: widget.semanticsIndex != null
                  ? OrdinalSortKey(widget.semanticsIndex!.toDouble())
                  : null,
              enabled: true,
              hidden: false,
              excludeSemantics: false,
              label: widget.semanticsLabel,
              child: buildSlidingText(offsetValue),
            ),
    );
  }

  Widget buildSlidingText(offsetValue) => Stack(
        children: [
          if (_isAnimatingOldText)
            TweenAnimationBuilder<Offset>(
              key: ValueKey(_previousText),
              duration: widget.duration,
              tween: Tween(begin: Offset.zero, end: Offset(offsetValue, 0)),
              builder: (context, offset, child) {
                return Transform.translate(
                  offset: Offset(offset.dx, 0),
                  child: child,
                );
              },
              child: _textWidget(_previousText),
            ),
          if (!_isAnimatingOldText)
            TweenAnimationBuilder<Offset>(
              key: ValueKey(_currentText),
              duration: widget.duration,
              tween: Tween(begin: Offset(-offsetValue, 0), end: Offset.zero),
              builder: (context, offset, child) {
                return Transform.translate(
                  offset: Offset(offset.dx, 0),
                  child: child,
                );
              },
              child: _textWidget(_currentText),
            ),
        ],
      );
}
