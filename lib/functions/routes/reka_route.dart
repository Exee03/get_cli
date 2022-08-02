import 'dart:io';

import 'package:get_cli/extensions.dart';
import 'package:recase/recase.dart';

import '../../common/utils/logger/log_utils.dart';
import '../../core/internationalization.dart';
import '../../core/locales.g.dart';
import '../../core/structure_extend.dart';
import '../../functions/create/create_single_file_extend.dart';
import '../../common/utils/pubspec/pubspec_utils.dart';
import '../../samples/impl/reka/base/route_base.dart';
import '../../samples/impl/reka/route.dart';
import '../create/create_single_file_extend.dart';
import '../find_file/find_file_by_name.dart';
import '../formatter_dart_file/frommatter_dart_file.dart';

void _createAppRoute(String name, String path) {
  final appRoutesFile = findFileByName('app_route.dart');
  String appRoutePath = appRoutesFile.path;

  final isExist = appRoutePath.isNotEmpty;
  if (!isExist) appRoutePath = _createRoute('app');

  final routesFile = File(appRoutePath);

  List<String> contentLines = routesFile.readAsLinesSync();

  if (!isExist) {
    contentLines = contentLines.addContent(
      "static const INITIAL =  ${name.pascalCase}Route.${name.toUpperCase()};",
      after: 'extends RouteBase',
    );
  }

  contentLines = contentLines
      .addContent(
        _getRouteImport(path),
        after: 'import',
      )
      .addContent(
        "...${name.pascalCase}Route.routes,",
        after: 'routes =',
      );
  final content = formatterDartFile(contentLines.join('\n'));

  writeFile(
    routesFile.path,
    content,
    overwrite: true,
    logger: false,
    useRelativeImport: true,
  );
}

void createModuleRoute(String name) {
  final moduleRoutePath = _createRoute(name);

  _createAppRoute(name, moduleRoutePath);
}

void updateRoute(
    String name, String moduleName, String providerPath, String viewPath) {
  final routesFile = findFileByName('${moduleName.snakeCase}_route.dart');

  List<String> contentLines = routesFile.readAsLinesSync();

  contentLines = contentLines
      .addContent(
        _getRouteImport(providerPath),
        after: 'import',
      )
      .addContent(
        _getRouteImport(viewPath),
        after: 'import',
      )
      .addContent(
        "static const ${name.snakeCase.toUpperCase()} = '/${name.snakeCase.toLowerCase()}';",
        after: 'extends RouteBase',
      )
      .addContent(
        'GetPage(name: ${name.snakeCase.toUpperCase()},page:()=> const ${name.pascalCase}View(),binding: ${name.pascalCase}Provider(),),];',
        after: '];',
        replace: true,
      );
  final content = formatterDartFile(contentLines.join('\n'));

  writeFile(
    routesFile.path,
    content,
    overwrite: true,
    logger: false,
    useRelativeImport: true,
  );

  LogService.success(
      Translation(LocaleKeys.sucess_route_created).trArgs([name.pascalCase]));
}

String _getRouteImport(String dir) {
  var import =
      "import 'package:${PubspecUtils.projectName}/${Structure.pathToDirImport(dir)}';";
  return import;
}

String _createRoute(String name) {
  final routeBaseDir = createSampleBase(RouteBaseSample());

  RouteSample sample = RouteSample('', name, routeBaseDir);

  handleFileCreate(
    name,
    'route',
    name,
    true,
    sample,
    'routes',
    '_',
    true,
  );

  return sample.path;
}
