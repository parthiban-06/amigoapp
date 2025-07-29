import 'dart:convert';

import 'package:encrypt/encrypt.dart' as ed;
import 'package:encrypt_shared_preferences/provider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:visaamigo/utils/utils.dart';

import 'app_const.dart';

class EncryptDecryptService {
  static String encryptAES(String plainText) {
    final key = ed.Key.fromUtf8(dotenv.env[AppConst.AES_ENC_KEY]!);
    final iv = ed.IV.fromUtf8(dotenv.env[AppConst.AES_ENC_IV]!);
    final encrypter = ed.Encrypter(ed.AES(key, mode: ed.AESMode.cbc));
    var encrypted = encrypter.encrypt(plainText, iv: iv);
    return encrypted.base64;
  }

  static Uint8List encryptFile(List<int> fileBytes) {
    Utils.logPrint("file decryption length ${fileBytes.length}");
    final key = ed.Key.fromUtf8(dotenv.env[AppConst.AES_ENC_KEY]!);
    final iv = ed.IV.fromUtf8(dotenv.env[AppConst.AES_ENC_IV]!);
    final encrypter = ed.Encrypter(ed.AES(key, mode: ed.AESMode.cbc));
    var encrypted = encrypter.encryptBytes(fileBytes, iv: iv);
    String finalResult =
        "${base64Encode(encrypted!.bytes)}${List.from(dotenv.env[AppConst.AES_ENC_IV]!.split('').reversed).join('')}${List.from(dotenv.env[AppConst.AES_ENC_IV]!.split('').reversed).join('')}";
    return Uint8List.fromList(finalResult.codeUnits);
  }

  static String decryptAES(String encryptedData) {
    try {
      ed.Encrypted encrypted = ed.Encrypted.fromBase64(encryptedData);
      final key = ed.Key.fromUtf8(dotenv.env[AppConst.AES_ENC_KEY]!);
      final iv = ed.IV.fromUtf8(dotenv.env[AppConst.AES_ENC_IV]!);
      final encrypter = ed.Encrypter(ed.AES(key, mode: ed.AESMode.cbc));
      var decrypted = encrypter.decrypt(encrypted, iv: iv);
      return decrypted;
    } catch (error) {
      Utils.logPrint("AES decryption error: $error");
      return "";
    }
  }

  static Uint8List? decryptFile(Uint8List? encryptedData) {
    try {
      String partiallyEncrypted = String.fromCharCodes(encryptedData!);
      var encKey = partiallyEncrypted.substring(partiallyEncrypted.length - 32);
      final key =
          ed.Key.fromUtf8(encKey.substring(0, 16).split('').reversed.join(''));
      final iv =
          ed.IV.fromUtf8(encKey.substring(16).split('').reversed.join(''));
      final encrypter = ed.Encrypter(ed.AES(key, mode: ed.AESMode.gcm));
      var imgBytes = base64Decode(
          partiallyEncrypted.substring(0, partiallyEncrypted.length - 32));
      var decrypted = encrypter.decryptBytes(ed.Encrypted(imgBytes), iv: iv);
      return Uint8List.fromList(decrypted);
    } catch (error) {
      Utils.logPrint("AES decryption error: $error");
      return null;
    }
  }
}

class CustomEncryptorAlgorithm implements IEncryptor {
  @override
  String decrypt(String key, String encryptedData) {
    return (EncryptDecryptService.decryptAES(encryptedData));
  }

  @override
  String encrypt(String key, String plainText) {
    return (EncryptDecryptService.encryptAES(plainText));
  }
}
