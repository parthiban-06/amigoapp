import 'package:visaamigo/utils/app_const.dart';

import '../../models/ai_chat_response.dart';
import '../../models/ai_get_preferences_questions_model.dart';

class Message {
  String id;
  String editId;
  final String text;
  final bool isUser;
  final DateTime timestamp;
  bool isTyping;
  bool isCopy;
  String displayText;
  bool isFinalText;
  AiChatResponse? aiChatResponse;
  final Questions? questions;
  final int state;
  final bool isFinalTextEmpty;
  final bool isInitialTextEmpty;
  final Map<String, Set<int>>? animatedPlaceIndexes;
  final bool showTextWithAnimation;

  Message({
    required this.id,
    required this.editId,
    required this.text,
    required this.isUser,
    required this.timestamp,
    required this.aiChatResponse,
    this.isTyping = false,
    this.isCopy = false,
    this.isFinalText = false,
    this.displayText = "",
    this.questions,
    this.state = 0,
    this.isFinalTextEmpty = false,
    this.isInitialTextEmpty = false,
    this.animatedPlaceIndexes,
    this.showTextWithAnimation = false,
  });

  factory Message.fromJson(Map<String, dynamic> json, bool isUser) {
    return Message(
      id: json['id'] ?? "",
      editId: json['editId'] ?? "",
      text: json['text'] ?? "",
      isUser: isUser,
      timestamp:
          json['timestamp'] != null && json['timestamp'].toString().isNotEmpty
              ? DateTime.tryParse(json['timestamp']) ?? DateTime.now()
              : DateTime.now(),
      isTyping: json['isTyping'] ?? false,
      isCopy: json['isCopy'] ?? false,
      isFinalText: json['isFinalText'] ?? false,
      displayText: json['displayText'] ?? "",
      aiChatResponse: json['aiChatResponse'] != null
          ? AiChatResponse.fromJson(json['aiChatResponse'])
          : null,
      questions: json['questions'] != null
          ? Questions.fromJson(json['questions'])
          : null,
      state: (json['feedback'] == null)
          ? 0
          : (json['feedback'] == AppConst.like)
              ? 1
              : 2,
      isFinalTextEmpty: json['isFinalTextEmpty'] ?? false,
      animatedPlaceIndexes: {},
      showTextWithAnimation: json['showTextWithAnimation'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'editId': editId,
      'text': text,
      'isUser': isUser,
      'timestamp': timestamp.toIso8601String(),
      'isTyping': isTyping,
      'isCopy': isCopy,
      'isFinalText': isFinalText,
      'displayText': displayText,
      'aiChatResponse': aiChatResponse?.toJson(),
      'questions': questions?.toJson(),
      'state': state,
      'isFinalTextEmpty': isFinalTextEmpty,
      'animatedPlaceIndexes': animatedPlaceIndexes,
      'showTextWithAnimation': showTextWithAnimation,
    };
  }

  Message copyWith({
    String? id,
    String? editId,
    String? text,
    bool? isUser,
    DateTime? timestamp,
    bool? isTyping,
    bool? isCopy,
    bool? isFinalText,
    String? displayText,
    AiChatResponse? response,
    Questions? questions,
    int? state,
    bool? isFinalTextEmpty,
    Map<String, Set<int>>? animatedPlaceIndexes,
    bool? showTextWithAnimation,
  }) {
    return Message(
      id: id ?? this.id,
      editId: editId ?? this.editId,
      text: text ?? this.text,
      isUser: isUser ?? this.isUser,
      timestamp: timestamp ?? this.timestamp,
      isTyping: isTyping ?? this.isTyping,
      isCopy: isCopy ?? this.isCopy,
      isFinalText: isFinalText ?? this.isFinalText,
      displayText: displayText ?? this.displayText,
      aiChatResponse: response ?? this.aiChatResponse,
      questions: questions ?? this.questions,
      state: state ?? this.state,
      isFinalTextEmpty: isFinalTextEmpty ?? this.isFinalTextEmpty,
      animatedPlaceIndexes: animatedPlaceIndexes ?? this.animatedPlaceIndexes,
      showTextWithAnimation:
          showTextWithAnimation ?? this.showTextWithAnimation,
    );
  }
}
