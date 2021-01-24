import 'dart:convert';

// import 'package:crypto/crypto.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:hello_world_app/bloc/login_bloc.dart';
import 'package:hello_world_app/models/login_model.dart';
import 'package:hello_world_app/models/login_repository.dart';
import 'package:hello_world_app/networking/api_response.dart';
import 'package:hello_world_app/screens/main_screen/main_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Create a Form widget.
class LoginForm extends StatefulWidget {
  @override
  LoginFormState createState() {
    return LoginFormState();
  }
}

// Create a corresponding State class.
// This class holds data related to the form.
class LoginFormState extends State<LoginForm> {
  LoginBloc _loginBloc;

  @override
  void initState() {
    super.initState();
    _loginBloc = LoginBloc();
  }

  TextEditingController usernameController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();

  final _formKey = GlobalKey<FormState>();
  bool _passwordVisibility = true;
  bool _isLoading = false;

  void saveData(int employeeId, String personName, String username) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setInt("employee_id", employeeId);
    pref.setString("person_name", personName);
    pref.setString("username", username);
  }

  void _onLoading() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          child: new Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              new CircularProgressIndicator(),
              new Text("Loading"),
            ],
          ),
        );
      },
    );
    if (_isLoading == false) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          TextFormField(
            controller: usernameController,
            textAlignVertical: TextAlignVertical.bottom,
            onEditingComplete: () => FocusScope.of(context).nextFocus(),
            decoration: InputDecoration(hintText: 'Username'),
            keyboardType: TextInputType.text,
            validator: (value) {
              if (value.isEmpty) {
                return 'Please enter username';
              }
              return null;
            },
          ),
          SizedBox(
            height: 10.0,
          ),
          TextFormField(
            controller: passwordController,
            textAlignVertical: TextAlignVertical.bottom,
            decoration: InputDecoration(
                hintText: 'Password',
                suffixIcon: GestureDetector(
                  onTap: () {
                    _togglePasswordVisibility();
                  },
                  child: Icon(
                    _passwordVisibility
                        ? Icons.visibility_off
                        : Icons.visibility,
                    color: _passwordVisibility ? Colors.grey : Colors.blue,
                  ),
                )),
            obscureText: _passwordVisibility,
            keyboardType: TextInputType.text,
            enableSuggestions: false,
            validator: (value) {
              if (value.isEmpty) {
                return 'Please enter password';
              }
              return null;
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: ElevatedButton(
              onPressed: () {
                if (_formKey.currentState.validate()) {
                  Scaffold.of(context)
                      .showSnackBar(SnackBar(content: Text('Processing Data')));

                  _loginBloc.fetchDataLogin(
                      usernameController.text,
                      md5
                          .convert(utf8.encode(passwordController.text))
                          .toString());
                  usernameController.clear();
                  passwordController.clear();
                }
              },
              child: Text('Login'),
            ),
          ),
          StreamBuilder<ApiResponse<PostLogin>>(
              stream: _loginBloc.loginDataStream,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  switch (snapshot.data.status) {
                    case Status.LOADING:
                      return Loading(
                        loadingMessage: snapshot.data.message,
                      );
                      // TODO: Handle this case.
                      break;
                    case Status.COMPLETED:
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        saveData(
                            snapshot.data.data.employee_id,
                            snapshot.data.data.person_name,
                            snapshot.data.data.user_name);
                        Navigator.pop(context);
                        Navigator.pushNamed(context, MainScreen.routeName);
                      });
                      break;
                    case Status.ERROR:
                      return Container(
                        margin: EdgeInsets.all(5),
                        child: Center(
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                              snapshot.data.message,
                              style: TextStyle(color: Colors.red),
                            ),
                          ),
                        ),
                      );
                      break;
                  }
                }
                return Container();
              })
        ],
      ),
    );
  }

  void _togglePasswordVisibility() {
    setState(() {
      _passwordVisibility = !_passwordVisibility;
    });
  }
}

class Loading extends StatelessWidget {
  final String loadingMessage;

  const Loading({Key key, this.loadingMessage}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: EdgeInsets.fromLTRB(0, 10, 0, 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              loadingMessage,
              textAlign: TextAlign.center,
              style: TextStyle(
//              color: Colors.lightGreen,
                fontSize: 20,
              ),
            ),
            SizedBox(height: 24),
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.lightGreen),
            ),
          ],
        ),
      ),
    );
  }
}
