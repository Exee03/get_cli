import 'dart:io';

import 'package:dcli/dcli.dart';
import 'package:http/http.dart';
import 'package:path/path.dart' as p;
import 'package:recase/recase.dart';

import '../../../../common/utils/json_serialize/model_generator_extend.dart';
import '../../../../common/utils/logger/log_utils.dart';
import '../../../../common/utils/pubspec/pubspec_utils.dart';
import '../../../../common/utils/shell/shel.utils.dart';
import '../../../../core/internationalization.dart';
import '../../../../core/locales.g.dart';
import '../../../../core/structure_extend.dart';
import '../../../../exception_handler/exceptions/cli_exception.dart';
import '../../../../functions/create/create_single_file_extend.dart';
import '../../../../models/file_model.dart';
import '../../../../samples/impl/reka/base/data_base.dart';
import '../../../../samples/impl/reka/base/repository_base.dart';
import '../../../../samples/impl/reka/base/storage_base.dart';
import '../../../../samples/impl/reka/repository.dart';
import 'model.dart' as origin;

class GenerateModelCommand extends origin.GenerateModelCommand {
  @override
  Future<void> execute() async {
    final useStorage = containsArg('--withStorage');
    if (useStorage) await createStorageBase();

    var name = p.basenameWithoutExtension(withArgument).pascalCase;
    if (withArgument.isEmpty) {
      // final dialog = CLI_Dialog(questions: [
      //   [LocaleKeys.ask_model_name.tr, 'name']
      // ]);
      // var result = dialog.ask()['name'] as String;
      var result = ask(LocaleKeys.ask_model_name.tr);
      name = result.pascalCase;
    }

    FileModel newFileModel;
    final classGenerator = ModelGenerator(
      name,
      containsArg('--private'),
      containsArg('--withCopy'),
      null,
      useStorage,
    );

    // newFileModel = Structure.model(name, 'model', false, on: onCommand);
    newFileModel = Structure.model(name, 'model', true,
        on: onCommand, folderName: name.snakeCase);

    var dartCode = classGenerator.generateDartClasses(await _jsonRawData);

    var modelPath = '${newFileModel.path}_model.dart';

    var model = writeFile(modelPath, dartCode.result, overwrite: true);

    for (var warning in dartCode.warnings) {
      LogService.info('warning: ${warning.path} ${warning.warning} ');
    }
    await createRepository(name, model.path);
  }

  Future<String> get _jsonRawData async {
    if (withArgument.isNotEmpty) {
      return await File(withArgument).readAsString();
    } else {
      try {
        var result = await get(Uri.parse(fromArgument));
        return result.body;
      } on Exception catch (_) {
        throw CliException(
            LocaleKeys.error_failed_to_connect.trArgs([fromArgument]));
      }
    }
  }

  Future<void> createStorageBase() async {
    createSampleBase(StorageBaseSample());

    final dependencies = ['get_storage', 'kt_dart'];
    for (var dependency in dependencies) {
      await PubspecUtils.addDependencies(dependency, runPubGet: false);
    }
    await ShellUtils.pubGet();
  }

  Future<void> createRepository(String name, String modelPath) async {
    if (containsArg('--skipRepository')) return;
    final dataBaseDir = createSampleBase(DataBaseSample());
    final repositoryBaseDir =
        createSampleBase(RepositoryBaseSample(dataBaseDir));

    final sample = RepositorySample(
      name,
      createEndpoints: true,
      baseDir: repositoryBaseDir,
      modelDir: Structure.pathToDirImport(modelPath),
    );

    handleFileCreate(
      name,
      'repository',
      onCommand,
      true,
      sample,
      name.snakeCase,
    );
  }
}
