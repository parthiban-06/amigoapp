import 'package:flutter/material.dart';
import 'package:visaamigo/custom_widgets/visa_textview.dart';
import 'package:visaamigo/utils/app_extensions.dart';
import 'package:visaamigo/utils/const_screen_size.dart';
import 'package:visaamigo/utils/theme_extension.dart';

import '../../../../../core/theme/theme.dart';
import '../../../../../generated/l10n.dart';
import '../../../providers/ai_assistant_recent_queries_screen_provider.dart';

class AiAssistantRecentQueriesListWidget extends StatelessWidget {
  final AiAssistantRecentQueriesScreenProvider viewModel;

  const AiAssistantRecentQueriesListWidget(
      {super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return (viewModel.listRecentQueries != null &&
            viewModel.listRecentQueries!.isNotEmpty)
        ? AnimatedList(
            key: viewModel.animatedListKey,
            initialItemCount: viewModel.listRecentQueries!.length,
            itemBuilder: (context, index, animation) {
              var model = viewModel.listRecentQueries![index];
              return SizeTransition(
                sizeFactor: animation,
                child: Dismissible(
                  key: Key('${model.hashCode}'),
                  onDismissed: (direction) {
                    var removedItem = viewModel.listRecentQueries![
                        index]; // Temporarily store the removed item
                    viewModel.removeItem(
                        index); // Remove it from the list and AnimatedList
                    viewModel.showCustomDialog(context, index, removedItem);
                  },
                  background: Container(
                    alignment: Alignment.centerRight,
                    padding: EdgeInsets.symmetric(horizontal: Sizes.fifteen),
                    decoration: BoxDecoration(
                      color: context.theme.colorScheme.primary,
                      borderRadius: BorderRadius.circular(Sizes.ten),
                    ),
                    child: VisaTextView(
                      text: S.of(context).delete,
                      colorTheme: VisaTextTheme.secondary,
                      style: VisaTextStyle.custom,
                      fontSize: Sizes.fourteen,
                      overflow: TextOverflow.visible,
                    ),
                  ),
                  direction: DismissDirection.endToStart,
                  child: Container(
                    width: context.screenWidth,
                    margin: EdgeInsets.only(bottom: Sizes.ten),
                    padding: EdgeInsets.all(Sizes.twenty),
                    decoration: BoxDecoration(
                      color: VisaColors.greyLight,
                      borderRadius: BorderRadius.circular(Sizes.ten),
                    ),
                    child: VisaTextView(
                      text: model.query,
                      colorTheme: VisaTextTheme.primaryDark,
                      style: VisaTextStyle.custom,
                      fontSize: Sizes.fourteenInt.toDouble(),
                      overflow: TextOverflow.visible,
                    ),
                  ),
                ),
              );
            },
          )
        : const SizedBox.shrink();
  }
}
