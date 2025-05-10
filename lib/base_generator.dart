class IntBaseGenerator{
  final BigInt _b = BigInt.parse('4294967299'); // 2^32+3
  final BigInt _m = BigInt.parse('9223372036854775808'); // 2^64
  late BigInt _current;

  IntBaseGenerator(){
    final data = DateTime.now();
    _current = BigInt.from(data.microsecond * data.year * data.microsecond);
  }

  BigInt get nextInt{
    final nextNum = (_current * _b) % _m;
    _current = nextNum;
    return nextNum;
  }
}

class DoubleBaseGenerator extends IntBaseGenerator {
  double get nextDouble {
    final bigIntValue = super.nextInt;
    return bigIntValue / _m;
  }
}