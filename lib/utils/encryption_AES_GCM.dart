import 'dart:convert';
import 'dart:typed_data';
import 'package:cryptography/cryptography.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class EncryptionHelperGCM {
  // Base64URL-encoded 32-byte key
  static final String keyBase64 = dotenv.env['KEY_BASE64']!;

  static Future<String> encrypt(String plaintext) async {
    final secretKey = SecretKey(base64Url.decode(keyBase64));
    final algorithm = AesGcm.with256bits();

    final nonce = algorithm.newNonce(); // 12-byte nonce
    final secretBox = await algorithm.encrypt(
      utf8.encode(plaintext),
      secretKey: secretKey,
      nonce: nonce,
    );

    // Combine nonce + ciphertext + tag into one list
    final combined = Uint8List.fromList([
      ...secretBox.nonce,
      ...secretBox.cipherText,
      ...secretBox.mac.bytes,
    ]);

    return base64.encode(combined);
  }

  static Future<String> decrypt(String encryptedBase64) async {
    final algorithm = AesGcm.with256bits();
    final data = base64.decode(encryptedBase64);

    final nonce = data.sublist(0, 12);
    final mac = Mac(data.sublist(data.length - 16));
    final cipherText = data.sublist(12, data.length - 16);

    final secretKey = SecretKey(base64Url.decode(keyBase64));

    final secretBox = SecretBox(
      cipherText,
      nonce: nonce,
      mac: mac,
    );

    final cleartext = await algorithm.decrypt(
      secretBox,
      secretKey: secretKey,
    );

    return utf8.decode(cleartext);
  }
}
