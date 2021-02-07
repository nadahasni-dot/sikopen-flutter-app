import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:hello_world_app/globals/ApiEndpoints.dart';
import 'package:hello_world_app/utils/DeviceRegPreferences.dart';
import 'package:hello_world_app/utils/LoginPreferences.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

import '../main_screen.dart';

class RegistrasiDeviceScreen extends StatefulWidget {
  RegistrasiDeviceScreen({Key key}) : super(key: key);

  @override
  _RegistrasiDeviceScreenState createState() => _RegistrasiDeviceScreenState();
}

class _RegistrasiDeviceScreenState extends State<RegistrasiDeviceScreen> {
  bool _isProcessingRequest = false;
  Widget _displayWidget;
  Timer _timer;
  String _errorType;
  String _errorText = 'Terjadi Error. Harap coba lagi.';

  @override
  void initState() {
    if (!DeviceRegPreferences.getUidRequestStatus()) {
      //jika belum request sama sekali
      _loadView();
    } else {
      //jika sudah request dan menunggu approval
      setState(() {
        _displayWidget = _getPendingWidget();
      });
      _checkUidActivation(context);
      _startRepeatingTask();
    }

    super.initState();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _loadView() {
    if (!DeviceRegPreferences.getUidRequestStatus()) {
      // jika belum melakukan request
      setState(() {
        _displayWidget = _getSubmitWidget();
      });
    } else {
      // jika sudah melakukan request namun pending
      setState(() {
        _displayWidget = _getPendingWidget();
      });
    }

    if (DeviceRegPreferences.getUidRequestStatus() &&
        DeviceRegPreferences.getUidStatus()) {
      // jika sudah request dan sudah diterima
      setState(() {
        _displayWidget = _getSuccessWidget();
      });
    }
  }

  void _checkUidActivation(BuildContext context) async {
    Dio _dio = new Dio();
    Response response;
    _dio.options.connectTimeout = 8000;
    _dio.options.receiveTimeout = 3000;

    setState(() {
      _isProcessingRequest = true;
    });

    try {
      response = await _dio.get(ApiEndpoints.GET_UID_ACTIVATION_STATUS +
          LoginPreferences.prefs
              .getInt(LoginPreferences.EMPLOYEE_ID)
              .toString() +
          '&uid=' +
          DeviceRegPreferences.getUid());

      setState(() {
        _isProcessingRequest = false;
      });

      if (response.statusCode == 200) {
        if (response.data['result'] > 0) {
          // jika uid sudah diaprove maka simpan status request true
          DeviceRegPreferences.prefs
              .setBool(DeviceRegPreferences.UID_STATUS, true);
          _stopRepeatingTask();
        } else {
          DeviceRegPreferences.prefs
              .setBool(DeviceRegPreferences.UID_STATUS, false);
        }

        print('check status: $response.data');
        _loadView();
      }
    } on DioError catch (e) {
      setState(() {
        _isProcessingRequest = false;
        _errorType = 'check';
        _displayWidget = _getErrorWidget();
      });

      // if error on sending request
      switch (e.type) {
        case DioErrorType.CONNECT_TIMEOUT:
          setState(() {
            _errorText = 'Connection time out. Harap periksa koneksi anda';
          });
          print('connection time out');
          return;
          break;
        case DioErrorType.DEFAULT:
          setState(() {
            _errorText = 'Network error. Harap periksa koneksi anda.';
          });
          print('default error');
          return;
          break;
        case DioErrorType.CANCEL:
          setState(() {
            _errorText = 'Request canceled';
          });
          print('canceled');
          return;
          break;
        default:
          print('another error occured');
      }

      // if error on status code
      switch (e.response.statusCode) {
        case 401:
          setState(() {
            _errorText = 'Autentikasi error';
          });
          return;
          break;
        case 500:
          setState(() {
            _errorText = 'Server Error. Harap coba beberapa saat lagi';
          });
          return;
          break;
        default:
          setState(() {
            _errorText = 'Terjadi Error. Harap coba beberapa saat lagi';
          });
          return;
      }
    }
  }

  void _submitUidtoRegister(BuildContext context) async {
    Dio _dio = new Dio();
    Response response;
    _dio.options.connectTimeout = 8000;
    _dio.options.receiveTimeout = 3000;

    setState(() {
      _isProcessingRequest = true;
    });

    try {
      response = await _dio.post(ApiEndpoints.POST_UID_REGISTRATION, data: {
        'employee_id':
            LoginPreferences.prefs.getInt(LoginPreferences.EMPLOYEE_ID),
        'uid': DeviceRegPreferences.getUid(),
      });

      setState(() {
        _isProcessingRequest = false;
      });

      if (response.statusCode == 200) {
        if (response.data['status'] == true) {
          //jika sudah berhasil submit uid maka simpan status request true
          DeviceRegPreferences.prefs
              .setBool(DeviceRegPreferences.UID_REQUEST, true);
          _startRepeatingTask();
        } else {
          DeviceRegPreferences.prefs
              .setBool(DeviceRegPreferences.UID_REQUEST, false);
        }

        print('submit status: $response.data');
        _loadView();
      }
    } on DioError catch (e) {
      setState(() {
        _isProcessingRequest = false;
        _errorType = 'submit';
        _displayWidget = _getErrorWidget();
      });

      // if error on sending request
      switch (e.type) {
        case DioErrorType.CONNECT_TIMEOUT:
          setState(() {
            _errorText = 'Connection time out. Harap periksa koneksi anda';
          });
          print('connection time out');
          return;
          break;
        case DioErrorType.DEFAULT:
          setState(() {
            _errorText = 'Network error. Harap periksa koneksi anda.';
          });
          print('default error');
          return;
          break;
        case DioErrorType.CANCEL:
          setState(() {
            _errorText = 'Request canceled.';
          });
          print('canceled');
          return;
          break;
        default:
          setState(() {
            _errorText = 'another error occured: ' +
                e.toString() +
                e.response.toString();
          });
          print(
              'another error occured: ' + e.toString() + e.response.toString());
      }

      // if error on status code
      switch (e.response.statusCode) {
        case 401:
          setState(() {
            _errorText = 'Autentikasi error';
          });
          return;
          break;
        case 500:
          setState(() {
            _errorText = 'Server Error. Harap coba beberapa saat lagi';
          });
          return;
          break;
        default:
          setState(() {
            _errorText = 'Terjadi Error. Harap coba beberapa saat lagi';
          });
          return;
      }
    }
  }

  void _startRepeatingTask() {
    _timer = Timer.periodic(
        Duration(seconds: 5), (Timer t) => _checkUidActivation(context));
  }

  void _stopRepeatingTask() {
    _timer.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: _isProcessingRequest,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [_displayWidget],
      ),
    );
  }

  Widget _getSubmitWidget() {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Card(
        elevation: 10.0,
        color: Colors.orange,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: EdgeInsets.all(10.0),
              child: Text(
                'UUID anda belum terdaftar. Harap melakukan pengajuan registrasi device',
                style: TextStyle(color: Colors.white),
              ),
            ),
            Text(
              'Installation ID:',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white),
            ),
            SizedBox(height: 10.0),
            Padding(
              padding: EdgeInsets.only(left: 10.0, right: 10.0),
              child: Container(
                color: Colors.white,
                child: Text(
                  DeviceRegPreferences.getUid(),
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.black87),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: RaisedButton(
                  color: Colors.white,
                  textColor: Colors.black87,
                  onPressed: () {
                    _submitUidtoRegister(context);
                  },
                  child: Text(
                    'PENGAJUAN REGISTRASI DEVICE',
                  )),
            )
          ],
        ),
      ),
    );
  }

  Widget _getPendingWidget() {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Card(
        elevation: 10.0,
        color: Colors.lightBlue,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: EdgeInsets.all(10.0),
              child: Text(
                'UUID anda sedang dalam proses pengajuan. Harap menunggu konfirmasi dari admin.',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _getSuccessWidget() {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Card(
        elevation: 10.0,
        color: Colors.green,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: EdgeInsets.all(10.0),
              child: Text(
                'UUID anda telah diverifikasi admin. Anda dapat melanjutkan ke menu utama.',
                style: TextStyle(color: Colors.white),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: RaisedButton(
                  color: Colors.white,
                  textColor: Colors.black87,
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.pushNamed(context, MainScreen.routeName);
                  },
                  child: Text(
                    'MENUJU MENU UTAMA',
                  )),
            )
          ],
        ),
      ),
    );
  }

  Widget _getErrorWidget() {
    return Container(
      height: MediaQuery.of(context).size.height - 200,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            _errorText,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 10.0),
          RaisedButton(
            color: Colors.grey[400],
            child: Text('Coba Lagi'),
            onPressed: () {
              switch (_errorType) {
                case 'submit':
                  _submitUidtoRegister(context);
                  print('submit error retry');
                  break;
                case 'check':
                  print('check error retry');
                  _checkUidActivation(context);
                  break;
                default:                  
                  print('another error retry');
              }
            },
          )
        ],
      ),
    );
  }
}
