class FirebaseClientModel {
  final String enterpriseName;
  final String urlCCS;
  FirebaseClientModel({
    this.enterpriseName = "undefined",
    required this.urlCCS,
  });

  Map<String, dynamic> toJson() {
    return {
      'enterpriseName':
          enterpriseName.toLowerCase().replaceAll(RegExp(r'\s+'), ''),
      'urlCCS': urlCCS.toLowerCase().replaceAll(RegExp(r'\s+'), ''),
    };
  }
}