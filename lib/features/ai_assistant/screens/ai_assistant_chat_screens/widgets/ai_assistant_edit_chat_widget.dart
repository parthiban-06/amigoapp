import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/theme/theme.dart';
import '../../../../../custom_widgets/visa_edit_chat_text_field.dart';
import '../../../../../utils/app_const.dart';
import '../../../../../utils/const_screen_size.dart';
import '../../../providers/ai_chat_provider.dart';
import '../ai_message.dart';

class AiAssistantEditChatWidget extends StatelessWidget {
  final Message message;
  final ChatProvider chatProvider;

  const AiAssistantEditChatWidget({
    super.key,
    required this.message,
    required this.chatProvider,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        margin: EdgeInsets.only(
          left: Sizes.twentyEightInt.w,
        ),
        decoration: BoxDecoration(
          color: VisaColors.white,
          borderRadius: BorderRadius.circular(Sizes.sixteen),
          border: Border.all(
            color: VisaColors.primary, // Outline color
          ),
        ),
        padding: EdgeInsets.symmetric(
          vertical: Sizes.sixteen,
          horizontal: Sizes.twenty,
        ),
        child: VisaEditChatTextField(
          focusNode: chatProvider.editFocusNode,
          controller: chatProvider.textEditController,
          isValid: true,
          borderTransparent: true,
          vPadding: 0,
          hPadding: 0,
          filled: true,
          fontSize: 16,
          fontWeight: FontWeight.w700,
          fillColor: VisaColors.white,
          maxLines: 5,
          maxLength: AppConst.TEXTFIELD_EMAIL_LENGTH,
          letterSpacing: -0.16,
        ),
      ),
    );
  }
}
