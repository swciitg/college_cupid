class DriveData {
  final String diffieHellmanPrivateKey;
  final List<String> crushEmailList;

  DriveData({
    required this.crushEmailList,
    required this.diffieHellmanPrivateKey,
  });

  factory DriveData.fromJSON(Map<String, dynamic> json) {
    return DriveData(
      crushEmailList: (json['crushEmailList'] as List<dynamic>).cast<String>(),
      diffieHellmanPrivateKey: json['diffieHellmanPrivateKey'] ?? '',
    );
  }

  Map<String, dynamic> toJSON() {
    return {
      'crushEmailList': crushEmailList,
      'diffieHellmanPrivateKey': diffieHellmanPrivateKey,
    };
  }
}
