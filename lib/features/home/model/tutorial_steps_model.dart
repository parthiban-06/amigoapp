class TutorialStepsModel {
  final String title;
  final String subtitle;
  final String description;
  final String iconAsset;
  final bool isTextSpan;
  final List<String>? boldWords;

  TutorialStepsModel({
    required this.title,
    required this.subtitle,
    required this.description,
    required this.iconAsset,
    this.isTextSpan = false,
    this.boldWords,
  });
}
