import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:visaamigo/core/theme/theme.dart';
import 'package:visaamigo/utils/app_extensions.dart';

import '../../../../../custom_widgets/visa_button.dart';
import '../../../../../custom_widgets/visa_textview.dart';
import '../../../../../generated/l10n.dart';
import '../../../../../utils/const_screen_size.dart';
import '../../../providers/ai_chip_group_selector_provider.dart';
import '../../../providers/ai_prompt_personal_preferences_provider.dart';
import 'ai_prompt_list_item.dart';

// ignore: must_be_immutable
class AiPromptsListWidget extends StatefulWidget {
  final AiPromptPersonalPreferencesProvider viewModel;

  const AiPromptsListWidget({super.key, required this.viewModel});

  @override
  State<AiPromptsListWidget> createState() => _AiPromptsListWidgetState();
}

class _AiPromptsListWidgetState extends State<AiPromptsListWidget> {
  late double two;
  bool showAnimation = true;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 3500), () {
      setState(() {
        showAnimation = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final isIOS = Theme.of(context).platform == TargetPlatform.iOS;
    two = AppSizes.twoRadius;
    if (widget.viewModel.listQuestions != null &&
        widget.viewModel.listQuestions!.isEmpty) {
      return const SizedBox.shrink();
    }
    final scrollable = Consumer<AiChipGroupSelectorProvider>(
        builder: (context, viewGroupModel, child) {
      return ListView.builder(
        controller: widget.viewModel.promptsScrollController,
        itemCount: widget.viewModel.listQuestions!.length + 1,
        padding: EdgeInsets.only(
          left: AppSizes.dimSmall,
          right: AppSizes.dimSmall,
        ),
        itemBuilder: (context, index) {
          if (index == widget.viewModel.listQuestions!.length) {
            return Padding(
              padding: const EdgeInsets.only(
                  // top: Sizes.fourInt.h,
                  //bottom: AppSizes.tweentyHeight,
                  //right: Sizes.tenInt.w,
                  ),
              child: Center(
                child: VisaButton(
                  text: s.save,
                  height: AppSizes.fiftySevenInt.toDouble(),
                  width: context.screenWidth,
                  variant: VisaButtonVariant.primary,
                  fontWeight: VisaFontWeight.medium,
                  fontSize: AppSizes.fontMedium,
                  letterSpacing: AppSizes.zero,
                  lineHeight: (25 / 18).toDouble(),
                  borderRadius: AppSizes.sixteenRadius,
                  onPressed: () {
                    widget.viewModel
                        .updatePreferenceOption(viewGroupModel.questions);
                  },
                ),
              ),
            );
          }
          return AiPromptListItem(
            // key: ValueKey(viewModel.listQuestions![index].questionId),
            showAnimation: showAnimation,
            animationDuration: 450 + (800 * index),
            index: index,
            questions: widget.viewModel.listQuestions![index],
            viewModel: widget.viewModel,
          );
        },
      );
    });

    return ChangeNotifierProvider<AiChipGroupSelectorProvider>(
      create: (_) =>
          AiChipGroupSelectorProvider(widget.viewModel.listQuestions!),
      child: Expanded(
        child: Padding(
          padding: EdgeInsets.only(
            right: Sizes.eightInt.w,
            bottom: AppSizes.tweentyHeight,
          ),
          child: ScrollbarTheme(
            data: ScrollbarThemeData(
              crossAxisMargin: AppSizes.zero,
              mainAxisMargin: AppSizes.zero,
              thumbVisibility: const WidgetStatePropertyAll(true),
              trackVisibility: const WidgetStatePropertyAll(true),
              thumbColor: WidgetStateProperty.all(VisaColors.primary),
              trackColor:
                  WidgetStateProperty.all(VisaColors.greyScrollTrackColor),
              trackBorderColor:
                  WidgetStateProperty.all(VisaColors.greyScrollTrackColor),
              thickness: WidgetStateProperty.all(two),
              radius: Radius.circular(two),
            ),
            child: isIOS
                ? CupertinoScrollbar(
                    controller: widget.viewModel.promptsScrollController,
                    thickness: two,
                    thumbVisibility: true,
                    radius: Radius.circular(two),
                    child: scrollable,
                  )
                : Scrollbar(
                    controller: widget.viewModel.promptsScrollController,
                    thumbVisibility: true,
                    thickness: two,
                    radius: Radius.circular(two),
                    child: scrollable,
                  ),
          ),
        ),
      ),

      // Expanded(
      //   child: Column(
      //     children: [
      //
      //       Consumer<AiChipGroupSelectorProvider>(
      //         builder: (context, viewGroupModel, child) {
      //           return ValueListenableBuilder<bool>(
      //             valueListenable: viewModel.isAtBottom,
      //             builder: (context, value, child) {
      //               return AnimatedSwitcher(
      //                 duration: const Duration(milliseconds: 250),
      //                 // Slightly reduced for instant feedback
      //                 switchInCurve: Curves.easeInOut,
      //                 switchOutCurve: Curves.easeInOut,
      //                 transitionBuilder: (child, animation) => FadeTransition(
      //                   opacity: animation, // Smooth fade-in & fade-out
      //                   child: child,
      //                 ),
      //                 child: value
      //                     ? Padding(
      //                         padding: EdgeInsets.only(
      //                           top: ,
      //                           bottom: AppSizes.tweentyHeight,
      //                           right: AppSizes.dimSmall,
      //                           left: AppSizes.dimSmall,
      //                         ),
      //                         child: Center(
      //                           child: VisaButton(
      //                             text: s.save,
      //                             height: Sizes.fiftySevenInt.toDouble(),
      //                             width: context.screenWidth,
      //                             variant: VisaButtonVariant.primary,
      //                             fontWeight: VisaFontWeight.medium,
      //                             fontSize: Sizes.eighteenInt.toDouble(),
      //                             letterSpacing: AppSizes.zero,
      //                             lineHeight: (25 / 18).roundToDouble(),
      //                             borderRadius: Sizes.sixteen,
      //                             onPressed: () {
      //                               viewModel.updatePreferenceOption(
      //                                   viewGroupModel.questions);
      //                             },
      //                           ),
      //                         ),
      //                       )
      //                     : const SizedBox
      //                         .shrink(), // Invisible when `value` is false
      //               );
      //             },
      //           );
      //         },
      //       )
      //     ],
      //   ),
      // ),
    );
  }
}
