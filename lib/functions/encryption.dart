import 'dart:typed_data';
import 'package:pointycastle/digests/sha256.dart';
import 'dart:convert';
import 'package:aes_crypt_null_safe/aes_crypt_null_safe.dart';
import 'package:pointycastle/export.dart';

class Encryption {
  static String calculateSHA256(String input) {
    Uint8List bytes = Uint8List.fromList(utf8.encode(input));
    Uint8List digest = SHA256Digest().process(bytes);

    String hashedString =
        digest.map((byte) => byte.toRadixString(16).padLeft(2, '0')).join('');
    return hashedString;
  }

  static Uint8List encryptAES(String plainText, String key) {
    Uint8List keyBytes =
        SHA256Digest().process(Uint8List.fromList(utf8.encode(key)));
    Uint8List iv = Uint8List(16);

    var crypt = AesCrypt();
    crypt.aesSetParams(keyBytes, iv, AesMode.cbc);
    List<int> l = utf8.encode(plainText.padLeft(128, '0'));

    Uint8List srcData = (Uint8List.fromList(l));
    Uint8List encrypted = crypt.aesEncrypt(srcData);
    return encrypted;
  }

  static String decryptAES(Uint8List encryptedText, String key) {
    Uint8List keyBytes =
        SHA256Digest().process(Uint8List.fromList(utf8.encode(key)));

    var crypt = AesCrypt();
    Uint8List iv = Uint8List(16);
    crypt.aesSetParams(keyBytes, iv, AesMode.cbc);

    Uint8List decryptedData = crypt.aesDecrypt(encryptedText);
    return String.fromCharCodes(decryptedData);
  }
}
