import 'package:flutter/material.dart';

class AiAssistantPromptAnimationWidget extends StatefulWidget {
  final Widget child;
  final Duration? delay;
  final double? begin;
  final bool? showAnimation;

  const AiAssistantPromptAnimationWidget(
      {super.key, required this.child, this.delay, this.begin, this.showAnimation});

  @override
  AiAssistantPromptAnimationWidgetState createState() => AiAssistantPromptAnimationWidgetState();
}

class AiAssistantPromptAnimationWidgetState extends State<AiAssistantPromptAnimationWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    if(widget.showAnimation != null && widget.showAnimation == false){
      return;
    }

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 750),
    );

    _scaleAnimation = Tween<double>(begin: widget.begin ?? 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0, // Fully transparent
      end: 1.0, // Fully visible
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));

    // Start animation after a short delay
    Future.delayed((widget.delay ?? Duration.zero),
            () {
          if (mounted) {
            _controller.forward();
          }
        });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if(widget.showAnimation != null && widget.showAnimation == false){
      return widget.child;
    }
    return FadeTransition(
      opacity: _fadeAnimation,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: widget.child,
      ),
    );
  }
}
