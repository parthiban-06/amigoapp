typedef JsonParser<T> = T Function(Map<String, dynamic> json);

class AwsApiResponse<T> {
  final T? data;
  final bool success;
  final String? message;
  final int statusCode;
  final Map<String, dynamic>? rawData;

  AwsApiResponse({
    this.data,
    required this.success,
    this.message,
    required this.statusCode,
    this.rawData,
  });

  factory AwsApiResponse.success({
    required T? data,
    required int statusCode,
    Map<String, dynamic>? rawData,
  }) {
    return AwsApiResponse(
      data: data,
      success: true,
      statusCode: statusCode,
      rawData: rawData,
    );
  }

  factory AwsApiResponse.error({
    required String message,
    required int statusCode,
    Map<String, dynamic>? rawData,
  }) {
    return AwsApiResponse(
      success: false,
      message: message,
      statusCode: statusCode,
      rawData: rawData,
    );
  }
}
