class AiGetPreferencesQuestionModel {
  final List<Questions>? questions;

  AiGetPreferencesQuestionModel({this.questions});

  AiGetPreferencesQuestionModel copyWith({List<Questions>? questions}) {
    return AiGetPreferencesQuestionModel(
      questions: questions ?? this.questions,
    );
  }

  factory AiGetPreferencesQuestionModel.fromJson(Map<String, dynamic> json) {
    return AiGetPreferencesQuestionModel(
      questions: (json['questions'] as List?)
          ?.map((dynamic e) => Questions.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        'questions': questions?.map((e) => e.toJson()).toList(),
      };
}

class Questions {
  final String? questionId;
  final String? questionKey;
  final String? section;
  final bool? isPrimary;
  final List<Options>? options;
  final List<dynamic>? selectedOptions;

  Questions({
    this.questionId,
    this.questionKey,
    this.section,
    this.isPrimary,
    this.options,
    this.selectedOptions,
  });

  Questions copyWith({
    String? questionId,
    String? questionKey,
    String? section,
    bool? isPrimary,
    List<Options>? options,
    List<dynamic>? selectedOptions,
  }) {
    return Questions(
      questionId: questionId ?? this.questionId,
      questionKey: questionKey ?? this.questionKey,
      section: section ?? this.section,
      isPrimary: isPrimary ?? this.isPrimary,
      options: options ?? this.options,
      selectedOptions: selectedOptions ?? this.selectedOptions,
    );
  }

  factory Questions.fromJson(Map<String, dynamic> json) {
    return Questions(
      questionId: json['question_id'] as String?,
      questionKey: json['question_key'] as String?,
      section: json['section'] as String?,
      isPrimary: json['is_primary'] as bool?,
      options: (json['options'] as List?)
          ?.map((dynamic e) => Options.fromJson(e as Map<String, dynamic>))
          .toList(),
      selectedOptions: json['selected_options'] as List?,
    );
  }

  Map<String, dynamic> toJson() => {
        'question_id': questionId,
        'question_key': questionKey,
        'section': section,
        'is_primary': isPrimary,
        'options': options?.map((e) => e.toJson()).toList(),
        'selected_options': selectedOptions,
      };
}

class Options {
  final String? optionId;
  final String? optionName;
  bool? isSelected;
  bool? permanentSelected;

  Options(
      {this.optionId,
      this.isSelected,
      this.optionName,
      this.permanentSelected});

  Options copyWith({String? optionId, bool? isSelected, String? optionName}) {
    return Options(
      optionName: optionName ?? this.optionName,
      optionId: optionId ?? this.optionId,
      isSelected: isSelected ?? this.isSelected,
      permanentSelected: permanentSelected ?? this.isSelected,
    );
  }

  factory Options.fromJson(Map<String, dynamic> json) {
    return Options(
      optionName: json['option_name'] as String?,
      optionId: json['option_id'] as String?,
      isSelected: json['is_selected'] as bool?,
      permanentSelected: json['permanent_selected'] as bool?,
    );
  }

  Map<String, dynamic> toJson() => {
        'option_id': optionId,
        'option_name': optionName,
        'is_selected': isSelected,
        'permanent_selected': permanentSelected,
      };
}
