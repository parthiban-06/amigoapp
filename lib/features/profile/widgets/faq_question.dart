import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:visaamigo/core/theme/theme.dart';
import 'package:visaamigo/custom_widgets/visa_textview.dart';
import 'package:visaamigo/features/profile/model/faq_model.dart';
import 'package:visaamigo/features/profile/widgets/dynamic_text_with_link.dart';
import 'package:visaamigo/generated/assets.dart';
import 'package:visaamigo/utils/app_extensions.dart';
import 'package:visaamigo/utils/const_screen_size.dart';

class FaqQuestion extends StatefulWidget {
  final Faq faq;

  const FaqQuestion({super.key, required this.faq});

  @override
  State<FaqQuestion> createState() => _FaqQuestionState();
}

class _FaqQuestionState extends State<FaqQuestion> {
  bool show = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: () {
            setState(() {
              show = !show;
            });
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: context.screenWidth * 0.75,
                child: VisaTextView(
                  text: widget.faq.questionText,
                  softWrap: true,
                  overflow: TextOverflow.visible,
                  style: VisaTextStyle.customLarge,
                  fontFamily: VisaFontWeight.semibold,
                  fontSize: Sizes.twentyTwoInt.toDouble(),
                  customColor: VisaColors.black,
                  lineHeight: (Sizes.twentyFourInt.toDouble() /
                          Sizes.twentyTwoInt.toDouble())
                      .h,
                  colorTheme: VisaTextTheme.customTextColor,
                  letterSpacing: -1,
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                    vertical: Sizes.tenInt.h, horizontal: Sizes.tenInt.h),
                child: SvgPicture.asset(
                    show == true ? Assets.iconsMoveDown : Assets.iconsMoveUp,
                    height: Sizes.tenInt.toDouble().h,
                    width: 16.36.w),
              ),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(
            vertical: Sizes.twentyInt.h,
          ),
          child: Divider(
            height: Sizes.oneInt.h,
            color: VisaColors.greyBackGround,
          ),
        ),
        show == true
            ? Padding(
                padding: EdgeInsets.only(
                  bottom: Sizes.twentyInt.h,
                  left: Sizes.twentyInt.h,
                  right: Sizes.twentyInt.h,
                ),
                child: DynamicTextWithLinks(input: widget.faq.answerText),
              )
            : const SizedBox()
      ],
    );
  }
}
