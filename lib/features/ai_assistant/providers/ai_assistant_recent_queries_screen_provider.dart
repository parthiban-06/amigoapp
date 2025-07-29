import 'package:flutter/material.dart';
import 'package:visaamigo/ui/base/base_provider.dart';

import '../../../custom_widgets/visa_dialog.dart';
import '../../../generated/assets.dart';
import '../../../generated/l10n.dart';
import '../../../utils/utils.dart';
import '../models/ai_recent_queries_model.dart';

class AiAssistantRecentQueriesScreenProvider extends BaseProvider {
  // Mock Recent Queries List
  List<AiRecentQueriesModel>? listRecentQueries = [];

  // GlobalKey to manage the state of the AnimatedList.
  GlobalKey<AnimatedListState> animatedListKey = GlobalKey<AnimatedListState>();

  // Load Mock AI Recent Queries From Json File
  Future<void> loadRecentQueriesFromJsonFile() async {
    if (listRecentQueries == null || listRecentQueries!.isEmpty) {
      listRecentQueries = recentQueriesFromJsonList(
          await Utils.loadJson(Assets.jsonAiRecentQueries));
      addIndexInGlobalKey();
      // Trigger UI update
      setState();
    }
  }

  // Add all items from the list to the AnimatedList.
  void addIndexInGlobalKey() {
    listRecentQueries
        ?.asMap()
        .forEach((i, _) => animatedListKey.currentState?.insertItem(i));
  }

  // Remove an item from the AnimatedList and the data source.
  void removeItem(int index) {
    animatedListKey.currentState
        ?.removeItem(index, (_, __) => const SizedBox.shrink());
    listRecentQueries?.removeAt(index);
  }

  // Insert an item from the AnimatedList and the data source.
  void addItem(int index, var model) {
    listRecentQueries?.insert(index, model); // Add to the data source first
    animatedListKey.currentState?.insertItem(index);
  }

  // Show a confirmation dialog with actions to cancel or delete an item at the given index.
  void showCustomDialog(BuildContext context, int index, var model) {
    var s = S.of(context);
    VisaDialog.show(
      context: context,
      title: s.confirmation,
      message: s.want_to_delete,
      config: VisaDialogShowConfig(
        primaryButtonText: s.delete,
        secondaryButtonText: s.cancel,
        barrierDismissible: false,
        outlinedSecondaryButton: false,
        onPrimaryPressed: () {
          navPop(); // Close the dialog
        },
        onSecondaryPressed: () {
          navPop(); // Close the dialog
          addItem(index, model);
        },
      ),
    );
  }
}
