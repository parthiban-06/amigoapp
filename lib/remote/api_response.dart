import 'package:visaamigo/remote/paginate_response.dart';

class ApiResponse<T> {
  final T? data;
  final String? error;
  final String? messageKey;
  final bool isLoading;
  final int? statusCode;
  final PaginatedResponse<T>? paginatedData;

  ApiResponse({
    this.data,
    this.error,
    this.messageKey,
    this.isLoading = false,
    this.statusCode,
    this.paginatedData,
  });

  bool get isSuccess =>
      statusCode != null && statusCode! >= 200 && statusCode! < 300;

  bool get isError => error != null;

  bool get hasData => data != null || paginatedData != null;

  ApiResponse<T> copyWith({
    T? data,
    String? error,
    String? messageKey,
    bool? isLoading,
    int? statusCode,
    PaginatedResponse<T>? paginatedData,
  }) {
    return ApiResponse<T>(
      data: data ?? this.data,
      error: error ?? this.error,
      messageKey: messageKey ?? this.messageKey,
      isLoading: isLoading ?? this.isLoading,
      statusCode: statusCode ?? this.statusCode,
      paginatedData: paginatedData ?? this.paginatedData,
    );
  }
}
