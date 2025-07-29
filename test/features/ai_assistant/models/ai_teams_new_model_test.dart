import 'package:flutter_test/flutter_test.dart';
import 'dart:convert';
import 'package:visaamigo/features/ai_assistant/models/ai_teams_new_model.dart';

void main() {
  group('AiTeamsNewModel', () {
    final jsonMap = {
      'teams': [
        {'id': 1, 'name': 'Team A', 'key': 'A'},
        {'id': 2, 'name': 'Team B', 'key': 'B'},
      ]
    };

    test('fromJson parses all fields', () {
      final model = AiTeamsNewModel.fromJson(jsonMap);
      expect(model.teams.length, 2);
      expect(model.teams[0].id, 1);
      expect(model.teams[0].name, 'Team A');
      expect(model.teams[0].key, 'A');
      expect(model.teams[1].id, 2);
      expect(model.teams[1].name, 'Team B');
      expect(model.teams[1].key, 'B');
    });

    test('toJson returns correct map', () {
      final model = AiTeamsNewModel.fromJson(jsonMap);
      final map = model.toJson();
      expect(map['teams'][0]['id'], 1);
      expect(map['teams'][1]['name'], 'Team B');
    });

    test('teamsNewModelFromJson parses from string', () {
      final jsonString = json.encode(jsonMap);
      final model = teamsNewModelFromJson(jsonString);
      expect(model.teams.length, 2);
      expect(model.teams[0].name, 'Team A');
    });

    test('teamsNewModelToJson encodes to string', () {
      final model = AiTeamsNewModel.fromJson(jsonMap);
      final jsonString = teamsNewModelToJson(model);
      final decoded = json.decode(jsonString);
      expect(decoded['teams'][0]['id'], 1);
      expect(decoded['teams'][1]['key'], 'B');
    });

    test('teamsNewFromJsonList parses list', () {
      final list = [
        {'teams': [{'id': 1, 'name': 'T1', 'key': 'K1'}]},
        {'teams': [{'id': 2, 'name': 'T2', 'key': 'K2'}]},
      ];
      final models = teamsNewFromJsonList(list);
      expect(models.length, 2);
      expect(models[0].teams[0].name, 'T1');
      expect(models[1].teams[0].key, 'K2');
    });
  });

  group('Teams', () {
    final json = {'id': 10, 'name': 'Alpha', 'key': 'alpha'};
    test('fromJson and toJson', () {
      final t = Teams.fromJson(json);
      expect(t.id, 10);
      expect(t.name, 'Alpha');
      expect(t.key, 'alpha');
      final map = t.toJson();
      expect(map['id'], 10);
      expect(map['name'], 'Alpha');
      expect(map['key'], 'alpha');
    });
  });
}
