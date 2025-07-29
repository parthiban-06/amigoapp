import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:visaamigo/custom_widgets/visa_textview.dart';
import 'package:visaamigo/utils/const_screen_size.dart';

import '../../../../../core/theme/theme.dart';
import '../../../providers/ai_assistant_main_provider.dart';
import '../../../providers/ai_assistant_prompts_screen_provider.dart';

class AiAssistantStaggeredGridItemsWidget extends StatelessWidget {
  final AiAssistantPromptsScreenProvider viewModel;
  final int index;

  const AiAssistantStaggeredGridItemsWidget({
    super.key,
    required this.viewModel,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    var aiAssistantProvider = Provider.of<AiAssistantMainProvider>(context);
    return Card(
      elevation: 0.0,
      surfaceTintColor: VisaColors.greyLight,
      color: VisaColors.greyLight,
      margin: EdgeInsets.zero,
      child: InkWell(
        onTap: () {
          // aiAssistantProvider.navigateToAiAssistantThreadsScreen();
        },
        child: SizedBox(
          height: viewModel.calculateHeight(index, context),
          child: Center(
            child: VisaTextView(
              text: viewModel.listSuggestions![index].suggestion,
              colorTheme: VisaTextTheme.primaryDark,
              overflow: TextOverflow.visible,
              fontSize: AppSizes.fontMedium,
              textAlign: TextAlign.center,
              style: VisaTextStyle.custom,
              letterSpacing: 0.5,
            ),
          ),
        ),
      ),
    );
  }
}
