// import 'dart:convert';

// import 'package:encrypt/encrypt.dart';
// import 'package:flutter_dotenv/flutter_dotenv.dart';

// class EncryptionHelper {
//   static final String keyBase64 = dotenv.env['KEY_BASE64']!;
//   static final String ivString = dotenv.env['IV_STRING']!; // 16-byte IV

//   static String encryptString(String text) {
//     // Decode Base64 key (must be 32 bytes)
//     final key = Key(base64Url.decode(keyBase64));
//     final iv = IV.fromUtf8(ivString);

//     final encrypter = Encrypter(AES(key, mode: AESMode.cbc, padding: "PKCS7"));
//     final encrypted = encrypter.encrypt(text, iv: iv);

//     return base64.encode(encrypted.bytes); // Encode output as Base64
//   }

//   static String decryptString(String encryptedText) {
//     final key = Key(base64Url.decode(keyBase64));
//     final iv = IV.fromUtf8(ivString);

//     final encrypter = Encrypter(AES(key, mode: AESMode.cbc, padding: "PKCS7"));

//     // Decode Base64 to get raw encrypted bytes
//     final encryptedBytes = base64.decode(encryptedText);
//     final encrypted = Encrypted(encryptedBytes);

//     final decrypted = encrypter.decrypt(encrypted, iv: iv);
//     return decrypted;
//   }
// }
