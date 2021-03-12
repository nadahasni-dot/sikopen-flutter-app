import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:hello_world_app/globals/ApiEndpoints.dart';
import 'package:hello_world_app/screens/login_screen/login_screen.dart';
import 'package:hello_world_app/screens/main_screen/main_screen.dart';
import 'package:hello_world_app/utils/DeviceRegPreferences.dart';
import 'package:hello_world_app/utils/LoginPreferences.dart';
import 'package:uuid/uuid.dart';

class SplashScreen extends StatelessWidget {
  static const routeName = '/';
  const SplashScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    _goToLogin(context, 5);
    _checkUid();

    return Scaffold(
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                height: MediaQuery.of(context).size.height,
                decoration: BoxDecoration(color: Colors.blue),
                child: Center(
                  child: Text(
                    'ABSENSI ONLINE',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 26.0,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _goToLogin(BuildContext context, int seconds) {
    Timer(Duration(seconds: seconds), () {
      Navigator.of(context).pop();
      LoginPreferences.prefs.getBool(LoginPreferences.LOGGED_IN) == true
          ? Navigator.pushNamed(context, MainScreen.routeName)
          : Navigator.pushNamed(context, LoginScreen.routeName,
              arguments: {'passedString': 'samlekom'});
    });
  }

  void _checkUid() {
    // ? kalau belum pernah create uid
    if (DeviceRegPreferences.getUid() == null) {
      DeviceRegPreferences.prefs
          .setBool(DeviceRegPreferences.UID_STATUS, false);
      DeviceRegPreferences.prefs
          .setBool(DeviceRegPreferences.UID_REQUEST, false);
      DeviceRegPreferences.prefs
          .setString(DeviceRegPreferences.UID, Uuid().v1());
    }

    // ? cek jika sudah login
    if (LoginPreferences.prefs.getBool(LoginPreferences.LOGGED_IN) == true) {
      // ? jika sudah login maka cek aktivasi uid
      print('sudah login');
      _checkUidActivation();
    }

    print(DeviceRegPreferences.getUid());
    print(DeviceRegPreferences.getUidStatus());
    print(DeviceRegPreferences.getUidRequestStatus());
  }

  void _checkUidActivation() async {
    Dio _dio = new Dio();
    Response response;
    _dio.options.connectTimeout = 8000;
    _dio.options.receiveTimeout = 3000;

    try {
      response = await _dio.get(ApiEndpoints.GET_UID_ACTIVATION_STATUS +
          LoginPreferences.prefs
              .getInt(LoginPreferences.EMPLOYEE_ID)
              .toString() +
          '&uid=' +
          DeviceRegPreferences.getUid());

      if (response.statusCode == 200) {
        if (response.data['result'] > 0) {
          // ? jika uid sudah diaprove maka simpan status request true
          print('uid sesuai');
          DeviceRegPreferences.prefs
              .setBool(DeviceRegPreferences.UID_STATUS, true);
        } else {
          print(
              'uid tidak sesuai dengan database. uid telah terdaftar di device lain');

          // ? jika uid tidak sama maka paksa user logout, dan submit uid kembali
          DeviceRegPreferences.prefs
              .setBool(DeviceRegPreferences.UID_REQUEST, false);
          LoginPreferences.prefs.setBool(LoginPreferences.LOGGED_IN, false);
          // DeviceRegPreferences.prefs
          //     .setBool(DeviceRegPreferences.UID_STATUS, false);
        }

        print('check status: $response.data');
        print('status after check ' +
            DeviceRegPreferences.getUidStatus().toString());
      }
    } on DioError catch (e) {
      // if error on sending request
      switch (e.type) {
        case DioErrorType.CONNECT_TIMEOUT:
          print('connection time out');
          return;
          break;
        case DioErrorType.DEFAULT:
          print('default error');
          return;
          break;
        case DioErrorType.CANCEL:
          print('canceled');
          return;
          break;
        default:
          print('another error occured');
      }
    }
  }
}
