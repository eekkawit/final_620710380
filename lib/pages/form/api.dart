class Api {
  final String status;
  final String? message;
  final dynamic data;

  Api({
    required this.status,
    required this.message,
    required this.data,
  });

  factory Api.fromJson(Map<String, dynamic> json) {
    return Api(
      status: json['status'],
      message: json['message'],
      data: json['data'],
    );
  }
}