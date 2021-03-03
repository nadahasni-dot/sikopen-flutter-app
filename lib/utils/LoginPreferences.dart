import 'package:shared_preferences/shared_preferences.dart';

class LoginPreferences {
  static SharedPreferences prefs;

  static const String EMPLOYEE_NIP = 'EMPLOYE_NIP';
  static const String EMPLOYEE_ID = 'EMPLOYEE_ID';
  static const String USER_ID = 'USER_ID';
  static const String USER_NAME = 'USER_NAME';
  static const String USER_STATUS = 'USER_STATUS';
  static const String PERSON_NAME = 'PERSON_NAME';
  static const String PAR_ID = 'PAR_ID';
  static const String USER_SALT_ENCRYPT = 'USER_SALT_ENCRYPT';
  static const String LOGGED_IN = 'LOGGED_IN';
  static const String EMPLOYEE_GROUP_ID = 'EMPLOYE_GROUP_ID';
}
