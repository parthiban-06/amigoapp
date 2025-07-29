import '../../../utils/utils.dart';

class CompanionListResponse {
  final int statusCode;
  final String messageKey;
  final List<CompanionProfile>? data;

  CompanionListResponse({
    required this.statusCode,
    required this.messageKey,
    this.data,
  });

  factory CompanionListResponse.fromJson(Map<String, dynamic> json) {
    return CompanionListResponse(
      statusCode: json['status_code'],
      messageKey: json['message_key'],
      data: (json['data'] as List?)
          ?.map((item) => CompanionProfile.fromJson(item))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        'status_code': statusCode,
        'message_key': messageKey,
        if (data != null) 'data': data!.map((item) => item.toJson()).toList(),
      };
}

class CompanionProfile {
  final String id;
  final String userId;
  final String firstName;
  final String lastName;
  final String email;
  final List<String> matchIds;
  final bool status;

  CompanionProfile({
    required this.id,
    required this.userId,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.matchIds,
    required this.status,
  });

  factory CompanionProfile.fromJson(Map<String, dynamic> json) {
    return CompanionProfile(
      id: json['id'],
      userId: json['user_id'],
      firstName: Utils.convrtStringUtf(json['first_name']),
      lastName: Utils.convrtStringUtf(json['last_name']),
      email: json['email'],
      matchIds: List<String>.from(json['match_ids'] ?? []),
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'user_id': userId,
        'first_name': firstName,
        'last_name': lastName,
        'email': email,
        'match_ids': matchIds,
        'status': status,
      };
}
