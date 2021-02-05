import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hello_world_app/screens/main_screen/menu_screen/laporan_absensi/data_absensi_bulanan_screen.dart';
import 'package:hello_world_app/utils/LoginPreferences.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';

class LaporanAbsensiBulananScreen extends StatefulWidget {
  LaporanAbsensiBulananScreen({Key key}) : super(key: key);

  @override
  _LaporanAbsensiBulananScreenState createState() =>
      _LaporanAbsensiBulananScreenState();
}

class _LaporanAbsensiBulananScreenState
    extends State<LaporanAbsensiBulananScreen> {
  List<DropdownMenuItem<String>> _dropDownItems;
  String _currentItem;
  TextEditingController tanggalAwalController;
  TextEditingController tanggalAkhirController;
  TextEditingController tanggalBulanController;

  void changedDropDwonItem(String selectedItem) {
    setState(() {
      _currentItem = selectedItem;
    });
  }

  List<DropdownMenuItem<String>> getDropDownMenuItems() {
    List<DropdownMenuItem<String>> items = new List();

    items.add(new DropdownMenuItem(
      value: "Bulanan",
      child: new Text("Bulanan"),
    ));
    items.add(new DropdownMenuItem(
      value: "Periodik",
      child: new Text("Periodik"),
    ));

    return items;
  }

  _selectMonth() {
    showMonthPicker(
      context: context,
      firstDate: DateTime(DateTime.now().year - 100),
      lastDate: DateTime.now(),
      initialDate: DateTime.now(),
    ).then((date) {
      if (date != null) {
        tanggalBulanController.text = "${date.month}-${date.year}";
      }
    });
  }

  _selectDate(BuildContext context, TextEditingController controller) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(DateTime.now().year - 100),
        lastDate: DateTime.now());
    if (picked != null) {
      setState(() {
        controller.text = "${picked.day}-${picked.month}-${picked.year}";
      });
    }
  }

  @override
  void initState() {
    _dropDownItems = getDropDownMenuItems();
    _currentItem = "Bulanan";

    tanggalAwalController = TextEditingController(
        text:
            "${DateTime.now().day}-${DateTime.now().month}-${DateTime.now().year}");
    tanggalAkhirController = TextEditingController(
        text:
            "${DateTime.now().day}-${DateTime.now().month}-${DateTime.now().year}");
    tanggalBulanController = TextEditingController(
        text: "${DateTime.now().month}-${DateTime.now().year}");
    super.initState();
  }

  @override
  void dispose() {
    tanggalAwalController.dispose();
    tanggalAkhirController.dispose();
    tanggalBulanController.dispose();

    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(children: [
      Column(
        children: [
          Container(
            margin: EdgeInsets.fromLTRB(20, 20, 20, 20),
            child: DropdownButton(
              value: _currentItem,
              items: _dropDownItems,
              onChanged: changedDropDwonItem,
              isExpanded: true,
            ),
          ),
          Container(
              margin: EdgeInsets.fromLTRB(20, 0, 20, 0), child: showField()),
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
                            int id = LoginPreferences.prefs
                                .getInt(LoginPreferences.EMPLOYEE_ID);
                            if (_currentItem == "Bulanan") {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => DataAbsensiBulanan(
                                        date:
                                            "${tanggalBulanController.text}/$id",
                                        kode: 1),
                                  )).then((value) {});
                            } else {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => DataAbsensiBulanan(
                                        date:
                                            "$id/${tanggalAwalController.text}/${tanggalAkhirController.text}",
                                        kode: 2),
                                  )).then((value) {});
                            }
                          },
                          child: Center(
                            child: Text(
                              "CARI",
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
                  )))
        ],
      ),
    ]);
  }

  Widget showField() {
    if (_currentItem == "Periodik") {
      return Column(
        children: [
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
        ],
      );
    } else {
      return GestureDetector(
        onTap: () => _selectMonth(),
        child: Container(
          color: Colors.transparent,
          child: IgnorePointer(
            child: TextFormField(
                controller: tanggalBulanController,
                decoration: InputDecoration(
                    icon: Icon(Icons.date_range), labelText: "Tanggal/Bulan")),
          ),
        ),
      );
    }
  }
}
