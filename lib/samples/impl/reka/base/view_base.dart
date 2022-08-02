import '../../../../common/utils/pubspec/pubspec_utils.dart';
import '../../../interface/sample_interface.dart';

/// [Sample] file from view_base.dart file creation.
class ViewBaseSample extends Sample {
  ViewBaseSample({
    String path = 'lib/app/base/view_base.dart',
  }) : super(path);

  String get _package => PubspecUtils.isServerProject
      ? "'package:get_server/get_server.dart'"
      : "'package:get/get.dart'";

  @override
  String get content => '''
import $_package;
import 'package:flutter/foundation.dart';

export $_package;

abstract class ViewBase<T> extends GetView<T> {
  const ViewBase({Key? key}) : super(key: key);
}

''';
}
