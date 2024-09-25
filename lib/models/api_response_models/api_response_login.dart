import 'package:LibreriaApp/models/user_login_model.dart';

class ApiResponseLogin {
  final UserLogin? user;
  final String? error;

  ApiResponseLogin({this.user, this.error});
}
