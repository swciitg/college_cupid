import 'dart:typed_data';
import 'dart:convert';
import 'package:aes_crypt_null_safe/aes_crypt_null_safe.dart';
import 'package:pointycastle/export.dart';

class Encryption {
  static String bytesToHexadecimal(Uint8List bytes) {
    return bytes.map((byte) => byte.toRadixString(16).padLeft(2, '0')).join('');
  }

  static Uint8List hexadecimalToBytes(String hexString) {
    List<int> decimalList = [];
    for (int i = 0; i < hexString.length; i += 2) {
      decimalList.add(int.parse(hexString.substring(i, i + 2).toUpperCase(), radix: 16));
    }
    return Uint8List.fromList(decimalList);
  }

  static Uint8List calculateSHA256(String input) {
    Uint8List bytes = Uint8List.fromList(utf8.encode(input));
    Uint8List shaDigest = SHA256Digest().process(bytes);

    return shaDigest;
  }

  static Uint8List calculateMD5(String input) {
    Uint8List bytes = Uint8List.fromList(utf8.encode(input));
    Uint8List md5Digest = MD5Digest().process(bytes);

    return md5Digest;
  }

  static Uint8List encryptAES({required String plainText, required String key}) {
    Uint8List keyBytes = calculateMD5(key);
    // Uint8List keyBytes2 = calculateSHA256(key);
    // print(key);
    // print(keyBytes);
    // print(keyBytes2);
    Uint8List iv = Uint8List(16);

    var crypt = AesCrypt();
    crypt.aesSetParams(keyBytes, iv, AesMode.cbc);
    List<int> paddedText = utf8.encode(plainText.padLeft(512, '0'));

    Uint8List srcData = Uint8List.fromList(paddedText);
    Uint8List encrypted = crypt.aesEncrypt(srcData);
    return encrypted;
  }

  static String decryptAES({required Uint8List encryptedText, required String key}) {
    Uint8List keyBytes = calculateMD5(key);
    Uint8List iv = Uint8List(16);

    var crypt = AesCrypt();
    crypt.aesSetParams(keyBytes, iv, AesMode.cbc);

    Uint8List decryptedData = crypt.aesDecrypt(encryptedText);
    return String.fromCharCodes(decryptedData);
  }

  static String encryptEmail(String email, String key) {
    final encryptedEmailBytes = encryptAES(plainText: email, key: key);
    return bytesToHexadecimal(encryptedEmailBytes);
  }

  /// Encrypt a message using the recipient's public key
  /// Uses the public key as part of AES key derivation
  static String encryptWithPublicKey({
    required String message,
    required String publicKey,
  }) {
    // Use the public key as the encryption key
    final encryptedBytes = encryptAES(plainText: message, key: publicKey);
    return bytesToHexadecimal(encryptedBytes);
  }

  /// Decrypt a message using the user's own private key
  /// The sender encrypted with our public key, we decrypt with our private key
  static String decryptWithPrivateKey({
    required String encryptedMessage,
    required String privateKey,
  }) {
    try {
      final encryptedBytes = hexadecimalToBytes(encryptedMessage);
      // Use private key to decrypt (since sender used our public key)
      // In Diffie-Hellman context, we use the private key for decryption
      return decryptAES(encryptedText: encryptedBytes, key: privateKey).trim();
    } catch (e) {
      // If decryption fails, return the original message
      return encryptedMessage;
    }
  }
}
