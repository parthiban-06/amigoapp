import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:visaamigo/utils/theme_extension.dart';

class CustomIconButton extends StatelessWidget {
  final Widget icon;
  final VoidCallback onTap;
  final EdgeInsets margin;
  final EdgeInsets padding;

  const CustomIconButton({
    super.key,
    required this.icon,
    required this.onTap,
    this.margin = EdgeInsets.zero,
    this.padding = EdgeInsets.zero,
  });

  @override
  Widget build(BuildContext context) {
    final platform = context.theme.platform;
    return Padding(
      padding: margin,
      child: !kIsWeb &&
              (platform == TargetPlatform.iOS ||
                  platform == TargetPlatform.macOS)
          ? CupertinoButton(
              onPressed: onTap,
              padding: padding,
              child: icon,
            )
          : InkWell(
              onTap: onTap,
              borderRadius: BorderRadius.circular(100.0).r,
              child: Padding(
                padding: padding,
                child: icon,
              ),
            ),
    );
  }
}
