import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:visaamigo/custom_widgets/visa_textview.dart';

class ClickableLinkTextView extends StatelessWidget {
  final String text;
  final String linkText;
  final VoidCallback onLinkTap;
  final VisaTextStyle textStyle;
  final VisaTextStyle linkTextStyle;
  final VisaTextTheme textColorTheme;
  final VisaTextTheme linkColorTheme;
  final TextAlign textAlign;
  final VisaFontWeight fontWeight;
  final bool semantics;
  final int maxline;

  const ClickableLinkTextView({
    super.key,
    required this.text,
    required this.linkText,
    required this.onLinkTap,
    this.textStyle = VisaTextStyle.bodyMedium,
    this.linkTextStyle = VisaTextStyle.bodyMedium,
    this.textColorTheme = VisaTextTheme.primary,
    this.linkColorTheme = VisaTextTheme.primary,
    this.textAlign = TextAlign.start,
    this.fontWeight = VisaFontWeight.regular,
    this.semantics = true,
    this.maxline = 3,
  });

  @override
  Widget build(BuildContext context) {
    // Check if the link text is contained in the full text
    if (!text.toLowerCase().contains(linkText.toLowerCase())) {
      return VisaTextView(
        semantics: semantics,
        text: text,
        style: textStyle,
        colorTheme: textColorTheme,
        textAlign: textAlign,
        fontFamily: fontWeight,
        maxLines: maxline,
      );
    }

    // Split the text into parts before, during, and after the link
    final beforeLink =
        text.substring(0, text.toLowerCase().indexOf(linkText.toLowerCase()));
    final afterLink = text.substring(
        text.toLowerCase().indexOf(linkText.toLowerCase()) + linkText.length);

    return RichText(
      textAlign: textAlign,
      text: TextSpan(
        children: [
          // Text before the link
          WidgetSpan(
            child: VisaTextView(
              semantics: semantics,
              semanticsFocus: true,
              text: beforeLink,
              style: textStyle,
              colorTheme: textColorTheme,
              textAlign: textAlign,
              fontFamily: fontWeight,
              maxLines: maxline,
            ),
          ),

          // Clickable link text
          WidgetSpan(
            child: Semantics(
              label: linkText,
              button: true,
              child: GestureDetector(
                onTap: onLinkTap,
                child: VisaTextView(
                  semantics: false,
                  text: linkText,
                  style: linkTextStyle,
                  colorTheme: linkColorTheme,
                  textAlign: textAlign,
                  fontFamily: fontWeight,
                  maxLines: maxline,
                ),
              ),
            ),
          ),

          // Text after the link
          WidgetSpan(
            child: VisaTextView(
              semantics: semantics,
              text: afterLink,
              style: textStyle,
              colorTheme: textColorTheme,
              textAlign: textAlign,
              fontFamily: fontWeight,
              maxLines: maxline,
            ),
          ),
        ],
      ),
    );
  }
}
