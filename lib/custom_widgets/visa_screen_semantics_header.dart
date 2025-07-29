import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';

class VisaScreenSemanticsHeader extends StatelessWidget {
  final String label;
  final Widget child;
  final int sortOrder;
  final bool enabled;
  final bool hidden;

  const VisaScreenSemanticsHeader({
    super.key,
    required this.label,
    required this.child,
    this.sortOrder = 1,
    this.enabled = true,
    this.hidden = false,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      sortKey: OrdinalSortKey(sortOrder.toDouble()),
      container: true,
      label: label,
      enabled: enabled,
      hidden: hidden,
      child: child,
    );
  }
}
