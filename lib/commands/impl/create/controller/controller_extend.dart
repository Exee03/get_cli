import '../../../../common/utils/pubspec/pubspec_utils.dart';
import '../../../../core/internationalization.dart';
import '../../../../core/locales.g.dart';
import '../../../../core/structure_extend.dart';
import '../../../../functions/create/create_single_file_extend.dart';
import '../../../../functions/find_file/find_file_by_name.dart';
import '../../../../samples/impl/reka/base/controller_base.dart';
import '../../../../samples/impl/reka/controller.dart';
import '../../../interface/command_base.dart';

/// This command is a controller with the template:
///```
///import 'package:get/get.dart';,
///
///class NameController extends GetxController {
///
///}
///```
class CreateControllerCommand extends CommandBase {
  @override
  String get commandName => 'controller';

  @override
  String? get hint => LocaleKeys.hint_create_controller.tr;

  @override
  String get codeSample => 'get create controller:name [OPTINAL PARAMETERS] \n'
      '${LocaleKeys.optional_parameters.trArgs(['[on, with]'])} ';

  @override
  Future<void> create(
    String name, {
    String withArgument = '',
    String onCommand = '',
  }) async {
    final moduleName = onCommand.isNotEmpty ? onCommand : 'app';
    final controllerBaseDir = createSampleBase(ControllerBaseSample());

    final blocFile = findFileByName('${moduleName}_bloc.dart');
    final blocDir = Structure.pathToDirImport(blocFile.path);

    ControllerSample sample = ControllerSample(
      '',
      name,
      moduleName,
      controllerBaseDir,
      blocDir,
    );

    sample =
        await getCustomContent<ControllerSample>(withArgument, sample, name);

    handleFileCreate(
      name,
      commandName,
      onCommand,
      true,
      sample,
      '${commandName}s',
    );

    if (!hasModule) updateProvider(moduleName, name, sample.path);

    updatePath(sample);
  }
}
