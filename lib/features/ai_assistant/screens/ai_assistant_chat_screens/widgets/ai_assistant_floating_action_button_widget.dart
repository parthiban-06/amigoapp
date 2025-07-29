import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:visaamigo/utils/const_screen_size.dart';
import 'package:visaamigo/utils/theme_extension.dart';

import '../../../../../core/theme/theme.dart';
import '../../../providers/ai_assistant_threads_screen_provider.dart';

class AiAssistantFloatingActionButtonWidget extends StatelessWidget {
  final AiAssistantThreadsScreenProvider viewModel;

  const AiAssistantFloatingActionButtonWidget(
      {super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return Consumer<AiAssistantThreadsScreenProvider>(
        builder: (context, provider, child) {
      return AnimatedScale(
        scale: viewModel.isFabVisible ? 1.0 : 0.0,
        // Scale down to 0 when hidden
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        child: viewModel.isFabVisible
            ? Padding(
                padding: EdgeInsets.only(bottom: Sizes.eighty),
                child: FloatingActionButton(
                  backgroundColor: VisaColors.white,
                  foregroundColor: VisaColors.white,
                  onPressed: viewModel.scrollToBottomThreads,
                  child: Icon(
                    Icons.arrow_downward,
                    color: context.theme.colorScheme.primary,
                  ),
                ),
              )
            : const SizedBox.shrink(),
      );
    });
  }
}
