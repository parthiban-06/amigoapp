import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:visaamigo/core/theme/theme.dart';
import 'package:visaamigo/custom_widgets/visa_button.dart';
import 'package:visaamigo/custom_widgets/visa_textview.dart';
import 'package:visaamigo/generated/l10n.dart';
import 'package:visaamigo/utils/app_extensions.dart';
import 'package:visaamigo/utils/const_screen_size.dart';

class FirstTimeTutorialView extends StatefulWidget {
  final String mainTitle;
  final String desc;
  final bool showNext;
  final bool showBack;
  final Function next;
  final bool tooltipPosition;
  final Function close;
  final Function previous;

  const FirstTimeTutorialView(
      {super.key,
      required this.next,
      required this.close,
      required this.mainTitle,
      required this.desc,
      required this.showNext,
      required this.previous,
      required this.showBack,
      required this.tooltipPosition});

  @override
  State<FirstTimeTutorialView> createState() => _FirstTimeTutorialView1State();
}

class _FirstTimeTutorialView1State extends State<FirstTimeTutorialView> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        widget.tooltipPosition
            ? Padding(
                padding: EdgeInsets.symmetric(horizontal: 15.w),
                child: CustomPaint(
                  size: Size(15.w, 15.h), // Width & Height 10
                  painter: TrianglePainter(context: context),
                ),
              )
            : const SizedBox(),
        Container(
          width: (context.screenWidth * 0.825).w,
          // height: 200.h,
          padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 5.h),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary,
            borderRadius: BorderRadius.all(
              Radius.circular(15.r),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.centerRight,
                child: IconButton(
                  onPressed: () {
                    widget.close();
                  },
                  icon: const Icon(
                    Icons.close,
                    color: Colors.white,
                  ),
                ),
              ),
              VisaTextView(
                text: widget.mainTitle,
                style: VisaTextStyle.bodyLarge,
                customColor: VisaColors.white,
                colorTheme: VisaTextTheme.customTextColor,
              ),
              AppSizes.xxsmallVS,
              VisaTextView(
                text: widget.desc,
                style: VisaTextStyle.bodyMedium,
                customColor: VisaColors.white,
                overflow: TextOverflow.fade,
                colorTheme: VisaTextTheme.customTextColor,
              ),
              AppSizes.xxsmallVS,
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  !widget.showBack
                      ? const SizedBox()
                      : TextButton(
                          onPressed: () {
                            widget.previous();
                          },
                          child: VisaTextView(
                            text: S.of(context).back,
                            style: VisaTextStyle.bodyMedium,
                            customColor: VisaColors.white,
                            overflow: TextOverflow.fade,
                            colorTheme: VisaTextTheme.customTextColor,
                          ),
                        ),
                  AppSizes.xxsmallVS,
                  !widget.showNext
                      ? const SizedBox()
                      : Align(
                          alignment: Alignment.centerRight,
                          child: VisaButton(
                            onPressed: () {
                              widget.next();
                            },
                            text: S.of(context).next,
                            width: 100.w,
                            height: AppSizes.heightFourty,
                            variant: VisaButtonVariant.black,
                          ),
                        ),
                ],
              ),
              AppSizes.xxsmallVS,
            ],
          ),
        ),
        !widget.tooltipPosition
            ? Padding(
                padding: EdgeInsets.symmetric(horizontal: 15.w),
                child: Transform.rotate(
                  angle: 180 * (pi / 180),
                  child: CustomPaint(
                    size: Size(15.w, 15.h), // Width & Height 10
                    painter: TrianglePainter(context: context),
                  ),
                ),
              )
            : const SizedBox(),
      ],
    );
  }
}

class TrianglePainter extends CustomPainter {
  final BuildContext context;

  TrianglePainter({required this.context});

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Theme.of(context).colorScheme.primary
      ..style = PaintingStyle.fill;

    Path path = Path()
      ..moveTo(size.width / 2, 0) // Top point
      ..lineTo(size.width, size.height) // Bottom right
      ..lineTo(0, size.height) // Bottom left
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
