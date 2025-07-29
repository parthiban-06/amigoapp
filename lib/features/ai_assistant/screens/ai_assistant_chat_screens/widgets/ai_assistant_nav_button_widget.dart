import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../custom_widgets/visa_button.dart';
import '../../../../../custom_widgets/visa_textview.dart';
import '../../../../../utils/const_screen_size.dart';
import '../../../providers/ai_chat_provider.dart';
import '../ai_message.dart';

class AiAssistantNavButtonWidget extends StatelessWidget {
  final Message message;
  final ChatProvider chatProvider;
  final String ctaText;
  final String url;
  final bool isRedirectToBooking;
  final bool isComeFromFAQ;

  const AiAssistantNavButtonWidget({
    super.key,
    required this.message,
    required this.chatProvider,
    required this.ctaText,
    required this.url,
    required this.isRedirectToBooking,
    required this.isComeFromFAQ,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      container: true,
      child: Padding(
        padding: EdgeInsets.only(
          top: message.isFinalTextEmpty
              ? AppSizes.zeroInt.h
              : Sizes.twentyFourInt.h,
        ),
        child: VisaButton(
          text: ctaText,
          onPressed: () {
            chatProvider.cancelEditChat();
            if (isComeFromFAQ) {
              chatProvider.navigateFaqUrls(
                url,
              );
            } else {
              chatProvider.navigateToRedirectingScreen(
                url,
                isRedirectToBooking: isRedirectToBooking,
              );
            }
          },
          fontWeight: VisaFontWeight.medium,
          variant: VisaButtonVariant.primary,
          lineHeight: 1.39,
        ),
      ),
    );
  }
}
