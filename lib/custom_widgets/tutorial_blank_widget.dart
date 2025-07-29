import 'package:flutter/cupertino.dart';
import 'package:visaamigo/custom_widgets/visa_show_case_widget.dart';

class TutorialBlankWidget extends StatelessWidget {
  final GlobalKey tutorialBlank;
  final bool isComeFromHome;

  const TutorialBlankWidget({
    super.key,
    required this.tutorialBlank,
    required this.isComeFromHome,
  });

  @override
  Widget build(BuildContext context) {
    return VisaShowcase(
      keyValue: tutorialBlank,
      isComeFromHome: isComeFromHome,
      child: const SizedBox.shrink(),
    );
  }
}
