import 'package:flutter/material.dart';
import 'package:visaamigo/custom_widgets/visa_textview.dart';

class VisaSlideUpTextViewAnimation extends StatefulWidget {
  final String text;
  final TextStyle? textStyle;
  final Duration duration;
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
  final bool isSlideUp;
  final Function(bool)? isTextAnimationFinished;
  final bool semantics;
  final int? semanticsIndex;
  final String? semanticsLabel;

  const VisaSlideUpTextViewAnimation({
    super.key,
    required this.text,
    this.duration = const Duration(seconds: 1),
    this.textStyle,
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
    this.isSlideUp = true,
    this.isTextAnimationFinished,
    this.semantics = true,
    this.semanticsIndex,
    this.semanticsLabel,
  });

  @override
  VisaSlideUpTextViewAnimationState createState() =>
      VisaSlideUpTextViewAnimationState();
}

class VisaSlideUpTextViewAnimationState
    extends State<VisaSlideUpTextViewAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation _opacity1;
  late Animation _opacity2;
  late Animation<Offset> _position1;
  late Animation<Offset> _position2;
  String _currentText = '';

  @override
  void initState() {
    super.initState();
    _currentText = widget.text;

    _controller = AnimationController(
      vsync: this,
      duration: widget.duration * 2,
    );

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed ||
          status == AnimationStatus.dismissed) {
        widget.isTextAnimationFinished?.call(true);
      } else if (status == AnimationStatus.forward) {
        widget.isTextAnimationFinished?.call(false);
      }
    });

    _initializeAnimation();
    _controller.forward();
  }

  void _initializeAnimation() {
    Offset startOffset =
        widget.isSlideUp ? const Offset(0, 0.5) : const Offset(0, -0.5);

    _opacity1 = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
          parent: _controller,
          curve: const Interval(0.0, 0.5, curve: Curves.easeIn)),
    );

    _opacity2 = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
          parent: _controller,
          curve: const Interval(0.5, 1.0, curve: Curves.easeIn)),
    );

    _position1 = Tween<Offset>(begin: startOffset, end: Offset.zero).animate(
      CurvedAnimation(
          parent: _controller,
          curve: const Interval(0.0, 0.5, curve: Curves.easeInOut)),
    );

    _position2 = Tween<Offset>(begin: startOffset, end: Offset.zero).animate(
      CurvedAnimation(
          parent: _controller,
          curve: const Interval(0.5, 1.0, curve: Curves.easeInOut)),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant VisaSlideUpTextViewAnimation oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.text != widget.text) {
      setState(() {
        _currentText = widget.text;
      });
      _controller.reset();
      _initializeAnimation();
      _controller.forward();
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
      letterSpacing: widget.letterSpacing,
      lineHeight: widget.lineHeight,
      maxLines: widget.maxLines,
      textAlign: widget.textAlign,
      fontSize: widget.fontSize,
      softWrap: widget.softWrap,
      isItalic: widget.isItalic,
      textWidthBasis: widget.textWidthBasis,
      semantics: widget.semantics,
      semanticsIndex: widget.semanticsIndex,
      semanticsLabel: widget.semanticsLabel,
    );
  }

  @override
  Widget build(BuildContext context) {
    final lines = _currentText.split('\n');
    final firstLine = lines.sublist(0, (lines.length / 2).ceil()).join(' ');
    final secondLine = lines.sublist((lines.length / 2).ceil()).join(' ');

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (firstLine.isNotEmpty)
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Opacity(
                opacity: _opacity1.value,
                child: SlideTransition(
                  position: _position1,
                  child: _textWidget(firstLine),
                ),
              );
            },
          ),
        if (secondLine.isNotEmpty)
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Opacity(
                opacity: _opacity2.value,
                child: SlideTransition(
                  position: _position2,
                  child: _textWidget(secondLine),
                ),
              );
            },
          ),
      ],
    );
  }
}
