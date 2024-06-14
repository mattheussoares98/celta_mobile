import 'package:platform_plus/platform_plus.dart';

class UserData {
  static String urlCCS = "";
  static String crossIdentity = '';
  static String userName = '';
  static String enterpriseName = '';
  static String? fcmToken = "";
  static String deviceType =
      PlatformPlus.platform.isIOSNative ? "iOS" : "android";
  static bool alreadyInsertedUsersInformations = false;
}
