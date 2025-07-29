import 'dart:async';

import 'package:flutter/material.dart';

class VisaAnimatedCircularGradient extends StatefulWidget {
  final List<Color> gradientColors;
  final List<Color> innerColors;
  final double size;
  final Duration animationDuration;
  final Alignment begin;
  final Alignment end;
  final Widget? child;
  final List<double>? stops;
  final TileMode tileMode;
  final GradientTransform? transform;
  final List<BoxShadow>? boxShadow;
  final EdgeInsets margin;

  const VisaAnimatedCircularGradient({
    super.key,
    required this.gradientColors,
    required this.innerColors,
    this.size = 200.0,
    this.animationDuration = const Duration(seconds: 5),
    this.begin = Alignment.topLeft,
    this.end = Alignment.bottomRight,
    this.child,
    this.stops,
    this.tileMode = TileMode.clamp,
    this.transform,
    this.boxShadow,
    this.margin = EdgeInsets.zero,
  });

  @override
  VisaAnimatedCircularGradientState createState() =>
      VisaAnimatedCircularGradientState();
}

class VisaAnimatedCircularGradientState
    extends State<VisaAnimatedCircularGradient>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _movementX;
  late Animation<double> _movementY;
  late Animation<double> _fogOpacity;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    )..repeat(reverse: true);

    // Creates swirling fog motion
    _movementX = TweenSequence([
      TweenSequenceItem(tween: Tween(begin: 0.3, end: -0.3), weight: 50),
      TweenSequenceItem(tween: Tween(begin: -0.3, end: 0.3), weight: 50),
    ]).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _movementY = TweenSequence([
      TweenSequenceItem(tween: Tween(begin: -0.3, end: 0.3), weight: 50),
      TweenSequenceItem(tween: Tween(begin: 0.3, end: -0.3), weight: 50),
    ]).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    // Color transition animations for a foggy gradient effect

    // Opacity animation for a soft fog effect
    _fogOpacity = TweenSequence([
      TweenSequenceItem(tween: Tween(begin: 0.3, end: 0.7), weight: 50),
      TweenSequenceItem(tween: Tween(begin: 0.7, end: 0.3), weight: 50),
    ]).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    // Subtle scaling animation (breathing effect)
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
      builder: (context, child) {
        return Container(
          width: widget.size,
          height: widget.size,
          margin: widget.margin,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: widget.boxShadow ??
                [
                  BoxShadow(
                    color: widget.gradientColors.last.withValues(alpha: 0.4),
                    blurRadius: 20,
                    spreadRadius: 10,
                  ),
                ],
            gradient: RadialGradient(
              colors: widget.gradientColors,
              center: Alignment.center,
              radius: 1.0,
            ),
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Moving White Fog Effect (Inside the Circle)
              ClipOval(
                child: ShaderMask(
                  shaderCallback: (Rect bounds) {
                    return RadialGradient(
                      center: Alignment(
                        _movementX.value, // Moves left-right
                        _movementY.value, // Moves up-down
                      ),
                      radius: 0.4,
                      colors: [
                        Colors.white.withValues(alpha: _fogOpacity.value),
                        // White fog
                        Colors.white.withValues(alpha: 0.1),
                        // Softer edges
                      ],
                      stops: const [0.3, 1.0],
                      tileMode: TileMode.clamp,
                    ).createShader(bounds);
                  },
                  blendMode: BlendMode.overlay, // ✅ Best for fog effect
                  child: Container(
                    width: widget.size,
                    height: widget.size,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white
                          .withValues(alpha: 0.15), // Faint fog effect
                    ),
                  ),
                ),
              ),

              // Static Child Widget (Text or Icon)
              if (widget.child != null) widget.child!,
            ],
          ),
        );
      },
    );
  }
}

/// *******************************
/// Linear Gradient Animation
/// *******************************

/// [VisaAnimatedLinearGradientBackground] cycles through multiple
/// linear gradients. Set [animate] to false to disable the animation.
class VisaAnimatedLinearGradientBackground extends StatefulWidget {
  final Widget child;
  final List<List<Color>> colorSets; // List of gradient color lists
  final Alignment begin;
  final Alignment end;
  final Duration duration;
  final bool animate;

  /// Optional gradient parameters:
  final List<double>? stops;
  final TileMode tileMode;
  final GradientTransform? transform;

  const VisaAnimatedLinearGradientBackground({
    super.key,
    required this.child,
    required this.colorSets,
    this.begin = Alignment.topRight,
    this.end = Alignment.bottomLeft,
    this.duration = const Duration(seconds: 3),
    this.animate = true,
    this.stops,
    this.tileMode = TileMode.clamp,
    this.transform,
  });

  @override
  VisaAnimatedLinearGradientBackgroundState createState() =>
      VisaAnimatedLinearGradientBackgroundState();
}

class VisaAnimatedLinearGradientBackgroundState
    extends State<VisaAnimatedLinearGradientBackground> {
  int _currentIndex = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    if (widget.animate && widget.colorSets.length > 1) {
      _startAnimation();
    }
  }

  void _startAnimation() {
    _timer = Timer.periodic(widget.duration, (timer) {
      setState(() {
        _currentIndex = (_currentIndex + 1) % widget.colorSets.length;
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // If animation is disabled, always show the first gradient.
    final colors = widget.animate
        ? widget.colorSets[_currentIndex]
        : widget.colorSets.first;
    return AnimatedContainer(
      duration: widget.duration,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: widget.begin,
          end: widget.end,
          colors: colors,
          stops: widget.stops,
          tileMode: widget.tileMode,
          transform: widget.transform,
        ),
      ),
      child: widget.child,
    );
  }
}

/// *******************************
/// Radial Gradient Animation
/// *******************************

/// [VisaAnimatedRadialGradientBackground] cycles through multiple
/// radial gradients. Set [animate] to false to display a static gradient.
class VisaAnimatedRadialGradientBackground extends StatefulWidget {
  final Widget child;
  final List<List<Color>> colorSets;
  final Alignment center;
  final double radius;
  final Duration duration;
  final bool animate;

  /// Optional gradient parameters:
  final List<double>? stops;
  final TileMode tileMode;
  final GradientTransform? transform;

  const VisaAnimatedRadialGradientBackground({
    super.key,
    required this.child,
    required this.colorSets,
    this.center = Alignment.center,
    this.radius = 0.5,
    this.duration = const Duration(seconds: 3),
    this.animate = true,
    this.stops,
    this.tileMode = TileMode.clamp,
    this.transform,
  });

  @override
  VisaAnimatedRadialGradientBackgroundState createState() =>
      VisaAnimatedRadialGradientBackgroundState();
}

class VisaAnimatedRadialGradientBackgroundState
    extends State<VisaAnimatedRadialGradientBackground> {
  int _currentIndex = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    if (widget.animate && widget.colorSets.length > 1) {
      _startAnimation();
    }
  }

  void _startAnimation() {
    _timer = Timer.periodic(widget.duration, (timer) {
      setState(() {
        _currentIndex = (_currentIndex + 1) % widget.colorSets.length;
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = widget.animate
        ? widget.colorSets[_currentIndex]
        : widget.colorSets.first;
    return AnimatedContainer(
      duration: widget.duration,
      decoration: BoxDecoration(
        gradient: RadialGradient(
          center: widget.center,
          radius: widget.radius,
          colors: colors,
          stops: widget.stops,
          tileMode: widget.tileMode,
          transform: widget.transform,
        ),
      ),
      child: widget.child,
    );
  }
}

/// *******************************
/// Sweep Gradient Animation
/// *******************************

/// [VisaAnimatedSweepGradientBackground] cycles through multiple
/// sweep gradients. Set [animate] to false to display a static gradient.
class VisaAnimatedSweepGradientBackground extends StatefulWidget {
  final Widget child;
  final List<List<Color>> colorSets;
  final Alignment center;
  final double startAngle;
  final double endAngle;
  final Duration duration;
  final bool animate;

  /// Optional gradient parameters:
  final List<double>? stops;
  final TileMode tileMode;
  final GradientTransform? transform;

  const VisaAnimatedSweepGradientBackground({
    super.key,
    required this.child,
    required this.colorSets,
    this.center = Alignment.center,
    this.startAngle = 0.0,
    this.endAngle = 6.28319, // 2 * pi
    this.duration = const Duration(seconds: 3),
    this.animate = true,
    this.stops,
    this.tileMode = TileMode.clamp,
    this.transform,
  });

  @override
  VisaAnimatedSweepGradientBackgroundState createState() =>
      VisaAnimatedSweepGradientBackgroundState();
}

class VisaAnimatedSweepGradientBackgroundState
    extends State<VisaAnimatedSweepGradientBackground> {
  int _currentIndex = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    if (widget.animate && widget.colorSets.length > 1) {
      _startAnimation();
    }
  }

  void _startAnimation() {
    _timer = Timer.periodic(widget.duration, (timer) {
      setState(() {
        _currentIndex = (_currentIndex + 1) % widget.colorSets.length;
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = widget.animate
        ? widget.colorSets[_currentIndex]
        : widget.colorSets.first;
    return AnimatedContainer(
      duration: widget.duration,
      decoration: BoxDecoration(
        gradient: SweepGradient(
          center: widget.center,
          startAngle: widget.startAngle,
          endAngle: widget.endAngle,
          colors: colors,
          stops: widget.stops,
          tileMode: widget.tileMode,
          transform: widget.transform,
        ),
      ),
      child: widget.child,
    );
  }
}

/// *******************************
/// Rotating Gradient Animation
/// *******************************

/// [VisaRotatingGradientBackground] rotates a single static linear gradient.
/// Set [animate] to false to disable the rotation.
class VisaRotatingGradientBackground extends StatefulWidget {
  final Widget child;
  final List<Color> colors;
  final Alignment begin;
  final Alignment end;
  final Duration duration;
  final bool animate;

  /// Optional gradient parameters:
  final List<double>? stops;
  final TileMode tileMode;
  final GradientTransform? transform;

  const VisaRotatingGradientBackground({
    super.key,
    required this.child,
    required this.colors,
    this.begin = Alignment.topLeft,
    this.end = Alignment.bottomRight,
    this.duration = const Duration(seconds: 10),
    this.animate = true,
    this.stops,
    this.tileMode = TileMode.clamp,
    this.transform,
  });

  @override
  VisaRotatingGradientBackgroundState createState() =>
      VisaRotatingGradientBackgroundState();
}

class VisaRotatingGradientBackgroundState
    extends State<VisaRotatingGradientBackground>
    with SingleTickerProviderStateMixin {
  AnimationController? _controller;

  @override
  void initState() {
    super.initState();
    if (widget.animate) {
      _controller = AnimationController(
        duration: widget.duration,
        vsync: this,
      )..repeat();
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Build the background with a static linear gradient.
    final background = Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: widget.begin,
          end: widget.end,
          colors: widget.colors,
          stops: widget.stops,
          tileMode: widget.tileMode,
          transform: widget.transform,
        ),
      ),
      child: widget.child,
    );

    if (!widget.animate) return background;

    // Use AnimatedBuilder to rotate the background.
    return AnimatedBuilder(
      animation: _controller!,
      builder: (context, child) {
        return Transform.rotate(
          angle: _controller!.value * 2 * 3.14159,
          child: child,
        );
      },
      child: background,
    );
  }
}
