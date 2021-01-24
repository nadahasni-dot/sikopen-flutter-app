import 'package:hello_world_app/networking/api_base_helper.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PostLogin {
  String user_name;
  String user_salt_encrypt;
  int employee_id;
  String person_name;

  PostLogin(
      {this.user_name,
      this.user_salt_encrypt,
      this.employee_id,
      this.person_name});

  PostLogin.createPostLogin(Map<String, dynamic> object) {
    var userData = (object as Map<String, dynamic>)['payload'];

    print(userData);

    user_name = userData[0]['user_name'];
    user_salt_encrypt = userData[0]['user_salt_encrypt'];
    employee_id = userData[0]['employee_id'];
    person_name = userData[0]['person_name'];
  }

  // static Future<PostLogin> postDataLogin(
  //     String username, String password) async {
  //   ApiBaseHelper _helper = ApiBaseHelper();
  //   try {
  //     var resp = await _helper
  //         .post("auth", {"username": username, "password": password});
  //     return PostLogin.createPostLogin(resp);
  //   } catch (e) {
  //     print("ini error : " + e.toString());
  //   }

  // String apiURL = "https://dev.sabinsolusi.com/sikopen-api/auth";
  // var apiResult = await http
  //     .post(apiURL, body: {"username": username, "password": password});
  // print("Status login = " + apiResult.statusCode.toString());
  // var jsonObject = json.decode(apiResult.body);
  // var userData = await (resp as Map<String, dynamic>)['payload'];
}
