import 'package:recase/recase.dart';

import '../../../common/utils/pubspec/pubspec_utils.dart';
import '../../interface/sample_interface.dart';

/// [Sample] file from [app_routes] file creation.
class RouteSample extends Sample {
  final String _name;
  final String _baseDir;

  RouteSample(
    String path,
    this._name,
    this._baseDir, {
    bool overwrite = false,
  }) : super(
          path,
          overwrite: overwrite,
        );

  @override
  String get content => '''
import 'package:${PubspecUtils.projectName}/$_baseDir';

class ${_name.pascalCase}Route extends RouteBase {

  static List<GetPage<dynamic>> routes = [
  ];

  @override
  setRoute(routes);
}

''';
}
