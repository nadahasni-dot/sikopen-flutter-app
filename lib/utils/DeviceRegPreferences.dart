import 'package:shared_preferences/shared_preferences.dart';

class DeviceRegPreferences {
  static SharedPreferences prefs;

  static const String UID = 'UUID';
  static const String UID_STATUS = 'UID_STATUS';
  static const String UID_REQUEST = 'UID_REQUEST';

  static String getUid() {
    return prefs.getString(UID);
  }

  static bool getUidStatus() {
    return prefs.getBool(UID_STATUS) == null ? false : prefs.getBool(UID_STATUS);
  }

  static bool getUidRequestStatus() {
    return prefs.getBool(UID_REQUEST) == null ? false : prefs.getBool(UID_REQUEST);
  }
}
