import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hello_world_app/globals/ApiEndpoints.dart';
import 'package:hello_world_app/utils/LoginPreferences.dart';
import 'package:hello_world_app/utils/ketidakhadiran.dart';

class Dataketidakhadiran extends StatefulWidget {
  @override
  _DataketidakhadiranState createState() => _DataketidakhadiranState();
}

class _DataketidakhadiranState extends State<Dataketidakhadiran> {
  GlobalKey<ScaffoldState> scaffoldState = new GlobalKey();
  List<Ketidakhadiran> dataKetidakhadiran = new List();
  Dio _dio = new Dio();

  void postKirimDataKetidakhadiran(int kode) async {
    Response response;
    _dio.options.connectTimeout = 8000;
    _dio.options.receiveTimeout = 3000;

    setState(() {
      // _isProcessingRequest = true;
    });

    // scaffoldState.currentState
    //     .showSnackBar(SnackBar(content: new Text('Processing data  ...')));

    try {
      response = await _dio.post(
        ApiEndpoints.POST_KIRIM_KETIDAKHADIRAN + kode.toString(),
      );

      setState(() {
        // _isProcessingRequest = false;
      });

      if (response.statusCode == 200) {
        print('berhasil mengirim = ' + response.toString());
        _getDataKetidakhadiran();
        setState(() {
          // dataTidakhadir.addAll(tList);
        });
      }
    } on DioError catch (e) {
      setState(() {
        print(e);
        // _isProcessingRequest = false;
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

  void deleteDataKetidakhadiran(int kode) async {
    Response response;
    _dio.options.connectTimeout = 8000;
    _dio.options.receiveTimeout = 3000;

    setState(() {
      // _isProcessingRequest = true;
    });

    // scaffoldState.currentState
    //     .showSnackBar(SnackBar(content: new Text('Processing data  ...')));

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
        setState(() {
          // dataTidakhadir.addAll(tList);
        });
      }
    } on DioError catch (e) {
      setState(() {
        print(e);
        // _isProcessingRequest = false;
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

  void _getDataKetidakhadiran() async {
    Response response;
    _dio.options.connectTimeout = 8000;
    _dio.options.receiveTimeout = 3000;

    setState(() {
      // _isProcessingRequest = true;
    });

    // scaffoldState.currentState
    //     .showSnackBar(SnackBar(content: new Text('Processing data  ...')));

    try {
      response = await _dio.get(
        ApiEndpoints.GET_DATA_KETIDAKHADIRAN +
            LoginPreferences.prefs
                .getInt(LoginPreferences.EMPLOYEE_ID)
                .toString(),
      );

      setState(() {
        // _isProcessingRequest = false;
      });
      List<Ketidakhadiran> tList = List();
      if (response.statusCode == 200) {
        for (var i = 0; i < response.data.length - 1; i++) {
          tList.add(Ketidakhadiran.fromJson(response.data[i.toString()]));
        }

        setState(() {
          dataKetidakhadiran = tList;
        });
      }
    } on DioError catch (e) {
      setState(() {
        print(e);
        // _isProcessingRequest = false;
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
  void initState() {
    _getDataKetidakhadiran();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 1,
      child: Scaffold(
        key: scaffoldState,
        appBar: AppBar(
          title: Text('Dataketidakhadiran'),
        ),
        body: TabBarView(
          children: <Widget>[
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: DataTable(
                    columns: <DataColumn>[
                      DataColumn(label: Text("Jenis Absensi")),
                      DataColumn(label: Text('Tanggal Awal')),
                      DataColumn(label: Text('Tanggal AKhir')),
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
                                                        BorderRadius.circular(
                                                            10),
                                                    splashColor: Colors.amber,
                                                    onTap: () {
                                                      print(data.tdkhadir_id);
                                                    },
                                                    child: Center(
                                                      child: Text(
                                                        "Edit",
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
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
                                                      begin:
                                                          Alignment.topCenter,
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
                                                        BorderRadius.circular(
                                                            10),
                                                    splashColor: Colors.amber,
                                                    onTap: () {
                                                      postKirimDataKetidakhadiran(
                                                          data.tdkhadir_id);
                                                    },
                                                    child: Center(
                                                      child: Text(
                                                        "Kirim",
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
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
                                                      begin:
                                                          Alignment.topCenter,
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
                                                        BorderRadius.circular(
                                                            10),
                                                    splashColor: Colors.amber,
                                                    onTap: () {
                                                      deleteDataKetidakhadiran(
                                                          data.tdkhadir_id);
                                                    },
                                                    child: Center(
                                                      child: Text(
                                                        "Hapus",
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
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
                                                      begin:
                                                          Alignment.topCenter,
                                                      end: Alignment
                                                          .bottomCenter)),
                                            ))),
                                  ],
                                  if (data.acc_status == 1)
                                    Text("Menunggu Keputusan"),
                                  if (data.acc_status == 2) Text("Disetujui"),
                                ],
                              )),
                            ]))
                        .toList()),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
