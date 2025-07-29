import 'package:flutter_test/flutter_test.dart';
import 'package:visaamigo/features/ai_assistant/models/ai_assist_question.dart';

void main() {
  group('AiAssistQuestion', () {
    test('fromJson and toJson', () {
      final json = {
        'query': 'What is the weather?',
        'city': 'London',
        'session_id': 'abc123',
        'question_id': 'q1',
        'message_id': 'm1',
      };
      final question = AiAssistQuestion.fromJson(json);
      expect(question.query, 'What is the weather?');
      expect(question.city, 'London');
      expect(question.sessionId, 'abc123');
      expect(question.questionId, 'q1');
      expect(question.messageId, 'm1');
      expect(question.toJson(), json);
    });

    test('toApiJson omits null or empty fields', () {
      final question = AiAssistQuestion(
        query: 'Q',
        city: 'C',
        sessionId: null,
        questionId: '',
        messageId: null,
      );
      final apiJson = question.toApiJson();
      expect(apiJson['query'], 'Q');
      expect(apiJson['city'], 'C');
      expect(apiJson.containsKey('session_id'), isFalse);
      expect(apiJson.containsKey('question_id'), isFalse);
      expect(apiJson.containsKey('message_id'), isFalse);
    });

    test('toString returns expected format', () {
      final question = AiAssistQuestion(
        query: 'Q',
        city: 'C',
        sessionId: 'S',
        messageId: 'M',
      );
      expect(question.toString(), 'Q, C, S, M ');
    });

    test('equality and hashCode', () {
      final q1 = AiAssistQuestion(
        query: 'Q',
        city: 'C',
        sessionId: 'S',
        questionId: 'QID',
        messageId: 'MID',
      );
      final q2 = AiAssistQuestion(
        query: 'Q',
        city: 'C',
        sessionId: 'S',
        questionId: 'QID',
        messageId: 'MID',
      );
      expect(q1, equals(q2));
      expect(q1.hashCode, q2.hashCode);
    });

    test('copyWith emulation returns new instance with updated fields', () {
      final q1 = AiAssistQuestion(
        query: 'Q',
        city: 'C',
        sessionId: 'S',
        questionId: 'QID',
        messageId: 'MID',
      );
      final q2 = AiAssistQuestion(
        query: 'Q2',
        city: 'C2',
        sessionId: 'S2',
        questionId: 'QID2',
        messageId: 'MID2',
      );
      expect(q1 == q2, isFalse);
      expect(q2.query, 'Q2');
      expect(q2.city, 'C2');
      expect(q2.sessionId, 'S2');
      expect(q2.questionId, 'QID2');
      expect(q2.messageId, 'MID2');
    });
  });
}
