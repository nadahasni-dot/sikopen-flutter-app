import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:hello_world_app/globals/ApiEndpoints.dart';
import 'package:hello_world_app/screens/main_screen/menu_screen/data_ketidakhadiran_screen.dart';
import 'package:hello_world_app/utils/LoginPreferences.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class PengajuanIjinScreen extends StatefulWidget {
  PengajuanIjinScreen({Key key}) : super(key: key);

  @override
  _PengajuanIjinScreenState createState() => _PengajuanIjinScreenState();
}

class _PengajuanIjinScreenState extends State<PengajuanIjinScreen> {
  var _formKey;
  List ijin = ["Sakit", "Ijin"];
  List<DropdownMenuItem<String>> _dropDownIjinItems;
  String _currentIjin;
  bool _isProcessingRequest;

  TextEditingController tanggalAwalController;
  TextEditingController tanggalAkhirController;
  TextEditingController namaPegawaiController;
  TextEditingController keteranganController;

  @override
  void initState() {
    _dropDownIjinItems = getDropDownMenuItems();
    _currentIjin = _dropDownIjinItems[0].value;
    _formKey = GlobalKey<FormState>();
    _isProcessingRequest = false;

    tanggalAwalController = TextEditingController(
        text:
            "${DateTime.now().day}-${DateTime.now().month}-${DateTime.now().year}");
    tanggalAkhirController = TextEditingController(
        text:
            "${DateTime.now().day}-${DateTime.now().month}-${DateTime.now().year}");

    namaPegawaiController = TextEditingController(
        text: LoginPreferences.prefs.getString(LoginPreferences.PERSON_NAME));
    keteranganController = TextEditingController();

    super.initState();
  }

  List<DropdownMenuItem<String>> getDropDownMenuItems() {
    List<DropdownMenuItem<String>> items = new List();
    for (String data in ijin) {
      items.add(new DropdownMenuItem(
        value: data,
        child: new Text(data),
      ));
    }
    return items;
  }

  void changedDropDwonItem(String selectedItem) {
    setState(() {
      _currentIjin = selectedItem;
    });
  }

  void _postKetidakhadiran(BuildContext context, int pegawaiId, String mulai,
      String akhir, String fk_tidak_hadir, String keterangan) async {
    Dio _dio = new Dio();
    Response response;
    _dio.options.connectTimeout = 8000;
    _dio.options.receiveTimeout = 3000;

    setState(() {
      _isProcessingRequest = true;
    });

    Scaffold.of(context).showSnackBar(SnackBar(
      content: Text("Please wait ..."),
    ));

    try {
      response = await _dio.post(ApiEndpoints.POST_KETIDAKHADIRAN, data: {
        'pegawai_id': pegawaiId,
        'mulai': mulai,
        'akhir': akhir,
        'fk_tidak_hadir': fk_tidak_hadir,
        'keterangan': keterangan
      });

      setState(() {
        _isProcessingRequest = false;
      });

      if (response.statusCode == 200) {
        print("berhasil insert !");
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Dataketidakhadiran()),
        );
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
    return ModalProgressHUD(
      inAsyncCall: _isProcessingRequest,
      child: ListView(
        children: [
          Card(
            margin: EdgeInsets.all(15),
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
                        "Form Ketidakhadiran",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                    IgnorePointer(
                      child: TextFormField(
                          controller: namaPegawaiController,
                          decoration: InputDecoration(
                              icon: Icon(Icons.person),
                              labelText: "Nama Pegawai")),
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
                          width: MediaQuery.of(context).size.width * 0.8,
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
                      onTap: () => _selectDate(context, tanggalAwalController),
                      child: Container(
                        color: Colors.transparent,
                        child: IgnorePointer(
                          child: TextFormField(
                              controller: tanggalAwalController,
                              decoration: InputDecoration(
                                  icon: Icon(Icons.date_range),
                                  labelText: "Tanggal Awal")),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => _selectDate(context, tanggalAkhirController),
                      child: Container(
                        color: Colors.transparent,
                        child: IgnorePointer(
                          child: TextFormField(
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
                                    borderRadius: BorderRadius.circular(20),
                                    splashColor: Colors.amber,
                                    onTap: () {
                                      if (_formKey.currentState.validate()) {
                                        var fk = "S";
                                        if (_currentIjin == "Ijin") {
                                          fk = "I";
                                        }
                                        // _postKetidakhadiran(
                                        //     context,
                                        //     LoginPreferences.prefs.getInt(
                                        //         LoginPreferences.EMPLOYEE_ID),
                                        //     tanggalAwalController.text,
                                        //     tanggalAkhirController.text,
                                        //     fk,
                                        //     keteranganController.text);

                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  Dataketidakhadiran()),
                                        );
                                      }
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
                                      colors: [Colors.blue, Colors.blue[300]],
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
}
