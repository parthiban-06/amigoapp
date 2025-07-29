import 'package:flutter/material.dart';

class VisaNavigationSemantics extends StatelessWidget {
  final String label;
  final Widget child;

  const VisaNavigationSemantics({
    super.key,
    required this.label,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      container: true,
      excludeSemantics: true,
      label: label,
      child: child,
    );
  }
}
