import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:visaamigo/core/base/view/base_view.dart';
import 'package:visaamigo/core/theme/theme.dart';
import 'package:visaamigo/custom_widgets/visa_button.dart';
import 'package:visaamigo/custom_widgets/visa_size_box.dart';
import 'package:visaamigo/custom_widgets/visa_svg_icon.dart';
import 'package:visaamigo/custom_widgets/visa_textview.dart';
import 'package:visaamigo/features/companion/providers/add_companion_provider.dart';
import 'package:visaamigo/generated/assets.dart';
import 'package:visaamigo/generated/l10n.dart';
import 'package:visaamigo/utils/app_extensions.dart';
import 'package:visaamigo/utils/const_screen_size.dart';

import '../../../analytics/firebase_analytics_service.dart';

class DeleteCompanion extends StatefulWidget {
  final String companionId;

  const DeleteCompanion({
    super.key,
    required this.companionId,
  });

  @override
  State<DeleteCompanion> createState() => _DeleteCompanionState();
}

class _DeleteCompanionState extends State<DeleteCompanion> {
  late AddCompanionProvider addCompanionProvider;
  late double tweentyWidth;
  late double tweentyFourHeight;
  late double fontfourteen;
  late double lineHeight;

  @override
  void initState() {
    super.initState();
    // Retrieve AddCompanionProvider using GetIt
    addCompanionProvider = GetIt.I<AddCompanionProvider>();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    tweentyWidth = AppSizes.tweentyWidth;
    tweentyFourHeight = AppSizes.heightTweentyFour;
    fontfourteen = AppSizes.fontfourteen;
    lineHeight = 18.0.h / 14.sp;
  }

  @override
  Widget build(BuildContext context) {
    return BaseView<AddCompanionProvider>(
      viewModel: addCompanionProvider,
      onModelReady: (model) {
        // Perform any initialization if needed
      },
      addDefaultPadding: false,
      setTopSafeArea: false,
      screenBackgroundColor: VisaColors.transparent,
      onPageBuilderMobileView:
          (BuildContext context, AddCompanionProvider viewModel) {
        return Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: AppSizes.dimSmall),
            child: Semantics(
              enabled: true,
              container: true,
              focused: true,
              focusable: true,
              label:
                  "${S.of(context).dialog},${S.of(context).delete_your_companion},${S.of(context).upon_deletion_your_companion},${S.of(context).ticket_can_still_be},${S.of(context).close}${S.of(context).button},${S.of(context).delete}}${S.of(context).button}",
              child: Container(
                width: context.screenWidth,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(AppSizes.tenRadius),
                    color: VisaColors.lightRed),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: tweentyWidth),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      VisaSizeBox(
                        height: tweentyFourHeight,
                      ),
                      Semantics(
                        enabled: true,
                        label: S.of(context).close.toUpperCase(),
                        button: true,
                        child: InkWell(
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              VisaSvgIcon(
                                semantics: false,
                                height: 8.5.h,
                                width: 8.5.w,
                                assetPath: Assets.iconsIcClose,
                                color: VisaColors.black,
                              ),
                              VisaSizeBox(
                                width: 4.w,
                              ),
                              VisaTextView(
                                semantics: false,
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
                      ),
                      VisaSizeBox(
                        height: tweentyFourHeight,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: tweentyWidth),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            VisaSvgIcon(
                              semantics: false,
                              height: Sizes.sixty.h,
                              width: Sizes.sixty.w,
                              assetPath: Assets.iconsIcDeleteRed,
                              setColorFilter: false,
                            ),
                            VisaSizeBox(
                              height: AppSizes.tweentyHeight,
                            ),
                            VisaTextView(
                              text: S.of(context).delete_your_companion,
                              softWrap: true,
                              overflow: TextOverflow.visible,
                              textAlign: TextAlign.center,
                              style: VisaTextStyle.customLarge,
                              fontFamily: VisaFontWeight.medium,
                              fontSize: AppSizes.fontSmall,
                              customColor: VisaColors.black,
                              colorTheme: VisaTextTheme.customTextColor,
                              letterSpacing: 0,
                            ),
                            VisaSizeBox(
                              height: AppSizes.tweentyHeight,
                            ),
                            VisaTextView(
                              text: S.of(context).upon_deletion_your_companion,
                              softWrap: true,
                              overflow: TextOverflow.visible,
                              textAlign: TextAlign.center,
                              style: VisaTextStyle.customLarge,
                              fontFamily: VisaFontWeight.medium,
                              fontSize: fontfourteen,
                              lineHeight: lineHeight,
                              customColor: VisaColors.black,
                              colorTheme: VisaTextTheme.customTextColor,
                              letterSpacing: 0,
                            ),
                            VisaSizeBox(
                              height: AppSizes.tweentyHeight,
                            ),
                            VisaTextView(
                              text: S.of(context).ticket_can_still_be,
                              softWrap: true,
                              overflow: TextOverflow.visible,
                              textAlign: TextAlign.center,
                              style: VisaTextStyle.customLarge,
                              fontFamily: VisaFontWeight.medium,
                              fontSize: fontfourteen,
                              lineHeight: lineHeight,
                              customColor: VisaColors.black,
                              colorTheme: VisaTextTheme.customTextColor,
                              letterSpacing: 0,
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: AppSizes.heightTweentyFour),
                              child: VisaButton(
                                text: S.of(context).delete,
                                onPressed: () {
                                  FirebaseAnalyticsService.logEvent(
                                      eventName:
                                          "editCompanion_deleteCompanion_popupconfirm",
                                      parameters: {
                                        AnalyticsEventConst
                                                .PARAM_NAME_UI_ELEMENT:
                                            "delete_companion",
                                        AnalyticsEventConst
                                                .PARAM_NAME_UI_ELEMENT_LOCATION:
                                            "delete_companion_confirm"
                                      });
                                  viewModel.deleteCompanion(widget.companionId);
                                },
                                isDisable: false,
                                fontWeight: VisaFontWeight.medium,
                                variant: VisaButtonVariant.delete,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
