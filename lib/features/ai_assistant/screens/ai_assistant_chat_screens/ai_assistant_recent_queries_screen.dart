import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/base/view/base_view.dart';
import '../../../../custom_widgets/visa_appbar.dart';
import '../../../../custom_widgets/visa_textview.dart';
import '../../../../generated/l10n.dart';
import '../../../../utils/const_screen_size.dart';
import '../../providers/ai_assistant_main_provider.dart';
import '../../providers/ai_assistant_recent_queries_screen_provider.dart';
import 'widgets/ai_assistant_recent_queries_list_widget.dart';

class AiAssistantRecentQueriesScreen extends StatelessWidget {
  const AiAssistantRecentQueriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    var aiAssistantProvider = Provider.of<AiAssistantMainProvider>(context);
    return BaseView<AiAssistantRecentQueriesScreenProvider>(
      viewModel: AiAssistantRecentQueriesScreenProvider(),
      onModelReady: (model) {
        model.loadRecentQueriesFromJsonFile();
      },
      buildAppBar: VisaAppBar(
        isActionButtonShow: true,
        isRecentButtonShow: false,
        isCancelButtonShow: true,
        isBackButtonShow: true,
        visaIconHeight: AppSizes.twentyRadius,
        onCancelPress: () {
          aiAssistantProvider.closeScreen();
        },
      ),
      onPageBuilderMobileView: (BuildContext context,
          AiAssistantRecentQueriesScreenProvider viewModel) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            VisaTextView(
              text: s.recent_queries,
              style: VisaTextStyle.custom,
              colorTheme: VisaTextTheme.primaryDark,
              fontSize: AppSizes.fontMedium,
            ),
            AppSizes.smallVS,
            Expanded(
              child: AiAssistantRecentQueriesListWidget(
                viewModel: viewModel,
              ),
            ),
          ],
        );
      },
    );
  }
}
