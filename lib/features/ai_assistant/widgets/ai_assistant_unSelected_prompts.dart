import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:visaamigo/core/theme/theme.dart';
import 'package:visaamigo/custom_widgets/text_with_icon.dart';
import 'package:visaamigo/custom_widgets/visa_auto_size_text.dart';
import 'package:visaamigo/custom_widgets/visa_svg_icon.dart';
import 'package:visaamigo/custom_widgets/visa_textview.dart';
import 'package:visaamigo/features/ai_assistant/models/ai_prompt_model.dart';
import 'package:visaamigo/features/ai_assistant/providers/ai_assistant_prompts_screen_provider.dart';
import 'package:visaamigo/generated/assets.dart';
import 'package:visaamigo/utils/const_screen_size.dart';

import '../../../custom_widgets/visa_font_family.dart';
import '../../../custom_widgets/visa_show_case_widget.dart';
import '../../../utils/utils.dart';
import '../../home/providers/tutorial_provider.dart';

class AiAssistantUnSelectedPrompts extends StatelessWidget {
  final AiPromptModel promptModel;
  final int index;
  final double width;

  AiAssistantUnSelectedPrompts(
      {super.key,
      required this.promptModel,
      required this.index,
      required this.width});

  var localText = {};

  @override
  Widget build(BuildContext context) {
    var aiAssistantProvider =
        Provider.of<AiAssistantPromptsScreenProvider>(context);
    var tutorialProvider =
        Provider.of<TutorialProvider>(context, listen: false);
    if (localText.isEmpty) {
      localText = Map.from(aiAssistantProvider.setTextData(context));
    }
    List<String> descList = localText[promptModel.desc].toString().split(" ");
    String lastWord = descList.removeLast();
    return Container(
      width: width,
      constraints: BoxConstraints(minHeight: (index == 0 ? 187 : 169).h),
      decoration: BoxDecoration(
          color: VisaColors.blueBackgroundLight,
          borderRadius: BorderRadius.circular(20.r)),
      child: Padding(
        padding:
            EdgeInsets.symmetric(horizontal: AppSizes.dimSmall, vertical: 22.h),
        child: VisaShowcase(
          keyValue:
              index == 4 ? tutorialProvider.tutorialPersonalPref : GlobalKey(),
          borderRadius: BorderRadius.circular(Sizes.twenty),
          isComeFromHome: false,
          targetPadding: EdgeInsets.symmetric(
            horizontal: AppSizes.dimSmall,
            vertical: 22.h,
          ),
          child: Semantics(
            button: true,
            label:
                "${localText.containsKey(promptModel.prompt) ? localText[promptModel.prompt] : ""}, ",
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                VisaAutoSizeText(
                  text: localText.containsKey(promptModel.prompt)
                      ? localText[promptModel.prompt]
                      : "",
                  maxLines: 3,
                  overflow: TextOverflow.visible,
                  minFontSize: index == 0 ? AppSizes.fontThirtyFive : 21.3,
                  style: VisaTextStyle.customLarge,
                  fontSize: index == 0 ? AppSizes.fontThirtyFive : 21.3,
                  fontFamily: VisaFontWeight.bold,
                  customColor: VisaColors.black,
                  colorTheme: VisaTextTheme.customTextColor,
                  letterSpacing: index == 0 ? -2 : -1,
                ),
                TextWithEndIcon(
                  text:
                      localText.containsKey(promptModel.desc) ? descList : [""],
                  selected: false,
                  textStyle: TextStyle(
                      color: Colors.black,
                      fontFamily: VisaFontFamily.getFontFamily(
                          VisaFontWeight.medium, false),
                      fontWeight: FontWeight.w500,
                      letterSpacing: -0.02 * 14.sp,
                      fontSize: 14.sp),
                  widget: Wrap(
                    runAlignment: WrapAlignment.start,
                    alignment: WrapAlignment.start,
                    crossAxisAlignment: WrapCrossAlignment.start,
                    children: [
                      Text(
                        lastWord,
                        textScaler: TextScaler.linear(
                            Utils.getCappedScale(context, 14.sp)),
                        style: TextStyle(
                            color: Colors.black,
                            fontFamily: VisaFontFamily.getFontFamily(
                                VisaFontWeight.medium, false),
                            fontWeight: FontWeight.w500,
                            letterSpacing: -0.02 * 14.sp,
                            fontSize: 14.sp),
                      ),
                      AppSizes.xxsmallHS,
                      Padding(
                        padding: EdgeInsets.only(top: AppSizes.heightFive),
                        child: VisaSvgIcon(
                          semantics: false,
                          assetPath: Assets.iconsIcLeftArrow,
                          color: VisaColors.black,
                          width: AppSizes.tweleveWidth,
                          height: AppSizes.tweleveHeight,
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
    );
  }
}
