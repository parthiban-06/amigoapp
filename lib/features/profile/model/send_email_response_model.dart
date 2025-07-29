import 'dart:convert';

class SendEmailResponse {
  final int statusCode;
  final String messageKey;
  final SendEmailData data;

  const SendEmailResponse({
    required this.statusCode,
    required this.messageKey,
    required this.data,
  });

  /// Factory constructor to create an instance from a `Map<String, dynamic>`
  factory SendEmailResponse.fromJson(Map<String, dynamic> json) {
    return SendEmailResponse(
      statusCode: json['status_code'] as int,
      messageKey: json['message_key'] as String,
      data: SendEmailData.fromJson(json['data'] as Map<String, dynamic>),
    );
  }

  /// Converts the instance back to JSON
  Map<String, dynamic> toJson() => {
        'status_code': statusCode,
        'message_key': messageKey,
        'data': data.toJson(),
      };

  /// Handy helper if you receive the JSON as a raw string
  factory SendEmailResponse.fromRawJson(String source) =>
      SendEmailResponse.fromJson(jsonDecode(source));

  String toRawJson() => jsonEncode(toJson());
}

class SendEmailData {
  final String to;
  final String template;

  const SendEmailData({
    required this.to,
    required this.template,
  });

  factory SendEmailData.fromJson(Map<String, dynamic> json) {
    return SendEmailData(
      to: json['to'] as String,
      template: json['template'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
        'to': to,
        'template': template,
      };
}
