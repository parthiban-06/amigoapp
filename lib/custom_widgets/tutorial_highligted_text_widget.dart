import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';

class HighlightedText extends StatelessWidget {
  /// The full text content to render.
  final String text;

  /// A list of words to render in bold.
  final List<String> boldWords;

  /// Optional base style for the text.
  final TextStyle? style;

  /// Whether to include the text in the semantics tree (accessibility).
  final bool semantics;

  /// Optional semantics sort index for reading order.
  final int? semanticsIndex;

  final String? semanticLabel;

  const HighlightedText({
    super.key,
    required this.text,
    required this.boldWords,
    this.style,
    this.semantics = true,
    this.semanticsIndex,
    this.semanticLabel,
  });

  @override
  Widget build(BuildContext context) {
    final baseStyle = style ?? const TextStyle();
    final textSpans = _buildTextSpans(text, boldWords, baseStyle);
    final richText = Text.rich(TextSpan(children: textSpans));

    if (!semantics) {
      return ExcludeSemantics(child: richText);
    }

    return Semantics(
      label: semanticLabel ?? text,
      sortKey: semanticsIndex != null
          ? OrdinalSortKey(semanticsIndex!.toDouble())
          : null,
      enabled: true,
      hidden: false,
      container: true,
      child: ExcludeSemantics(child: richText),
    );
  }

  List<TextSpan> _buildTextSpans(
      String text, List<String> boldWords, TextStyle baseStyle) {
    if (boldWords.isEmpty) {
      return [TextSpan(text: text, style: baseStyle)];
    }

    final pattern = RegExp(
      '(${boldWords.map(RegExp.escape).join('|')})',
      caseSensitive: false,
    );

    final spans = <TextSpan>[];

    text.splitMapJoin(
      pattern,
      onMatch: (match) {
        spans.add(TextSpan(
          text: match[0],
          style: baseStyle.copyWith(fontWeight: FontWeight.w700),
        ));
        return '';
      },
      onNonMatch: (nonMatch) {
        spans.add(TextSpan(
          text: nonMatch,
          style: baseStyle,
        ));
        return '';
      },
    );

    return spans;
  }
}
