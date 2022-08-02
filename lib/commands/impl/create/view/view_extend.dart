import 'package:recase/recase.dart';

import '../../../../common/utils/pubspec/pubspec_utils.dart';
import '../../../../core/internationalization.dart';
import '../../../../core/locales.g.dart';
import '../../../../core/structure_extend.dart';
import '../../../../functions/create/create_single_file_extend.dart';
import '../../../../functions/find_file/find_file_by_name.dart';
import '../../../../samples/impl/reka/base/view_base.dart';
import '../../../../samples/impl/reka/view.dart';
import '../../../interface/command_base.dart';

class CreateViewCommand extends CommandBase {
  @override
  String get commandName => 'view';

  @override
  String? get hint => Translation(LocaleKeys.hint_create_view).tr;

  @override
  String get codeSample => 'get create view:delete_dialog';

  @override
  bool validate() {
    return true;
  }

  @override
  Future<void> create(
    String name, {
    String withArgument = '',
    String onCommand = '',
  }) async {
    final controllerFile = findFileByName('${name}_controller.dart');
    final hasController = controllerFile.path.isNotEmpty;
    final viewBaseDir = createSampleBase(ViewBaseSample());
    final controllerDir =
        hasController ? Structure.pathToDirImport(controllerFile.path) : '';

    var sample = GetViewSample(
      '',
      name,
      viewBaseDir,
      controllerDir,
      PubspecUtils.isServerProject,
    );

    sample = await getCustomContent<GetViewSample>(withArgument, sample, name);

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
