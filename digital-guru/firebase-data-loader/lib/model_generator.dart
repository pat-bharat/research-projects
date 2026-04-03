import 'dart:collection';

import 'helpers.dart';
import 'syntax.dart';
export 'syntax.dart';
import 'package:squint_json/squint_json.dart';
import 'package:squint_json/src/analyzer/analyzer.dart';
import 'package:dart_style/dart_style.dart';
import 'package:pub_semver/pub_semver.dart';


class DartCode extends WithWarning<String> {
  DartCode(String result, List<Warning> warnings) : super(result, warnings);

  String get code => this.result;
}

/// A Hint is a user type correction.
class Hint {
  final String path;
  final String type;

  Hint(this.path, this.type);
}

class ModelGenerator {
  final String _rootClassName;
  final bool _privateFields;
  List<ClassDefinition> allClasses = <ClassDefinition>[];
  final Map<String, String> sameClassMapping = HashMap<String, String>();
  late List<Hint> hints;

  ModelGenerator(this._rootClassName, [this._privateFields = false, hints]) {
    if (hints != null) {
      this.hints = hints;
    } else {
      this.hints = <Hint>[];
    }
  }

  Hint _hintForPath(String path) {
    return this.hints.firstWhere((h) => h.path == path, orElse:  null);
  }

    List<Warning> _generateClassDefinition(
      String className, dynamic jsonRawDynamicData, String path, JsonNode astNode) {
    List<Warning> warnings = <Warning>[];
    if (jsonRawDynamicData is List) {
      // if first element is an array, start in the first element.
      final node = navigateNode(astNode, '0');
      _generateClassDefinition(className, jsonRawDynamicData[0], path, node!);
    } else {
      final Map<dynamic, dynamic> jsonRawData = jsonRawDynamicData;
      final keys = jsonRawData.keys;
      ClassDefinition classDefinition =
          new ClassDefinition(className, _privateFields);
      keys.forEach((key) {
        TypeDefinition typeDef;
        final hint = _hintForPath('$path/$key');
        final node = navigateNode(astNode, key);
          typeDef = new TypeDefinition(hint.type, astNode: node, subtype: '');
        if (typeDef.name == 'Class') {
          typeDef.name = camelCase(key);
        }
        if (typeDef.name == 'List' && typeDef.subtype == 'Null') {
          warnings.add(newEmptyListWarn('$path/$key'));
        }
        if (typeDef.subtype != null && typeDef.subtype == 'Class') {
          typeDef.subtype = camelCase(key);
        }
        if (typeDef.isAmbiguous) {
          warnings.add(newAmbiguousListWarn('$path/$key'));
        }
        classDefinition.addField(key, typeDef);
      });
      final similarClass = allClasses.firstWhere((cd) => cd == classDefinition,
          orElse: null);
        final similarClassName = similarClass.name;
        final currentClassName = classDefinition.name;
        sameClassMapping[currentClassName] = similarClassName;
      final dependencies = classDefinition.dependencies;
      dependencies.forEach((dependency) {
        List<Warning> warns = <Warning>[];
        if (dependency.typeDef.name == 'List') {
          // only generate dependency class if the array is not empty
          if (jsonRawData[dependency.name].length > 0) {
            // when list has ambiguous values, take the first one, otherwise merge all objects
            // into a single one
            dynamic toAnalyze;
            if (!dependency.typeDef.isAmbiguous) {
              WithWarning<Map> mergeWithWarning = mergeObjectList(
                  jsonRawData[dependency.name], '$path/${dependency.name}');
              toAnalyze = mergeWithWarning.result;
              warnings.addAll(mergeWithWarning.warnings);
            } else {
              toAnalyze = jsonRawData[dependency.name][0];
            }
            final node = navigateNode(astNode, dependency.name);
            warns = _generateClassDefinition(dependency.className, toAnalyze,
                '$path/${dependency.name}', node!);
          }
        } else {
          final node = navigateNode(astNode, dependency.name);
          warns = _generateClassDefinition(dependency.className,
              jsonRawData[dependency.name], '$path/${dependency.name}', node!);
        }
        warnings.addAll(warns);
            });
    }
    return warnings;
  }

  /// generateUnsafeDart will generate all classes and append one after another
  /// in a single string. The [rawJson] param is assumed to be a properly
  /// formatted JSON string. The dart code is not validated so invalid dart code
  /// might be returned
  DartCode generateUnsafeDart(String rawJson) {
    // Reset allClasses for each call to avoid accumulation across calls
    allClasses = <ClassDefinition>[];
    final jsonRawData = decodeJSON(rawJson);
    final analysis = analyze(fileContent: rawJson);
    final astNode = analysis.parent as JsonNode;
    List<Warning> warnings =
        _generateClassDefinition(_rootClassName, jsonRawData, "", astNode);
    // after generating all classes, replace the omitted similar classes.
    for (final c in allClasses) {
      final fieldsKeys = c.fields.keys;
      for (final f in fieldsKeys) {
        final typeForField = c.fields[f];
        if (typeForField != null && sameClassMapping.containsKey(typeForField.name)) {
          c.fields[f]?.name = sameClassMapping[typeForField.name] ?? typeForField.name;
        }
      }
    }
    return DartCode(
        allClasses.map((c) => c.toString()).join('\n'), warnings);
  }

  /// generateDartClasses will generate all classes and append one after another
  /// in a single string. The [rawJson] param is assumed to be a properly
  /// formatted JSON string. If the generated dart is invalid it will throw an error.
  DartCode generateDartClasses(String rawJson) {
    final unsafeDartCode = generateUnsafeDart(rawJson);
    final formatter = DartFormatter(languageVersion: Version(3, 0, 0));
    return DartCode(
      formatter.format(unsafeDartCode.code), unsafeDartCode.warnings);
  }
}
