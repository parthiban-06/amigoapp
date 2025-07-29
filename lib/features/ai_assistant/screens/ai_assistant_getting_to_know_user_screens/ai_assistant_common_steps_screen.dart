import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart' show OrdinalSortKey;
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart' show GetIt;
import 'package:provider/provider.dart';
import 'package:visaamigo/core/theme/theme.dart';
import 'package:visaamigo/custom_widgets/visa_appbar.dart';
import 'package:visaamigo/custom_widgets/visa_appbar_actions.dart'
    show VisaAppBarActions;
import 'package:visaamigo/custom_widgets/visa_blurred_container.dart';
import 'package:visaamigo/custom_widgets/visa_size_box.dart';
import 'package:visaamigo/custom_widgets/visa_svg_icon.dart' show VisaSvgIcon;
import 'package:visaamigo/custom_widgets/visa_textview.dart';
import 'package:visaamigo/features/ai_assistant/screens/ai_assistant_getting_to_know_user_screens/widgets/ai_build_background_section_widget.dart';
import 'package:visaamigo/features/ai_assistant/screens/ai_assistant_getting_to_know_user_screens/widgets/ai_build_page_content_widget.dart';
import 'package:visaamigo/utils/app_extensions.dart';
import 'package:visaamigo/utils/utils.dart' show Utils;

import '../../../../core/base/view/base_view.dart';
import '../../../../custom_widgets/visa_button.dart';
import '../../../../custom_widgets/visa_sliding_text_view_animation.dart';
import '../../../../generated/assets.dart';
import '../../../../generated/l10n.dart';
import '../../../../utils/const_screen_size.dart';
import '../../providers/ai_assistant_common_steps_provider.dart';
import '../../providers/ai_assistant_main_provider.dart';
import 'widgets/ai_assistant_progress_stepper_widget.dart';

class AiAssistantCommonStepsScreen extends StatefulWidget {
  const AiAssistantCommonStepsScreen({super.key});

  @override
  State<StatefulWidget> createState() => AiAssistantCommonStepsScreenState();
}

class AiAssistantCommonStepsScreenState
    extends State<AiAssistantCommonStepsScreen> with TickerProviderStateMixin {
  late AiAssistantMainProvider aiAssistantProvider;
  late AiAssistantCommonStepsProvider viewModel;
  late S s;
  late bool isDesktop;
  late double zeroPadding;
  bool semanticsAnnounced = false;

  @override
  void initState() {
    super.initState();
    aiAssistantProvider =
        Provider.of<AiAssistantMainProvider>(context, listen: false);
    aiAssistantProvider.init(this);
    // aiAssistantProvider = GetIt.I<AiAssistantMainProvider>();
    viewModel = GetIt.I<AiAssistantCommonStepsProvider>();
    zeroPadding = AppSizes.zero;
  }

  @override
  didChangeDependencies() {
    super.didChangeDependencies();
    s = S.of(context);
    if (!semanticsAnnounced) {
      semanticsAnnounced = true;
      Utils.announceMessage(S.of(context).getting_to_konw_screen);
    }
  }

  // Build Center Content Widget
  Widget _buildContent(
      double screenHeight, AiAssistantCommonStepsProvider viewModel) {
    return isDesktop
        ? Center(child: _buildSubContent())
        : Transform.translate(
            offset: Offset(
              0,
              -screenHeight * aiAssistantProvider.animation.value,
            ),
            child: _buildSubContent());
  }

  Widget _buildSubContent() => Consumer<AiAssistantCommonStepsProvider>(
          builder: (context, viewModels, child) {
        return Container(
          margin: EdgeInsets.only(
              top: (isDesktop && viewModels.currentStep == 1) ? 100 : 0),
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTapUp: (TapUpDetails details) {
              getTapforClick(viewModels);
            },
            // onTapUp: (TapUpDetails details) {},
            onDoubleTap: () {
              getTapforClick(viewModels);
            },
            child: SizedBox(
              width: context.screenWidth,
              child: SizedBox(
                width: isDesktop
                    ? AppSizes.fourFiveFourWidth
                    : context.screenWidth,
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 0, sigmaY: 0),
                  child: aiAssistantProvider
                      .pages[aiAssistantProvider.currentPage],
                ),
              ),
            ),
          ),
        );
      });

  Widget questionsCount() => Padding(
        padding: EdgeInsets.symmetric(horizontal: Sizes.sixteen),
        child: Semantics(
          focusable: true,
          excludeSemantics: true,
          sortKey: const OrdinalSortKey(2.0),
          label:
              '${s.step}${viewModel.currentStep}/${aiAssistantProvider.pages.length}',
          child: Row(
            spacing: AppSizes.fiveRadius,
            children: [
              VisaTextView(
                semantics: false,
                text: s.step.toUpperCase(),
                style: VisaTextStyle.displayBodyXs,
                colorTheme: VisaTextTheme.customTextColor,
                customColor:
                    isDesktop ? VisaColors.white : VisaColors.primaryDark,
                fontFamily: VisaFontWeight.medium,
                overflow: TextOverflow.visible,
                letterSpacing: Sizes.two,
              ),
              DecoratedBox(
                decoration: BoxDecoration(
                  color: VisaColors.transparent, // Background color
                  borderRadius:
                      BorderRadius.circular(zeroPadding), // Rounded corners
                ),
                child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: zeroPadding,
                      vertical: zeroPadding,
                    ),
                    // Adjust padding as needed
                    child:
                        // Consumer<AiAssistantCommonStepsProvider>(
                        //     builder: (context, viewModel, child) {
                        //   return
                        VisaSlidingTextViewAnimation(
                      semantics: false,
                      text:
                          '${aiAssistantProvider.currentPage + 1}/${aiAssistantProvider.pages.length}',
                      style: VisaTextStyle.displayBodyXs,
                      colorTheme: VisaTextTheme.customTextColor,
                      customColor:
                          isDesktop ? VisaColors.white : VisaColors.black,
                      fontFamily: VisaFontWeight.medium,
                      overflow: TextOverflow.visible,
                      letterSpacing: Sizes.two,
                    )
                    // }),
                    ),
              )
            ],
          ),
        ),
      );

  Widget webAppBar() => Padding(
        padding: EdgeInsets.only(
            top: AppSizes.heightFourty,
            bottom: AppSizes.heightXLarge,
            left: AppSizes.dimMedium,
            right: AppSizes.dimMedium),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            VisaSvgIcon(
              semanticsIndex: 1,
              assetPath: Assets.iconsIcVisaLogo,
              height: AppSizes.heightFourty,
              isIconFlip: false,
              color: VisaColors.white,
              semantics: aiAssistantProvider.currentPage == 1 ? true : false,
            ),
            questionsCount(),
            Semantics(
              focused: true,
              focusable: true,
              // excludeSemantics: true,
              sortKey: const OrdinalSortKey(3.0),
              child: VisaAppBarActions(
                onPressed: () {
                  aiAssistantProvider.navigateToHomeScreen();
                },
                visaTextStyle: VisaTextStyle.bodyMedium,
                visaTextTheme: isDesktop
                    ? VisaTextTheme.customTextColor
                    : VisaTextTheme.primaryDark,
                isIconShow: true,
                isTextShow: true,
                text: s.close.toUpperCase(),
                icons: Icons.close,
                iconColor: VisaColors.white,
                iconSize: AppSizes.sixteenRadius,
                letterSpacing: AppSizes.twoRadius,
                customColor: VisaColors.white,
                padding: EdgeInsetsDirectional.only(end: Sizes.eight),
              ),
            )
          ],
        ),
      );

  @override
  Widget build(BuildContext context) {
    _updateDesktopState();
    return Stack(
      children: [
        _buildAnimatedBackground(),
        _buildMainContentSection(),
      ],
    );
  }

  /// Updates the desktop state based on provider
  void _updateDesktopState() {
    isDesktop =
        aiAssistantProvider.isDesktopView || aiAssistantProvider.isTabletView;
  }

  /// Builds the animated background section
  Widget _buildAnimatedBackground() {
    return AnimatedBuilder(
      animation: aiAssistantProvider.backgroundAnimation,
      builder: (context, child) {
        final screenHeight = context.screenHeight;
        final currentOffset =
            -aiAssistantProvider.backgroundAnimation.value * screenHeight;
        final nextOffset =
            screenHeight * (1 - aiAssistantProvider.backgroundAnimation.value);

        return Stack(
          children: [
            AiBuildBackgroundSectionWidget(
              pageIndex: aiAssistantProvider.currentPage,
              offset: currentOffset,
            ),
            AiBuildBackgroundSectionWidget(
              pageIndex: aiAssistantProvider.nextPage,
              offset: nextOffset,
            ),
          ],
        );
      },
    );
  }

  /// Builds the main content section
  Widget _buildMainContentSection() {
    return BaseView<AiAssistantCommonStepsProvider>(
      viewModel: AiAssistantCommonStepsProvider(),
      addDefaultPadding: false,
      extendBodyBehindAppBar: false,
      wrapWithSafeArea: false,
      onlyDesktop: true,
      screenBackgroundColor: VisaColors.transparent,
      buildAppBar: _buildAppBar(),
      onDispose: _handleDispose,
      onPageBuilderMobileView: _buildMobileView,
    );
  }

  /// Builds the app bar
  PreferredSizeWidget _buildAppBar() {
    return VisaAppBar(
      semanticsIndex: 1,
      visaIconColor: VisaColors.white,
      isActionButtonShow: true,
      isCancelWithTextButtonShow: true,
      onCancelPress: () => aiAssistantProvider.navigateToHomeScreen(),
    );
  }

  /// Handles disposal of controllers
  void _handleDispose() {
    aiAssistantProvider.controller.dispose();
    aiAssistantProvider.gaugeAnimationController.dispose();
    for (final controller in aiAssistantProvider.shadowControllers) {
      if (controller.isAnimating) {
        controller.dispose();
      }
    }
    aiAssistantProvider.clearAllLists();
  }

  /// Builds the mobile view content
  Widget _buildMobileView(
      BuildContext context, AiAssistantCommonStepsProvider viewModel) {
    if (aiAssistantProvider.pages.isEmpty) {
      return const SizedBox.shrink();
    }

    return Consumer<AiAssistantMainProvider>(
      builder: (context, mainProvider, child) {
        _updateDesktopStateFromProvider(mainProvider);
        return Stack(
          alignment: Alignment.topLeft,
          children: [
            if (isDesktop) webAppBar(),
            _buildMainContent(mainProvider, viewModel),
            _buildTopBlurEffect(mainProvider, viewModel),
            _buildTopSection(mainProvider, viewModel),
            _buildPageContent(mainProvider, viewModel),
            _buildBottomSection(mainProvider, viewModel),
          ],
        );
      },
    );
  }

  /// Updates desktop state from provider
  void _updateDesktopStateFromProvider(AiAssistantMainProvider mainProvider) {
    isDesktop = mainProvider.isDesktopView || mainProvider.isTabletView;
  }

  /// Builds the main content area
  Widget _buildMainContent(AiAssistantMainProvider mainProvider,
      AiAssistantCommonStepsProvider viewModel) {
    return AnimatedBuilder(
      animation: aiAssistantProvider.animation,
      builder: (context, child) {
        final screenHeight = context.screenHeight - 80;
        final content = _buildContent(screenHeight, viewModel);
        return _buildContentWrapper(mainProvider, viewModel, content);
      },
    );
  }

  /// Builds the content wrapper with scroll view if needed
  Widget _buildContentWrapper(AiAssistantMainProvider mainProvider,
      AiAssistantCommonStepsProvider viewModel, Widget content) {
    if (_shouldWrapWithScrollView(mainProvider)) {
      return _buildScrollableContent(mainProvider, viewModel, content);
    }
    return _buildNonScrollableContent(mainProvider, content);
  }

  /// Checks if content should be wrapped with scroll view
  bool _shouldWrapWithScrollView(AiAssistantMainProvider mainProvider) {
    return mainProvider.shouldWrapWithScrollView ||
        (_isLargeFontSize() && mainProvider.currentPage == 2 && !isDesktop);
  }

  /// Checks if font size is large
  bool _isLargeFontSize() {
    return Utils.getFontSize(context);
  }

  /// Builds scrollable content
  Widget _buildScrollableContent(AiAssistantMainProvider mainProvider,
      AiAssistantCommonStepsProvider viewModel, Widget content) {
    return Container(
      margin: _getScrollableMargin(viewModel),
      child: SingleChildScrollView(
        physics: _getScrollPhysics(viewModel),
        padding: _getScrollablePadding(mainProvider, viewModel),
        child: content,
      ),
    );
  }

  /// Gets scrollable margin
  EdgeInsets _getScrollableMargin(AiAssistantCommonStepsProvider viewModel) {
    return EdgeInsets.only(
      top: _shouldShowTopMargin(viewModel) ? AppSizes.heightSeventySeven : 0,
    );
  }

  /// Checks if top margin should be shown
  bool _shouldShowTopMargin(AiAssistantCommonStepsProvider viewModel) {
    return isDesktop && viewModel.currentStep == 2 && !_isLargeFontSize();
  }

  /// Gets scroll physics
  ScrollPhysics _getScrollPhysics(AiAssistantCommonStepsProvider viewModel) {
    return (viewModel.currentStep == 2 && isDesktop)
        ? const NeverScrollableScrollPhysics()
        : const AlwaysScrollableScrollPhysics();
  }

  /// Gets scrollable padding
  EdgeInsets _getScrollablePadding(AiAssistantMainProvider mainProvider,
      AiAssistantCommonStepsProvider viewModel) {
    return EdgeInsets.only(
      top: _getTopPadding(mainProvider, viewModel),
      bottom: Sizes.hundredInt.h,
    );
  }

  /// Gets top padding for scrollable content
  double _getTopPadding(AiAssistantMainProvider mainProvider,
      AiAssistantCommonStepsProvider viewModel) {
    if (mainProvider.pages.length <= 1) {
      return aiAssistantProvider.appBarTotalHeight + Sizes.oneHundredFiftyInt.h;
    }

    if (isDesktop && viewModel.currentStep == 2) {
      return Sizes.oneHundredFiftyInt.h;
    }

    return aiAssistantProvider.appBarTotalHeight + Sizes.oneHundredSixtyInt.h;
  }

  /// Builds non-scrollable content
  Widget _buildNonScrollableContent(
      AiAssistantMainProvider mainProvider, Widget content) {
    if (isDesktop && viewModel.currentStep == 2) {
      return Padding(
        padding: EdgeInsets.only(
          top: mainProvider.isTabletView
              ? AppSizes.heightFourty
              : aiAssistantProvider.appBarTotalHeight +
                  Sizes.oneHundredSixtyInt.h,
        ),
        child: content,
      );
    }
    return content;
  }

  /// Builds top blur effect
  Widget _buildTopBlurEffect(AiAssistantMainProvider mainProvider,
      AiAssistantCommonStepsProvider viewModel) {
    if (!_shouldShowTopBlur(mainProvider, viewModel)) {
      return const SizedBox.shrink();
    }

    return AnimatedBuilder(
      animation: aiAssistantProvider.animation,
      builder: (context, child) {
        final screenHeight = context.screenHeight - 80;
        return Transform.translate(
          offset:
              Offset(0, -screenHeight * aiAssistantProvider.animation.value),
          child: IgnorePointer(
            child: VisaBlurredContainer(
              height: aiAssistantProvider.appBarTotalHeight + 330.h,
              width: context.screenWidth,
              blurX: 4.0,
              blurY: 4.0,
              opacity: 0.9,
              isTransformImage: true,
              imagePath: Assets.imagesBubbleBgTopBlur,
            ),
          ),
        );
      },
    );
  }

  /// Checks if top blur should be shown
  bool _shouldShowTopBlur(AiAssistantMainProvider mainProvider,
      AiAssistantCommonStepsProvider viewModel) {
    return mainProvider.shouldWrapWithScrollView &&
        !(viewModel.currentStep == 2 && isDesktop);
  }

  /// Builds top section with progress
  Widget _buildTopSection(AiAssistantMainProvider mainProvider,
      AiAssistantCommonStepsProvider viewModel) {
    if (mainProvider.pages.length <= 1) {
      return const SizedBox.shrink();
    }

    return KeyboardVisibilityBuilder(
      builder: (context, isKeyboardVisible) {
        if (isKeyboardVisible) {
          return const SizedBox.shrink();
        }

        return IgnorePointer(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTopSpacing(),
              if (!isDesktop) _buildQuestionProgress(viewModel),
              AppSizes.smallVS,
              if (!isDesktop) _buildProgressStepper(viewModel),
            ],
          ),
        );
      },
    );
  }

  /// Builds top spacing
  Widget _buildTopSpacing() {
    return VisaSizeBox(
      height:
          aiAssistantProvider.appBarTotalHeight + Sizes.sixteenInt.toDouble(),
    );
  }

  /// Builds question progress indicator
  Widget _buildQuestionProgress(AiAssistantCommonStepsProvider viewModel) {
    return Semantics(
      enabled: true,
      excludeSemantics: true,
      label:
          '${s.question}${viewModel.currentStep}  ${s.of_question}  ${aiAssistantProvider.pages.length}',
      sortKey: const OrdinalSortKey(2.0),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: Sizes.sixteen),
        child: Row(
          spacing: AppSizes.fiveRadius,
          children: [
            _buildQuestionText(),
            _buildQuestionNumber(viewModel),
          ],
        ),
      ),
    );
  }

  /// Builds question text
  Widget _buildQuestionText() {
    return VisaTextView(
      text: s.question.toUpperCase(),
      style: VisaTextStyle.displayBodyXs,
      colorTheme: VisaTextTheme.customTextColor,
      customColor: isDesktop ? VisaColors.white : VisaColors.primaryDark,
      fontFamily: VisaFontWeight.medium,
      overflow: TextOverflow.visible,
      semantics: false,
      letterSpacing: Sizes.two,
    );
  }

  /// Builds question number
  Widget _buildQuestionNumber(AiAssistantCommonStepsProvider viewModel) {
    return VisaTextView(
      semantics: false,
      text: '${viewModel.currentStep}/${aiAssistantProvider.pages.length}',
      style: VisaTextStyle.displayBodyXs,
      colorTheme: VisaTextTheme.customTextColor,
      customColor: isDesktop ? VisaColors.white : VisaColors.black,
      fontFamily: VisaFontWeight.medium,
      overflow: TextOverflow.visible,
      letterSpacing: Sizes.two,
    );
  }

  /// Builds progress stepper
  Widget _buildProgressStepper(AiAssistantCommonStepsProvider viewModel) {
    return AiAssistantProgressStepperWidget(
      currentStep: viewModel.currentStep,
      totalSteps: aiAssistantProvider.pages.length,
    );
  }

  /// Builds page content
  Widget _buildPageContent(AiAssistantMainProvider mainProvider,
      AiAssistantCommonStepsProvider viewModel) {
    return AnimatedBuilder(
      animation: aiAssistantProvider.animation,
      builder: (context, child) {
        final screenHeight = context.screenHeight - 80;
        return Stack(
          children: [
            _buildCurrentPageContent(viewModel, screenHeight),
            _buildNextPageContent(viewModel, screenHeight),
          ],
        );
      },
    );
  }

  /// Builds current page content
  Widget _buildCurrentPageContent(
      AiAssistantCommonStepsProvider viewModel, double screenHeight) {
    return AiBuildPageContentWidget(
      pageIndex: aiAssistantProvider.currentPage,
      yOffset: -screenHeight * aiAssistantProvider.animation.value,
      viewModel: viewModel,
      appBarTotalHeight: aiAssistantProvider.appBarTotalHeight,
    );
  }

  /// Builds next page content
  Widget _buildNextPageContent(
      AiAssistantCommonStepsProvider viewModel, double screenHeight) {
    return AiBuildPageContentWidget(
      pageIndex: aiAssistantProvider.nextPage,
      yOffset: screenHeight * (1 - aiAssistantProvider.animation.value),
      viewModel: viewModel,
      appBarTotalHeight: aiAssistantProvider.appBarTotalHeight,
    );
  }

  /// Builds bottom section with buttons
  Widget _buildBottomSection(AiAssistantMainProvider mainProvider,
      AiAssistantCommonStepsProvider viewModel) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        _buildBottomBlurEffect(mainProvider, viewModel),
        _buildBottomButtons(mainProvider, viewModel),
      ],
    );
  }

  /// Builds bottom blur effect
  Widget _buildBottomBlurEffect(AiAssistantMainProvider mainProvider,
      AiAssistantCommonStepsProvider viewModel) {
    if (!_shouldShowBottomBlur(mainProvider, viewModel)) {
      return const SizedBox.shrink();
    }

    return IgnorePointer(
      child: VisaBlurredContainer(
        width: context.screenWidth,
        blurX: 4.0,
        blurY: 4.0,
        opacity: 0.9,
        imagePath: Assets.imagesBottomBlur,
      ),
    );
  }

  /// Checks if bottom blur should be shown
  bool _shouldShowBottomBlur(AiAssistantMainProvider mainProvider,
      AiAssistantCommonStepsProvider viewModel) {
    return mainProvider.shouldWrapWithScrollView &&
        !(viewModel.currentStep == 2 && isDesktop);
  }

  /// Builds bottom buttons
  Widget _buildBottomButtons(AiAssistantMainProvider mainProvider,
      AiAssistantCommonStepsProvider viewModel) {
    if (_shouldHideButtons(mainProvider, viewModel)) {
      return const SizedBox.shrink();
    }
    return Center(
      child: SizedBox(
        width: isDesktop ? 400.w : null,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: AppSizes.sixteenRadius,
                vertical: AppSizes.twentyEightRadius,
              ),
              child: _buildButtonLayout(viewModel),
            ),
          ],
        ),
      ),
    );
  }

  /// Checks if buttons should be hidden
  bool _shouldHideButtons(AiAssistantMainProvider mainProvider,
      AiAssistantCommonStepsProvider viewModel) {
    final isDesktopStep2 =
        (mainProvider.isDesktopView || mainProvider.isTabletView) &&
            (mainProvider.currentPage + 1 == 2);
    final isMobileLargeFont = !isDesktop &&
        (mainProvider.currentPage == 2 &&
            MediaQuery.of(context).textScaler.scale(1) > 1.25);

    return isDesktopStep2 || isMobileLargeFont;
  }

  Widget _buildButtonLayout(AiAssistantCommonStepsProvider viewModel) {
    final isGerman = Localizations.localeOf(context).languageCode == 'de';

    if (isGerman) {
      return _buildHorizontalButtonLayout(viewModel, 2, 2);
    } else {
      return _buildHorizontalButtonLayout(viewModel, 1, 2);
    }
  }

  /// Builds horizontal button layout
  Widget _buildHorizontalButtonLayout(
      AiAssistantCommonStepsProvider viewModel, int flexValue, int flexValue2) {
    return Row(
      children: [
        Expanded(
          flex: flexValue,
          child: _buildSkipButton(viewModel),
        ),
        SizedBox(width: 22.w),
        Expanded(
          flex: flexValue2,
          child: _buildContinueButton(viewModel),
        ),
      ],
    );
  }

  /// Builds continue button
  Widget _buildContinueButton(AiAssistantCommonStepsProvider viewModel) {
    return VisaButton(
      addDefaultAnalyticsEvent: false,
      text: s.txt_continue,
      height: AppSizes.fiftySevenInt.toDouble(),
      width: context.screenWidth,
      variant: VisaButtonVariant.white,
      fontWeight: VisaFontWeight.medium,
      letterSpacing: zeroPadding,
      onPressed: () => _handleContinueAction(viewModel),
    );
  }

  /// Builds skip button
  Widget _buildSkipButton(AiAssistantCommonStepsProvider viewModel) {
    return VisaButton(
      text: s.skip,
      height: AppSizes.fiftyThreeInt.toDouble(),
      width: AppSizes.oneThirtyTwo.toDouble(),
      variant: _getSkipButtonVariant(),
      fontWeight: VisaFontWeight.medium,
      letterSpacing: zeroPadding,
      isOutlined: !isDesktop,
      onPressed: () => _handleSkipAction(viewModel),
    );
  }

  /// Gets skip button variant
  VisaButtonVariant _getSkipButtonVariant() {
    return isDesktop ? VisaButtonVariant.primary : VisaButtonVariant.white;
  }

  /// Handles continue button action
  Future<void> _handleContinueAction(
      AiAssistantCommonStepsProvider viewModel) async {
    if (_isLastStep(viewModel)) {
      aiAssistantProvider.updateTeamPreference();
      aiAssistantProvider.navigateToAiAssistantThanksScreen();
    } else {
      await _proceedToNextStep(viewModel, true);
    }
  }

  /// Handles skip button action
  Future<void> _handleSkipAction(
      AiAssistantCommonStepsProvider viewModel) async {
    if (_isLastStep(viewModel)) {
      aiAssistantProvider.navigateToAiAssistantThanksScreen();
    } else {
      await _proceedToNextStep(viewModel, false);
    }
  }

  /// Checks if current step is the last step
  bool _isLastStep(AiAssistantCommonStepsProvider viewModel) {
    return viewModel.currentStep == aiAssistantProvider.pages.length;
  }

  /// Proceeds to next step
  Future<void> _proceedToNextStep(
      AiAssistantCommonStepsProvider viewModel, bool isContinue) async {
    await aiAssistantProvider.changePage(
        isContinue, aiAssistantProvider.currentPage + 1);
    viewModel.setCurrentStep(viewModel.currentStep + 1);
  }

  Widget webView() {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage(Assets.imagesWebBackground),
          fit: BoxFit.cover,
        ),
      ),
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: AppSizes.sixteenRadius,
          vertical: AppSizes.twentyEightRadius,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            webAppBar(),
            _buildWebAnimatedContent(),
            _buildWebMainContent(),
            _buildWebBottomButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildWebAnimatedContent() {
    return AnimatedBuilder(
      animation: aiAssistantProvider.animation,
      builder: (context, child) {
        final screenHeight = context.screenHeight - 80;
        return Stack(
          children: [
            _buildWebPageContent(aiAssistantProvider.currentPage,
                -screenHeight * aiAssistantProvider.animation.value),
            _buildWebPageContent(aiAssistantProvider.nextPage,
                screenHeight * (1 - aiAssistantProvider.animation.value)),
          ],
        );
      },
    );
  }

  Widget _buildWebPageContent(int pageIndex, double yOffset) {
    return AiBuildPageContentWidget(
      pageIndex: pageIndex,
      yOffset: yOffset,
      viewModel: viewModel,
      appBarTotalHeight: aiAssistantProvider.appBarTotalHeight,
    );
  }

  Widget _buildWebMainContent() {
    return AnimatedBuilder(
      animation: aiAssistantProvider.animation,
      builder: (context, child) {
        final screenHeight = context.screenHeight - 80;
        Widget content = _buildContent(screenHeight, viewModel);

        if (aiAssistantProvider.shouldWrapWithScrollView) {
          return _buildWebScrollableContent(content);
        }
        return content;
      },
    );
  }

  Widget _buildWebScrollableContent(Widget content) {
    final topPadding = aiAssistantProvider.pages.length > 1
        ? (aiAssistantProvider.appBarTotalHeight + Sizes.oneHundredSixtyInt.h)
        : (aiAssistantProvider.appBarTotalHeight + Sizes.oneHundredFiftyInt.h);

    return SingleChildScrollView(
      padding: EdgeInsets.only(
        top: topPadding,
        bottom: Sizes.hundredInt.h,
      ),
      child: content,
    );
  }

  Widget _buildWebBottomButtons() {
    return Center(
      child: SizedBox(
        width: 400.w,
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: AppSizes.sixteenRadius,
                vertical: AppSizes.twentyEightRadius,
              ),
              child: _buildWebButtonLayout(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWebButtonLayout() {
    final isLargeText = MediaQuery.of(context).textScaler.scale(1) > 1.25;

    if (isLargeText) {
      return _buildWebVerticalButtonLayout();
    } else {
      return _buildWebHorizontalButtonLayout();
    }
  }

  Widget _buildWebVerticalButtonLayout() {
    return Column(
      children: [
        _buildWebContinueButton(),
        SizedBox(height: 22.w),
        _buildWebSkipButton(),
      ],
    );
  }

  Widget _buildWebHorizontalButtonLayout() {
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: _buildWebSkipButton(),
        ),
        SizedBox(width: 22.w),
        Expanded(
          flex: 2,
          child: _buildWebContinueButton(),
        ),
      ],
    );
  }

  Widget _buildWebContinueButton() {
    return VisaButton(
      text: s.txt_continue,
      height: AppSizes.fiftySevenInt.toDouble(),
      width: context.screenWidth,
      variant: VisaButtonVariant.white,
      fontWeight: VisaFontWeight.medium,
      letterSpacing: AppSizes.zero,
      onPressed: () => _handleWebContinueAction(),
    );
  }

  Widget _buildWebSkipButton() {
    return VisaButton(
      text: s.skip,
      height: AppSizes.fiftyThreeInt.toDouble(),
      width: AppSizes.oneThirtyTwo.toDouble(),
      variant: VisaButtonVariant.primary,
      fontWeight: VisaFontWeight.medium,
      letterSpacing: AppSizes.zero,
      isOutlined: false,
      onPressed: () => _handleWebSkipAction(),
    );
  }

  Future<void> _handleWebContinueAction() async {
    if (_isWebLastStep()) {
      aiAssistantProvider.updateTeamPreference();
      aiAssistantProvider.navigateToAiAssistantThanksScreen();
    } else {
      await _proceedToWebNextStep(true);
    }
  }

  Future<void> _handleWebSkipAction() async {
    if (_isWebLastStep()) {
      aiAssistantProvider.navigateToAiAssistantThanksScreen();
    } else {
      await _proceedToWebNextStep(false);
    }
  }

  bool _isWebLastStep() {
    return viewModel.currentStep == aiAssistantProvider.pages.length;
  }

  Future<void> _proceedToWebNextStep(bool isContinue) async {
    await aiAssistantProvider.changePage(
        isContinue, aiAssistantProvider.currentPage + 1);
    viewModel.setCurrentStep(viewModel.currentStep + 1);
  }

  void getTapforClick(AiAssistantCommonStepsProvider viewModel) {
    if (viewModel.currentStep == 1 && aiAssistantProvider.isStepOneScreenShow) {
      aiAssistantProvider.nextStep();
    } else {
      Utils.hideKeyboard(context);
    }
  }
}
