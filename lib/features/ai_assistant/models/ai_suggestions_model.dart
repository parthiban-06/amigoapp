import 'dart:convert';

AISuggestions suggestionModelFromJson(String str) =>
    AISuggestions.fromJson(json.decode(str));

String suggestionModelToJson(AISuggestions data) => json.encode(data.toJson());

List<AISuggestions> suggestionFromJsonList(List<dynamic> data) {
  return List<AISuggestions>.from(
      data.map((item) => AISuggestions.fromJson(item)));
}

class AISuggestions {
  AISuggestions({
    String? suggestion,
  }) {
    _suggestion = suggestion;
  }

  AISuggestions.fromJson(dynamic json) {
    _suggestion = json['suggestion'];
  }

  String? _suggestion;

  AISuggestions copyWith({
    String? suggestion,
  }) =>
      AISuggestions(
        suggestion: suggestion ?? _suggestion,
      );

  String get suggestion => _suggestion ?? "";

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['suggestion'] = _suggestion;
    return map;
  }
}
