import '../../interface/sample_interface.dart';

class RekaMainSample extends Sample {
  final bool? isServer;
  RekaMainSample({this.isServer}) : super('lib/main.dart', overwrite: true);

  String get _flutterMain => '''import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'app/routes/app_route.dart';

void main() {
  runApp(
    GetMaterialApp(
      title: "Application",
      initialRoute: AppRoute.INITIAL,
      getPages: AppRoute.routes,
    ),
  );
}
  ''';

  String get _serverMain => '''import 'package:get_server/get_server.dart';
import 'app/routes/app_pages.dart';

void main() {
  runApp(GetServer(
    getPages: AppPages.routes,
  ));
}
  ''';

  @override
  String get content => isServer! ? _serverMain : _flutterMain;
}
