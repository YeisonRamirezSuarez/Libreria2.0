import 'api_response_base.dart';

class ApiResponseRegistrer extends ApiResponseBase {
  ApiResponseRegistrer({
    required bool success,
    required String message,
    String? error,
  }) : super(success: success, message: message, error: error);

  factory ApiResponseRegistrer.fromJson(Map<String, dynamic> json) {
    return ApiResponseRegistrer(
      success: json['mensaje'] == 'success register',
      message: json['mensaje'] ?? '',
      error: json['error'],
    );
  }
}
