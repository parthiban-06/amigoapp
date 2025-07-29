import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart' show GetIt;
import 'package:provider/provider.dart';

import '../../../../core/base/view/base_view.dart';
import '../../../../custom_widgets/visa_ai_assistant_search_box.dart';
import '../../../../custom_widgets/visa_appbar.dart';
import '../../../../generated/l10n.dart';
import '../../../../router/app_routes_const.dart';
import '../../../../utils/const_screen_size.dart';
import '../../../../utils/responsive_util.dart';
import '../../../home/providers/navigation_provider.dart';
import '../../providers/ai_assistant_threads_screen_provider.dart';
import 'widgets/ai_assistant_threads_list_widget.dart';

// ignore: must_be_immutable
class AiAssistantThreadsScreen extends StatefulWidget {
  String evaQuestion;
  String location;

  AiAssistantThreadsScreen(this.evaQuestion, this.location, {super.key});

  @override
  State<StatefulWidget> createState() => AiAssistantThreadsScreenState();
}

class AiAssistantThreadsScreenState extends State<AiAssistantThreadsScreen>
    with SingleTickerProviderStateMixin {
  late final ResponsiveUtil responsive;
  late NavigationProvider navigationBar;
  late final AiAssistantThreadsScreenProvider viewModel;
  late S s; //
  late SizedBox vsSpacing;
  @override
  void initState() {
    super.initState();
    // Retrieve dependencies using GetIt
    viewModel = GetIt.I<AiAssistantThreadsScreenProvider>();
    // Initialize the ViewModel
    viewModel.init(widget.evaQuestion, widget.location);
    viewModel.loadAiChatFromJsonFile();
    viewModel.scrollControllerListener();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    s = S.of(context);
    navigationBar = Provider.of<NavigationProvider>(context, listen: false);
    responsive = GetIt.I<ResponsiveUtil>(param1: context);
    vsSpacing = AppSizes.smallVS;
  }

  @override
  Widget build(BuildContext context) {
    return BaseView<AiAssistantThreadsScreenProvider>(
      viewModel: viewModel,
      screenBackgroundColor: Colors.white,
      // onModelReady: (model) {
      //   model.init(widget.evaQuestion, widget.location);
      //   model.loadAiChatFromJsonFile();
      //   model.scrollControllerListener();
      // },
      buildAppBar: VisaAppBar(
        isHamburgerIconShow: responsive.kISWeb() &&
            (responsive.isMobile(context: context) ||
                responsive.isTablet(context: context)),
        isActionButtonShow: true,
        isRightSideHamburgerIconShow: false,
        isCancelWithTextButtonShow: true,
        onCancelPress: () {
          navigationBar.goBranch(AppRoutes.evaScreenIndex, loadInitial: true);
        },
      ),
      onDispose: () {
        //aiAssistantProvider.socketDisconnect();
      },
      onPageBuilderMobileView:
          (BuildContext context, AiAssistantThreadsScreenProvider viewModel) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: AiAssistantThreadsListWidget(
                viewModel: viewModel,
              ),
            ),
            vsSpacing,
            // Search TextField at the Bottom
            VisaAiAssistantSearchBox(
              controller: viewModel.threadController,
              hintText: s.ask_eva,
              autofocus: false,
              maxLines: 2,
              onTap: () {
                viewModel.scrollToBottomThreads();
              },
              onSearch: () {
                viewModel.sendMessage();
              },
            ),
            vsSpacing,

            // AppSizes.xxsmallVS,
          ],
        );
      },
    );
  }
}
