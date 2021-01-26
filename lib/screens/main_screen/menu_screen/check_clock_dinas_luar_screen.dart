import 'package:flutter/material.dart';
import 'package:hello_world_app/screens/main_screen/menu_screen/check_clock_dinas_luar/check_clock_dinas_luar.dart';
import 'package:hello_world_app/screens/main_screen/menu_screen/check_clock_dinas_luar/loading_check_clock.dart';

class CheckClockDinasLuarScreen extends StatefulWidget {
  CheckClockDinasLuarScreen({Key key}) : super(key: key);

  @override
  _CheckClockDinasLuarScreenState createState() =>
      _CheckClockDinasLuarScreenState();
}

class _CheckClockDinasLuarScreenState extends State<CheckClockDinasLuarScreen> {
  bool _isLoading;

  @override
  void initState() {
    super.initState();
    _isLoading = false;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading ? LoadingCheckClock() : CheckClockDinasLuar();
  }
}
