import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:visaamigo/core/base/view/base_view.dart';
import 'package:visaamigo/core/theme/theme.dart';
import 'package:visaamigo/custom_widgets/custom_visa_two_button.dart';
import 'package:visaamigo/custom_widgets/visa_textview.dart';
import 'package:visaamigo/features/biometric/providers/biometric_provider_apple.dart';
import 'package:visaamigo/generated/assets.dart';
import 'package:visaamigo/generated/l10n.dart';
import 'package:visaamigo/utils/app_extensions.dart';
import 'package:visaamigo/utils/const_screen_size.dart';

import '../../../custom_widgets/visa_appbar.dart';

class BiometricScreenApple extends StatelessWidget {
  const BiometricScreenApple({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BaseView<BiometricProviderApple>(
      viewModel: BiometricProviderApple(),
      onModelReady: (model) {
        model.init();
      },
      buildAppBar: const VisaAppBar(),
      onPageBuilderMobileView:
          (BuildContext context, BiometricProviderApple viewModel) {
        return Column(
          children: [
            Expanded(
              child: SizedBox(
                width: context.screenWidth,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    AppSizes.mediumVS,
                    Column(
                      children: [
                        SvgPicture.asset(
                          Assets.iconsBiometricsIcon,
                        ),
                        AppSizes.mediumVS,
                        VisaTextView(
                          text: S.of(context).enable_face_id,
                          style: VisaTextStyle.customLarge,
                          fontFamily: VisaFontWeight.semibold,
                          fontSize: AppSizes.fontXSmall,
                          textAlign: TextAlign.center,
                          maxLines: 3,
                          customColor: VisaColors.textTertiary7,
                          colorTheme: VisaTextTheme.customTextColor,
                        ),
                        AppSizes.xxsmallVS,
                        VisaTextView(
                          text: S.of(context).get_faster_access,
                          style: VisaTextStyle.customSmall,
                          fontFamily: VisaFontWeight.regular,
                          fontSize:AppSizes.fontfourteen,
                          overflow: TextOverflow.fade,
                          textAlign: TextAlign.center,
                          customColor: VisaColors.textTertiary5,
                          colorTheme: VisaTextTheme.customTextColor,
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        CustomTwoButtons(
                          leftButtonText: S.of(context).skip,
                          rightButtonText: S.of(context).enable,
                          rightButtonDisable: false,
                          onLeftButtonPressed: () {
                            viewModel.onCancelButton();
                          },
                          onRightButtonPressed: () {
                            viewModel.enableBiometrics();
                          },
                          isRightButtonLoading: false,
                          isLeftButtonLoading: false,
                        ),
                        AppSizes.smallVS,
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
