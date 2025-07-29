import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:visaamigo/core/base/view/base_view.dart';
import 'package:visaamigo/core/theme/theme.dart';
import 'package:visaamigo/custom_widgets/visa_appbar.dart';
import 'package:visaamigo/custom_widgets/visa_textview.dart';
import 'package:visaamigo/features/home/providers/home_provider.dart';
import 'package:visaamigo/features/home/widgets/first_time_tutorial_view.dart';
import 'package:visaamigo/features/home/widgets/home_card_primary.dart';
import 'package:visaamigo/features/home/widgets/home_card_secondary.dart';
import 'package:visaamigo/features/home/widgets/home_tile_primary.dart';
import 'package:visaamigo/features/home/widgets/home_title_secondary.dart';
import 'package:visaamigo/features/home/widgets/tutorial_widget.dart';
import 'package:visaamigo/generated/l10n.dart';
import 'package:visaamigo/utils/app_extensions.dart';
import 'package:visaamigo/utils/const_screen_size.dart' show AppSizes;

import '../../../custom_widgets/visa_button.dart';
import '../providers/tutorial_provider.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  late HomeViewProvider homeViewProvider;
  late TutorialProvider tutorialProvider;
  late double tenHeight;
  @override
  void initState() {
    super.initState();
    // Retrieve dependencies using GetIt
    homeViewProvider = GetIt.I<HomeViewProvider>();
    tutorialProvider = GetIt.I<TutorialProvider>();
    tutorialProvider.setContext(context);
    // Initialize the HomeViewProvider
    homeViewProvider.setContext(context);
    homeViewProvider.init(context);
  }

  @override
  didChangeDependencies() {
    super.didChangeDependencies();
    // Initialize the HomeViewProvider again in case the context has changed
    tenHeight = AppSizes.ten;
  }

  @override
  Widget build(BuildContext context) {
    return ShowCaseWidget(
      builder: (context) {
        return _buildBaseView();
      },
    );
  }

  Widget _buildBaseView() {
    return BaseView<HomeViewProvider>(
      viewModel: homeViewProvider,
      addDefaultPadding: false,
      buildAppBar: const VisaAppBar(),
      onPageBuilderMobileView:
          (BuildContext context, HomeViewProvider viewModel) {
        return _buildMobileView(context, viewModel);
      },
    );
  }

  Widget _buildMobileView(BuildContext context, HomeViewProvider viewModel) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeaderSection(context, viewModel),
          _buildLogoutButton(viewModel),
          _buildHomePageContent(context, viewModel),
        ],
      ),
    );
  }

  Widget _buildHeaderSection(BuildContext context, HomeViewProvider viewModel) {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: AppSizes.iconXXSmall, vertical: tenHeight),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildGreetingText(context, viewModel),
          _buildSubtitleText(context),
        ],
      ),
    );
  }

  Widget _buildGreetingText(BuildContext context, HomeViewProvider viewModel) {
    return VisaTextView(
      text: S.of(context).helloMessage(viewModel.userModel?.firstName ?? ""),
      style: VisaTextStyle.bodyLarge,
      customColor: VisaColors.black,
      colorTheme: VisaTextTheme.customTextColor,
    );
  }

  Widget _buildSubtitleText(BuildContext context) {
    return VisaTextView(
      text: S.of(context).lets_plan_your_trip,
      style: VisaTextStyle.bodyLarge,
      customColor: VisaColors.textTertiary5,
      colorTheme: VisaTextTheme.customTextColor,
    );
  }

  Widget _buildLogoutButton(HomeViewProvider viewModel) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: VisaButton(
        text: "Logodsdsut",
        icon: Icons.arrow_forward,
        onPressed: () {
          viewModel.signOutButtonPressed();
        },
        height: 50,
        variant: VisaButtonVariant.primary,
      ),
    );
  }

  Widget _buildHomePageContent(
      BuildContext context, HomeViewProvider viewModel) {
    if (!viewModel.showHomePage) {
      return const SizedBox();
    }

    return Column(
      children: [
        _buildTitleCarousel(context, viewModel),
        _buildBodyCarousel(context, viewModel),
      ],
    );
  }

  Widget _buildTitleCarousel(BuildContext context, HomeViewProvider viewModel) {
    return Showcase.withWidget(
      key: tutorialProvider.tutorialTicketKey,
      height: 200.h,
      disposeOnTap: false,
      disableBarrierInteraction: true,
      disableDefaultTargetGestures: true,
      width: MediaQuery.sizeOf(context).width,
      targetPadding: EdgeInsets.symmetric(
          horizontal: AppSizes.twentyFive, vertical: tenHeight),
      tooltipPosition: TooltipPosition.bottom,
      overlayOpacity: 0.5,
      tooltipActionConfig: _buildTooltipActionConfig(),
      tooltipActions: _buildTooltipActions(),
      container: _buildTutorialContainer(context),
      child: _buildTitleCarouselSlider(viewModel),
    );
  }

  TooltipActionConfig _buildTooltipActionConfig() {
    return const TooltipActionConfig(
      alignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      position: TooltipActionPosition.outside,
    );
  }

  List<TooltipActionButton> _buildTooltipActions() {
    return const [
      TooltipActionButton(
        backgroundColor: Colors.transparent,
        type: TooltipDefaultActionType.previous,
        textStyle: TextStyle(color: Colors.transparent),
      ),
    ];
  }

  Widget _buildTutorialContainer(BuildContext context) {
    return FirstTimeTutorialView(
      mainTitle: S.of(context).ftt_title,
      desc: S.of(context).ftt_match_ticket_desc,
      tooltipPosition: true,
      showNext: true,
      showBack: false,
      next: tutorialProvider.next,
      previous: tutorialProvider.previous,
      close: tutorialProvider.closeOverlayTutorial,
    );
  }

  Widget _buildTitleCarouselSlider(HomeViewProvider viewModel) {
    return CarouselSlider.builder(
      carouselController: viewModel.carouselControllerHomeTitle,
      itemCount: viewModel.homeTitle.length,
      options: _buildTitleCarouselOptions(),
      itemBuilder: (BuildContext context, int itemIndex, int pageViewIndex) {
        return _buildTitleItem(viewModel, itemIndex);
      },
    );
  }

  CarouselOptions _buildTitleCarouselOptions() {
    return CarouselOptions(
      height: 50.h,
      viewportFraction: (0.9).w,
      enableInfiniteScroll: false,
      reverse: false,
      enlargeCenterPage: false,
      onPageChanged: (_, c) {
        homeViewProvider.onPrimaryTitleScroll(_);
      },
      disableCenter: true,
      scrollDirection: Axis.horizontal,
    );
  }

  Widget _buildTitleItem(HomeViewProvider viewModel, int itemIndex) {
    return viewModel.homeTitle[itemIndex].type == 1
        ? HomeTilePrimary(
            homeTitle: viewModel.homeTitle,
            homeTitleColor: viewModel.homeTitleColor,
            homeTitleIndex: itemIndex,
          )
        : HomeTileSecondary(
            homeTitle: viewModel.homeTitle,
            homeTitleColor: viewModel.homeTitleColor,
            homeTitleIndex: itemIndex,
          );
  }

  Widget _buildBodyCarousel(BuildContext context, HomeViewProvider viewModel) {
    return CarouselSlider.builder(
      carouselController: viewModel.carouselControllerHomeBody,
      itemCount: viewModel.homeTitle.length,
      options: _buildBodyCarouselOptions(context),
      itemBuilder: (BuildContext context, int titleIndex, int pageViewIndex) {
        return _buildBodyItem(context, viewModel, titleIndex);
      },
    );
  }

  CarouselOptions _buildBodyCarouselOptions(BuildContext context) {
    return CarouselOptions(
      viewportFraction: 1.w,
      height: (context.screenHeight - 200).h,
      initialPage: 0,
      enableInfiniteScroll: false,
      reverse: false,
      enlargeCenterPage: false,
      onPageChanged: (_, c) {
        homeViewProvider.onSecondaryTitleScroll(_);
      },
      scrollDirection: Axis.horizontal,
    );
  }

  Widget _buildBodyItem(
      BuildContext context, HomeViewProvider viewModel, int titleIndex) {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: AppSizes.tweentyWidth, vertical: tenHeight),
      child: SingleChildScrollView(
        child: Column(
          children: _buildBodyItems(context, viewModel, titleIndex),
        ),
      ),
    );
  }

  List<Widget> _buildBodyItems(
      BuildContext context, HomeViewProvider viewModel, int titleIndex) {
    return List.generate(
        viewModel.homeTitle.elementAt(titleIndex).subTitle.length, (bodyIndex) {
      return _buildBodyItemWidget(context, viewModel, titleIndex, bodyIndex);
    });
  }

  Widget _buildBodyItemWidget(BuildContext context, HomeViewProvider viewModel,
      int titleIndex, int bodyIndex) {
    if (_shouldShowTutorialWidget(bodyIndex)) {
      return _buildTutorialWidget(context, viewModel, titleIndex, bodyIndex);
    }
    return _buildHomeCard(viewModel, titleIndex, bodyIndex);
  }

  bool _shouldShowTutorialWidget(int bodyIndex) {
    return !tutorialProvider.tutorialStatus &&
        (bodyIndex == 0 || bodyIndex == 2);
  }

  Widget _buildTutorialWidget(BuildContext context, HomeViewProvider viewModel,
      int titleIndex, int bodyIndex) {
    final tutorialKey = bodyIndex == 0
        ? tutorialProvider.tutorialEvaTravelKey
        : tutorialProvider.tutorialWalletKey;
    final toolTipPosition = bodyIndex == 0;

    return TutorialWidget(
      tutorialKey: tutorialKey,
      mainTitle: S.of(context).ftt_match_ticket,
      subTitle: S.of(context).ftt_match_ticket_desc,
      next: tutorialProvider.next,
      close: tutorialProvider.closeOverlayTutorial,
      previous: tutorialProvider.previous,
      toolTipPosition: toolTipPosition,
      child: _buildHomeCard(viewModel, titleIndex, bodyIndex),
    );
  }

  Widget _buildHomeCard(
      HomeViewProvider viewModel, int titleIndex, int bodyIndex) {
    return viewModel.homeTitle[titleIndex].type == 1
        ? HomeCardPrimary(
            homeTile: viewModel.homeTitle,
            inxHomeTile: titleIndex,
            inxHomeSubTile: bodyIndex,
            homeTitleColor: viewModel.homeTitleColor)
        : HomeCardSecondary(
            homeTile: viewModel.homeTitle,
            inxHomeTile: titleIndex,
            inxHomeSubTile: bodyIndex,
            homeTitleColor: viewModel.homeTitleColor);
  }
}
