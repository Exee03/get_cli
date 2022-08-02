import '../../../../core/internationalization.dart';
import '../../../../core/locales.g.dart';
import '../../../../core/structure_extend.dart';
import '../../../../functions/create/create_single_file_extend.dart';
import '../../../../functions/find_file/find_file_by_name.dart';
import '../../../../samples/impl/reka/base/bloc_base.dart';
import '../../../../samples/impl/reka/bloc.dart';
import '../../../interface/command_base.dart';

/// This command is a bloc with the template:
///```
///
///class NameBloc extends BlocBase {
///
///}
///```
class CreateBlocCommand extends CommandBase {
  @override
  String get commandName => 'bloc';

  @override
  String? get hint => 'Generate bloc';

  @override
  String get codeSample => 'get create bloc:name [OPTINAL PARAMETERS] \n'
      '${LocaleKeys.optional_parameters.trArgs(['[on, with]'])} ';

  @override
  Future<void> create(
    String name, {
    String withArgument = '',
    String onCommand = '',
  }) async {
    final moduleName = onCommand.isNotEmpty ? onCommand : 'app';
    final blocBaseDir = createSampleBase(BlocBaseSample());

    final stateFile = findFileByName('${moduleName}_state.dart');
    final stateDir = Structure.pathToDirImport(stateFile.path);

    BlocSample sample = BlocSample('', name, moduleName, blocBaseDir, stateDir);

    sample = await getCustomContent<BlocSample>(withArgument, sample, name);

    handleFileCreate(
      name,
      commandName,
      onCommand,
      true,
      sample,
      '${commandName}s',
    );

    updateProvider(moduleName, name, sample.path);

    updatePath(sample);
  }
}
