import 'aes_engine.dart';
import 'buffered_block_padding_base.dart';
import 'cipher_block_chaining_mode.dart';

/// internal class
class AesCipher {
  //Constructor
  /// internal constructor
  AesCipher(bool isEncryption, List<int> key, List<int> iv) {
    _bp = BufferedCipher(CipherBlockChainingMode(AesEngine()));
    final InvalidParameter ip = InvalidParameter(KeyParameter(key), iv);
    _bp.initialize(isEncryption, ip);
  }

  //Fields
  late BufferedCipher _bp;

  //Implementation
  /// internal method
  List<int>? update(List<int> input, int inputOffset, int inputLength) {
    int length = _bp.getUpdateOutputSize(inputLength);
    List<int>? output;
    if (length > 0) {
      output = List<int>.filled(length, 0, growable: true);
    } else {
      length = 0;
    }
    final Map<String, dynamic> result =
        _bp.processBytes(input, inputOffset, inputLength, output, 0);
    output = result['output'] as List<int>?;
    return output;
  }
}

/// internal class
class AesCipherNoPadding {
  //Constructor
  /// internal constructor
  AesCipherNoPadding(bool isEncryption, List<int> key) {
    _cbc = CipherBlockChainingMode(AesEngine());
    _cbc.initialize(isEncryption, KeyParameter(key));
  }

  //Fields
  late CipherBlockChainingMode _cbc;

  //Implementation
  /// internal method
  List<int>? processBlock(List<int>? input, int offset, int length) {
    if ((length % _cbc.blockSize!) != 0) {
      throw ArgumentError.value('Not multiple of block: $length');
    }
    List<int>? output = List<int>.filled(length, 0, growable: true);
    int tempOffset = 0;
    while (length > 0) {
      final Map<String, dynamic> result =
          _cbc.processBlock(input, offset, output, tempOffset);
      output = result['output'] as List<int>?;
      length -= _cbc.blockSize!;
      tempOffset += _cbc.blockSize!;
      offset += _cbc.blockSize!;
    }
    return output;
  }
}

/// internal class
class AesEncryptor {
  /// internal constructor
  AesEncryptor(List<int> key, List<int> iv, bool isEncryption) {
    initialize();
    _aes = Aes(
        key.length == _blockSize ? _KeySize.bits128 : _KeySize.bits256, key);
    List.copyRange(_buf, 0, iv, 0, iv.length);
    List.copyRange(_cbcV!, 0, iv, 0, iv.length);
    if (isEncryption) {
      _ivOff = _buf.length;
    }
    _isEncryption = isEncryption;
  }

  //Fields
  int? _blockSize;
  late Aes _aes;
  late bool _isEncryption;
  late List<int> _buf;
  List<int>? _cbcV;
  int? _ivOff;
  List<int>? _nextBlockVector;

  //Implementation
  /// internal method
  void initialize() {
    _blockSize = 16;
    _ivOff = 0;
    _buf = List<int>.filled(_blockSize!, 0, growable: true);
    _cbcV = List<int>.filled(_blockSize!, 0, growable: true);
    _nextBlockVector = List<int>.filled(_blockSize!, 0, growable: true);
  }

  /// internal method
  int getBlockSize(int length) {
    final int total = length + _ivOff!;
    final int leftOver = total % _buf.length;
    return total - (leftOver == 0 ? _buf.length : leftOver);
  }

  /// internal method
  void processBytes(
      List<int> input, int inOff, int length, List<int> output, int outOff) {
    if (length < 0) {
      throw ArgumentError.value(length, 'length cannot be negative');
    }
    int resultLen = 0;
    final int bytesLeft = _buf.length - _ivOff!;
    if (length > bytesLeft) {
      List.copyRange(_buf, _ivOff!, input, inOff, inOff + bytesLeft);
      resultLen += processBlock(_buf, 0, output, outOff);
      _ivOff = 0;
      length -= bytesLeft;
      inOff += bytesLeft;
      while (length > _buf.length) {
        resultLen += processBlock(input, inOff, output, outOff + resultLen);
        length -= _blockSize!;
        inOff += _blockSize!;
      }
    }
    List.copyRange(_buf, _ivOff!, input, inOff, inOff + length);
    _ivOff = _ivOff! + length;
  }

  /// internal method
  int processBlock(List<int> input, int inOff, List<int> outBytes, int outOff) {
    int length = 0;
    if ((inOff + _blockSize!) > input.length) {
      throw ArgumentError.value('input buffer length is too short');
    }
    if (_isEncryption) {
      for (int i = 0; i < _blockSize!; i++) {
        _cbcV![i] ^= input[inOff + i];
      }
      length = _aes._cipher(_cbcV, outBytes, outOff);
      List.copyRange(_cbcV!, 0, outBytes, outOff, outOff + _cbcV!.length);
    } else {
      List.copyRange(_nextBlockVector!, 0, input, inOff, inOff + _blockSize!);
      length = _aes._invCipher(_nextBlockVector, outBytes, outOff);
      for (int i = 0; i < _blockSize!; i++) {
        outBytes[outOff + i] ^= _cbcV![i];
      }
      final List<int>? tmp = _cbcV;
      _cbcV = _nextBlockVector;
      _nextBlockVector = tmp;
    }
    return length;
  }

  /// internal method
  int calculateOutputSize() {
    final int total = _ivOff!;
    final int leftOver = total % _buf.length;
    return leftOver == 0
        ? (_isEncryption ? (total + _buf.length) : total)
        : (total - leftOver + _buf.length);
  }

  /// internal method
  int finalize(List<int> output) {
    int resultLen = 0;
    const int outOff = 0;
    if (_isEncryption) {
      if (_ivOff == _blockSize) {
        resultLen = processBlock(_buf, 0, output, outOff);
        _ivOff = 0;
      }
      _ivOff = _addPadding(_buf, _ivOff!);
      resultLen += processBlock(_buf, 0, output, outOff + resultLen);
    } else {
      if (_ivOff == _blockSize) {
        resultLen = processBlock(_buf, 0, output, 0);
        _ivOff = 0;
      }
      resultLen -= _checkPadding(output);
    }
    return resultLen;
  }

  int _addPadding(List<int> input, int offset) {
    final int data = (input.length - offset).toUnsigned(8);
    while (offset < input.length) {
      input[offset] = data;
      offset++;
    }
    return offset;
  }

  int _checkPadding(List<int> input) {
    int count = input[input.length - 1] & 0xff;
    for (int i = 1; i <= count; i++) {
      if (input[input.length - i] != count) {
        count = 0;
      }
    }
    return count;
  }
}

/// internal class
class Aes {
  /// internal constructor
  Aes(_KeySize keySize, List<int> keyBytes) {
    _keySize = keySize;
    nb = 4;
    if (_keySize == _KeySize.bits128) {
      nk = 4;
      nr = 10;
    } else if (_keySize == _KeySize.bits192) {
      nk = 6;
      nr = 12;
    } else if (_keySize == _KeySize.bits256) {
      nk = 8;
      nr = 14;
    }
    key = List<int>.filled(nk * 4, 0, growable: true);
    List.copyRange(key, 0, keyBytes, 0, key.length);
    initialize();
  }

  //Fields
  _KeySize? _keySize;

  /// internal field
  late int nb;

  /// internal field
  late int nk;

  /// internal field
  int? nr;

  /// internal field
  late List<int> key;

  /// internal field
  late List<List<int>> sBox;

  /// internal field
  late List<List<int>> iBox;

  /// internal field
  late List<List<int>> rCon;

  /// internal field
  late List<List<int>> keySheduleArray;

  /// internal field
  late List<List<int>> state;

  //Implemenation
  /// internal method
  void initialize() {
    _buildSubstitutionBox();
    _buildInverseSubBox();
    _buildRoundConstants();
    _keyExpansion();
  }

  void _keyExpansion() {
    keySheduleArray = List<List<int>>.generate(
        nb * (nr! + 1), (int i) => List<int>.generate(4, (int j) => 0));
    for (int row = 0; row < nk; ++row) {
      keySheduleArray[row][0] = key[4 * row];
      keySheduleArray[row][1] = key[(4 * row) + 1];
      keySheduleArray[row][2] = key[(4 * row) + 2];
      keySheduleArray[row][3] = key[(4 * row) + 3];
    }
    List<int> temp = List<int>.filled(4, 0, growable: true);
    for (int row = nk; row < nb * (nr! + 1); ++row) {
      temp[0] = keySheduleArray[row - 1][0];
      temp[1] = keySheduleArray[row - 1][1];
      temp[2] = keySheduleArray[row - 1][2];
      temp[3] = keySheduleArray[row - 1][3];
      if (row % nk == 0) {
        temp = _subWord(_rotWord(temp));
        temp[0] = (temp[0].toSigned(32) ^ rCon[row ~/ nk][0].toSigned(32))
            .toUnsigned(8);
        temp[1] = (temp[1].toSigned(32) ^ rCon[row ~/ nk][1].toSigned(32))
            .toUnsigned(8);
        temp[2] = (temp[2].toSigned(32) ^ rCon[row ~/ nk][2].toSigned(32))
            .toUnsigned(8);
        temp[3] = (temp[3].toSigned(32) ^ rCon[row ~/ nk][3].toSigned(32))
            .toUnsigned(8);
      } else if (nk > 6 && (row % nk == 4)) {
        temp = _subWord(temp);
      }
      keySheduleArray[row][0] =
          (keySheduleArray[row - nk][0].toSigned(32) ^ temp[0].toSigned(32))
              .toUnsigned(8);
      keySheduleArray[row][1] =
          (keySheduleArray[row - nk][1].toSigned(32) ^ temp[1].toSigned(32))
              .toUnsigned(8);
      keySheduleArray[row][2] =
          (keySheduleArray[row - nk][2].toSigned(32) ^ temp[2].toSigned(32))
              .toUnsigned(8);
      keySheduleArray[row][3] =
          (keySheduleArray[row - nk][3].toSigned(32) ^ temp[3].toSigned(32))
              .toUnsigned(8);
    }
  }

  List<int> _subWord(List<int> word) {
    final List<int> result = List<int>.filled(4, 0, growable: true);
    result[0] = sBox[word[0] >> 4][word[0] & 0x0f];
    result[1] = sBox[word[1] >> 4][word[1] & 0x0f];
    result[2] = sBox[word[2] >> 4][word[2] & 0x0f];
    result[3] = sBox[word[3] >> 4][word[3] & 0x0f];
    return result;
  }

  List<int> _rotWord(List<int> word) {
    final List<int> result = List<int>.filled(4, 0, growable: true);
    result[0] = word[1];
    result[1] = word[2];
    result[2] = word[3];
    result[3] = word[0];
    return result;
  }

  int _cipher(List<int>? input, List<int> output, int outOff) {
    initialize();
    state = List<List<int>>.generate(
        4, (int i) => List<int>.generate(nb, (int j) => 0));
    for (int i = 0; i < (4 * nb); ++i) {
      state[i % 4][i ~/ 4] = input![i];
    }
    _addRoundKey(0);
    for (int round = 1; round <= (nr! - 1); ++round) {
      _subBytes();
      _shiftRows();
      _mixColumns();
      _addRoundKey(round);
    }
    _subBytes();
    _shiftRows();
    _addRoundKey(nr);
    for (int i = 0; i < (4 * nb); ++i) {
      output[outOff++] = state[i % 4][i ~/ 4];
    }
    return 16;
  }

  int _invCipher(List<int>? input, List<int> output, int outOff) {
    state = List<List<int>>.generate(
        4, (int i) => List<int>.generate(nb, (int j) => 0));
    for (int i = 0; i < (4 * nb); ++i) {
      state[i % 4][i ~/ 4] = input![i];
    }
    _addRoundKey(nr);
    for (int round = nr! - 1; round >= 1; --round) {
      _invShiftRows();
      _invSubBytes();
      _addRoundKey(round);
      _invMixColumns();
    }
    _invShiftRows();
    _invSubBytes();
    _addRoundKey(0);
    for (int i = 0; i < (4 * nb); ++i) {
      output[outOff++] = state[i % 4][i ~/ 4];
    }
    return 16;
  }

  void _mixColumns() {
    final List<List<int>> temp = List<List<int>>.generate(
        4, (int i) => List<int>.generate(4, (int j) => 0));
    for (int r = 0; r < 4; ++r) {
      for (int c = 0; c < 4; ++c) {
        temp[r][c] = state[r][c];
      }
    }
    for (int c = 0; c < 4; ++c) {
      state[0][c] = (_gfmultby02(temp[0][c]).toSigned(32) ^
              _gfmultby03(temp[1][c]).toSigned(32) ^
              temp[2][c].toSigned(32) ^
              temp[3][c].toSigned(32))
          .toUnsigned(8);
      state[1][c] = (temp[0][c].toSigned(32) ^
              _gfmultby02(temp[1][c]).toSigned(32) ^
              _gfmultby03(temp[2][c]).toSigned(32) ^
              temp[3][c].toSigned(32))
          .toUnsigned(8);
      state[2][c] = (temp[0][c].toSigned(32) ^
              temp[1][c].toSigned(32) ^
              _gfmultby02(temp[2][c]).toSigned(32) ^
              _gfmultby03(temp[3][c]).toSigned(32))
          .toUnsigned(8);
      state[3][c] = (_gfmultby03(temp[0][c]).toSigned(32) ^
              temp[1][c].toSigned(32) ^
              temp[2][c].toSigned(32) ^
              _gfmultby02(temp[3][c]).toSigned(32))
          .toUnsigned(8);
    }
  }

  void _invMixColumns() {
    final List<List<int>> temp = List<List<int>>.generate(
        4, (int i) => List<int>.generate(4, (int j) => 0));
    for (int r = 0; r < 4; ++r) {
      for (int c = 0; c < 4; ++c) {
        temp[r][c] = state[r][c];
      }
    }
    for (int c = 0; c < 4; ++c) {
      state[0][c] = (_gfmultby0e(temp[0][c]).toSigned(32) ^
              _gfmultby0b(temp[1][c]).toSigned(32) ^
              _gfmultby0d(temp[2][c]).toSigned(32) ^
              _gfmultby09(temp[3][c]).toSigned(32))
          .toUnsigned(8);
      state[1][c] = (_gfmultby09(temp[0][c]).toSigned(32) ^
              _gfmultby0e(temp[1][c]).toSigned(32) ^
              _gfmultby0b(temp[2][c]).toSigned(32) ^
              _gfmultby0d(temp[3][c]).toSigned(32))
          .toUnsigned(8);
      state[2][c] = (_gfmultby0d(temp[0][c]).toSigned(32) ^
              _gfmultby09(temp[1][c]).toSigned(32) ^
              _gfmultby0e(temp[2][c]).toSigned(32) ^
              _gfmultby0b(temp[3][c]).toSigned(32))
          .toUnsigned(8);
      state[3][c] = (_gfmultby0b(temp[0][c]).toSigned(32) ^
              _gfmultby0d(temp[1][c]).toSigned(32) ^
              _gfmultby09(temp[2][c]).toSigned(32) ^
              _gfmultby0e(temp[3][c]).toSigned(32))
          .toUnsigned(8);
    }
  }

  int _gfmultby0d(int b) {
    return (_gfmultby02(_gfmultby02(_gfmultby02(b))).toSigned(32) ^
            _gfmultby02(_gfmultby02(b)).toSigned(32) ^
            b.toSigned(32))
        .toUnsigned(8);
  }

  int _gfmultby09(int b) {
    return (_gfmultby02(_gfmultby02(_gfmultby02(b))).toSigned(32) ^
            b.toSigned(32))
        .toUnsigned(8);
  }

  int _gfmultby0b(int b) {
    return (_gfmultby02(_gfmultby02(_gfmultby02(b))).toSigned(32) ^
            _gfmultby02(b).toSigned(32) ^
            b.toSigned(32))
        .toUnsigned(8);
  }

  int _gfmultby0e(int b) {
    return (_gfmultby02(_gfmultby02(_gfmultby02(b))).toSigned(32) ^
            _gfmultby02(_gfmultby02(b)).toSigned(32) ^
            _gfmultby02(b).toSigned(32))
        .toUnsigned(8);
  }

  int _gfmultby02(int b) {
    return (b < 0x80
            ? (b << 1).toSigned(32)
            : ((b << 1).toSigned(32) ^ 0x1b.toSigned(32)))
        .toUnsigned(8);
  }

  int _gfmultby03(int b) {
    return (_gfmultby02(b).toSigned(32) ^ b.toSigned(32)).toUnsigned(8);
  }

  void _shiftRows() {
    final List<List<int>> temp = List<List<int>>.generate(
        4, (int i) => List<int>.generate(4, (int j) => 0));
    for (int r = 0; r < 4; ++r) {
      for (int c = 0; c < 4; ++c) {
        temp[r][c] = state[r][c];
      }
    }
    for (int r = 1; r < 4; ++r) {
      for (int c = 0; c < 4; ++c) {
        state[r][c] = temp[r][(c + r) % nb];
      }
    }
  }

  void _invShiftRows() {
    final List<List<int>> temp = List<List<int>>.generate(
        4, (int i) => List<int>.generate(4, (int j) => 0));
    for (int r = 0; r < 4; ++r) {
      for (int c = 0; c < 4; ++c) {
        temp[r][c] = state[r][c];
      }
    }
    for (int r = 1; r < 4; ++r) {
      for (int c = 0; c < 4; ++c) {
        state[r][(c + r) % nb] = temp[r][c];
      }
    }
  }

  void _subBytes() {
    for (int r = 0; r < 4; ++r) {
      for (int c = 0; c < 4; ++c) {
        state[r][c] = sBox[(state[r][c] >> 4)][(state[r][c] & 0x0f)];
      }
    }
  }

  void _invSubBytes() {
    for (int r = 0; r < 4; ++r) {
      for (int c = 0; c < 4; ++c) {
        state[r][c] = iBox[state[r][c] >> 4][state[r][c] & 0x0f];
      }
    }
  }

  void _addRoundKey(int? round) {
    for (int r = 0; r < 4; ++r) {
      for (int c = 0; c < 4; ++c) {
        state[r][c] = (state[r][c].toSigned(32) ^
                keySheduleArray[(round! * 4) + c][r].toSigned(32))
            .toUnsigned(8);
      }
    }
  }

  void _buildRoundConstants() {
    rCon = <List<int>>[
      <int>[0x00, 0x00, 0x00, 0x00],
      <int>[0x01, 0x00, 0x00, 0x00],
      <int>[0x02, 0x00, 0x00, 0x00],
      <int>[0x04, 0x00, 0x00, 0x00],
      <int>[0x08, 0x00, 0x00, 0x00],
      <int>[0x10, 0x00, 0x00, 0x00],
      <int>[0x20, 0x00, 0x00, 0x00],
      <int>[0x40, 0x00, 0x00, 0x00],
      <int>[0x80, 0x00, 0x00, 0x00],
      <int>[0x1b, 0x00, 0x00, 0x00],
      <int>[0x36, 0x00, 0x00, 0x00]
    ];
  }

  void _buildInverseSubBox() {
    iBox = <List<int>>[
      <int>[
        0x52,
        0x09,
        0x6a,
        0xd5,
        0x30,
        0x36,
        0xa5,
        0x38,
        0xbf,
        0x40,
        0xa3,
        0x9e,
        0x81,
        0xf3,
        0xd7,
        0xfb
      ],
      <int>[
        0x7c,
        0xe3,
        0x39,
        0x82,
        0x9b,
        0x2f,
        0xff,
        0x87,
        0x34,
        0x8e,
        0x43,
        0x44,
        0xc4,
        0xde,
        0xe9,
        0xcb
      ],
      <int>[
        0x54,
        0x7b,
        0x94,
        0x32,
        0xa6,
        0xc2,
        0x23,
        0x3d,
        0xee,
        0x4c,
        0x95,
        0x0b,
        0x42,
        0xfa,
        0xc3,
        0x4e
      ],
      <int>[
        0x08,
        0x2e,
        0xa1,
        0x66,
        0x28,
        0xd9,
        0x24,
        0xb2,
        0x76,
        0x5b,
        0xa2,
        0x49,
        0x6d,
        0x8b,
        0xd1,
        0x25
      ],
      <int>[
        0x72,
        0xf8,
        0xf6,
        0x64,
        0x86,
        0x68,
        0x98,
        0x16,
        0xd4,
        0xa4,
        0x5c,
        0xcc,
        0x5d,
        0x65,
        0xb6,
        0x92
      ],
      <int>[
        0x6c,
        0x70,
        0x48,
        0x50,
        0xfd,
        0xed,
        0xb9,
        0xda,
        0x5e,
        0x15,
        0x46,
        0x57,
        0xa7,
        0x8d,
        0x9d,
        0x84
      ],
      <int>[
        0x90,
        0xd8,
        0xab,
        0x00,
        0x8c,
        0xbc,
        0xd3,
        0x0a,
        0xf7,
        0xe4,
        0x58,
        0x05,
        0xb8,
        0xb3,
        0x45,
        0x06
      ],
      <int>[
        0xd0,
        0x2c,
        0x1e,
        0x8f,
        0xca,
        0x3f,
        0x0f,
        0x02,
        0xc1,
        0xaf,
        0xbd,
        0x03,
        0x01,
        0x13,
        0x8a,
        0x6b
      ],
      <int>[
        0x3a,
        0x91,
        0x11,
        0x41,
        0x4f,
        0x67,
        0xdc,
        0xea,
        0x97,
        0xf2,
        0xcf,
        0xce,
        0xf0,
        0xb4,
        0xe6,
        0x73
      ],
      <int>[
        0x96,
        0xac,
        0x74,
        0x22,
        0xe7,
        0xad,
        0x35,
        0x85,
        0xe2,
        0xf9,
        0x37,
        0xe8,
        0x1c,
        0x75,
        0xdf,
        0x6e
      ],
      <int>[
        0x47,
        0xf1,
        0x1a,
        0x71,
        0x1d,
        0x29,
        0xc5,
        0x89,
        0x6f,
        0xb7,
        0x62,
        0x0e,
        0xaa,
        0x18,
        0xbe,
        0x1b
      ],
      <int>[
        0xfc,
        0x56,
        0x3e,
        0x4b,
        0xc6,
        0xd2,
        0x79,
        0x20,
        0x9a,
        0xdb,
        0xc0,
        0xfe,
        0x78,
        0xcd,
        0x5a,
        0xf4
      ],
      <int>[
        0x1f,
        0xdd,
        0xa8,
        0x33,
        0x88,
        0x07,
        0xc7,
        0x31,
        0xb1,
        0x12,
        0x10,
        0x59,
        0x27,
        0x80,
        0xec,
        0x5f
      ],
      <int>[
        0x60,
        0x51,
        0x7f,
        0xa9,
        0x19,
        0xb5,
        0x4a,
        0x0d,
        0x2d,
        0xe5,
        0x7a,
        0x9f,
        0x93,
        0xc9,
        0x9c,
        0xef
      ],
      <int>[
        0xa0,
        0xe0,
        0x3b,
        0x4d,
        0xae,
        0x2a,
        0xf5,
        0xb0,
        0xc8,
        0xeb,
        0xbb,
        0x3c,
        0x83,
        0x53,
        0x99,
        0x61
      ],
      <int>[
        0x17,
        0x2b,
        0x04,
        0x7e,
        0xba,
        0x77,
        0xd6,
        0x26,
        0xe1,
        0x69,
        0x14,
        0x63,
        0x55,
        0x21,
        0x0c,
        0x7d
      ]
    ];
  }

  void _buildSubstitutionBox() {
    sBox = <List<int>>[
      <int>[
        0x63,
        0x7c,
        0x77,
        0x7b,
        0xf2,
        0x6b,
        0x6f,
        0xc5,
        0x30,
        0x01,
        0x67,
        0x2b,
        0xfe,
        0xd7,
        0xab,
        0x76
      ],
      <int>[
        0xca,
        0x82,
        0xc9,
        0x7d,
        0xfa,
        0x59,
        0x47,
        0xf0,
        0xad,
        0xd4,
        0xa2,
        0xaf,
        0x9c,
        0xa4,
        0x72,
        0xc0
      ],
      <int>[
        0xb7,
        0xfd,
        0x93,
        0x26,
        0x36,
        0x3f,
        0xf7,
        0xcc,
        0x34,
        0xa5,
        0xe5,
        0xf1,
        0x71,
        0xd8,
        0x31,
        0x15
      ],
      <int>[
        0x04,
        0xc7,
        0x23,
        0xc3,
        0x18,
        0x96,
        0x05,
        0x9a,
        0x07,
        0x12,
        0x80,
        0xe2,
        0xeb,
        0x27,
        0xb2,
        0x75
      ],
      <int>[
        0x09,
        0x83,
        0x2c,
        0x1a,
        0x1b,
        0x6e,
        0x5a,
        0xa0,
        0x52,
        0x3b,
        0xd6,
        0xb3,
        0x29,
        0xe3,
        0x2f,
        0x84
      ],
      <int>[
        0x53,
        0xd1,
        0x00,
        0xed,
        0x20,
        0xfc,
        0xb1,
        0x5b,
        0x6a,
        0xcb,
        0xbe,
        0x39,
        0x4a,
        0x4c,
        0x58,
        0xcf
      ],
      <int>[
        0xd0,
        0xef,
        0xaa,
        0xfb,
        0x43,
        0x4d,
        0x33,
        0x85,
        0x45,
        0xf9,
        0x02,
        0x7f,
        0x50,
        0x3c,
        0x9f,
        0xa8
      ],
      <int>[
        0x51,
        0xa3,
        0x40,
        0x8f,
        0x92,
        0x9d,
        0x38,
        0xf5,
        0xbc,
        0xb6,
        0xda,
        0x21,
        0x10,
        0xff,
        0xf3,
        0xd2
      ],
      <int>[
        0xcd,
        0x0c,
        0x13,
        0xec,
        0x5f,
        0x97,
        0x44,
        0x17,
        0xc4,
        0xa7,
        0x7e,
        0x3d,
        0x64,
        0x5d,
        0x19,
        0x73
      ],
      <int>[
        0x60,
        0x81,
        0x4f,
        0xdc,
        0x22,
        0x2a,
        0x90,
        0x88,
        0x46,
        0xee,
        0xb8,
        0x14,
        0xde,
        0x5e,
        0x0b,
        0xdb
      ],
      <int>[
        0xe0,
        0x32,
        0x3a,
        0x0a,
        0x49,
        0x06,
        0x24,
        0x5c,
        0xc2,
        0xd3,
        0xac,
        0x62,
        0x91,
        0x95,
        0xe4,
        0x79
      ],
      <int>[
        0xe7,
        0xc8,
        0x37,
        0x6d,
        0x8d,
        0xd5,
        0x4e,
        0xa9,
        0x6c,
        0x56,
        0xf4,
        0xea,
        0x65,
        0x7a,
        0xae,
        0x08
      ],
      <int>[
        0xba,
        0x78,
        0x25,
        0x2e,
        0x1c,
        0xa6,
        0xb4,
        0xc6,
        0xe8,
        0xdd,
        0x74,
        0x1f,
        0x4b,
        0xbd,
        0x8b,
        0x8a
      ],
      <int>[
        0x70,
        0x3e,
        0xb5,
        0x66,
        0x48,
        0x03,
        0xf6,
        0x0e,
        0x61,
        0x35,
        0x57,
        0xb9,
        0x86,
        0xc1,
        0x1d,
        0x9e
      ],
      <int>[
        0xe1,
        0xf8,
        0x98,
        0x11,
        0x69,
        0xd9,
        0x8e,
        0x94,
        0x9b,
        0x1e,
        0x87,
        0xe9,
        0xce,
        0x55,
        0x28,
        0xdf
      ],
      <int>[
        0x8c,
        0xa1,
        0x89,
        0x0d,
        0xbf,
        0xe6,
        0x42,
        0x68,
        0x41,
        0x99,
        0x2d,
        0x0f,
        0xb0,
        0x54,
        0xbb,
        0x16
      ]
    ];
  }
}

/// Specifies the key size of AES.
enum _KeySize {
  /// 128 Bit.
  bits128,

  /// 192 Bit.
  bits192,

  /// 256 Bit.
  bits256
}
