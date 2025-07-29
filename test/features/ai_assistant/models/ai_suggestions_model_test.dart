import 'package:flutter_test/flutter_test.dart';
import 'dart:convert';
import 'package:visaamigo/features/ai_assistant/models/ai_suggestions_model.dart';

void main() {
  group('AISuggestions', () {
    final jsonMap = {'suggestion': 'Try Paris'};

    test('fromJson parses suggestion', () {
      final model = AISuggestions.fromJson(jsonMap);
      expect(model.suggestion, 'Try Paris');
    });

    test('toJson returns correct map', () {
      final model = AISuggestions.fromJson(jsonMap);
      final map = model.toJson();
      expect(map['suggestion'], 'Try Paris');
    });

    test('suggestionModelFromJson parses from string', () {
      final jsonString = json.encode(jsonMap);
      final model = suggestionModelFromJson(jsonString);
      expect(model.suggestion, 'Try Paris');
    });

    test('suggestionModelToJson encodes to string', () {
      final model = AISuggestions.fromJson(jsonMap);
      final jsonString = suggestionModelToJson(model);
      final decoded = json.decode(jsonString);
      expect(decoded['suggestion'], 'Try Paris');
    });

    test('suggestionFromJsonList parses list', () {
      final list = [
        {'suggestion': 'A'},
        {'suggestion': 'B'},
      ];
      final models = suggestionFromJsonList(list);
      expect(models.length, 2);
      expect(models[0].suggestion, 'A');
      expect(models[1].suggestion, 'B');
    });

    test('copyWith returns new instance with updated suggestion', () {
      final model = AISuggestions.fromJson({'suggestion': 'Old'});
      final updated = model.copyWith(suggestion: 'New');
      expect(updated.suggestion, 'New');
      expect(model.suggestion, 'Old');
    });

    test('suggestion getter returns empty string if null', () {
      final model = AISuggestions();
      expect(model.suggestion, '');
    });
  });
}
