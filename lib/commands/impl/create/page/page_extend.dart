import 'dart:io';

import 'package:dcli/dcli.dart';
import 'package:recase/recase.dart';

import '../../../../common/menu/menu.dart';
import '../../../../common/utils/logger/log_utils.dart';
import '../../../../core/generator.dart';
import '../../../../core/internationalization.dart';
import '../../../../core/locales.g.dart';
import '../../../../core/structure_extend.dart';
import '../../../../functions/routes/reka_route.dart';
import '../../../interface/command_base.dart';
import '../../commads_export_extend.dart';

/// The command create a Binding and Controller page and view
class CreatePageCommand extends CommandBase {
  @override
  String get commandName => 'page';

  @override
  List<String> get alias => ['module', '-p', '-m'];

  @override
  String? get hint =>
      '${LocaleKeys.hint_create_page.tr} (controller/provider/view)';

  @override
  String get codeSample => 'get create page:name [OPTINAL PARAMETERS] \n'
      '${LocaleKeys.optional_parameters.trArgs(['[on, with]'])} ';

  @override
  Future<void> execute() async {
    var isProject = false;
    if (GetCli.arguments[0] == 'create' || GetCli.arguments[0] == '-c') {
      isProject = GetCli.arguments[1].split(':').first == 'project';
    }
    var name = this.name;
    if (name.isEmpty || isProject) {
      name = 'home';
    }
    checkForAlreadyExists(name);
  }

  void checkForAlreadyExists(String? name) {
    var newFileModel =
        Structure.model(name, 'page', true, on: onCommand, folderName: name);
    var pathSplit = Structure.safeSplitPath(newFileModel.path!);

    pathSplit.removeLast();
    var path = pathSplit.join('/');
    path = Structure.replaceAsExpected(path: path);
    if (Directory(path).existsSync()) {
      final menu = Menu(
        [
          LocaleKeys.options_yes.tr,
          LocaleKeys.options_no.tr,
          LocaleKeys.options_rename.tr,
        ],
        title:
            Translation(LocaleKeys.ask_existing_page.trArgs([name])).toString(),
      );
      final result = menu.choose();
      if (result.index == 0) {
        _writeFiles(path, name!, overwrite: true);
      } else if (result.index == 2) {
        // final dialog = CLI_Dialog();
        // dialog.addQuestion(LocaleKeys.ask_new_page_name.tr, 'name');
        // name = dialog.ask()['name'] as String?;
        var name = ask(LocaleKeys.ask_new_page_name.tr);
        checkForAlreadyExists(name.trim().snakeCase);
      }
    } else {
      if (onCommand.isEmpty) Directory(path).createSync(recursive: true);
      _writeFiles(path, name!, overwrite: false);
    }
  }

  Future<void> _writeFiles(
    String path,
    String name, {
    bool overwrite = false,
  }) async {
    await CreateControllerCommand().handle(name);
    final viewPath = (await CreateViewCommand().handle(name)).path;
    final providerPath = (await CreateProviderCommand().handle(name)).path;

    final moduleName = onCommand.isNotEmpty ? onCommand : name;
    updateRoute(
      name,
      moduleName,
      providerPath,
      viewPath,
    );

    LogService.success(LocaleKeys.sucess_page_create.trArgs([name.pascalCase]));
  }

  @override
  Future<void> create(String name,
          {String withArgument = '', String onCommand = ''}) =>
      execute();
}
