import 'package:recase/recase.dart';

import '../../../common/utils/pubspec/pubspec_utils.dart';
import '../../interface/sample_interface.dart';

/// [Sample] file from Provider file creation.
class ProviderSample extends Sample {
  final String _name;
  final String _moduleName;
  final String _baseDir;
  final String _blocDir;
  final String _stateDir;
  final String _controllerDir;

  ProviderSample(
    String path,
    this._name,
    this._moduleName,
    this._blocDir,
    this._baseDir,
    this._stateDir,
    this._controllerDir, {
    bool overwrite = false,
  }) : super(
          path,
          overwrite: overwrite,
        );

  bool get hasBloc => _blocDir.isNotEmpty;

  bool get hasController => _controllerDir.isNotEmpty;

  String get addImport {
    String value = "";
    if (hasBloc) {
      value = "$value\nimport 'package:${PubspecUtils.projectName}/$_blocDir';";
    }
    if (hasController) {
      value =
          "$value\nimport 'package:${PubspecUtils.projectName}/$_controllerDir';";
    }
    return value;
  }

  String get addContent {
    String value = "";
    if (hasBloc) {
      value =
          "$value\nGet.lazyPut<${_moduleName.pascalCase}Bloc>(() => ${_moduleName.pascalCase}Bloc());";
    }
    if (hasController) {
      value =
          "$value\nGet.lazyPut<${_name.pascalCase}Controller>(() => ${_name.pascalCase}Controller());";
    }
    return value;
  }

  @override
  String get content => '''
import 'package:${PubspecUtils.projectName}/$_baseDir';
import 'package:${PubspecUtils.projectName}/$_stateDir';
$addImport

class ${_name.pascalCase}Provider extends ProviderBase {
  @override
  void init() {
    Get.lazyPut<${_moduleName.pascalCase}State>(() => ${_moduleName.pascalCase}State());
    $addContent
  }
}

''';
}
