import 'package:flutter_test/flutter_test.dart';
import 'package:visaamigo/features/ai_assistant/models/ai_chat_history.dart';

void main() {
  group('AiChatHistory', () {
    test('fromJson parses all fields correctly', () {
      final json = {
        'session_id': 'abc123',
        'topic': 'Test Topic',
        'created_at': '2025-06-27T12:34:56.000Z',
      };
      final history = AiChatHistory.fromJson(json);
      expect(history.sessionid, 'abc123');
      expect(history.topic, 'Test Topic');
      expect(history.createdat, DateTime.parse('2025-06-27T12:34:56.000Z'));
    });

    test('fromJson handles missing fields', () {
      final json = <String, dynamic>{};
      final history = AiChatHistory.fromJson(json);
      expect(history.sessionid, isNull);
      expect(history.topic, anyOf(isNull, ''));
      expect(history.createdat, isNull);
    });

    test('toJson returns correct map', () {
      final date = DateTime.parse('2025-06-27T12:34:56.000Z');
      final history = AiChatHistory(
        sessionid: 'id1',
        topic: 'topic1',
        createdat: date,
      );
      final map = history.toJson();
      expect(map['session_id'], 'id1');
      expect(map['topic'], 'topic1');
      expect(map['created_at'], date);
    });

    test('fromDataJson returns list of AiChatHistory', () {
      final json = {
        'data': [
          {
            'session_id': 'id1',
            'topic': 'topic1',
            'created_at': '2025-06-27T12:34:56.000Z',
          },
          {
            'session_id': 'id2',
            'topic': 'topic2',
            'created_at': '2025-06-27T12:35:00.000Z',
          },
        ]
      };
      final list = AiChatHistory.fromDataJson(json);
      expect(list.length, 2);
      expect(list[0].sessionid, 'id1');
      expect(list[1].sessionid, 'id2');
    });

    test('fromDataJson returns empty list if data is null', () {
      final json = <String, dynamic>{};
      final list = AiChatHistory.fromDataJson(json);
      expect(list, isEmpty);
    });

    test('equality and hashCode', () {
      final date = DateTime.parse('2025-06-27T12:34:56.000Z');
      final h1 = AiChatHistory(sessionid: 'id', topic: 't', createdat: date);
      final h2 = AiChatHistory(sessionid: 'id', topic: 't', createdat: date);
      expect(h1, equals(h2));
      expect(h1.hashCode, h2.hashCode);
    });

    test('toString returns string representation', () {
      final date = DateTime.parse('2025-06-27T12:34:56.000Z');
      final h = AiChatHistory(sessionid: 'id', topic: 't', createdat: date);
      final str = h.toString();
      expect(str, contains('id'));
      expect(str, contains('t'));
      expect(str, contains('2025-06-27'));
    });
  });
}
