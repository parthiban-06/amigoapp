import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

HttpClient createPinnedHttpClient() {
  // Skip SSL pinning on web platform
  if (kIsWeb) {
    // Return a basic HTTP client for web
    return HttpClient();
  }

  final context =
      SecurityContext(withTrustedRoots: true); // 👈 disables default CA trust
  final HttpClient client = HttpClient(context: context);

  // Replace this with your actual Base64-encoded SHA-256 public key pin
  String pinnedKey = (dotenv.env["SSL_KEY"] ?? "");

  client.badCertificateCallback =
      (X509Certificate cert, String host, int port) {
    // Get SHA-256 hash of the server's public key
    final derBytes = cert.der;
    final sha256Digest = sha256.convert(derBytes);
    final base64Digest = base64.encode(sha256Digest.bytes);

    // Compare against your pinned key
    return base64Digest == pinnedKey;
  };

  return client;
}
