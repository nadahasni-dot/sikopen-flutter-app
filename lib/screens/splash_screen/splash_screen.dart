import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hello_world_app/screens/login_screen/login_screen.dart';
import 'package:hello_world_app/screens/main_screen/main_screen.dart';
import 'package:hello_world_app/utils/LoginPreferences.dart';

class SplashScreen extends StatelessWidget {
  static const routeName = '/';
  const SplashScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    _goToLogin(context, 3);

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
                    'SABINSOLUSI',
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
}
