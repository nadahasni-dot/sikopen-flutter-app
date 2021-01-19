import 'package:flutter/material.dart';

class CheckClockScreen extends StatefulWidget {
  CheckClockScreen({Key key}) : super(key: key);

  @override
  _CheckClockScreenState createState() => _CheckClockScreenState();
}

class _CheckClockScreenState extends State<CheckClockScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Text('Check clock menu'),
    );
  }
}
