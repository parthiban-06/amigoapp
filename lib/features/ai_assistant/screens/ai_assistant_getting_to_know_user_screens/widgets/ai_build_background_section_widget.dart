import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:provider/provider.dart';
import 'package:visaamigo/utils/app_extensions.dart';

import '../../../../../generated/assets.dart';
import '../../../providers/ai_assistant_main_provider.dart';

class AiBuildBackgroundSectionWidget extends StatelessWidget {
  final int pageIndex;
  final double offset;

  const AiBuildBackgroundSectionWidget({
    super.key,
    required this.pageIndex,
    required this.offset,
  });

  @override
  Widget build(BuildContext context) {
    var aiAssistantProvider = Provider.of<AiAssistantMainProvider>(context);
    bool isDesktop = aiAssistantProvider.isDesktopView || aiAssistantProvider.isTabletView;

    return Positioned(
      top: offset,
      left: 0,
      right: 0,
      height: context.screenHeight,
      child: ShaderMask(
        shaderCallback: (Rect bounds) {
          return const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.black, Colors.black],
            stops: [0.7, 1.0],
          ).createShader(bounds);
        },
        blendMode: BlendMode.dstIn,
        child: KeyboardVisibilityBuilder(builder: (context, isKeyboardVisible) {
          return Image.asset(
            isDesktop ? Assets.imagesWebBackground : Assets.imagesBackgroundNew,
            fit: BoxFit.cover,
            alignment: aiAssistantProvider.getBackgroundAlignment(
              pageIndex,
              isKeyboardVisible,
            ), // Adjust alignment based on page
          );
        }),
      ),
    );
  }
}
