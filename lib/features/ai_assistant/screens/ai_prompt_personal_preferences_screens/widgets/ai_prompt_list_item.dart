import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:visaamigo/features/ai_assistant/models/ai_get_preferences_questions_model.dart';
import 'package:visaamigo/features/ai_assistant/screens/ai_assistant_getting_to_know_user_screens/widgets/ai_assistant_animated_text.dart';
import 'package:visaamigo/generated/assets.dart';

import '../../../../../core/theme/theme.dart';
import '../../../../../custom_widgets/visa_custom_chip_wrap_widget.dart';
import '../../../../../custom_widgets/visa_row_items_widget.dart';
import '../../../../../custom_widgets/visa_textview.dart';
import '../../../../../utils/const_screen_size.dart';
import '../../../../../utils/utils.dart';
import '../../../providers/ai_chip_group_selector_provider.dart';
import '../../../providers/ai_prompt_personal_preferences_provider.dart';

class AiPromptListItem extends StatefulWidget {
  final int index;
  final Questions questions;
  final int? animationDuration;
  final bool? showAnimation;
  final AiPromptPersonalPreferencesProvider viewModel;

  const AiPromptListItem({
    super.key,
    required this.index,
    required this.questions,
    required this.viewModel,
    this.animationDuration,
    this.showAnimation,
  });

  @override
  State<AiPromptListItem> createState() => _AiPromptListItemState();
}

class _AiPromptListItemState extends State<AiPromptListItem> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        right: AppSizes.dimXSmall,
        bottom: AppSizes.thirtyTwoHeight,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          VisaAnimatedText(
            showAnimation: widget.showAnimation,
            delay: Duration(milliseconds: widget.animationDuration ?? 0),
            child: VisaRowItemsWidget(
              iconPath: Assets.iconsEva,
              iconColor: VisaColors.black,
              text: Utils.getErrorMessageFromString(
                  widget.questions.questionKey!),
              style: VisaTextStyle.displayTitleSmall,
              colorTheme: VisaTextTheme.customTextColor,
              customColor: VisaColors.black,
              fontFamily: VisaFontWeight.bold,
              lineHeight: (21 / 20).toDouble(),
              letterSpacing: -1,
            ),
          ),
          AppSizes.smallVS,
          Padding(
            padding: EdgeInsets.only(left: Sizes.twentyFourInt.w),
            child: Consumer<AiChipGroupSelectorProvider>(
              builder: (context, chipProvider, _) {
                final questions = chipProvider.questions;
                return VisaCustomChipWrapWidget(
                  showAnimation: widget.showAnimation,
                  animationDuration: widget.animationDuration,
                  parentIndex: widget.index,
                  chips: questions[widget.index].options!,
                  onChipTap: (parentIndex, chipIndex) {
                    chipProvider.toggleChipSelection(parentIndex, chipIndex);
                  },
                  spacing: 8,
                  runSpacing: 1,
                  borderRadius: AppSizes.fifty,
                  borderWidth: 1,
                  padding: EdgeInsets.symmetric(
                    horizontal: AppSizes.tweleveWidth,
                    vertical: AppSizes.eightHeight,
                  ),
                  textStyle: VisaTextStyle.displayBodyS,
                  selectedFontWeight: FontWeight.w500,
                  unselectedFontWeight: FontWeight.w500,
                  selectedTextColor: VisaColors.white,
                  unselectedTextColor: VisaColors.black,
                  borderColor: VisaColors.primary,
                  lineHeight: (18 / 14).toDouble(),
                  selectedGradient: const LinearGradient(
                    begin: Alignment(-0.98, 0.17),
                    end: Alignment(0.98, -0.17),
                    colors: [
                      VisaColors.primary,
                      VisaColors.blueTextLight,
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// class AiPromptListItem extends StatelessWidget {
//   final int index;
//   final Questions questions;
//   final AiPromptPersonalPreferencesProvider viewModel;
//
//   const AiPromptListItem({
//     super.key,
//     required this.index,
//     required this.questions,
//     required this.viewModel,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: EdgeInsets.only(
//         right: Sizes.fifteenInt.w,
//         top: Sizes.thirtyEightInt.h,
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         mainAxisAlignment: MainAxisAlignment.start,
//         children: [
//           VisaRowItemsWidget(
//             iconPath: Assets.iconsEva,
//             iconColor: VisaColors.black,
//             text: Utils.getErrorMessageFromString(questions.questionKey!),
//             style: VisaTextStyle.displayTitleSmall,
//             colorTheme: VisaTextTheme.customTextColor,
//             customColor: VisaColors.black,
//             fontFamily: VisaFontWeight.bold,
//             lineHeight: (21 / 20).roundToDouble(),
//             letterSpacing: -1,
//           ),
//           AppSizes.xxsmallVS,
//           Padding(
//             padding: EdgeInsets.only(left: Sizes.twentyFourInt.w),
//             child: VisaCustomChipWrapWidget(
//               parentIndex: index,
//               chips: questions.options!,
//               onChipTap: (parentIndex, chipIndex) {
//                 viewModel.toggleChipSelection(parentIndex, chipIndex);
//               },
//               spacing: Sizes.tenInt.toDouble(),
//               runSpacing: Sizes.tenInt.toDouble(),
//               borderRadius: Sizes.fifty,
//               borderWidth: Sizes.oneInt.toDouble(),
//               padding: EdgeInsets.only(
//                   left: Sizes.twelveInt.w,
//                   right: Sizes.twelveInt.w,
//                   top: Sizes.eightInt.h,
//                   bottom: Sizes.eightInt.h),
//               textStyle: VisaTextStyle.displayBodyS,
//               selectedFontWeight: VisaFontWeight.bold,
//               unselectedFontWeight: VisaFontWeight.medium,
//               selectedTextColor: VisaColors.white,
//               unselectedTextColor: VisaColors.black,
//               borderColor: VisaColors.primary,
//               lineHeight: (18 / 14).roundToDouble(),
//               selectedGradient: const LinearGradient(
//                 begin: Alignment(-0.98, 0.17),
//                 end: Alignment(0.98, -0.17),
//                 colors: [
//                   VisaColors.primary,
//                   VisaColors.blueTextLight,
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
