part of pdf;

class _DataEncryption implements _ICipher {
  _DataEncryption() {
    _blockSize = 8;
    byteBit = <int>[128, 64, 32, 16, 8, 4, 2, 1];
    bigByte = <int>[
      0x800000,
      0x400000,
      0x200000,
      0x100000,
      0x80000,
      0x40000,
      0x20000,
      0x10000,
      0x8000,
      0x4000,
      0x2000,
      0x1000,
      0x800,
      0x400,
      0x200,
      0x100,
      0x80,
      0x40,
      0x20,
      0x10,
      0x8,
      0x4,
      0x2,
      0x1
    ];
    pc1 = <int>[
      56,
      48,
      40,
      32,
      24,
      16,
      8,
      0,
      57,
      49,
      41,
      33,
      25,
      17,
      9,
      1,
      58,
      50,
      42,
      34,
      26,
      18,
      10,
      2,
      59,
      51,
      43,
      35,
      62,
      54,
      46,
      38,
      30,
      22,
      14,
      6,
      61,
      53,
      45,
      37,
      29,
      21,
      13,
      5,
      60,
      52,
      44,
      36,
      28,
      20,
      12,
      4,
      27,
      19,
      11,
      3
    ];
    toTrot = <int>[1, 2, 4, 6, 8, 10, 12, 14, 15, 17, 19, 21, 23, 25, 27, 28];
    pc2 = <int>[
      13,
      16,
      10,
      23,
      0,
      4,
      2,
      27,
      14,
      5,
      20,
      9,
      22,
      18,
      11,
      3,
      25,
      7,
      15,
      6,
      26,
      19,
      12,
      1,
      40,
      51,
      30,
      36,
      46,
      54,
      29,
      39,
      50,
      44,
      32,
      47,
      43,
      48,
      38,
      55,
      33,
      52,
      45,
      41,
      49,
      35,
      28,
      31
    ];
    sp1 = <int>[
      0x01010400,
      0x00000000,
      0x00010000,
      0x01010404,
      0x01010004,
      0x00010404,
      0x00000004,
      0x00010000,
      0x00000400,
      0x01010400,
      0x01010404,
      0x00000400,
      0x01000404,
      0x01010004,
      0x01000000,
      0x00000004,
      0x00000404,
      0x01000400,
      0x01000400,
      0x00010400,
      0x00010400,
      0x01010000,
      0x01010000,
      0x01000404,
      0x00010004,
      0x01000004,
      0x01000004,
      0x00010004,
      0x00000000,
      0x00000404,
      0x00010404,
      0x01000000,
      0x00010000,
      0x01010404,
      0x00000004,
      0x01010000,
      0x01010400,
      0x01000000,
      0x01000000,
      0x00000400,
      0x01010004,
      0x00010000,
      0x00010400,
      0x01000004,
      0x00000400,
      0x00000004,
      0x01000404,
      0x00010404,
      0x01010404,
      0x00010004,
      0x01010000,
      0x01000404,
      0x01000004,
      0x00000404,
      0x00010404,
      0x01010400,
      0x00000404,
      0x01000400,
      0x01000400,
      0x00000000,
      0x00010004,
      0x00010400,
      0x00000000,
      0x01010004
    ];
    sp2 = <int>[
      0x80108020,
      0x80008000,
      0x00008000,
      0x00108020,
      0x00100000,
      0x00000020,
      0x80100020,
      0x80008020,
      0x80000020,
      0x80108020,
      0x80108000,
      0x80000000,
      0x80008000,
      0x00100000,
      0x00000020,
      0x80100020,
      0x00108000,
      0x00100020,
      0x80008020,
      0x00000000,
      0x80000000,
      0x00008000,
      0x00108020,
      0x80100000,
      0x00100020,
      0x80000020,
      0x00000000,
      0x00108000,
      0x00008020,
      0x80108000,
      0x80100000,
      0x00008020,
      0x00000000,
      0x00108020,
      0x80100020,
      0x00100000,
      0x80008020,
      0x80100000,
      0x80108000,
      0x00008000,
      0x80100000,
      0x80008000,
      0x00000020,
      0x80108020,
      0x00108020,
      0x00000020,
      0x00008000,
      0x80000000,
      0x00008020,
      0x80108000,
      0x00100000,
      0x80000020,
      0x00100020,
      0x80008020,
      0x80000020,
      0x00100020,
      0x00108000,
      0x00000000,
      0x80008000,
      0x00008020,
      0x80000000,
      0x80100020,
      0x80108020,
      0x00108000
    ];
    sp3 = <int>[
      0x00000208,
      0x08020200,
      0x00000000,
      0x08020008,
      0x08000200,
      0x00000000,
      0x00020208,
      0x08000200,
      0x00020008,
      0x08000008,
      0x08000008,
      0x00020000,
      0x08020208,
      0x00020008,
      0x08020000,
      0x00000208,
      0x08000000,
      0x00000008,
      0x08020200,
      0x00000200,
      0x00020200,
      0x08020000,
      0x08020008,
      0x00020208,
      0x08000208,
      0x00020200,
      0x00020000,
      0x08000208,
      0x00000008,
      0x08020208,
      0x00000200,
      0x08000000,
      0x08020200,
      0x08000000,
      0x00020008,
      0x00000208,
      0x00020000,
      0x08020200,
      0x08000200,
      0x00000000,
      0x00000200,
      0x00020008,
      0x08020208,
      0x08000200,
      0x08000008,
      0x00000200,
      0x00000000,
      0x08020008,
      0x08000208,
      0x00020000,
      0x08000000,
      0x08020208,
      0x00000008,
      0x00020208,
      0x00020200,
      0x08000008,
      0x08020000,
      0x08000208,
      0x00000208,
      0x08020000,
      0x00020208,
      0x00000008,
      0x08020008,
      0x00020200
    ];
    sp4 = <int>[
      0x00802001,
      0x00002081,
      0x00002081,
      0x00000080,
      0x00802080,
      0x00800081,
      0x00800001,
      0x00002001,
      0x00000000,
      0x00802000,
      0x00802000,
      0x00802081,
      0x00000081,
      0x00000000,
      0x00800080,
      0x00800001,
      0x00000001,
      0x00002000,
      0x00800000,
      0x00802001,
      0x00000080,
      0x00800000,
      0x00002001,
      0x00002080,
      0x00800081,
      0x00000001,
      0x00002080,
      0x00800080,
      0x00002000,
      0x00802080,
      0x00802081,
      0x00000081,
      0x00800080,
      0x00800001,
      0x00802000,
      0x00802081,
      0x00000081,
      0x00000000,
      0x00000000,
      0x00802000,
      0x00002080,
      0x00800080,
      0x00800081,
      0x00000001,
      0x00802001,
      0x00002081,
      0x00002081,
      0x00000080,
      0x00802081,
      0x00000081,
      0x00000001,
      0x00002000,
      0x00800001,
      0x00002001,
      0x00802080,
      0x00800081,
      0x00002001,
      0x00002080,
      0x00800000,
      0x00802001,
      0x00000080,
      0x00800000,
      0x00002000,
      0x00802080
    ];
    sp5 = <int>[
      0x00000100,
      0x02080100,
      0x02080000,
      0x42000100,
      0x00080000,
      0x00000100,
      0x40000000,
      0x02080000,
      0x40080100,
      0x00080000,
      0x02000100,
      0x40080100,
      0x42000100,
      0x42080000,
      0x00080100,
      0x40000000,
      0x02000000,
      0x40080000,
      0x40080000,
      0x00000000,
      0x40000100,
      0x42080100,
      0x42080100,
      0x02000100,
      0x42080000,
      0x40000100,
      0x00000000,
      0x42000000,
      0x02080100,
      0x02000000,
      0x42000000,
      0x00080100,
      0x00080000,
      0x42000100,
      0x00000100,
      0x02000000,
      0x40000000,
      0x02080000,
      0x42000100,
      0x40080100,
      0x02000100,
      0x40000000,
      0x42080000,
      0x02080100,
      0x40080100,
      0x00000100,
      0x02000000,
      0x42080000,
      0x42080100,
      0x00080100,
      0x42000000,
      0x42080100,
      0x02080000,
      0x00000000,
      0x40080000,
      0x42000000,
      0x00080100,
      0x02000100,
      0x40000100,
      0x00080000,
      0x00000000,
      0x40080000,
      0x02080100,
      0x40000100
    ];
    sp6 = <int>[
      0x20000010,
      0x20400000,
      0x00004000,
      0x20404010,
      0x20400000,
      0x00000010,
      0x20404010,
      0x00400000,
      0x20004000,
      0x00404010,
      0x00400000,
      0x20000010,
      0x00400010,
      0x20004000,
      0x20000000,
      0x00004010,
      0x00000000,
      0x00400010,
      0x20004010,
      0x00004000,
      0x00404000,
      0x20004010,
      0x00000010,
      0x20400010,
      0x20400010,
      0x00000000,
      0x00404010,
      0x20404000,
      0x00004010,
      0x00404000,
      0x20404000,
      0x20000000,
      0x20004000,
      0x00000010,
      0x20400010,
      0x00404000,
      0x20404010,
      0x00400000,
      0x00004010,
      0x20000010,
      0x00400000,
      0x20004000,
      0x20000000,
      0x00004010,
      0x20000010,
      0x20404010,
      0x00404000,
      0x20400000,
      0x00404010,
      0x20404000,
      0x00000000,
      0x20400010,
      0x00000010,
      0x00004000,
      0x20400000,
      0x00404010,
      0x00004000,
      0x00400010,
      0x20004010,
      0x00000000,
      0x20404000,
      0x20000000,
      0x00400010,
      0x20004010
    ];
    sp7 = <int>[
      0x00200000,
      0x04200002,
      0x04000802,
      0x00000000,
      0x00000800,
      0x04000802,
      0x00200802,
      0x04200800,
      0x04200802,
      0x00200000,
      0x00000000,
      0x04000002,
      0x00000002,
      0x04000000,
      0x04200002,
      0x00000802,
      0x04000800,
      0x00200802,
      0x00200002,
      0x04000800,
      0x04000002,
      0x04200000,
      0x04200800,
      0x00200002,
      0x04200000,
      0x00000800,
      0x00000802,
      0x04200802,
      0x00200800,
      0x00000002,
      0x04000000,
      0x00200800,
      0x04000000,
      0x00200800,
      0x00200000,
      0x04000802,
      0x04000802,
      0x04200002,
      0x04200002,
      0x00000002,
      0x00200002,
      0x04000000,
      0x04000800,
      0x00200000,
      0x04200800,
      0x00000802,
      0x00200802,
      0x04200800,
      0x00000802,
      0x04000002,
      0x04200802,
      0x04200000,
      0x00200800,
      0x00000000,
      0x00000002,
      0x04200802,
      0x00000000,
      0x00200802,
      0x04200000,
      0x00000800,
      0x04000002,
      0x04000800,
      0x00000800,
      0x00200002
    ];
    sp8 = <int>[
      0x10001040,
      0x00001000,
      0x00040000,
      0x10041040,
      0x10000000,
      0x10001040,
      0x00000040,
      0x10000000,
      0x00040040,
      0x10040000,
      0x10041040,
      0x00041000,
      0x10041000,
      0x00041040,
      0x00001000,
      0x00000040,
      0x10040000,
      0x10000040,
      0x10001000,
      0x00001040,
      0x00041000,
      0x00040040,
      0x10040040,
      0x10041000,
      0x00001040,
      0x00000000,
      0x00000000,
      0x10040040,
      0x10000040,
      0x10001000,
      0x00041040,
      0x00040000,
      0x00041040,
      0x00040000,
      0x10041000,
      0x00001000,
      0x00000040,
      0x10040040,
      0x00001000,
      0x00041040,
      0x10001000,
      0x00000040,
      0x10000040,
      0x10040000,
      0x10040040,
      0x10000000,
      0x00040000,
      0x10001040,
      0x00000000,
      0x10041040,
      0x00040040,
      0x10000040,
      0x10040000,
      0x10001000,
      0x10001040,
      0x00000000,
      0x10041040,
      0x00041000,
      0x00041000,
      0x00001040,
      0x00001040,
      0x00040040,
      0x10000000,
      0x10041000
    ];
  }

  //Fields
  int? _blockSize;
  late List<int> byteBit;
  late List<int> bigByte;
  late List<int> pc1;
  late List<int> toTrot;
  late List<int> pc2;
  late List<int> sp1;
  late List<int> sp2;
  late List<int> sp3;
  late List<int> sp4;
  late List<int> sp5;
  late List<int> sp6;
  late List<int> sp7;
  late List<int> sp8;
  List<int>? _keys;

  //Properties
  List<int>? get keys => _keys;
  @override
  String get algorithmName => _Asn1.des;
  @override
  bool get isBlock => false;
  @override
  int? get blockSize => _blockSize;

  //Implementation
  @override
  void initialize(bool? isEncryption, _ICipherParameter? parameters) {
    if (parameters is! _KeyParameter) {
      throw ArgumentError.value(parameters, 'parameters', 'Invalid parameter');
    }
    _keys = generateWorkingKey(isEncryption, parameters.keys);
  }

  @override
  Map<String, dynamic> processBlock(
      List<int>? inBytes, int inOffset, List<int>? outBytes, int? outOffset) {
    ArgumentError.checkNotNull(_keys);
    if ((inOffset + _blockSize!) > inBytes!.length) {
      throw ArgumentError.value(
          inOffset, 'inOffset', 'Invalid length in input bytes');
    }
    if ((outOffset! + _blockSize!) > outBytes!.length) {
      throw ArgumentError.value(
          outOffset, 'outOffset', 'Invalid length in output bytes');
    }
    encryptData(_keys, inBytes, inOffset, outBytes, outOffset);
    return <String, dynamic>{'length': _blockSize, 'output': outBytes};
  }

  @override
  void reset() {}
  List<int> generateWorkingKey(bool? isEncrypt, List<int> bytes) {
    final List<int> newKeys = List<int>.generate(32, (int i) => 0);
    final List<bool> bytes1 = List<bool>.generate(56, (int i) => false);
    final List<bool> bytes2 = List<bool>.generate(56, (int i) => false);
    for (int j = 0; j < 56; j++) {
      final int length = pc1[j];
      bytes1[j] =
          (bytes[length.toUnsigned(32) >> 3] & byteBit[length & 07]) != 0;
    }
    for (int i = 0; i < 16; i++) {
      int a;
      int b;
      int c;
      if (isEncrypt!) {
        b = i << 1;
      } else {
        b = (15 - i) << 1;
      }
      c = b + 1;
      newKeys[b] = newKeys[c] = 0;
      for (int j = 0; j < 28; j++) {
        a = j + toTrot[i];
        if (a < 28) {
          bytes2[j] = bytes1[a];
        } else {
          bytes2[j] = bytes1[a - 28];
        }
      }
      for (int j = 28; j < 56; j++) {
        a = j + toTrot[i];
        if (a < 56) {
          bytes2[j] = bytes1[a];
        } else {
          bytes2[j] = bytes1[a - 28];
        }
      }
      for (int j = 0; j < 24; j++) {
        if (bytes2[pc2[j]]) {
          newKeys[b] |= bigByte[j];
        }
        if (bytes2[pc2[j + 24]]) {
          newKeys[c] |= bigByte[j];
        }
      }
    }
    for (int i = 0; i != 32; i += 2) {
      int value1, value2;
      value1 = newKeys[i];
      value2 = newKeys[i + 1];
      newKeys[i] = (((value1 & 0x00fc0000) << 6).toUnsigned(32) |
              ((value1 & 0x00000fc0) << 10).toUnsigned(32) |
              ((value2 & 0x00fc0000).toUnsigned(32) >> 10) |
              ((value2 & 0x00000fc0).toUnsigned(32) >> 6))
          .toSigned(32);
      newKeys[i + 1] = (((value1 & 0x0003f000) << 12).toUnsigned(32) |
              ((value1 & 0x0000003f) << 16).toUnsigned(32) |
              ((value2 & 0x0003f000).toUnsigned(32) >> 4) |
              (value2 & 0x0000003f).toUnsigned(32))
          .toSigned(32);
    }
    return newKeys;
  }

  void encryptData(List<int>? keys, List<int> inputBytes, int inOffset,
      List<int> outBytes, int outOffset) {
    int left = _Asn1.beToUInt32(inputBytes, inOffset);
    int right = _Asn1.beToUInt32(inputBytes, inOffset + 4);
    int data = (((left >> 4) ^ right) & 0x0f0f0f0f).toUnsigned(32);
    right ^= data;
    left ^= data << 4;
    data = ((left >> 16) ^ right) & 0x0000ffff;
    right ^= data;
    left ^= data << 16;
    data = ((right >> 2) ^ left) & 0x33333333;
    left ^= data;
    right ^= data << 2;
    data = ((right >> 8) ^ left) & 0x00ff00ff;
    left ^= data;
    right ^= data << 8;
    right = ((right << 1) | (right >> 31)).toUnsigned(32);
    data = (left ^ right) & 0xaaaaaaaa;
    left ^= data;
    right ^= data;
    left = ((left << 1) | (left >> 31)).toUnsigned(32);
    for (int round = 0; round < 8; round++) {
      data = ((right << 28) | (right >> 4)).toUnsigned(32);
      data ^= (keys![round * 4 + 0]).toUnsigned(32);
      int value = sp7[data & 0x3f];
      value |= sp5[(data >> 8) & 0x3f];
      value |= sp3[(data >> 16) & 0x3f];
      value |= sp1[(data >> 24) & 0x3f];
      data = right ^ (keys[round * 4 + 1]).toUnsigned(32);
      value |= sp8[data & 0x3f];
      value |= sp6[(data >> 8) & 0x3f];
      value |= sp4[(data >> 16) & 0x3f];
      value |= sp2[(data >> 24) & 0x3f];
      left ^= value;
      data = ((left << 28) | (left >> 4)).toUnsigned(32);
      data ^= (keys[round * 4 + 2]).toUnsigned(32);
      value = sp7[data & 0x3f];
      value |= sp5[(data >> 8) & 0x3f];
      value |= sp3[(data >> 16) & 0x3f];
      value |= sp1[(data >> 24) & 0x3f];
      data = left ^ (keys[round * 4 + 3]).toUnsigned(32);
      value |= sp8[data & 0x3f];
      value |= sp6[(data >> 8) & 0x3f];
      value |= sp4[(data >> 16) & 0x3f];
      value |= sp2[(data >> 24) & 0x3f];
      right ^= value;
    }
    right = ((right << 31) | (right >> 1)).toUnsigned(32);
    data = (left ^ right) & 0xaaaaaaaa;
    left ^= data;
    right ^= data;
    left = ((left << 31) | (left >> 1)).toUnsigned(32);
    data = ((left >> 8) ^ right) & 0x00ff00ff;
    right ^= data;
    left ^= data << 8;
    data = ((left >> 2) ^ right) & 0x33333333;
    right ^= data;
    left ^= data << 2;
    data = ((right >> 16) ^ left) & 0x0000ffff;
    left ^= data;
    right ^= data << 16;
    data = ((right >> 4) ^ left) & 0x0f0f0f0f;
    left ^= data;
    right ^= data << 4;
    _Asn1.uInt32ToBe(right, outBytes, outOffset);
    _Asn1.uInt32ToBe(left, outBytes, outOffset + 4);
  }
}
