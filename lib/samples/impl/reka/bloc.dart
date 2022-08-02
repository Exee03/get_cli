import 'package:recase/recase.dart';

import '../../../common/utils/pubspec/pubspec_utils.dart';
import '../../interface/sample_interface.dart';

/// [Sample] file from Bloc file creation.
class BlocSample extends Sample {
  final String _name;
  final String _moduleName;
  final String _baseDir;
  final String _stateDir;

  BlocSample(
    String path,
    this._name,
    this._moduleName,
    this._baseDir,
    this._stateDir, {
    bool overwrite = false,
  }) : super(
          path,
          overwrite: overwrite,
        );

  bool get hasState => _stateDir.isNotEmpty;

  String get addImport {
    if (!hasState) return "";

    return "import 'package:${PubspecUtils.projectName}/$_stateDir';";
  }

  String get addContent {
    if (!hasState) return "//TODO: Implement ${_name.pascalCase}Bloc";

    return '''
  final ${_moduleName.camelCase}State = Get.find<${_moduleName.pascalCase}State>();

  void add() => ${_moduleName.camelCase}State.increment();
''';
  }

  @override
  String get content => '''
import 'package:${PubspecUtils.projectName}/$_baseDir';
$addImport

class ${_name.pascalCase}Bloc extends BlocBase {
  $addContent
}

''';
}
