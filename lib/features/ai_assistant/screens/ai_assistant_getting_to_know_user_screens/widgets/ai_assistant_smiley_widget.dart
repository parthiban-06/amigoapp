import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:visaamigo/core/theme/theme.dart';
import 'package:visaamigo/custom_widgets/visa_textview.dart';
import 'package:visaamigo/generated/assets.dart';
import 'package:visaamigo/generated/l10n.dart' show S;
import 'package:visaamigo/utils/theme_extension.dart';
import 'package:visaamigo/utils/utils.dart';

import '../../../../../custom_widgets/visa_slide_up_text_view_animation.dart';
import '../../../../../utils/const_screen_size.dart';
import '../../../providers/ai_assistant_main_provider.dart';

// ignore: must_be_immutable
class AiAssistantSmileyWidget extends StatelessWidget {
  const AiAssistantSmileyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final screenHeight = MediaQuery.of(context).size.height;

    var aiAssistantProvider = Provider.of<AiAssistantMainProvider>(context);
    aiAssistantProvider.getTeams();
    aiAssistantProvider.loadExcitementsListFromJsonFile();
    if (aiAssistantProvider.listExcitements!.isEmpty) {
      return Container();
    }

    return Column(
      // mainAxisAlignment: MainAxisAlignment.center,
      // crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          height: Utils.getFontSize(context)
              ? (aiAssistantProvider.isDesktopView
                  ? 200.h
                  : (screenHeight * 0.35).clamp(0, 280.h))
              : (aiAssistantProvider.isDesktopView
                  ? 200.h
                  : (screenHeight * 0.30).clamp(0, 300.h)),
        ),

        Lottie.asset(
          animate: false, // Let controller drive the animation
          Assets.jsonEmojiAllpositionsV2,
          width: Sizes.twoHundredFifty.w,
          height: Sizes.twoHundredFifty.h,
          controller: aiAssistantProvider.gaugeAnimationController,
          onLoaded: (composition) {
            aiAssistantProvider.gaugeAnimationController.duration =
                composition.duration;
          },
        ),

        // AppSizes.mediumVS,
        Column(
          children: [
            Container(
              // color: Colors.red,
              padding:
                  EdgeInsets.only(top: Utils.getFontSize(context) ? 0 : 20.r),
              child: VisaSlideUpTextViewAnimation(
                text: aiAssistantProvider.getExcitementStepsTitle(),
                style: VisaTextStyle.displayTitleSmall,
                colorTheme: VisaTextTheme.customTextColor,
                customColor: VisaColors.white,
                fontFamily: VisaFontWeight.semibold,
                overflow: TextOverflow.visible,
                isSlideUp: aiAssistantProvider.isForward,
                duration: const Duration(milliseconds: 500),
                letterSpacing: -1,
                lineHeight: Sizes.twentyOne,
                semantics: aiAssistantProvider.isDesktopView ? true : false,
              ),
            ),
            AppSizes.mediumVS,

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15).r,
              child: Semantics(
                // sortKey: const OrdinalSortKey(3.0),
                // label: aiAssistantProvider.isDesktopView
                //     ? ""
                //     : aiAssistantProvider.getExcitementStepsTitle(),
                // button: true,
                // enabled: true,
                sortKey: const OrdinalSortKey(3.0),
                label: aiAssistantProvider.isDesktopView
                    ? ""
                    : aiAssistantProvider.getExcitementStepsTitle(),

                // // Enhanced semantic properties for slider
                // slider: true,
                focusable: true,
                focused: true,
                // value: aiAssistantProvider.volumeValue.toStringAsFixed(2),
                enabled: true,
                hint: aiAssistantProvider.isDesktopView
                    ? s.slider_hint_web
                    : s.slider_hint_app,
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTapDown: (details) {
                        final box = context.findRenderObject() as RenderBox;
                        final localPosition =
                            box.globalToLocal(details.globalPosition);
                        double tapPercent =
                            localPosition.dx / constraints.maxWidth;
                        double newValue = tapPercent.clamp(0.0, 1.0);

                        // Ensure the tap value is properly synchronized
                        aiAssistantProvider.onVolumeChanged(newValue, true);
                      },
                      child: SfLinearGauge(
                        key: aiAssistantProvider.gaugeKey,
                        animationDuration: 700, // Slower animation
                        orientation: LinearGaugeOrientation.horizontal,
                        minimum: 0,
                        maximum: 1,
                        interval: 0.1,
                        showLabels: false,
                        showTicks: false,
                        axisTrackStyle: LinearAxisTrackStyle(
                          thickness: Sizes.sixteen,
                          color: VisaColors.blueLight,
                          edgeStyle: LinearEdgeStyle.bothCurve,
                        ),
                        barPointers: [
                          LinearBarPointer(
                            value: aiAssistantProvider.volumeValue,
                            thickness: Sizes.sixteen,
                            edgeStyle: LinearEdgeStyle.bothCurve,
                            color: context.theme.primaryColor,
                            enableAnimation: true,
                            animationDuration: 700, // Slower animation
                          ),
                        ],
                        markerPointers: [
                          LinearWidgetPointer(
                            value: aiAssistantProvider.volumeValue,
                            enableAnimation: true,
                            animationDuration: 700, // Slower animation
                            dragBehavior: LinearMarkerDragBehavior.constrained,
                            onChanged: (value) => aiAssistantProvider
                                .onVolumeChanged(value, false),
                            onChangeStart: (value) =>
                                aiAssistantProvider.isGauageAnimation(true),
                            onChangeEnd: (value) {
                              aiAssistantProvider.isGauageAnimation(false);
                              aiAssistantProvider
                                  .stopAnimationToDragPoint(value);
                            },
                            position: LinearElementPosition.cross,
                            child: Image.asset(
                              aiAssistantProvider.isGauageAnimationStart
                                  ? Assets.imagesCircleIcon
                                  : Assets.imagesCircleIcon,
                              height: Sizes.fortyTwo,
                              width: Sizes.fortyTwo,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
// ...existing code...
          ],
        ),

        // VSpacings.small,
      ],
    );
  }
}
