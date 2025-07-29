class SessionDeleteResponse {
  final List<String> data;

  SessionDeleteResponse(this.data);

  factory SessionDeleteResponse.fromJson(dynamic json) {
    // json is actually the value of "data", so it's a List
    if (json is List) {
      return SessionDeleteResponse(
          List<String>.from(json.map((e) => e.toString())));
    } else {
      return SessionDeleteResponse([]);
    }
  }

  static List<SessionDeleteResponse> fromDataJson(Map<String, dynamic> json) {
    if (json['data'] == null) return [];
    return (json['data'] as List)
        .map((e) => SessionDeleteResponse.fromJson(e))
        .toList();
  }
}
