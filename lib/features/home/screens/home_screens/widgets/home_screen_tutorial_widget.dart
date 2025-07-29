import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../analytics/firebase_analytics_service.dart';
import '../../../../../custom_widgets/tutorial_bottom_sheet.dart';
import '../../../../../generated/l10n.dart';
import '../../../providers/tutorial_provider.dart';

class HomeScreenTutorialWidget extends StatefulWidget {
  const HomeScreenTutorialWidget({super.key});

  @override
  State<HomeScreenTutorialWidget> createState() =>
      _HomeScreenTutorialWidgetState();
}

class _HomeScreenTutorialWidgetState extends State<HomeScreenTutorialWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  bool _wasVisible = false;
  bool _shouldShowWidget = false;
  bool _showAppBar = false;

  final Duration fadeInDuration = const Duration(milliseconds: 500);
  final Duration fadeOutDuration = const Duration(milliseconds: 100);

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: fadeInDuration,
      vsync: this,
    );

    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0.0, 1), // Start a little below
      end: Offset.zero, // Move to normal position
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) {
        _controller.forward();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleVisibility(bool isVisible) async {
    if (isVisible && !_wasVisible) {
      _controller.duration = fadeInDuration;
      setState(() {
        _shouldShowWidget = true;
        Future.delayed(const Duration(milliseconds: 500), () {
          setState(() {
            _showAppBar = true;
          });
        });
      });
      _controller.forward(from: 0);
    } else if (!isVisible && _wasVisible) {
      if (!isVisible && _showAppBar) {
        setState(() {
          _showAppBar = false;
        });
      }
      _controller.duration = fadeOutDuration;
      await _controller.reverse();
    }
    _wasVisible = isVisible;
  }

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);

    return Consumer<TutorialProvider>(
      builder: (context, viewModel, child) {
        final isVisible = !viewModel.tutorialStatus && viewModel.tutorialLoaded;
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _handleVisibility(isVisible);
        });

        if (!_shouldShowWidget) return const SizedBox.shrink();

        return SlideTransition(
          position: _slideAnimation,
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: TutorialBottomSheet(
              onNext: viewModel.next,
              onBack: viewModel.previous,
              onStart: () {
                viewModel.next();
                // tutorialbanner.start
                FirebaseAnalyticsService.logEvent(
                  eventName: "tutorialbanner_start",
                  parameters: {
                    AnalyticsEventConst.PARAM_NAME_UI_ELEMENT_LOCATION:
                        viewModel.uiElementLocation,
                    AnalyticsEventConst.PARAM_NAME_UI_ELEMENT: "start_button",
                  },
                );
              },
              onCancel: () {
                viewModel.closeOverlayTutorial();

                FirebaseAnalyticsService.logEvent(
                  eventName: "tutorialbanner_close",
                  parameters: {
                    AnalyticsEventConst.PARAM_NAME_UI_ELEMENT_LOCATION:
                        viewModel.uiElementLocation,
                    AnalyticsEventConst.PARAM_NAME_UI_ELEMENT: "close",
                  },
                );
              },
              tutorialIcon: viewModel.tutorialSteps[viewModel.index].iconAsset,
              title: viewModel.tutorialSteps[viewModel.index].title,
              subTitle: viewModel.tutorialSteps[viewModel.index].subtitle,
              description: viewModel.tutorialSteps[viewModel.index].description,
              startButtonText: s.start,
              backButtonText: s.back,
              isTextSpan: viewModel.tutorialSteps[viewModel.index].isTextSpan,
              boldWords: viewModel.tutorialSteps[viewModel.index].boldWords,
              nextButtonText:
                  (viewModel.index == viewModel.tutorialSteps.length - 1)
                      ? s.lets_go_button
                      : s.next,
              isTutorialStarted: viewModel.isTutorialStarted,
              isSingleButtonVisible: !viewModel.isTutorialStarted,
              showAppBar: _showAppBar,
            ),
          ),
        );
      },
    );
  }
}
