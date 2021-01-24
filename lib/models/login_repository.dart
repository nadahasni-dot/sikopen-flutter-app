import 'package:hello_world_app/models/login_model.dart';
import 'package:hello_world_app/networking/api_base_helper.dart';

class LoginRepository {
  ApiBaseHelper _helper = ApiBaseHelper();

  Future<PostLogin> postDataLogin(String username, String password) async {
    ApiBaseHelper _helper = ApiBaseHelper();

    final resp = await _helper
        .post("auth", {"username": username, "password": password});
    return PostLogin.createPostLogin(resp);
  }
}
