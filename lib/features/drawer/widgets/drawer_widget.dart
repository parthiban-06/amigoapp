import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:visaamigo/custom_widgets/text_with_icon.dart';
import 'package:visaamigo/custom_widgets/visa_auto_size_text.dart';
import 'package:visaamigo/custom_widgets/visa_font_family.dart';
import 'package:visaamigo/custom_widgets/visa_svg_icon.dart';
import 'package:visaamigo/generated/l10n.dart';
import 'package:visaamigo/router/app_router.dart';
import 'package:visaamigo/utils/app_extensions.dart';
import 'package:visaamigo/utils/theme_extension.dart';
import 'package:visaamigo/utils/utils.dart';

import '../../../analytics/firebase_analytics_service.dart';
import '../../../core/theme/theme.dart';
import '../../../custom_widgets/visa_textview.dart'
    show VisaFontWeight, VisaTextStyle, VisaTextTheme;
import '../../../generated/assets.dart';
import '../../../utils/const_screen_size.dart' show AppSizes, Sizes;
import '../../select_languages/providers/language_selection_generic_provider.dart';

// ignore: must_be_immutable
class DrawerItemWidget extends StatelessWidget {
  String title;
  final String? semanticTitle;
  int notificationCount;
  final VoidCallback? onItemClick;

  DrawerItemWidget(
      {super.key,
      required this.title,
      required this.onItemClick,
      required this.notificationCount,
      this.semanticTitle});

  @override
  Widget build(BuildContext context) {
    List<String> descList = title.split(" ");
    String lastWord = descList.removeLast();

    return title == S.of(context).notifications && notificationCount > 0
        ? Semantics(
            enabled: true,
            excludeSemantics: true,
            label: S.of(context).notification_count(notificationCount),
            child: tabWidget(
              context: context,
              title: title,
              notificationCount: notificationCount,
              onItemClick: onItemClick,
              semanticTitle: semanticTitle ?? (lastWord + S.of(context).button),
            ),
          )
        : tabWidget(
            context: context,
            title: title,
            notificationCount: notificationCount,
            onItemClick: onItemClick,
            semanticTitle: semanticTitle ?? (lastWord + S.of(context).button),
          );
  }

  Widget tabWidget({
    required BuildContext context,
    required String title,
    required int notificationCount,
    required VoidCallback? onItemClick,
    String? semanticTitle,
  }) {
    List<String> descList = title.split(" ");
    String lastWord = descList.removeLast();
    final padding = AppSizes.dimSmall;
    final fontThirtyTwo = AppSizes.fontThirtyTwo;

    return GestureDetector(
      onTap: () {
        SelectLanguageGenericProvider localLanguageProvider =
            Provider.of<SelectLanguageGenericProvider>(context, listen: false);
        FirebaseAnalyticsService.logEventButtonClick(
            btnName: localLanguageProvider.getKeyFromValue(title),
          parameters: {
            AnalyticsEventConst.PARAM_NAME_UI_ELEMENT_LOCATION: AppRouter.router.state.path ?? "",
          }
        );
        if (onItemClick != null) {
          onItemClick!();
        }
      },
      child: Container(
        width: context.screenWidth,
        color: Colors.transparent,
        // margin: EdgeInsets.all(3),
        padding: EdgeInsets.only(
          left: padding,
          right: padding,
          top: Sizes.twenty,
          bottom: Sizes.twenty,
        ),
        child: Row(
          children: [
            Expanded(
              child: TextWithEndIcon(
                text: descList,
                selected: false,
                textStyle: TextStyle(
                    color: VisaColors.bookingBadgeColor,
                    fontFamily: VisaFontFamily.getFontFamily(
                        VisaFontWeight.bold, false),
                    fontWeight: FontWeight.bold,
                    letterSpacing: -2,
                    height: 1.23,
                    fontSize: fontThirtyTwo),
                widget: Wrap(
                  runAlignment: WrapAlignment.start,
                  alignment: WrapAlignment.start,
                  crossAxisAlignment: WrapCrossAlignment.start,
                  children: [
                    Text(
                      lastWord,
                      semanticsLabel:
                          semanticTitle ?? (lastWord + S.of(context).button),
                      textScaler: TextScaler.linear(
                          Utils.getCappedScale(context, AppSizes.fontfourteen)),
                      style: TextStyle(
                          color: VisaColors.bookingBadgeColor,
                          fontFamily: VisaFontFamily.getFontFamily(
                              VisaFontWeight.bold, false),
                          fontWeight: FontWeight.bold,
                          letterSpacing: -2,
                          height: 1.23,
                          fontSize: fontThirtyTwo),
                    ),
                    AppSizes.xsmallHS,
                    Padding(
                      padding: EdgeInsets.only(top: AppSizes.heightSmall),
                      child: VisaSvgIcon(
                        semantics: false,
                        assetPath: Assets.iconsIcLeftArrow,
                        color: VisaColors.bookingBadgeColor,
                        width: AppSizes.iconXXSmall,
                        height: Sizes.fourteenInt.h,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            (notificationCount > 0)
                ? Container(
                    margin:
                        EdgeInsetsDirectional.only(start: AppSizes.fiveRadius),
                    // height: 26.h,
                    padding: EdgeInsets.all(AppSizes.tenRadius),
                    // width: 26.w,
                    decoration: BoxDecoration(
                        color: context.theme.primaryColor,
                        shape: BoxShape.circle),
                    child: Center(
                      child: VisaAutoSizeText(
                        text: (notificationCount > 99)
                            ? "99+"
                            : "$notificationCount",
                        softWrap: true,
                        overflow: TextOverflow.visible,
                        style: VisaTextStyle.customLarge,
                        fontFamily: VisaFontWeight.semibold,
                        fontSize: 17.sp,
                        maxFontSize: 17.sp,
                        minFontSize: 3,
                        maxLines: 1,
                        customColor: VisaColors.white,
                        colorTheme: VisaTextTheme.customTextColor,
                        letterSpacing: 0,
                      ),
                    ),
                  )
                : const SizedBox.shrink()
          ],
        ),
      ),
    );
  }
}
