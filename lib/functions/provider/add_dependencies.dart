import 'dart:io';

import 'package:recase/recase.dart';

import '../../common/utils/logger/log_utils.dart';
import '../../common/utils/pubspec/pubspec_utils.dart';
import '../../core/internationalization.dart';
import '../../core/locales.g.dart';
import '../create/create_single_file.dart';
import '../path/replace_to_relative.dart';

///
/// Add a new dependency to bindings
///
///Example your providers look like this:
/// ```
///import 'package:get/get.dart';
///import 'home_controller.dart';
///class HomeProvider extends ProviderBase {
///   @override
///   void init() {
///     Get.lazyPut<HomeController>(() => HomeController());
///   }
///}
///
///addDependencyToProvider('PATH_YOUR_PROVIDER',
/// 'DEPENDENCY_NAME', 'DEPENDENCY_DIR' );
///
/// //the exit will be:
///
///import 'package:get/get.dart';
///import 'home_controller.dart';
///import 'package:example/DEPENDENCY_DIR';
///class HomeProvider extends ProviderBase {
///    @override
///    void init() {
///      Get.lazyPut<DEPENDENCY_NAME>(() => DEPENDENCY_NAME());
///      Get.lazyPut<HomeController>(() => HomeController());
///    }
///}
///```
void addDependencyToProvider(
  String path,
  String name,
  String command,
  String dir,
) {
  final import = '''import 'package:${PubspecUtils.projectName}/$dir';''';
  final content =
      '''Get.lazyPut<${name.pascalCase}${command.pascalCase}>(() => ${name.pascalCase}${command.pascalCase}());''';

  final file = File(path);

  if (!file.existsSync()) return;

  final lines = file.readAsLinesSync();
  lines.insert(2, replaceToRelativeImport(import, file.path));

  int index = lines.indexWhere((element) {
    element = element.trim();
    final isAsync = element.contains('async');
    if (isAsync) return element.startsWith('Future<void> init() async {');
    return element.startsWith('void init() {');
  });
  lines.insert(index + 1, content);

  writeFile(file.path, lines.join('\n'), overwrite: true, logger: false);

  LogService.success(LocaleKeys.sucess_add_controller_in_bindings
      .trArgs(['${name.pascalCase}${command.pascalCase}', path]));
}
