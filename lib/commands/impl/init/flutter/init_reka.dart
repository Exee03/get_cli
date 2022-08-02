import 'dart:io';

import '../../../../common/utils/pubspec/pubspec_utils.dart';
import '../../../../core/structure_extend.dart';
import '../../../../functions/create/create_list_directory.dart';
import '../../../../functions/create/create_main.dart';
import '../../../../samples/impl/reka/main.dart';
import '../../commads_export_extend.dart';
import '../../install/install_get.dart';

Future<void> createInitReka() async {
  var canContinue = await createMain();
  if (!canContinue) return;

  var isServerProject = PubspecUtils.isServerProject;
  if (!isServerProject) {
    await installGet();
  }
  RekaMainSample(isServer: isServerProject).create();
  await CreateModuleCommand().execute();
  await CreatePageCommand().execute();
  var initialDirs = [
    Directory(Structure.replaceAsExpected(path: 'lib/app/components/')),
  ];
  createListDirectory(initialDirs);
}
