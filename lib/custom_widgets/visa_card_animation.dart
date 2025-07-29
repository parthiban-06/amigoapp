import 'package:flutter/material.dart';

enum AnimationDirection { leftToRight, rightToLeft, bottomToTop, topToBottom }

class VisaCardAnimation extends StatefulWidget {
  final Widget child;
  final Duration? delay;
  final AnimationDirection direction; // New: Direction control

  const VisaCardAnimation({
    super.key,
    required this.child,
    this.delay,
    this.direction = AnimationDirection.leftToRight, // Default direction
  });

  @override
  VisaCardAnimationState createState() => VisaCardAnimationState();
}

class VisaCardAnimationState extends State<VisaCardAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1250),
    );

    // Determine slide direction
    Offset beginOffset;
    switch (widget.direction) {
      case AnimationDirection.leftToRight:
        beginOffset = const Offset(-1.0, 0.0); // Start from left
        break;
      case AnimationDirection.rightToLeft:
        beginOffset = const Offset(1.0, 0.0); // Start from right
        break;
      case AnimationDirection.bottomToTop:
        beginOffset = const Offset(0.0, 1.0); // Start from bottom
        break;
      case AnimationDirection.topToBottom:
        beginOffset = const Offset(0.0, -1.0); // Start from top
        break;
    }

    _slideAnimation = Tween<Offset>(
      begin: beginOffset,
      end: Offset.zero, // Move to normal position
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _fadeAnimation = Tween<double>(
      begin: 0.0, // Fully transparent
      end: 1.0, // Fully visible
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));

    // Start animation after a short delay
    Future.delayed(
        const Duration(milliseconds: 300) + (widget.delay ?? Duration.zero),
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
    return SlideTransition(
      position: _slideAnimation,
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: widget.child,
      ),
    );
  }
}
