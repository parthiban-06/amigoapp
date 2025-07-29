import 'package:flutter/material.dart';

class VisaAnimatedWidget extends StatefulWidget {
  final Widget child;
  final Duration? delay;

  const VisaAnimatedWidget({super.key, required this.child, this.delay});

  @override
  VisaAnimatedWidgetState createState() => VisaAnimatedWidgetState();
}

class VisaAnimatedWidgetState extends State<VisaAnimatedWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    _scaleAnimation = Tween<double>(begin: 0.75, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeIn,
      ),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0.0, 1), // Start a little below
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
    return ScaleTransition(
      scale: _scaleAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: widget.child,
        ),
      ),
    );
  }
}
