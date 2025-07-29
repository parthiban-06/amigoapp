import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import '../../../providers/ai_assistant_prompts_screen_provider.dart';
import 'ai_assistant_staggered_grid_items_widget.dart';

class AiAssistantStaggeredGridWidget extends StatelessWidget {
  final AiAssistantPromptsScreenProvider viewModel;

  const AiAssistantStaggeredGridWidget({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return (viewModel.listSuggestions != null &&
            viewModel.listSuggestions!.isNotEmpty)
        ? AnimationLimiter(
            child: StaggeredGrid.count(
              crossAxisCount: 2,
              mainAxisSpacing: 6,
              crossAxisSpacing: 6,
              children:
                  List.generate(viewModel.listSuggestions!.length, (index) {
                return AnimationConfiguration.staggeredGrid(
                  position: index,
                  duration: const Duration(milliseconds: 375),
                  columnCount: viewModel.listSuggestions!.length,
                  child: SlideAnimation(
                    // ScaleAnimation are also present
                    verticalOffset: 50.0,
                    horizontalOffset: 50.0,
                    child: FadeInAnimation(
                      child: AiAssistantStaggeredGridItemsWidget(
                        viewModel: viewModel,
                        index: index,
                      ),
                    ),
                  ),
                );
              }),
            ),
          )
        : const SizedBox.shrink();
  }
}
