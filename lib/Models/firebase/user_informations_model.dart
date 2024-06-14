class UserInformations {
  final String? fcmToken;
  final String userName;
  final String deviceType;
  final DateTime dateOfLastUpdatedInFirebase;

  UserInformations({
    required this.fcmToken,
    required this.userName,
    required this.deviceType,
    required this.dateOfLastUpdatedInFirebase,
  });

  Map<String, dynamic> toJson() => {
        "fcmToken": fcmToken,
        "userName": userName,
        "deviceType": deviceType,
        "dateOfLastUpdatedInFirebase":
            dateOfLastUpdatedInFirebase.toIso8601String(),
      };

  factory UserInformations.fromJson(Map json) => UserInformations(
        fcmToken: json["fcmToken"],
        userName: json["userName"],
        deviceType: json["deviceType"],
        dateOfLastUpdatedInFirebase:
            DateTime.parse(json["dateOfLastUpdatedInFirebase"]),
      );
}
