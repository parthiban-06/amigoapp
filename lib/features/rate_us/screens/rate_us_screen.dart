import 'package:flutter/material.dart';
import 'package:visaamigo/core/base/view/base_view.dart';
import 'package:visaamigo/core/theme/theme.dart';
import 'package:visaamigo/custom_widgets/visa_button.dart';
import 'package:visaamigo/custom_widgets/visa_size_box.dart';
import 'package:visaamigo/custom_widgets/visa_text_field.dart';
import 'package:visaamigo/custom_widgets/visa_textview.dart';
import 'package:visaamigo/di/service_locator.dart' show getIt;
import 'package:visaamigo/features/rate_us/model/rate_us_model.dart'
    show RateUsModel;
import 'package:visaamigo/features/rate_us/widgets/visa_rating_selector.dart'
    show VisaRatingSelector;
import 'package:visaamigo/generated/assets.dart' show Assets;
import 'package:visaamigo/generated/l10n.dart';
import 'package:visaamigo/utils/const_screen_size.dart';

import '../../../custom_widgets/visa_appbar.dart';

class RateUs extends StatefulWidget {
  final int? selectedStars;

  const RateUs({super.key, this.selectedStars});

  @override
  RateUsState createState() => RateUsState();
}

class RateUsState extends State<RateUs> {
  late final RateUsModel rateUsModel;
  late final double heightTen;

  @override
  void initState() {
    super.initState();
    rateUsModel = getIt<RateUsModel>(); // Retrieve once in initState
    rateUsModel.init(widget.selectedStars); // Initialize the model
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    heightTen = AppSizes.ten;
  }

  @override
  Widget build(BuildContext context) {
    return BaseView<RateUsModel>(
      viewModel: rateUsModel,
      setTopSafeArea: false,
      addDefaultPadding: false,
      buildAppBar: VisaAppBar(
        isActionButtonShow: true,
        isCancelWithTextButtonShow: true,
        onCancelPress: () {
          Navigator.of(context).pop();
        },
      ),
      onPageBuilderMobileView: (BuildContext context, RateUsModel viewModel) {
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: AppSizes.dimSmall),
          child: Form(
            key: viewModel.formKey,
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        VisaSizeBox(
                          height: heightTen,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: heightTen),
                          child: VisaTextView(
                            text: S.of(context).rate_visa_go_app,
                            softWrap: true,
                            overflow: TextOverflow.visible,
                            style: VisaTextStyle.customLarge,
                            fontFamily: VisaFontWeight.semibold,
                            fontSize: AppSizes.fontXSmall,
                            customColor: VisaColors.black,
                            colorTheme: VisaTextTheme.customTextColor,
                            letterSpacing: -1,
                          ),
                        ),
                        AppSizes.mediumVS,
                        viewModel.isLoading
                            ? Container()
                            : VisaRatingSelector(
                                initialRating:
                                    viewModel.selectedRating.toDouble(),
                                assetPathBorder: Assets.iconsEmptyStar,
                                assetPathFill: Assets.iconsStar,
                                selectedColor: VisaColors.secondaryDark,
                                unselectedColor: VisaColors.secondaryDark,
                              ),
                        AppSizes.mediumVS,
                        AppSizes.xxsmallVS,
                        viewModel.isLoading
                            ? Container()
                            : VisaTextField(
                                textInputAction: TextInputAction.newline,
                                controller: viewModel.feedbackController,
                                textInputType: TextInputType.multiline,
                                label: S.of(context).how_are_doing,
                                errorText: viewModel.errorText,
                                maxLength: 500,
                                letterSpacing: 0,
                                hPaddingInside: 10,
                                maxLines: 15,
                                minLines: 15,
                                isPassword: false,
                                hint: S.of(context).share_thoughts,
                                onTap: (_) {},
                                onChanged: (_) {},
                                isValid: true,
                                isRequired: false,
                              ),
                        AppSizes.mediumVS,
                      ],
                    ),
                  ),
                ),
                VisaButton(
                  text: S.of(context).submit,
                  height: 54,
                  isDisable: viewModel.isLoading || !viewModel.hasChanges,
                  onPressed: () {
                    viewModel.submitRating();
                  },
                  variant: VisaButtonVariant.primary,
                ),
                VisaSizeBox(
                  height: AppSizes.heightSmall,
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
