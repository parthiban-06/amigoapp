import 'package:flutter_test/flutter_test.dart';
import 'package:visaamigo/features/ai_assistant/models/ai_chat_model.dart';
import 'package:visaamigo/features/ai_assistant/models/ai_chat_response.dart';
import 'package:visaamigo/features/ai_assistant/models/ai_messages_model.dart';

void main() {
  group('Message', () {
    test('constructor assigns all fields', () {
      final now = DateTime.parse('2025-06-27T12:00:00.000Z');
      final msg = Message(
        role: 'user',
        message: 'Hello',
        sessionId: 's1',
        initialQuestions: InitialQuestions(),
        followUpQuestions: FollowUpQuestions(),
        dynamicResponse: DynamicResponse(),
        aiCharResponse: AiChatResponse(
          type: 'testType',
          initialText: 'testInitial',
          finalText: 'testFinal',
          data: [],
          topic: 'testTopic',
          sessionId: 'testSession',
          questionId: 'testQuestion',
          messageId: 'testMessage',
        ),
        timestamp: now,
      );
      expect(msg.role, 'user');
      expect(msg.message, 'Hello');
      expect(msg.sessionId, 's1');
      expect(msg.initialQuestions, isA<InitialQuestions>());
      expect(msg.followUpQuestions, isA<FollowUpQuestions>());
      expect(msg.dynamicResponse, isA<DynamicResponse>());
      expect(msg.aiCharResponse, isA<AiChatResponse>());
      expect(msg.timestamp, now);
    });

    test('toJson returns correct map', () {
      final now = DateTime.parse('2025-06-27T12:00:00.000Z');
      final msg = Message(
        role: 'user',
        message: 'Hi',
        sessionId: 's2',
        initialQuestions: InitialQuestions(),
        followUpQuestions: FollowUpQuestions(),
        dynamicResponse: DynamicResponse(),
        aiCharResponse: AiChatResponse(
          type: 'testType',
          initialText: 'testInitial',
          finalText: 'testFinal',
          data: [],
          topic: 'testTopic',
          sessionId: 'testSession',
          questionId: 'testQuestion',
          messageId: 'testMessage',
        ),
        timestamp: now,
      );
      final map = msg.toJson();
      expect(map['role'], 'user');
      expect(map['message'], 'Hi');
      expect(map['timestamp'], now);
      expect(map['session_id'], 's2');
      expect(map['initial_questions'], isA<InitialQuestions>());
      expect(map['follow_up_questions'], isA<FollowUpQuestions>());
      expect(map['dynamic_response'], isA<DynamicResponse>());
      expect(map['ai_chat_response'], isA<AiChatResponse>());
    });

    test('fromJson parses all fields', () {
      final now = DateTime.parse('2025-06-27T12:00:00.000Z');
      final json = {
        'role': 'assistant',
        'message': 'Hey',
        'timestamp': now,
        'session_id': 's3',
        'initial_questions': InitialQuestions(),
        'follow_up_questions': FollowUpQuestions(),
        'dynamic_response': DynamicResponse().toJson(),
        'ai_chat_response': AiChatResponse(
          type: 'testType',
          initialText: 'testInitial',
          finalText: 'testFinal',
          data: [],
          topic: 'testTopic',
          sessionId: 'testSession',
          questionId: 'testQuestion',
          messageId: 'testMessage',
        ),
      };
      final msg = Message.fromJson(json);
      expect(msg.role, 'assistant');
      expect(msg.message, 'Hey');
      expect(msg.timestamp, now);
      expect(msg.sessionId, 's3');
      expect(msg.initialQuestions, isA<InitialQuestions>());
      expect(msg.followUpQuestions, isA<FollowUpQuestions>());
      expect(msg.dynamicResponse, isA<DynamicResponse>());
      expect(msg.aiCharResponse, isA<AiChatResponse>());
    });
  });
}
