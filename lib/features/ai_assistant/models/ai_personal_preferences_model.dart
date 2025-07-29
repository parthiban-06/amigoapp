import 'dart:convert';

AiPersonalPreferencesModel personalPrefModelFromJson(String str) =>
    AiPersonalPreferencesModel.fromJson(json.decode(str));

String personalPrefModelToJson(AiPersonalPreferencesModel data) =>
    json.encode(data.toJson());

List<AiPersonalPreferencesModel> personalPrefFromJsonList(List<dynamic> data) {
  return List<AiPersonalPreferencesModel>.from(
      data.map((item) => AiPersonalPreferencesModel.fromJson(item)));
}

class AiPersonalPreferencesModel {
  final String? title;
  final List<String>? chips;

  AiPersonalPreferencesModel({
    this.title,
    this.chips,
  });

  AiPersonalPreferencesModel.fromJson(Map<String, dynamic> json)
      : title = json['title'] as String?,
        chips =
            (json['chips'] as List?)?.map((dynamic e) => e as String).toList();

  Map<String, dynamic> toJson() => {'title': title, 'chips': chips};
}
