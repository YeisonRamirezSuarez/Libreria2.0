import 'package:libreria_app/models/login_model.dart';

class ApiResponseLogin {
  final UserModel? user;
  final String? error;

  ApiResponseLogin({this.user, this.error});
}


class ApiResponseRegistrer {
  final bool success;
  final String message;
  final String? error;

  ApiResponseRegistrer({required this.success, required this.message, this.error});

  factory ApiResponseRegistrer.fromJson(Map<String, dynamic> json) {
    return ApiResponseRegistrer(
      success: json['mensaje'] == 'success register',
      message: json['mensaje'] ?? '',
      error: json['error'],
    );
  }
}

class ApiResponseUpdate {
  final bool success;
  final String message;
  final String? error;

  ApiResponseUpdate({required this.success, required this.message, this.error});

  factory ApiResponseUpdate.fromJson(Map<String, dynamic> json) {
    return ApiResponseUpdate(
      success: json['mensaje'] == 'success update',
      message: json['mensaje'] ?? '',
      error: json['error'],
    );
  }
}



