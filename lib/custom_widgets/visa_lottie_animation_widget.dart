import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class VisaLottieAnimationWidget extends StatefulWidget {
  final String assetPath;
  final bool repeat;
  final void Function(LottieComposition)? onLoaded;
  final void Function()? onComplete;
  final double? width;
  final double? height;
  final bool isSetLastFrame;

  const VisaLottieAnimationWidget({
    super.key,
    required this.assetPath,
    this.repeat = true,
    this.onLoaded,
    this.onComplete,
    this.width,
    this.height,
    this.isSetLastFrame = true,
  });

  @override
  LottieAnimationWidgetState createState() => LottieAnimationWidgetState();
}

class LottieAnimationWidgetState extends State<VisaLottieAnimationWidget>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late int totalFrames = 0;

  void setLottieFrame(int frame) {
    if (totalFrames > 0) {
      double progress = frame / totalFrames;
      _controller.value = progress; // Jump to specific frame
    }
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _controller.stop();
        if (widget.isSetLastFrame) {
          // Stop Animation Last Frame
          setLottieFrame(2766);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Lottie.asset(
      widget.assetPath,
      controller: _controller,
      width: widget.width,
      height: widget.height,
      repeat: widget.repeat,
      onLoaded: (composition) {
        _controller.duration = composition.duration;
        totalFrames = composition.duration.inMilliseconds; // Approximate frames
        _controller.forward(); // Set to frame 30 (example)
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
