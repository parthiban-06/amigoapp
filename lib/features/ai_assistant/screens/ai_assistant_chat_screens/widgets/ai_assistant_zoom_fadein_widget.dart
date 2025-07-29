import 'package:flutter/material.dart';

class ZoomFadeExpand extends StatefulWidget {
  final bool expand;
  final Widget child;
  final Duration duration;
  final Curve curve;

  const ZoomFadeExpand({
    super.key,
    required this.expand,
    required this.child,
    this.duration = const Duration(milliseconds: 300),
    this.curve = Curves.easeInOut,
  });

  @override
  State<ZoomFadeExpand> createState() => _ZoomFadeExpandState();
}

class _ZoomFadeExpandState extends State<ZoomFadeExpand>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  late final AnimationController _controller;
  late final Animation<double> _fadeAnimation;
  late final Animation<double> _scaleAnimation;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );

    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: widget.curve,
    );

    _scaleAnimation = Tween<double>(begin: 0.7, end: 1.0).animate(_fadeAnimation);

    if (widget.expand) {
      _controller.forward();
    }
  }

  @override
  void didUpdateWidget(covariant ZoomFadeExpand oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.expand != oldWidget.expand) {
      if (widget.expand) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // important for keep-alive
    return SizeTransition(
      sizeFactor: _fadeAnimation,
      axisAlignment: -1.0,
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: ScaleTransition(
          scale: _scaleAnimation,
          alignment: Alignment.topCenter,
          child: widget.child,
        ),
      ),
    );
  }
}
