import 'ai_chat_model.dart';
import 'ai_chat_response.dart';

class Message {
  final String role;
  final String message;
  final String sessionId;
  final DateTime timestamp;
  final InitialQuestions? initialQuestions;
  final FollowUpQuestions? followUpQuestions;
  final DynamicResponse? dynamicResponse;
  final AiChatResponse? aiCharResponse;

  Message({
    required this.role,
    required this.message,
    required this.sessionId,
    required this.initialQuestions,
    required this.followUpQuestions,
    required this.dynamicResponse,
    required this.aiCharResponse,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();

  // Convert Message to a JSON-like map
  Map<String, dynamic> toJson() {
    return {
      'role': role,
      'message': message,
      'timestamp': timestamp,
      'session_id': sessionId,
      'initial_questions': initialQuestions,
      'follow_up_questions': followUpQuestions,
      'dynamic_response': dynamicResponse,
      'ai_chat_response': aiCharResponse,
    };
  }

  // Create a Message object from a JSON-like map
  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      role: json['role'],
      message: json['message'],
      timestamp: json['timestamp'],
      sessionId: json['session_id'],
      initialQuestions: json['initial_questions'],
      followUpQuestions: json['follow_up_questions'],
      aiCharResponse: json['ai_chat_response'],
      dynamicResponse: json['dynamic_response'] != null
          ? DynamicResponse.fromJson(json['dynamic_response'])
          : null,
    );
  }
}
