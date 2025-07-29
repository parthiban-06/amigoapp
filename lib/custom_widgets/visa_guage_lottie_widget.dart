import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class VisaGuageLottieWidget extends StatefulWidget {
  final String assetPaths;
  final AnimationController gaugeController;
  final double? width;
  final double? height;

  const VisaGuageLottieWidget(
      {super.key,
      required this.assetPaths,
      required this.gaugeController,
      this.width,
      this.height});

  @override
  GaugeLottieWidgetState createState() => GaugeLottieWidgetState();
}

class GaugeLottieWidgetState extends State<VisaGuageLottieWidget> {
  // late String _currentLottiePath;

  @override
  void initState() {
    super.initState();
    widget.gaugeController.addListener(_updateLottie);
  }

  void _updateLottie() {
    double progress = widget.gaugeController.value;

    // if (_currentLottiePath != widget.assetPaths[index]) {
    //   setState(() {
    //     _currentLottiePath = widget.assetPaths[index];
    //   });
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Lottie.asset(
      widget.assetPaths,
      controller: widget.gaugeController,
      width: widget.width,
      height: widget.height,
      onLoaded: (composition) {
        widget.gaugeController.duration = composition.duration;
      },
    );
  }

  @override
  void dispose() {
    widget.gaugeController.removeListener(_updateLottie);
    super.dispose();
  }
}
