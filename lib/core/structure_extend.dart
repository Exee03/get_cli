import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:recase/recase.dart';

import '../exception_handler/exceptions/cli_exception.dart';
import '../models/file_model.dart';
import 'internationalization.dart';
import 'locales.g.dart';
import 'structure.dart' as origin;

class Structure extends origin.Structure {
  static final Map<String, String> _paths = {
    'page': Directory(replaceAsExpected(
                path: '${Directory.current.path} /lib/pages/'))
            .existsSync()
        ? replaceAsExpected(path: 'lib/pages')
        : replaceAsExpected(path: 'lib/app/modules'),
    'module': replaceAsExpected(path: 'lib/app/modules'),
    'widget': replaceAsExpected(path: 'lib/app/widgets/'),
    'model': replaceAsExpected(path: 'lib/app/data'),
    'init': replaceAsExpected(path: 'lib/'),
    'route': replaceAsExpected(path: 'lib/routes/'),
    'repository': replaceAsExpected(path: 'lib/app'),
    'provider': replaceAsExpected(path: 'lib/app'),
    'controller': replaceAsExpected(path: 'lib/app'),
    'bloc': replaceAsExpected(path: 'lib/app'),
    'state': replaceAsExpected(path: 'lib/app'),
    'view': replaceAsExpected(path: 'lib/app/views/'),
    'component': replaceAsExpected(path: 'lib/app/components'),
    'export': replaceAsExpected(path: 'lib/app'),
    //artekko files
    'screen': replaceAsExpected(path: 'lib/presentation'),
    'controller.binding':
        replaceAsExpected(path: 'lib/infrastructure/navigation/bindings'),
    'navigation': replaceAsExpected(
        path: 'lib/infrastructure/navigation/navigation.dart'),
    //generator files
    'generate_locales': replaceAsExpected(path: 'lib/generated'),
    //base files
    'base': replaceAsExpected(path: 'lib/app/base'),
  };

  static FileModel model(String? name, String command, bool wrapperFolder,
      {String? on, String? folderName}) {
    if (on != null && on != '') {
      on = replaceAsExpected(path: on).replaceAll('\\\\', '\\');
      var current = Directory('lib');
      final list = current.listSync(recursive: true, followLinks: false);
      final contains = list.firstWhere((element) {
        if (element is File) {
          return false;
        }

        return '${element.path}${p.separator}'.contains('$on${p.separator}');
      }, orElse: () {
        return list.firstWhere((element) {
          //Fix erro ao encontrar arquivo com nome
          if (element is File) {
            return false;
          }
          return element.path.contains(on!);
        }, orElse: () {
          throw CliException(LocaleKeys.error_folder_not_found.trArgs([on]));
        });
      });

      return FileModel(
        name: name,
        path: Structure.getPathWithName(
          contains.path,
          ReCase(name!).snakeCase,
          createWithWrappedFolder: wrapperFolder,
          folderName: folderName,
        ),
        commandName: command,
      );
    }
    return FileModel(
      name: name,
      path: Structure.getPathWithName(
        _paths[command],
        ReCase(name!).snakeCase,
        createWithWrappedFolder: wrapperFolder,
        folderName: folderName,
      ),
      commandName: command,
    );
  }

  static String replaceAsExpected({
    required String path,
    String? replaceChar,
  }) =>
      origin.Structure.replaceAsExpected(
        path: path,
        replaceChar: replaceChar,
      );

  static String? getPathWithName(
    String? firstPath,
    String secondPath, {
    bool createWithWrappedFolder = false,
    required String? folderName,
  }) =>
      origin.Structure.getPathWithName(
        firstPath,
        secondPath,
        createWithWrappedFolder: createWithWrappedFolder,
        folderName: folderName,
      );

  static List<String> safeSplitPath(String path) =>
      origin.Structure.safeSplitPath(path);

  static String pathToDirImport(String path) =>
      origin.Structure.pathToDirImport(path);
}
