import 'objects/formula.dart';
import 'objects/element.dart';

class FormulaParser {
  final String s;

  var pos = 0;

  FormulaParser(this.s);

  int _zero = "0".codeUnits[0];
  int _nine = "9".codeUnits[0];
  int _alphaStart1 = "a".codeUnits[0];
  int _alphaEnd1 = "z".codeUnitAt(0);
  int _alphaStart2 = "A".codeUnitAt(0);
  int _alphaEnd2 = "Z".codeUnitAt(0);

  bool _isDigit(String s, [int idx = 0]) =>
      s.codeUnits[idx] >= _zero && s.codeUnits[idx] <= _nine;

  bool _isLetter(String s) {
    int n = s.codeUnitAt(0);
    return (_alphaStart1 <= n && n <= _alphaEnd1) ||
        (_alphaStart2 <= n && n <= _alphaEnd2);
  }

  int nextInt() {
    String res = "";
    while (pos < s.length && _isDigit(s[pos])) {
      res += s[pos++];
    }
    return int.parse(res);
  }

  _isLowerCase(String c) {
    return c == c.toLowerCase();
  }

  Element nextElement() {
    String symbol = "";
    symbol += s[pos++];
    while (pos < s.length && _isLowerCase(s[pos]) && _isLetter(s[pos])) {
      symbol += s[pos++];
    }
    return Element(symbol);
  }

  Formula _parseInternal() {
    var posStart = pos;
    if (_isLetter(s[pos])) {
      var el = nextElement();
      var res = Formula();
      res.factor = 1;
      res.elements.add(el);
      if (pos < s.length && _isDigit(s[pos])) {
        res.factor = nextInt();
      }
      return res;
    }
    var factor = 1;
    var res = Formula();
    if (_isDigit(s[pos])) {
      factor = nextInt();
    }
    if (pos < s.length && s[pos] == '(') {
      pos++;
    }
    while (pos < s.length && s[pos] != ')' && pos != posStart
    &&(_isLetter(s[pos]) || _isDigit(s[pos])  || s[pos] == '(')) {
      res.elements.add(_parseInternal());
    }
    pos++;

    if (pos < s.length && _isDigit(s[pos])) {
      factor *= nextInt();
    }
    res.factor = factor;
    return res;
  }

  List<Formula> parse() {
    List<Formula> res = [];
    while (pos < s.length) {
      while (pos < s.length && (s[pos] == ' ' || s[pos] == '+')) {
        pos++;
      }
      var cur = Formula();
      cur.factor = 1;
      while (pos < s.length && s[pos] != ' ' && s[pos] != '+') {
        cur.elements.add(_parseInternal());
      }
      if (cur.elements.length == 1) {
        cur = cur.elements[0];
      }
      res.add(cur);
    }
    return res;
  }
}

void main() {
}
