import 'package:flutter_test/flutter_test.dart';
import 'package:visaamigo/features/ai_assistant/models/get_user_matches_model.dart';

void main() {
  group('GetUserMatchesModel', () {
    final jsonMap = {
      'status_code': 200,
      'message_key': 'success',
      'data': [
        {
          'id': '1',
          'match_city': '',
          'match_state': '',
          'match_country': '',
          'match_stadium': '',
          'event_name': 'Alice',
          'match_time': DateTime.now().toIso8601String(),
          'match_end_time': DateTime.now().toIso8601String(),
          'match_timezone': '',
          'match_teams': '',
          'match_name': '',
          'match_latitude': 0.0,
          'match_longitude': 0.0,
          'ticket_expired': false,
          'max_no_of_companions': 0,
          'ticket_ids': [],
          'companions_assigned': [],
        },
        {
          'id': '2',
          'match_city': '',
          'match_state': '',
          'match_country': '',
          'match_stadium': '',
          'event_name': 'Bob',
          'match_time': DateTime.now().toIso8601String(),
          'match_end_time': DateTime.now().toIso8601String(),
          'match_timezone': '',
          'match_teams': '',
          'match_name': '',
          'match_latitude': 0.0,
          'match_longitude': 0.0,
          'ticket_expired': false,
          'max_no_of_companions': 0,
          'ticket_ids': [],
          'companions_assigned': [],
        },
      ]
    };

    test('fromJson parses all fields', () {
      final model = GetUserMatchesModel.fromJson(jsonMap);
      expect(model.statusCode, 200);
      expect(model.messageKey, 'success');
      expect(model.data?.length, 2);
      expect(model.data?[0].id, '1');
      expect(model.data?[1].eventName, 'Bob');
    });

    test('toJson returns correct map', () {
      final model = GetUserMatchesModel.fromJson(jsonMap);
      final map = model.toJson();
      expect(map['status_code'], 200);
      expect(map['message_key'], 'success');
      expect(map['data'][0]['id'], '1');
      expect(map['data'][1]['event_name'], 'Bob');
    });

    test('copyWith returns new instance with updated fields', () {
      final model = GetUserMatchesModel.fromJson(jsonMap);
      final updated = model.copyWith(
        statusCode: 404,
        messageKey: 'fail',
        data: [model.data!.first],
      );
      expect(updated.statusCode, 404);
      expect(updated.messageKey, 'fail');
      expect(updated.data?.length, 1);
      expect(updated.data?[0].id, '1');
      expect(model.statusCode, 200);
    });

    test('default constructor and toJson with nulls', () {
      final model = GetUserMatchesModel();
      expect(model.statusCode, isNull);
      expect(model.messageKey, isNull);
      expect(model.data, isNull);
      final map = model.toJson();
      expect(map['status_code'], isNull);
      expect(map['message_key'], isNull);
      expect(map['data'], isNull);
    });

    test('copyWith with no arguments returns identical fields', () {
      final model = GetUserMatchesModel(statusCode: 1, messageKey: 'k', data: []);
      final copy = model.copyWith();
      expect(copy.statusCode, 1);
      expect(copy.messageKey, 'k');
      expect(copy.data, []);
    });

    test('fromJson with empty map', () {
      final model = GetUserMatchesModel.fromJson({});
      expect(model.statusCode, isNull);
      expect(model.messageKey, isNull);
      expect(model.data, isNull);
    });

    test('fromJson with null data', () {
      final model = GetUserMatchesModel.fromJson({'status_code': 100, 'message_key': 'msg', 'data': null});
      expect(model.statusCode, 100);
      expect(model.messageKey, 'msg');
      expect(model.data, isNull);
    });
  });
}
