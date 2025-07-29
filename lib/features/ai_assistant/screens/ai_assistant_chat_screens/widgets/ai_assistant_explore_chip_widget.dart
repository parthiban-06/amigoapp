import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:visaamigo/core/theme/theme.dart';
import 'package:visaamigo/custom_widgets/visa_textview.dart';
import 'package:visaamigo/utils/app_extensions.dart';
import 'package:visaamigo/utils/utils.dart';

import '../../../../../custom_widgets/visa_button.dart';
import '../../../../../custom_widgets/visa_custom_chip_wrap_widget.dart';
import '../../../../../generated/l10n.dart';
import '../../../../../utils/const_screen_size.dart';
import '../../../providers/ai_chat_provider.dart';
import '../../../providers/ai_chip_selector_provider.dart';
import '../ai_message.dart';

class AiAssistantExploreChipWidget extends StatelessWidget {
  final int index;
  final Message message;
  final ChatProvider chatProvider;

  const AiAssistantExploreChipWidget({
    super.key,
    required this.index,
    required this.message,
    required this.chatProvider,
  });

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    return (!message.isTyping &&
            message.isFinalText &&
            chatProvider.section!.isNotEmpty &&
            message.questions != null &&
            !chatProvider.isContinueButtonSelected)
        ? ChangeNotifierProvider<AiChipSelectorProvider>(
            create: (_) => AiChipSelectorProvider(message.questions!.options!),
            child: Padding(
              padding: EdgeInsets.only(top: Sizes.eighteenInt.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Consumer<AiChipSelectorProvider>(
                    builder: (context, chipProvider, _) {
                      return VisaCustomChipWrapWidget(
                        parentIndex: index,
                        showAnimation: false,
                        chips: chipProvider.options,
                        onChipTap: (_, chipIndex) =>
                            chipProvider.toggleChip(chipIndex),
                        spacing: Sizes.eightInt.toDouble(),
                        runSpacing: AppSizes.zeroInt.toDouble(),
                        borderRadius: Sizes.fifty,
                        borderWidth: Sizes.oneInt.toDouble(),
                        padding: EdgeInsets.symmetric(
                          horizontal: Sizes.twelveInt.w,
                          vertical: Sizes.eightInt.h,
                        ),
                        textStyle: VisaTextStyle.displayBodyS,
                        selectedFontWeight: FontWeight.w500,
                        unselectedFontWeight: FontWeight.w500,
                        fontSize: 14.sp,
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
                  Consumer<AiChipSelectorProvider>(
                    builder: (context, chipProvider, _) {
                      return chipProvider.hasSelected
                          ? Padding(
                              padding: EdgeInsets.only(
                                top: AppSizes.tweentyHeight,
                                bottom: AppSizes.zeroInt.h,
                              ),
                              child: Center(
                                child: VisaButton(
                                  text: s.txt_continue,
                                  height: Sizes.fiftySevenInt.h,
                                  width: context.screenWidth,
                                  variant: VisaButtonVariant.primary,
                                  fontWeight: VisaFontWeight.medium,
                                  fontSize: AppSizes.fontMedium,
                                  letterSpacing: AppSizes.zero,
                                  lineHeight: (25 / 18).toDouble(),
                                  borderRadius: Sizes.sixteen,
                                  onPressed: () {
                                    Utils.logPrint("message ${message.id}");
                                    chatProvider.buildOptionSummary(
                                        chipProvider.options, message.editId);
                                  },
                                ),
                              ),
                            )
                          : const SizedBox.shrink();
                    },
                  ),
                ],
              ),
            ),
          )
        : const SizedBox.shrink();
  }
}
