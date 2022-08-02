import '../../../../common/utils/pubspec/pubspec_utils.dart';
import '../../../interface/sample_interface.dart';

/// [Sample] file from route_base.dart file creation.
class RouteBaseSample extends Sample {
  RouteBaseSample({
    String path = 'lib/app/base/route_base.dart',
  }) : super(path);

  String get _package => PubspecUtils.isServerProject
      ? "'package:get_server/get_server.dart'"
      : "'package:get/get.dart'";

  @override
  String get content => '''
import $_package;

export $_package;

abstract class RouteBase {
  List<GetPage<dynamic>>? _routes;

  List<String> get paths => _routes?.map((route) => route.name).toList() ?? [];

  void setRoute(List<GetPage<dynamic>> routes) {
    _routes = routes;
  }
}

''';
}
