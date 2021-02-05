import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hello_world_app/globals/ApiEndpoints.dart';
import 'package:hello_world_app/screens/main_screen/menu_screen/pangajuan_ijin/edit_ketidakhadiran_screen.dart';
import 'package:hello_world_app/utils/LoginPreferences.dart';
import 'package:hello_world_app/screens/main_screen/menu_screen/pangajuan_ijin/ketidakhadiran.dart';
import 'package:progress_dialog/progress_dialog.dart';

class Dataketidakhadiran extends StatefulWidget {
  @override
  _DataketidakhadiranState createState() => _DataketidakhadiranState();
}

class _DataketidakhadiranState extends State<Dataketidakhadiran> {
  GlobalKey<ScaffoldState> scaffoldState = new GlobalKey();
  List<Ketidakhadiran> dataKetidakhadiran = new List();
  ProgressDialog pr;
  bool _dataLoaded = false;
  Dio _dio = new Dio();
  String _responseText = "Fetching data ...";

  Future<String> postKirimDataKetidakhadiran(int kode) async {
    Response response;
    String returnData;
    _dio.options.connectTimeout = 8000;
    _dio.options.receiveTimeout = 3000;

    try {
      response = await _dio.post(
        ApiEndpoints.POST_KIRIM_KETIDAKHADIRAN + kode.toString(),
      );

      if (response.statusCode == 200) {
        print('berhasil mengirim = ' + response.toString());
        _getDataKetidakhadiran();
        returnData = "Berhasil mengirim data";
      }
    } on DioError catch (e) {
      // if error on sending request
      switch (e.type) {
        case DioErrorType.CONNECT_TIMEOUT:
          returnData = "Connection time out pada data ketidakhadiran";
          break;
        case DioErrorType.DEFAULT:
          return "Terjadi error. Harap coba beberapa saat lagi";
          break;
        case DioErrorType.CANCEL:
          returnData = "Request canceled";
          break;
        default:
          returnData = "another error occured";
      }
      switch (e.response.statusCode) {
        case 401:
          returnData = "Username atau password anda tidak sesuai";
          break;
        case 500:
          returnData = "Server Error. Harap coba beberapa saat lagi";
          break;
        default:
          returnData = '"Terjadi Error. Harap coba beberapa saat lagi"';
      }
    }
    return returnData;
  }

  Future<String> deleteDataKetidakhadiran(int kode) async {
    Response response;
    _dio.options.connectTimeout = 8000;
    _dio.options.receiveTimeout = 3000;

    try {
      response = await _dio.delete(
        ApiEndpoints.DELETE_KETIDAKHADIRAN + kode.toString(),
      );

      setState(() {
        // _isProcessingRequest = false;
      });

      if (response.statusCode == 200) {
        print('berhasil menghapus = ' + response.toString());
        _getDataKetidakhadiran();
        return "Berhasil menghapus data";
      }
    } on DioError catch (e) {
      // if error on sending request
      switch (e.type) {
        case DioErrorType.CONNECT_TIMEOUT:
          return "Connection time out pada data ketidakhadiran";
          break;
        case DioErrorType.DEFAULT:
          return "Terjadi error. Harap coba beberapa saat lagi";
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

  Future<String> _getDataKetidakhadiran() async {
    Response response;
    _dio.options.connectTimeout = 20000;
    _dio.options.receiveTimeout = 3000;

    try {
      response = await _dio.get(
        ApiEndpoints.GET_DATA_KETIDAKHADIRAN +
            LoginPreferences.prefs
                .getInt(LoginPreferences.EMPLOYEE_ID)
                .toString(),
      );

      List<Ketidakhadiran> tList = List();
      if (response.statusCode == 200) {
        for (var i = 0; i < response.data.length - 1; i++) {
          tList.add(Ketidakhadiran.fromJson(response.data[i.toString()]));
        }

        setState(() {
          dataKetidakhadiran = tList;
          _dataLoaded = true;
        });
        return "Load data sukses";
      }
    } on DioError catch (e) {
      // if error on sending request
      switch (e.type) {
        case DioErrorType.CONNECT_TIMEOUT:
          _responseText = "Connection time out";
          return "Connection time out pada data ketidakhadiran";
          break;
        case DioErrorType.DEFAULT:
          _responseText = "Terjadi error. Harap coba beberapa saat lagi";
          return "Terjadi error. Harap coba beberapa saat lagi";
          break;
        case DioErrorType.CANCEL:
          _responseText = "Request canceled";
          return "Request canceled";
          break;
        default:
          _responseText = "another error occured";
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
    } catch (e) {
      print(e);
    }
  }

  _displaySnackBar(BuildContext context, String text) {
    final snackBar = SnackBar(content: Text(text));
    scaffoldState.currentState.showSnackBar(snackBar);
  }

  @override
  void initState() {
    _getDataKetidakhadiran().then((value) => print(value));
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
    super.initState();
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    pr = new ProgressDialog(context);
    pr = new ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false, showLogs: false);

    return DefaultTabController(
      length: 1,
      child: Scaffold(
          key: scaffoldState,
          appBar: AppBar(
            title: Text('Data Ketidakhadiran'),
          ),
          body: _buildCard()),
    );
  }

  _buildCard() {
    if (_dataLoaded == true) {
      return TabBarView(
        children: <Widget>[
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: DataTable(
                  columns: <DataColumn>[
                    DataColumn(label: Text("Jenis Absensi")),
                    DataColumn(label: Text('Tanggal Awal')),
                    DataColumn(label: Text('Tanggal Akhir')),
                    DataColumn(label: Text("Keterangan")),
                    DataColumn(label: Text("Action")),
                  ],
                  rows: dataKetidakhadiran
                      .map((data) => DataRow(cells: [
                            DataCell(Text(data.fk_tidak_hadir)),
                            DataCell(Text(data.tglAwal)),
                            DataCell(Text(data.tglAkhir)),
                            DataCell(Text(data.keterangan)),
                            DataCell(Row(
                              children: [
                                if (data.acc_status == 0) ...[
                                  Container(
                                      margin: EdgeInsets.fromLTRB(5, 2, 5, 2),
                                      child: SizedBox(
                                          width: 50,
                                          height: 50,
                                          child: Container(
                                            child: Material(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              color: Colors.transparent,
                                              child: InkWell(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  splashColor: Colors.amber,
                                                  onTap: () {
                                                    SystemChrome
                                                        .setPreferredOrientations([
                                                      DeviceOrientation
                                                          .landscapeRight,
                                                      DeviceOrientation
                                                          .landscapeLeft,
                                                      DeviceOrientation
                                                          .portraitUp,
                                                      DeviceOrientation
                                                          .portraitDown,
                                                    ]);
                                                    Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (context) =>
                                                              EditKetidakhadiran(
                                                                  kode: data
                                                                      .tdkhadir_id),
                                                        )).then((value) {
                                                      SystemChrome
                                                          .setPreferredOrientations([
                                                        DeviceOrientation
                                                            .landscapeRight,
                                                        DeviceOrientation
                                                            .landscapeLeft
                                                      ]);
                                                      _getDataKetidakhadiran();
                                                    });
                                                    print(data.tdkhadir_id);
                                                  },
                                                  child: Center(
                                                    child: Text(
                                                      "Edit",
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  )),
                                            ),
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                gradient: LinearGradient(
                                                    colors: [
                                                      Colors.green,
                                                      Colors.green[300]
                                                    ],
                                                    begin: Alignment.topCenter,
                                                    end: Alignment
                                                        .bottomCenter)),
                                          ))),
                                  Container(
                                      margin: EdgeInsets.fromLTRB(5, 2, 5, 2),
                                      child: SizedBox(
                                          width: 50,
                                          height: 50,
                                          child: Container(
                                            child: Material(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              color: Colors.transparent,
                                              child: InkWell(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  splashColor: Colors.amber,
                                                  onTap: () {
                                                    pr.show();
                                                    postKirimDataKetidakhadiran(
                                                            data.tdkhadir_id)
                                                        .then((value) {
                                                      pr.hide();
                                                      _displaySnackBar(
                                                          context, value);
                                                    });
                                                  },
                                                  child: Center(
                                                    child: Text(
                                                      "Kirim",
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  )),
                                            ),
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                gradient: LinearGradient(
                                                    colors: [
                                                      Colors.blue,
                                                      Colors.blue[300]
                                                    ],
                                                    begin: Alignment.topCenter,
                                                    end: Alignment
                                                        .bottomCenter)),
                                          ))),
                                  Container(
                                      margin: EdgeInsets.fromLTRB(5, 2, 5, 2),
                                      child: SizedBox(
                                          width: 50,
                                          height: 50,
                                          child: Container(
                                            child: Material(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              color: Colors.transparent,
                                              child: InkWell(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  splashColor: Colors.amber,
                                                  onTap: () {
                                                    pr.show();
                                                    deleteDataKetidakhadiran(
                                                            data.tdkhadir_id)
                                                        .then((value) {
                                                      pr.hide();
                                                      _displaySnackBar(
                                                          context, value);
                                                    });
                                                  },
                                                  child: Center(
                                                    child: Text(
                                                      "Hapus",
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  )),
                                            ),
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                gradient: LinearGradient(
                                                    colors: [
                                                      Colors.red,
                                                      Colors.red[300]
                                                    ],
                                                    begin: Alignment.topCenter,
                                                    end: Alignment
                                                        .bottomCenter)),
                                          ))),
                                ],
                                if (data.acc_status == 1)
                                  Text("Menunggu Keputusan"),
                                if (data.acc_status == 3) Text("Disetujui"),
                              ],
                            )),
                          ]))
                      .toList()),
            ),
          ),
        ],
      );
    } else {
      return Center(
        child: Text(_responseText),
      );
    }
  }
}
