import 'package:flutter_test/flutter_test.dart';
import 'dart:convert';
import 'package:visaamigo/features/ai_assistant/models/ai_personal_preferences_model.dart';

void main() {
  group('AiPersonalPreferencesModel', () {
    final jsonMap = {
      'title': 'My Preferences',
      'chips': ['A', 'B', 'C'],
    };

    test('fromJson parses all fields', () {
      final model = AiPersonalPreferencesModel.fromJson(jsonMap);
      expect(model.title, 'My Preferences');
      expect(model.chips, ['A', 'B', 'C']);
    });

    test('toJson returns correct map', () {
      final model = AiPersonalPreferencesModel.fromJson(jsonMap);
      final map = model.toJson();
      expect(map['title'], 'My Preferences');
      expect(map['chips'], ['A', 'B', 'C']);
    });

    test('personalPrefModelFromJson parses from string', () {
      final jsonString = json.encode(jsonMap);
      final model = personalPrefModelFromJson(jsonString);
      expect(model.title, 'My Preferences');
      expect(model.chips, ['A', 'B', 'C']);
    });

    test('personalPrefModelToJson encodes to string', () {
      final model = AiPersonalPreferencesModel.fromJson(jsonMap);
      final jsonString = personalPrefModelToJson(model);
      final decoded = json.decode(jsonString);
      expect(decoded['title'], 'My Preferences');
      expect(decoded['chips'], ['A', 'B', 'C']);
    });

    test('personalPrefFromJsonList parses list', () {
      final list = [
        {'title': 'T1', 'chips': ['X']},
        {'title': 'T2', 'chips': ['Y', 'Z']},
      ];
      final models = personalPrefFromJsonList(list);
      expect(models.length, 2);
      expect(models[0].title, 'T1');
      expect(models[1].chips, ['Y', 'Z']);
    });

    test('constructor with parameters', () {
      final model = AiPersonalPreferencesModel(
        title: 'Custom Title',
        chips: ['Custom', 'Chips'],
      );
      expect(model.title, 'Custom Title');
      expect(model.chips, ['Custom', 'Chips']);
    });

    test('constructor with null values', () {
      final model = AiPersonalPreferencesModel();
      expect(model.title, isNull);
      expect(model.chips, isNull);
    });

    test('handles null values in fromJson', () {
      final nullJson = {
        'title': null,
        'chips': null,
      };
      final model = AiPersonalPreferencesModel.fromJson(nullJson);
      expect(model.title, isNull);
      expect(model.chips, isNull);
    });
  });
}
