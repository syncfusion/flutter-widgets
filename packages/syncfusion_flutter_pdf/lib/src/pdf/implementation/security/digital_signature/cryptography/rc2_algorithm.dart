part of pdf;

class _Rc2Algorithm implements _ICipher {
  _Rc2Algorithm() {
    _piTable = <int>[
      217,
      120,
      249,
      196,
      25,
      221,
      181,
      237,
      40,
      233,
      253,
      121,
      74,
      160,
      216,
      157,
      198,
      126,
      55,
      131,
      43,
      118,
      83,
      142,
      98,
      76,
      100,
      136,
      68,
      139,
      251,
      162,
      23,
      154,
      89,
      245,
      135,
      179,
      79,
      19,
      97,
      69,
      109,
      141,
      9,
      129,
      125,
      50,
      189,
      143,
      64,
      235,
      134,
      183,
      123,
      11,
      240,
      149,
      33,
      34,
      92,
      107,
      78,
      130,
      84,
      214,
      101,
      147,
      206,
      96,
      178,
      28,
      115,
      86,
      192,
      20,
      167,
      140,
      241,
      220,
      18,
      117,
      202,
      31,
      59,
      190,
      228,
      209,
      66,
      61,
      212,
      48,
      163,
      60,
      182,
      38,
      111,
      191,
      14,
      218,
      70,
      105,
      7,
      87,
      39,
      242,
      29,
      155,
      188,
      148,
      67,
      3,
      248,
      17,
      199,
      246,
      144,
      239,
      62,
      231,
      6,
      195,
      213,
      47,
      200,
      102,
      30,
      215,
      8,
      232,
      234,
      222,
      128,
      82,
      238,
      247,
      132,
      170,
      114,
      172,
      53,
      77,
      106,
      42,
      150,
      26,
      210,
      113,
      90,
      21,
      73,
      116,
      75,
      159,
      208,
      94,
      4,
      24,
      164,
      236,
      194,
      224,
      65,
      110,
      15,
      81,
      203,
      204,
      36,
      145,
      175,
      80,
      161,
      244,
      112,
      57,
      153,
      124,
      58,
      133,
      35,
      184,
      180,
      122,
      252,
      2,
      54,
      91,
      37,
      85,
      151,
      49,
      45,
      93,
      250,
      152,
      227,
      138,
      146,
      174,
      5,
      223,
      41,
      16,
      103,
      108,
      186,
      201,
      211,
      0,
      230,
      207,
      225,
      158,
      168,
      44,
      99,
      22,
      1,
      63,
      88,
      226,
      137,
      169,
      13,
      56,
      52,
      27,
      171,
      51,
      255,
      176,
      187,
      72,
      12,
      95,
      185,
      177,
      205,
      46,
      197,
      243,
      219,
      71,
      229,
      165,
      156,
      119,
      10,
      166,
      32,
      104,
      254,
      127,
      193,
      173
    ];
    _blockSize = 8;
  }
  //Fields
  int? _blockSize;
  late List<int> _key;
  bool? _isEncrypt;
  late List<int> _piTable;

  //Properties
  @override
  String get algorithmName => 'RC2';
  @override
  bool get isBlock => false;
  @override
  int? get blockSize => _blockSize;

  //Implementation
  List<int> generateKey(List<int> key, int bits) {
    int x;
    final List<int> xKey = List<int>.generate(128, (int i) => 0);
    for (int i = 0; i != key.length; i++) {
      xKey[i] = key[i] & 0xff;
    }
    int len = key.length;
    if (len < 128) {
      int index = 0;
      x = xKey[len - 1];
      do {
        x = _piTable[(x + xKey[index++]) & 255] & 0xff;
        xKey[len++] = x;
      } while (len < 128);
    }
    len = (bits + 7) >> 3;
    x = _piTable[xKey[128 - len] & (255 >> (7 & -bits))] & 0xff;
    xKey[128 - len] = x;
    for (int i = 128 - len - 1; i >= 0; i--) {
      x = _piTable[x ^ xKey[i + len]] & 0xff;
      xKey[i] = x;
    }
    final List<int> newKey = <int>[];
    for (int i = 0; i < 64; i++) {
      newKey.add(xKey[2 * i] + (xKey[2 * i + 1] << 8));
    }
    return newKey;
  }

  @override
  void initialize(bool? forEncryption, _ICipherParameter? parameters) {
    _isEncrypt = forEncryption;
    if (parameters is _KeyParameter) {
      final List<int> key = parameters.keys;
      _key = generateKey(key, key.length * 8);
    }
  }

  @override
  void reset() {}

  @override
  Map<String, dynamic> processBlock(
      List<int>? input, int inOff, List<int>? output, int? outOff) {
    if (_isEncrypt!) {
      encryptBlock(input!, inOff, output!, outOff!);
    } else {
      decryptBlock(input!, inOff, output!, outOff!);
    }
    return <String, dynamic>{'length': _blockSize, 'output': output};
  }

  int rotateWordLeft(int x, int y) {
    x &= 0xffff;
    return (x << y) | (x >> (16 - y));
  }

  void encryptBlock(
      List<int> input, int inOff, List<int> outBytes, int outOff) {
    int x76 = ((input[inOff + 7] & 0xff) << 8) + (input[inOff + 6] & 0xff);
    int x54 = ((input[inOff + 5] & 0xff) << 8) + (input[inOff + 4] & 0xff);
    int x32 = ((input[inOff + 3] & 0xff) << 8) + (input[inOff + 2] & 0xff);
    int x10 = ((input[inOff + 1] & 0xff) << 8) + (input[inOff + 0] & 0xff);
    for (int i = 0; i <= 16; i += 4) {
      x10 = rotateWordLeft(x10 + (x32 & ~x76) + (x54 & x76) + _key[i], 1);
      x32 = rotateWordLeft(x32 + (x54 & ~x10) + (x76 & x10) + _key[i + 1], 2);
      x54 = rotateWordLeft(x54 + (x76 & ~x32) + (x10 & x32) + _key[i + 2], 3);
      x76 = rotateWordLeft(x76 + (x10 & ~x54) + (x32 & x54) + _key[i + 3], 5);
    }
    x10 += _key[x76 & 63];
    x32 += _key[x10 & 63];
    x54 += _key[x32 & 63];
    x76 += _key[x54 & 63];
    for (int i = 20; i <= 40; i += 4) {
      x10 = rotateWordLeft(x10 + (x32 & ~x76) + (x54 & x76) + _key[i], 1);
      x32 = rotateWordLeft(x32 + (x54 & ~x10) + (x76 & x10) + _key[i + 1], 2);
      x54 = rotateWordLeft(x54 + (x76 & ~x32) + (x10 & x32) + _key[i + 2], 3);
      x76 = rotateWordLeft(x76 + (x10 & ~x54) + (x32 & x54) + _key[i + 3], 5);
    }
    x10 += _key[x76 & 63];
    x32 += _key[x10 & 63];
    x54 += _key[x32 & 63];
    x76 += _key[x54 & 63];
    for (int i = 44; i < 64; i += 4) {
      x10 = rotateWordLeft(x10 + (x32 & ~x76) + (x54 & x76) + _key[i], 1);
      x32 = rotateWordLeft(x32 + (x54 & ~x10) + (x76 & x10) + _key[i + 1], 2);
      x54 = rotateWordLeft(x54 + (x76 & ~x32) + (x10 & x32) + _key[i + 2], 3);
      x76 = rotateWordLeft(x76 + (x10 & ~x54) + (x32 & x54) + _key[i + 3], 5);
    }
    outBytes[outOff + 0] = x10.toUnsigned(8);
    outBytes[outOff + 1] = (x10 >> 8).toUnsigned(8);
    outBytes[outOff + 2] = x32.toUnsigned(8);
    outBytes[outOff + 3] = (x32 >> 8).toUnsigned(8);
    outBytes[outOff + 4] = x54.toUnsigned(8);
    outBytes[outOff + 5] = (x54 >> 8).toUnsigned(8);
    outBytes[outOff + 6] = x76.toUnsigned(8);
    outBytes[outOff + 7] = (x76 >> 8).toUnsigned(8);
  }

  void decryptBlock(
      List<int> input, int inOff, List<int> outBytes, int outOff) {
    int x76 = ((input[inOff + 7] & 0xff) << 8) + (input[inOff + 6] & 0xff);
    int x54 = ((input[inOff + 5] & 0xff) << 8) + (input[inOff + 4] & 0xff);
    int x32 = ((input[inOff + 3] & 0xff) << 8) + (input[inOff + 2] & 0xff);
    int x10 = ((input[inOff + 1] & 0xff) << 8) + (input[inOff + 0] & 0xff);
    for (int i = 60; i >= 44; i -= 4) {
      x76 =
          rotateWordLeft(x76, 11) - ((x10 & ~x54) + (x32 & x54) + _key[i + 3]);
      x54 =
          rotateWordLeft(x54, 13) - ((x76 & ~x32) + (x10 & x32) + _key[i + 2]);
      x32 =
          rotateWordLeft(x32, 14) - ((x54 & ~x10) + (x76 & x10) + _key[i + 1]);
      x10 = rotateWordLeft(x10, 15) - ((x32 & ~x76) + (x54 & x76) + _key[i]);
    }
    x76 -= _key[x54 & 63];
    x54 -= _key[x32 & 63];
    x32 -= _key[x10 & 63];
    x10 -= _key[x76 & 63];
    for (int i = 40; i >= 20; i -= 4) {
      x76 =
          rotateWordLeft(x76, 11) - ((x10 & ~x54) + (x32 & x54) + _key[i + 3]);
      x54 =
          rotateWordLeft(x54, 13) - ((x76 & ~x32) + (x10 & x32) + _key[i + 2]);
      x32 =
          rotateWordLeft(x32, 14) - ((x54 & ~x10) + (x76 & x10) + _key[i + 1]);
      x10 = rotateWordLeft(x10, 15) - ((x32 & ~x76) + (x54 & x76) + _key[i]);
    }
    x76 -= _key[x54 & 63];
    x54 -= _key[x32 & 63];
    x32 -= _key[x10 & 63];
    x10 -= _key[x76 & 63];
    for (int i = 16; i >= 0; i -= 4) {
      x76 =
          rotateWordLeft(x76, 11) - ((x10 & ~x54) + (x32 & x54) + _key[i + 3]);
      x54 =
          rotateWordLeft(x54, 13) - ((x76 & ~x32) + (x10 & x32) + _key[i + 2]);
      x32 =
          rotateWordLeft(x32, 14) - ((x54 & ~x10) + (x76 & x10) + _key[i + 1]);
      x10 = rotateWordLeft(x10, 15) - ((x32 & ~x76) + (x54 & x76) + _key[i]);
    }
    outBytes[outOff + 0] = x10.toUnsigned(8);
    outBytes[outOff + 1] = (x10 >> 8).toUnsigned(8);
    outBytes[outOff + 2] = x32.toUnsigned(8);
    outBytes[outOff + 3] = (x32 >> 8).toUnsigned(8);
    outBytes[outOff + 4] = x54.toUnsigned(8);
    outBytes[outOff + 5] = (x54 >> 8).toUnsigned(8);
    outBytes[outOff + 6] = x76.toUnsigned(8);
    outBytes[outOff + 7] = (x76 >> 8).toUnsigned(8);
  }
}
