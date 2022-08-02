import '../../../../common/utils/pubspec/pubspec_utils.dart';
import '../../../interface/sample_interface.dart';

/// [Sample] file from state_base.dart file creation.
class StateBaseSample extends Sample {
  StateBaseSample({
    String path = 'lib/app/base/state_base.dart',
  }) : super(path);

  String get _package => PubspecUtils.isServerProject
      ? "'package:get_server/get_server.dart'"
      : "'package:get/get.dart'";

  @override
  String get content => '''
import $_package;

export $_package;

abstract class StateBase extends GetxService {}

''';
}
