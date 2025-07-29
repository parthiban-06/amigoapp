import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';

import '../../../../../generated/assets.dart';
import '../../../../../utils/const_screen_size.dart';

class AiAssistantLoadingWidget extends StatefulWidget {
  // final AiAssistantThreadsScreenProvider viewModel;

  final bool isPlay;

  const AiAssistantLoadingWidget({super.key, this.isPlay = true});

  @override
  State<AiAssistantLoadingWidget> createState() =>
      _AiAssistantLoadingWidgetState();
}

class _AiAssistantLoadingWidgetState extends State<AiAssistantLoadingWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: Alignment.centerLeft,
        width: Sizes.twentyFourInt.w,
        height: Sizes.twentyFourInt.h,
        // padding: EdgeInsets.symmetric(vertical: Sizes.twelve),

        margin: EdgeInsets.only(
          // horizontal: Sizes.twelve,
          top: 0.h,
        ),
        child: ExcludeSemantics(
          child: SizedBox(
            width: Sizes.twentyFourInt.w,
            height: Sizes.twentyFourInt.h,
            child: /*VisaLottieAnimationWidget(
            repeat: true,
            assetPath: Assets.jsonEvaLoadinganimtion,
            width: Sizes.twentyFour.w,
            height: Sizes.twentyFour.h,
          )*/
                Lottie.asset(
              Assets.jsonEvaLoadinganimtion,
              width: Sizes.twentyFour.w,
              height: Sizes.twentyFour.h,
              repeat: widget.isPlay,
            ),
          ),
        ));
  }
}
