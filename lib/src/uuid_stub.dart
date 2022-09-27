class UuidStub {
  static int _sequence = 0;

  static String v4() {
    final result = _sequence.toString();
    _sequence++;
    return result;
  }
}
