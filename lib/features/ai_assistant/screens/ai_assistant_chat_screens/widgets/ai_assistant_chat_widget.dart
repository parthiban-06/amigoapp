import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:visaamigo/utils/app_extensions.dart';

import '../../../../../core/theme/theme.dart';
import '../../../../../custom_widgets/visa_ai_chat_title_widget.dart';
import '../../../../../custom_widgets/visa_textview.dart';
import '../../../../../generated/assets.dart';
import '../../../../../generated/l10n.dart';
import '../../../../../utils/const_screen_size.dart';
import '../../../providers/ai_chat_provider.dart';
import '../ai_message.dart';

class AiAssistantChatWidget extends StatelessWidget {
  final Message message;
  final ChatProvider chatProvider;
  final bool isLastUserMessage;

  const AiAssistantChatWidget({
    super.key,
    required this.message,
    required this.chatProvider,
    required this.isLastUserMessage,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        margin: EdgeInsets.only(
          left: Sizes.twentyEightInt.w,
        ),
        decoration: BoxDecoration(
          color: VisaColors.blueBackgroundLightNew,
          borderRadius: BorderRadius.circular(Sizes.sixteen),
        ),
        padding: EdgeInsets.symmetric(
            vertical: Sizes.sixteen, horizontal: Sizes.twenty),
        child: Semantics(
          label: "${message.text}, ${S.of(context).sender_message}",
          container: true,
          enabled: true,
          child: VisaChatTitleWidget(
            showEditIcon: chatProvider.textController.isEmpty &&
                isLastUserMessage &&
                !chatProvider.isTyping &&
                (chatProvider.section!.isNullOrEmpty),
            iconHeight: Sizes.eighteen,
            iconPadding: EdgeInsets.symmetric(horizontal: 2.w),
            iconPath: Assets.iconsEva,
            iconColor: VisaColors.black,
            text: message.text,
            style: VisaTextStyle.displayBodyL,
            colorTheme: VisaTextTheme.customTextColor,
            customColor: VisaColors.black,
            fontFamily: VisaFontWeight.bold,
            lineHeight: (17 / 16).toDouble(),
            letterSpacing: -0.16,
            onEditTap: () {
              if (!chatProvider.isTyping) {
                chatProvider.requestEditTextFocus();
                chatProvider.editLastUserMessage(
                  chatProvider.textEditController,
                  message.editId,
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
