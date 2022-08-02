import '../../../../common/utils/pubspec/pubspec_utils.dart';
import '../../../interface/sample_interface.dart';

/// [Sample] file from bloc_base.dart file creation.
class BlocBaseSample extends Sample {
  BlocBaseSample({
    String path = 'lib/app/base/bloc_base.dart',
  }) : super(path);

  String get _package => PubspecUtils.isServerProject
      ? "'package:get_server/get_server.dart'"
      : "'package:get/get.dart'";

  @override
  String get content => '''
import $_package;

export $_package;

abstract class BlocBase extends GetxService {}

''';
}
