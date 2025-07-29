import 'package:flutter_test/flutter_test.dart';
import 'package:visaamigo/features/ai_assistant/models/ai_get_preferences_questions_model.dart';

void main() {
  group('AiGetPreferencesQuestionModel', () {
    final json = {
      'questions': [
        {
          'question_id': 'q1',
          'question_key': 'key1',
          'section': 'sec1',
          'is_primary': true,
          'options': [
            {
              'option_id': 'o1',
              'option_name': 'Option 1',
              'is_selected': true,
              'permanent_selected': false
            }
          ],
          'selected_options': ['o1']
        }
      ]
    };

    test('fromJson parses all fields', () {
      final model = AiGetPreferencesQuestionModel.fromJson(json);
      expect(model.questions?.length, 1);
      final q = model.questions!.first;
      expect(q.questionId, 'q1');
      expect(q.questionKey, 'key1');
      expect(q.section, 'sec1');
      expect(q.isPrimary, true);
      expect(q.options?.length, 1);
      expect(q.options?.first.optionId, 'o1');
      expect(q.options?.first.optionName, 'Option 1');
      expect(q.options?.first.isSelected, true);
      expect(q.options?.first.permanentSelected, false);
      expect(q.selectedOptions, ['o1']);
    });

    test('toJson returns correct map', () {
      final model = AiGetPreferencesQuestionModel.fromJson(json);
      final map = model.toJson();
      expect(map['questions'][0]['question_id'], 'q1');
      expect(map['questions'][0]['options'][0]['option_id'], 'o1');
      expect(map['questions'][0]['selected_options'], ['o1']);
    });

    test('copyWith returns new instance with updated fields', () {
      final model = AiGetPreferencesQuestionModel.fromJson(json);
      final updated = model.copyWith(questions: []);
      expect(updated.questions, isEmpty);
    });

    test('handles null/empty cases', () {
      final emptyJson = <String, dynamic>{};
      final model = AiGetPreferencesQuestionModel.fromJson(emptyJson);
      expect(model.questions, isNull);
      final map = model.toJson();
      expect(map['questions'], isNull);
    });

    test('handles null questions list', () {
      final jsonWithNullQuestions = {'questions': null};
      final model = AiGetPreferencesQuestionModel.fromJson(jsonWithNullQuestions);
      expect(model.questions, isNull);
    });

    test('handles empty questions list', () {
      final jsonWithEmptyQuestions = {'questions': []};
      final model = AiGetPreferencesQuestionModel.fromJson(jsonWithEmptyQuestions);
      expect(model.questions, isEmpty);
    });

    test('copyWith with null values', () {
      final model = AiGetPreferencesQuestionModel.fromJson(json);
      final updated = model.copyWith(questions: null);
      expect(updated.questions, model.questions);
    });
  });

  group('Questions', () {
    final json = {
      'question_id': 'q2',
      'question_key': 'key2',
      'section': 'sec2',
      'is_primary': false,
      'options': [
        {
          'option_id': 'o2',
          'option_name': 'Option 2',
          'is_selected': false,
          'permanent_selected': true
        }
      ],
      'selected_options': ['o2']
    };
    
    test('fromJson and toJson', () {
      final q = Questions.fromJson(json);
      expect(q.questionId, 'q2');
      expect(q.questionKey, 'key2');
      expect(q.section, 'sec2');
      expect(q.isPrimary, false);
      expect(q.options?.first.optionId, 'o2');
      expect(q.options?.first.optionName, 'Option 2');
      expect(q.options?.first.isSelected, false);
      expect(q.options?.first.permanentSelected, true);
      expect(q.selectedOptions, ['o2']);
      final map = q.toJson();
      expect(map['question_id'], 'q2');
      expect(map['options'][0]['option_id'], 'o2');
    });
    
    test('copyWith returns new instance with updated fields', () {
      final q = Questions.fromJson(json);
      final updated = q.copyWith(questionId: 'newId');
      expect(updated.questionId, 'newId');
      expect(updated.questionKey, 'key2');
    });

    test('handles null values', () {
      final nullJson = {
        'question_id': null,
        'question_key': null,
        'section': null,
        'is_primary': null,
        'options': null,
        'selected_options': null,
      };
      final q = Questions.fromJson(nullJson);
      expect(q.questionId, isNull);
      expect(q.questionKey, isNull);
      expect(q.section, isNull);
      expect(q.isPrimary, isNull);
      expect(q.options, isNull);
      expect(q.selectedOptions, isNull);
      final map = q.toJson();
      expect(map['question_id'], isNull);
      expect(map['options'], isNull);
    });

    test('copyWith with all null values', () {
      final q = Questions.fromJson(json);
      final updated = q.copyWith(
        questionId: null,
        questionKey: null,
        section: null,
        isPrimary: null,
        options: null,
        selectedOptions: null,
      );
      expect(updated.questionId, q.questionId);
      expect(updated.questionKey, q.questionKey);
      expect(updated.section, q.section);
      expect(updated.isPrimary, q.isPrimary);
      expect(updated.options, q.options);
      expect(updated.selectedOptions, q.selectedOptions);
    });

    test('handles empty options list', () {
      final jsonWithEmptyOptions = {
        'question_id': 'q3',
        'question_key': 'key3',
        'section': 'sec3',
        'is_primary': true,
        'options': [],
        'selected_options': [],
      };
      final q = Questions.fromJson(jsonWithEmptyOptions);
      expect(q.options, isEmpty);
      expect(q.selectedOptions, isEmpty);
    });
  });

  group('Options', () {
    final json = {
      'option_id': 'o3',
      'option_name': 'Option 3',
      'is_selected': true,
      'permanent_selected': false
    };
    
    test('fromJson and toJson', () {
      final o = Options.fromJson(json);
      expect(o.optionId, 'o3');
      expect(o.optionName, 'Option 3');
      expect(o.isSelected, true);
      expect(o.permanentSelected, false);
      final map = o.toJson();
      expect(map['option_id'], 'o3');
      expect(map['option_name'], 'Option 3');
    });
    
    test('copyWith returns new instance with updated fields', () {
      final o = Options.fromJson(json);
      final updated = o.copyWith(optionName: 'New Option');
      expect(updated.optionName, 'New Option');
      expect(updated.optionId, 'o3');
    });

    test('handles null values', () {
      final nullJson = {
        'option_id': null,
        'option_name': null,
        'is_selected': null,
        'permanent_selected': null,
      };
      final o = Options.fromJson(nullJson);
      expect(o.optionId, isNull);
      expect(o.optionName, isNull);
      expect(o.isSelected, isNull);
      expect(o.permanentSelected, isNull);
      final map = o.toJson();
      expect(map['option_id'], isNull);
      expect(map['option_name'], isNull);
    });

    test('copyWith with null values', () {
      final o = Options.fromJson(json);
      final updated = o.copyWith(
        optionId: null,
        optionName: null,
        isSelected: null,
      );
      expect(updated.optionId, o.optionId);
      expect(updated.optionName, o.optionName);
      expect(updated.isSelected, o.isSelected);
      expect(updated.permanentSelected, false);
    });

    test('copyWith preserves permanentSelected correctly', () {
      final o = Options.fromJson(json);
      final updated = o.copyWith(optionName: 'Test');
      expect(updated.permanentSelected, false);
    });
  });

  test('All model classes can be instantiated', () {
    final model = AiGetPreferencesQuestionModel();
    final questions = Questions();
    final options = Options();

    expect(model, isA<AiGetPreferencesQuestionModel>());
    expect(questions, isA<Questions>());
    expect(options, isA<Options>());
  });
}
