class ApiException implements Exception {
  final String message;
  final String? messageKey;
  final int? statusCode;
  final dynamic response;

  ApiException({
    required this.message,
    this.messageKey,
    this.statusCode,
    this.response,
  });

  @override
  String toString() => 'ApiException: $message (Status: $statusCode)';
}
