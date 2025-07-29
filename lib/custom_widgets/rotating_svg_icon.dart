import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class RotatingSvgIcon extends StatefulWidget {
  final String assetPath;
  final double size;
  final Duration duration;

  const RotatingSvgIcon({
    super.key,
    required this.assetPath,
    this.size = 48.0,
    this.duration = const Duration(seconds: 2),
  });

  @override
  State<RotatingSvgIcon> createState() => _RotatingSvgIconState();
}

class _RotatingSvgIconState extends State<RotatingSvgIcon>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    )..repeat(); // rotates indefinitely
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (_, child) {
        return Transform.rotate(
          angle: _controller.value * 2 * 3.1415926,
          child: child,
        );
      },
      child: SvgPicture.asset(
        widget.assetPath,
        width: widget.size,
        height: widget.size,
      ),
    );
  }
}
