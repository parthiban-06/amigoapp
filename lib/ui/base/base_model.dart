abstract class BaseModel {
  // String get baseId;

  Map<String, dynamic> toJson();

  BaseModel fromJson(Map<String, dynamic> json);
}
