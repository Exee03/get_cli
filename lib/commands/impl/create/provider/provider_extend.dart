import '../../../../core/internationalization.dart';
import '../../../../core/locales.g.dart';
import '../../../../core/structure_extend.dart';
import '../../../../functions/create/create_single_file_extend.dart';
import '../../../../functions/find_file/find_file_by_name.dart';
import '../../../../samples/impl/reka/base/provider_base.dart';
import '../../../../samples/impl/reka/provider.dart';
import '../../../interface/command_base.dart';

/// This command is a provider with the template:
///```
///
///class NameProvider extends ProviderBase {
///
///}
///```
class CreateProviderCommand extends CommandBase {
  @override
  String get commandName => 'provider';

  @override
  String? get hint => 'Generate provider';

  @override
  String get codeSample => 'get create provider:name [OPTINAL PARAMETERS] \n'
      '${LocaleKeys.optional_parameters.trArgs(['[on, with]'])} ';

  @override
  Future<void> create(
    String name, {
    String withArgument = '',
    String onCommand = '',
  }) async {
    final moduleName = onCommand.isNotEmpty ? onCommand : 'app';
    final providerBaseDir = createSampleBase(ProviderBaseSample());

    final stateFile = findFileByName('${moduleName}_state.dart');
    final stateDir = Structure.pathToDirImport(stateFile.path);
    final blocFile = findFileByName('${moduleName}_bloc.dart');
    final blocDir = Structure.pathToDirImport(blocFile.path);
    final controllerFile = findFileByName('${name}_controller.dart');
    final controllerDir = Structure.pathToDirImport(controllerFile.path);

    ProviderSample sample = ProviderSample(
      '',
      name,
      moduleName,
      blocDir,
      providerBaseDir,
      stateDir,
      controllerDir,
      useAsync: name == 'app',
    );

    sample = await getCustomContent<ProviderSample>(withArgument, sample, name);

    handleFileCreate(
      name,
      commandName,
      onCommand,
      true,
      sample,
      '${commandName}s',
    );

    updatePath(sample);
  }
}
