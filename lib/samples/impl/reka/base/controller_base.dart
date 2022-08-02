import '../../../../common/utils/pubspec/pubspec_utils.dart';
import '../../../interface/sample_interface.dart';

/// [Sample] file from controller_base.dart file creation.
class ControllerBaseSample extends Sample {
  ControllerBaseSample({
    String path = 'lib/app/base/controller_base.dart',
  }) : super(path);

  String get _package => PubspecUtils.isServerProject
      ? "'package:get_server/get_server.dart'"
      : "'package:get/get.dart'";

  @override
  String get content => '''
import $_package;

export $_package;

abstract class ControllerBase extends GetxController {}

''';
}
