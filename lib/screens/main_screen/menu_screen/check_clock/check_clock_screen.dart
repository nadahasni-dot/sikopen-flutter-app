import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hello_world_app/globals/ApiEndpoints.dart';
import 'package:hello_world_app/screens/main_screen/menu_screen/check_clock/mesin.dart';
import 'package:hello_world_app/screens/main_screen/menu_screen/check_clock/shift.dart';
import 'package:hello_world_app/screens/main_screen/menu_screen/check_clock_dinas_luar/loading_check_clock.dart';
import 'package:hello_world_app/utils/LoginPreferences.dart';
import 'package:intl/intl.dart';
import 'package:latlong/latlong.dart';
import 'package:location_permissions/location_permissions.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class CheckClockScreen extends StatefulWidget {
  CheckClockScreen({Key key}) : super(key: key);

  @override
  _CheckClockScreenState createState() => _CheckClockScreenState();
}

class _CheckClockScreenState extends State<CheckClockScreen> {
  Stream<bool> locationEventStream;
  String _timeString, _selectedType;
  bool _isProcessingRequest = false;
  Timer _timer;
  int _ccType;
  int mesin_id = -1;
  bool snackbarshow = true;
  Position _currentPosition;
  LocationPermission permission;
  bool serviceEnabled;
  final double zoomClose = 17.0;
  LatLng _defaultLocation = LatLng(-6.1275785, 106.8356448);
  final MapController _mapController = MapController();
  List<Shift> lshift = new List();
  List<Mesin> ldataMesin = List();
  bool islocationLoaded = false;
  bool locationLoaded = false;
  bool determinelocationLoaded = false;
  Dio _dio = new Dio();
  double jarak;

  void _postPresence(BuildContext context, int ccType, int employeeId,
      String lat, String lng, int mesin_id) async {
    Response response;
    _dio.options.connectTimeout = 20000;
    _dio.options.receiveTimeout = 3000;

    setState(() {
      _isProcessingRequest = true;
    });

    try {
      response = await _dio.post(ApiEndpoints.POST_PRESENCE, data: {
        'cc_type': ccType,
        'employee_id': employeeId,
        'mesin_id': mesin_id,
        'lat': lat,
        'lng': lng
      });

      if (response.statusCode == 200) {
        _showSuccessAlert(context);
        _isProcessingRequest = false;
      }
    } on DioError catch (e) {
      switch (e.type) {
        case DioErrorType.CONNECT_TIMEOUT:
          Scaffold.of(context).showSnackBar(SnackBar(
              content: Text("Connection time out. Harap periksa koneksi anda"),
              duration: Duration(seconds: 3)));
          print('connection time out');
          return;
          break;
        case DioErrorType.DEFAULT:
          Scaffold.of(context).showSnackBar(SnackBar(
              content: Text("Tidak ada koneksi. Harap periksa internet anda"),
              duration: Duration(seconds: 3)));
          print('default error');
          return;
          break;
        case DioErrorType.CANCEL:
          Scaffold.of(context).showSnackBar(SnackBar(
              content: Text("Request canceled"),
              duration: Duration(seconds: 3)));
          print('canceled');
          return;
          break;
        default:
          print('another error occured');
      }

      switch (e.response.statusCode) {
        case 400:
          Scaffold.of(context).showSnackBar(SnackBar(
              content: Text("Gagal submit presensi. Harap coba kembali"),
              duration: Duration(seconds: 3)));
          return;
          break;
        case 500:
          Scaffold.of(context).showSnackBar(SnackBar(
              content: Text("Server Error. Harap coba beberapa saat lagi"),
              duration: Duration(seconds: 3)));
          return;
          break;
        default:
          Scaffold.of(context).showSnackBar(SnackBar(
              content: Text("Terjadi Error. Harap coba beberapa saat lagi"),
              duration: Duration(seconds: 3)));
          return;
      }
    }
  }

  void setShift() {
    lshift.add(new Shift.setShift(1, "Non Shift Masuk"));
    lshift.add(new Shift.setShift(2, "Non Shift Pulang"));
    lshift.add(new Shift.setShift(3, "Pagi Masuk"));
    lshift.add(new Shift.setShift(4, "Pagi Pulang"));
    lshift.add(new Shift.setShift(5, "Siang Masuk"));
    lshift.add(new Shift.setShift(6, "Siang Pulang"));
    lshift.add(new Shift.setShift(7, "Malam Masuk"));
    lshift.add(new Shift.setShift(8, "Malam Pulang"));
    lshift.add(new Shift.setShift(9, "Lembur Masuk"));
    lshift.add(new Shift.setShift(10, "Lembur Pulang"));
    _selectedType = lshift[0].nama_cc;
    _ccType = lshift[0].value;
  }

  Future<String> _getMesin() async {
    Response response;
    _dio.options.connectTimeout = 20000;
    _dio.options.receiveTimeout = 3000;

    try {
      response = await _dio.get(ApiEndpoints.GET_MESIN_POINT);

      List<Mesin> lmesin = List();
      if (response.statusCode == 200) {
        for (var i = 0; i < response.data.length; i++) {
          lmesin.add(Mesin.fromJson(response.data[i]));
        }
        print(lmesin[0].mesin_nama);
        setState(() {
          ldataMesin = lmesin;
          // _dataLoaded = true;
        });
        return "Load data sukses";
      }
    } on DioError catch (e) {
      // if error on sending request
      switch (e.type) {
        case DioErrorType.CONNECT_TIMEOUT:
          // _responseText = "Connection time out";
          return "Connection time out pada data ketidakhadiran";
          break;
        case DioErrorType.DEFAULT:
          // _responseText = "Terjadi error. Harap coba beberapa saat lagi";
          return "Terjadi error. Harap coba beberapa saat lagi";
          break;
        case DioErrorType.CANCEL:
          // _responseText = "Request canceled";
          return "Request canceled";
          break;
        default:
          // _responseText = "another error occured";
          return "another error occured";
      }
      switch (e.response.statusCode) {
        case 401:
          // _responseText = "Data tidak ditemukan";
          return "Data tidak ditemukan";
          break;
        case 500:
          // _responseText = "Server Error. Harap coba beberapa saat lagi";
          return "Server Error. Harap coba beberapa saat lagi";
          break;
        default:
          // _responseText = "Terjadi Error. Harap coba beberapa saat lagi";
          return '"Terjadi Error. Harap coba beberapa saat lagi"';
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> checkGPS() async {
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      _showGpsAlert(context);
    }
  }

  // listen location changes
  StreamSubscription<Position> _positionStreamSubscription;

  Future<Position> _determinePosition(BuildContext context) async {
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permantly denied, we cannot request permissions.');
    }

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.whileInUse &&
          permission != LocationPermission.always) {
        return Future.error(
            'Location permissions are denied (actual value: $permission).');
      }
    }

    try {
      return await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.bestForNavigation,
          forceAndroidLocationManager: true);
    } catch (e) {
      print("Error pada get current position " + e.toString());
    }
  }

  void _toggleListening() {
    if (_positionStreamSubscription == null) {
      final positionStream = Geolocator.getPositionStream(
          forceAndroidLocationManager: true,
          desiredAccuracy: LocationAccuracy.bestForNavigation,
          intervalDuration: Duration(seconds: 1));
      _positionStreamSubscription = positionStream.handleError((error) {
        _positionStreamSubscription.cancel();
        _positionStreamSubscription = null;
      }).listen((position) {
        if (this.mounted) {
          print("_positionStream : " + position.toString());
          setState(() => _currentPosition = position);
          islocationLoaded = true;
          _mapController.move(
              LatLng(_currentPosition.latitude, _currentPosition.longitude),
              zoomClose);
          _getDistance();
        }
      });
      _positionStreamSubscription.pause();
    }

    setState(() {
      if (_positionStreamSubscription.isPaused) {
        _positionStreamSubscription.resume();
      } else {
        _positionStreamSubscription.pause();
      }
    });
  }

  // to show alert gps not active
  void _showGpsAlert(BuildContext context) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
              title: Text("GPS"),
              content: Text("GPS not detected. Please activate it."),
              actions: [
                TextButton(
                  child: Text('Go to settings'),
                  onPressed: () {
                    Geolocator.openLocationSettings();
                    Navigator.pop(context);
                  },
                ),
              ],
            ));
  }

  void _showSuccessAlert(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text("Success"),
              content: Text(
                  "Berhasil melakukan presensi ($_selectedType) at $_timeString"),
              actions: [
                TextButton(
                  child: Text('Ok'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ));
  }

  String _formatDateTime(DateTime dateTime) {
    return DateFormat('dd/MM/yyyy hh:mm:ss').format(dateTime);
  }

  void _getTime() {
    final DateTime now = DateTime.now();
    final String formattedDateTime = _formatDateTime(now);
    if (this.mounted) {
      setState(() {
        _timeString = formattedDateTime;
      });
    }
  }

  void _getDistance() {
    if (ldataMesin.length != 0 && _currentPosition != null) {
      for (var i = 0; i < ldataMesin.length; i++) {
        double tmpJarak = Geolocator.distanceBetween(
            _currentPosition.latitude,
            _currentPosition.longitude,
            double.parse(ldataMesin[i].mesin_latitude),
            double.parse(ldataMesin[i].mesin_longitude));
        if (jarak > tmpJarak) {
          jarak = tmpJarak;
          mesin_id = ldataMesin[i].mesin_id;
        }
      }
    }
  }

  Future<void> loopLocation() async {
    if (!islocationLoaded) {
      try {
        Geolocator.getLastKnownPosition().then((value) {
          setState(() {
            _defaultLocation = LatLng(value.latitude, value.longitude);
            locationLoaded = true;
            _currentPosition = value;
            if (value.latitude != null) {
              islocationLoaded = true;
              _getDistance();
            }
            _mapController.move(
                LatLng(_currentPosition.latitude, _currentPosition.longitude),
                zoomClose);
            if (ldataMesin.length != 0) {
              _getDistance();
            }
            print("getLastknownLocation looplocation" +
                value.latitude.toString());
          });
        }).catchError(
            (error) => print(error.toString() + " null pada lastKnown"));
      } catch (e) {
        print("Error pada get current position " + e.toString());
      }
    }
  }

  Future<void> getLocationPerSecond() async {
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      print("determinelocation false <<<<<<<<<<<<<<<<");
      determinelocationLoaded = false;
      if (snackbarshow == true) {
        Scaffold.of(context).showSnackBar(SnackBar(
            content: Text("Harap hidupkan GPS !"),
            duration: Duration(seconds: 3)));
        snackbarshow = false;
      }

      setState(() {
        locationLoaded = false;
      });
    } else {
      if (snackbarshow == false) {
        Scaffold.of(context).showSnackBar(SnackBar(
            content: Text("GPS hidup kembali"),
            duration: Duration(seconds: 3)));
        snackbarshow = true;
      }
      setState(() {
        locationLoaded = true;
      });
      if (determinelocationLoaded == false) {
        print("determinelocation hidup <<<<<<<<<<<<<<<<");
        determinelocationLoaded = true;
        _determinePosition(context).then((position) {
          print(position.toString());
          setState(() {
            islocationLoaded = true;
            locationLoaded = true;
            _currentPosition = position;
            if (locationLoaded) {
              _mapController.move(
                  new LatLng(position.latitude, position.longitude), zoomClose);
              _getDistance();
            }
          });
          _toggleListening();
        }).catchError((error) =>
            print(error.toString() + "move pada determinepositionthen"));
      }
    }
  }

  @override
  void initState() {
    checkGPS();

    _getMesin().then((value) {
      if (locationLoaded) {
        _getDistance();
      }
    });

    jarak = 999999999999999;

    setShift();

    _timeString = _formatDateTime(DateTime.now());
    super.initState();
    _timer = Timer.periodic(Duration(seconds: 1), (Timer t) {
      _getTime();
      loopLocation();
      getLocationPerSecond();
    });
  }

  @override
  void dispose() {
    // dispose location listen on widget dispose
    if (_positionStreamSubscription != null) {
      _positionStreamSubscription.cancel();
      _positionStreamSubscription = null;
    }
    // cancel timer on dispose
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
        inAsyncCall: _isProcessingRequest, child: _buildMap());
  }

  _buildMap() {
    if (locationLoaded) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
              padding: EdgeInsets.all(8.0),
              child: Card(
                elevation: 10.0,
                color: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0, bottom: 4.0),
                      child: Text(
                        _timeString,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Divider(thickness: 0.5, color: Colors.black87),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 4.0, left: 16.0, right: 16.0, bottom: 4.0),
                      child: Text(
                        'NIP: ${LoginPreferences.prefs.getInt(LoginPreferences.EMPLOYEE_ID).toString()}',
                        textAlign: TextAlign.left,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Divider(thickness: 0.5, color: Colors.black87),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 4.0, left: 16.0, right: 16.0, bottom: 4.0),
                      child: Text(
                        'NAMA: ${LoginPreferences.prefs.getString(LoginPreferences.PERSON_NAME)}',
                        textAlign: TextAlign.left,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Divider(thickness: 0.5, color: Colors.black87),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 4.0, left: 16.0, right: 16.0, bottom: 4.0),
                      child: Row(
                        children: [
                          Text(
                            'Jarak: ',
                            textAlign: TextAlign.left,
                          ),
                          Text(
                            jarak.ceil().toString() + " m",
                            textAlign: TextAlign.left,
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      child: Divider(
                        thickness: 0.5,
                        color: Colors.black87,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          left: 16.0, right: 16.0, bottom: 10.0),
                      child: DropdownButton(
                        isExpanded: true,
                        value: _selectedType,
                        items: lshift.map((value) {
                          return DropdownMenuItem(
                            child: Text(value.nama_cc),
                            value: value.nama_cc,
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            for (var i = 0; i < lshift.length; i++) {
                              if (lshift[i].nama_cc == value) {
                                _ccType = lshift[i].value;
                                print(_ccType);
                              }
                            }
                            _selectedType = value;
                          });
                        },
                      ),
                    )
                  ],
                ),
              )),
          Expanded(
            child: Stack(
              children: [
                FlutterMap(
                    mapController: _mapController,
                    options: new MapOptions(
                        center: _currentPosition == null
                            ? _defaultLocation
                            : new LatLng(_currentPosition.latitude,
                                _currentPosition.longitude),
                        zoom: zoomClose,
                        interactive: false),
                    layers: [
                      new TileLayerOptions(
                          urlTemplate:
                              "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                          subdomains: ['a', 'b', 'c']),
                      new MarkerLayerOptions(markers: _buildPoint()),
                    ]),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: ElevatedButton(
                        onPressed: () {
                          if (jarak < 100) {
                            _postPresence(
                                context,
                                _ccType,
                                LoginPreferences.prefs
                                    .getInt(LoginPreferences.EMPLOYEE_ID),
                                _currentPosition.latitude.toString(),
                                _currentPosition.longitude.toString(),
                                mesin_id);
                          }
                        },
                        child: Text('Submit Presensi'),
                      ),
                    ),
                  ],
                )
              ],
            ),
          )
        ],
      );
    } else {
      return LoadingCheckClock();
    }
  }

  _buildPoint() {
    List<Marker> marker = List();
    marker.add(
      Marker(
        width: 80.0,
        height: 80.0,
        point: _currentPosition == null
            ? _defaultLocation
            : new LatLng(_currentPosition.latitude, _currentPosition.longitude),
        builder: (ctx) => new Container(
          child: Icon(
            Icons.person_pin_circle,
            color: Colors.red,
          ),
        ),
      ),
    );
    if (ldataMesin.length != 0) {
      for (var i = 0; i < ldataMesin.length; i++) {
        marker.add(Marker(
            width: 80.0,
            height: 80.0,
            point: new LatLng(double.parse(ldataMesin[i].mesin_latitude),
                double.parse(ldataMesin[i].mesin_longitude)),
            builder: (context) => new Container(
                  child: Icon(
                    Icons.person_pin_circle,
                    color: Colors.red,
                  ),
                )));
      }
      return marker;
    } else {
      return marker;
    }
  }
}
