import 'package:flutter_test/flutter_test.dart';
import 'package:visaamigo/features/ai_assistant/models/ai_chat_response.dart';

// Dummy AiChatItems for isolated Datum tests
class AiChatItems {
  final String location;
  AiChatItems({required this.location});
  factory AiChatItems.fromJson(Map<String, dynamic> json) => AiChatItems(location: json['location'] ?? '');
  Map<String, dynamic> toJson() => {'location': location};
  static AiChatItems empty() => AiChatItems(location: '');
  @override
  String toString() => location.isNotEmpty ? location : '';
}

void main() {
  group('AiChatResponse', () {
    final json = {
      'type': 'response',
      'initial_text': 'Hello',
      'final_text': 'Goodbye',
      'data': [
        {
          'source': 'api',
          'tag': 'tag1',
          'items': {'location': 'Paris'}
        }
      ],
      'topic': 'Travel',
      'session_id': 's1',
      'message_id': 'm1',
      'question_id': 'q1',
      'text': 'Some text',
    };

    test('fromJson parses all fields', () {
      final resp = AiChatResponse.fromJson(json);
      expect(resp.type, 'response');
      expect(resp.initialText, 'Hello');
      expect(resp.finalText, 'Goodbye');
      expect(resp.data.length, 1);
      expect(resp.data.first.source, 'api');
      expect(resp.data.first.tag, 'tag1');
      expect(resp.data.first.items.location, 'Paris');
      expect(resp.topic, 'Travel');
      expect(resp.sessionId, 's1');
      expect(resp.messageId, 'm1');
      expect(resp.questionId, 'q1');
      expect(resp.text, 'Some text');
    });

    test('toJson returns correct map', () {
      final resp = AiChatResponse.fromJson(json);
      final map = resp.toJson();
      expect(map['type'], 'response');
      expect(map['initial_text'], 'Hello');
      expect(map['final_text'], 'Goodbye');
      expect(map['data'][0]['source'], 'api');
      expect(map['data'][0]['items']['location'], 'Paris');
      expect(map['topic'], 'Travel');
      expect(map['session_id'], 's1');
      expect(map['message_id'], 'm1');
      expect(map['text'], 'Some text');
    });

    test('copyWith returns new instance with updated fields', () {
      final resp = AiChatResponse.fromJson(json);
      final updated = resp.copyWith(type: 'newType', text: 'newText');
      expect(updated.type, 'newType');
      expect(updated.text, 'newText');
      expect(updated.initialText, resp.initialText);
    });

    test('copyWith with nulls and empty data', () {
      final resp = AiChatResponse.fromJson(json);
      final updated = resp.copyWith(type: null, data: []);
      expect(updated.type, resp.type);
      expect(updated.data, isEmpty);
    });

    test('handles null/empty/edge cases', () {
      final emptyJson = <String, dynamic>{};
      final resp = AiChatResponse.fromJson(emptyJson);
      expect(resp.type, isNull);
      expect(resp.initialText, isNotNull); // convrtStringUtf('null') returns 'null'
      expect(resp.finalText, isNotNull);
      expect(resp.data, isEmpty);
      expect(resp.topic, '');
      expect(resp.sessionId, '');
      expect(resp.messageId, '');
      expect(resp.questionId, '');
      expect(resp.text, isNotNull);
      final map = resp.toJson();
      expect(map['type'], isNull);
      expect(map['data'], isEmpty);
    });

    test('toString returns string representation', () {
      final resp = AiChatResponse.fromJson(json);
      final str = resp.toString();
      expect(str, contains('response'));
      expect(str, contains('Hello'));
      expect(str, contains('Goodbye'));
      expect(str, contains('Paris'));
    });
  });

  group('Datum', () {
    test('handles null/empty/edge cases', () {
      final emptyJson = <String, dynamic>{};
      final d = Datum.fromJson(emptyJson);
      expect(d.source, '');
      expect(d.tag, '');
      expect(d.items.location, '');
      final map = d.toJson();
      expect(map['source'], '');
      expect(map['tag'], '');
      expect(map['items']['location'], '');
    });

    // datumJson is already defined below, so no need to redeclare it here.
    test('copyWith with nulls', () {
      final datumJsonLocal = {
        'source': 'api',
        'tag': 'tag2',
        'items': {'location': 'London'}
      };
      final d = Datum.fromJson(datumJsonLocal);
      final updated = d.copyWith(source: null, tag: null, items: null);
      expect(updated.source, d.source);
      expect(updated.tag, d.tag);
      expect(updated.items.location, d.items.location);
    });
    final datumJson = {
      'source': 'api',
      'tag': 'tag2',
      'items': {'location': 'London'}
    };
    test('fromJson and toJson', () {
      final d = Datum.fromJson(datumJson);
      expect(d.source, 'api');
      expect(d.tag, 'tag2');
      expect(d.items.location, 'London');
      final map = d.toJson();
      expect(map['source'], 'api');
      expect(map['items']['location'], 'London');
    });
    test('copyWith returns new instance with updated fields', () {
      final d = Datum.fromJson(datumJson);
      final updated = d.copyWith(tag: 'newTag');
      expect(updated.tag, 'newTag');
      expect(updated.source, 'api');
    });
    test('toString returns string representation', () {
      final d = Datum.fromJson(datumJson);
      final str = d.toString();
      expect(str, contains('api'));
      expect(str, contains('London'));
    });
    test('handles null/empty/edge cases', () {
      final emptyJson = <String, dynamic>{};
      final d = Datum.fromJson(emptyJson);
      expect(d.source, '');
      expect(d.tag, '');
      expect(d.items.location, '');
      final map = d.toJson();
      expect(map['source'], '');
      expect(map['tag'], '');
      expect(map['items']['location'], '');
    });
    test('copyWith with nulls', () {
      final d = Datum.fromJson(datumJson);
      final updated = d.copyWith(source: null, tag: null, items: null);
      expect(updated.source, d.source);
      expect(updated.tag, d.tag);
      expect(updated.items.location, d.items.location);
    });
  });
}
