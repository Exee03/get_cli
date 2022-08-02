import 'package:recase/recase.dart';

import '../../interface/sample_interface.dart';

/// [Sample] file from Component file creation.
class ComponentSample extends Sample {
  final String _name;

  ComponentSample(
    String path,
    this._name, {
    bool overwrite = false,
  }) : super(
          path,
          overwrite: overwrite,
        );

  @override
  String get content => '''
import 'package:flutter/material.dart';

class ${_name.pascalCase}Component extends StatelessWidget {
  const ${_name.pascalCase}Component({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}


''';
}
