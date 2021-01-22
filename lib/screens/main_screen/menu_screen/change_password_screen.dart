import 'package:flutter/material.dart';

class ChangePasswordScreen extends StatefulWidget {
  ChangePasswordScreen({Key key}) : super(key: key);

  @override
  _ChangePasswordScreenState createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _formKey = GlobalKey<FormState>();

  bool _passwordVisibility1 = true;
  bool _passwordVisibility2 = true;
  bool _passwordVisibility3 = true;

  var _controller1 = TextEditingController();
  var _controller2 = TextEditingController();
  var _controller3 = TextEditingController();

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
    return Container(
      child: Padding(
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
                          color:
                              _passwordVisibility1 ? Colors.grey : Colors.blue,
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
                  onEditingComplete: () => FocusScope.of(context).nextFocus(),
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
                          color:
                              _passwordVisibility2 ? Colors.grey : Colors.blue,
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
                  onEditingComplete: () => FocusScope.of(context).nextFocus(),
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
                          color:
                              _passwordVisibility3 ? Colors.grey : Colors.blue,
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
                  onEditingComplete: () => FocusScope.of(context).nextFocus(),
                ),
                SizedBox(height: 10.0),
                ElevatedButton(
                  onPressed: () {
                    // Validate returns true if the form is valid, or false
                    // otherwise.
                    if (_formKey.currentState.validate()) {
                      _controller1.clear();
                      _controller2.clear();
                      _controller3.clear();

                      setState(() {
                        _passwordVisibility1 = true;
                        _passwordVisibility2 = true;
                        _passwordVisibility3 = true;
                      });
                    }
                  },
                  child: Text('Login'),
                ),
              ],
            )),
      ),
    );
  }

  @override
  void dispose() {
    _controller1.dispose();
    _controller2.dispose();
    _controller3.dispose();
    super.dispose();
  }
}
