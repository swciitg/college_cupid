import 'package:college_cupid/shared/diffie_hellman_constants.dart';

class DiffieHellman {
  static KeyPair generateKeyPair() {
    BigInt privateKey = BigInt.parse(generateRandomBits(1024), radix: 2);
    BigInt publicKey = generator.modPow(privateKey, primeNumber);
    return KeyPair(privateKey: privateKey, publicKey: publicKey);
  }

  static BigInt generateSharedSecret(
      {required BigInt myPrivateKey, required BigInt otherPublicKey}) {
    return otherPublicKey.modPow(myPrivateKey, primeNumber);
  }
}
