import 'package:visaamigo/features/home/model/match_details.dart';

class GetUserMatchesModel {
  final int? statusCode;
  final String? messageKey;
  final List<MatchData>? data;

  GetUserMatchesModel({
    this.statusCode,
    this.messageKey,
    this.data,
  });

  GetUserMatchesModel copyWith({
    int? statusCode,
    String? messageKey,
    List<MatchData>? data,
  }) {
    return GetUserMatchesModel(
      statusCode: statusCode ?? this.statusCode,
      messageKey: messageKey ?? this.messageKey,
      data: data ?? this.data,
    );
  }

  GetUserMatchesModel.fromJson(Map<String, dynamic> json)
      : statusCode = json['status_code'] as int?,
        messageKey = json['message_key'] as String?,
        data = (json['data'] as List?)
            ?.map((dynamic e) => MatchData.fromJson(e as Map<String, dynamic>))
            .toList();

  Map<String, dynamic> toJson() => {
        'status_code': statusCode,
        'message_key': messageKey,
        'data': data?.map((e) => e.toJson()).toList()
      };
}
