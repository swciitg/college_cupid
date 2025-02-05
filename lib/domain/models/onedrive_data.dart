class OneDriveData {
  final String diffieHellmanPrivateKey;
  final List<String> crushEmailList;

  OneDriveData({
    required this.crushEmailList,
    required this.diffieHellmanPrivateKey,
  });

  factory OneDriveData.fromJSON(Map<String, dynamic> json) {
    return OneDriveData(
      crushEmailList: json['crushEmailList'].cast<String>(),
      diffieHellmanPrivateKey: json['diffieHellmanPrivateKey'],
    );
  }

  Map<String, dynamic> toJSON() {
    return {
      'crushEmailList': crushEmailList,
      'diffieHellmanPrivateKey': diffieHellmanPrivateKey,
    };
  }
}
