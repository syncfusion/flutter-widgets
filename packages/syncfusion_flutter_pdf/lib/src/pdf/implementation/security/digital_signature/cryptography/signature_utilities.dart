import 'dart:math';

/// internal method
BigInt bigIntFromBytes(List<int>? data, [int? sign]) {
  BigInt result;
  if (sign == null) {
    final bool isNegative = data!.isNotEmpty && data[0] & 0x80 == 0x80;
    if (data.length == 1) {
      result = BigInt.from(data[0]);
    } else {
      result = BigInt.zero;
      for (int i = 0; i < data.length; i++) {
        final int item = data[data.length - i - 1];
        result |= BigInt.from(item) << (8 * i);
      }
    }
    return result != BigInt.zero
        ? isNegative
            ? result.toSigned(result.bitLength)
            : result
        : BigInt.zero;
  } else {
    if (sign == 0) {
      return BigInt.zero;
    }
    if (data!.length == 1) {
      result = BigInt.from(data[0]);
    } else {
      result = BigInt.from(0);
      for (int i = 0; i < data.length; i++) {
        final int item = data[data.length - i - 1];
        result |= BigInt.from(item) << (8 * i);
      }
    }
    if (result != BigInt.zero) {
      if (sign < 0) {
        result = result.toSigned(result.bitLength);
      } else {
        result = result.toUnsigned(result.bitLength);
      }
    }
  }
  return result;
}

/// internal method
List<int> bigIntToBytes(BigInt number, [bool isSigned = true]) {
  List<int> result;
  final BigInt mask = BigInt.from(0xff);
  final BigInt flag = BigInt.from(0x80);
  if (isSigned) {
    if (number == BigInt.zero) {
      return <int>[0];
    }
    int paddingBytes;
    int size;
    if (number > BigInt.zero) {
      size = (number.bitLength + 7) >> 3;
      paddingBytes = ((number >> (size - 1) * 8) & flag) == flag ? 1 : 0;
    } else {
      paddingBytes = 0;
      size = (number.bitLength + 8) >> 3;
    }
    final int length = size + paddingBytes;
    result = List<int>.generate(length, (int i) => 0);
    for (int i = 0; i < size; i++) {
      result[length - i - 1] = (number & mask).toSigned(32).toInt();
      number = number >> 8;
    }
  } else {
    if (number == BigInt.zero) {
      return <int>[0];
    }
    final int length = number.bitLength + (number.isNegative ? 8 : 7) >> 3;
    result = List<int>.generate(length, (int i) => 0);
    for (int i = 0; i < length; i++) {
      result[length - i - 1] = (number & mask).toSigned(32).toInt();
      number = number >> 8;
    }
  }
  return result;
}

/// internal method
BigInt getMod(BigInt n, BigInt m) {
  final BigInt biggie = n.remainder(m);
  return biggie.sign >= 0 ? biggie : biggie + m;
}

/// internal method
BigInt bigIntFromRamdom(int value, Random? random) {
  BigInt result;
  if (value < 0) {
    throw ArgumentError.value(value, 'value', 'Invalid entry');
  }
  if (value == 0) {
    result = BigInt.from(0);
  } else {
    final int nBytes = (value + 8 - 1) ~/ 8;
    final List<int> b =
        List<int>.generate(nBytes, (int i) => random!.nextInt(256));
    final int xBits = 8 * nBytes - value;
    b[0] &= (255 >> xBits).toUnsigned(8);
    result = bigIntFromBytes(b);
  }
  return result;
}
