import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:visaamigo/features/home/widgets/first_time_tutorial_view.dart';
import 'package:visaamigo/utils/app_extensions.dart';
import 'package:visaamigo/utils/const_screen_size.dart' show AppSizes;

class TutorialWidget extends StatelessWidget {
  final GlobalKey tutorialKey;
  final String mainTitle;
  final String subTitle;
  final bool toolTipPosition;
  final Function next;
  final Widget child;
  final Function close;
  final Function previous;

  const TutorialWidget({
    super.key,
    required this.tutorialKey,
    required this.next,
    required this.close,
    required this.previous,
    required this.child,
    required this.mainTitle,
    required this.subTitle,
    required this.toolTipPosition,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Showcase.withWidget(
        key: tutorialKey,
        height: 200.h,
        disposeOnTap: false,
        disableBarrierInteraction: true,
        disableDefaultTargetGestures: true,
        width: context.screenWidth,
        targetPadding: EdgeInsets.symmetric(horizontal:AppSizes.twentyFive),
        tooltipPosition:
            toolTipPosition ? TooltipPosition.bottom : TooltipPosition.top,
        overlayOpacity: 0.5,
        tooltipActionConfig: const TooltipActionConfig(
          alignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          position: TooltipActionPosition.outside,
        ),
        tooltipActions: const [
          TooltipActionButton(
            backgroundColor: Colors.transparent,
            type: TooltipDefaultActionType.skip,
            textStyle: TextStyle(
              color: Colors.transparent,
            ),
          ),
        ],
        container: FirstTimeTutorialView(
          mainTitle: mainTitle,
          desc: subTitle,
          tooltipPosition: toolTipPosition,
          showNext: toolTipPosition,
          showBack: true,
          next: next,
          previous: previous,
          close: close,
        ),
        child: child,
      ),
    );
  }
}
