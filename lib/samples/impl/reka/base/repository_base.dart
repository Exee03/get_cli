import '../../../../common/utils/pubspec/pubspec_utils.dart';
import '../../../interface/sample_interface.dart';

/// [Sample] file from repository_base.dart file creation.
class RepositoryBaseSample extends Sample {
  final String _dataBaseDir;

  RepositoryBaseSample(
    this._dataBaseDir, {
    String path = 'lib/app/base/repository_base.dart',
  }) : super(path);

  String get _package => PubspecUtils.isServerProject
      ? "'package:get_server/get_server.dart'"
      : "'package:get/get.dart'";

  @override
  String get content => '''
import 'package:flutter_dotenv/flutter_dotenv.dart';
import $_package;

import 'package:${PubspecUtils.projectName}/$_dataBaseDir';

export $_package;

abstract class RepositoryBase<T> extends GetConnect {
  String get endpoint;

  T Function(dynamic data) get parser;

  @override
  Future<void> onInit() async {
    httpClient.baseUrl = dotenv.get('ENDPOINT');

    _initDecoder();
  }

  void _initDecoder() {
    httpClient.defaultDecoder = (map) {
      try {
        if (map is String) throw 'Api error';

        final data = Data.fromJson(map);

        if (!data.success!) throw data.message ?? 'Api error';

        if (!(data.data?.containsKey('current_page') ?? false)) {
          return parser.call(data);
        }

        final dataList = data.data as List?;

        return dataList?.map((item) => parser.call(item)).toList() ?? [];
      } catch (e) {
        // throw 'Api error';
        rethrow;
      }
    };
  }
}

''';
}
