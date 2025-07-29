import 'package:flutter/material.dart';
import 'package:visaamigo/custom_widgets/visa_textview.dart';

import '../utils/const_screen_size.dart';

class VisaRetryButtonWidget extends StatelessWidget {
  final VoidCallback onRetry;
  final String label;

  const VisaRetryButtonWidget({
    super.key,
    required this.onRetry,
    this.label = 'Retry',
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: label,
      child: ElevatedButton.icon(
        onPressed: onRetry,
        icon: const Icon(
          Icons.refresh,
          color: Colors.black,
        ),
        label: VisaTextView(
          semantics: false,
          text: label,
          customColor: Colors.black,
          overflow: TextOverflow.visible,
          style: VisaTextStyle.customLarge,
          fontFamily: VisaFontWeight.medium,
          fontSize: AppSizes.fontXXSmall,
          colorTheme: VisaTextTheme.customTextColor,
        ),
        style: ElevatedButton.styleFrom(
          elevation: 0.0,
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    );
  }
}
