import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';
import 'package:visaamigo/core/theme/theme.dart';
import 'package:visaamigo/custom_widgets/visa_font_family.dart';
import 'package:visaamigo/custom_widgets/visa_textview.dart';
import 'package:visaamigo/utils/utils.dart';

import '../features/ai_assistant/screens/ai_assistant_chat_screens/widgets/ai_assistant_loading_widget.dart';
import '../utils/const_screen_size.dart';

class VisaChatLoadingMessage extends StatefulWidget {
  const VisaChatLoadingMessage({super.key});

  @override
  State<VisaChatLoadingMessage> createState() => _VisaChatLoadingMessageState();
}

class _VisaChatLoadingMessageState extends State<VisaChatLoadingMessage> {
  static const _texts = [
    "analyzing",
    "fetching_data",
    "processing",
    "thinking",
    "searching",
    "gathering_info"
  ];

  late String _randomText;
  late Timer _timer;
  bool showShimmerText = false;

  @override
  void initState() {
    super.initState();
    _setRandomText();
    _timer = Timer.periodic(const Duration(seconds: 4), (timer) {
      setState(() {
        showShimmerText = true;
        Utils.announceMessage(_randomText);
      });
    });
  }

  void _setRandomText() {
    _randomText = _texts[Random().nextInt(_texts.length)];

    Utils.logPrint("_randomText $_randomText");
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.only(top: 20.r, bottom: 3.r),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AiAssistantLoadingWidget(),
          SizedBox(
            width: AppSizes.tenRadius,
          ),
          if (showShimmerText)
            Shimmer.fromColors(
              baseColor: VisaColors.shimmerGrey,
              highlightColor: VisaColors.grey,
              child: Text(
                Utils.getErrorMessageFromString(_randomText),
                textScaler: TextScaler.linear(Utils.getCappedScale(
                  context,
                  FontSizes(context).displayBodyL,
                )),
                style: TextStyle(
                  fontSize: FontSizes(context).displayBodyL,
                  fontFamily: VisaFontFamily.getFontFamily(
                      VisaFontWeight.semibold, false),
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0,
                  height: (18 / 16).toDouble(),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
