import 'api_response_base.dart';

class ApiResponseDelete extends ApiResponseBase {
  ApiResponseDelete({
    required bool success,
    required String message,
    String? error,
  }) : super(success: success, message: message, error: error);

  factory ApiResponseDelete.fromJson(Map<String, dynamic> json) {
    return ApiResponseDelete(
      success: json['mensaje'] == 'success delete book',
      message: json['mensaje'] ?? '',
      error: json['error'],
    );
  }
}
