import 'dart:io';

import 'package:path/path.dart';

import '../../common/utils/logger/log_utils.dart';
import '../../common/utils/pubspec/pubspec_utils.dart';
import '../../core/internationalization.dart';
import '../../core/locales.g.dart';
import '../../core/structure_extend.dart';
import '../../samples/interface/sample_interface.dart';
import '../sorter_imports/sort.dart';
import 'create_single_file.dart' as origin;

File handleFileCreate(
  String name,
  String command,
  String on,
  bool extraFolder,
  Sample sample,
  String folderName, [
  String sep = '_',
  bool skipFormatter = false,
]) {
  folderName = folderName;
  /* if (folderName.isNotEmpty) {
    extraFolder = PubspecUtils.extraFolder ?? extraFolder;
  } */
  final fileModel = Structure.model(name, command, extraFolder,
      on: on, folderName: folderName);
  var path = '${fileModel.path}$sep${fileModel.commandName}.dart';
  sample.path = path;
  return sample.create(skipFormatter: skipFormatter);
}

/// Create or edit the contents of a file
File writeFile(
  String path,
  String content, {
  bool overwrite = false,
  bool skipFormatter = false,
  bool logger = true,
  bool skipRename = false,
  bool useRelativeImport = false,
}) {
  var newFile = File(Structure.replaceAsExpected(path: path));

  if (!newFile.existsSync() || overwrite) {
    if (!skipFormatter) {
      if (path.endsWith('.dart')) {
        try {
          content = sortImports(
            content,
            renameImport: !skipRename,
            filePath: path,
            useRelative: useRelativeImport,
          );
        } on Exception catch (_) {
          if (newFile.existsSync()) {
            LogService.info(
                LocaleKeys.error_invalid_dart.trArgs([newFile.path]));
          }
          rethrow;
        }
      }
    }
    if (!skipRename && newFile.path != 'pubspec.yaml') {
      var separatorFileType = PubspecUtils.separatorFileType!;
      if (separatorFileType.isNotEmpty) {
        newFile = newFile.existsSync()
            ? newFile = newFile
                .renameSync(replacePathTypeSeparator(path, separatorFileType))
            : File(replacePathTypeSeparator(path, separatorFileType));
      }
    }

    newFile.createSync(recursive: true);
    newFile.writeAsStringSync(content);
    if (logger) {
      LogService.success(
        LocaleKeys.sucess_file_created.trArgs(
          [basename(newFile.path), newFile.path],
        ),
      );
    }
  }
  return newFile;
}

String createSampleBase(Sample sample) {
  if (!File(sample.path).existsSync()) sample.create();

  return Structure.pathToDirImport(sample.path);
}

/// Replace the file name separator
String replacePathTypeSeparator(String path, String separator) =>
    origin.replacePathTypeSeparator(path, separator);
