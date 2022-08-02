import 'package:recase/recase.dart';

import '../../../common/utils/pubspec/pubspec_utils.dart';
import '../../interface/sample_interface.dart';

/// [Sample] file from Repository file creation.
class RepositorySample extends Sample {
  final String _name;
  final bool createEndpoints;
  final String baseDir;
  final String modelDir;
  String? _namePascal;
  String? _nameLower;

  RepositorySample(
    this._name, {
    bool overwrite = false,
    this.createEndpoints = false,
    this.baseDir = '',
    this.modelDir = '',
    String path = '',
  }) : super(
          path,
          overwrite: overwrite,
        ) {
    _namePascal = _name.pascalCase;
    _nameLower = _name.toLowerCase();
  }

  String get _defaultEndpoint => createEndpoints
      ? '''
Future<$_namePascal?> get$_namePascal(int id) async {
final response = await get('\$endpoint/\$id');
return response.body;
}

Future<Response<$_namePascal>> post$_namePascal($_namePascal $_nameLower) async => await post(endpoint, $_nameLower);

Future<Response> delete$_namePascal(int id) async => await delete('\$endpoint/\$id');
'''
      : '\n';

  @override
  String get content => '''
import 'package:${PubspecUtils.projectName}/$baseDir';
import 'package:${PubspecUtils.projectName}/$modelDir';

class ${_name.pascalCase}Repository extends RepositoryBase<$_namePascal> {

@override
String get endpoint => '$_nameLower';

@override
$_namePascal Function(dynamic data) get parser => (json) => $_namePascal.fromJson(json);

$_defaultEndpoint

}

''';
}
