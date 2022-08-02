import 'dart:io';

import 'package:path/path.dart';
import 'package:recase/recase.dart';

import '../../core/structure.dart';

String findProviderFromName(String path, String name) {
  path = Structure.replaceAsExpected(path: path);
  var splitPath = Structure.safeSplitPath(path);
  splitPath
    ..remove('.')
    ..removeLast();

  var providerPath = '';
  while (splitPath.isNotEmpty && providerPath == '') {
    Directory(splitPath.join(separator))
        .listSync(recursive: true, followLinks: false)
        .forEach((element) {
      if (element is File) {
        var fileName = basename(element.path);
        if (fileName == '${name.snakeCase}_provider.dart') {
          providerPath = element.path;
        }
      }
    });
    splitPath.removeLast();
  }
  return providerPath;
}
