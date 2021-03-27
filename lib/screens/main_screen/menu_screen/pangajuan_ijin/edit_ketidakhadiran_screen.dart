import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hello_world_app/globals/ApiEndpoints.dart';
import 'package:hello_world_app/screens/main_screen/menu_screen/pangajuan_ijin/dropdown_ijin.dart';
import 'package:hello_world_app/utils/LoginPreferences.dart';
import 'package:hello_world_app/screens/main_screen/menu_screen/pangajuan_ijin/ketidakhadiran.dart';
import 'package:intl/intl.dart';
import 'package:progress_dialog/progress_dialog.dart';

class EditKetidakhadiran extends StatefulWidget {
  int kode;
  EditKetidakhadiran({Key key, @required this.kode}) : super(key: key);
  @override
  _EditKetidakhadiranState createState() => _EditKetidakhadiranState();
}

class _EditKetidakhadiranState extends State<EditKetidakhadiran> {
  @override
  void setState(fn) {
    if (this.mounted) {
      super.setState(fn);
    }
  }

  bool __dataLoaded = false;
  var _formKey;
  GlobalKey<ScaffoldState> scaffoldState = new GlobalKey();
  List<DropdownIjin> ijin = new List();
  List<DropdownMenuItem<DropdownIjin>> _dropDownIjinItems;
  DropdownIjin _currentIjin;
  Ketidakhadiran dataKetidakhadiran = new Ketidakhadiran();
  String _responseText = "Fetching data ...";
  ProgressDialog pr;
  Dio _dio = new Dio();

  TextEditingController tanggalAwalController;
  TextEditingController tanggalAkhirController;
  TextEditingController namaPegawaiController;
  TextEditingController keteranganController;

  List<DropdownMenuItem<DropdownIjin>> getDropDownMenuItems() {
    List<DropdownMenuItem<DropdownIjin>> items = new List();
    for (DropdownIjin data in ijin) {
      items.add(new DropdownMenuItem(
        value: data,
        child: new Text(data.ijinNama),
      ));
    }
    return items;
  }

  void changedDropDwonItem(DropdownIjin selectedItem) {
    setState(() {
      _currentIjin = selectedItem;
    });
  }

  Future<String> _postEditDataKetidakhadiranPegawai() async {
    print("Kode yg diupdate = " + widget.kode.toString());
    Response response;
    _dio.options.connectTimeout = 8000;
    _dio.options.receiveTimeout = 3000;

    try {
      response = await _dio
          .post(ApiEndpoints.POST_UBAH_DATA_KETIDAKHADIRAN_PEGAWAI, data: {
        'tdkhadir_id': widget.kode,
        'pegawai_id':
            LoginPreferences.prefs.getInt(LoginPreferences.EMPLOYEE_ID),
        'mulai': tanggalAwalController.text,
        'akhir': tanggalAkhirController.text,
        'fk_tidak_hadir': _currentIjin.ijinId,
        'keterangan': keteranganController.text
      });

      if (response.statusCode == 200) {
        print(response);
        setState(() {});
        return "Edit data sukses";
      }
    } on DioError catch (e) {
      // if error on sending request
      switch (e.type) {
        case DioErrorType.CONNECT_TIMEOUT:
          return "Connection time out";
          break;
        case DioErrorType.DEFAULT:
          print("Terjadi error. Harap coba beberapa saat lagi");
          break;
        case DioErrorType.CANCEL:
          return "Request canceled";
          break;
        default:
          return "another error occured";
      }
      switch (e.response.statusCode) {
        case 401:
          return "Username atau password anda tidak sesuai";
          break;
        case 500:
          return "Server Error. Harap coba beberapa saat lagi";
          break;
        default:
          return '"Terjadi Error. Harap coba beberapa saat lagi"';
      }
    }
  }

  void _getDropdownIjin(BuildContext context) async {
    Dio _dio = new Dio();
    Response response;
    _dio.options.connectTimeout = 8000;
    _dio.options.receiveTimeout = 3000;

    try {
      response = await _dio.get(ApiEndpoints.GET_DROPDOWN_IJIN);

      if (response.statusCode == 200) {
        print('berhasil mendapat data jenis dropdown ijin');

        List<DropdownIjin> tempList = new List();

        for (var i = 0; i < response.data.length - 1; i++) {
          tempList.add(DropdownIjin.fromJson(response.data[i.toString()]));
        }

        setState(() {
          ijin = tempList;
          _dropDownIjinItems = getDropDownMenuItems();
          // _currentIjin = _dropDownIjinItems[0].value;
        });

        _getDataKetidakhadiranPegawai();

        print('load dropdown sukses');
      }
    } on DioError catch (e) {
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

  Future<String> _getDataKetidakhadiranPegawai() async {
    print("Kode yg dikirimkan = " + widget.kode.toString());
    Response response;
    _dio.options.connectTimeout = 8000;
    _dio.options.receiveTimeout = 3000;

    try {
      response = await _dio.get(
        ApiEndpoints.GET_DATA_KETIDAKHADIRAN_PEGAWAI + widget.kode.toString(),
      );

      if (response.statusCode == 200) {
        dataKetidakhadiran = Ketidakhadiran.fromJson(response.data['0']);

        DateTime tglAwal =
            new DateFormat("yyyy-MM-dd").parse(dataKetidakhadiran.tglAwal);
        DateTime tglAkhir =
            new DateFormat("yyyy-MM-dd").parse(dataKetidakhadiran.tglAkhir);
        tanggalAwalController = TextEditingController(
            text: DateFormat('dd-MM-yyyy').format(tglAwal).toString());
        tanggalAkhirController = TextEditingController(
            text: DateFormat('dd-MM-yyyy').format(tglAkhir).toString());

        print('fk_tidak_hadir get: ' + dataKetidakhadiran.fk_tidak_hadir);

        for (DropdownIjin data in ijin) {
          if (data.ijinNama ==
              dataKetidakhadiran.fk_tidak_hadir.toUpperCase()) {
            print("id sama terpilih: " + data.toString());
            _currentIjin = data;
          }
        }
        // _currentIjin = dataKetidakhadiran.fk_tidak_hadir;

        namaPegawaiController = TextEditingController(
            text:
                LoginPreferences.prefs.getString(LoginPreferences.PERSON_NAME));
        keteranganController =
            TextEditingController(text: dataKetidakhadiran.keterangan);
        __dataLoaded = true;
        _responseText = "Load data sukses";
        setState(() {});
        return "Load data sukses";
      }
    } on DioError catch (e) {
      // if error on sending request
      switch (e.type) {
        case DioErrorType.CONNECT_TIMEOUT:
          _responseText = "Connection time out";
          return "Connection time out";
          break;
        case DioErrorType.DEFAULT:
          _responseText = "Terjadi error. Harap coba beberapa saat lagi";
          print("Terjadi error. Harap coba beberapa saat lagi");
          break;
        case DioErrorType.CANCEL:
          _responseText = "Request dibatalkan";
          return "Request canceled";
          break;
        default:
          return "another error occured";
      }
      switch (e.response.statusCode) {
        case 401:
          _responseText = "Data tidak ditemukan";
          return "Data tidak ditemukan";
          break;
        case 500:
          _responseText = "Server Error. Harap coba beberapa saat lagi";
          return "Server Error. Harap coba beberapa saat lagi";
          break;
        default:
          _responseText = "Terjadi Error. Harap coba beberapa saat lagi";
          return '"Terjadi Error. Harap coba beberapa saat lagi"';
      }
    }
  }

  @override
  void initState() {
    _formKey = GlobalKey<FormState>();
    _getDropdownIjin(context);
    // _dropDownIjinItems = getDropDownMenuItems();
    // _currentIjin = _dropDownIjinItems[0].value;
    // _getDataKetidakhadiranPegawai();
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]);
    super.initState();
  }

  _displaySnackBar(BuildContext context, String text) {
    final snackBar = SnackBar(content: Text(text));
    scaffoldState.currentState.showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 1,
      child: Scaffold(
          key: scaffoldState,
          appBar: AppBar(
            title: Text("Edit data"),
          ),
          body: _buildCard()),
    );
  }

  _selectDate(BuildContext context, TextEditingController controller) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime(DateTime.now().year + 5));
    if (picked != null) {
      setState(() {
        controller.text = "${picked.day}-${picked.month}-${picked.year}";
      });
    }
  }

  _buildCard() {
    if (__dataLoaded == true) {
      pr = new ProgressDialog(context);
      pr = new ProgressDialog(context,
          type: ProgressDialogType.Normal,
          isDismissible: false,
          showLogs: false);
      return TabBarView(
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              children: [
                Card(
                  margin: EdgeInsets.all(10),
                  elevation: 5,
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.all(5),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          Container(
                            margin: EdgeInsets.fromLTRB(0, 10, 10, 20),
                            child: Text(
                              "Edit Ketidakhadiran",
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                          ),
                          IgnorePointer(
                            child: TextFormField(
                              controller: namaPegawaiController,
                              decoration: InputDecoration(
                                  icon: Icon(Icons.person),
                                  labelText: "Nama Pegawai"),
                            ),
                          ),
                          Row(
                            children: [
                              Container(
                                margin: EdgeInsets.fromLTRB(0, 10, 15, 5),
                                child: Icon(
                                  Icons.list,
                                ),
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width * 0.5,
                                child: DropdownButton(
                                  value: _currentIjin,
                                  items: _dropDownIjinItems,
                                  onChanged: changedDropDwonItem,
                                  isExpanded: true,
                                ),
                              ),
                            ],
                          ),
                          GestureDetector(
                            onTap: () =>
                                _selectDate(context, tanggalAwalController),
                            child: Container(
                              color: Colors.transparent,
                              child: IgnorePointer(
                                child: TextFormField(
                                    validator: (value) {
                                      if (value.isEmpty) {
                                        return 'Harap memilih tanggal awal';
                                      }
                                      return null;
                                    },
                                    controller: tanggalAwalController,
                                    decoration: InputDecoration(
                                        icon: Icon(Icons.date_range),
                                        labelText: "Tanggal Awal")),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () =>
                                _selectDate(context, tanggalAkhirController),
                            child: Container(
                              color: Colors.transparent,
                              child: IgnorePointer(
                                child: TextFormField(
                                    validator: (value) {
                                      if (value.isEmpty) {
                                        return 'Harap memilih tanggal akhir';
                                      }
                                      return null;
                                    },
                                    controller: tanggalAkhirController,
                                    decoration: InputDecoration(
                                        icon: Icon(Icons.date_range),
                                        labelText: "Tanggal Akhir")),
                              ),
                            ),
                          ),
                          TextFormField(
                              controller: keteranganController,
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Harap masukkan keterangan';
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                  icon: Icon(Icons.message),
                                  labelText: "Keterangan")),
                          Container(
                              margin: EdgeInsets.fromLTRB(10, 30, 10, 30),
                              child: SizedBox(
                                  width: MediaQuery.of(context).size.width,
                                  height: 50,
                                  child: Container(
                                    child: Material(
                                      borderRadius: BorderRadius.circular(20),
                                      color: Colors.transparent,
                                      child: InkWell(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          splashColor: Colors.amber,
                                          onTap: () {
                                            _postEditDataKetidakhadiranPegawai()
                                                .then((value) {
                                              _displaySnackBar(context, value);
                                            });
                                          },
                                          child: Center(
                                            child: Text(
                                              "SIMPAN",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          )),
                                    ),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15),
                                        gradient: LinearGradient(
                                            colors: [
                                              Colors.blue,
                                              Colors.blue[300]
                                            ],
                                            begin: Alignment.topCenter,
                                            end: Alignment.bottomCenter)),
                                  ))),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      );
    } else {
      return Center(
        child: Text(_responseText),
      );
    }
  }
}
