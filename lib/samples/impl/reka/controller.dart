import 'package:recase/recase.dart';

import '../../../common/utils/pubspec/pubspec_utils.dart';
import '../../interface/sample_interface.dart';

/// [Sample] file from Module_Controller file creation.
class ControllerSample extends Sample {
  final String _name;
  final String _blocName;
  final String _baseDir;
  final String _blocDir;

  ControllerSample(
    String path,
    this._name,
    this._blocName,
    this._baseDir,
    this._blocDir, {
    bool overwrite = false,
  }) : super(
          path,
          overwrite: overwrite,
        );

  @override
  String get content => '''
import 'package:${PubspecUtils.projectName}/$_baseDir';
import 'package:${PubspecUtils.projectName}/$_blocDir';

class ${_name.pascalCase}Controller extends ControllerBase {
  final ${_blocName.camelCase}Bloc = Get.find<${_blocName.pascalCase}Bloc>();

  final count = 0.obs;

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void increment() => count.value++;

  void increment${_blocName.pascalCase}State() => ${_blocName.camelCase}Bloc.add();
}

''';
}
