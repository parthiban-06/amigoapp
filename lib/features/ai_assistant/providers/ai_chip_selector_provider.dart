import 'package:flutter/material.dart';
import 'package:visaamigo/features/ai_assistant/models/ai_get_preferences_questions_model.dart';

class AiChipSelectorProvider extends ChangeNotifier {
  List<Options> _options;
  List<Options> get options => _options;

  bool get hasSelected =>
      _options.any((o) => o.isSelected == true); // includes "no_preference"

  AiChipSelectorProvider(this._options);

  void toggleChip(int chipIndex) {
    if (chipIndex < 0 || chipIndex >= _options.length) return;

    final selectedOption = _options[chipIndex];

    _options = _options.map((option) {
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

    notifyListeners();
  }
}
