import 'dart:convert';

AiGoalModel goalModelFromJson(String str) =>
    AiGoalModel.fromJson(json.decode(str));

String goalModelToJson(AiGoalModel data) => json.encode(data.toJson());

List<AiGoalModel> goalFromJsonList(List<dynamic> data) {
  return List<AiGoalModel>.from(data.map((item) => AiGoalModel.fromJson(item)));
}

// Goal Model
class AiGoalModel {
  final int id;
  final String name;
  final String group;
  final double size;
  final double selectedSize;
  final double surroundedSize;
  final String langNameKey;
  final String langNameGroup;
  bool isSelect;
  int maxLines;

  AiGoalModel({
    required this.id,
    required this.name,
    required this.group,
    required this.size,
    required this.selectedSize,
    required this.surroundedSize,
    required this.langNameKey,
    required this.langNameGroup,
    required this.maxLines,
    this.isSelect = false,
  });

  factory AiGoalModel.fromJson(Map<String, dynamic> json) {
    return AiGoalModel(
      id: json['id'] as int,
      name: json['name'] as String,
      group: json['group'] as String,
      langNameKey: json['lang_name_key'] as String,
      langNameGroup: json['lang_name_group'] as String,
      size: (json['size'] as num).toDouble(),
      selectedSize: (json['selected_size'] as num).toDouble(),
      surroundedSize: (json['surrounded_size'] as num).toDouble(),
      isSelect: json['isSelect'] as bool,
      maxLines: json['max_line'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'group': group,
      'lang_name_key': langNameKey,
      'lang_name_group': langNameGroup,
      'size': size,
      'selected_size': selectedSize,
      'surrounded_size': surroundedSize,
      'isSelect': isSelect,
      'max_line': maxLines,
    };
  }
}
