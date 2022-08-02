import '../../interface/sample_interface.dart';

/// [Sample] file from Export file creation.
class ExportSample extends Sample {
  final String _exportPath;

  ExportSample(
    String path,
    this._exportPath, {
    bool overwrite = false,
  }) : super(
          path,
          overwrite: overwrite,
        );

  @override
  String get content => '''
export '$_exportPath';

''';
}
