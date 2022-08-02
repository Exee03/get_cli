import 'package:recase/recase.dart';

import '../../../common/utils/pubspec/pubspec_utils.dart';
import '../../interface/sample_interface.dart';

/// [Sample] file from State file creation.
class StateSample extends Sample {
  final String _name;
  final String _baseDir;

  StateSample(
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

class ${_name.pascalCase}State extends StateBase {
  final count = 0.obs;

  void increment() => count.value++;
}

''';
}
