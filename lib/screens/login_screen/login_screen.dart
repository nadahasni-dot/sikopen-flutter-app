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
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          SingleChildScrollView(
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
                            style: TextStyle(
                                color: Colors.black87, fontSize: 26.0),
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
          Container(
            child: Stack(
              children: <Widget>[
                Positioned(
                    child: Align(
                        alignment: FractionalOffset.bottomCenter,
                        child: Column(
                          children: [
                            Text(
                              'version 1.0.3',
                              textAlign: TextAlign.center,
                            ),
                            TextButton(
                                onPressed: () {
                                  print('show version dialog');
                                  showVersionLogDialog(context);
                                },
                                child: Text('lihat log versi')),
                          ],
                        )))
              ],
            ),
          ),
        ],
      ),
    );
  }

  void showVersionLogDialog(BuildContext context) {
    // set up the buttons
    Widget cancelButton = FlatButton(
      child: Text("Close"),
      onPressed: () {
        print('closing dialog');
        Navigator.of(context).pop();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Version Log"),
      content: Container(
        child: SingleChildScrollView(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            Text(
              'versi 1.0.3 (2021/03/12):',
              style: TextStyle(fontSize: 10.0, color: Colors.green),
            ),
            Text(
              '- menyesuaikan pilihan dropdown absensi sesuai grup',
              style: TextStyle(fontSize: 10.0),
            ),
            Text(
              '- memperbaiki device registration',
              style: TextStyle(fontSize: 10.0),
            ),
            SizedBox(
              height: 10.0,
            ),
            Text(
              'versi 1.0.2 (2021/02/19):',
              style: TextStyle(fontSize: 10.0),
            ),
            Text(
              '- menambah pengajuan cuti',
              style: TextStyle(fontSize: 10.0),
            ),
            SizedBox(
              height: 10.0,
            ),
            Text(
              'versi 1.0.1 (2021/02/13):',
              style: TextStyle(fontSize: 10.0),
            ),
            Text(
              '- memperbaiki map slow response',
              style: TextStyle(fontSize: 10.0),
            ),
            Text(
              '- memperbaiki device registration',
              style: TextStyle(fontSize: 10.0),
            ),
            SizedBox(
              height: 10.0,
            ),
            Text(
              'versi 1.0.0 (2021/01/19):',
              style: TextStyle(fontSize: 10.0),
            ),
            Text(
              '- initial release',
              style: TextStyle(fontSize: 10.0),
            ),
          ]),
        ),
      ),
      actions: [
        cancelButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
