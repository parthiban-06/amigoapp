import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:visaamigo/utils/utils.dart';

import '../features/select_languages/providers/language_selection_generic_provider.dart';

class VisaSvgIcon extends StatelessWidget {
  final String assetPath;
  final double? width;
  final double? height;
  final Color? color;
  final BoxFit fit;
  final double opacity;
  final bool isIconFlip;
  final bool setColorFilter;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final VoidCallback? onTap;
  final bool? useWithoutColor;
  final bool semantics;
  final String? semanticsLabel;
  final int? semanticsIndex;
  final bool semanticsFocused;
  final bool useWithShadow;
  final Color shadowColor;

  const VisaSvgIcon({
    super.key,
    required this.assetPath,
    this.width = 22.0,
    this.height = 22.0,
    this.color,
    this.fit = BoxFit.contain,
    this.opacity = 1.0,
    this.padding,
    this.isIconFlip = true,
    this.setColorFilter = true,
    this.margin,
    this.onTap,
    this.useWithoutColor = false,
    this.semantics = true,
    this.semanticsLabel,
    this.semanticsIndex,
    this.semanticsFocused = false,
    this.useWithShadow = false,
    this.shadowColor = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    final bool isRTL =
        Provider.of<SelectLanguageGenericProvider>(context).isRTL;
    final iconColor = color ?? IconTheme.of(context).color;

    final String labelName =
        assetPath.split("/").last.replaceAll("_", " ").replaceAll(".svg", "");

    final double scaledWidth =
        (width ?? 22) * Utils.getCappedScale(context, width ?? 22);
    final double scaledHeight =
        (height ?? 22) * Utils.getCappedScale(context, height ?? 22);

    Widget svg = SvgPicture.asset(
      assetPath,
      width: scaledWidth,
      height: scaledHeight,
      fit: fit,
      colorFilter: useWithoutColor == true || !setColorFilter
          ? null
          : iconColor != null
              ? ColorFilter.mode(iconColor, BlendMode.srcIn)
              : null,
    );

    if (useWithShadow) {
      svg = Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: shadowColor.withValues(
                alpha: 0.4,
              ), // lower opacity for lightness
              blurRadius: 15, // softer edge
              spreadRadius: 0.9, // small spread
              offset: const Offset(0, 1), // subtle bottom offset
            ),
          ],
        ),
        child: svg,
      );
    }

    svg = Opacity(opacity: opacity, child: svg);

    Widget icon = semantics
        ? Semantics(
            sortKey: semanticsIndex != null
                ? OrdinalSortKey(semanticsIndex!.toDouble())
                : null,
            enabled: true,
            excludeSemantics: true,
            container: true,
            focused: semanticsFocused,
            focusable: semanticsFocused,
            label: semanticsLabel ?? labelName,
            child: svg,
          )
        : ExcludeSemantics(child: svg);

    if (padding != null || margin != null) {
      icon = Padding(
        padding: margin ?? EdgeInsets.zero,
        child: Container(
          padding: padding ?? EdgeInsets.zero,
          child: icon,
        ),
      );
    }

    if (isIconFlip) {
      icon = Transform.flip(
        flipX: isRTL,
        child: icon,
      );
    }

    return onTap != null ? GestureDetector(onTap: onTap, child: icon) : icon;
  }
}
