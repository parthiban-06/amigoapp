import 'package:flutter_test/flutter_test.dart';
import 'dart:convert';
import 'package:visaamigo/features/ai_assistant/models/ai_recent_queries_model.dart';

void main() {
  group('AiRecentQueriesModel', () {
    final jsonMap = {'query': 'Where is Paris?'};

    test('fromJson parses query', () {
      final model = AiRecentQueriesModel.fromJson(jsonMap);
      expect(model.query, 'Where is Paris?');
    });

    test('toJson returns correct map', () {
      final model = AiRecentQueriesModel.fromJson(jsonMap);
      final map = model.toJson();
      expect(map['query'], 'Where is Paris?');
    });

    test('suggestionModelFromJson parses from string', () {
      final jsonString = json.encode(jsonMap);
      final model = suggestionModelFromJson(jsonString);
      expect(model.query, 'Where is Paris?');
    });

    test('recentQueriesModelToJson encodes to string', () {
      final model = AiRecentQueriesModel.fromJson(jsonMap);
      final jsonString = recentQueriesModelToJson(model);
      final decoded = json.decode(jsonString);
      expect(decoded['query'], 'Where is Paris?');
    });

    test('recentQueriesFromJsonList parses list', () {
      final list = [
        {'query': 'Q1'},
        {'query': 'Q2'},
      ];
      final models = recentQueriesFromJsonList(list);
      expect(models.length, 2);
      expect(models[0].query, 'Q1');
      expect(models[1].query, 'Q2');
    });

    test('copyWith returns new instance with updated query', () {
      final model = AiRecentQueriesModel.fromJson({'query': 'Old'});
      final updated = model.copyWith(query: 'New');
      expect(updated.query, 'New');
      expect(model.query, 'Old');
    });

    test('query getter returns empty string if null', () {
      final model = AiRecentQueriesModel();
      expect(model.query, '');
    });

    test('default constructor toJson returns map with null query', () {
      final model = AiRecentQueriesModel();
      final map = model.toJson();
      expect(map['query'], isNull);
    });

    test('fromJson with null query', () {
      final model = AiRecentQueriesModel.fromJson({'query': null});
      expect(model.query, '');
      final map = model.toJson();
      expect(map['query'], isNull);
    });
  });
}
