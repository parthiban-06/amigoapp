import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:visaamigo/remote/paginate_response.dart';
import 'package:visaamigo/utils/amplify_service.dart';
import 'package:visaamigo/utils/app_extensions.dart';
import 'package:visaamigo/utils/utils.dart';

import '../core/config/env_config.dart';
import '../router/app_router.dart';
import '../router/app_routes_const.dart';
import '../utils/app_const.dart';
import 'api_exception.dart';
import 'api_response.dart';
import 'debug_http_client.dart';

class ApiClient {
  final String baseUrl = EnvConfig.apiUrl;
  final http.Client client;
  final Map<String, dynamic> defaultHeaders;
  final Duration timeout;
  http.Request? retryOption;
  bool _isCancelled = false;

  ApiClient({
    http.Client? client,
    Map<String, String>? defaultHeaders,
    this.timeout = const Duration(seconds: 60),
  })  : client = client ?? DebugHttpClient(),
        defaultHeaders = defaultHeaders ??
            {
              'Content-Type': 'application/json',
              "Accept-Charset": "utf-8",
              AppConst.HEADER_ACCESS_CONTROL_ALLOW_ORIGIN: EnvConfig.weburl,
            };

  Future<ApiResponse<T>> _handleResponse<T>({
    required Future<http.Response> Function() apiCall,
    required T Function(Map<String, dynamic> json) fromJson,
    bool isPaginated = false,
    bool isJsonRequired = true,
    bool isDataNodePresent = true,
    String itemsKey = "",
    bool retryOnAuthFail = true, // Prevents infinite retry loop
  }) async {
    try {
      final response = await apiCall().timeout(timeout);
      final statusCode = response.statusCode;

      // String utf8Decoded =
      //     utf8.decode(response.bodyBytes, allowMalformed: true);
      // Utils.logPrint("utf8Decoded $utf8Decoded");

      final jsonData = json.decode(response.body);

      // if (_isCancelled) {
      //   _isCancelled = false; // reset for next call
      //   return ApiResponse<T>(
      //     statusCode: 999,
      //   ); // HTTP 499 = client closed request
      // }

      // Utils.logPrint("response $response");
      Utils.logPrint("response.statusCode ${response.statusCode}");
      // Utils.logPrint("response.isPaginated $isPaginated");
      // Utils.logPrint("response.jsonData $jsonData");
      //
      // Utils.logPrint(
      //     "response.fromJson ${isJsonRequired ? fromJson(jsonData) : jsonData}");

      if (response.statusCode >= 200 && response.statusCode < 300) {
        if (isPaginated) {
          // Utils.logPrint("response $jsonData");
          final paginatedData = PaginatedResponse<T>.fromJson(
              jsonData, (json) => fromJson(json as Map<String, dynamic>),
              itemsKey: itemsKey);

          Utils.logPrint("paginatedData ${paginatedData.items}");

          return ApiResponse<T>(
            paginatedData: paginatedData,
            statusCode: statusCode,
          );
        }
        return ApiResponse<T>(
          data: (isDataNodePresent)
              ? isJsonRequired
                  ? fromJson(jsonData["data"])
                  : jsonData["data"]
              : isJsonRequired
                  ? fromJson(jsonData)
                  : jsonData,
          messageKey: jsonData["message_key"],
          statusCode: statusCode,
        );
      }
      /*if (response.statusCode == 401) {
        // AppRouter.router.pushRoute(AppRoutes.login);
        await AmplifyService().refreshTokens();

        return ApiResponse<T>(
          statusCode: statusCode,
          messageKey: "",
          error: "",
        );
      }*/
      if (statusCode == 401 || statusCode == 403) {
        // AppRouter.router.pushRoute(AppRoutes.login);
        // await AmplifyService().refreshTokens();

        if (retryOnAuthFail) {
          bool tokenRefreshed = await AmplifyService().refreshTokens();

          if (tokenRefreshed) {
            return _handleResponse<T>(
              apiCall: () => _retryWithNewHeadersFromRequest(retryOption),
              // Retry original request
              fromJson: fromJson,
              isPaginated: isPaginated,
              isJsonRequired: isJsonRequired,
              isDataNodePresent: isDataNodePresent,
              retryOnAuthFail: false, // Prevent multiple retries
            );
          } else {
            await AmplifyService().signOutUser();
            AppRouter.router.pushRoute(AppRoutes.registeredEmail);

            return ApiResponse<T>(
              statusCode: statusCode,
              messageKey: jsonData["error_code"] ?? jsonData["message_key"],
              error: Utils.getErrorMessageFromString(
                  jsonData["error_code"] ?? jsonData["message_key"],
                  returnTryagain: true),
            );
          }
        } else {
          await AmplifyService().signOutUser();

          AppRouter.router.pushRoute(AppRoutes.registeredEmail);
          return ApiResponse<T>(
            statusCode: statusCode,
            messageKey: jsonData["error_code"] ?? jsonData["message_key"],
            error: Utils.getErrorMessageFromString(
                jsonData["error_code"] ?? jsonData["message_key"],
                returnTryagain: true),
          );
        }
      } else {
        Utils.logPrint("message Unknown error occurred ${statusCode}");
        return ApiResponse<T>(
          statusCode: statusCode,
          messageKey: jsonData["error_code"] ?? jsonData["message_key"],
          error: Utils.getErrorMessageFromString(
              jsonData["error_code"] ?? jsonData["message_key"],
              returnTryagain: true),
        );
      }
    } on SocketException catch (e) {
      Utils.logPrint("SocketException $e");
      //VisaSnackBar.show();
      return ApiResponse<T>(
        error: Utils.getErrorMessageFromString("no_internet",
            returnTryagain: true),
        statusCode: 503,
        messageKey: 'no_internet',
      );
    } on http.ClientException catch (e) {
      Utils.logPrint("http.ClientException $e");
      //VisaSnackBar.show();
      return ApiResponse<T>(
        error: Utils.getErrorMessageFromString("connection_refused",
            returnTryagain: true),
        statusCode: 503,
        messageKey: 'connection_refused',
      );
    } on TimeoutException catch (e) {
      Utils.logPrint("TimeoutException $e");
      // VisaSnackBar.show();
      return ApiResponse<T>(
        error: Utils.getErrorMessageFromString("api_timeout",
            returnTryagain: true),
        statusCode: 504,
        messageKey: 'api_timeout',
      );
    } on ApiException catch (e) {
      Utils.logPrint("ApiException $e");

      return ApiResponse<T>(
        error: e.message,
        statusCode: e.statusCode,
        messageKey: "try_again",
      );
    } on FormatException catch (e) {
      Utils.logPrint("FormatException $e");
      return ApiResponse<T>(
        error: "Invalid response format",
        statusCode: 500,
        messageKey: "invalid_response",
      );
    } catch (e) {
      Utils.logPrint("catch Exception $e");
      return ApiResponse<T>(
        error: e.toString(),
        statusCode: 500,
        messageKey: "try_again",
      );
    }
  }

  Future<ApiResponse<T>> get<T>({
    required String endpoint,
    required T Function(Map<String, dynamic> json) fromJson,
    Map<String, String>? headers,
    Map<String, dynamic>? queryParameters,
    String? customUrl,
    bool isPaginated = false,
    bool isJsonRequired = true,
    bool isDataNodePresent = true,
    bool addAuthHeader = true,
    String itemsKey = "",
  }) async {
    final uri = customUrl == null
        ? Uri.parse('$baseUrl$endpoint').replace(
            queryParameters: queryParameters,
          )
        : Uri.parse(customUrl);

    if (addAuthHeader) {
      headers = await addHeader(headers);
    }

    retryOption = http.Request('GET', uri)
      ..headers.addAll({...defaultHeaders, ...?headers});

    return _handleResponse<T>(
        apiCall: () => client.get(
              uri,
              headers: {...defaultHeaders, ...?headers},
            ),
        fromJson: fromJson,
        isPaginated: isPaginated,
        isJsonRequired: isJsonRequired,
        itemsKey: itemsKey,
        isDataNodePresent: isDataNodePresent);
  }

  Future<ApiResponse<T>> post<T>({
    required String endpoint,
    required T Function(Map<String, dynamic> json) fromJson,
    dynamic body,
    Map<String, String>? headers,
    bool isPaginated = false,
    bool addAuthHeader = true,
    bool isDataNodePresent = true,
  }) async {
    Utils.logPrint("post $body");

    if (addAuthHeader) {
      headers = await addHeader(headers);
    }
    retryOption = http.Request('POST', Uri.parse('$baseUrl$endpoint'))
      ..headers.addAll({...defaultHeaders, ...?headers})
      ..body = json.encode(body);
    return _handleResponse<T>(
      apiCall: () => client.post(
        Uri.parse('$baseUrl$endpoint'),
        headers: {...defaultHeaders, ...?headers},
        body: json.encode(body),
      ),
      isDataNodePresent: isDataNodePresent,
      fromJson: fromJson,
      isPaginated: isPaginated,
    );
  }

  Future<ApiResponse<T>> put<T>({
    required String endpoint,
    required T Function(Map<String, dynamic> json) fromJson,
    dynamic body,
    Map<String, String>? headers,
    bool isPaginated = false,
    bool addAuthHeader = true,
    bool isDataNodePresent = true,
  }) async {
    if (addAuthHeader) {
      headers = await addHeader(headers);
    }
    retryOption = http.Request('PUT', Uri.parse('$baseUrl$endpoint'))
      ..headers.addAll({...defaultHeaders, ...?headers})
      ..body = json.encode(body);
    return _handleResponse<T>(
      apiCall: () => client.put(
        Uri.parse('$baseUrl$endpoint'),
        headers: {...defaultHeaders, ...?headers},
        body: json.encode(body),
      ),
      isDataNodePresent: isDataNodePresent,
      fromJson: fromJson,
      isPaginated: isPaginated,
    );
  }

  Future<ApiResponse<T>> patch<T>({
    required String endpoint,
    required T Function(Map<String, dynamic> json) fromJson,
    dynamic body,
    bool isJsonRequired = true,
    Map<String, String>? headers,
    bool addAuthHeader = true,
    bool isDataNodePresent = true,
  }) async {
    if (addAuthHeader) {
      headers = await addHeader(headers);
    }
    retryOption = http.Request('PATCH', Uri.parse('$baseUrl$endpoint'))
      ..headers.addAll({...defaultHeaders, ...?headers})
      ..body = json.encode(body);
    return _handleResponse<T>(
        apiCall: () => client.patch(
              Uri.parse('$baseUrl$endpoint'),
              headers: {...defaultHeaders, ...?headers},
              body: json.encode(body),
            ),
        isJsonRequired: isJsonRequired,
        fromJson: fromJson,
        isDataNodePresent: isDataNodePresent);
  }

  Future<ApiResponse<T>> delete<T>({
    required String endpoint,
    required T Function(Map<String, dynamic> json) fromJson,
    Map<String, String>? headers,
    bool addAuthHeader = true,
    bool isJsonRequired = true,
    bool isDataNodePresent = true,
  }) async {
    if (addAuthHeader) {
      headers = await addHeader(headers);
    }
    retryOption = http.Request('DELETE', Uri.parse('$baseUrl$endpoint'))
      ..headers.addAll({...defaultHeaders, ...?headers});
    return _handleResponse<T>(
        apiCall: () => client.delete(
              Uri.parse('$baseUrl$endpoint'),
              headers: {...defaultHeaders, ...?headers},
            ),
        isJsonRequired: isJsonRequired,
        fromJson: fromJson,
        isDataNodePresent: isDataNodePresent);
  }

  Future<Map<String, String>?> addHeader(Map<String, String>? headers) async {
    if (!AmplifyService().authToken.isNullOrEmpty) {
      headers ??= <String, String>{};
      headers.putIfAbsent(AppConst.HEADER_AUTHORIZATION,
          () => "${AppConst.HEADER_BEARER} ${AmplifyService().authToken}");
    } else {
      //retry to get new token

      bool tokenRefreshed = await AmplifyService().refreshTokens();

      if (tokenRefreshed) {
        headers ??= <String, String>{};
        headers.putIfAbsent(AppConst.HEADER_AUTHORIZATION,
            () => "${AppConst.HEADER_BEARER} ${AmplifyService().authToken}");
      } else {
        // await AmplifyService().signOutUser();

        // AppRouter.router.pushRoute(AppRoutes.registeredEmail);
      }
    }

    return headers;
  }

  Future<ApiResponse<T>> deleteItem<T>({
    required String endpoint,
    required T Function(Map<String, dynamic> json) fromJson,
    dynamic body,
    Map<String, String>? headers,
    bool addAuthHeader = true,
    bool isJsonRequired = true,
    bool isDataNodePresent = true,
  }) async {
    if (addAuthHeader) {
      headers = await addHeader(headers);
    }

    final request = http.Request('DELETE', Uri.parse('$baseUrl$endpoint'))
      ..headers.addAll({...defaultHeaders, ...?headers});

    if (body != null) {
      request.body = json.encode(body);
    }

    retryOption = request;

    final streamedResponse = await client.send(request);
    final response = await http.Response.fromStream(streamedResponse);

    return _handleResponse<T>(
      apiCall: () async => response,
      fromJson: fromJson,
      isJsonRequired: isJsonRequired,
      isDataNodePresent: isDataNodePresent,
    );
  }

  Map<String, String>? replaceHeader(Map<String, String>? headers) {
    Utils.logPrint("replaceHeader method");
    if (!AmplifyService().authToken.isNullOrEmpty) {
      Utils.logPrint("replaceHeader old token -  $headers");

      Utils.logPrint(
          "replaceHeader new token -  ${AmplifyService().authToken}");
      headers?.remove(AppConst.HEADER_AUTHORIZATION);
      headers ??= <String, String>{};
      headers.putIfAbsent(AppConst.HEADER_AUTHORIZATION,
          () => "${AppConst.HEADER_BEARER} ${AmplifyService().authToken}");
    } else {
      Utils.logPrint("authToken empty");
    }

    Utils.logPrint("replaceHeader headers -  ${headers}");

    return headers;
  }

  Future<http.Response> _retryWithNewHeaders(
      Future<http.Response> Function() originalCall) async {
    Utils.logPrint("_retryWithNewHeaders 1");
    Utils.logPrint("_retryWithNewHeaders originalCall");
    final originalResponse = await originalCall();
    final request = originalResponse.request!;
    final updatedHeaders = replaceHeader(request.headers);
    Utils.logPrint("_retryWithNewHeaders 2}");

    String? body;
    if (request is http.Request) {
      body = request.body;
    }
    Utils.logPrint("_retryWithNewHeaders 3}");

    switch (request.method.toUpperCase()) {
      case 'GET':
        return client.get(request.url, headers: updatedHeaders);
      case 'POST':
        return client.post(request.url, headers: updatedHeaders, body: body);
      case 'PUT':
        return client.put(request.url, headers: updatedHeaders, body: body);
      case 'PATCH':
        return client.patch(request.url, headers: updatedHeaders, body: body);
      case 'DELETE':
        return client.delete(request.url, headers: updatedHeaders);
      default:
        throw UnsupportedError(
            'HTTP method ${request.method} not supported for retry.');
    }
  }

  /// Helper method to decode Unicode escape sequences in JSON data
  Map<String, dynamic> _decodeUnicodeEscapes(Map<String, dynamic> input) {
    Map<String, dynamic> result = {};

    input.forEach((key, value) {
      if (value is String) {
        // Check if the string contains Unicode escape sequences
        if (value.contains('\\u')) {
          try {
            // Convert Unicode escape sequences to actual characters
            final decodedValue = _convertUnicodeEscapes(value);
            result[key] = decodedValue;
          } catch (e) {
            // If conversion fails, keep the original value
            result[key] = value;
          }
        } else {
          result[key] = value;
        }
      } else if (value is Map<String, dynamic>) {
        // Recursively process nested maps
        result[key] = _decodeUnicodeEscapes(value);
      } else if (value is List) {
        // Process lists
        result[key] = _decodeUnicodeEscapesInList(value);
      } else {
        // Keep other types as is
        result[key] = value;
      }
    });

    return result;
  }

  /// Helper method to decode Unicode escape sequences in lists
  List _decodeUnicodeEscapesInList(List input) {
    return input.map((item) {
      if (item is String) {
        if (item.contains('\\u')) {
          try {
            return _convertUnicodeEscapes(item);
          } catch (e) {
            return item;
          }
        }
        return item;
      } else if (item is Map<String, dynamic>) {
        return _decodeUnicodeEscapes(item);
      } else if (item is List) {
        return _decodeUnicodeEscapesInList(item);
      }
      return item;
    }).toList();
  }

  /// Converts Unicode escape sequences (\\uXXXX) to actual characters
  String _convertUnicodeEscapes(String input) {
    // Replace all Unicode escape sequences with actual characters
    RegExp unicodePattern = RegExp(r'\\u([0-9a-fA-F]{4})');
    return input.replaceAllMapped(unicodePattern, (Match match) {
      final hexCode = match.group(1);
      if (hexCode != null) {
        final codePoint = int.parse(hexCode, radix: 16);
        return String.fromCharCode(codePoint);
      }
      return match.group(0)!;
    });
  }

  Future<http.Response> _retryWithNewHeadersFromRequest(
      http.Request? request) async {
    if (request == null) {
      throw Exception("No request found to retry");
    }

    final updatedHeaders = replaceHeader({...request.headers});

    final retryRequest = http.Request(request.method, request.url)
      ..headers.addAll(updatedHeaders!)
      ..body = request.body;

    final streamedResponse = await client.send(retryRequest);
    return http.Response.fromStream(streamedResponse);
  }

  void cancelCurrentRequest() {
    _isCancelled = true;
  }

  Future<String> getHtml({
    required String endpoint,
    Map<String, String>? headers,
    Map<String, dynamic>? queryParameters,
    String? customUrl,
    bool addAuthHeader = true,
  }) async {
    try {
      final uri = customUrl == null
          ? Uri.parse('$baseUrl$endpoint')
              .replace(queryParameters: queryParameters)
          : Uri.parse(customUrl);

      if (addAuthHeader) {
        headers = await addHeader(headers);
      }

      final response =
          await client.get(uri, headers: {...defaultHeaders, ...?headers});

      // Check if the response is HTML based on content-type
      if (response.headers['content-type']?.contains('text/html') == true) {
        return response.body; // Return the HTML directly as a String
      } else {
        throw Exception('Expected HTML content, but received something else.');
      }
    } catch (e) {
      throw Exception('Error occurred: $e');
    }
  }
}
