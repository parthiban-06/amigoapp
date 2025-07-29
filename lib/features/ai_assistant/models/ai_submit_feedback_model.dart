import 'package:visaamigo/utils/app_extensions.dart';

class AiSubmitFeedbackModel {
  AiSubmitFeedbackModel({
    required this.sessionId,
    required this.messageId,
    required this.feedback,
  });

  final String? sessionId;
  final String? messageId;
  final String? feedback;

  factory AiSubmitFeedbackModel.fromJson(Map<String, dynamic> json) {
    return AiSubmitFeedbackModel(
      feedback: json["feedback"],
      messageId: json["message_id"],
      sessionId: json["session_id"],
    );
  }

  Map<String, dynamic> toJson() => {
        "feedback": feedback,
        "message_id": messageId,
        "session_id": sessionId,
      };

  Map<String, dynamic> toApiJson() {
    final map = <String, dynamic>{};
    map['feedback'] = feedback;
    map['message_id'] = messageId;

    if (!sessionId.isNullOrEmpty) {
      map['session_id'] = sessionId;
    }

    return map;
  }

  @override
  String toString() {
    return "$feedback, $messageId, $sessionId, ";
  }
}
