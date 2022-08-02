import 'dart:io';

import 'package:http/http.dart';
import 'package:path/path.dart';

import '../../../../core/internationalization.dart';
import '../../../../core/locales.g.dart';
import '../../../../exception_handler/exceptions/cli_exception.dart';
import '../../core/structure_extend.dart';
import '../../functions/is_url/is_url.dart';
import '../../functions/provider/add_dependencies.dart';
import '../../functions/provider/find_provider.dart';
import '../../functions/replace_vars/replace_vars.dart';
import '../../samples/interface/sample_interface.dart';
import 'command.dart';

abstract class CommandBase extends Command {
  String? _path;

  String get path => _path ?? '';

  void updatePath(Sample sample) {
    _path = sample.path;
  }

  bool get hasModule => onCommand.isNotEmpty;

  @override
  int get maxParameters => 0;

  @override
  bool validate() {
    super.validate();
    if (args.length > 2) {
      var unnecessaryParameter = args.skip(2).toList();
      throw CliException(
          LocaleKeys.error_unnecessary_parameter.trArgsPlural(
            LocaleKeys.error_unnecessary_parameter_plural,
            unnecessaryParameter.length,
            [unnecessaryParameter.toString()],
          ),
          codeSample: codeSample);
    }
    return true;
  }

  @override
  Future<void> execute() async {
    return create(
      name,
      withArgument: withArgument,
      onCommand: onCommand,
    );
  }

  Future<CommandBase> handle(String name) async {
    final on = onCommand.isEmpty ? name : onCommand;
    create(
      name,
      withArgument: withArgument,
      onCommand: on,
    );

    return this;
  }

  Future<void> create(
    String name, {
    String withArgument = '',
    String onCommand = '',
  });

  Future<T> getCustomContent<T>(
    String withArgument,
    Sample sample,
    String name,
  ) async {
    if (withArgument.isEmpty) return sample as T;

    try {
      final content = await _getContent(withArgument);

      sample.customContent = replaceVars(content, name);
      return sample as T;
    } catch (e) {
      throw CliException(
          LocaleKeys.error_failed_to_connect.trArgs([withArgument]));
    }
  }

  Future<String> _getContent(String withArgument) async {
    final isUrl = isURL(withArgument);
    if (isUrl) {
      final res = await get(Uri.parse(withArgument));
      if (res.statusCode != 200) throw 'Error';
      return res.body;
    } else {
      final file = File(withArgument);
      if (!file.existsSync()) throw 'Error';
      return file.readAsStringSync();
    }
  }

  updateProvider(String moduleName, String name, String path) {
    final providerPath = findProviderFromName(path, basename(moduleName));
    if (providerPath.isEmpty) return;

    final controllerDir = Structure.pathToDirImport(path);
    addDependencyToProvider(providerPath, name, commandName, controllerDir);
  }
}
