import 'api_response_base.dart';

class ApiResponseRegistrer extends ApiResponseBase {
  ApiResponseRegistrer({
    required super.success,
    required super.message,
    super.error,
  });

  factory ApiResponseRegistrer.fromJson(Map<String, dynamic> json) {
    return ApiResponseRegistrer(
      success: json['mensaje'] == 'success register',
      message: json['mensaje'] ?? '',
      error: json['error'],
    );
  }
}
