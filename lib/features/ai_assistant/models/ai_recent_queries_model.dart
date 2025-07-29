import 'dart:convert';

AiRecentQueriesModel suggestionModelFromJson(String str) =>
    AiRecentQueriesModel.fromJson(json.decode(str));

String recentQueriesModelToJson(AiRecentQueriesModel data) =>
    json.encode(data.toJson());

List<AiRecentQueriesModel> recentQueriesFromJsonList(List<dynamic> data) {
  return List<AiRecentQueriesModel>.from(
      data.map((item) => AiRecentQueriesModel.fromJson(item)));
}

class AiRecentQueriesModel {
  AiRecentQueriesModel({
    String? query,
  }) {
    _query = query;
  }

  AiRecentQueriesModel.fromJson(dynamic json) {
    _query = json['query'];
  }

  String? _query;

  AiRecentQueriesModel copyWith({
    String? query,
  }) =>
      AiRecentQueriesModel(
        query: query ?? _query,
      );

  String get query => _query ?? "";

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['query'] = _query;
    return map;
  }
}
