import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:sprintf/sprintf.dart';

import '../../core/config/app_config.dart';
import '../../utils/utils.dart';
import 'aws_api_response.dart';

class AwsApiService {
  final String apiGatewayId;
  final Map<String, String> defaultHeaders;
  final Duration timeout;

  String awsBaseUrl = "";

  AwsApiService({
    required this.apiGatewayId,
    Map<String, String>? defaultHeaders,
    Duration? timeout,
  })  : defaultHeaders = defaultHeaders ??
            {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
        timeout = timeout ?? const Duration(seconds: 30),
        awsBaseUrl = sprintf(
            "https://%s.execute-api.us-east-1.amazonaws.com/%s",
            [apiGatewayId, AppConfig().awsApiGatewayEnvironment]);

  Future<AwsApiResponse<T>> get<T>({
    required String endpoint,
    Map<String, String>? headers,
    Map<String, dynamic>? queryParameters,
    required JsonParser<T> parser,
  }) async {
    return _sendRequest<T>(
      endpoint: endpoint,
      method: 'GET',
      headers: headers,
      queryParameters: queryParameters,
      parser: parser,
    );
  }

  Future<AwsApiResponse<T>> post<T>({
    required String endpoint,
    Map<String, String>? headers,
    Map<String, dynamic>? queryParameters,
    dynamic body,
    required JsonParser<T> parser,
  }) async {
    return _sendRequest<T>(
      endpoint: endpoint,
      method: 'POST',
      headers: headers,
      queryParameters: queryParameters,
      body: body,
      parser: parser,
    );
  }

  Future<AwsApiResponse<T>> put<T>({
    required String endpoint,
    Map<String, String>? headers,
    Map<String, dynamic>? queryParameters,
    dynamic body,
    required JsonParser<T> parser,
  }) async {
    return _sendRequest<T>(
      endpoint: endpoint,
      method: 'PUT',
      headers: headers,
      queryParameters: queryParameters,
      body: body,
      parser: parser,
    );
  }

  Future<AwsApiResponse<T>> delete<T>({
    required String endpoint,
    Map<String, String>? headers,
    Map<String, dynamic>? queryParameters,
    dynamic body,
    required JsonParser<T> parser,
  }) async {
    return _sendRequest<T>(
      endpoint: endpoint,
      method: 'DELETE',
      headers: headers,
      queryParameters: queryParameters,
      body: body,
      parser: parser,
    );
  }

  Future<AwsApiResponse<T>> _sendRequest<T>({
    required String endpoint,
    required String method,
    Map<String, String>? headers,
    Map<String, dynamic>? queryParameters,
    dynamic body,
    required JsonParser<T> parser,
  }) async {
    try {
      final uri = Uri.parse(awsBaseUrl + endpoint).replace(
        queryParameters: queryParameters,
      );

      final requestHeaders = {
        ...defaultHeaders,
        if (headers != null) ...headers,
      };

      final request = http.Request(method, uri);
      request.headers.addAll(requestHeaders);

      if (body != null) {
        request.body = json.encode(body);
      }

      final streamedResponse = await request.send().timeout(timeout);

      final response = await http.Response.fromStream(streamedResponse);

      Utils.logPrint("response -- ${method} --  ${request.url}");
      Utils.logPrint("response.statusCode ${response.statusCode}");
      Utils.logPrint("response.body ${json.encode(body)}");

      if (response.statusCode == 204) {
        return AwsApiResponse.success(
          data: null,
          statusCode: response.statusCode,
        );
      }

      final responseData = json.decode(response.body);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        try {
          final parsedData = parser(responseData);
          return AwsApiResponse.success(
            data: parsedData,
            statusCode: response.statusCode,
            rawData: responseData,
          );
        } catch (e) {
          return AwsApiResponse.error(
            message: 'Failed to parse response data',
            statusCode: response.statusCode,
            rawData: responseData,
          );
        }
      } else {
        return AwsApiResponse.error(
          message: responseData['message'] ?? 'Unknown error occurred',
          statusCode: response.statusCode,
          rawData: responseData,
        );
      }
    } catch (e) {
      return AwsApiResponse.error(
        message: _handleError(e),
        statusCode: 500,
      );
    }
  }

  String _handleError(dynamic error) {
    //currently hardcode once we finalise backend code will convert to int status
    if (error is http.ClientException) {
      return 'Network error occurred';
    } else if (error is FormatException) {
      return 'Invalid response format';
    } else if (error is TimeoutException) {
      return 'Request timed out';
    }
    return error.toString();
  }
}
