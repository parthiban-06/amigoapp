import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/theme/theme.dart';
import '../../../../../custom_widgets/visa_icon_with_text_widget.dart';
import '../../../../../custom_widgets/visa_textview.dart';
import '../../../../../generated/assets.dart';
import '../../../../../generated/l10n.dart';
import '../../../../../utils/const_screen_size.dart';
import '../../../../../utils/utils.dart';
import '../../../providers/ai_chat_provider.dart';
import '../ai_message.dart';

class AiAssistantEditChatButtonsWidget extends StatelessWidget {
  final Message message;
  final ChatProvider chatProvider;
  final bool isLastUserMessage;

  const AiAssistantEditChatButtonsWidget({
    super.key,
    required this.message,
    required this.chatProvider,
    required this.isLastUserMessage,
  });

  @override
  Widget build(BuildContext context) {
    return chatProvider.isEdit! && isLastUserMessage
        ? Padding(
            padding: EdgeInsets.only(
              left: Sizes.twentyEightInt.w,
              right: Sizes.sixtyInt.w,
              top: Sizes.twelveInt.h,
              bottom: Sizes.thirtyInt.h,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Semantics(
                  label: S.of(context).cancel_editing_message,
                  button: true,
                  enabled: true,
                  child: InkWell(
                    child: VisaIconWithTextWidget(
                      iconPath: Assets.iconsIcClose,
                      iconColor: VisaColors.primary,
                      text: S.of(context).cancel,
                      style: VisaTextStyle.displayBodyS,
                      colorTheme: VisaTextTheme.customTextColor,
                      customColor: VisaColors.primary,
                      fontFamily: VisaFontWeight.semibold,
                      lineHeight: 1.29,
                      letterSpacing: 0,
                      iconHeight: Sizes.fourteenInt.toDouble(),
                      iconWidth: Sizes.fourteenInt.toDouble(),
                      iconPadding: EdgeInsets.only(top: 5.h),
                      spacing: 8.w,
                    ),
                    onTap: () {
                      chatProvider.cancelEditChat();
                    },
                  ),
                ),
                Semantics(
                  label: S.of(context).update_message,
                  button: true,
                  enabled: true,
                  child: InkWell(
                    child: VisaIconWithTextWidget(
                      iconPath: Assets.iconsIcCheckMark,
                      iconColor: VisaColors.primary,
                      text: S.of(context).update,
                      style: VisaTextStyle.displayBodyS,
                      colorTheme: VisaTextTheme.customTextColor,
                      customColor: VisaColors.primary,
                      fontFamily: VisaFontWeight.semibold,
                      lineHeight: 1.29,
                      letterSpacing: 0,
                      iconHeight: Sizes.fourteenInt.toDouble(),
                      iconWidth: Sizes.fourteenInt.toDouble(),
                      iconPadding: EdgeInsets.only(top: 5.h),
                      spacing: 7.w,
                    ),
                    onTap: () {
                      Utils.hideKeyboard(context);
                      chatProvider.removeChatWithMessageId(
                        message.editId,
                      );
                    },
                  ),
                ),
              ],
            ),
          )
        : const SizedBox.shrink();
  }
}
