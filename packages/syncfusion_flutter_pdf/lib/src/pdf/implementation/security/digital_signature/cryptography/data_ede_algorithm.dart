part of pdf;

class _DesEdeAlogorithm extends _DataEncryption {
  _DesEdeAlogorithm() : super();
  List<int>? _key1;
  List<int>? _key2;
  List<int>? _key3;
  bool? _isEncryption;

  //Properties
  @override
  int? get blockSize => _blockSize;
  @override
  String get algorithmName => _Asn1Constants.desEde;
  //Implementation
  @override
  void initialize(bool? forEncryption, _ICipherParameter? parameters) {
    if (parameters is! _KeyParameter) {
      throw ArgumentError.value(parameters, 'parameters', 'Invalid parameter');
    }
    final List<int> keyMaster = parameters.keys;
    if (keyMaster.length != 24 && keyMaster.length != 16) {
      throw ArgumentError.value(parameters, 'parameters',
          'Invalid key size. Size must be 16 or 24 bytes.');
    }
    _isEncryption = forEncryption;
    final List<int> key1 = List<int>.generate(8, (int i) => 0);
    List.copyRange(key1, 0, keyMaster, 0, key1.length);
    _key1 = generateWorkingKey(forEncryption, key1);
    final List<int> key2 = List<int>.generate(8, (int i) => 0);
    List.copyRange(key2, 0, keyMaster, 8, 8 + key2.length);
    _key2 = generateWorkingKey(!forEncryption!, key2);
    if (keyMaster.length == 24) {
      final List<int> key3 = List<int>.generate(8, (int i) => 0);
      List.copyRange(key3, 0, keyMaster, 16, 16 + key3.length);
      _key3 = generateWorkingKey(forEncryption, key3);
    } else {
      _key3 = _key1;
    }
  }

  @override
  Map<String, dynamic> processBlock(
      [List<int>? inputBytes,
      int? inOffset,
      List<int>? outputBytes,
      int? outOffset]) {
    ArgumentError.checkNotNull(_key1);
    if ((inOffset! + _blockSize!) > inputBytes!.length) {
      throw ArgumentError.value(
          inOffset, 'inOffset', 'Invalid length in input bytes');
    }
    if ((outOffset! + _blockSize!) > outputBytes!.length) {
      throw ArgumentError.value(
          inOffset, 'inOffset', 'Invalid length in output bytes');
    }
    final List<int> tempBytes = List<int>.generate(_blockSize!, (int i) => 0);
    if (_isEncryption!) {
      encryptData(_key1, inputBytes, inOffset, tempBytes, 0);
      encryptData(_key2, tempBytes, 0, tempBytes, 0);
      encryptData(_key3, tempBytes, 0, outputBytes, outOffset);
    } else {
      encryptData(_key3, inputBytes, inOffset, tempBytes, 0);
      encryptData(_key2, tempBytes, 0, tempBytes, 0);
      encryptData(_key1, tempBytes, 0, outputBytes, outOffset);
    }
    return <String, dynamic>{'length': _blockSize, 'output': outputBytes};
  }

  @override
  void reset() {}
}
