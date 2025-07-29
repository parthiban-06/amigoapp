import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:visaamigo/core/theme/theme.dart';
import 'package:visaamigo/custom_widgets/visa_size_box.dart';
import 'package:visaamigo/custom_widgets/visa_snack_bar.dart';
import 'package:visaamigo/custom_widgets/visa_svg_icon.dart';
import 'package:visaamigo/custom_widgets/visa_textview.dart';
import 'package:visaamigo/generated/assets.dart';
import 'package:visaamigo/generated/l10n.dart';
import 'package:visaamigo/utils/app_const.dart';
import 'package:visaamigo/utils/const_screen_size.dart';
import 'package:visaamigo/utils/utils.dart';

class WebViewAppbar extends StatelessWidget {
  final String url;
  final bool show;

  const WebViewAppbar({super.key, required this.url, required this.show});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: InkWell(
        onTap: () {
          Navigator.of(context).pop();
        },
        child: Center(
          child: VisaSvgIcon(
            height: Sizes.sixteenInt.h,
            width: Sizes.sixteenInt.w,
            assetPath: Assets.iconsIcClose,
            color: VisaColors.black,
          ),
        ),
      ),
      centerTitle: true,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          VisaTextView(
            text: Utils.getDomainName(url).toLowerCase(),
            softWrap: true,
            overflow: TextOverflow.visible,
            style: VisaTextStyle.customLarge,
            fontFamily: VisaFontWeight.medium,
            fontSize: Sizes.twelve.h,
            customColor: VisaColors.black,
            colorTheme: VisaTextTheme.customTextColor,
            letterSpacing: 0,
          ),
          VisaSizeBox(
            height: Sizes.twoInt.h,
          ),
          VisaTextView(
            text: S.of(context).visa_go,
            softWrap: true,
            overflow: TextOverflow.visible,
            style: VisaTextStyle.customLarge,
            fontFamily: VisaFontWeight.medium,
            fontSize: Sizes.elevenInt.h,
            customColor: VisaColors.webViewGrey,
            colorTheme: VisaTextTheme.customTextColor,
            letterSpacing: 0,
          ),
        ],
      ),
      actions: [
        show == false
            ? const SizedBox()
            : Padding(
                padding: EdgeInsets.only(right: Sizes.sixteenInt.w),
                child: PopupMenuButton(
                  color: Colors.grey.shade50,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                        Sizes.twentyInt.r), // using screen utils or similar
                  ),
                  constraints: BoxConstraints(
                      maxWidth: Sizes.twoHundredInt.w,
                      minWidth: Sizes.fiftyInt.w),
                  child: Icon(
                    Icons.more_horiz,
                    size: Sizes.twentyFourInt.w,
                  ),
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      value: AppConst.copyUrl,
                      child: SizedBox(
                        width: Sizes.oneHundredFiftyInt.w,
                        height: Sizes.sixtyInt.h,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(
                                  left: Sizes.fiveInt.w, right: Sizes.tenInt.w),
                              child: VisaSvgIcon(
                                height: Sizes.twenty.h,
                                width: Sizes.twenty.w,
                                assetPath: Assets.iconsIcCopy,
                                color: VisaColors.black,
                              ),
                            ),
                            VisaTextView(
                              text: S.of(context).copy_url,
                              softWrap: true,
                              overflow: TextOverflow.visible,
                              style: VisaTextStyle.customLarge,
                              fontFamily: VisaFontWeight.medium,
                              fontSize: Sizes.fourteen.h,
                              customColor: VisaColors.black,
                              colorTheme: VisaTextTheme.customTextColor,
                              letterSpacing: 0,
                            ),
                          ],
                        ),
                      ),
                    ),
                    PopupMenuItem(
                      value: AppConst.externalBrowser,
                      child: SizedBox(
                        width: Sizes.twoHundredInt.w,
                        height: Utils.getFontSize(context)
                            ? Sizes.sixtyInt.h
                            : Sizes.fortyInt.h,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(
                                  left: Sizes.twoInt.w, right: Sizes.tenInt.w),
                              child: Icon(
                                Icons.output,
                                size: Sizes.twentyFourInt.h,
                              ),
                            ),
                            Expanded(
                              child: VisaTextView(
                                text: S.of(context).open_in_external_browser,
                                softWrap: true,
                                overflow: TextOverflow.visible,
                                style: VisaTextStyle.customLarge,
                                fontFamily: VisaFontWeight.medium,
                                fontSize: Sizes.fourteen.h,
                                customColor: VisaColors.black,
                                colorTheme: VisaTextTheme.customTextColor,
                                letterSpacing: 0,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                  onSelected: (_) {
                    if (_ == AppConst.copyUrl) {
                      Clipboard.setData(ClipboardData(text: url));
                      visaSnackBar(
                          context: context,
                          title: S.of(context).success,
                          subtitle: S.of(context).copied,
                          showAtBottom: true);
                    } else if (_ == AppConst.externalBrowser) {
                      Utils.openExternalApplication(url, "");
                    }
                  },
                ),
              )
      ],
    );
  }
}
