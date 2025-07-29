import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart'
    show RatingBar, RatingWidget;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:visaamigo/custom_widgets/visa_svg_icon.dart';
import 'package:visaamigo/features/rate_us/model/rate_us_model.dart'
    show RateUsModel;
import 'package:visaamigo/utils/const_screen_size.dart' show AppSizes;
// Adjust path accordingly

class VisaRatingSelector extends StatelessWidget {
  final String assetPathBorder;
  final String assetPathFill;
  final double iconSize;
  final Color selectedColor;
  final Color unselectedColor;
  final double initialRating;

  const VisaRatingSelector({
    super.key,
    required this.assetPathBorder,
    required this.assetPathFill,
    this.iconSize = 46,
    required this.selectedColor,
    required this.unselectedColor,
    this.initialRating = 0,
  });

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<RateUsModel>();

    return Center(
      child: RatingBar(
        itemSize: iconSize.w,
        initialRating: initialRating,
        direction: Axis.horizontal,
        maxRating: 5,
        minRating: 0,
        itemCount: 5,
        glowRadius: 1,
        wrapAlignment: WrapAlignment.center,
        ratingWidget: RatingWidget(
          full: VisaSvgIcon(
            assetPath: assetPathFill,
            width: iconSize.w,
            height: iconSize.h,
            color: selectedColor,
          ),
          half: VisaSvgIcon(
            assetPath: assetPathFill,
            width: iconSize.w,
            height: iconSize.h,
            color: selectedColor,
          ),
          empty: VisaSvgIcon(
            assetPath: assetPathBorder,
            width: iconSize.w,
            height: iconSize.h,
            setColorFilter: false,
            color: unselectedColor,
          ),
        ),
        itemPadding: EdgeInsets.symmetric(horizontal: AppSizes.nineWidth),
        onRatingUpdate: (rating) {
          viewModel.onSelectRating(rating);
        },
      ),
    );
  }
}
