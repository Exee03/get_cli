import 'dart:io';

import 'package:get_cli/extensions.dart';

import '../../../../core/locales.g.dart';
import '../../../../functions/create/create_single_file_extend.dart';
import '../../../../functions/find_file/is_file_exist.dart';
import '../../../../functions/formatter_dart_file/frommatter_dart_file.dart';
import '../../../../samples/impl/reka/component.dart';
import '../../../../samples/impl/reka/export.dart';
import '../../../interface/command_base.dart';

/// This command is a component with the template:
///```
///
///class NameComponent extends StatelessWidget {
///
///}
///```
class CreateComponentCommand extends CommandBase {
  @override
  String get commandName => 'component';

  @override
  String? get hint => 'Generate component';

  @override
  String get codeSample => 'get create component:name [OPTINAL PARAMETERS] \n'
      '${LocaleKeys.optional_parameters.trArgs(['[on, with]'])} ';

  @override
  Future<void> create(
    String name, {
    String withArgument = '',
    String onCommand = '',
  }) async {
    ComponentSample sample = ComponentSample('', name);

    handleFileCreate(
      name,
      commandName,
      onCommand,
      onCommand.isNotEmpty,
      sample,
      '${commandName}s',
    );

    updateExportFile(sample.path);
  }

  void updateExportFile(String path) {
    String exportFilePath = _getExportFile(path);
    final exportPath = _getExportPath(path);

    final isExist = isFileExist(exportFilePath);

    String content = '';

    if (!isExist) {
      ExportSample sample = ExportSample('', exportPath);
      content = sample.content;
    } else {
      List<String> contentLines = File(exportFilePath).readAsLinesSync();

      contentLines = contentLines.addContent(
        "export '$exportPath';",
        after: 'export',
      );

      content = formatterDartFile(contentLines.join('\n'));
    }

    writeFile(
      exportFilePath,
      content,
      overwrite: true,
      logger: false,
      useRelativeImport: true,
    );
  }

  String _getExportFile(String path) {
    final exportPath = path.split('/');
    exportPath.removeLast();
    return '${exportPath.join('/')}/components.dart';
  }

  String _getExportPath(String path) {
    final exportPath = path.split('/');
    return exportPath.removeLast();
  }
}
