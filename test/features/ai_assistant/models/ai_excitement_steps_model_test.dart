import 'package:flutter_test/flutter_test.dart';
import 'dart:convert';
import 'package:visaamigo/features/ai_assistant/models/ai_excitement_steps_model.dart';

void main() {
  group('AiExcitementStepsModel', () {
    final jsonMap = {
      'id': 1,
      'title': 'Excitement Step',
      'point': 2.5,
      'isSelect': true,
    };

    test('fromJson parses all fields', () {
      final model = AiExcitementStepsModel.fromJson(jsonMap);
      expect(model.id, 1);
      expect(model.title, 'Excitement Step');
      expect(model.point, 2.5);
      expect(model.isSelect, true);
    });

    test('toJson returns correct map', () {
      final model = AiExcitementStepsModel.fromJson(jsonMap);
      final map = model.toJson();
      expect(map['id'], 1);
      expect(map['title'], 'Excitement Step');
      expect(map['point'], 2.5);
      expect(map['isSelect'], true);
    });

    test('excitementModelFromJson parses from string', () {
      final jsonString = json.encode(jsonMap);
      final model = excitementModelFromJson(jsonString);
      expect(model.id, 1);
      expect(model.title, 'Excitement Step');
    });

    test('suggestionModelToJson encodes to string', () {
      final model = AiExcitementStepsModel.fromJson(jsonMap);
      final jsonString = suggestionModelToJson(model);
      final decoded = json.decode(jsonString);
      expect(decoded['id'], 1);
      expect(decoded['title'], 'Excitement Step');
    });

    test('excitementFromJsonList parses list', () {
      final list = [
        {'id': 1, 'title': 'A', 'point': 1.0, 'isSelect': false},
        {'id': 2, 'title': 'B', 'point': 2.0, 'isSelect': true},
      ];
      final models = excitementFromJsonList(list);
      expect(models.length, 2);
      expect(models[0].id, 1);
      expect(models[1].title, 'B');
      expect(models[1].isSelect, true);
    });
  });
}
