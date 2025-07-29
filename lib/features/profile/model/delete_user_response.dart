class DeleteUserResponse {
  final int statusCode;
  final String messageKey;
  final String detail;
  final Map<String, dynamic> data;

  DeleteUserResponse({
    required this.statusCode,
    required this.messageKey,
    required this.detail,
    required this.data,
  });

  factory DeleteUserResponse.fromJson(Map<String, dynamic> json) {
    return DeleteUserResponse(
      statusCode: json['status_code'] ?? 0,
      messageKey: json['message_key'] ?? '',
      detail: json['detail'] ?? '',
      data: json['data'] ?? {},
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status_code': statusCode,
      'message_key': messageKey,
      'detail': detail,
      'data': data,
    };
  }
}
