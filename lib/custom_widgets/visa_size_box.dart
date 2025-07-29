import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../features/select_languages/providers/language_selection_generic_provider.dart';

class VisaSizeBox extends StatelessWidget {
  final double? height;
  final double? width;
  final bool? isHorozontal;

  const VisaSizeBox({super.key, this.width, this.height, this.isHorozontal});

  @override
  Widget build(BuildContext context) {
    final bool isRTL =
        Provider.of<SelectLanguageGenericProvider>(context).isRTL;

    return (height != null)
        ? SizedBox(height: height!)
        : (width != null)
            ? SizedBox(width: width!) // remove RTL logic here
            : const SizedBox.shrink();
  }
}
