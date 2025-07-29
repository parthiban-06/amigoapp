import 'package:flutter_test/flutter_test.dart';
import 'package:visaamigo/features/ai_assistant/models/ai_delete_response.dart';

void main() {
  group('SessionDeleteResponse', () {
    test('fromJson parses list of strings', () {
      final json = ['a', 'b', 'c'];
      final resp = SessionDeleteResponse.fromJson(json);
      expect(resp.data, ['a', 'b', 'c']);
    });

    test('fromJson returns empty list if not a list', () {
      final json = {'not': 'a list'};
      final resp = SessionDeleteResponse.fromJson(json);
      expect(resp.data, isEmpty);
    });

    test('fromDataJson parses list of SessionDeleteResponse', () {
      final json = {
        'data': [
          ['x', 'y'],
          ['z']
        ]
      };
      final list = SessionDeleteResponse.fromDataJson(json);
      expect(list.length, 2);
      expect(list[0].data, ['x', 'y']);
      expect(list[1].data, ['z']);
    });

    test('fromDataJson returns empty list if data is null', () {
      final json = <String, dynamic>{};
      final list = SessionDeleteResponse.fromDataJson(json);
      expect(list, isEmpty);
    });
  });
}
