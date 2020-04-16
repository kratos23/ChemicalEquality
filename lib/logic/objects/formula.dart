import 'package:chemeq/logic/objects/element.dart';

class Formula {
  int factor = 1;

  List<Object> elements = [];

  static final subscript = {
    '0': '\u2080',
    '1': '\u2081',
    '2': '\u2082',
    '3': '\u2083',
    '4': '\u2084',
    '5': '\u2085',
    '6': '\u2086',
    '7': '\u2087',
    '8': '\u2088',
    '9': '\u2089'
  };

  static String intToSubscript(int x) {
    var s = x.toString();
    var sb = StringBuffer();
    for (var i = 0; i < s.length; i++) {
      sb.write(subscript[s[i]]);
    }
    return sb.toString();
  }

  String _toStringInternal([bool start = false]) {
    var result = "";
    if (start) {
      if (factor > 1) {
        result += factor.toString();
      }
      elements.forEach((part) {
        if (part is Formula) {
          result += part._toStringInternal();
        } else {
          result += part.toString();
        }
      });
    } else {
      if (factor > 1 && elements.length > 1) {
        result += "(";
      }
      elements.forEach((part) {
        if (part is Formula) {
          result += part._toStringInternal();
        } else {
          result += part.toString();
        }
      });
      if (factor > 1) {
        if (elements.length > 1) {
          result += ")";
        }
        result += intToSubscript(factor);
      }
    }
    return result;
  }

  @override
  String toString() {
    return _toStringInternal(true);
  }
}

void main() {
}
