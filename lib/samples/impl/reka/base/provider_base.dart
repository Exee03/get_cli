import '../../../../common/utils/pubspec/pubspec_utils.dart';
import '../../../interface/sample_interface.dart';

/// [Sample] file from provider_base.dart file creation.
class ProviderBaseSample extends Sample {
  ProviderBaseSample({
    String path = 'lib/app/base/provider_base.dart',
  }) : super(path);

  String get _package => PubspecUtils.isServerProject
      ? "'package:get_server/get_server.dart'"
      : "'package:get/get.dart'";

  @override
  String get content => '''
import $_package;

export $_package;

abstract class ProviderBase extends Bindings {
  void init();

  @override
  void dependencies() => init();
}


''';
}
