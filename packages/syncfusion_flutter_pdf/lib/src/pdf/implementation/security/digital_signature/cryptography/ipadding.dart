part of pdf;

class _IPadding {
  void initialize(Random? random) {}
  String? get paddingName => null;
  int? addPadding(List<int>? bytes, int? offset) => null;
  int? count(List<int>? bytes) => null;
}

class _IBufferedCipher {
  String? get algorithmName => null;
  void initialize(bool forEncryption, _ICipherParameter? parameters) {}
  int? get blockSize => null;
  int? getOutputSize(int inputLen) => null;
  int? getUpdateOutputSize(int inputLen) => null;

  List<int>? processByte(int intput) => null;
  Map<String, dynamic>? copyBytes(int input, List<int> output, int outOff) =>
      null;
  List<int>? readBytesFromInput(List<int> input) => null;
  List<int>? readBytes(List<int> input, int inOff, int length) => null;
  Map<String, dynamic>? processByteFromValues(
          List<int> input, List<int> output, int outOff) =>
      null;
  Map<String, dynamic>? processBytes(List<int> input, int inOff, int length,
          List<int> output, int outOff) =>
      null;

  List<int>? doFinal() => null;
  List<int>? doFinalFromInput(List<int>? input) => null;
  List<int>? readFinal(List<int> input, int inOff, int length) => null;
  Map<String, dynamic>? writeFinal(List<int> output, int outOff) => null;
  Map<String, dynamic>? copyFinal(
          List<int> input, List<int> output, int outOff) =>
      null;
  Map<String, dynamic>? readFinalValues(List<int> input, int inOff, int length,
          List<int> output, int outOff) =>
      null;
  void reset() {}
}

class _ICipher {
  String? get algorithmName => null;
  void initialize(bool? isEncryption, _ICipherParameter? parameters) {}
  int? get blockSize => null;
  bool? get isBlock => null;
  Map<String, dynamic>? processBlock(List<int>? inBytes, int inOffset,
          List<int>? outBytes, int? outOffset) =>
      null;
  void reset() {}
}

class _ICipherBlock {
  String? get algorithmName => null;
  void initialize(bool isEncryption, _ICipherParameter? parameters) {}
  int? get inputBlock => null;
  int? get outputBlock => null;
  List<int>? processBlock(List<int> bytes, int offset, int length) => null;
}

class _ICipherParameter {
  List<int>? keys;
}

class _ISigner {
  //String get algorithmName => null;
  void initialize(bool isSigning, _ICipherParameter? parameters) {}
  //void update(int input) {}
  void blockUpdate(List<int> bytes, int offset, int length) {}
  List<int>? generateSignature() => null;
  //bool validateSignature(List<int> bytes) => null;
  void reset() {}
}

class _IRandom {
  int? getValue(int position, [List<int>? bytes, int? offset, int? length]) =>
      null;
  int? get length => null;
}
