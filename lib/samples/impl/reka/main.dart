import 'package:recase/recase.dart';

import '../../interface/sample_interface.dart';

class RekaMainSample extends Sample {
  final String _name;
  final bool? isServer;

  RekaMainSample(
    this._name, {
    this.isServer,
  }) : super('lib/main.dart', overwrite: true);

  String get _flutterMain => '''import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'app/providers/app_provider.dart';
import 'app/routes/app_route.dart';

Future<void> main() async {
  await AppProvider().init();

  runApp(
    GetMaterialApp(
      title: '${_name.pascalCase}',
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
