import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:hello_world_app/globals/ApiEndpoints.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:hello_world_app/helper/Md5Converter.dart';

class ChangePasswordScreen extends StatefulWidget {
  ChangePasswordScreen({Key key}) : super(key: key);

  @override
  _ChangePasswordScreenState createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _formKey = GlobalKey<FormState>();

  bool _passwordVisibility1;
  bool _passwordVisibility2;
  bool _passwordVisibility3;
  bool _isProcessingRequest;

  var _controller1;
  var _controller2;
  var _controller3;

  @override
  void initState() {    
    super.initState();
    _passwordVisibility1 = true;
    _passwordVisibility2 = true;
    _passwordVisibility3 = true;
    _isProcessingRequest = false;

    _controller1 = TextEditingController();
    _controller2 = TextEditingController();
    _controller3 = TextEditingController();
  }

  void _postChangePassword(BuildContext context, int userId, String oldPassword,
      String newPassword) async {
    Dio _dio = new Dio();
    Response response;
    _dio.options.connectTimeout = 8000;
    _dio.options.receiveTimeout = 3000;

    setState(() {
      _isProcessingRequest = true;
    });

    try {
      response = await _dio.post(ApiEndpoints.POST_CHANGE_PASSWORD, data: {
        'employee_id': userId,
        'password_old': oldPassword,
        'password_new': newPassword
      });

      setState(() {
        _isProcessingRequest = false;
      });

      if (response.statusCode == 200) {
        Scaffold.of(context).showSnackBar(SnackBar(
          content: Text("Berhasil merubah password"),
        ));
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
            content: Text("Password lama anda tidak sesuai"),
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

  void _togglePasswordVisibility(int inputPassword) {
    setState(() {
      switch (inputPassword) {
        case 1:
          _passwordVisibility1 = !_passwordVisibility1;
          break;
        case 2:
          _passwordVisibility2 = !_passwordVisibility2;
          break;
        case 3:
          _passwordVisibility3 = !_passwordVisibility3;
          break;
        default:
          return;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: _isProcessingRequest,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      TextFormField(
                        controller: _controller1,
                        textAlignVertical: TextAlignVertical.bottom,
                        decoration: InputDecoration(
                            hintText: 'Password Lama',
                            suffixIcon: GestureDetector(
                              onTap: () {
                                _togglePasswordVisibility(1);
                              },
                              child: Icon(
                                _passwordVisibility1
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                color: _passwordVisibility1
                                    ? Colors.grey
                                    : Colors.blue,
                              ),
                            )),
                        obscureText: _passwordVisibility1,
                        keyboardType: TextInputType.text,
                        enableSuggestions: false,
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Harap masukkan password lama';
                          }
                          return null;
                        },
                        onEditingComplete: () =>
                            FocusScope.of(context).nextFocus(),
                      ),
                      SizedBox(height: 10.0),
                      TextFormField(
                        controller: _controller2,
                        textAlignVertical: TextAlignVertical.bottom,
                        decoration: InputDecoration(
                            hintText: 'Password Baru',
                            suffixIcon: GestureDetector(
                              onTap: () {
                                _togglePasswordVisibility(2);
                              },
                              child: Icon(
                                _passwordVisibility2
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                color: _passwordVisibility2
                                    ? Colors.grey
                                    : Colors.blue,
                              ),
                            )),
                        obscureText: _passwordVisibility2,
                        keyboardType: TextInputType.text,
                        enableSuggestions: false,
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Harap masukkan password baru';
                          }
                          return null;
                        },
                        onEditingComplete: () =>
                            FocusScope.of(context).nextFocus(),
                      ),
                      SizedBox(height: 10.0),
                      TextFormField(
                        controller: _controller3,
                        textAlignVertical: TextAlignVertical.bottom,
                        decoration: InputDecoration(
                            hintText: 'Ulangi Password',
                            suffixIcon: GestureDetector(
                              onTap: () {
                                _togglePasswordVisibility(3);
                              },
                              child: Icon(
                                _passwordVisibility3
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                color: _passwordVisibility3
                                    ? Colors.grey
                                    : Colors.blue,
                              ),
                            )),
                        obscureText: _passwordVisibility3,
                        keyboardType: TextInputType.text,
                        enableSuggestions: false,
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Harap masukkan pengulangan password';
                          }

                          if (_controller2.text != _controller3.text) {
                            return 'Pengulangan password tidak sama';
                          }

                          return null;
                        },
                        onEditingComplete: () =>
                            FocusScope.of(context).nextFocus(),
                      ),
                      SizedBox(height: 10.0),
                      ElevatedButton(
                        onPressed: () {
                          // Validate returns true if the form is valid, or false
                          // otherwise.
                          if (_formKey.currentState.validate()) {
                            setState(() {
                              _passwordVisibility1 = true;
                              _passwordVisibility2 = true;
                              _passwordVisibility3 = true;
                            });                            

                            _postChangePassword(
                                context,
                                7,
                                Md5Converter.generateMd5(_controller1.text),
                                Md5Converter.generateMd5(_controller2.text));

                            _controller1.clear();
                            _controller2.clear();
                            _controller3.clear();
                          }
                        },
                        child: Text('Login'),
                      ),
                    ],
                  )),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller1.dispose();
    _controller2.dispose();
    _controller3.dispose();
  }
}
