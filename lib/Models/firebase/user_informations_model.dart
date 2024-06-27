import '../../utils/utils.dart';

class UserInformationsModel {
  final String? fcmToken;
  final String userName;
  final String deviceType;
  final DateTime dateOfLastUpdatedInFirebase;

  UserInformationsModel({
    required this.fcmToken,
    required this.userName,
    required this.deviceType,
    required this.dateOfLastUpdatedInFirebase,
  });

  Map<String, dynamic> toJson() => {
        "fcmToken": fcmToken,
        "userName": userName.toLowerCase().removeWhiteSpaces(),
        "deviceType": deviceType,
        "dateOfLastUpdatedInFirebase":
            dateOfLastUpdatedInFirebase.toIso8601String(),
      };

  factory UserInformationsModel.fromJson(Map json) => UserInformationsModel(
        fcmToken: json["fcmToken"],
        userName: json["userName"],
        deviceType: json["deviceType"],
        dateOfLastUpdatedInFirebase:
            DateTime.parse(json["dateOfLastUpdatedInFirebase"]),
      );
}
