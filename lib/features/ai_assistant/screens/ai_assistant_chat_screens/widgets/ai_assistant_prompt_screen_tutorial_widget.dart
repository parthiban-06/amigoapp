import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../custom_widgets/tutorial_bottom_sheet.dart';
import '../../../../../generated/l10n.dart';
import '../../../../home/providers/tutorial_provider.dart';

class AiAssistantPromptScreenTutorialWidget extends StatefulWidget {
  const AiAssistantPromptScreenTutorialWidget({super.key});

  @override
  State<AiAssistantPromptScreenTutorialWidget> createState() =>
      _AiAssistantPromptScreenTutorialWidgetState();
}

class _AiAssistantPromptScreenTutorialWidgetState
    extends State<AiAssistantPromptScreenTutorialWidget>
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
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    // _controller.addStatusListener((status) {
    //   if (status == AnimationStatus.dismissed) {
    //     setState(() {
    //       _shouldShowWidget = false;
    //     });
    //   }
    // });

    // Start animation after a short delay
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
      _controller.forward(from: 0.0);
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
        final isVisible =
            !viewModel.tutorialEvaScreenStatus && viewModel.tutorialEVALoaded;

        WidgetsBinding.instance.addPostFrameCallback((_) {
          _handleVisibility(isVisible);
        });

        if (!_shouldShowWidget) return const SizedBox.shrink();

        return SlideTransition(
          position: _slideAnimation,
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: TutorialBottomSheet(
              onNext: () {},
              onBack: () {},
              onStart: viewModel.closeEVATutorial,
              onCancel: viewModel.closeEVATutorial,
              tutorialIcon:
                  viewModel.tutorialEVASteps[viewModel.index].iconAsset,
              title: viewModel.tutorialEVASteps[viewModel.index].title,
              subTitle: viewModel.tutorialEVASteps[viewModel.index].subtitle,
              description:
                  viewModel.tutorialEVASteps[viewModel.index].description,
              startButtonText: s.got_it,
              backButtonText: s.back,
              isTextSpan:
                  viewModel.tutorialEVASteps[viewModel.index].isTextSpan,
              boldWords: viewModel.tutorialEVASteps[viewModel.index].boldWords,
              nextButtonText:
                  (viewModel.index == viewModel.tutorialEVASteps.length - 1)
                      ? s.lets_go_button
                      : s.next,
              isTutorialStarted: viewModel.tutorialEVALoaded,
              isSingleButtonVisible: viewModel.tutorialEVALoaded,
              isShowForHome: false,
              showAppBar: _showAppBar,
            ),
          ),
        );
      },
    );
  }
}
