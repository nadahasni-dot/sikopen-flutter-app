import 'dart:async';

import 'package:hello_world_app/models/login_model.dart';
import 'package:hello_world_app/models/login_repository.dart';
import 'package:hello_world_app/networking/api_response.dart';

class LoginBloc {
  LoginRepository _loginRepository;

  StreamController _loginController;

  StreamSink<ApiResponse<PostLogin>> get loginDataSink => _loginController.sink;
  Stream<ApiResponse<PostLogin>> get loginDataStream => _loginController.stream;

  LoginBloc() {
    _loginController = StreamController<ApiResponse<PostLogin>>();
    _loginRepository = LoginRepository();
  }

  fetchDataLogin(String username, String password) async {
    loginDataSink.add(ApiResponse.loading('Fetching Details'));
    try {
      PostLogin data = await _loginRepository.postDataLogin(username, password);
      loginDataSink.add(ApiResponse.completed(data));
    } catch (e) {
      loginDataSink.add(ApiResponse.error(e.toString()));
    }
  }
}
