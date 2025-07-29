import 'package:flutter_test/flutter_test.dart';
import 'package:visaamigo/features/ai_assistant/models/ai_thread_list_model.dart';

// Dummy AiChatResponse for isolated MessageItem tests
class AiChatResponse {
  final String? type;
  AiChatResponse({this.type});
  factory AiChatResponse.fromJson(Map<String, dynamic> json) => AiChatResponse(type: json['type']);
  Map<String, dynamic> toJson() => {'type': type};
}

void main() {
  group('AiThreadListModel', () {
    final jsonMap = {
      'total_pages': 2,
      'page_no': 1,
      'messages': [
        {
          'message_id': 'm1',
          'question_id': 'q1',
          'sender': 'user',
          'feedback': 'good',
          'content': {'type': 'response'},
          'timestamp': '2025-06-27T12:00:00Z',
        },
        {
          'message_id': 'm2',
          'question_id': 'q2',
          'sender': 'bot',
          'feedback': 'ok',
          'content': {'type': 'reply'},
          'timestamp': '2025-06-27T12:01:00Z',
        },
      ]
    };

    test('fromJson parses all fields', () {
      final model = AiThreadListModel.fromJson(jsonMap);
      expect(model.totalPages, 2);
      expect(model.pageNo, 1);
      expect(model.messages?.length, 2);
      expect(model.messages?[0].messageId, 'm1');
      expect(model.messages?[1].sender, 'bot');
      expect(model.messages?[0].content?.type, 'response');
    });

    test('toJson returns correct map', () {
      final model = AiThreadListModel.fromJson(jsonMap);
      final map = model.toJson();
      expect(map['total_pages'], 2);
      expect(map['page_no'], 1);
      expect(map['messages'][0]['message_id'], 'm1');
      expect(map['messages'][1]['content']['type'], 'reply');
    });
  });

  group('MessageItem', () {
    final json = {
      'message_id': 'mid',
      'question_id': 'qid',
      'sender': 's',
      'feedback': 'f',
      'content': {'type': 't'},
      'timestamp': '2025-06-27T13:00:00Z',
    };
    test('fromJson and toJson', () {
      final item = MessageItem.fromJson(json);
      expect(item.messageId, 'mid');
      expect(item.questionId, 'qid');
      expect(item.sender, 's');
      expect(item.feedback, 'f');
      expect(item.content?.type, 't');
      expect(item.timestamp, '2025-06-27T13:00:00Z');
      final map = item.toJson();
      expect(map['message_id'], 'mid');
      expect(map['content']['type'], 't');
    });
    test('listFromJson parses list', () {
      final list = [json, json];
      final items = MessageItem.listFromJson(list);
      expect(items.length, 2);
      expect(items[0].messageId, 'mid');
    });
  });
}
