class CompanionDeleteResponse {
  final int statusCode;
  final String messageKey;
  final CompanionData data;

  CompanionDeleteResponse({
    required this.statusCode,
    required this.messageKey,
    required this.data,
  });

  factory CompanionDeleteResponse.fromJson(Map<String, dynamic> json) {
    return CompanionDeleteResponse(
      statusCode: json['status_code'],
      messageKey: json['message_key'],
      data: CompanionData.fromJson(json['data']),
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

class CompanionData {
  final String id;
  final String userId;
  final List<Limit> limit;

  CompanionData({
    required this.id,
    required this.userId,
    required this.limit,
  });

  factory CompanionData.fromJson(Map<String, dynamic> json) {
    return CompanionData(
      id: json['id'],
      userId: json['user_id'],
      limit: (json['limit'] as List)
          .map((item) => Limit.fromJson(item))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'limit': limit.map((l) => l.toJson()).toList(),
    };
  }
}

class Limit {
  final String matchId;
  final int limitLeft;

  Limit({
    required this.matchId,
    required this.limitLeft,
  });

  factory Limit.fromJson(Map<String, dynamic> json) {
    return Limit(
      matchId: json['match_id'],
      limitLeft: json['limit_left'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'match_id': matchId,
      'limit_left': limitLeft,
    };
  }
}
