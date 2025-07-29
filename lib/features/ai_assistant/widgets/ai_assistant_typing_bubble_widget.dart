import 'package:flutter/material.dart';
import 'package:visaamigo/utils/theme_extension.dart';

class AiAssistantTypingBubbleWidget extends StatefulWidget {
  const AiAssistantTypingBubbleWidget({super.key});

  @override
  TypingIndicatorState createState() => TypingIndicatorState();
}

class TypingIndicatorState extends State<AiAssistantTypingBubbleWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _dotOneOpacity;
  late Animation<double> _dotTwoOpacity;
  late Animation<double> _dotThreeOpacity;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat();

    _dotOneOpacity = TweenSequence([
      TweenSequenceItem(tween: Tween(begin: 0.2, end: 1.0), weight: 1),
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 0.2), weight: 1),
    ]).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0.0, 0.33)),
    );

    _dotTwoOpacity = TweenSequence([
      TweenSequenceItem(tween: Tween(begin: 0.2, end: 1.0), weight: 1),
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 0.2), weight: 1),
    ]).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0.33, 0.66)),
    );

    _dotThreeOpacity = TweenSequence([
      TweenSequenceItem(tween: Tween(begin: 0.2, end: 1.0), weight: 1),
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 0.2), weight: 1),
    ]).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0.66, 1.0)),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        FadeTransition(
          opacity: _dotOneOpacity,
          child: _buildDot(),
        ),
        const SizedBox(width: 5),
        FadeTransition(
          opacity: _dotTwoOpacity,
          child: _buildDot(),
        ),
        const SizedBox(width: 5),
        FadeTransition(
          opacity: _dotThreeOpacity,
          child: _buildDot(),
        ),
      ],
    );
  }

  Widget _buildDot() {
    return Container(
      width: 10,
      height: 10,
      decoration: BoxDecoration(
        color: context.theme.colorScheme.primary,
        shape: BoxShape.circle,
      ),
    );
  }
}
