class Response {
  final String error;
  final String success;

  const Response({required this.error, required this.success});
  factory Response.fromJson(Map<String, dynamic> json) {
    return Response(
      error: json['error'] ?? '',
      success: json['success'] ?? '',
    );
  }
}
