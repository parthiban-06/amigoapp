import 'package:flutter/material.dart';
import 'package:visaamigo/utils/theme_extension.dart';

class AiAssistantBubbleLoadingWidget extends StatefulWidget {
  const AiAssistantBubbleLoadingWidget({super.key});

  @override
  AiAssistantBubbleLoadingState createState() =>
      AiAssistantBubbleLoadingState();
}

class AiAssistantBubbleLoadingState
    extends State<AiAssistantBubbleLoadingWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<Animation<double>> _animations;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    )..repeat();

    _animations = List.generate(3, (index) {
      return Tween<double>(begin: 0, end: -8).animate(
        CurvedAnimation(
          parent: _controller,
          curve: Interval(
            index * 0.2, // stagger animations
            0.8, // ensure smooth transition for all dots
            curve: Curves.linear,
          ),
        ),
      );
    });
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
      children: List.generate(3, (index) {
        return AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Transform.translate(
              offset: Offset(0, _animations[index].value),
              child: child,
            );
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6.0),
            child: CircleAvatar(
              radius: 6.0,
              backgroundColor: context.theme.colorScheme.primary,
            ),
          ),
        );
      }),
    );
  }
}
