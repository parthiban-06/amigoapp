import 'package:visaamigo/utils/utils.dart';

import 'ai_chat_response.dart';

class AiThreadListModel {
  int? totalPages;
  int? pageNo;
  List<MessageItem>? messages;

  AiThreadListModel({this.totalPages, this.pageNo, this.messages});

  AiThreadListModel.fromJson(Map<String, dynamic> json) {
    Utils.logPrint("AiThreadListModel $json");
    totalPages = json['total_pages'];
    pageNo = json['page_no'];
    if (json['messages'] != null) {
      messages = <MessageItem>[];
      json['messages'].forEach((v) {
        messages!.add(MessageItem.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['total_pages'] = totalPages;
    data['page_no'] = pageNo;
    if (messages != null) {
      data['messages'] = messages!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class MessageItem {
  String? messageId;
  String? questionId;
  String? sender;
  String? feedback;
  AiChatResponse? content;
  String? timestamp;

  MessageItem(
      {this.messageId,
      this.sender,
      this.content,
      this.feedback,
      this.timestamp,
      this.questionId});

  factory MessageItem.fromJson(Map<String, dynamic> json) {
    Utils.logPrint("MessageItem $json");
    return MessageItem(
      messageId: json['message_id'],
      questionId: json['question_id'],
      sender: json['sender'],
      feedback: json['feedback'],
      content: json['content'] != null
          ? AiChatResponse.fromJson(json['content'])
          : null,
      timestamp: json['timestamp'],
    );
  }

  static List<MessageItem> listFromJson(List<dynamic> jsonList) {
    return jsonList.map((e) => MessageItem.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['message_id'] = messageId;
    data['sender'] = sender;
    data['feedback'] = feedback;
    data['question_id'] = questionId;
    if (content != null) {
      data['content'] = content!.toJson();
    }
    data['timestamp'] = timestamp;
    return data;
  }
}
