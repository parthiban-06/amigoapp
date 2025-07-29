import 'package:flutter/material.dart';

enum AnimationType {
  noAnimation,
  slideFromLeft,
  slideFromRight,
  fade,
  scale,
  rotate,
  color,
  bounce,
  shake,
  combined,
}

class VisaAnimatedListItems extends StatefulWidget {
  final Widget child;
  final AnimationType animationType;
  final Duration duration;

  const VisaAnimatedListItems({
    super.key,
    required this.child,
    this.animationType = AnimationType.slideFromLeft,
    this.duration = const Duration(milliseconds: 300),
  });

  @override
  State<VisaAnimatedListItems> createState() => _VisaAnimatedListItemsState();
}

class _VisaAnimatedListItemsState extends State<VisaAnimatedListItems> {
  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder(
      tween: _getTween(),
      duration: widget.duration,
      builder: (context, dynamic value, child) {
        return _buildAnimation(value);
      },
      child: widget.child,
    );
  }

  Tween<dynamic> _getTween() {
    switch (widget.animationType) {
      case AnimationType.noAnimation:
        return Tween<Offset>(
          begin: const Offset(0.0, 0.0),
          end: const Offset(0.0, 0.0),
        );
      case AnimationType.slideFromLeft:
        return Tween<Offset>(
          begin: const Offset(-1.0, 0.0),
          end: const Offset(0.0, 0.0),
        );
      case AnimationType.slideFromRight:
        return Tween<Offset>(
          begin: const Offset(1.0, 0.0),
          end: const Offset(0.0, 0.0),
        );
      case AnimationType.fade:
        return Tween<double>(
          begin: 0.0,
          end: 1.0,
        );
      case AnimationType.scale:
        return Tween<double>(
          begin: 0.8,
          end: 1.0,
        );
      case AnimationType.rotate:
        return Tween<double>(
          begin: 0.0,
          end: 2 * 3.14159265359,
        );
      case AnimationType.color:
        return ColorTween(
          begin: Colors.red,
          end: Colors.blue,
        );
      case AnimationType.bounce:
        return Tween<double>(
          begin: 0.0,
          end: 1.0,
        );
      case AnimationType.shake:
        return Tween<double>(
          begin: 0.0,
          end: 1.0,
        );
      case AnimationType.combined:
        return Tween<double>(
          begin: 0.8,
          end: 1.0,
        );
    }
  }

  Widget _buildAnimation(dynamic value) {
    switch (widget.animationType) {
      case AnimationType.slideFromLeft ||
            AnimationType.slideFromRight ||
            AnimationType.noAnimation:
        return Transform.translate(
          offset: Offset(value.dx * 50, value.dy * 50),
          child: widget.child,
        );
      case AnimationType.fade:
        return Opacity(
          opacity: value,
          child: widget.child,
        );
      case AnimationType.scale:
        return Transform.scale(
          scale: value,
          child: widget.child,
        );
      case AnimationType.rotate:
        return Transform.rotate(
          angle: value,
          child: widget.child,
        );
      case AnimationType.color:
        return Container(
          color: value,
          child: widget.child,
        );
      case AnimationType.bounce:
        return Transform.translate(
          offset: Offset(0, -30 * (1 - value as double)),
          // Cast value to double
          child: widget.child,
        );
      case AnimationType.shake:
        return Transform.translate(
          offset: Offset(value * 10 * (value % 2 == 0 ? 1 : -1), 0),
          child: widget.child,
        );
      case AnimationType.combined:
        return Transform(
          transform: Matrix4.identity()
            ..scale(value)
            ..rotateZ(value * 2 * 3.14159265359),
          alignment: Alignment.center,
          child: widget.child,
        );
    }
  }
}
