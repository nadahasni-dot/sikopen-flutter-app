import 'package:flutter/material.dart';

class PengajuanIjinScreen extends StatefulWidget {
  PengajuanIjinScreen({Key key}) : super(key: key);

  @override
  _PengajuanIjinScreenState createState() => _PengajuanIjinScreenState();
}

class _PengajuanIjinScreenState extends State<PengajuanIjinScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Text('Pengajuan ijin menu'),
    );
  }
}
