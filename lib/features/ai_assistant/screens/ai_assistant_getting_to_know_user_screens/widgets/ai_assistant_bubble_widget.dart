import 'dart:math';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get_it/get_it.dart' show GetIt;
import 'package:provider/provider.dart';
import 'package:visaamigo/custom_widgets/visa_button.dart'
    show VisaButton, VisaButtonVariant;
import 'package:visaamigo/custom_widgets/visa_textview.dart';
import 'package:visaamigo/features/ai_assistant/models/ai_goal_model.dart'
    show AiGoalModel;
import 'package:visaamigo/features/ai_assistant/providers/ai_assistant_common_steps_provider.dart'
    show AiAssistantCommonStepsProvider;
import 'package:visaamigo/generated/l10n.dart' show S;
import 'package:visaamigo/utils/app_extensions.dart';
import 'package:visaamigo/utils/const_screen_size.dart' show AppSizes, Sizes;

import '../../../../../core/theme/theme.dart';
import '../../../../../generated/assets.dart';
import '../../../../../utils/utils.dart';
import '../../../providers/ai_assistant_main_provider.dart';

class AiAssistantBubbleWidget extends StatefulWidget {
  const AiAssistantBubbleWidget({super.key});

  @override
  State<AiAssistantBubbleWidget> createState() =>
      _AiAssistantBubbleWidgetState();
}

class _AiAssistantBubbleWidgetState extends State<AiAssistantBubbleWidget> {
  late var aiAssistantProvider;
  late var goals;
  final List<int> bubblePattern = [2, 3, 2, 1];
  late S s;
  late double zeroPadding;
  late AiAssistantCommonStepsProvider viewModel;
  bool semanticsAnnounced = false;
  late List<FocusNode> bubbleFocusNodes; // List of FocusNodes for bubbles

  @override
  Future<void> didChangeDependencies() async {
    super.didChangeDependencies();
    aiAssistantProvider = Provider.of<AiAssistantMainProvider>(context);
    aiAssistantProvider.loadGoalsListFromJsonFile();
    aiAssistantProvider.setContext(context);

    aiAssistantProvider.calculateBubbleSize();
    goals = aiAssistantProvider.goals;
    // aiAssistantProvider.initializeShadowControllers(this);

    zeroPadding = AppSizes.zero;
    // aiAssistantProvider.init(this);
    // aiAssistantProvider = GetIt.I<AiAssistantMainProvider>();
    viewModel = GetIt.I<AiAssistantCommonStepsProvider>();
    if (!semanticsAnnounced) {
      semanticsAnnounced = true;
      Utils.announceMessage(
          "${S.of(context).step} ${viewModel.currentStep + 1} ${S.of(context).goal_of_the_trip}");
      await Future.delayed(const Duration(seconds: 4));
    }
  }

  @override
  void dispose() {
    for (final controller in aiAssistantProvider.shadowControllers) {
      if (controller.isAnimating) {
        controller.dispose();
      }
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double additionalSize =
        (Utils.getFontSize(context) ? Sizes.eightyInt : 0).toDouble();
    zeroPadding = AppSizes.zero;
    s = S.of(context);

    if (goals == null ||
        goals.isEmpty ||
        !aiAssistantProvider.isAnimationFinished) {
      return const SizedBox.shrink();
    }
    return aiAssistantProvider.isDesktopView
        ? webLayout(aiAssistantProvider, context)
        : Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                  padding: EdgeInsets.symmetric(
                      vertical: Utils.getFontSize(context)
                          ? 70
                          : MediaQuery.of(context).textScaler.scale(1) > 1
                              ? 40
                              : 0),
                  child: Container(
                    width: context.screenWidth,
                    margin: const EdgeInsets.symmetric(horizontal: 20).r,
                    child: Wrap(
                      spacing: 10.w,
                      // Horizontal spacing
                      runSpacing: AppSizes.heightEighteen,
                      // Vertical spacing
                      alignment: WrapAlignment.spaceAround,
                      // crossAxisAlignment: WrapCrossAlignment.start,
                      runAlignment: WrapAlignment.start,
                      clipBehavior: Clip.antiAlias,
                      children: List.generate(goals.length + 1, (index) {
                        if (index >= goals.length) {
                          return const SizedBox.shrink();
                        }
                        final appearance =
                            aiAssistantProvider.getBubbleAppearance(index);
                        bool isEnded = false;
                        return Row(
                            mainAxisSize: additionalSize > 0
                                ? MainAxisSize.max
                                : MainAxisSize.min,
                            mainAxisAlignment: additionalSize > 0
                                ? index % 2 == 0
                                    ? MainAxisAlignment.start
                                    : MainAxisAlignment.end
                                : MainAxisAlignment.start,
                            crossAxisAlignment: additionalSize > 0
                                ? index % 2 == 0
                                    ? CrossAxisAlignment.end
                                    : CrossAxisAlignment.start
                                : CrossAxisAlignment.start,
                            children: [
                              GestureDetector(
                                onTap: () =>
                                    aiAssistantProvider.toggleSelection(index),
                                child: aiAssistantProvider
                                            .shadowControllers.length >
                                        index
                                    ? AnimatedBuilder(
                                        animation: aiAssistantProvider
                                            .shadowControllers[index],
                                        builder: (context, child) {
                                          double shadowX = cos(
                                                  aiAssistantProvider
                                                      .shadowAnimations[index]
                                                      .value) *
                                              aiAssistantProvider.radii[index];
                                          double shadowY = sin(
                                                  aiAssistantProvider
                                                      .shadowAnimations[index]
                                                      .value) *
                                              aiAssistantProvider.radii[index];

                                          return AnimationConfiguration
                                              .staggeredGrid(
                                            position: index,
                                            duration:
                                                const Duration(milliseconds: 0),
                                            // Smooth duration
                                            columnCount: goals.length + 1,
                                            child: Container(
                                              width: aiAssistantProvider
                                                      .bubbleWidth +
                                                  additionalSize,
                                              alignment: (index ==
                                                      goals.length - 1)
                                                  ? Alignment.centerLeft
                                                  : (index.isOdd)
                                                      ? ((index ~/ 2).isEven)
                                                          ? Alignment.centerLeft
                                                          : Alignment
                                                              .centerRight
                                                      : (index % 4 == 0)
                                                          ? Alignment.centerLeft
                                                          : Alignment
                                                              .centerRight,
                                              // decoration: BoxDecoration(
                                              //     border: Border.all(color: Colors.blueAccent)),
                                              child: AnimatedContainer(
                                                onEnd: () {
                                                  isEnded = true;
                                                },
                                                margin: additionalSize > 0
                                                    ? EdgeInsets.zero
                                                    : (appearance.isSurrounding)
                                                        ? EdgeInsets.only(
                                                            top: index.isOdd
                                                                ? 20.0.h
                                                                : 0,
                                                            left: !index.isEven
                                                                ? (aiAssistantProvider
                                                                    .paddingCalculationOne)
                                                                : (aiAssistantProvider
                                                                    .paddingCalculationThree),
                                                            right: !index.isEven
                                                                ? (aiAssistantProvider
                                                                    .paddingCalculationThree)
                                                                : (aiAssistantProvider
                                                                    .paddingCalculationOne), // Reduce initial height jump
                                                          )
                                                        : EdgeInsets.only(
                                                            top: index.isOdd
                                                                ? 20.0.h
                                                                : 0.0,
                                                          ),
                                                duration: const Duration(
                                                    milliseconds: 200),
                                                curve: Curves.ease,
                                                width: appearance.size +
                                                    additionalSize,
                                                height: appearance.size +
                                                    additionalSize,
                                                clipBehavior: Clip.antiAlias,
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  boxShadow: [
                                                    // Shadow 1: soft bright
                                                    BoxShadow(
                                                      color: goals[index]
                                                              .isSelect
                                                          ? VisaColors
                                                              .selectedThirdLayerGradientColor
                                                              .withValues(
                                                                  alpha: 0.6)
                                                          : VisaColors.blurColor
                                                              .withValues(
                                                                  alpha: 0.7),
                                                      blurRadius: 25,
                                                      offset: Offset(
                                                          shadowX, shadowY),
                                                      spreadRadius: 12,
                                                    ),

                                                    // Shadow 2: faint dark glow
                                                    BoxShadow(
                                                      color:
                                                          // goals[index].isSelect
                                                          //     ? VisaColors.selectedBlurColor

                                                          //     :
                                                          VisaColors.black
                                                              .withValues(
                                                                  alpha: 0.2),
                                                      blurRadius: 25,
                                                      offset: Offset(
                                                          -shadowX, -shadowY),
                                                      spreadRadius: 6,
                                                    ),
                                                  ],
                                                ),
                                                child: Semantics(
                                                  container: true,
                                                  excludeSemantics: true,
                                                  enabled: true,
                                                  label:
                                                      "${Utils.getErrorMessageFromString(goals[index].langNameKey)}, ${S.of(context).double_tap_to_activate}",
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                      image: DecorationImage(
                                                        image: AssetImage(
                                                          goals[index].isSelect
                                                              ? Assets
                                                                  .imagesSelected
                                                              : Assets
                                                                  .imagesUnSelected,
                                                        ),
                                                      ),
                                                    ),
                                                    child: Center(
                                                      child:
                                                          TweenAnimationBuilder<
                                                              double>(
                                                        duration: appearance
                                                                .isSurrounding
                                                            ? const Duration(
                                                                milliseconds:
                                                                    200) // smallest
                                                            : goals[index]
                                                                    .isSelect
                                                                ? const Duration(
                                                                    milliseconds:
                                                                        700) // large
                                                                : const Duration(
                                                                    milliseconds:
                                                                        300),
                                                        //normal
                                                        tween: Tween(
                                                          begin: appearance
                                                                  .isSurrounding
                                                              ? 12.sp
                                                              : goals[index]
                                                                      .isSelect
                                                                  ? 26.sp
                                                                  : AppSizes
                                                                      .fontMedium,
                                                          end: appearance
                                                                  .isSurrounding
                                                              ? 12.sp
                                                              : goals[index]
                                                                      .isSelect
                                                                  ? 30.sp
                                                                  : 16.sp,
                                                        ),
                                                        builder: (context, size,
                                                            child) {
                                                          return Padding(
                                                            padding: goals[
                                                                        index]
                                                                    .isSelect
                                                                ? EdgeInsets.all(
                                                                    AppSizes
                                                                        .tenRadius)
                                                                : EdgeInsets.all(
                                                                    AppSizes
                                                                        .fiveRadius),
                                                            child: AutoSizeText(
                                                              Utils.getErrorMessageFromString(
                                                                  goals[index]
                                                                      .langNameKey),
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                              style: TextStyle(
                                                                  fontSize: AppSizes
                                                                      .fontMedium,
                                                                  fontWeight: goals[
                                                                              index]
                                                                          .isSelect
                                                                      ? FontWeight
                                                                          .bold
                                                                      : FontWeight
                                                                          .w500,
                                                                  fontFamily:
                                                                      "VisaDialectUI",
                                                                  //temp hardcoded
                                                                  color:
                                                                      VisaColors
                                                                          .black),
                                                              maxFontSize: appearance
                                                                      .isSurrounding
                                                                  ? (12.sp)
                                                                      .ceilToDouble()
                                                                  : goals[index]
                                                                          .isSelect
                                                                      ? AppSizes
                                                                          .fontNineteen
                                                                          .ceilToDouble()
                                                                      : AppSizes
                                                                          .fontMedium
                                                                          .ceilToDouble(),
                                                              minFontSize: 9,
                                                              maxLines:
                                                                  goals[index]
                                                                      .maxLines,
                                                              stepGranularity:
                                                                  1,
                                                            ),
                                                          );
                                                        },
                                                      ),
                                                    ), // Dynamic child widget
                                                  ),
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                      )
                                    : const SizedBox(),
                              )
                            ]);
                      }),
                    ),
                  ))
            ],
          );
  }

  Widget webLayout(provider, context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Center(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Padding(
              padding: EdgeInsets.all(AppSizes.tweleveWidth),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: _buildBubbleColumns(provider).map((col) {
                  return Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: AppSizes.tweleveWidth),
                    child: col,
                  );
                }).toList(),
              ),
            ),
          ),
        ),
        buttons(context)
      ],
    );
  }

  Widget buttons(BuildContext context) => Center(
        child: SizedBox(
          width: 400.w,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: AppSizes.sixteenRadius,
                  vertical: AppSizes.twentyEightRadius,
                ),
                child: Row(
                  // spacing: Sizes.eighteen,
                  children: [
                    Expanded(
                      flex: 1,
                      child: VisaButton(
                        text: s.skip,
                        height: AppSizes.fiftyThreeInt.toDouble(),
                        width: AppSizes.oneThirtyTwo.toDouble(),
                        variant: VisaButtonVariant.primary,
                        fontWeight: VisaFontWeight.medium,
                        // fontSize: Sizes.sixteen,
                        letterSpacing: zeroPadding,
                        isOutlined: false,
                        onPressed: () async {
                          if (viewModel.currentStep !=
                              aiAssistantProvider.pages.length) {
                            await aiAssistantProvider.changePage(
                                false, aiAssistantProvider.currentPage + 1);
                            viewModel.setCurrentStep(viewModel.currentStep + 1);
                          } else {
                            aiAssistantProvider
                                .navigateToAiAssistantThanksScreen();
                          }
                        },
                      ),
                    ),
                    SizedBox(
                      width: 22.w,
                    ),
                    Expanded(
                      flex: 2,
                      child: VisaButton(
                        text: s.txt_continue,
                        height: AppSizes.fiftySevenInt.toDouble(),
                        width: context.screenWidth,
                        variant: VisaButtonVariant.white,
                        fontWeight: VisaFontWeight.medium,
                        // fontSize: Sizes.sixteen,
                        letterSpacing: zeroPadding,
                        onPressed: () async {
                          if (viewModel.currentStep !=
                              aiAssistantProvider.pages.length) {
                            await aiAssistantProvider.changePage(
                                true, aiAssistantProvider.currentPage + 1);
                            viewModel.setCurrentStep(viewModel.currentStep + 1);
                          } else {
                            aiAssistantProvider.updateTeamPreference();
                            aiAssistantProvider
                                .navigateToAiAssistantThanksScreen();
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
              // AppSizes.xxsmallVS,
            ],
          ),
        ),
      );

  List<Widget> _buildBubbleColumns(AiAssistantMainProvider provider) {
    List<Widget> rows = [];
    int index = 0;
    bool reverse = false;

    while (index < goals!.length) {
      for (final count in bubblePattern) {
        if (index >= goals!.length) break;
        List<Widget> columnBubbles = [];
        for (int i = 0; i < count && index < goals!.length; i++) {
          int currentIndex = index;
          // final isSelected = _selectedIndices.contains(currentIndex);

          // Use provider to get bubble appearance
          final appearance = provider.getBubbleAppearance(currentIndex);
          Utils.logPrint("appearance: ${appearance.size}");
          columnBubbles.add(
            Container(
              margin: const EdgeInsets.symmetric(vertical: 10),
              child: GestureDetector(
                onTap: () => provider.toggleSelection(currentIndex),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.ease,
                  width: appearance.size,
                  height: appearance.size,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: goals![currentIndex].isSelect
                            ? VisaColors.selectedBlurColor
                            : VisaColors.unSelectedBlurColor,
                        blurRadius: goals![currentIndex].isSelect ? 10 : 13.60,
                        spreadRadius: goals![currentIndex].isSelect ? 5 : 8,
                      ),
                      BoxShadow(
                        color: goals![currentIndex].isSelect
                            ? VisaColors.selectedBlurColor
                            : VisaColors.unSelectedBlurColor,
                        blurRadius: goals![currentIndex].isSelect ? 10 : 13.60,
                        spreadRadius: goals![currentIndex].isSelect ? 8 : 5,
                      ),
                    ],
                  ),
                  child: provider.shadowControllers.length > currentIndex
                      ? AnimatedBuilder(
                          animation: provider.shadowControllers[currentIndex],
                          builder: (context, child) {
                            return AnimationConfiguration.staggeredList(
                              position: currentIndex,
                              duration: const Duration(milliseconds: 600),
                              child: ScaleAnimation(
                                child: FadeInAnimation(
                                  child: GlassBubble(
                                      label: goals![currentIndex].name,
                                      isSelected: goals![currentIndex].isSelect,
                                      size: appearance.size,
                                      appearance: appearance,
                                      goals: goals![currentIndex],
                                      index: currentIndex),
                                ),
                              ),
                            );
                          },
                        )
                      : const SizedBox.shrink(),
                ),
              ),
            ),
          );
          index++;
        }
        rows.add(
          Column(
            mainAxisSize: MainAxisSize.min,
            children: reverse ? columnBubbles.reversed.toList() : columnBubbles,
          ),
        );
      }
      reverse = !reverse;
    }
    return rows;
  }
}

class GlassBubble extends StatelessWidget {
  final String label;
  final bool isSelected;
  final double size;
  final dynamic appearance;
  final AiGoalModel? goals;
  final int? index;

  const GlassBubble(
      {super.key,
      required this.label,
      this.isSelected = false,
      this.size = 100,
      this.appearance,
      this.goals,
      this.index});

  @override
  Widget build(BuildContext context) {
    final double fontTwelve = AppSizes.fontTwelve;
    return isSelected
        ? selectedBubbleWidget(fontTwelve, context)
        : unSelectedBubbleWidget(fontTwelve, context);
  }

  Widget selectedBubbleWidget(fontTwelve, context) => Semantics(
        button: true,
        focusable: true,

        sortKey: OrdinalSortKey(index!.toDouble()),
        // If true, all semantics from the child are ignored.
        excludeSemantics: true,
        hint:
            "${Utils.getErrorMessageFromString(goals!.langNameKey)} ${S.of(context).selected}",
        child: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage(
                Assets.imagesSelected,
              ),
            ),
          ),
          child: Center(
              child: TweenAnimationBuilder<double>(
            duration: appearance.isSurrounding
                ? const Duration(milliseconds: 200) // smallest
                : goals!.isSelect
                    ? const Duration(milliseconds: 700) // large
                    : const Duration(milliseconds: 300),
            //normal
            tween: Tween(
              begin: appearance.isSurrounding
                  ? fontTwelve
                  : goals!.isSelect
                      ? AppSizes.fontTweentysix
                      : AppSizes.fontMedium,
              end: appearance.isSurrounding
                  ? fontTwelve
                  : goals!.isSelect
                      ? AppSizes.fontThirty
                      : 16.sp,
            ),
            builder: (context, size, child) {
              return Padding(
                padding: EdgeInsets.all(AppSizes.fiveRadius),
                child: AutoSizeText(
                  Utils.getErrorMessageFromString(goals!.langNameKey),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: size - 2,
                      fontWeight:
                          goals!.isSelect ? FontWeight.bold : FontWeight.w500,
                      fontFamily: "VisaDialectUI",
                      //temp hardcoded
                      color: VisaColors.black),
                  maxFontSize: appearance.isSurrounding
                      ? (fontTwelve).ceilToDouble()
                      : goals!.isSelect
                          ? 16.sp.ceilToDouble()
                          : 18.sp.ceilToDouble(),
                  minFontSize: 9,
                  maxLines: goals!.maxLines,
                  stepGranularity: 1,
                ),
              );
            },
          )), // Dynamic chi
        ),
      );

  Widget unSelectedBubbleWidget(fontTwelve, context) => Semantics(
        button: true,
        focusable: true,
        focused: index == 0 ? true : false,
        sortKey: OrdinalSortKey(index!.toDouble()),
        // Ensure correct order in semantics
        // If true, all semantics from the child are ignored.
        excludeSemantics: true,
        hint:
            "${Utils.getErrorMessageFromString(goals!.langNameKey)} ${S.of(context).unselected}",
        child: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage(
                Assets.imagesUnSelected,
              ),
            ),
          ),
          child: Center(
              child: TweenAnimationBuilder<double>(
            duration: appearance.isSurrounding
                ? const Duration(milliseconds: 200) // smallest
                : goals!.isSelect
                    ? const Duration(milliseconds: 700) // large
                    : const Duration(milliseconds: 300),
            //normal
            tween: Tween(
              begin: appearance.isSurrounding
                  ? fontTwelve
                  : goals!.isSelect
                      ? AppSizes.fontTweentysix
                      : AppSizes.fontMedium,
              end: appearance.isSurrounding
                  ? fontTwelve
                  : goals!.isSelect
                      ? AppSizes.fontThirty
                      : 16.sp,
            ),
            builder: (context, size, child) {
              return Padding(
                padding: EdgeInsets.all(AppSizes.fiveRadius),
                child: AutoSizeText(
                  Utils.getErrorMessageFromString(goals!.langNameKey),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: size - 2,
                      fontWeight:
                          goals!.isSelect ? FontWeight.bold : FontWeight.w500,
                      fontFamily: "VisaDialectUI",
                      //temp hardcoded
                      color: VisaColors.black),
                  maxFontSize: appearance.isSurrounding
                      ? (fontTwelve).ceilToDouble()
                      : goals!.isSelect
                          ? 22.sp.ceilToDouble()
                          : 18.sp.ceilToDouble(),
                  minFontSize: 9,
                  maxLines: goals!.maxLines,
                  stepGranularity: 1,
                ),
              );
            },
          )), // Dynamic chi
        ),
      );
}
