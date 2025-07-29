class VersionResponse {
  final int statusCode;
  final String messageKey;
  final VersionData data;

  VersionResponse({
    required this.statusCode,
    required this.messageKey,
    required this.data,
  });

  factory VersionResponse.fromJson(Map<String, dynamic> json) {
    return VersionResponse(
      statusCode: json['status_code'],
      messageKey: json['message_key'],
      data: VersionData.fromJson(json['data']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status_code': statusCode,
      'message_key': messageKey,
      'data': data.toJson(),
    };
  }
}

class VersionData {
  final String currentVersion;
  final bool cancel;

  VersionData({
    required this.currentVersion,
    required this.cancel,
  });

  factory VersionData.fromJson(Map<String, dynamic> json) {
    return VersionData(
      currentVersion: json['current_version'],
      cancel: json['cancel'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'current_version': currentVersion,
      'cancel': cancel,
    };
  }
}
