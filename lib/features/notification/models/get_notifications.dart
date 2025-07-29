import 'package:visaamigo/utils/utils.dart';

class NotificationResponse {
  final int statusCode;
  final String messageKey;
  final List<NotificationData> data;

  NotificationResponse({
    required this.statusCode,
    required this.messageKey,
    required this.data,
  });

  factory NotificationResponse.fromJson(Map<String, dynamic> json) {
    return NotificationResponse(
      statusCode: json['status_code'],
      messageKey: json['message_key'],
      data: List<NotificationData>.from(
        json['data'].map((x) => NotificationData.fromJson(x)),
      ),
    );
  }

  Map<String, dynamic> toJson() => {
        'status_code': statusCode,
        'message_key': messageKey,
        'data': data.map((x) => x.toJson()).toList(),
      };
}

class NotificationData {
  final String? title;
  final String? body;
  final bool? read;
  final String? type;
  final String? channel;
  final Payload? payload;
  final DateTime? receivedAt;
  final String? id;

  NotificationData({
    required this.title,
    required this.body,
    required this.read,
    required this.type,
    required this.channel,
    required this.payload,
    required this.receivedAt,
    required this.id,
  });

  factory NotificationData.fromJson(Map<String, dynamic> json) {
    return NotificationData(
      title: Utils.convrtStringUtf(json['title'] ?? ""),
      body: Utils.convrtStringUtf(json['body'] ?? ""),
      read: json.containsKey("read") ? (json['read'] == 'true') : true,
      type: json['type'] ?? "",
      channel: json['channel'] ?? "",
      payload: json.containsKey("payload")
          ? Payload.fromJson(json['payload'])
          : null,
      receivedAt: json.containsKey("received_at")
          ? DateTime.parse(json['received_at'])
          : DateTime.now(),
      id: json['id'] ?? "",
    );
  }

  Map<String, dynamic> toJson() => {
        'title': title,
        'body': body,
        'read': read.toString(),
        'type': type,
        'channel': channel,
        'payload': payload?.toJson(),
        'received_at': receivedAt?.toIso8601String(),
        'id': id,
      };

  NotificationData copyWith({
    String? title,
    String? body,
    bool? read,
    String? type,
    String? channel,
    Payload? payload,
    DateTime? receivedAt,
    String? id,
  }) {
    return NotificationData(
      title: title ?? this.title,
      body: body ?? this.body,
      read: read ?? this.read,
      type: type ?? this.type,
      channel: channel ?? this.channel,
      payload: payload ?? this.payload,
      receivedAt: receivedAt ?? this.receivedAt,
      id: id ?? this.id,
    );
  }
}

class Payload {
  final String link;

  Payload({required this.link});

  factory Payload.fromJson(Map<String, dynamic> json) {
    return Payload(
      link: json['link'] ?? "",
    );
  }

  Map<String, dynamic> toJson() => {
        'link': link,
      };
}
