class SendOtpResponse {
  final int statusCode;
  final String messageKey;

  SendOtpResponse({
    required this.statusCode,
    required this.messageKey,
  });

  factory SendOtpResponse.fromJson(Map<String, dynamic> json) {
    return SendOtpResponse(
      statusCode: json['status_code'],
      messageKey: json['message_key'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status_code': statusCode,
      'message_key': messageKey,
    };
  }
}
