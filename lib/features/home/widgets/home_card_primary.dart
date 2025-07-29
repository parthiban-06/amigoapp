import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:visaamigo/core/theme/theme.dart';
import 'package:visaamigo/custom_widgets/visa_textview.dart';
import 'package:visaamigo/utils/app_extensions.dart';
import 'package:visaamigo/utils/const_screen_size.dart';

import '../providers/home_provider.dart';

class HomeCardPrimary extends StatelessWidget {
  final List<HomeTitles> homeTile;
  final List<List<Color>> homeTitleColor;
  final int inxHomeTile;
  final int inxHomeSubTile;

  const HomeCardPrimary(
      {super.key,
      required this.homeTile,
      required this.inxHomeTile,
      required this.inxHomeSubTile,
      required this.homeTitleColor});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: AppSizes.ten),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              VisaTextView(
                text: homeTile
                    .elementAt(inxHomeTile)
                    .subTitle
                    .elementAt(inxHomeSubTile)
                    .name,
                style: VisaTextStyle.labelLarge,
                customColor: VisaColors.black,
                colorTheme: VisaTextTheme.customTextColor,
              ),
              AppSizes.xxsmallVS,
              Container(
                width: (context.screenWidth - 40).w,
                height: 120.h,
                decoration: BoxDecoration(
                  color: inxHomeSubTile == 0
                      ? homeTitleColor.elementAt(inxHomeTile)[0]
                      : homeTitleColor.elementAt(inxHomeTile)[1],
                  borderRadius: BorderRadius.circular(25.r),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: (context.screenWidth * 0.5).w,
                          child: VisaTextView(
                            overflow: TextOverflow.fade,
                            text: homeTile
                                .elementAt(inxHomeTile)
                                .subTitle
                                .elementAt(inxHomeSubTile)
                                .title,
                            style: VisaTextStyle.titleSmall,
                            customColor: VisaColors.white,
                            colorTheme: VisaTextTheme.customTextColor,
                          ),
                        ),
                        SizedBox(
                          width: (context.screenWidth * 0.5).w,
                          child: VisaTextView(
                            overflow: TextOverflow.fade,
                            text: homeTile
                                .elementAt(inxHomeTile)
                                .subTitle
                                .elementAt(inxHomeSubTile)
                                .subTitle,
                            style: VisaTextStyle.bodySmall,
                            customColor: VisaColors.white,
                            colorTheme: VisaTextTheme.customTextColor,
                          ),
                        ),
                      ],
                    ),
                    const Icon(
                      Icons.arrow_forward,
                      color: VisaColors.white,
                    )
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
