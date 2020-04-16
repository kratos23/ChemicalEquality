import 'dart:collection';

import 'package:chemeq/logic/formula_parser.dart';
import 'package:chemeq/logic/fraction.dart';
import 'package:chemeq/logic/objects/element.dart';

import 'objects/formula.dart';

class SolveResult {
  bool solved;

  List<Fraction> factors;
}

class EqSolver {
  Map<Element, BigInt> _getElementsCount(Formula f) {
    Map<Element, BigInt> result = LinkedHashMap();
    for (Object obj in f.elements) {
      if (obj is Element) {
        result.putIfAbsent(obj, () => BigInt.zero);
        result[obj] += BigInt.from(f.factor);
      } else if (obj is Formula) {
        Map<Element, BigInt> tmp = _getElementsCount(obj);
        tmp.forEach((el, cnt) {
          result.putIfAbsent(el, () => BigInt.zero);
          result[el] += cnt * BigInt.from(f.factor);
        });
      }
      return result;
    }
  }

  SolveResult solve(List<Formula> left, List<Formula> right) {
    List<Map<Element, BigInt>> leftList = List();
    var elements = LinkedHashSet();
    left.forEach((it) => {leftList.add(_getElementsCount(it))});
    List<Map<Element, BigInt>> rightList = List();
    right.forEach((it) => {rightList.add(_getElementsCount(it))});
    leftList.forEach((list) => {
          list.forEach((el, cnt) => {elements.add(el)})
        });
    rightList.forEach((list) => {
          list.forEach((el, cnt) => {elements.add(el)})
        });
    var matrix = List<List<BigInt>>();
    for (var el in elements) {
      var elementKs = List<BigInt>();
      for (var mp in leftList) {
        elementKs.add(mp[el] ?? BigInt.zero);
      }
      for (var mp in rightList) {
        elementKs.add(-(mp[el] ?? BigInt.zero));
      }
      elementKs.add(BigInt.zero);
      matrix.add(elementKs);
    }
    print(matrix);
  }
}

void main() {
  var solver = EqSolver();
  var leftParser = FormulaParser("K2SO4 + NaCl");
  var rightParser = FormulaParser("KCL + Na2SO4");
  var left = leftParser.parse();
  var right = rightParser.parse();
  solver.solve(left, right);
}
