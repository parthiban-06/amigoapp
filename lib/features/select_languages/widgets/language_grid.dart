import 'package:flutter/material.dart';
import 'package:visaamigo/features/select_languages/widgets/selected_card.dart';
import 'package:visaamigo/features/select_languages/widgets/unSelected_card.dart';

import '../models/language_selection_model.dart';

class LanguageCard extends StatelessWidget {
  final Language language;
  final bool isSelected;
  final VoidCallback onTap;

  const LanguageCard({
    super.key,
    required this.language,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: isSelected
          ? SelectedCard(
        language: language,
      )
          : UnselectedCard(language: language),
    );
  }
}
