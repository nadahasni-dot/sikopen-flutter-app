import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hello_world_app/screens/login_screen/form_login.dart';

class LoginScreen extends StatelessWidget {
  static const routeName = '/login';
  final String _passedString;
  // const LoginScreen({Key key}) : super(key: key);
  LoginScreen(this._passedString);

  @override
  Widget build(BuildContext context) {
    print(_passedString);

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                padding: const EdgeInsets.all(16.0),
                child: Card(
                  elevation: 3.0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(bottom: 20.0, top: 20.0),
                        child: Text(
                          'Login',
                          textAlign: TextAlign.center,
                          style:
                              TextStyle(color: Colors.black87, fontSize: 26.0),
                        ),
                      ),
                      Padding(
                          padding: EdgeInsets.only(left: 16.0, right: 16.0),
                          child: LoginForm()),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
