class ApiResponse {
  final String status;
  final String responseTime;
  final ResponseData responseData;

  ApiResponse({required this.status, required this.responseTime, required this.responseData});

  factory ApiResponse.fromJson(Map<String, dynamic> json) {
    return ApiResponse(
      status: json['status'],
      responseTime: json['responseTime'],
      responseData: ResponseData.fromJson(json['response']),
    );
  }
}

class ResponseData {
  final List<String> bus;
  final List<FeedbackField> feedbackFields;

  ResponseData({required this.bus, required this.feedbackFields});

  factory ResponseData.fromJson(Map<String, dynamic> json) {
    var busList = List<String>.from(json['bus']);
    var feedbackFieldsList = (json['feedback_fields'] as List)
        .map((i) => FeedbackField.fromJson(i))
        .toList();

    return ResponseData(
      bus: busList,
      feedbackFields: feedbackFieldsList,
    );
  }
}

class FeedbackField {
  final String field;
  final String type;
  final List<String> values;

  FeedbackField({required this.field, required this.type, required this.values});

  factory FeedbackField.fromJson(Map<String, dynamic> json) {
    return FeedbackField(
      field: json['field'],
      type: json['type'],
      values: List<String>.from(json['values']),
    );
  }

  Map<String, dynamic> toJson() => {
    'field': field,
    'type': type,
    'values': values,
  };
}
