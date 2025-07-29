import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';

class VisaImageIcon extends StatelessWidget {
  final String assetPath;
  final double? width;
  final double? height;
  final Color? color;
  final BoxFit fit;
  final double opacity;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final VoidCallback? onTap;
  final bool semantics;
  final String? semanticsLabel;
  final int? semanticsIndex;

  const VisaImageIcon({
    super.key,
    required this.assetPath, //
    this.width, // Default size
    this.height,
    this.color,
    this.fit = BoxFit.contain,
    this.opacity = 1.0,
    this.padding,
    this.margin,
    this.onTap, // Optional click handler
    this.semantics = true,
    this.semanticsLabel,
    this.semanticsIndex,
  });

  @override
  Widget build(BuildContext context) {
    // Fetch color from IconTheme if no color is provided
    String labelName =
        assetPath.split("/").last.replaceAll("_", " ").replaceAll(".png", "");

    Widget icon = Opacity(
      opacity: opacity,
      child: Image.asset(
        assetPath,
        width: width,
        height: height,
        fit: fit,
      ),
    );

    // Add Padding & Margin if needed
    if (padding != null || margin != null) {
      icon = Padding(
        padding: margin ?? EdgeInsets.zero,
        child: Container(
          padding: padding ?? EdgeInsets.zero,
          child: semantics
              ? Semantics(
                  sortKey: semanticsIndex != null
                      ? OrdinalSortKey(semanticsIndex!.toDouble())
                      : null,
                  enabled: true,
                  hidden: false,
                  excludeSemantics: true,
                  container: true,
                  label: semanticsLabel ?? labelName,
                  child: icon,
                )
              : ExcludeSemantics(child: icon),
        ),
      );
    }

    // Wrap with GestureDetector if onTap is provided
    return onTap != null ? GestureDetector(onTap: onTap, child: icon) : icon;
  }
}
