import 'dart:typed_data';
import 'dart:convert';
import 'package:aes_crypt_null_safe/aes_crypt_null_safe.dart';
import 'package:college_cupid/functions/diffie_hellman.dart';
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
    Uint8List iv = Uint8List(16);

    var crypt = AesCrypt();
    crypt.aesSetParams(keyBytes, iv, AesMode.cbc);
    List<int> plainBytes = utf8.encode(plainText);
    
    // Add PKCS7 padding: pad to multiple of 16 bytes
    int paddingLength = 16 - (plainBytes.length % 16);
    List<int> paddedBytes = plainBytes + List.filled(paddingLength, paddingLength);

    Uint8List srcData = Uint8List.fromList(paddedBytes);
    Uint8List encrypted = crypt.aesEncrypt(srcData);
    return encrypted;
  }

  static String decryptAES({required Uint8List encryptedText, required String key}) {
    Uint8List keyBytes = calculateMD5(key);
    Uint8List iv = Uint8List(16);

    var crypt = AesCrypt();
    crypt.aesSetParams(keyBytes, iv, AesMode.cbc);

    Uint8List decryptedData = crypt.aesDecrypt(encryptedText);
    
    // Remove PKCS7 padding: last byte indicates padding length
    if (decryptedData.isNotEmpty) {
      int paddingLength = decryptedData.last;
      if (paddingLength > 0 && paddingLength <= 16) {
        decryptedData = decryptedData.sublist(0, decryptedData.length - paddingLength);
      }
    }
    
    return String.fromCharCodes(decryptedData);
  }

  static String encryptEmail(String email, String key) {
    final encryptedEmailBytes = encryptAES(plainText: email, key: key);
    return bytesToHexadecimal(encryptedEmailBytes);
  }

  /// Diffie-Hellman encryption using shared secret
  static String encryptWithSharedSecret({
    required String message,
    required String myPrivateKey,
    required String theirPublicKey,
  }) {
    // Calculate shared secret: theirPublicKey ^ myPrivateKey (mod prime)
    final myPrivateBigInt = BigInt.parse(myPrivateKey);
    final theirPublicBigInt = BigInt.parse(theirPublicKey);
    final sharedSecret = DiffieHellman.generateSharedSecret(myPrivateKey: myPrivateBigInt, otherPublicKey: theirPublicBigInt);

    // Use shared secret as AES key
    final encryptedBytes = encryptAES(plainText: message, key: sharedSecret.toString());
    return bytesToHexadecimal(encryptedBytes);
  }

  /// Diffie-Hellman decryption using shared secret
  static String decryptWithSharedSecret({
    required String encryptedMessage,
    required String myPrivateKey,
    required String theirPublicKey,
  }) {
    try {
      final myPrivateBigInt = BigInt.parse(myPrivateKey);
      final theirPublicBigInt = BigInt.parse(theirPublicKey);
      final sharedSecret = DiffieHellman.generateSharedSecret(myPrivateKey: myPrivateBigInt, otherPublicKey: theirPublicBigInt);

      // Use shared secret as AES key
      final encryptedBytes = hexadecimalToBytes(encryptedMessage);
      return decryptAES(encryptedText: encryptedBytes, key: sharedSecret.toString()).trim();
    } catch (e) {
      return encryptedMessage;
    }
  }
}
