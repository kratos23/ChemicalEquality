class Fraction {
  // a / b
  BigInt a, b;

  Fraction(BigInt a, BigInt b) {
    BigInt g = a.gcd(b);
    this.a = a ~/ g;
    this.b = b ~/ g;
    if (this.b < BigInt.zero) {
      this.a *= -BigInt.one;
      this.b *= -BigInt.one;
    }
  }

  Fraction.from(BigInt a) {
    this.a = a;
    this.b = BigInt.one;
  }

  BigInt _lcm(BigInt x, BigInt y) {
    return (x * y) ~/ x.gcd(y);
  }

  Fraction operator +(Fraction f) {
    BigInt lcm = _lcm(b, f.b);
    BigInt m1 = lcm ~/ b;
    BigInt m2 = lcm ~/ f.b;
    return Fraction(a * m1 + f.a * m2, lcm);
  }

  Fraction operator *(Fraction f) {
    return Fraction(a * f.a, b * f.b);
  }

  Fraction operator /(Fraction f) {
    return this * Fraction(f.b, f.a);
  }

  Fraction operator -() {
    return Fraction(-a, b);
  }

  Fraction operator -(Fraction f) {
    return this + (-f);
  }

  @override
  String toString() {
    var value = a.toDouble() / b.toDouble();
    return value.toString();
  }

}
