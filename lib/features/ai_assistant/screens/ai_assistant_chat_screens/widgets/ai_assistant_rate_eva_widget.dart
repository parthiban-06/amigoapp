import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:visaamigo/custom_widgets/visa_svg_icon.dart';

import '../../../../../custom_widgets/visa_size_box.dart';
import '../../../../../generated/assets.dart';
import '../../../../../utils/app_const.dart';
import '../../../../../utils/const_screen_size.dart';
import '../../../providers/ai_chat_provider.dart';
import '../ai_message.dart';

class AiAssistantRateEvaWidget extends StatelessWidget {
  final Message message;
  final ChatProvider chatProvider;
  final bool isComeFromFaq;
  final bool showLike;

  const AiAssistantRateEvaWidget({
    required this.message,
    required this.chatProvider,
    this.isComeFromFaq = false,
    super.key,
    required this.showLike,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top: message.isFinalTextEmpty && !isComeFromFaq
            ? Sizes.zeroInt.h
            : Sizes.twentyFourInt.h,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          showLike == false
              ? const SizedBox()
              : Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: () {
                        chatProvider.cancelEditChat();
                        chatProvider.updateLikeDislike(
                          message.id,
                          message.state,
                          true,
                        );
                        chatProvider.submitMessageFeedback(
                          AppConst.like,
                          message.aiChatResponse!.sessionId!,
                          message.aiChatResponse!.messageId!,
                        );
                      },
                      child: VisaSvgIcon(
                        useWithoutColor: true,
                        height: AppSizes.thirtyTwoHeight,
                        width: Sizes.thirtyTwoInt.w,
                        assetPath: message.state == 1
                            ? Assets.iconsLikeFill
                            : Assets.iconsLike,
                      ),
                    ),
                    VisaSizeBox(width: Sizes.twelveInt.w),
                    GestureDetector(
                      onTap: () {
                        chatProvider.cancelEditChat();
                        chatProvider.updateLikeDislike(
                          message.id,
                          message.state,
                          false,
                        );
                        chatProvider.submitMessageFeedback(
                          AppConst.dislike,
                          message.aiChatResponse!.sessionId!,
                          message.aiChatResponse!.messageId!,
                        );
                      },
                      child: VisaSvgIcon(
                        useWithoutColor: true,
                        assetPath: message.state == 2
                            ? Assets.iconsDislikeFill
                            : Assets.iconsDislike,
                        height: AppSizes.thirtyTwoHeight,
                        width: Sizes.thirtyTwoInt.w,
                      ),
                    ),
                  ],
                ),
          GestureDetector(
            onTap: () {
              chatProvider.copyEVAText(message);
            },
            child: VisaSvgIcon(
              useWithoutColor: true,
              assetPath: message.isCopy == true
                  ? Assets.iconsCopyEvaFill
                  : Assets.iconsCopyEva,
              height: AppSizes.thirtyTwoHeight,
              width: Sizes.thirtyTwoInt.w,
            ),
          ),
        ],
      ),
    );
  }
}
