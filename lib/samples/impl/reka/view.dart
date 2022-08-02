import 'package:recase/recase.dart';

import '../../../common/utils/pubspec/pubspec_utils.dart';
import '../../interface/sample_interface.dart';

/// [Sample] file from Module_View file creation.
class GetViewSample extends Sample {
  final String _name;
  final String _baseDir;
  final String _controllerDir;
  final bool _isServer;

  GetViewSample(
    String path,
    this._name,
    this._baseDir,
    this._controllerDir,
    this._isServer, {
    bool overwrite = false,
  }) : super(path, overwrite: overwrite);

  String get import => _controllerDir.isNotEmpty
      ? '''import 'package:${PubspecUtils.projectName}/$_controllerDir';'''
      : '';

  String get _controller => _controllerDir.isNotEmpty
      ? 'ViewBase<${_name.pascalCase}Controller>'
      : 'ViewBase';

  String get _flutterView => '''
import 'package:flutter/material.dart';
import 'package:${PubspecUtils.projectName}/$_baseDir';
$import

class ${_name.pascalCase}View extends $_controller {
 const ${_name.pascalCase}View({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('${_name.pascalCase}'),
        centerTitle: true,
      ),
      body:const Center(
        child: Text(
          '${_name.pascalCase} is working', 
          style: TextStyle(fontSize:20),
        ),
      ),
    );
  }
}
  ''';

  String get _serverView => '''
import 'package:get_server/get_server.dart'; 
import 'package:${PubspecUtils.projectName}/$_baseDir';
$import

class ${_name.pascalCase}View extends $_controller {
  @override
  Widget build(BuildContext context) {
    return const Text('GetX to Server is working!');
  }
}
  ''';

  @override
  String get content => _isServer ? _serverView : _flutterView;
}
