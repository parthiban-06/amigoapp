import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get_utils/src/extensions/context_extensions.dart';
import 'package:get_it/get_it.dart' show GetIt;
import 'package:provider/provider.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:visaamigo/core/theme/theme.dart';
import 'package:visaamigo/custom_widgets/visa_ai_assistant_search_box.dart';
import 'package:visaamigo/custom_widgets/visa_header_background.dart';
import 'package:visaamigo/custom_widgets/visa_text_field.dart';
import 'package:visaamigo/custom_widgets/visa_textview.dart';
import 'package:visaamigo/features/ai_assistant/widgets/ai_assistant_prompt_animation_widget.dart';
import 'package:visaamigo/features/ai_assistant/widgets/ai_assistant_selected_prompts.dart';
import 'package:visaamigo/features/ai_assistant/widgets/ai_assistant_unSelected_prompts.dart';
import 'package:visaamigo/features/select_languages/providers/language_selection_generic_provider.dart';
import 'package:visaamigo/generated/assets.dart';
import 'package:visaamigo/utils/app_const.dart';
import 'package:visaamigo/utils/app_extensions.dart';
import 'package:visaamigo/utils/const_screen_size.dart';
import 'package:visaamigo/utils/utils.dart';

import '../../../../analytics/firebase_analytics_service.dart';
import '../../../../core/base/view/base_view.dart';
import '../../../../custom_widgets/visa_appbar.dart';
import '../../../../generated/l10n.dart';
import '../../../../utils/responsive_util.dart';
import '../../../home/providers/tutorial_provider.dart';
import '../../providers/ai_assistant_main_provider.dart';
import '../../providers/ai_assistant_prompts_screen_provider.dart';

class AiAssistantPromptsScreen extends StatefulWidget {
  const AiAssistantPromptsScreen({super.key});

  @override
  State<AiAssistantPromptsScreen> createState() =>
      _AiAssistantPromptsScreenState();
}

class _AiAssistantPromptsScreenState extends State<AiAssistantPromptsScreen>
    with WidgetsBindingObserver {
  late final AiAssistantPromptsScreenProvider viewModel;
  ResponsiveUtil? responsive;
  late final AiAssistantMainProvider aiAssistantProvider;
  late S s;

  @override
  void initState() {
    super.initState();
    // Retrieve dependencies using GetIt
    viewModel = GetIt.I<AiAssistantPromptsScreenProvider>();
    aiAssistantProvider =
        Provider.of<AiAssistantMainProvider>(context, listen: false);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    Utils.logPrint(
        "_AiAssistantPromptsScreenState didChangeDependencies *****************");
    responsive = GetIt.I<ResponsiveUtil>(param1: context);
    s = S.of(context);
    //viewModel.init(context);
  }

  @override
  Widget build(BuildContext context2) {
    final tutorialProvider =
        Provider.of<TutorialProvider>(context2, listen: false);

    return ShowCaseWidget(
      builder: (context) => _buildBaseView(context, context2, tutorialProvider),
    );
  }

  /// Builds the main base view with all configurations
  Widget _buildBaseView(BuildContext context, BuildContext context2,
      TutorialProvider tutorialProvider) {
    return BaseView<AiAssistantPromptsScreenProvider>(
      viewModel: viewModel,
      resizeToAvoidBottomInset: true,
      screenBackgroundColor: Colors.transparent,
      addDefaultPadding: false,
      onlyDesktop: true,
      onModelReady: (model) => _onModelReady(context, tutorialProvider),
      extendBodyBehindAppBar: false,
      wrapWithSafeArea: false,
      screenBackgroundImage: const VisaHeaderBackground(),
      buildAppBar: _buildAppBar(context2),
      onPageBuilderMobileView: (context, viewModel) =>
          _buildMobileView(context, viewModel, tutorialProvider),
    );
  }

  /// Handles model ready callback
  void _onModelReady(BuildContext context, TutorialProvider tutorialProvider) {
    Utils.announceMessage(S.of(context).eva);
    viewModel.init(context);
    tutorialProvider.initEVAContext(context);
    WidgetsBinding.instance.addObserver(this);
  }

  /// Builds the app bar with proper configuration
  PreferredSizeWidget _buildAppBar(BuildContext context2) {
    return VisaAppBar(
      isHamburgerIconShow: _shouldShowHamburgerIcon(context2),
      isActionButtonShow: true,
      brandingLogoColor: _getBrandingLogoColor(context2),
      isRightSideHamburgerIconShow: true,
      isCancelWithTextButtonShow: false,
    );
  }

  /// Determines if hamburger icon should be shown
  bool _shouldShowHamburgerIcon(BuildContext context2) {
    return responsive != null &&
        responsive!.kISWeb() &&
        (responsive!.isMobile(context: context2) ||
            responsive!.isTablet(context: context2));
  }

  /// Gets the branding logo color based on RTL setting
  Color _getBrandingLogoColor(BuildContext context2) {
    return Provider.of<SelectLanguageGenericProvider>(context2, listen: false)
            .isRTL
        ? VisaColors.white
        : context2.theme.primaryColor;
  }

  /// Builds the mobile view with all ValueListenableBuilder widgets
  Widget _buildMobileView(
      BuildContext context,
      AiAssistantPromptsScreenProvider viewModel,
      TutorialProvider tutorialProvider) {
    viewModel.isAtBottom.value = false;

    return ValueListenableBuilder(
      valueListenable: viewModel.onTapSearch,
      builder: (context, valueSearch, child) => ValueListenableBuilder(
        valueListenable: viewModel.evaBottom,
        builder: (context, evaBottom, child) => _buildMainStack(
            context, viewModel, tutorialProvider, valueSearch, evaBottom),
      ),
    );
  }

  /// Builds the main stack with all positioned widgets
  Widget _buildMainStack(
      BuildContext context,
      AiAssistantPromptsScreenProvider viewModel,
      TutorialProvider tutorialProvider,
      bool valueSearch,
      double evaBottom) {
    return Stack(
      children: [
        _buildTopGradient(),
        _buildMainContent(
            context, viewModel, tutorialProvider, valueSearch, evaBottom),
        _buildBottomSearchBox(context, viewModel, valueSearch, evaBottom),
      ],
    );
  }

  /// Builds the top gradient overlay
  Widget _buildTopGradient() {
    bool isDeviceSmall = context.screenHeight <= 700;
    double topPadding = isDeviceSmall
        ? (MediaQuery.of(context).padding.top + 40).h //10>40
        : (MediaQuery.of(context).padding.top + 50).h; //10>50
    return Positioned(
      top: topPadding,
      child: Container(
        height: isDeviceSmall ? 200.h : 150.h, // 120>150/200
        width: context.screenWidth,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              VisaColors.white.withAlpha(0),
              VisaColors.white,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: const [0, 0.5],
          ),
        ),
      ),
    );
  }

  /// Builds the main content area
  Widget _buildMainContent(
      BuildContext context,
      AiAssistantPromptsScreenProvider viewModel,
      TutorialProvider tutorialProvider,
      bool valueSearch,
      double evaBottom) {
    return Padding(
      padding: EdgeInsets.only(top: (MediaQuery.of(context).padding.top).h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeaderText(context),
          _buildLocationTextField(context, viewModel, valueSearch, evaBottom),
          _buildDivider(context, valueSearch, evaBottom),
          Container(
            height: 5.h,
            color: VisaColors.white,
          ),
          _buildPromptsSection(context, viewModel, tutorialProvider),
        ],
      ),
    );
  }

  /// Builds the header text
  Widget _buildHeaderText(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: VisaTextView(
        text: S.of(context).get_ready_to_explore,
        softWrap: true,
        semanticsFocus: true,
        overflow: TextOverflow.visible,
        style: VisaTextStyle.customLarge,
        fontSize: AppSizes.fontTwelve,
        lineHeight: 1.14,
        letterSpacing: -0.20,
        fontFamily: VisaFontWeight.semibold,
        customColor: VisaColors.black,
        colorTheme: VisaTextTheme.customTextColor,
      ),
    );
  }

  /// Builds the location text field
  Widget _buildLocationTextField(
      BuildContext context,
      AiAssistantPromptsScreenProvider viewModel,
      bool valueSearch,
      double evaBottom) {
    return Padding(
      padding: EdgeInsets.only(left: 16.w, right: 16.w, top: 8.h),
      child: Column(
        children: [
          VisaTextField(
            controller: viewModel.selectLocationController,
            hint: S.of(context).type_location_here,
            underlineInputBorder: false,
            isDense: false,
            errorText: "",
            contentPadding: EdgeInsets.all(16.r),
            fontSize: AppSizes.fontTwelve,
            letterSpacing: 2,
            vPadding: 0,
            isUpperCase: true,
            fontWeight: FontWeight.w500,
            textCapitalization: TextCapitalization.words,
            focusNode: viewModel.focusNode,
            borderTransparent: true,
            suffixIcon: _buildSuffixIcon(viewModel, valueSearch, evaBottom),
            prefixIcon: _buildPrefixIcon(),
            maxLength: AppConst.TEXTFIELD_EMAIL_LENGTH,
            textInputType: TextInputType.emailAddress,
            onChanged: (val) => viewModel.searchLocation(),
            onSubmitted: (val) => _handleLocationSubmission(viewModel),
            isValid: true,
          ),
        ],
      ),
    );
  }

  /// Builds the suffix icon for the text field
  Widget? _buildSuffixIcon(AiAssistantPromptsScreenProvider viewModel,
      bool valueSearch, double evaBottom) {
    if (!(evaBottom > 0 && valueSearch)) return null;

    return Padding(
      padding: EdgeInsets.only(left: 14.w),
      child: InkWell(
        onTap: () => viewModel.clearLocationSearch(),
        child: SizedBox(
          height: 24.h,
          width: 24.w,
          child: Center(
            child: SvgPicture.asset(
              Assets.iconsIcClose,
              height: 12.75.h,
              width: 12.75.w,
            ),
          ),
        ),
      ),
    );
  }

  /// Builds the prefix icon for the text field
  Widget _buildPrefixIcon() {
    return SizedBox(
      width: 30.w,
      child: Padding(
        padding: EdgeInsets.only(bottom: 2.h),
        child: Align(
          alignment: Alignment.centerLeft,
          child: SvgPicture.asset(Assets.iconsIcSearch, width: 16.w),
        ),
      ),
    );
  }

  /// Handles location text field submission
  void _handleLocationSubmission(AiAssistantPromptsScreenProvider viewModel) {
    if (_canAutoSelectLocation(viewModel)) {
      final firstPrediction =
          viewModel.placePredictions.value!.predictions.first;
      viewModel.changeLocation(firstPrediction.description.toUpperCase());
    }
  }

  /// Checks if location can be auto-selected
  bool _canAutoSelectLocation(AiAssistantPromptsScreenProvider viewModel) {
    return viewModel.placePredictions.value != null &&
        viewModel.placePredictions.value!.predictions.isNotEmpty &&
        viewModel.selectLocationController.text.isEmpty;
  }

  /// Builds the divider below the text field
  Widget _buildDivider(
      BuildContext context, bool valueSearch, double evaBottom) {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: (evaBottom > 0 && valueSearch) ? 0 : 16),
      child: Container(
        width: context.screenWidth,
        height: 1,
        color: VisaColors.black,
      ),
    );
  }

  /// Builds the prompts section with ValueListenableBuilder
  Widget _buildPromptsSection(
      BuildContext context,
      AiAssistantPromptsScreenProvider viewModel,
      TutorialProvider tutorialProvider) {
    return ValueListenableBuilder(
      valueListenable: viewModel.isSelectedPrompt,
      builder: (context, isSelected, child) => _buildPromptsContent(
          context, viewModel, tutorialProvider, isSelected),
    );
  }

  /// Builds the prompts content based on data availability
  Widget _buildPromptsContent(
      BuildContext context,
      AiAssistantPromptsScreenProvider viewModel,
      TutorialProvider tutorialProvider,
      int isSelected) {
    if (_shouldShowEmptyContainer(viewModel)) {
      return Container();
    }

    return Expanded(
      child: Container(
        color: VisaColors.white,
        child: Stack(
          children: [
            _buildPromptsScrollView(
                context, viewModel, tutorialProvider, isSelected),
            _buildFadeOverlays(context, viewModel),
            _buildLocationPredictions(context, viewModel),
          ],
        ),
      ),
    );
  }

  /// Checks if empty container should be shown
  bool _shouldShowEmptyContainer(AiAssistantPromptsScreenProvider viewModel) {
    return viewModel.prompts == null || viewModel.prompts!.isEmpty;
  }

  /// Builds the scrollable prompts view
  Widget _buildPromptsScrollView(
      BuildContext context,
      AiAssistantPromptsScreenProvider viewModel,
      TutorialProvider tutorialProvider,
      int isSelected) {
    final addPadding = _shouldAddPadding(tutorialProvider);

    return SingleChildScrollView(
      controller: viewModel.promptsScrollController,
      child: Padding(
        padding: EdgeInsets.only(
          left: 16.r,
          right: 16.r,
          bottom: addPadding ? context.screenHeight / 2 : Sizes.oneHundred,
          top: Sizes.twenty,
        ),
        child: _buildPromptsWrap(context, viewModel, isSelected),
      ),
    );
  }

  /// Checks if padding should be added for tutorial
  bool _shouldAddPadding(TutorialProvider tutorialProvider) {
    return tutorialProvider.tutorialEVALoaded &&
        !tutorialProvider.tutorialEvaScreenStatus;
  }

  /// Builds the wrap widget containing all prompts
  Widget _buildPromptsWrap(BuildContext context,
      AiAssistantPromptsScreenProvider viewModel, int isSelected) {
    return Wrap(
      runAlignment: WrapAlignment.spaceBetween,
      alignment: WrapAlignment.spaceBetween,
      spacing: 16.r,
      children: _buildPromptItems(context, viewModel, isSelected),
    );
  }

  /// Builds the list of prompt items
  List<Widget> _buildPromptItems(BuildContext context,
      AiAssistantPromptsScreenProvider viewModel, int isSelected) {
    return List.generate(viewModel.prompts!.length,
        (index) => _buildPromptItem(context, viewModel, isSelected, index));
  }

  /// Builds a single prompt item
  Widget _buildPromptItem(BuildContext context,
      AiAssistantPromptsScreenProvider viewModel, int isSelected, int index) {
    return Padding(
      padding: EdgeInsets.only(top: _calculateTopPadding(context, index)),
      child: GestureDetector(
        onTapDown: (values) => _handlePromptTapDown(context, viewModel, index),
        onTapCancel: () => viewModel.resetPromtIndex(),
        onTapUp: (values) => _handlePromptTapUp(context, viewModel, index),
        child:
            _buildPromptAnimationWidget(context, viewModel, isSelected, index),
      ),
    );
  }

  /// Calculates top padding for prompt items
  double _calculateTopPadding(BuildContext context, int index) {
    if (Utils.getFontSize(context)) {
      return index != 0 ? 18.w : 0;
    } else {
      if (index < 2) return 0;
      return (index % 2 == 0) ? 18.w : 0;
    }
  }

  /// Handles prompt tap down event
  void _handlePromptTapDown(BuildContext context,
      AiAssistantPromptsScreenProvider viewModel, int index) {
    FocusManager.instance.primaryFocus?.unfocus();
    viewModel.changePrompt(context, viewModel.prompts!.elementAt(index), index);
  }

  /// Handles prompt tap up event
  void _handlePromptTapUp(BuildContext context,
      AiAssistantPromptsScreenProvider viewModel, int index) {
    FocusManager.instance.primaryFocus?.unfocus();
    viewModel.changePromptOpenChat(
        context, viewModel.prompts!.elementAt(index), index);
  }

  /// Builds the prompt animation widget
  Widget _buildPromptAnimationWidget(BuildContext context,
      AiAssistantPromptsScreenProvider viewModel, int isSelected, int index) {
    return AiAssistantPromptAnimationWidget(
      begin: 0.7,
      delay: Duration(milliseconds: (175 * index)),
      child: _buildPromptWidget(context, viewModel, isSelected, index),
    );
  }

  /// Builds the appropriate prompt widget based on selection state
  Widget _buildPromptWidget(BuildContext context,
      AiAssistantPromptsScreenProvider viewModel, int isSelected, int index) {
    final width = _calculatePromptWidth(context);
    final promptModel = viewModel.prompts!.elementAt(index);

    return isSelected == index
        ? AiAssistantSelectedPrompts(
            index: index,
            width: width,
            promptModel: promptModel,
          )
        : AiAssistantUnSelectedPrompts(
            index: index,
            width: width,
            promptModel: promptModel,
          );
  }

  /// Calculates the width for prompt widgets
  double _calculatePromptWidth(BuildContext context) {
    return Utils.getFontSize(context)
        ? context.screenWidth
        : (context.screenWidth * 0.5) - (48.r / 2);
  }

  /// Builds fade overlays for scroll effects
  Widget _buildFadeOverlays(
      BuildContext context, AiAssistantPromptsScreenProvider viewModel) {
    return ValueListenableBuilder(
      valueListenable: viewModel.isAtBottom,
      builder: (context, value, child) => _buildFadeOverlay(context, value),
    );
  }

  /// Builds individual fade overlay
  Widget _buildFadeOverlay(BuildContext context, bool value) {
    return value ? _buildTopFade(context) : _buildBottomFade(context);
  }

  /// Builds top fade overlay
  Widget _buildTopFade(BuildContext context) {
    return Positioned(
      top: 0,
      child: IgnorePointer(
        child: Container(
          height: (context.screenWidth * 0.4).h,
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

  /// Builds bottom fade overlay
  Widget _buildBottomFade(BuildContext context) {
    return Positioned(
      bottom: 0,
      child: IgnorePointer(
        child: Container(
          height: (context.screenHeight * 0.25).h,
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

  /// Builds location predictions overlay
  Widget _buildLocationPredictions(
      BuildContext context, AiAssistantPromptsScreenProvider viewModel) {
    return Positioned(
      top: 0,
      child: ValueListenableBuilder(
        valueListenable: viewModel.placePredictions,
        builder: (context, value, child) =>
            _buildLocationPredictionsContent(context, viewModel, value),
      ),
    );
  }

  /// Builds location predictions content
  Widget _buildLocationPredictionsContent(BuildContext context,
      AiAssistantPromptsScreenProvider viewModel, dynamic value) {
    if (!_shouldShowLocationPredictions(value, viewModel)) {
      return const SizedBox();
    }

    return Container(
      height: context.screenHeight * 0.4.h,
      width: context.screenWidth,
      decoration: _buildLocationPredictionsDecoration(),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 0, vertical: 10.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [_buildLocationPredictionsList(context, viewModel, value)],
        ),
      ),
    );
  }

  /// Checks if location predictions should be shown
  bool _shouldShowLocationPredictions(
      dynamic value, AiAssistantPromptsScreenProvider viewModel) {
    return value != null && viewModel.onTapSearch.value;
  }

  /// Builds decoration for location predictions container
  BoxDecoration _buildLocationPredictionsDecoration() {
    return BoxDecoration(
      gradient: LinearGradient(
        colors: [VisaColors.white, VisaColors.white.withAlpha(0)],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        stops: const [0.6, 1],
      ),
    );
  }

  /// Builds the list of location predictions
  Widget _buildLocationPredictionsList(BuildContext context,
      AiAssistantPromptsScreenProvider viewModel, dynamic value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(
        value.predictions.length,
        (index) =>
            _buildLocationPredictionItem(context, viewModel, value, index),
      ),
    );
  }

  /// Builds a single location prediction item
  Widget _buildLocationPredictionItem(BuildContext context,
      AiAssistantPromptsScreenProvider viewModel, dynamic value, int index) {
    final description =
        value.predictions.elementAt(index).description.toUpperCase();
    final cleanDescription = description.split('[').first.trim();
    final isSelected = viewModel.selectedLocation == cleanDescription;

    return Column(
      children: [
        _buildLocationPredictionInkWell(
            context, viewModel, description, cleanDescription, isSelected),
        if (index != value.predictions.length - 1)
          _buildLocationPredictionDivider(),
      ],
    );
  }

  /// Builds the ink well for location prediction
  Widget _buildLocationPredictionInkWell(
      BuildContext context,
      AiAssistantPromptsScreenProvider viewModel,
      String description,
      String cleanDescription,
      bool isSelected) {
    return InkWell(
      onTap: () => viewModel.changeLocation(cleanDescription),
      child: Container(
        height: 41.h,
        width: context.screenWidth,
        color: isSelected ? VisaColors.greyBackGround : null,
        alignment: Alignment.centerLeft,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 25.w),
          child: VisaTextView(
            text: description,
            softWrap: true,
            overflow: TextOverflow.visible,
            style: VisaTextStyle.customLarge,
            fontSize: AppSizes.fontTwelve,
            letterSpacing: 2,
            fontFamily:
                isSelected ? VisaFontWeight.semibold : VisaFontWeight.medium,
            customColor: VisaColors.black,
            colorTheme: VisaTextTheme.customTextColor,
          ),
        ),
      ),
    );
  }

  /// Builds divider for location predictions
  Widget _buildLocationPredictionDivider() {
    return const Divider(
      height: 1,
      thickness: 1,
      color: VisaColors.greyBackGround,
    );
  }

  /// Builds the bottom search box
  Widget _buildBottomSearchBox(
      BuildContext context,
      AiAssistantPromptsScreenProvider viewModel,
      bool valueSearch,
      double evaBottom) {
    return Positioned(
      bottom: -5 - (valueSearch ? evaBottom : 0),
      child: SizedBox(
        height: Sizes.twoHundred.h,
        width: context.screenWidth,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [_buildSearchBoxContainer(context, viewModel)],
        ),
      ),
    );
  }

  /// Builds the search box container
  Widget _buildSearchBoxContainer(
      BuildContext context, AiAssistantPromptsScreenProvider viewModel) {
    return Container(
      child: Padding(
        padding: EdgeInsets.only(left: 16.w, right: 16.w, bottom: 16.h),
        child: _buildSearchBox(context, viewModel),
      ),
    );
  }

  /// Builds the search box widget
  Widget _buildSearchBox(
      BuildContext context, AiAssistantPromptsScreenProvider viewModel) {
    return VisaAiAssistantSearchBox(
      controller: viewModel.promptsController,
      hintText: s.ask_eva,
      autofocus: false,
      maxLines: 2,
      onTap: () => _handleSearchBoxTap(),
      onSearch: () => _handleSearchBoxSearch(viewModel),
    );
  }

  /// Handles search box tap event
  void _handleSearchBoxTap() {
    FirebaseAnalyticsService.logEvent(
      eventName: "evaquery_initiate",
      parameters: {
        AnalyticsEventConst.PARAM_NAME_UI_ELEMENT: "query_bar",
      },
    );
  }

  /// Handles search box search event
  void _handleSearchBoxSearch(AiAssistantPromptsScreenProvider viewModel) {
    if (_canPerformSearch(viewModel)) {
      aiAssistantProvider.navigateToAiAssistantThreadsScreen(
        viewModel.promptsController.text.trim(),
        viewModel.selectLocationController.text.trim(),
      );
      viewModel.clearEditTextField();
    }
  }

  /// Checks if search can be performed
  bool _canPerformSearch(AiAssistantPromptsScreenProvider viewModel) {
    return !viewModel.promptsController.text.trim().isNullOrEmpty;
  }
}
