import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hello_world_app/globals/ApiEndpoints.dart';
import 'package:hello_world_app/screens/main_screen/menu_screen/laporan_absensi/data_absensi.dart';
import 'package:hello_world_app/utils/LoginPreferences.dart';

class DataAbsensiBulanan extends StatefulWidget {
  String date;
  int kode;
  DataAbsensiBulanan({Key key, @required this.date, @required this.kode})
      : super(key: key);
  @override
  _DataAbsensiBulananState createState() => _DataAbsensiBulananState();
}

class _DataAbsensiBulananState extends State<DataAbsensiBulanan> {
  bool _dataLoaded = false;
  Dio _dio = new Dio();
  String _responseText = "Fetching data ...";
  List<DataAbsensi> dataAbsensi = List();

  Future<String> getDataAbsensi(int kd) async {
    Response response;
    String returnData;
    _dio.options.connectTimeout = 18000;
    _dio.options.receiveTimeout = 3000;
    print(ApiEndpoints.GET_DATA_ABSENSI_BULANAN + "${widget.date}");
    try {
      if (kd == 1) {
        response = await _dio.get(
          ApiEndpoints.GET_DATA_ABSENSI_BULANAN + "${widget.date}",
        );
      } else {
        response = await _dio.get(
          ApiEndpoints.GET_DATA_ABSENSI_PERIODIK + "${widget.date}",
        );
      }

      if (response.statusCode == 200) {
        // print(response);
        List<DataAbsensi> tList = List();
        for (var i = 0; i < response.data.length - 1; i++) {
          tList.add(DataAbsensi.fromJson(response.data[i.toString()]));
        }
        print(tList[0].hari);
        setState(() {
          dataAbsensi = tList;
          _dataLoaded = true;
        });
        // print('berhasil mengirim = ' + response.toString());
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

  @override
  void initState() {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.landscapeRight, DeviceOrientation.landscapeLeft]);
    print(widget.date);
    getDataAbsensi(widget.kode);
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
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
    return DefaultTabController(
      length: 1,
      child: Scaffold(
          appBar: AppBar(
            title: Text('Data Absensi'),
          ),
          body: _buildData()),
    );
  }

  _buildData() {
    if (_dataLoaded == true) {
      return TabBarView(
        children: <Widget>[
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: DataTable(
                  columns: <DataColumn>[
                    DataColumn(label: Text("Tanggal")),
                    DataColumn(label: Text('Hari')),
                    DataColumn(label: Text('Shift')),
                    DataColumn(label: Text("JK_IN")),
                    DataColumn(label: Text("JK_OUT")),
                    DataColumn(label: Text("Absen in")),
                    DataColumn(label: Text("Absen out")),
                    DataColumn(label: Text("Terlambat")),
                    DataColumn(label: Text("JEfektif")),
                  ],
                  rows: dataAbsensi
                      .map((data) => DataRow(cells: [
                            DataCell(
                                (data.tgl == null) ? Text("") : Text(data.tgl)),
                            DataCell((data.hari == null)
                                ? Text("")
                                : Text(data.hari)),
                            DataCell((data.shift == null)
                                ? Text("")
                                : Text(data.shift)),
                            DataCell((data.jmasuk == null)
                                ? Text("")
                                : Text(data.jmasuk)),
                            DataCell((data.jpulang == null)
                                ? Text("")
                                : Text(data.jpulang)),
                            DataCell((data.amasuk == null)
                                ? Text("")
                                : Text(data.amasuk.toString())),
                            DataCell((data.apulang == null)
                                ? Text("")
                                : Text(data.apulang.toString())),
                            DataCell((data.terlambat == null)
                                ? Text("")
                                : Text(data.terlambat.toString())),
                            DataCell((data.jefektif == null)
                                ? Text("")
                                : Text(data.jefektif.toString())),
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
