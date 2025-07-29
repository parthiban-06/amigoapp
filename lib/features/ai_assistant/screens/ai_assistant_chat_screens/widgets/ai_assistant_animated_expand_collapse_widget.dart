import 'package:flutter/material.dart';

class AiAssistantAnimatedExpandCollapseWidget extends StatefulWidget {
  final bool isExpanded;
  final Widget child;

  const AiAssistantAnimatedExpandCollapseWidget({
    super.key,
    required this.isExpanded,
    required this.child,
  });

  @override
  State<AiAssistantAnimatedExpandCollapseWidget> createState() =>
      _AnimatedExpandCollapseState();
}

class _AnimatedExpandCollapseState
    extends State<AiAssistantAnimatedExpandCollapseWidget> {
  bool _showChild = false;

  @override
  void initState() {
    super.initState();
    if (widget.isExpanded) {
      _showChild = true;
    }
  }

  @override
  void didUpdateWidget(
      covariant AiAssistantAnimatedExpandCollapseWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.isExpanded && !_showChild) {
      setState(() => _showChild = true);
    } else if (!widget.isExpanded && _showChild) {
      Future.delayed(const Duration(milliseconds: 100), () {
        if (!widget.isExpanded && mounted) {
          setState(() => _showChild = false);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSize(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
      alignment: Alignment.topCenter,
      child: _showChild
          ? TweenAnimationBuilder<double>(
              tween: Tween(
                begin: widget.isExpanded ? 0.7 : 1.0,
                end: widget.isExpanded ? 1.0 : 0.7,
              ),
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeInOut,
              builder: (context, scale, child) {
                return Transform.scale(
                  scale: scale,
                  alignment: Alignment.topCenter,
                  child: AnimatedOpacity(
                    duration: const Duration(milliseconds: 200),
                    opacity: widget.isExpanded ? 1 : 0,
                    child: child,
                  ),
                );
              },
              child: widget.child,
            )
          : const SizedBox.shrink(),
    );
  }
}
