import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart' show GetIt;
import 'package:provider/provider.dart';
import 'package:visaamigo/core/theme/theme.dart';
import 'package:visaamigo/custom_widgets/custom_visa_two_button.dart';
import 'package:visaamigo/custom_widgets/visa_appbar.dart';
import 'package:visaamigo/custom_widgets/visa_button.dart';
import 'package:visaamigo/custom_widgets/visa_click_text_link.dart';
import 'package:visaamigo/custom_widgets/visa_textview.dart';
import 'package:visaamigo/features/ai_assistant/providers/ai_chat_provider.dart';
import 'package:visaamigo/generated/l10n.dart';
import 'package:visaamigo/utils/app_extensions.dart';
import 'package:visaamigo/utils/const_screen_size.dart';
import 'package:visaamigo/utils/theme_extension.dart';

import '../../../../analytics/firebase_analytics_service.dart';
import '../../../../core/base/view/base_view.dart';
import '../../../../router/app_routes_const.dart';
import '../../../../utils/responsive_util.dart';
import '../../../../utils/utils.dart';
import '../../../home/providers/navigation_provider.dart';
import '../../providers/ai_hisotry/ai_chat_hisotry_provider.dart';
import 'ai_chat_history_item.dart' show ChatHistoryItem;

class AiChatHistoryScreen extends StatefulWidget {
  const AiChatHistoryScreen({super.key});

  @override
  State<AiChatHistoryScreen> createState() => _AiChatHistoryScreenState();
}

class _AiChatHistoryScreenState extends State<AiChatHistoryScreen> {
  late final ResponsiveUtil responsive;
  late final ChatProvider chatProvider;
  late final AiChatHistoryProvider aiChatProvider;
  late final NavigationProvider navigationBar;
  late S s;

  @override
  void initState() {
    super.initState();
    // Retrieve dependencies using GetIt
    chatProvider = GetIt.I<ChatProvider>();
    aiChatProvider = GetIt.I<AiChatHistoryProvider>();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    responsive = GetIt.I<ResponsiveUtil>(param1: context);
    s = S.of(context);
    navigationBar = Provider.of<NavigationProvider>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    return BaseView<AiChatHistoryProvider>(
      onlyDesktop: true,
      screenBackgroundColor: Colors.white,
      extendBodyBehindAppBar: false,
      addDefaultPadding: false,
      wrapWithSafeArea: false,
      resizeToAvoidBottomInset: true,
      systemNavigationBarColor: context.theme.primaryColor,
      viewModel: aiChatProvider,
      onModelReady: (model) {
        model.init();
        Utils.announceMessage(s.eva_chat_history_screen);
      },
      screenBackgroundImage: null,
      buildAppBar: _buildAppBar(),
      onPageBuilderMobileView: _buildMobileView,
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return VisaAppBar(
      isHamburgerIconShow: responsive.kISWeb() &&
          (responsive.isMobile(context: context) ||
              responsive.isTablet(context: context)),
      isActionButtonShow: true,
      isCancelWithTextButtonShow: true,
      isRightSideHamburgerIconShow: false,
      onCancelPress: () {
        aiChatProvider.showDeleteChatUi();
      },
    );
  }

  Widget _buildMobileView(
      BuildContext context, AiChatHistoryProvider viewModel) {
    return Padding(
      padding: EdgeInsets.only(
        top: Provider.of<ResponsiveUtil>(context).appBarTotalHeight ?? 0,
        right: AppSizes.sixteenRadius,
        left: AppSizes.sixteenRadius,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          AppSizes.mediumVS,
          _buildTitle(),
          AppSizes.smallVS,
          _buildContentSection(viewModel),
        ],
      ),
    );
  }

  Widget _buildTitle() {
    return VisaTextView(
      text: s.conversation_history,
      semanticsFocus: true,
      style: VisaTextStyle.displayTitleMedium,
      colorTheme: VisaTextTheme.textColorBlack,
      customColor: VisaColors.black,
      fontFamily: VisaFontWeight.semibold,
      letterSpacing: -1,
    );
  }

  Widget _buildContentSection(AiChatHistoryProvider viewModel) {
    final hasHistory =
        viewModel.aiHistoryList != null && viewModel.aiHistoryList!.isNotEmpty;

    if (!hasHistory) {
      return _buildEmptyState(viewModel);
    }

    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          _buildHistoryHeader(viewModel),
          AppSizes.mediumVS,
          _buildHistoryList(viewModel),
          AppSizes.smallVS,
          _buildActionButtons(viewModel),
        ],
      ),
    );
  }

  Widget _buildEmptyState(AiChatHistoryProvider viewModel) {
    if (viewModel.isLoading) {
      return const SizedBox();
    }

    return Expanded(
      child: Center(
        child: VisaButton(
          text: s.start_new_chat,
          onPressed: () {
            navigationBar.goBranch(AppRoutes.evaScreenIndex,
                loadInitial: true, showGreetingScreen: true);
          },
        ),
      ),
    );
  }

  Widget _buildHistoryHeader(AiChatHistoryProvider viewModel) {
    if (viewModel.isDeleteHistoryEnable) {
      return VisaTextView(
        text: s.select_conversation_delete,
        style: VisaTextStyle.displayBodyS,
        colorTheme: VisaTextTheme.textColorBlack,
        customColor: VisaColors.black,
      );
    }

    return ClickableLinkTextView(
      semantics: true,
      text: s.select_conversation,
      linkText: s.manage_history,
      maxline: 5,
      onLinkTap: _onManageHistoryTap,
      fontWeight: VisaFontWeight.semibold,
      textStyle: VisaTextStyle.displayBodyS,
      linkTextStyle: VisaTextStyle.displayBodyS,
      textColorTheme: VisaTextTheme.textColorBlack,
      linkColorTheme: VisaTextTheme.primary,
    );
  }

  void _onManageHistoryTap() {
    aiChatProvider.isDeleteHistoryEnable = true;

    FirebaseAnalyticsService.logEventButtonClick(
      btnName: "manage_history",
      parameters: {AnalyticsEventConst.PARAM_NAME_UI_ELEMENT: "manage_history"},
    );
  }

  Widget _buildHistoryList(AiChatHistoryProvider viewModel) {
    if (aiChatProvider.aiHistoryList == null) {
      return const SizedBox();
    }

    return Expanded(
      child: Stack(
        children: [
          _buildListView(viewModel),
          _buildGradientOverlay(viewModel),
        ],
      ),
    );
  }

  Widget _buildListView(AiChatHistoryProvider viewModel) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return ListView.builder(
          padding: const EdgeInsets.all(0),
          controller: aiChatProvider.scrollController,
          itemCount: aiChatProvider.aiHistoryList!.length,
          addAutomaticKeepAlives: true,
          itemBuilder: (context, index) => _buildHistoryItem(viewModel, index),
        );
      },
    );
  }

  Widget _buildHistoryItem(AiChatHistoryProvider viewModel, int index) {
    final isSelected = aiChatProvider.selectedItems.contains(index);

    return ChatHistoryItem(
      title: aiChatProvider.aiHistoryList![index].topic ?? "",
      isDeleteHistoryEnable: viewModel.isDeleteHistoryEnable,
      isSelected: isSelected,
      onTap: () => _onHistoryItemTap(viewModel, index),
    );
  }

  void _onHistoryItemTap(AiChatHistoryProvider viewModel, int index) {
    if (viewModel.isDeleteHistoryEnable) {
      aiChatProvider.toggleSelection(index);
    } else {
      aiChatProvider.openChatDetailScreen(
        navigationBar,
        chatProvider,
        aiChatProvider.aiHistoryList![index],
      );
    }
  }

  Widget _buildGradientOverlay(AiChatHistoryProvider viewModel) {
    return ValueListenableBuilder(
      valueListenable: viewModel.isAtBottom,
      builder: (context, value, child) {
        Utils.logPrint("ValueListenableBuilder bottom ${value}");

        if (value) {
          return _buildTopGradient();
        } else {
          return _buildBottomGradient();
        }
      },
    );
  }

  Widget _buildTopGradient() {
    return Positioned(
      top: 0,
      child: IgnorePointer(
        child: Container(
          height: AppSizes.heightFifty,
          width: context.screenWidth,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                VisaColors.white.withAlpha(0),
                VisaColors.white.withAlpha(200)
              ],
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              stops: const [0.2, 1],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBottomGradient() {
    return Positioned(
      bottom: 0,
      child: IgnorePointer(
        child: Container(
          height: AppSizes.heightXLarge,
          width: context.screenWidth,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [VisaColors.white, VisaColors.white.withAlpha(0)],
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              stops: const [0, 1],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActionButtons(AiChatHistoryProvider viewModel) {
    if (!viewModel.isDeleteHistoryEnable) {
      return const SizedBox();
    }

    return Padding(
      padding: EdgeInsets.only(bottom: AppSizes.tweentyHeight),
      child: CustomTwoButtons(
        width: AppSizes.oneTweentywWidth,
        leftButtonText: S.of(context).cancel,
        rightButtonText: S.of(context).delete,
        rightButtonDisable: viewModel.selectedItems.isEmpty,
        onLeftButtonPressed: () {
          aiChatProvider.showDeleteChatUi();
        },
        onRightButtonPressed: () {
          viewModel.deleteChatConversation();
        },
        isRightButtonLoading: false,
        isLeftButtonLoading: false,
      ),
    );
  }
}
