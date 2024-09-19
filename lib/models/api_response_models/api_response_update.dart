import 'api_response_base.dart';

class ApiResponseUpdate extends ApiResponseBase {
  ApiResponseUpdate({
    required bool success,
    required String message,
    String? error,
  }) : super(success: success, message: message, error: error);

  factory ApiResponseUpdate.fromJson(Map<String, dynamic> json) {
    return ApiResponseUpdate(
      success: json['mensaje'] == 'success update',
      message: json['mensaje'] ?? '',
      error: json['error'],
    );
  }
}
