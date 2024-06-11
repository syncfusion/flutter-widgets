import 'dart:math';

/// internal class
class IPadding {
  /// internal method
  void initialize(Random? random) {}

  /// internal property
  String? get paddingName => null;

  /// internal method
  int? addPadding(List<int>? bytes, int? offset) => null;

  /// internal method
  int? count(List<int>? bytes) => null;
}

/// internal class
class IBufferedCipher {
  /// internal property
  String? get algorithmName => null;

  /// internal method
  void initialize(bool forEncryption, ICipherParameter? parameters) {}

  /// internal property
  int? get blockSize => null;

  /// internal method
  int? getOutputSize(int inputLen) => null;

  /// internal method
  int? getUpdateOutputSize(int inputLen) => null;

  /// internal method
  List<int>? processByte(int intput) => null;

  /// internal method
  Map<String, dynamic>? copyBytes(int input, List<int> output, int outOff) =>
      null;

  /// internal method
  List<int>? readBytesFromInput(List<int> input) => null;

  /// internal method
  List<int>? readBytes(List<int> input, int inOff, int length) => null;

  /// internal method
  Map<String, dynamic>? processByteFromValues(
          List<int> input, List<int> output, int outOff) =>
      null;

  /// internal method
  Map<String, dynamic>? processBytes(List<int> input, int inOff, int length,
          List<int> output, int outOff) =>
      null;

  /// internal method
  List<int>? doFinal() => null;

  /// internal method
  List<int>? doFinalFromInput(List<int>? input) => null;

  /// internal method
  List<int>? readFinal(List<int> input, int inOff, int length) => null;

  /// internal method
  Map<String, dynamic>? writeFinal(List<int> output, int outOff) => null;

  /// internal method
  Map<String, dynamic>? copyFinal(
          List<int> input, List<int> output, int outOff) =>
      null;

  /// internal method
  Map<String, dynamic>? readFinalValues(List<int> input, int inOff, int length,
          List<int> output, int outOff) =>
      null;

  /// internal method
  void reset() {}
}

/// internal class
class ICipher {
  /// internal property
  String? get algorithmName => null;

  /// internal method
  void initialize(bool? isEncryption, ICipherParameter? parameters) {}

  /// internal property
  int? get blockSize => null;

  /// internal property
  bool? get isBlock => null;

  /// internal method
  Map<String, dynamic>? processBlock(List<int>? inBytes, int inOffset,
          List<int>? outBytes, int? outOffset) =>
      null;

  /// internal method
  void reset() {}
}

/// internal class
class ICipherBlock {
  /// internal property
  String? get algorithmName => null;

  /// internal method
  void initialize(bool isEncryption, ICipherParameter? parameters) {}

  /// internal property
  int? get inputBlock => null;

  /// internal property
  int? get outputBlock => null;

  /// internal method
  List<int>? processBlock(List<int> bytes, int offset, int length) => null;
}

/// internal class
class ICipherParameter {
  /// internal field
  List<int>? keys;
}

/// internal class
class ISigner {
  /// internal method
  void initialize(bool isSigning, ICipherParameter? parameters) {}

  /// internal method
  void blockUpdate(List<int> bytes, int offset, int length) {}

  /// internal method
  List<int>? generateSignature() => null;

  /// internal method
  bool validateSignature(List<int> bytes) => false;

  /// internal method
  void reset() {}
}

/// internal class
class IRandom {
  /// internal method
  int? getValue(int position, [List<int>? bytes, int? offset, int? length]) =>
      null;

  /// internal property
  int? get length => null;
}
