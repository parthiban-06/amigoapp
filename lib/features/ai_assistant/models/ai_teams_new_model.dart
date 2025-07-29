import 'dart:convert';

AiTeamsNewModel teamsNewModelFromJson(String str) =>
    AiTeamsNewModel.fromJson(json.decode(str));

String teamsNewModelToJson(AiTeamsNewModel data) => json.encode(data.toJson());

List<AiTeamsNewModel> teamsNewFromJsonList(List<dynamic> data) {
  return List<AiTeamsNewModel>.from(
      data.map((item) => AiTeamsNewModel.fromJson(item)));
}

class AiTeamsNewModel {
  final List<Teams> teams;

  AiTeamsNewModel({required this.teams});

  factory AiTeamsNewModel.fromJson(Map<String, dynamic> json) {
    return AiTeamsNewModel(
      teams: (json['teams'] != null && json['teams'] is List)
          ? (json['teams'] as List)
              .map((e) => Teams.fromJson(e as Map<String, dynamic>))
              .toList()
          : [], // Ensure it's always initialized
    );
  }

  Map<String, dynamic> toJson() => {
        'teams': teams.map((e) => e.toJson()).toList(),
      };
}

class Teams {
  final int? id;
  final String? name;
  final String? key;

  Teams({
    this.id,
    this.name,
    this.key,
  });

  Teams.fromJson(Map<String, dynamic> json)
      : id = json['id'] as int?,
        name = json['name'] as String?,
        key = json['key'] as String?;

  Map<String, dynamic> toJson() => {'id': id, 'name': name, 'key': key};
}
