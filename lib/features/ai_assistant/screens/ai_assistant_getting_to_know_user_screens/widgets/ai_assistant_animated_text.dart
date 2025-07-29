import 'package:flutter/material.dart';

class VisaAnimatedText extends StatefulWidget {
  final Widget child;
  final Duration? delay;
  final Offset? slideOffset;
  final bool? showAnimation;

  const VisaAnimatedText(
      {super.key, required this.child, this.delay, this.slideOffset, this.showAnimation});

  @override
  VisaAnimatedTextState createState() => VisaAnimatedTextState();
}

class VisaAnimatedTextState extends State<VisaAnimatedText>
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

    _slideAnimation = Tween<Offset>(
      begin: widget.slideOffset ?? const Offset(0.0, 1), // Start a little below
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
    if(widget.showAnimation != null && widget.showAnimation == false){
      return widget.child;
    }
    return SlideTransition(
      position: _slideAnimation,
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: widget.child,
      ),
    );
  }
}
