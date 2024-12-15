class ApiResponse<T> {
  final int status;
  final bool success;
  final String message;
  final T? data;

  ApiResponse({
    required this.status,
    required this.success,
    required this.message,
    this.data,
  });

  factory ApiResponse.fromJson(
      Map<String, dynamic> json, T Function(dynamic) fromJsonT) {
    return ApiResponse(
      message: json['message'] as String,
      status: json['status'] as int,
      success: json['success'] as bool,
      data: json['data'] != null ? fromJsonT(json['data']) : null,
    );
  }
}
