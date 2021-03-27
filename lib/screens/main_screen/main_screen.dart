import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hello_world_app/globals/ApiEndpoints.dart';
import 'package:hello_world_app/screens/login_screen/login_screen.dart';
import 'package:hello_world_app/screens/main_screen/drawer_configuration.dart';
import 'package:hello_world_app/screens/main_screen/menu_screen/change_password_screen.dart';
import 'package:hello_world_app/screens/main_screen/menu_screen/check_clock/check_clock_screen.dart';
import 'package:hello_world_app/screens/main_screen/menu_screen/check_clock_dinas_luar_screen.dart';
import 'package:hello_world_app/screens/main_screen/menu_screen/laporan_absensi/laporan_absensi_bulanan_screen.dart';
import 'package:hello_world_app/screens/main_screen/menu_screen/pangajuan_ijin/pengajuan_ijin_screen.dart';
import 'package:hello_world_app/screens/main_screen/menu_screen/pangajuan_cuti/pengajuan_cuti_screen.dart';
import 'package:hello_world_app/screens/main_screen/menu_screen/registrasi_device_screen.dart';
import 'package:hello_world_app/utils/DeviceRegPreferences.dart';
import 'package:hello_world_app/utils/LoginPreferences.dart';
import 'package:uuid/uuid.dart';

class MainScreen extends StatefulWidget {
  static const routeName = '/main';
  MainScreen({Key key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  String _appTitle = 'Home';
  String _currentMenu = DrawerConfiguration.MENU_HOME;
  bool _isDeviceActivated = false;
  Widget _menuWidget;

  @override
  void initState() {
    // _checkUidStatus();
    _checkUidActivation();
    print('status uid: $_isDeviceActivated');
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_appTitle),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            UserAccountsDrawerHeader(
              margin: EdgeInsets.only(bottom: 8.0),
              accountName: Text(LoginPreferences.prefs
                  .getString(LoginPreferences.PERSON_NAME)),
              accountEmail: Text('NIP: ' +
                  LoginPreferences.prefs
                      .getString(LoginPreferences.EMPLOYEE_NIP)
                      .toString()),
              currentAccountPicture: CircleAvatar(
                backgroundImage: NetworkImage(
                    'https://bonds-and-shares.com/wp-content/uploads/2019/07/placeholder-user.png'),
              ),
            ),
            ListTile(
              selected:
                  _currentMenu == DrawerConfiguration.MENU_HOME ? true : false,
              enabled: _isDeviceActivated ? true : false,
              title: Text(DrawerConfiguration.MENU_HOME),
              leading: Icon(Icons.map),
              onTap: () {
                _updateMenuState(DrawerConfiguration.MENU_HOME);
              },
            ),
            ListTile(
              selected:
                  _currentMenu == DrawerConfiguration.MENU_CHECKCLOCK_DINAS_LUAR
                      ? true
                      : false,
              enabled: _isDeviceActivated ? true : false,
              title: Text(DrawerConfiguration.MENU_CHECKCLOCK_DINAS_LUAR),
              leading: Icon(Icons.fact_check),
              onTap: () {
                _updateMenuState(
                    DrawerConfiguration.MENU_CHECKCLOCK_DINAS_LUAR);
              },
            ),
            ListTile(
              selected: _currentMenu == DrawerConfiguration.MENU_PEMGAJUAN_IJIN
                  ? true
                  : false,
              enabled: _isDeviceActivated ? true : false,
              title: Text(DrawerConfiguration.MENU_PEMGAJUAN_IJIN),
              leading: Icon(Icons.assignment),
              onTap: () {
                _updateMenuState(DrawerConfiguration.MENU_PEMGAJUAN_IJIN);
              },
            ),
            ListTile(
              selected: _currentMenu == DrawerConfiguration.MENU_LAPORAN_ABSENSI
                  ? true
                  : false,
              enabled: _isDeviceActivated ? true : false,
              title: Text(DrawerConfiguration.MENU_LAPORAN_ABSENSI),
              leading: Icon(Icons.book),
              onTap: () {
                _updateMenuState(DrawerConfiguration.MENU_LAPORAN_ABSENSI);
              },
            ),
            ListTile(
                selected:
                    _currentMenu == DrawerConfiguration.MENU_REGISTRASI_DEVICE
                        ? true
                        : false,
                enabled: _isDeviceActivated ? false : true,
                title: Text(DrawerConfiguration.MENU_REGISTRASI_DEVICE),
                leading: Icon(Icons.important_devices),
                onTap: () {
                  _updateMenuState(DrawerConfiguration.MENU_REGISTRASI_DEVICE);
                }),
            Divider(
              thickness: 0.5,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10.0, bottom: 10.0),
              child: Text(
                'Settings',
                style: TextStyle(
                  fontSize: 12.0,
                  fontWeight: FontWeight.w300,
                ),
              ),
            ),
            ListTile(
              title: Text(DrawerConfiguration.MENU_PASSWORD),
              leading: Icon(Icons.vpn_key),
              selected: _currentMenu == DrawerConfiguration.MENU_PASSWORD
                  ? true
                  : false,
              onTap: () {
                _updateMenuState(DrawerConfiguration.MENU_PASSWORD);
              },
            ),
            ListTile(
              title: Text(DrawerConfiguration.MENU_LOGOUT),
              leading: Icon(Icons.logout),
              selected: _currentMenu == DrawerConfiguration.MENU_LOGOUT
                  ? true
                  : false,
              onTap: () {
                _showLogoutDialog(context);
              },
            ),
          ],
        ),
      ),
      body: _menuWidget,
    );
  }

  void _updateMenuState(String clickedMenuName) {
    setState(() {
      _appTitle = clickedMenuName;
      _currentMenu = clickedMenuName;
      _menuWidget = _getActiveMenuWidget(clickedMenuName);
    });
    Navigator.of(context).pop();
  }

  void _showLogoutDialog(BuildContext context) {
    // set up the buttons
    Widget cancelButton = FlatButton(
      child: Text("Cancel"),
      onPressed: () {
        print('cancelling logout');
        Navigator.of(context).pop();
      },
    );
    Widget continueButton = FlatButton(
      child: Text("Logout"),
      onPressed: () async {
        // ? clear login session
        LoginPreferences.prefs.setBool(LoginPreferences.LOGGED_IN, false);
        LoginPreferences.prefs.setInt(LoginPreferences.EMPLOYEE_ID, null);
        LoginPreferences.prefs.setInt(LoginPreferences.USER_ID, null);
        LoginPreferences.prefs.setString(LoginPreferences.USER_NAME, null);
        LoginPreferences.prefs.setBool(LoginPreferences.USER_STATUS, null);
        LoginPreferences.prefs.setString(LoginPreferences.PERSON_NAME, null);
        LoginPreferences.prefs.setInt(LoginPreferences.PAR_ID, null);
        LoginPreferences.prefs
            .setString(LoginPreferences.USER_SALT_ENCRYPT, null);
        LoginPreferences.prefs.setString(LoginPreferences.EMPLOYEE_NIP, null);
        LoginPreferences.prefs.setInt(LoginPreferences.EMPLOYEE_GROUP_ID, null);

        // ? generate new uid
        // DeviceRegPreferences.prefs.setString(DeviceRegPreferences.UID, null);
        // DeviceRegPreferences.prefs.setString(DeviceRegPreferences.UID, Uuid().v1());

        // ? clear uid request and activation status
        // DeviceRegPreferences.prefs.setBool(DeviceRegPreferences.UID_REQUEST, false);
        // DeviceRegPreferences.prefs.setBool(DeviceRegPreferences.UID_STATUS, false);
        // await LoginPreferences.prefs.clear();

        print('logged out');
        // close alert
        Navigator.of(context).pop();
        // close screen
        Navigator.of(context).pop();
        Navigator.pushNamed(context, LoginScreen.routeName,
            arguments: {'passedString': 'samlekom'});
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Logout Confirmation"),
      content: Text("Do you realy want to logout?"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    Navigator.of(context).pop();

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  void _checkUidStatus() {
    setState(() {
      _isDeviceActivated = DeviceRegPreferences.getUidStatus();
    });

    print(LoginPreferences.prefs.getInt(LoginPreferences.EMPLOYEE_ID));
    print(
        'check uid status: ' + DeviceRegPreferences.getUidStatus().toString());

    if (_isDeviceActivated == false) {
      setState(() {
        _menuWidget = RegistrasiDeviceScreen();
        _appTitle = DrawerConfiguration.MENU_REGISTRASI_DEVICE;
        _currentMenu = DrawerConfiguration.MENU_REGISTRASI_DEVICE;
      });
      return;
    }

    setState(() {
      _menuWidget = CheckClockScreen();
      _appTitle = DrawerConfiguration.MENU_HOME;
      _currentMenu = DrawerConfiguration.MENU_HOME;
    });
  }

  void _checkUidActivation() async {
    Dio _dio = new Dio();
    Response response;
    _dio.options.connectTimeout = 8000;
    _dio.options.receiveTimeout = 3000;

    try {
      response = await _dio.get(ApiEndpoints.GET_UID_ACTIVATION_STATUS +
          LoginPreferences.prefs
              .getInt(LoginPreferences.EMPLOYEE_ID)
              .toString() +
          '&uid=' +
          DeviceRegPreferences.getUid());

      if (response.statusCode == 200) {
        if (response.data['result'] > 0) {
          // jika uid sudah diaprove maka simpan status request true
          DeviceRegPreferences.prefs
              .setBool(DeviceRegPreferences.UID_STATUS, true);
        } else {
          DeviceRegPreferences.prefs
              .setBool(DeviceRegPreferences.UID_STATUS, false);
        }

        print('check status: $response.data');
        print('status after check ' +
            DeviceRegPreferences.getUidStatus().toString());
      }
      _checkUidStatus();
    } on DioError catch (e) {
      // if error on sending request
      setState(() {
        _menuWidget = Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Terjadi Kesalahan',
              textAlign: TextAlign.center,
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: ElevatedButton(
                onPressed: () {
                  _checkUidActivation();
                },
                child: Text('Coba Lagi'),
              ),
            ),
          ],
        );
      });

      switch (e.type) {
        case DioErrorType.CONNECT_TIMEOUT:
          print('connection time out');
          return;
          break;
        case DioErrorType.DEFAULT:
          print('default error');
          return;
          break;
        case DioErrorType.CANCEL:
          print('canceled');
          return;
          break;
        default:
          print('another error occured');
      }
    }
  }

  Widget _getActiveMenuWidget(String selectedMenu) {
    Widget selectedScreen;

    switch (selectedMenu) {
      case DrawerConfiguration.MENU_HOME:
        selectedScreen = CheckClockScreen();
        break;
      case DrawerConfiguration.MENU_CHECKCLOCK_DINAS_LUAR:
        selectedScreen = CheckClockDinasLuarScreen();
        break;
      case DrawerConfiguration.MENU_PEMGAJUAN_IJIN:
        selectedScreen = PengajuanIjinScreen();
        break;
      case DrawerConfiguration.MENU_REGISTRASI_DEVICE:
        selectedScreen = RegistrasiDeviceScreen();
        break;
      case DrawerConfiguration.MENU_LAPORAN_ABSENSI:
        selectedScreen = LaporanAbsensiBulananScreen();
        break;
      case DrawerConfiguration.MENU_PASSWORD:
        selectedScreen = ChangePasswordScreen();
        break;
      default:
        selectedScreen = CheckClockScreen();
    }

    return selectedScreen;
  }
}
