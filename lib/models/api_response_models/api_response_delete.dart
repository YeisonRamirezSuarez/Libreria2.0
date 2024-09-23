import 'api_response_base.dart';

class ApiResponseDelete extends ApiResponseBase {
  ApiResponseDelete({
    required super.success,
    required super.message,
    super.error,
  });

  factory ApiResponseDelete.fromJson(Map<String, dynamic> json) {
    return ApiResponseDelete(
      success: json['mensaje'] == 'success delete book',
      message: json['mensaje'] ?? '',
      error: json['error'],
    );
  }
}
