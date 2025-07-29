import 'package:visaamigo/utils/app_extensions.dart';

class AiAssistQuestion {
  AiAssistQuestion({
    required this.query,
    required this.city,
    required this.sessionId,
    this.questionId = "",
    this.messageId = "",
  });

  final String? query;
  final String? city;
  final String? sessionId;
  String? questionId;
  String? messageId;

  factory AiAssistQuestion.fromJson(Map<String, dynamic> json) {
    return AiAssistQuestion(
      query: json["query"],
      city: json["city"],
      sessionId: json["session_id"],
      questionId: json["question_id"],
      messageId: json["message_id"],
    );
  }

  Map<String, dynamic> toJson() => {
        "query": query,
        "city": city,
        "session_id": sessionId,
        "question_id": questionId,
        "message_id": messageId,
      };

  Map<String, dynamic> toApiJson() {
    final map = <String, dynamic>{};
    map['query'] = query;
    map['city'] = city;

    if (!sessionId.isNullOrEmpty) {
      map['session_id'] = sessionId;
    }

    if (!questionId.isNullOrEmpty) {
      map['question_id'] = questionId;
    }

    if (!messageId.isNullOrEmpty) {
      map['message_id'] = messageId;
    }
    return map;
  }

  @override
  String toString() {
    return "$query, $city, $sessionId, $messageId ";
  }
}
