import '../../../../core/internationalization.dart';
import '../../../../core/locales.g.dart';
import '../../../../functions/create/create_single_file_extend.dart';
import '../../../../samples/impl/reka/base/state_base.dart';
import '../../../../samples/impl/reka/state.dart';
import '../../../interface/command_base.dart';

/// This command is a state with the template:
///```
///
///class NameState extends StateBase {
///
///}
///```
class CreateStateCommand extends CommandBase {
  @override
  String get commandName => 'state';

  @override
  String? get hint => 'Generate state';

  @override
  String get codeSample => 'get create state:name [OPTINAL PARAMETERS] \n'
      '${LocaleKeys.optional_parameters.trArgs(['[on, with]'])} ';

  @override
  Future<void> create(
    String name, {
    String withArgument = '',
    String onCommand = '',
  }) async {
    final moduleName = onCommand.isNotEmpty ? onCommand : 'app';
    final stateBaseDir = createSampleBase(StateBaseSample());

    StateSample sample = StateSample('', name, stateBaseDir);

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
