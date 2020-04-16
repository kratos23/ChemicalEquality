class Element {

  String symbol;

  Element(this.symbol);

  @override
  String toString() {
    return symbol;
  }

  @override
  bool operator ==(other) {
    if (other is Element) {
      return symbol == other.symbol;
    } else {
      return false;
    }
  }

  @override
  int get hashCode {
    return symbol.hashCode;
  }


}
