import '../../../utils/utils.dart';
import 'ai_chat_items_model.dart';

class AiChatResponse {
  AiChatResponse({
    required this.type,
    required this.initialText,
    required this.finalText,
    required this.data,
    required this.topic,
    required this.sessionId,
    required this.questionId,
    required this.messageId,
    this.text,
  });

  final String? type;
  final String? initialText;
  final String? finalText;
  final List<Datum> data;
  final String? topic;
  String? sessionId;
  String? questionId;
  String? messageId;
  final String? text;

  factory AiChatResponse.fromJson(Map<String, dynamic> json) {
    return AiChatResponse(
      type: json["type"],
      initialText: Utils.convrtStringUtf(json["initial_text"].toString()),
      finalText: Utils.convrtStringUtf(json["final_text"].toString()),
      data: json["data"] == null
          ? []
          : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
      topic: json["topic"] ?? "",
      sessionId: json["session_id"] ?? "",
      messageId: json["message_id"] ?? "",
      questionId: json["question_id"] ?? "",
      text: Utils.convrtStringUtf(json["text"].toString()),
    );
  }

  Map<String, dynamic> toJson() => {
        "type": type,
        "initial_text": initialText,
        "final_text": finalText,
        "data": data.map((x) => x.toJson()).toList(),
        "topic": topic,
        "session_id": sessionId,
        "message_id": messageId,
        "text": text,
      };

  AiChatResponse copyWith({
    String? type,
    String? initialText,
    String? finalText,
    List<Datum>? data,
    String? topic,
    String? sessionId,
    String? messageId,
    String? text,
  }) {
    return AiChatResponse(
      type: type ?? this.type,
      initialText: initialText ?? this.initialText,
      finalText: finalText ?? this.finalText,
      data: data ?? this.data,
      topic: topic ?? this.topic,
      sessionId: sessionId ?? this.sessionId,
      questionId: sessionId ?? questionId,
      messageId: messageId ?? this.messageId,
      text: text ?? this.text,
    );
  }

  @override
  String toString() {
    return "$type, $initialText, $finalText, $data, $topic, $sessionId, $messageId, $questionId, $text";
  }
}

class Datum {
  final String source;
  final String tag;
  final AiChatItems items;

  Datum({
    required this.source,
    required this.tag,
    required this.items,
  });

  factory Datum.fromJson(Map<String, dynamic> json) {
    return Datum(
      source: json["source"] ?? "",
      tag: Utils.convrtStringUtf(json["tag"] ?? ""),
      items: json["items"] != null && json["items"] is Map
          ? AiChatItems.fromJson(json["items"])
          : AiChatItems.empty(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "source": source,
      "tag": tag,
      "items": items.toJson(),
    };
  }

  Datum copyWith({
    String? source,
    String? tag,
    AiChatItems? items,
  }) {
    return Datum(
      source: source ?? this.source,
      tag: tag ?? this.tag,
      items: items ?? this.items,
    );
  }

  @override
  String toString() {
    return "$source, $tag, $items,";
  }
}
