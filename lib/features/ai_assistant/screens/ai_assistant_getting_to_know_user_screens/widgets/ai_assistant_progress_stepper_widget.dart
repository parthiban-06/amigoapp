import 'package:flutter/material.dart';
import 'package:visaamigo/utils/app_extensions.dart';
import 'package:visaamigo/utils/theme_extension.dart';

import '../../../../../core/theme/theme.dart';
import '../../../../../utils/const_screen_size.dart';

class AiAssistantProgressStepperWidget extends StatelessWidget {
  final int currentStep;
  final int totalSteps;

  const AiAssistantProgressStepperWidget({
    super.key,
    required this.currentStep,
    required this.totalSteps,
  });

  @override
  Widget build(BuildContext context) {
    double progressValue = currentStep / totalSteps;
    return Stack(
      children: [
        // Grey Background Bar
        Container(
          height: Sizes.three,
          decoration: BoxDecoration(
            color: VisaColors.white,
            borderRadius: BorderRadius.circular(Sizes.ten),
          ),
        ),
        // Animated Progress Bar
        AnimatedContainer(
          duration: const Duration(milliseconds: 800),
          height: Sizes.three,
          width: context.screenWidth * progressValue,
          decoration: BoxDecoration(
            color: context.theme.primaryColor,
            borderRadius: BorderRadius.circular(Sizes.ten),
          ),
        ),
      ],
    );
  }
}
