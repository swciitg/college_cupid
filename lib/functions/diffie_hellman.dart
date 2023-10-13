import 'package:diffie_hellman/diffie_hellman.dart';

class DiffieHellman {
  final DhPkcs3Engine _dhEngine = DhPkcs3Engine.fromGroup(5);
  late BigInt privateKey, publicKey;

  DiffieHellman() {
    DhKeyPair keyPair = _dhEngine.generateKeyPair();
    privateKey = keyPair.privateKey;
    publicKey = keyPair.publicKey;
  }

  BigInt getSecretKey(BigInt otherPublicKey) {
    return _dhEngine.computeSecretKey(otherPublicKey);
  }
}