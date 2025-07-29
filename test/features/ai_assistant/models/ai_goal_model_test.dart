import 'package:flutter_test/flutter_test.dart';
import 'dart:convert';
import 'package:visaamigo/features/ai_assistant/models/ai_goal_model.dart';

void main() {
  group('AiGoalModel', () {
    final jsonMap = {
      'id': 1,
      'name': 'Goal Name',
      'group': 'Group1',
      'lang_name_key': 'key',
      'lang_name_group': 'groupKey',
      'size': 10.0,
      'selected_size': 5.0,
      'surrounded_size': 2.0,
      'isSelect': true,
      'max_line': 3,
    };

    test('fromJson parses all fields', () {
      final model = AiGoalModel.fromJson(jsonMap);
      expect(model.id, 1);
      expect(model.name, 'Goal Name');
      expect(model.group, 'Group1');
      expect(model.langNameKey, 'key');
      expect(model.langNameGroup, 'groupKey');
      expect(model.size, 10.0);
      expect(model.selectedSize, 5.0);
      expect(model.surroundedSize, 2.0);
      expect(model.isSelect, true);
      expect(model.maxLines, 3);
    });

    test('toJson returns correct map', () {
      final model = AiGoalModel.fromJson(jsonMap);
      final map = model.toJson();
      expect(map['id'], 1);
      expect(map['name'], 'Goal Name');
      expect(map['group'], 'Group1');
      expect(map['lang_name_key'], 'key');
      expect(map['lang_name_group'], 'groupKey');
      expect(map['size'], 10.0);
      expect(map['selected_size'], 5.0);
      expect(map['surrounded_size'], 2.0);
      expect(map['isSelect'], true);
      expect(map['max_line'], 3);
    });

    test('goalModelFromJson parses from string', () {
      final jsonString = json.encode(jsonMap);
      final model = goalModelFromJson(jsonString);
      expect(model.id, 1);
      expect(model.name, 'Goal Name');
    });

    test('goalModelToJson encodes to string', () {
      final model = AiGoalModel.fromJson(jsonMap);
      final jsonString = goalModelToJson(model);
      final decoded = json.decode(jsonString);
      expect(decoded['id'], 1);
      expect(decoded['name'], 'Goal Name');
    });

    test('goalFromJsonList parses list', () {
      final list = [
        {
          'id': 1,
          'name': 'A',
          'group': 'G',
          'lang_name_key': 'k',
          'lang_name_group': 'gk',
          'size': 1.0,
          'selected_size': 1.0,
          'surrounded_size': 1.0,
          'isSelect': false,
          'max_line': 1,
        },
        {
          'id': 2,
          'name': 'B',
          'group': 'G',
          'lang_name_key': 'k',
          'lang_name_group': 'gk',
          'size': 2.0,
          'selected_size': 2.0,
          'surrounded_size': 2.0,
          'isSelect': true,
          'max_line': 2,
        },
      ];
      final models = goalFromJsonList(list);
      expect(models.length, 2);
      expect(models[0].id, 1);
      expect(models[1].name, 'B');
      expect(models[1].isSelect, true);
    });
  });
}
