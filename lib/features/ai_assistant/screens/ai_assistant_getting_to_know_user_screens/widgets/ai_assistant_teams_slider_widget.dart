import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:visaamigo/core/theme/theme.dart';
import 'package:visaamigo/custom_widgets/visa_svg_icon.dart';
import 'package:visaamigo/custom_widgets/visa_textview.dart';
import 'package:visaamigo/generated/assets.dart';
import 'package:visaamigo/utils/app_extensions.dart';
import 'package:visaamigo/utils/const_screen_size.dart';
import 'package:visaamigo/utils/responsive_util.dart';
import 'package:visaamigo/utils/theme_extension.dart';
import 'package:visaamigo/utils/utils.dart';

import '../../../../../custom_widgets/visa_auto_resize_textview.dart';
import '../../../../../generated/l10n.dart';
import '../../../providers/ai_assistant_main_provider.dart';

class AiAssistantTeamsSliderWidget extends StatefulWidget {
  final AiAssistantMainProvider provider;

  const AiAssistantTeamsSliderWidget({
    super.key,
    required this.provider,
  });

  @override
  State<AiAssistantTeamsSliderWidget> createState() =>
      _AiAssistantTeamsSliderWidgetState();
}

class _AiAssistantTeamsSliderWidgetState
    extends State<AiAssistantTeamsSliderWidget> {
  @override
  Widget build(BuildContext context) {
    final isDesktopView =
        GetIt.I<ResponsiveUtil>(param1: context).isDesktop(context: context);

    return ExcludeSemantics(
      child: Stack(
        children: [
          Container(
            height: Sizes.sixtyOne,
            decoration: BoxDecoration(
              color: context.theme.primaryColor,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                VisaSvgIcon(
                  semantics: false,
                  assetPath: Assets.iconsLineDown,
                  color: VisaColors.greyDotLight,
                  height: Sizes.six,
                  width: context.screenWidth,
                  fit: BoxFit.fitWidth,
                  padding: EdgeInsets.only(
                    top: Sizes.two,
                    right: Sizes.six,
                  ),
                ),
                VisaSvgIcon(
                  semantics: false,
                  assetPath: Assets.iconsLineDown,
                  color: VisaColors.greyDotLight,
                  height: Sizes.six,
                  width: context.screenWidth,
                  fit: BoxFit.fitWidth,
                  padding: EdgeInsets.only(
                    bottom: Sizes.two,
                    right: Sizes.six,
                  ),
                ),
              ],
            ),
          ),
          isDesktopView ? _sliderWidget(0.12) : _sliderWidget(0.5)
        ],
      ),
    );
  }

  Widget _sliderWidget(double viewportFraction) =>
      NotificationListener<ScrollEndNotification>(
        onNotification: (scrollEnd) {
          if (scrollEnd.metrics is PageMetrics) {
            Utils.logPrint(
                'currentIndex>>> \\${widget.provider.teamSelectedIndex}');

            Future.delayed(const Duration(milliseconds: 150), () {
              if (mounted) {
                widget.provider.setContext(context);
                widget.provider.getSelectedIndex(
                  widget.provider.teamsList![widget.provider.teamSelectedIndex]
                      .name!,
                );
              }
            });
          }
          return true;
        },
        child: CarouselSlider.builder(
          itemCount: widget.provider.teamsList!.length,
          carouselController: widget.provider.carouselController,
          options: CarouselOptions(
            height: Sizes.sixtyOneInt.h,
            viewportFraction: viewportFraction,
            initialPage: widget.provider.teamSelectedIndex,
            enlargeStrategy: CenterPageEnlargeStrategy.zoom,
            enableInfiniteScroll: true,
            enlargeCenterPage: true,
            enlargeFactor: 0.1,
            animateToClosest: true,
            // Ensures scrolling stops at closest
            padEnds: true,
            pageSnapping: false,
            // Disabled so we control the snapping manually
            scrollPhysics: const BouncingScrollPhysics(),
            autoPlayCurve: Curves.easeOutExpo,
            autoPlayAnimationDuration: const Duration(milliseconds: 500),
            scrollDirection: Axis.horizontal,
            onPageChanged: (index, reason) {
              // widget.provider.getSelectedIndex(widget.provider.teamsList![index].name!);
              widget.provider.changeTeam(index);
            },
          ),
          itemBuilder: (context, itemIndex, pageViewIndex) {
            bool isSelected = widget.provider.teamSelectedIndex == itemIndex;
            final teamName = Utils.getErrorMessageFromString(
              widget.provider.teamsList![itemIndex].key!,
            ).toUpperCase();
            String semanticsLabel = isSelected
                ? teamName
                : "$teamName, ${S.of(context).double_tap_to_select}";

            return Align(
              alignment: Alignment.center,
              child: Semantics(
                selected: widget.provider.hasUserInteracted && isSelected,
                focused: widget.provider.hasUserInteracted && isSelected,
                label: semanticsLabel,
                excludeSemantics: true,
                container: true,
                child: GestureDetector(
                  onTap: () {
                    widget.provider.getSelectedIndex(
                        widget.provider.teamsList![itemIndex].name!);
                  },
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: AppSizes.zero),
                    child: SizedBox(
                      width: isSelected
                          ? context.screenWidth * 0.5
                          : context.screenWidth * 0.3,
                      // color: Colors.grey,
                      child: VisaAutoCompleteTextView(
                        text: teamName,
                        textLength: null,
                        style: VisaTextStyle.displayTitleSmall,
                        fontFamily: VisaFontWeight.bold,
                        colorTheme: VisaTextTheme.customTextColor,
                        maxLines: isSelected ? 2 : 1,
                        minFontSize: isSelected ? 8 : 20.sp,
                        customColor: isSelected
                            ? VisaColors.secondary
                            : VisaColors.blueTextLight,
                        letterSpacing: Sizes.three,
                        lineHeight: Sizes.twentyFive,
                        softWrap: true,
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      );
}

class DoubleCurvedHeaderClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();

    // Start point
    path.moveTo(0, size.height * 0.30); // Start from left side, 25% down

    // Top outer curve (convex)
    path.quadraticBezierTo(
      size.width * 0.5, // Control point x
      0, // Control point y
      size.width, // End point x
      size.height * 0.30, // End point y
    );

    // Right side line
    path.lineTo(size.width, size.height * 0.75);

    // Bottom inner curve (concave)
    path.quadraticBezierTo(
      size.width * 0.5, // Control point x
      size.height * 0.5, // Control point y - moved up to create inward curve
      0, // End point x
      size.height * 0.75, // End point y
    );

    // Close the path
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
