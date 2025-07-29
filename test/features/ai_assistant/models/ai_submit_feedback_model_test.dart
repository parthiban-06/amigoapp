import 'package:flutter_test/flutter_test.dart';
import 'package:visaamigo/features/ai_assistant/models/ai_submit_feedback_model.dart';

extension StringNullOrEmpty on String? {
  bool get isNullOrEmpty => this == null || this!.isEmpty;
}

void main() {
  group('AiSubmitFeedbackModel', () {
    final jsonMap = {
      'feedback': 'Great!',
      'message_id': 'm1',
      'session_id': 's1',
    };

    test('fromJson parses all fields', () {
      final model = AiSubmitFeedbackModel.fromJson(jsonMap);
      expect(model.feedback, 'Great!');
      expect(model.messageId, 'm1');
      expect(model.sessionId, 's1');
    });

    test('toJson returns correct map', () {
      final model = AiSubmitFeedbackModel.fromJson(jsonMap);
      final map = model.toJson();
      expect(map['feedback'], 'Great!');
      expect(map['message_id'], 'm1');
      expect(map['session_id'], 's1');
    });

    test('toApiJson omits session_id if null or empty', () {
      final model = AiSubmitFeedbackModel(
        feedback: 'Nice',
        messageId: 'mid',
        sessionId: '',
      );
      final map = model.toApiJson();
      expect(map['feedback'], 'Nice');
      expect(map['message_id'], 'mid');
      expect(map.containsKey('session_id'), false);
    });

    test('toApiJson includes session_id if not empty', () {
      final model = AiSubmitFeedbackModel(
        feedback: 'Nice',
        messageId: 'mid',
        sessionId: 'sid',
      );
      final map = model.toApiJson();
      expect(map['session_id'], 'sid');
    });

    test('toString returns string representation', () {
      final model = AiSubmitFeedbackModel.fromJson(jsonMap);
      final str = model.toString();
      expect(str, contains('Great!'));
      expect(str, contains('m1'));
      expect(str, contains('s1'));
    });
  });
}
