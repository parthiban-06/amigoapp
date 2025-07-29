import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';

import '../utils/ssl_pinning.dart';
import '../utils/utils.dart';

class DebugHttpClient extends http.BaseClient {
  final http.Client _inner;

  DebugHttpClient()
      : _inner = kIsWeb
            ? http.Client() // Use standard HTTP client for web
            : IOClient(
                createPinnedHttpClient()); // Use SSL pinned client for mobile

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    if (!const bool.fromEnvironment('dart.vm.product')) {
      // Log request
      Utils.logPrint('🌐 REQUEST ==> ${request.method} => ${request.url}');
      Utils.logPrint(
        'Headers: ==> ${request.headers}',
      );

      if (request is http.Request) {
        Utils.logPrint('Body: ==> ${request.body}');
      }
    }

    try {
      final response = await _inner.send(request);

      if (!const bool.fromEnvironment('dart.vm.product')) {
        // Log response
        final body = await response.stream.bytesToString();
        Utils.logPrint(
          '✅ RESPONSE ==> [${response.statusCode}] => ${request.url}\nBody: $body',
        );

        // Return new response since we consumed the stream
        return http.StreamedResponse(
          Stream.value(body.codeUnits),
          response.statusCode,
          headers: response.headers,
        );
      }

      return response;
    } catch (error) {
      if (!const bool.fromEnvironment('dart.vm.product')) {
        Utils.logPrint(
          '❌ ERROR => ${request.url}\nError: $error',
        );
      }
      rethrow;
    }
  }

  @override
  void close() {
    _inner.close();
  }
}
