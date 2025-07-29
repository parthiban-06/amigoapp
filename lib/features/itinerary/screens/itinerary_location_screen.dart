import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:visaamigo/core/base/view/base_view.dart';
import 'package:visaamigo/core/theme/theme.dart';
import 'package:visaamigo/custom_widgets/visa_size_box.dart';
import 'package:visaamigo/custom_widgets/visa_text_field.dart';
import 'package:visaamigo/custom_widgets/visa_textview.dart';
import 'package:visaamigo/features/itinerary/providers/location_itinerary_provider.dart';
import 'package:visaamigo/generated/assets.dart';
import 'package:visaamigo/generated/l10n.dart';
import 'package:visaamigo/utils/app_const.dart';
import 'package:visaamigo/utils/const_screen_size.dart';

import '../../../custom_widgets/visa_appbar.dart';

class AddItineraryLocation extends StatelessWidget {
  String? location;

  AddItineraryLocation(
    this.location, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BaseView<LocationItineraryProvider>(
      viewModel: LocationItineraryProvider(),
      setTopSafeArea: false,
      addDefaultPadding: false,
      buildAppBar: VisaAppBar(
        isActionButtonShow: true,
        isCancelWithTextButtonShow: true,
        onCancelPress: () {
          Navigator.of(context).pop();
        },
      ),
      onModelReady: (model) {
        model.init(location);
      },
      onPageBuilderMobileView:
          (BuildContext context, LocationItineraryProvider viewModel) {
        return Column(
          children: [
            Padding(
              padding: EdgeInsets.only(
                  top: Sizes.sixInt.h,
                  left: Sizes.sixteenInt.w,
                  right: Sizes.sixteenInt.w),
              child: VisaTextField(
                controller: viewModel.searchLocationText,
                hint: S.of(context).type_location_here,
                underlineInputBorder: false,
                errorText: "",
                fontSize: Sizes.twelveInt.h,
                letterSpacing: 2,
                hintColor: VisaColors.black,
                vPadding: 0,
                isUpperCase: true,
                fontWeight: FontWeight.w500,
                textCapitalization: TextCapitalization.words,
                borderTransparent: true,
                suffixIcon: viewModel.searchLocationText.text.isNotEmpty
                    ? Padding(
                        padding: EdgeInsets.only(left: Sizes.fourteenInt.w),
                        child: InkWell(
                            onTap: () {
                              viewModel.clearSearch();
                            },
                            child: SizedBox(
                              height: 24.h,
                              width: 24.w,
                              child: Center(
                                child: SvgPicture.asset(Assets.iconsIcClose,
                                    height: Sizes.thirteenInt.h,
                                    width: Sizes.thirteenInt.w),
                              ),
                            )),
                      )
                    : const SizedBox(),
                prefixIcon: SizedBox(
                    width: Sizes.thirtyInt.w,
                    child: Align(
                        alignment: Alignment.centerLeft,
                        child: SvgPicture.asset(Assets.iconsIcSearch,
                            width: Sizes.sixteenInt.w))),
                maxLength: AppConst.TEXTFIELD_EMAIL_LENGTH,
                textInputType: TextInputType.name,
                onChanged: (val) {
                  viewModel.searchLocation();
                },
                onSubmitted: (val) {},
                isValid: true,
              ),
            ),
            Divider(
              color: VisaColors.black,
              height: Sizes.oneInt.h,
            ),
            viewModel.placePredictions == null ||
                    viewModel.placePredictions!.results == null ||
                    viewModel.placePredictions!.results!.isEmpty
                ? const SizedBox()
                : Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(right: Sizes.tenInt.w,top: 10),
                      child: ScrollbarTheme(
                        data: ScrollbarThemeData(
                          interactive: true,
                          thumbColor: WidgetStateProperty.all(VisaColors.scrollBarThumb),
                          trackColor: WidgetStateProperty.all(VisaColors.hotelCardEmptyBgColor),
                          trackBorderColor: WidgetStateProperty.all(VisaColors.white),
                          radius:  Radius.circular(Sizes.twenty),
                          thickness: WidgetStateProperty.all(Sizes.nine),
                          minThumbLength: Sizes.twentyNineInt.h,
                          // mainAxisMargin: Sizes.ten,  // vertical padding of thumb
                        ),
                        child: Scrollbar(
                          controller: viewModel.scrollController,
                          thumbVisibility: true,
                          interactive: true,
                          trackVisibility: true,
                          child: Padding(
                            padding: EdgeInsets.only(right: Sizes.twentyInt.w,top: 10),
                            child: ListView.builder(
                                padding: EdgeInsets.zero,
                                controller: viewModel.scrollController,
                                itemCount: viewModel.placePredictions!.results!.length,
                                itemBuilder: (context, index) {
                                  String location = viewModel.placePredictions!.results!
                                          .elementAt(index)
                                          .formattedAddress ??
                                      "";
                                  return Semantics(
                                    container: true,
                                    button: true,
                                    label:
                                        '${viewModel.placePredictions!.results!.elementAt(index).name ?? location}, '
                                        '${viewModel.placePredictions!.results!.elementAt(index).formattedAddress ?? ""}. '
                                        '${S.of(context).double_tap_to_select_location}',
                                    child: InkWell(
                                      onTap: () {
                                        viewModel.getTimeOffset(
                                            "${viewModel.placePredictions!.results!.elementAt(index).name ?? ""}, ${viewModel.placePredictions!.results!.elementAt(index).formattedAddress ?? ""}",
                                            viewModel.placePredictions!.results!
                                                .elementAt(index)
                                                .geometry!
                                                .location!);
                                      },
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.only(
                                                left: Sizes.fortyFive.w,
                                                right: Sizes.fortyFive.w,
                                                top: index != 0 ? Sizes.nineteen.h : Sizes.nine.h,
                                                bottom: Sizes.nineteen.h,
                                            ),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                VisaTextView(
                                                  text: viewModel
                                                          .placePredictions!.results!
                                                          .elementAt(index)
                                                          .name ??
                                                      location,
                                                  semantics: false,
                                                  softWrap: true,
                                                  // maxLines: 1,
                                                  overflow: TextOverflow.visible,
                                                  style: VisaTextStyle.customLarge,
                                                  fontFamily: VisaFontWeight.medium,
                                                  fontSize: Sizes.twelveInt.h,
                                                  lineHeight:
                                                      16.8.h / Sizes.twelveInt.sp,
                                                  customColor: VisaColors.black,
                                                  colorTheme:
                                                      VisaTextTheme.customTextColor,
                                                  letterSpacing: 2,
                                                ),
                                                VisaSizeBox(
                                                  height: Sizes.eight.h,
                                                ),
                                                VisaTextView(
                                                  text: location,
                                                  semantics: false,
                                                  softWrap: true,
                                                  maxLines: 2,
                                                  overflow: TextOverflow.ellipsis,
                                                  style: VisaTextStyle.customLarge,
                                                  fontFamily: VisaFontWeight.regular,
                                                  fontSize: Sizes.twelveInt.h,
                                                  lineHeight: Sizes.sixteenInt.h /
                                                      Sizes.sixteenInt.sp,
                                                  customColor: VisaColors.black,
                                                  colorTheme:
                                                      VisaTextTheme.customTextColor,
                                                  letterSpacing: 0,
                                                ),
                                              ],
                                            ),
                                          ),
                                          Divider(
                                            color: VisaColors.greyBackGround,
                                            thickness: Sizes.one.w,
                                            height: 0,
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                }),
                          ),
                        ),
                      ),
                    ))
          ],
        );
      },
    );
  }
}
