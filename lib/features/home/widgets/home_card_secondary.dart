import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:visaamigo/core/theme/theme.dart';
import 'package:visaamigo/custom_widgets/visa_textview.dart';
import 'package:visaamigo/utils/app_extensions.dart';
import 'package:visaamigo/utils/const_screen_size.dart';

import '../providers/home_provider.dart';

class HomeCardSecondary extends StatelessWidget {
  final List<HomeTitles> homeTile;
  final List<List<Color>> homeTitleColor;
  final int inxHomeTile;
  final int inxHomeSubTile;

  const HomeCardSecondary(
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
                height: 200.h,
                decoration: BoxDecoration(
                  color: VisaColors.primary,
                  borderRadius: BorderRadius.circular(25.r),
                ),
                child: Padding(
                  padding: EdgeInsets.all( AppSizes.dimSmall),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: (context.screenWidth * 0.75).w,
                        child: VisaTextView(
                          overflow: TextOverflow.fade,
                          text: homeTile
                              .elementAt(inxHomeTile)
                              .subTitle
                              .elementAt(inxHomeSubTile)
                              .title,
                          style: VisaTextStyle.titleLarge,
                          customColor: VisaColors.white,
                          colorTheme: VisaTextTheme.customTextColor,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: (context.screenWidth * 0.6).w,
                            child: VisaTextView(
                              overflow: TextOverflow.fade,
                              text: homeTile
                                  .elementAt(inxHomeTile)
                                  .subTitle
                                  .elementAt(inxHomeSubTile)
                                  .subTitle,
                              style: VisaTextStyle.bodyMedium,
                              customColor: VisaColors.white,
                              colorTheme: VisaTextTheme.customTextColor,
                            ),
                          ),
                          const Icon(
                            Icons.arrow_forward,
                            color: VisaColors.white,
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
