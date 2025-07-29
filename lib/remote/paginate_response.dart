import 'package:visaamigo/utils/utils.dart';

class PaginatedResponse<T> {
  final List<T> items;
  final int currentPage;
  final int totalPages;
  final int totalItems;
  final bool hasNextPage;

  PaginatedResponse({
    required this.items,
    required this.currentPage,
    required this.totalPages,
    required this.totalItems,
    required this.hasNextPage,
  });

  factory PaginatedResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic>) fromJson, {
    required String itemsKey,
  }) {
    Utils.logPrint(
        "apiResponse currentPage  page_no--- ${json['data']} --- ${itemsKey}");
    return PaginatedResponse<T>(
      items: (json['data']?[itemsKey] as List)
          .map((item) => fromJson(item as Map<String, dynamic>))
          .toList(),
      currentPage: json['data']['page_no'] ?? 1,
      totalPages: json['data']['total_pages'] ?? 1,
      totalItems: json['data']['totalItems'] ?? 0,
      hasNextPage:
          (json['data']['page_no'] ?? 1) < (json['data']['total_pages'] ?? 1),
    );
  }
}
