import 'dart:typed_data';

/// internal class
abstract class IPadding {
  /// internal method
  void initialize([ICipherParameter? params]) {}

  /// internal property
  String? get paddingName => null;

  /// internal method
  int addPadding(Uint8List data, int offset);

  /// internal method
  int count(Uint8List data);
}

/// internal class
class IBufferedCipher extends ICipher {
  IPadding? get padding => null;

  ICipher? get cipher => null;

  @override
  Uint8List? process(Uint8List data) => null;

  /// internal method
  @override
  void initialize(bool forEncryption, ICipherParameter? parameters) {}

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
    List<int> input,
    List<int> output,
    int outOff,
  ) => null;

  /// internal method
  Map<String, dynamic>? processBytes(
    List<int> input,
    int inOff,
    int length,
    List<int> output,
    int outOff,
  ) => null;

  /// internal method
  List<int>? doFinal() => null;

  int? doFinalProcess(
    Uint8List inputBytes,
    int inputOffset,
    Uint8List outputBytes,
    int outputOffset,
  ) => null;

  /// internal method
  List<int>? doFinalFromInput(List<int>? input) => null;

  /// internal method
  List<int>? readFinal(List<int> input, int inOff, int length) => null;

  /// internal method
  Map<String, dynamic>? writeFinal(List<int> output, int outOff) => null;

  /// internal method
  Map<String, dynamic>? copyFinal(
    List<int> input,
    List<int> output,
    int outOff,
  ) => null;

  /// internal method
  Map<String, dynamic>? readFinalValues(
    List<int> input,
    int inOff,
    int length,
    List<int> output,
    int outOff,
  ) => null;

  /// internal method
  @override
  void reset() {}
}

/// internal class
abstract class ICipher {
  String? get algorithmName => null;

  /// Initialize the cipher
  void initialize(bool isEncryption, ICipherParameter? parameters);

  /// internal property
  int? get blockSize => null;

  /// internal property
  bool? get isBlock => null;

  /// Process a full block
  int? processingBlock(
    Uint8List inputBytes,
    int inputOffset,
    Uint8List outputBytes,
    int outputOffset,
  ) => null;

  Map<String, dynamic>? processBlock(
    List<int>? inBytes,
    int inOffset,
    List<int>? outBytes,
    int? outOffset,
  ) => null;

  /// Reset cipher
  void reset();

  Uint8List? process(Uint8List data) => null;
}

abstract class IBlockCipher extends ICipher {
  @override
  Uint8List process(Uint8List data) {
    final out = Uint8List(blockSize!);
    final len = processingBlock(data, 0, out, 0);
    return out.sublist(0, len);
  }
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
abstract class ICipherParameter {}

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
