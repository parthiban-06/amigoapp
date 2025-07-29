import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart' show GetIt;
import 'package:provider/provider.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:visaamigo/core/base/view/base_view.dart';
import 'package:visaamigo/core/theme/theme.dart';
import 'package:visaamigo/custom_widgets/visa_size_box.dart';
import 'package:visaamigo/features/ai_assistant/providers/ai_assistant_greeting_provider.dart';
import 'package:visaamigo/features/home/screens/home_screens/widgets/home_screen_companion_book_travel.dart';
import 'package:visaamigo/features/home/screens/home_screens/widgets/home_screen_eva_travel_widget.dart';
import 'package:visaamigo/features/home/screens/home_screens/widgets/home_screen_greeting_text_widget.dart';
import 'package:visaamigo/features/home/screens/home_screens/widgets/home_screen_wallet_and_travel_widget.dart';
import 'package:visaamigo/features/select_languages/providers/language_selection_generic_provider.dart';
import 'package:visaamigo/utils/app_extensions.dart';
import 'package:visaamigo/utils/const_screen_size.dart';
import 'package:visaamigo/utils/theme_extension.dart';
import 'package:visaamigo/utils/utils.dart';

import '../../../../custom_widgets/tutorial_blank_widget.dart';
import '../../../../custom_widgets/visa_appbar.dart';
import '../../../../custom_widgets/visa_header_background.dart';
import '../../../../generated/l10n.dart';
import '../../../../utils/responsive_util.dart';
import '../../providers/home_provider.dart';
import '../../providers/tutorial_provider.dart';
import 'widgets/home_screen_ticket_card_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late HomeViewProvider homeViewProvider;
  late ResponsiveUtil responsive;
  late double padding;
  late AiAssistantGreetingProvider viewModel;

  @override
  void initState() {
    super.initState();
    // Retrieve dependencies using GetIt
    homeViewProvider = GetIt.I<HomeViewProvider>();
    viewModel = GetIt.I<AiAssistantGreetingProvider>();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      homeViewProvider.setContext(context);
      homeViewProvider.init(context);
      viewModel.getGreetingScreenData();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    responsive = GetIt.I<ResponsiveUtil>(param1: context);
    padding = AppSizes.heightSmall;
  }

  @override
  Widget build(BuildContext context) {
    final tutorialProvider =
        Provider.of<TutorialProvider>(context, listen: false);
    return ShowCaseWidget(
      builder: (context) {
        tutorialProvider.initHomeContext(context);
        return _buildBaseView(tutorialProvider);
      },
    );
  }

  Widget _buildBaseView(TutorialProvider tutorialProvider) {
    return BaseView<HomeViewProvider>(
      onlyDesktop: true,
      screenBackgroundColor: Colors.transparent,
      extendBodyBehindAppBar: false,
      addDefaultPadding: false,
      wrapWithSafeArea: false,
      resizeToAvoidBottomInset: true,
      systemNavigationBarColor: context.theme.primaryColor,
      viewModel: homeViewProvider,
      onModelReady: (model) => _handleModelReady(model, tutorialProvider),
      screenBackgroundImage: const VisaHeaderBackground(),
      buildAppBar: _buildAppBar() as PreferredSizeWidget,
      onPageBuilderMobileView:
          (BuildContext context, HomeViewProvider viewModel) {
        return _buildMobileView(context, viewModel, tutorialProvider);
      },
    );
  }

  void _handleModelReady(
      HomeViewProvider model, TutorialProvider tutorialProvider) {
    Utils.announceMessage(S.of(context).home_screen);
    model.setState();
  }

  Widget _buildAppBar() {
    return VisaAppBar(
      isHamburgerIconShow: _shouldShowHamburgerIcon(),
      isActionButtonShow: true,
      brandingLogoColor: _getBrandingLogoColor(),
      isRightSideHamburgerIconShow: true,
    );
  }

  bool _shouldShowHamburgerIcon() {
    return responsive.kISWeb() &&
        (responsive.isMobile(context: context) ||
            responsive.isTablet(context: context));
  }

  Color _getBrandingLogoColor() {
    return Provider.of<SelectLanguageGenericProvider>(context, listen: false)
            .isRTL
        ? VisaColors.white
        : context.theme.primaryColor;
  }

  Widget _buildMobileView(BuildContext context, HomeViewProvider viewModel,
      TutorialProvider tutorialProvider) {
    return Padding(
      padding: EdgeInsets.only(top: viewModel.appBarTotalHeight),
      child: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(
          Sizes.sixteen,
          Sizes.sixteen,
          Sizes.sixteen,
          Sizes.eighteen,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildMainContent(viewModel),
            _buildTutorialWidgets(tutorialProvider, viewModel),
          ],
        ),
      ),
    );
  }

  Widget _buildMainContent(HomeViewProvider viewModel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        HomeScreenGreetingTextWidget(homeViewProvider: viewModel),
        HomeScreenTicketCardWidget(homeViewProvider: viewModel),
        _buildCompanionOrWalletContent(viewModel),
      ],
    );
  }

  Widget _buildCompanionOrWalletContent(HomeViewProvider viewModel) {
    if (viewModel.iCompanion) {
      return _buildCompanionContent(viewModel);
    } else {
      return _buildWalletContent(viewModel);
    }
  }

  Widget _buildCompanionContent(HomeViewProvider viewModel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        HomeScreenCompanionBookTravel(homeViewProvider: viewModel),
        AppSizes.smallVS,
        HomeScreenEvaTravelWidget(homeViewProvider: viewModel),
      ],
    );
  }

  Widget _buildWalletContent(HomeViewProvider viewModel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        HomeScreenEvaTravelWidget(homeViewProvider: viewModel),
        AppSizes.smallVS,
        HomeScreenWalletAndTravelWidget(homeViewProvider: viewModel),
      ],
    );
  }

  Widget _buildTutorialWidgets(
      TutorialProvider tutorialProvider, HomeViewProvider viewModel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTutorialBlankWidget(tutorialProvider),
        _buildTutorialSpacing(tutorialProvider, viewModel),
      ],
    );
  }

  Widget _buildTutorialBlankWidget(TutorialProvider tutorialProvider) {
    if (!tutorialProvider.tutorialStatus) {
      return TutorialBlankWidget(
        tutorialBlank: tutorialProvider.tutorialBlank,
        isComeFromHome: true,
      );
    }
    return const SizedBox.shrink();
  }

  Widget _buildTutorialSpacing(
      TutorialProvider tutorialProvider, HomeViewProvider viewModel) {
    if (_shouldShowTutorialSpacing(tutorialProvider, viewModel)) {
      return VisaSizeBox(
        height: (context.screenHeight / 2.clamp(0, 600)), // max 600
      );
    }
    return const SizedBox.shrink();
  }

  bool _shouldShowTutorialSpacing(
      TutorialProvider tutorialProvider, HomeViewProvider viewModel) {
    if (!tutorialProvider.tutorialLoaded) return false;

    if (viewModel.iCompanion) {
      return tutorialProvider.index >= 1;
    } else {
      return context.screenHeight <= 700
          ? tutorialProvider.index >= 1
          : tutorialProvider.index >= 2;
    }
  }
}
