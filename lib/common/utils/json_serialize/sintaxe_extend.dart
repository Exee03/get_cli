// ignore_for_file: lines_longer_than_80_chars

import '../pubspec/pubspec_utils.dart';
import 'helpers.dart';
import 'sintaxe.dart' as origin;

export 'sintaxe.dart' hide ClassDefinition;

class ClassDefinition extends origin.ClassDefinition {
  final String _name;
  final bool _privateFields;
  final bool? _withCopyConstructor;
  final Map<String, origin.TypeDefinition> fields =
      <String, origin.TypeDefinition>{};
  final bool _withStorage;

  String get name => _name;

  bool get privateFields => _privateFields;

  bool? get copyConstructor => _withCopyConstructor;

  bool get withStorage => _withStorage;

  ClassDefinition(
    this._name, [
    this._privateFields = false,
    this._withCopyConstructor = false,
    this._withStorage = false,
  ]) : super('');

  void _addTypeDef(origin.TypeDefinition typeDef, StringBuffer sb) {
    sb.write('${typeDef.name}');
    if (typeDef.subtype != null) {
      sb.write('<${typeDef.subtype}>');
      if (PubspecUtils.nullSafeSupport && typeDef.name != 'dynamic') {
        sb.write('?');
      }
    }
  }

  String _generateFieldList({int indentLevel = 1, String delimiter = ';'}) {
    return fields.keys.map((key) {
      final f = fields[key]!;
      final fieldName =
          fixFieldName(key, typeDef: f, privateField: privateFields);
      final sb = StringBuffer();
      sb.write('\t ' * indentLevel);
      _addTypeDef(f, sb);
      sb.write(' $fieldName$delimiter');
      return sb.toString();
    }).join('\n');
  }

  String get _fieldList {
    return _generateFieldList();
  }

  String get _gettersSetters {
    return fields.keys.map((key) {
      final f = fields[key]!;
      final publicFieldName =
          fixFieldName(key, typeDef: f, privateField: false);
      final privateFieldName =
          fixFieldName(key, typeDef: f, privateField: true);
      final sb = StringBuffer();
      sb.write('\t');
      _addTypeDef(f, sb);
      sb.write(' get $publicFieldName => $privateFieldName;'
          '\n\tset $publicFieldName(');
      _addTypeDef(f, sb);
      sb.write(' $publicFieldName) => $privateFieldName = $publicFieldName;');
      return sb.toString();
    }).join('\n');
  }

  String get _defaultPrivateConstructor {
    final sb = StringBuffer();
    sb.write('\t$name({');
    var i = 0;
    var len = fields.keys.length - 1;
    for (var key in fields.keys) {
      final f = fields[key]!;
      final publicFieldName =
          fixFieldName(key, typeDef: f, privateField: false);
      _addTypeDef(f, sb);
      sb.write(' $publicFieldName');
      if (i != len) {
        sb.write(', ');
      }
      i++;
    }
    sb.write('}) {\n');
    for (var key in fields.keys) {
      final f = fields[key];
      final publicFieldName =
          fixFieldName(key, typeDef: f, privateField: false);
      final privateFieldName =
          fixFieldName(key, typeDef: f, privateField: true);
      //sb.write('this.$privateFieldName = $publicFieldName;\n');
      sb.write('$privateFieldName = $publicFieldName;\n');
    }

    sb.write('}');
    return sb.toString();
  }

  String get _defaultConstructor {
    final sb = StringBuffer();
    sb.write('\t$name({');
    var i = 0;
    var len = fields.keys.length - 1;
    for (var key in fields.keys) {
      final f = fields[key];
      final fieldName =
          fixFieldName(key, typeDef: f, privateField: privateFields);
      sb.write('this.$fieldName');
      //sb.write('$fieldName');
      if (i != len) {
        sb.write(', ');
      }
      i++;
    }

    sb.write('});');
    return sb.toString();
  }

  String get _copyConstructor {
    final sb = StringBuffer();
    sb.write('\t$name copyWith({');
    sb.write(_generateFieldList(indentLevel: 2, delimiter: ','));
    sb.write('\t}) {');
    sb.write('\t\treturn $name(');

    for (var key in fields.keys) {
      final f = fields[key];
      final fieldName =
          fixFieldName(key, typeDef: f, privateField: privateFields);
      sb.write('$fieldName: $fieldName ?? this.$fieldName,');
    }

    sb.write(');'); // return $name(...
    sb.write('}');
    return sb.toString();
  }

  String get _jsonParseFunc {
    final sb = StringBuffer();
    sb.write('\t$name');
    sb.write('.fromJson(Map<String, dynamic> json) {\n');
    for (var k in fields.keys) {
      sb.write('\t\t${fields[k]!.jsonParseExpression(k, privateFields)}\n');
    }
    sb.write('\t}');
    return sb.toString();
  }

  String get _jsonGenFunc {
    final sb = StringBuffer();
    sb.write('\tMap<String, dynamic> toJson() {\n\t\t'
        'final  data = <String, dynamic>{};\n');
    for (var k in fields.keys) {
      sb.write('\t\t${fields[k]!.toJsonExpression(k, privateFields)}\n');
    }
    sb.write('\t\treturn data;\n');
    sb.write('\t}');
    return sb.toString();
  }

  String get _classDefinition {
    if (!withStorage) return 'class $name';
    return 'class $name extends $_storageAbstractClass<$name>';
  }

  String get _storageAbstractClass {
    return 'StorageBase';
  }

  String get _storageFunc {
    if (!withStorage) return '';
    final sb = StringBuffer();
    final indexValue = fields.containsKey('id') ? 'id?.toInt() ?? 0' : '0';
    sb.write("\n");
    sb.write("@override\nint get index => $indexValue;\n\n");
    sb.write(
        "@override\n$name Function(dynamic data) get decoder => (data) => $name.fromJson(data);\n\n");
    sb.write("@override\nMap<String, dynamic>? get encoder => toJson();\n\n");
    sb.write("\n");
    return sb.toString();
  }

  @override
  String toString() {
    if (privateFields) {
      return '$_classDefinition {\n$_fieldList\n\n$_defaultPrivateConstructor\n\n'
          '$_gettersSetters\n\n$_jsonParseFunc\n\n$_jsonGenFunc\n$_storageFunc}\n';
    } else {
      if (copyConstructor!) {
        return '$_classDefinition {\n$_fieldList\n\n$_defaultConstructor'
            '\n\n$_copyConstructor\n\n$_jsonParseFunc\n\n$_jsonGenFunc\n$_storageFunc}\n';
      } else {
        return '$_classDefinition {\n$_fieldList\n\n$_defaultConstructor'
            '\n\n$_jsonParseFunc\n\n$_jsonGenFunc\n$_storageFunc}\n';
      }
    }
  }
}
