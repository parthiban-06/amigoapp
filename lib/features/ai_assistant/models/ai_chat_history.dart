import '../../../utils/utils.dart';

class AiChatHistory {
  String? sessionid;
  String? topic;
  DateTime? createdat;

  AiChatHistory({this.sessionid, this.topic, this.createdat});

  AiChatHistory.fromJson(Map<String, dynamic> json) {
    sessionid = json['session_id'];
    topic = Utils.convrtStringUtf(json['topic'] ?? "");
    createdat = DateTime.tryParse(json['created_at'] ?? '');
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['session_id'] = sessionid;
    data['topic'] = topic;
    data['created_at'] = createdat;
    return data;
  }

  static List<AiChatHistory> fromDataJson(Map<String, dynamic> json) {
    if (json['data'] == null) return [];
    return (json['data'] as List)
        .map((e) => AiChatHistory.fromJson(e))
        .toList();
  }
}
