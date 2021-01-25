import 'package:flutter/material.dart';
import 'package:hello_world_app/globals/ApiEndpoints.dart';
import 'package:hello_world_app/helper/Md5Converter.dart';
import 'package:hello_world_app/screens/main_screen/main_screen.dart';
import 'package:hello_world_app/utils/LoginPreferences.dart';
import 'package:dio/dio.dart';

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
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  //
  // Note: This is a GlobalKey<FormState>,
  // not a GlobalKey<MyCustomFormState>.
  var _formKey;
  var usernameController;
  var passwordController;

  bool _passwordVisibility;
  bool _isProcessingRequest;

  @override
  void initState() {
    super.initState();
    _formKey = GlobalKey<FormState>();
    usernameController = TextEditingController();
    passwordController = TextEditingController();

    _passwordVisibility = true;
    _isProcessingRequest = false;
  }

  @override
  void dispose() {
    super.dispose();
    usernameController.dispose();
    passwordController.dispose();
  }

  void _postLogin(
      BuildContext context, String username, String password) async {
    Dio _dio = new Dio();
    Response response;
    _dio.options.connectTimeout = 8000;
    _dio.options.receiveTimeout = 3000;

    setState(() {
      _isProcessingRequest = true;
    });

    Scaffold.of(context).showSnackBar(SnackBar(
      content: Text("Logging in ..."),
    ));

    try {
      response = await _dio.post(ApiEndpoints.POST_LOGIN,
          data: {'username': username, 'password': password});

      setState(() {
        _isProcessingRequest = false;
      });      

      if (response.statusCode == 200) {
        LoginPreferences.prefs.setInt(LoginPreferences.EMPLOYEE_ID, response.data['payload'][0]['employee_id']);
        LoginPreferences.prefs.setInt(LoginPreferences.USER_ID, response.data['payload'][0]['user_id']);
        LoginPreferences.prefs.setString(LoginPreferences.USER_NAME, response.data['payload'][0]['user_name']);
        LoginPreferences.prefs.setBool(LoginPreferences.USER_STATUS, response.data['payload'][0]['user_status']);
        LoginPreferences.prefs.setString(LoginPreferences.PERSON_NAME, response.data['payload'][0]['person_name']);
        LoginPreferences.prefs.setInt(LoginPreferences.PAR_ID, response.data['payload'][0]['par_id']);
        LoginPreferences.prefs.setString(LoginPreferences.USER_SALT_ENCRYPT, response.data['payload'][0]['user_salt_encrypt']);
        LoginPreferences.prefs.setBool(LoginPreferences.LOGGED_IN, true);

        Navigator.pop(context);
        Navigator.pushNamed(context, MainScreen.routeName);
      }
    } on DioError catch (e) {
      setState(() {
        _isProcessingRequest = false;
      });

      // if error on sending request
      switch (e.type) {
        case DioErrorType.CONNECT_TIMEOUT:
          Scaffold.of(context).showSnackBar(SnackBar(
            content: Text("Connection time out. Harap periksa koneksi anda"),
          ));
          print('connection time out');
          return;
          break;
        case DioErrorType.DEFAULT:
          Scaffold.of(context).showSnackBar(SnackBar(
            content: Text("Terjadi error. Harap coba beberapa saat lagi"),
          ));
          print('default error');
          return;
          break;
        case DioErrorType.CANCEL:
          Scaffold.of(context).showSnackBar(SnackBar(
            content: Text("Request canceled"),
          ));
          print('canceled');
          return;
          break;
        default:
          print('another error occured');
      }

      // if error on status code
      switch (e.response.statusCode) {
        case 401:
          Scaffold.of(context).showSnackBar(SnackBar(
            content: Text("Username atau password anda tidak sesuai"),
          ));
          return;
          break;
        case 500:
          Scaffold.of(context).showSnackBar(SnackBar(
            content: Text("Server Error. Harap coba beberapa saat lagi"),
          ));
          return;
          break;
        default:
          Scaffold.of(context).showSnackBar(SnackBar(
            content: Text("Terjadi Error. Harap coba beberapa saat lagi"),
          ));
          return;
      }
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
                // if still on process dont do anything
                if(_isProcessingRequest) {
                  return;
                }

                if (_formKey.currentState.validate()) {
                  _postLogin(context, usernameController.text,
                      Md5Converter.generateMd5(passwordController.text));

                  usernameController.clear();
                  passwordController.clear();
                }
              },
              child: Text('Login'),
            ),
          ),
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
