import '../../../interface/sample_interface.dart';

/// [Sample] file from storage_base.dart file creation.
class StorageBaseSample extends Sample {
  StorageBaseSample({
    String path = 'lib/app/base/storage_base.dart',
  }) : super(path);

  @override
  String get content => '''
import 'dart:convert';

import 'package:get_storage/get_storage.dart';
import 'package:kt_dart/kt.dart';

// DO NOT EDIT. This is code generated

abstract class StorageBase<T> {
  final GetStorage _box = GetStorage();

  int get index;
  T Function(dynamic data)? get decoder;
  Map<String, dynamic>? get encoder;
  String get _key => T.toString();

  static Future<void> init() {
    return GetStorage.init();
  }

  KtList<Map<String, dynamic>> _getAll() {
    try {
      final dataString = _box.read<String>(_key);
      final data = jsonDecode(dataString!) as List;
      return data.map((e) => e as Map<String, dynamic>).toImmutableList();
    } catch (e) {
      return emptyList();
    }
  }

  List<T?> getAll() {
    try {
      final list = _getAll();
      return list.map((e) => decoder?.call(e)).asList();
    } catch (e) {
      return [];
    }
  }

  T? get() {
    try {
      final list = _getAll();

      final data = list.firstOrNull((element) => element['index'] == index);

      return decoder?.call(data!);
    } catch (e) {
      return null;
    }
  }

  Future<void> save({bool allowDuplicate = true}) async {
    try {
      if (!allowDuplicate) await delete();

      final newData = encoder;
      if (newData == null) return;

      final list = _getAll();

      newData.addAll({'index': index});
      final newDatas = list.plusElement(newData);

      final dataString = jsonEncode(newDatas.asList());
      await _box.write(_key, dataString);
    } catch (e) {
      return;
    }
  }

  Future<void> update() async {
    try {
      await save(allowDuplicate: false);
    } catch (e) {
      return;
    }
  }

  Future<void> delete() async {
    try {
      final list = _getAll();
      final filterData = list.filter((element) => element['index'] != index);

      final dataString = jsonEncode(filterData.asList());
      await _box.write(_key, dataString);
    } catch (e) {
      return;
    }
  }

  Future<void> clear() async {
    try {
      await _box.remove(_key);
    } catch (e) {
      return;
    }
  }
}

''';
}
