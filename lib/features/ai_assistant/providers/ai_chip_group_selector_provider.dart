import 'package:flutter/material.dart';
import 'package:visaamigo/features/ai_assistant/models/ai_get_preferences_questions_model.dart';

class AiChipGroupSelectorProvider extends ChangeNotifier {
  final List<Questions> _questions;

  AiChipGroupSelectorProvider(this._questions);

  List<Questions> get questions => _questions;

  void toggleChipSelection(int parentIndex, int chipIndex) {
    if (parentIndex < 0 || parentIndex >= _questions.length) return;
    if (chipIndex < 0 || chipIndex >= _questions[parentIndex].options!.length) {
      return;
    }

    final selectedOption = _questions[parentIndex].options![chipIndex];

    final updatedOptions = _questions[parentIndex].options!.map((option) {
      if (selectedOption.optionId == "no_preference") {
        return option.copyWith(isSelected: option.optionId == "no_preference");
      } else {
        if (option.optionId == "no_preference") {
          return option.copyWith(isSelected: false);
        } else if (option.optionId == selectedOption.optionId) {
          return option.copyWith(
              isSelected: !(selectedOption.isSelected ?? false));
        }
        return option;
      }
    }).toList();

    _questions[parentIndex] =
        _questions[parentIndex].copyWith(options: updatedOptions);

    notifyListeners();
  }

  /// Optionally: Get only selected questions
  List<Questions> get selectedQuestions => _questions
      .where((q) => q.options!.any((o) => o.isSelected == true))
      .toList();
}
