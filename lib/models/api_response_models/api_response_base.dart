abstract class ApiResponseBase {
  final bool success;
  final String message;
  final String? error;

  ApiResponseBase({
    required this.success,
    required this.message,
    this.error,
  });

  factory ApiResponseBase.fromJson(Map<String, dynamic> json, String successMessage) {
    return _ApiResponseBaseImpl(
      success: json['mensaje'] == successMessage,
      message: json['mensaje'] ?? '',
      error: json['error'],
    );
  }
}

// Implementación concreta de ApiResponseBase para ser utilizada internamente
class _ApiResponseBaseImpl extends ApiResponseBase {
  _ApiResponseBaseImpl({
    required super.success,
    required super.message,
    super.error,
  });
}
