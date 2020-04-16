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
    }
    return result;
  }

  BigInt _lcm(BigInt x, BigInt y) {
    return (x * y) ~/ x.gcd(y);
  }


  List<BigInt> _gauss(List<List<BigInt>> sourceMatrix) {
    List<List<Fraction>> m = List();
    for (var l in sourceMatrix) {
      var last = List<Fraction>();
      m.add(last);
      for (var x in l) {
        last.add(Fraction.from(x));
      }
    }
    var curI = 0;
    var freeJS = Set<int>();
    for (var j = 0; j < m[0].length - 1; j++) {
      var swpTarget = -1;
      for (var i = curI; i < m.length; i++) {
        if (m[i][j].a != BigInt.zero) {
          swpTarget = i;
          break;
        }
      }
      if (swpTarget == -1) {
        freeJS.add(j);
      } else {
        List<Fraction> tmp = m[curI];
        m[curI] = m[swpTarget];
        m[swpTarget] = tmp;

        for (var i = 0; i < m.length; i++) {
          if (i == curI) {
            continue;
          }
          var factor = m[i][j] / m[curI][j];
          for (var k = 0; k < m[0].length; k++) {
            m[i][k] -= m[curI][k] * factor;
          }
        }
        curI++;
      }
    }
    m.forEach((x) => print('$x'));
    print("Free vars");
    print(freeJS);


    curI = 0;
    for (var j = 0; j < m[0].length - 1; j++) {
      if (freeJS.contains(j)) {
        continue;
      }
      var x = m[curI][j];
      for (var k = 0; k < m[0].length - 1; k++) {
        m[curI][k] /= x;
      }
      curI++;
    }

    m.forEach((x) => print('$x'));
    print("Free vars");
    print(freeJS);

    var ans = List<BigInt>.generate(m[0].length - 1, (ind) => BigInt.one);
    for (var freeVarInd in freeJS) {
      var curFactor = BigInt.one;
      for (var i = 0; i < m.length; i++) {
        if (m[i][freeVarInd].a != BigInt.zero) {
          curFactor = _lcm(curFactor, m[i][freeVarInd].b);
        }
      }
      ans[freeVarInd] = curFactor;
    }

    curI = 0;
    for (var j = 0; j < m[0].length - 1; j++) {
      if (freeJS.contains(j)) {
        continue;
      }
      var curAns = m[curI][m[0].length - 1];
      for (var curJ = 0; curJ < m[0].length - 1; curJ++) {
        if (curJ == j) {
          continue;
        }
        curAns -= m[curI][curJ] * Fraction.from(ans[curJ]);
      }
      curI++;
      ans[j] = curAns.a;
      assert(curAns.b == BigInt.one);
    }

    print(ans);

    //TODO return null on no-solution or no natural solution
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

    matrix.forEach((x) => print('$x'));
    List<BigInt> solution = _gauss(matrix);
  }
}

void main() {
  var solver = EqSolver();
  //var leftParser = FormulaParser("K2SO4 + NaCl");
  //var rightParser = FormulaParser("KCl + Na2SO4");
  //var leftParser = FormulaParser("Al + HCl");
  //var rightParser = FormulaParser("AlCl3 + H2");
  //var leftParser = FormulaParser("AlCl3 + H2O + K2S");
  //var rightParser = FormulaParser("KCl + Al(OH)3 + H2S");
  var leftParser = FormulaParser("MnO2 + Cl2 + KOH");
  var rightParser = FormulaParser("KMnO4 + KCl + H2O");

  var left = leftParser.parse();
  var right = rightParser.parse();
  solver.solve(left, right);
}
