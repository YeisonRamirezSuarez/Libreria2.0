import 'api_response_base.dart';

class ApiResponseUpdate extends ApiResponseBase {
  ApiResponseUpdate({
    required super.success,
    required super.message,
    super.error,
  });

  factory ApiResponseUpdate.fromJson(Map<String, dynamic> json) {
    return ApiResponseUpdate(
      success: json['mensaje'] == 'success update',
      message: json['mensaje'] ?? '',
      error: json['error'],
    );
  }
}
