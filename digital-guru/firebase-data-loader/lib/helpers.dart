import 'dart:convert' as Convert;
import 'dart:math';
import 'package:json_to_dart/syntax.dart';
import 'package:squint_json/squint_json.dart';

const Map<String, bool> PRIMITIVE_TYPES = const {
  'int': true,
  'double': true,
  'String': true,
  'bool': true,
  'DateTime': false,
  'List<DateTime>': false,
  'List<int>': true,
  'List<double>': true,
  'List<String>': true,
  'List<bool>': true,
  'Null': true,
};

enum ListType { Object, String, Double, Int, Null }

class MergeableListType {
  final ListType listType;
  final bool isAmbigous;

  MergeableListType(this.listType, this.isAmbigous);
}

MergeableListType mergeableListType(List<dynamic> list) {
  ListType t = ListType.Null;
  bool isAmbigous = false;
  list.forEach((e) {
    ListType inferredType = ListType.Null;
    if (e.runtimeType == 'int') {
      inferredType = ListType.Int;
    } else if (e.runtimeType == 'double') {
      inferredType = ListType.Double;
    } else if (e.runtimeType == 'string') {
      inferredType = ListType.String;
    } else if (e is Map) {
      inferredType = ListType.Object;
    }
    if (t != ListType.Null && t != inferredType) {
      isAmbigous = true;
    }
    t = inferredType;
  });
  return MergeableListType(t, isAmbigous);
}

String camelCase(String text) {
  String capitalize(Match m) =>
      m[0]!.substring(0, 1).toUpperCase() + m[0]!.substring(1);
  String skip(String s) => "";
  return text.splitMapJoin(new RegExp(r'[a-zA-Z0-9]+'),
      onMatch: capitalize, onNonMatch: skip);
}

String camelCaseFirstLower(String text) {
  final camelCaseText = camelCase(text);
  final firstChar = camelCaseText.substring(0, 1).toLowerCase();
  final rest = camelCaseText.substring(1);
  return '$firstChar$rest';
}

decodeJSON(String rawJson) {
  return Convert.json.decode(rawJson);
}

WithWarning<Map> mergeObj(Map obj, Map other, String path) {
  List<Warning> warnings = <Warning>[];
  final Map clone = Map.from(obj);
  other.forEach((k, v) {
    if (clone[k] == null) {
      clone[k] = v;
    } else {
      final String otherType = getTypeName(v);
      final String t = getTypeName(clone[k]);
      if (t != otherType) {
        if (t == 'int' && otherType == 'double') {
          // if double was found instead of int, assign the double
          clone[k] = v;
        } else if (clone[k].runtimeType != 'double' && v.runtimeType != 'int') {
          // if types are not equal, then
          warnings.add(newAmbiguousType('$path/$k'));
        }
      } else if (t == 'List') {
        List l = List.from(clone[k]);
        l.addAll(other[k]);
        final mergeableType = mergeableListType(l);
        if (ListType.Object == mergeableType.listType) {
          WithWarning<Map> mergedList = mergeObjectList(l, '$path');
          warnings.addAll(mergedList.warnings);
          clone[k] = List.filled(1, mergedList.result);
        } else {
          if (l.length > 0) {
            clone[k] = List.filled(1, l[0]);
          }
          if (mergeableType.isAmbigous) {
            warnings.add(newAmbiguousType('$path/$k'));
          }
        }
      } else if (t == 'Class') {
        WithWarning<Map> mergedObj = mergeObj(clone[k], other[k], '$path/$k');
        warnings.addAll(mergedObj.warnings);
        clone[k] = mergedObj.result;
      }
    }
  });
  return new WithWarning(clone, warnings);
}

WithWarning<Map> mergeObjectList(List<dynamic> list, String path,
    [int idx = -1]) {
  List<Warning> warnings = <Warning>[];
  Map<String, dynamic> obj = <String, dynamic>{};
  for (var i = 0; i < list.length; i++) {
    final toMerge = list[i];
    if (toMerge is Map) {
      toMerge.forEach((k, v) {
        final String t = getTypeName(obj[k]);
        if (obj[k] == null) {
          obj[k] = v;
        } else {
          final String otherType = getTypeName(v);
          if (t != otherType) {
            if (t == 'int' && otherType == 'double') {
              // if double was found instead of int, assign the double
              obj[k] = v;
            } else if (t != 'double' && otherType != 'int') {
              // if types are not equal, then
              int realIndex = i;
              if (idx != -1) {
                realIndex = idx - i;
              }
              final String ambiguosTypePath = '$path[$realIndex]/$k';
              warnings.add(newAmbiguousType(ambiguosTypePath));
            }
          } else if (t == 'List') {
            List l = List.from(obj[k]);
            final int beginIndex = l.length;
            l.addAll(v);
            // bug is here
            final mergeableType = mergeableListType(l);
            if (ListType.Object == mergeableType.listType) {
              WithWarning<Map> mergedList =
                  mergeObjectList(l, '$path[$i]/$k', beginIndex);
              warnings.addAll(mergedList.warnings);
              obj[k] = List.filled(1, mergedList.result);
            } else {
              if (l.length > 0) {
                obj[k] = List.filled(1, l[0]);
              }
              if (mergeableType.isAmbigous) {
                warnings.add(newAmbiguousType('$path[$i]/$k'));
              }
            }
          } else if (t == 'Class') {
            int properIndex = i;
            if (idx != -1) {
              properIndex = i - idx;
            }
            WithWarning<Map> mergedObj = mergeObj(
              obj[k],
              v,
              '$path[$properIndex]/$k',
            );
            warnings.addAll(mergedObj.warnings);
            obj[k] = mergedObj.result;
          }
        }
      });
    }
  }
  return new WithWarning(obj, warnings);
}

isPrimitiveType(String typeName) {
  final isPrimitive = PRIMITIVE_TYPES[typeName];
  if (isPrimitive == null) {
    return false;
  }
  return isPrimitive;
}

String fixFieldName(String name,
    {TypeDefinition? typeDef, bool privateField = false}) {
  var properName = name;
  if (name.startsWith('_') || name.startsWith(new RegExp(r'[0-9]'))) {
    final firstCharType = typeDef?.name.substring(0, 1).toLowerCase() ?? '';
    properName = '$firstCharType$name';
  }
  final fieldName = camelCaseFirstLower(properName);
  if (privateField) {
    return '_$fieldName';
  }
  return fieldName;
}

String getTypeName(dynamic obj) {
  if (obj is String) {
    return 'String';
  } else if (obj is int) {
    return 'int';
  } else if (obj is double) {
    return 'double';
  } else if (obj is bool) {
    return 'bool';
  } else if (obj == null) {
    return 'Null';
  } else if (obj is List) {
    return 'List';
  } else {
    // assumed class
    return 'Class';
  }
}

JsonNode? navigateNode(JsonNode astNode, String path) {
  if (astNode is JsonObject) {
    if (astNode.data.containsKey(path)) {
      return astNode.data[path];
    }
  }
  if (astNode is JsonArray) {
    final index = int.tryParse(path);
    if (index != null && index < astNode.data.length) {
      return astNode.data[index];
    }
  }
  return null;
}

final _pattern = RegExp(r"([0-9]+)\.{0,1}([0-9]*)e(([-0-9]+))");

bool isASTLiteralDouble(JsonNode astNode) {
  // squint_json uses JsonFloatingNumber for doubles
  if (astNode is JsonFloatingNumber) {
    return true;
  }
  // Optionally, check for string representations of doubles
  if (astNode is JsonString) {
    final raw = astNode.data;
    final containsPoint = raw.contains('.') || raw.contains('e');
    if (containsPoint) {
      final matches = _pattern.firstMatch(raw);
      if (matches != null) {
        final integer = matches[1] ?? '';
        final comma = matches[2] ?? '';
        final exponent = matches[3] ?? '';
        return _isDoubleWithExponential(integer, comma, exponent);
      }
    }
  }
  return false;
}

bool _isDoubleWithExponential(String integer, String comma, String exponent) {
  final integerNumber = int.tryParse(integer) ?? 0;
  final exponentNumber = int.tryParse(exponent) ?? 0;
  final commaNumber = int.tryParse(comma) ?? 0;
  if (exponentNumber != null) {
    if (exponentNumber == 0) {
      return commaNumber > 0;
    }
    if (exponentNumber > 0) {
      return exponentNumber < comma.length && commaNumber > 0;
    }
    return commaNumber > 0 ||
        ((integerNumber.toDouble() * pow(10, exponentNumber)).remainder(1) > 0);
  }
  return false;
}
