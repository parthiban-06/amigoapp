import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:visaamigo/core/theme/theme.dart';
import 'package:visaamigo/custom_widgets/visa_button.dart';
import 'package:visaamigo/custom_widgets/visa_size_box.dart';
import 'package:visaamigo/custom_widgets/visa_svg_icon.dart';
import 'package:visaamigo/custom_widgets/visa_textview.dart';
import 'package:visaamigo/generated/assets.dart';
import 'package:visaamigo/generated/l10n.dart';
import 'package:visaamigo/utils/app_extensions.dart';
import 'package:visaamigo/utils/const_screen_size.dart';

class NoInternetScreen extends StatefulWidget {
  final Future<bool> Function() onPressed;

  const NoInternetScreen({super.key, required this.onPressed});

  @override
  State<NoInternetScreen> createState() => _NoInternetScreenState();
}

class _NoInternetScreenState extends State<NoInternetScreen> {
  bool _isLoading = false;

  void _handleTryAgain() async {
    setState(() {
      _isLoading = true;
    });

    final result = await widget.onPressed();

    if (!mounted) return;

    if (result) {
      if (Navigator.canPop(context)) {
        Navigator.of(context).pop();
      }
    } else {
      setState(() {
        _isLoading = false;
      });
    }
  }

  late double thirtyWidth;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    thirtyWidth = AppSizes.thirtyWidth;
  }

  Widget _buildBottomWidget() {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(VisaColors.primary),
        ),
      );
    }

    return VisaButton(
      text: S.of(context).try_again_only,
      onPressed: _handleTryAgain,
      height: 57,
      width: context.screenWidth,
      fontWeight: VisaFontWeight.medium,
      variant: VisaButtonVariant.primary,
      lineHeight: 1.39,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: context.screenWidth,
        height: context.screenHeight,
        color: VisaColors.white,
        padding: EdgeInsets.symmetric(
          vertical: AppSizes.tweentyHeight,
          horizontal: AppSizes.dimSmall,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  VisaSvgIcon(
                    assetPath: Assets.iconsNoInternet,
                    height: AppSizes.heightFiftyFive,
                    width: AppSizes.fiftyFiveWidth,
                    useWithoutColor: true,
                  ),
                  VisaSizeBox(height: 20.h),
                  VisaTextView(
                    text: S.of(context).no_internet_connect,
                    softWrap: true,
                    overflow: TextOverflow.visible,
                    fontFamily: VisaFontWeight.bold,
                    customColor: VisaColors.black,
                    fontSize: AppSizes.fontSmall,
                    colorTheme: VisaTextTheme.customTextColor,
                    textAlign: TextAlign.center,
                    lineHeight: 0.72,
                    letterSpacing: -0.72,
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      left: thirtyWidth,
                      right: thirtyWidth,
                      top: AppSizes.ten,
                    ),
                    child: VisaTextView(
                      text: S.of(context).check_connection,
                      softWrap: true,
                      overflow: TextOverflow.visible,
                      fontFamily: VisaFontWeight.semibold,
                      customColor: VisaColors.black,
                      fontSize: AppSizes.fontXSmall,
                      colorTheme: VisaTextTheme.customTextColor,
                      textAlign: TextAlign.center,
                      lineHeight: 1.04,
                      letterSpacing: -1,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: AppSizes.heightFiftySeven,
              width: context.screenWidth,
              child: _buildBottomWidget(),
            ),
          ],
        ),
      ),
    );
  }
}
