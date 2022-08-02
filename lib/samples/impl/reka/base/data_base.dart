import '../../../interface/sample_interface.dart';

/// [Sample] file from data_base.dart file creation.
class DataBaseSample extends Sample {
  DataBaseSample({
    String path = 'lib/app/base/data_base.dart',
  }) : super(path);

  @override
  String get content => '''
class Data {
  bool? success;
  String? message;
  Map<String, dynamic>? data;

  Data({this.success, this.message, this.data});

  Data.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'].toString();
    if (json['data'] != null) {
      data = json['data'] as Map<String, dynamic>;
    }
  }

  Map<String, dynamic> toJson() {
    final dataMap = <String, dynamic>{};
    dataMap['success'] = success;
    dataMap['message'] = message;
    if (data != null) {
      dataMap['data'] = data;
    }
    return dataMap;
  }
}

''';
}
