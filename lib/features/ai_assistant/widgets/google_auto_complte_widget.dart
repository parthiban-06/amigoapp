import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:visaamigo/utils/app_extensions.dart';

import '../../../core/theme/theme.dart';
import '../../../custom_widgets/visa_font_family.dart';
import '../../../custom_widgets/visa_text_field.dart';
import '../../../custom_widgets/visa_textview.dart';
import '../../../generated/assets.dart';
import '../../../generated/l10n.dart';
import '../../../utils/app_const.dart';
import '../../../utils/const_screen_size.dart';
import '../../../utils/utils.dart';
import '../providers/google_places_provider.dart';

class GooglePlacesAutocompleteField extends StatelessWidget {
  final String hint;
  final Function(String placeId, String placeName)? onPlaceSelected;

  const GooglePlacesAutocompleteField({
    super.key,
    this.hint = 'Search for a city',
    this.onPlaceSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<GooglePlacesProvider>(
      builder: (context, aiGoogleAutoCompleteProvider, child) {
        return Stack(
          children: [
            Column(
              children: [
// Search TextField
                VisaTextField(
                  controller: aiGoogleAutoCompleteProvider.searchController,
                  hint: S.of(context).type_location_here,
                  underlineInputBorder: true,
                  errorText: "",
                  focusNode: aiGoogleAutoCompleteProvider.focusNode,
                  labelStyle: TextStyle(
                    color: Colors.black,
                    fontSize: FontSizes(context).displayBodyXs,
                    fontFamily: VisaFontFamily.getFontFamily(
                        VisaFontWeight.medium, false),
                    fontWeight: FontWeight.w500,
                    height: 1.40,
                    letterSpacing: 2,
                  ),
                  suffixIcon: aiGoogleAutoCompleteProvider.showClearButton
                      ? InkWell(
                          onTap: () {
                            aiGoogleAutoCompleteProvider.clearSearch();
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(right: 10).r,
                            child: SvgPicture.asset(Assets.iconsIcClose,
                                width: 12.75.w),
                          ))
                      : aiGoogleAutoCompleteProvider.isLoading
                          ? Container(
                              margin: const EdgeInsets.all(12).r,
                              width: AppSizes.dimMedium,
                              height: AppSizes.heightTweentyFour,
                              child: const CircularProgressIndicator(
                                strokeWidth: 2,
                              ),
                            )
                          : null,
                  prefixIcon:
                      SvgPicture.asset(Assets.iconsSearchIcon, width: 18.w),
                  maxLength: AppConst.TEXTFIELD_EMAIL_LENGTH,
                  textInputType: TextInputType.emailAddress,
                  onChanged: (val) {
                    Utils.logPrint("val chane $val");
                    // viewModel.searchLocation();
                  },
                  onSubmitted: (_) {
                    // viewModel.searchLocation();
                  },
                  isValid: true,
                ),

// Predictions List
                if (aiGoogleAutoCompleteProvider.predictions.isNotEmpty &&
                    aiGoogleAutoCompleteProvider.focusNode.hasFocus)
                  Container(
                    height: context.screenHeight * 0.4.h,
                    width: context.screenWidth,
                    padding: EdgeInsets.symmetric(
                        horizontal: 0, vertical: AppSizes.ten),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          VisaColors.error,
                          VisaColors.black.withAlpha(0),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        stops: const [0.6, 1],
                      ),
                    ),
                    margin: const EdgeInsets.only(top: 5),
                    // constraints: BoxConstraints(
                    //   maxHeight: 300,
                    // ),
                    child: ListView.builder(
                      padding: EdgeInsets.zero,
                      shrinkWrap: true,
                      itemCount:
                          aiGoogleAutoCompleteProvider.predictions.length,
                      // separatorBuilder: (context, index) => Divider(height: 1),
                      itemBuilder: (context, index) {
                        final prediction =
                            aiGoogleAutoCompleteProvider.predictions[index];
                        return ListTile(
                          dense: true,
                          title: VisaTextView(
                            text: prediction.description.toUpperCase(),
                            softWrap: true,
                            overflow: TextOverflow.visible,
                            style: VisaTextStyle.customLarge,
                            fontSize: 12.sp,
                            letterSpacing: 2,
                            fontFamily: VisaFontWeight.medium,
                            customColor: VisaColors.black,
                            colorTheme: VisaTextTheme.customTextColor,
                          ) /*Text(prediction.description ?? '')*/,
                          onTap: () {
                            aiGoogleAutoCompleteProvider.selectPlace(
                              prediction.placeId ?? '',
                              prediction.description ?? '',
                            );

                            if (onPlaceSelected != null) {
                              onPlaceSelected!(
                                prediction.placeId ?? '',
                                prediction.description ?? '',
                              );
                            }

                            aiGoogleAutoCompleteProvider.focusNode.unfocus();
                          },
                        );
                      },
                    ),
                  ),
              ],
            )
          ],
        );
      },
    );
  }
}
