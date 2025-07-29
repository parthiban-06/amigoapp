import 'package:flutter/material.dart';

class ProgressBarWidget extends StatelessWidget {
  const ProgressBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final pWidth = MediaQuery.of(context).size.width;
    final pHeight = MediaQuery.of(context).size.height;
    return Stack(
      children: [
        Container(
          width: pWidth,
          height: pHeight,
          color: Colors.black26,
        ),
        Positioned(
          child: Center(
            child: CircularProgressIndicator(
                color: Theme.of(context).primaryColor),
          ),
        ),
      ],
    );
  }
}
