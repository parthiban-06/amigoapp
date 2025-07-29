import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:visaamigo/core/theme/theme.dart';
import 'package:visaamigo/custom_widgets/visa_button.dart';
import 'package:visaamigo/custom_widgets/visa_size_box.dart';
import 'package:visaamigo/custom_widgets/visa_textview.dart';
import 'package:visaamigo/di/service_locator.dart';
import 'package:visaamigo/features/rate_us/model/rate_us_model.dart';
import 'package:visaamigo/features/rate_us/widgets/tell_us_more.dart';
import 'package:visaamigo/features/rate_us/widgets/visa_rating_selector.dart';
import 'package:visaamigo/features/splash_screen/repo/user_detail_repo.dart';
import 'package:visaamigo/generated/assets.dart';
import 'package:visaamigo/generated/l10n.dart';
import 'package:visaamigo/router/app_router.dart';
import 'package:visaamigo/router/app_routes_const.dart';
import 'package:visaamigo/utils/amplify_service.dart';
import 'package:visaamigo/utils/app_extensions.dart';
import 'package:visaamigo/utils/const_screen_size.dart';
import 'package:visaamigo/utils/utils.dart';

import '../../../custom_widgets/visa_snack_bar.dart';
import '../../../custom_widgets/visa_svg_icon.dart';

class RateUsPopup extends StatelessWidget {
  final bool? isDouble;

  const RateUsPopup({super.key, this.isDouble});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => RateUsModel(userDetailRepo: getIt<UserDetailRepo>()),
      child: Scaffold(
        backgroundColor: VisaColors.transparent,
        body: Consumer<RateUsModel>(
          builder: (context2, model, _) {
            return _buildMainContent(context, model);
          },
        ),
      ),
    );
  }

  Widget _buildMainContent(BuildContext context, RateUsModel model) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 12.w),
        child: Container(
          width: context.screenWidth,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.r),
            color: VisaColors.white,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildHeader(),
              _buildRatingSection(model),
              _buildSubmitButton(AmplifyService.context!, model),
              VisaSizeBox(height: 24.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        VisaSizeBox(height: 24.h),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: _buildCloseButton(),
        ),
        VisaSizeBox(height: 24.h),
      ],
    );
  }

  Widget _buildCloseButton() {
    return Builder(
      builder: (context) => InkWell(
        onTap: () {
          Navigator.of(context).pop();
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            VisaSvgIcon(
              height: 10.h,
              width: 10.w,
              assetPath: Assets.iconsIcClose,
              color: VisaColors.black,
            ),
            VisaSizeBox(width: 4.w),
            VisaTextView(
              text: S.of(context).close.toUpperCase(),
              softWrap: true,
              overflow: TextOverflow.visible,
              style: VisaTextStyle.customLarge,
              fontFamily: VisaFontWeight.medium,
              fontSize: AppSizes.fontTwelve,
              customColor: VisaColors.black,
              colorTheme: VisaTextTheme.customTextColor,
              letterSpacing: 2,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRatingSection(RateUsModel model) {
    return Column(
      children: [
        _buildTitle(),
        VisaSizeBox(height: 24.h),
        _buildRatingSelector(model),
        VisaSizeBox(height: 24.h),
      ],
    );
  }

  Widget _buildTitle() {
    return Builder(
      builder: (context) => VisaTextView(
        text: S.of(context).rate_visa_go,
        softWrap: true,
        textAlign: TextAlign.center,
        overflow: TextOverflow.visible,
        style: VisaTextStyle.customLarge,
        fontFamily: VisaFontWeight.medium,
        fontSize: Sizes.thirtySixInt.toDouble(),
        customColor: VisaColors.primary,
        colorTheme: VisaTextTheme.customTextColor,
        letterSpacing: -0.72,
        lineHeight: 0.94,
      ),
    );
  }

  Widget _buildRatingSelector(RateUsModel model) {
    return VisaRatingSelector(
      initialRating: model.initialRating.toDouble(),
      assetPathBorder: Assets.iconsEmptyStar,
      assetPathFill: Assets.iconsStar,
      selectedColor: VisaColors.secondaryDark,
      unselectedColor: VisaColors.secondaryDark,
    );
  }

  Widget _buildSubmitButton(BuildContext context, RateUsModel model) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: VisaButton(
        text: S.of(context).submit,
        onPressed: () => _handleSubmitPressed(context, model),
        isDisable: !model.hasChanges,
        fontWeight: VisaFontWeight.medium,
        variant: VisaButtonVariant.primary,
      ),
    );
  }

  Future<void> _handleSubmitPressed(
      BuildContext context, RateUsModel model) async {
    if (model.selectedRating >= 4) {
      await _handleHighRating(context, model);
    } else if (model.selectedRating == 0) {
      _handleNoRating(context);
    } else {
      _handleLowRating(context, model);
    }
  }

  Future<void> _handleHighRating(
      BuildContext context, RateUsModel model) async {
    await model.rateUs2();
    if (context.mounted) {
      _navigateBack(context);
      Utils.rateUsPopup(
        context: context,
        child: const TellUsMore(),
      );
    }
  }

  void _handleNoRating(BuildContext context) {
    showVisaToast(
      context: context,
      title: S.of(context).error,
      subtitle: S.of(context).please_select_rating,
      type: SnackBarType.failure,
    );
    return;
  }

  void _handleLowRating(BuildContext context, RateUsModel model) {
    if (context.mounted) {
      _navigateBack(context);
      AppRouter.router.pushRoute(
        AppRoutes.rateUs,
        extra: model.selectedRating,
      );
    }
  }

  void _navigateBack(BuildContext context) {
    Navigator.of(context).pop();
    if (isDouble != null && isDouble == true) {
      Navigator.of(context).pop();
    }
  }
}
