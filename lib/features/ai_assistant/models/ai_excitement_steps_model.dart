import 'dart:convert';

AiExcitementStepsModel excitementModelFromJson(String str) =>
    AiExcitementStepsModel.fromJson(json.decode(str));

String suggestionModelToJson(AiExcitementStepsModel data) =>
    json.encode(data.toJson());

List<AiExcitementStepsModel> excitementFromJsonList(List<dynamic> data) {
  return List<AiExcitementStepsModel>.from(
      data.map((item) => AiExcitementStepsModel.fromJson(item)));
}

class AiExcitementStepsModel {
  final int id;
  final String title;
  final double point;
  bool isSelect;

  AiExcitementStepsModel({
    required this.id,
    required this.title,
    required this.point,
    this.isSelect = false,
  });

  factory AiExcitementStepsModel.fromJson(Map<String, dynamic> json) {
    return AiExcitementStepsModel(
      id: json['id'] as int,
      title: json['title'] as String,
      point: (json['point'] as num).toDouble(),
      isSelect: json['isSelect'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'point': point,
      'isSelect': isSelect,
    };
  }
}
