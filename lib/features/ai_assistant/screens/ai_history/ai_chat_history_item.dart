import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:visaamigo/core/theme/theme.dart';
import 'package:visaamigo/custom_widgets/visa_svg_icon.dart';
import 'package:visaamigo/custom_widgets/visa_textview.dart';
import 'package:visaamigo/utils/const_screen_size.dart' show AppSizes;
import 'package:visaamigo/utils/theme_extension.dart';

import '../../../../generated/assets.dart';

class ChatHistoryItem extends StatefulWidget {
  final String title;
  final bool isSelected;
  final bool isDeleteHistoryEnable;
  final VoidCallback onTap;

  const ChatHistoryItem({
    super.key,
    required this.title,
    required this.isSelected,
    required this.isDeleteHistoryEnable,
    required this.onTap,
  });

  @override
  ChatHistoryItemState createState() => ChatHistoryItemState();
}

class ChatHistoryItemState extends State<ChatHistoryItem>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true; // ✅ Keeps item alive even when scrolling
  final double sisxteenWidth = AppSizes.dimSmall;
  late double heightSmall;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    heightSmall = AppSizes.heightSmall;
    return Semantics(
      container: true,
      button: true,
      label: widget.title,
      checked: widget.isDeleteHistoryEnable ? widget.isSelected : null,
      enabled: true,
      child: GestureDetector(
        onTap: widget.onTap,
        child: Container(
          padding: EdgeInsets.symmetric(
              horizontal: AppSizes.tweentyWidth, vertical: heightSmall),
          margin: EdgeInsets.only(
              top: AppSizes.sixHeight, bottom: AppSizes.sixHeight),
          decoration: BoxDecoration(
            border: Border.all(
                color: widget.isSelected
                    ? context.theme.primaryColor
                    : context.theme.primaryColor,
                width: 1),
            borderRadius: BorderRadius.circular(16.r),
            color: !(widget.isDeleteHistoryEnable)
                ? Colors.white
                : widget.isSelected
                    ? VisaColors.chatHistorySelectionColor
                    : Colors.white,
          ),
          child: Row(
            children: [
              !(widget.isDeleteHistoryEnable)
                  ? VisaSvgIcon(
                      semantics: false,
                      assetPath: Assets.iconsIcChat,
                      height: heightSmall,
                      width: sisxteenWidth,
                      color: context.theme.primaryColor,
                      setColorFilter: false,
                    )
                  : widget.isSelected
                      ? VisaSvgIcon(
                          semantics: false,
                          assetPath: Assets.iconsIcCheckChat,
                          height: heightSmall,
                          width: sisxteenWidth,
                          setColorFilter: false,
                          color: context.theme.primaryColor,
                        )
                      : VisaSvgIcon(
                          semantics: false,
                          assetPath: Assets.iconsIcUncheckChat,
                          height: heightSmall,
                          width: sisxteenWidth,
                          setColorFilter: false,
                          color: context.theme.primaryColor,
                        ),
              // Checkbox(
              //   value: widget.isSelected,
              //   onChanged: (value) => widget.onTap(),
              // ),
              SizedBox(width: AppSizes.dimXSmall),
              Expanded(
                child: VisaTextView(
                  semantics: false,
                  text: widget.title,
                  maxLines: 3,
                  style: VisaTextStyle.displayBodyL,
                  fontFamily: VisaFontWeight.bold,
                  lineHeight: 1.06,
                  letterSpacing: -0.16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
