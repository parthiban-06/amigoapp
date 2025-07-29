import '../../../utils/utils.dart';

class AiSearchPlacesExpandCollapseModel {
  final String id;
  final bool isExpand;

  AiSearchPlacesExpandCollapseModel({
    required this.id,
    required this.isExpand,
  });

  factory AiSearchPlacesExpandCollapseModel.fromJson(Map<String, dynamic> json) {
    return AiSearchPlacesExpandCollapseModel(
      id: Utils.convrtStringUtf(json["id"] ?? ""),
      isExpand: false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "isExpand": isExpand,
    };
  }

  AiSearchPlacesExpandCollapseModel copyWith({
    String? id,
    bool? isExpand,

  }) {
    return AiSearchPlacesExpandCollapseModel(
      id: id ?? this.id,
      isExpand: isExpand ?? this.isExpand,
    );
  }
}

