import 'dart:io';

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
  final appRoutesFile = findFileByName('app_routes.dart');
  if (appRoutesFile.path.isNotEmpty) return;

  final routePath = _createRoute('app');

  final routesFile = File(routePath);

  List<String> contentLines = routesFile.readAsLinesSync();

  contentLines = _addContent(
    _getRouteImport(path),
    after: 'import',
    contentLines: contentLines,
  );
  contentLines = _addContent(
    "static const INITIAL =  ${name.pascalCase}Route.${name.toUpperCase()};",
    after: 'extends RouteBase',
    contentLines: contentLines,
  );
  contentLines = _addContent(
    "...${name.pascalCase}Route.routes,",
    after: 'routes =',
    contentLines: contentLines,
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

  contentLines = _addContent(
    _getRouteImport(providerPath),
    after: 'import',
    contentLines: contentLines,
  );
  contentLines = _addContent(
    _getRouteImport(viewPath),
    after: 'import',
    contentLines: contentLines,
  );
  contentLines = _addContent(
    "static const ${name.snakeCase.toUpperCase()} = '/${name.snakeCase.toLowerCase()}';",
    after: 'extends RouteBase',
    contentLines: contentLines,
  );
  contentLines = _addContent(
    '''GetPage(
name: ${name.snakeCase.toUpperCase()},
page:()=> const ${name.pascalCase}View(),
binding: ${name.pascalCase}Provider(),
),];''',
    after: '];',
    contentLines: contentLines,
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

List<String> _addContent(
  String value, {
  required List<String> contentLines,
  required String after,
  bool replace = false,
}) {
  bool added = false;

  contentLines = contentLines.map((e) {
    if (added) return e;
    if (!e.contains(after)) return e;

    added = true;
    if (replace) return value;
    return "$e $value";
  }).toList();

  return contentLines;
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
