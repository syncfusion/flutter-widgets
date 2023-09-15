import '../../utils/enum.dart';
import 'qr_code_values.dart';

/// Represents the error correction code word
class ErrorCorrectionCodeWords {
  /// Creates the error correction code word
  ErrorCorrectionCodeWords({this.codeVersion, this.correctionLevel}) {
    _codeValue = QRCodeValue(
        qrCodeVersion: codeVersion!, errorCorrectionLevel: correctionLevel!);
    eccw = _codeValue.noOfErrorCorrectionCodeWord;
  }

  /// Specifies the code version
  final QRCodeVersion? codeVersion;

  /// Specifies the correction level
  final ErrorCorrectionLevel? correctionLevel;

  /// Specifies the alpha  value
  static const List<int> _alpha = <int>[
    1,
    2,
    4,
    8,
    16,
    32,
    64,
    128,
    29,
    58,
    116,
    232,
    205,
    135,
    19,
    38,
    76,
    152,
    45,
    90,
    180,
    117,
    234,
    201,
    143,
    3,
    6,
    12,
    24,
    48,
    96,
    192,
    157,
    39,
    78,
    156,
    37,
    74,
    148,
    53,
    106,
    212,
    181,
    119,
    238,
    193,
    159,
    35,
    70,
    140,
    5,
    10,
    20,
    40,
    80,
    160,
    93,
    186,
    105,
    210,
    185,
    111,
    222,
    161,
    95,
    190,
    97,
    194,
    153,
    47,
    94,
    188,
    101,
    202,
    137,
    15,
    30,
    60,
    120,
    240,
    253,
    231,
    211,
    187,
    107,
    214,
    177,
    127,
    254,
    225,
    223,
    163,
    91,
    182,
    113,
    226,
    217,
    175,
    67,
    134,
    17,
    34,
    68,
    136,
    13,
    26,
    52,
    104,
    208,
    189,
    103,
    206,
    129,
    31,
    62,
    124,
    248,
    237,
    199,
    147,
    59,
    118,
    236,
    197,
    151,
    51,
    102,
    204,
    133,
    23,
    46,
    92,
    184,
    109,
    218,
    169,
    79,
    158,
    33,
    66,
    132,
    21,
    42,
    84,
    168,
    77,
    154,
    41,
    82,
    164,
    85,
    170,
    73,
    146,
    57,
    114,
    228,
    213,
    183,
    115,
    230,
    209,
    191,
    99,
    198,
    145,
    63,
    126,
    252,
    229,
    215,
    179,
    123,
    246,
    241,
    255,
    227,
    219,
    171,
    75,
    150,
    49,
    98,
    196,
    149,
    55,
    110,
    220,
    165,
    87,
    174,
    65,
    130,
    25,
    50,
    100,
    200,
    141,
    7,
    14,
    28,
    56,
    112,
    224,
    221,
    167,
    83,
    166,
    81,
    162,
    89,
    178,
    121,
    242,
    249,
    239,
    195,
    155,
    43,
    86,
    172,
    69,
    138,
    9,
    18,
    36,
    72,
    144,
    61,
    122,
    244,
    245,
    247,
    243,
    251,
    235,
    203,
    139,
    11,
    22,
    44,
    88,
    176,
    125,
    250,
    233,
    207,
    131,
    27,
    54,
    108,
    216,
    173,
    71,
    142
  ];

  /// Specifies the error corrcetion code word
  late int eccw;

  /// Specifies the data bits
  late int dataBits;

  /// Specifies the data code word
  late List<String?> dataCodeWords;

  /// Specifies the list of integer value based on alpha value
  late List<int> _gx;

  /// Specifies the list of decimal value
  late List<int> _decimalValue;

  /// Specifies the code value
  late QRCodeValue _codeValue;

  /// Returns the error correction word
  ///
  /// This is deliberately  a very large method. This method could be
  /// refactored to a smaller methods, but it degrades the performance.Since it
  /// uses single switch condition for calculating the error correction code
  /// word based on the provided version
  List<String> getERCW() {
    List<int> decimalRepresentation;
    List<String> errorCorrectionWord;
    _decimalValue = <int>[dataBits];
    switch (eccw) {
      case 7:
        _gx = <int>[0, 87, 229, 146, 149, 238, 102, 21];
        break;
      case 10:
        _gx = <int>[0, 251, 67, 46, 61, 118, 70, 64, 94, 32, 45];
        break;
      case 13:
        _gx = <int>[
          0,
          74,
          152,
          176,
          100,
          86,
          100,
          106,
          104,
          130,
          218,
          206,
          140,
          78
        ];
        break;
      case 15:
        _gx = <int>[
          0,
          8,
          183,
          61,
          91,
          202,
          37,
          51,
          58,
          58,
          237,
          140,
          124,
          5,
          99,
          105
        ];
        break;
      case 16:
        _gx = <int>[
          0,
          120,
          104,
          107,
          109,
          102,
          161,
          76,
          3,
          91,
          191,
          147,
          169,
          182,
          194,
          225,
          120
        ];
        break;
      case 17:
        _gx = <int>[
          0,
          43,
          139,
          206,
          78,
          43,
          239,
          123,
          206,
          214,
          147,
          24,
          99,
          150,
          39,
          243,
          163,
          136
        ];
        break;
      case 18:
        _gx = <int>[
          0,
          215,
          234,
          158,
          94,
          184,
          97,
          118,
          170,
          79,
          187,
          152,
          148,
          252,
          179,
          5,
          98,
          96,
          153
        ];
        break;
      case 20:
        _gx = <int>[
          0,
          17,
          60,
          79,
          50,
          61,
          163,
          26,
          187,
          202,
          180,
          221,
          225,
          83,
          239,
          156,
          164,
          212,
          212,
          188,
          190
        ];
        break;
      case 22:
        _gx = <int>[
          0,
          210,
          171,
          247,
          242,
          93,
          230,
          14,
          109,
          221,
          53,
          200,
          74,
          8,
          172,
          98,
          80,
          219,
          134,
          160,
          105,
          165,
          231
        ];
        break;
      case 24:
        _gx = <int>[
          0,
          229,
          121,
          135,
          48,
          211,
          117,
          251,
          126,
          159,
          180,
          169,
          152,
          192,
          226,
          228,
          218,
          111,
          0,
          117,
          232,
          87,
          96,
          227,
          21
        ];
        break;
      case 26:
        _gx = <int>[
          0,
          173,
          125,
          158,
          2,
          103,
          182,
          118,
          17,
          145,
          201,
          111,
          28,
          165,
          53,
          161,
          21,
          245,
          142,
          13,
          102,
          48,
          227,
          153,
          145,
          218,
          70
        ];
        break;
      case 28:
        _gx = <int>[
          0,
          168,
          223,
          200,
          104,
          224,
          234,
          108,
          180,
          110,
          190,
          195,
          147,
          205,
          27,
          232,
          201,
          21,
          43,
          245,
          87,
          42,
          195,
          212,
          119,
          242,
          37,
          9,
          123
        ];
        break;
      case 30:
        _gx = <int>[
          0,
          41,
          173,
          145,
          152,
          216,
          31,
          179,
          182,
          50,
          48,
          110,
          86,
          239,
          96,
          222,
          125,
          42,
          173,
          226,
          193,
          224,
          130,
          156,
          37,
          251,
          216,
          238,
          40,
          192,
          180
        ];
        break;
      case 32:
        _gx = <int>[
          0,
          10,
          6,
          106,
          190,
          249,
          167,
          4,
          67,
          209,
          138,
          138,
          32,
          242,
          123,
          89,
          27,
          120,
          185,
          80,
          156,
          38,
          69,
          171,
          60,
          28,
          222,
          80,
          52,
          254,
          185,
          220,
          241
        ];
        break;
      case 34:
        _gx = <int>[
          0,
          111,
          77,
          146,
          94,
          26,
          21,
          108,
          19,
          105,
          94,
          113,
          193,
          86,
          140,
          163,
          125,
          58,
          158,
          229,
          239,
          218,
          103,
          56,
          70,
          114,
          61,
          183,
          129,
          167,
          13,
          98,
          62,
          129,
          51
        ];
        break;
      case 36:
        _gx = <int>[
          0,
          200,
          183,
          98,
          16,
          172,
          31,
          246,
          234,
          60,
          152,
          115,
          0,
          167,
          152,
          113,
          248,
          238,
          107,
          18,
          63,
          218,
          37,
          87,
          210,
          105,
          177,
          120,
          74,
          121,
          196,
          117,
          251,
          113,
          233,
          30,
          120
        ];
        break;
      case 40:
        _gx = <int>[
          0,
          59,
          116,
          79,
          161,
          252,
          98,
          128,
          205,
          128,
          161,
          247,
          57,
          163,
          56,
          235,
          106,
          53,
          26,
          187,
          174,
          226,
          104,
          170,
          7,
          175,
          35,
          181,
          114,
          88,
          41,
          47,
          163,
          125,
          134,
          72,
          20,
          232,
          53,
          35,
          15
        ];
        break;
      case 42:
        _gx = <int>[
          0,
          250,
          103,
          221,
          230,
          25,
          18,
          137,
          231,
          0,
          3,
          58,
          242,
          221,
          191,
          110,
          84,
          230,
          8,
          188,
          106,
          96,
          147,
          15,
          131,
          139,
          34,
          101,
          223,
          39,
          101,
          213,
          199,
          237,
          254,
          201,
          123,
          171,
          162,
          194,
          117,
          50,
          96
        ];
        break;
      case 44:
        _gx = <int>[
          0,
          190,
          7,
          61,
          121,
          71,
          246,
          69,
          55,
          168,
          188,
          89,
          243,
          191,
          25,
          72,
          123,
          9,
          145,
          14,
          247,
          1,
          238,
          44,
          78,
          143,
          62,
          224,
          126,
          118,
          114,
          68,
          163,
          52,
          194,
          217,
          147,
          204,
          169,
          37,
          130,
          113,
          102,
          73,
          181
        ];
        break;
      case 46:
        _gx = <int>[
          0,
          112,
          94,
          88,
          112,
          253,
          224,
          202,
          115,
          187,
          99,
          89,
          5,
          54,
          113,
          129,
          44,
          58,
          16,
          135,
          216,
          169,
          211,
          36,
          1,
          4,
          96,
          60,
          241,
          73,
          104,
          234,
          8,
          249,
          245,
          119,
          174,
          52,
          25,
          157,
          224,
          43,
          202,
          223,
          19,
          82,
          15
        ];
        break;
      case 48:
        _gx = <int>[
          0,
          228,
          25,
          196,
          130,
          211,
          146,
          60,
          24,
          251,
          90,
          39,
          102,
          240,
          61,
          178,
          63,
          46,
          123,
          115,
          18,
          221,
          111,
          135,
          160,
          182,
          205,
          107,
          206,
          95,
          150,
          120,
          184,
          91,
          21,
          247,
          156,
          140,
          238,
          191,
          11,
          94,
          227,
          84,
          50,
          163,
          39,
          34,
          108
        ];
        break;
      case 50:
        _gx = <int>[
          0,
          232,
          125,
          157,
          161,
          164,
          9,
          118,
          46,
          209,
          99,
          203,
          193,
          35,
          3,
          209,
          111,
          195,
          242,
          203,
          225,
          46,
          13,
          32,
          160,
          126,
          209,
          130,
          160,
          242,
          215,
          242,
          75,
          77,
          42,
          189,
          32,
          113,
          65,
          124,
          69,
          228,
          114,
          235,
          175,
          124,
          170,
          215,
          232,
          133,
          205
        ];
        break;
      case 52:
        _gx = <int>[
          0,
          116,
          50,
          86,
          186,
          50,
          220,
          251,
          89,
          192,
          46,
          86,
          127,
          124,
          19,
          184,
          233,
          151,
          215,
          22,
          14,
          59,
          145,
          37,
          242,
          203,
          134,
          254,
          89,
          190,
          94,
          59,
          65,
          124,
          113,
          100,
          233,
          235,
          121,
          22,
          76,
          86,
          97,
          39,
          242,
          200,
          220,
          101,
          33,
          239,
          254,
          116,
          51
        ];
        break;
      case 54:
        _gx = <int>[
          0,
          183,
          26,
          201,
          87,
          210,
          221,
          113,
          21,
          46,
          65,
          45,
          50,
          238,
          184,
          249,
          225,
          102,
          58,
          209,
          218,
          109,
          165,
          26,
          95,
          184,
          192,
          52,
          245,
          35,
          254,
          238,
          175,
          172,
          79,
          123,
          25,
          122,
          43,
          120,
          108,
          215,
          80,
          128,
          201,
          235,
          8,
          153,
          59,
          101,
          31,
          198,
          76,
          31,
          156
        ];
        break;
      case 56:
        _gx = <int>[
          0,
          106,
          120,
          107,
          157,
          164,
          216,
          112,
          116,
          2,
          91,
          248,
          163,
          36,
          201,
          202,
          229,
          6,
          144,
          254,
          155,
          135,
          208,
          170,
          209,
          12,
          139,
          127,
          142,
          182,
          249,
          177,
          174,
          190,
          28,
          10,
          85,
          239,
          184,
          101,
          124,
          152,
          206,
          96,
          23,
          163,
          61,
          27,
          196,
          247,
          151,
          154,
          202,
          207,
          20,
          61,
          10
        ];
        break;
      case 58:
        _gx = <int>[
          0,
          82,
          116,
          26,
          247,
          66,
          27,
          62,
          107,
          252,
          182,
          200,
          185,
          235,
          55,
          251,
          242,
          210,
          144,
          154,
          237,
          176,
          141,
          192,
          248,
          152,
          249,
          206,
          85,
          253,
          142,
          65,
          165,
          125,
          23,
          24,
          30,
          122,
          240,
          214,
          6,
          129,
          218,
          29,
          145,
          127,
          134,
          206,
          245,
          117,
          29,
          41,
          63,
          159,
          142,
          233,
          125,
          148,
          123
        ];
        break;
      case 60:
        _gx = <int>[
          0,
          107,
          140,
          26,
          12,
          9,
          141,
          243,
          197,
          226,
          197,
          219,
          45,
          211,
          101,
          219,
          120,
          28,
          181,
          127,
          6,
          100,
          247,
          2,
          205,
          198,
          57,
          115,
          219,
          101,
          109,
          160,
          82,
          37,
          38,
          238,
          49,
          160,
          209,
          121,
          86,
          11,
          124,
          30,
          181,
          84,
          25,
          194,
          87,
          65,
          102,
          190,
          220,
          70,
          27,
          209,
          16,
          89,
          7,
          33,
          240
        ];
        break;
      case 62:
        _gx = <int>[
          0,
          65,
          202,
          113,
          98,
          71,
          223,
          248,
          118,
          214,
          94,
          0,
          122,
          37,
          23,
          2,
          228,
          58,
          121,
          7,
          105,
          135,
          78,
          243,
          118,
          70,
          76,
          223,
          89,
          72,
          50,
          70,
          111,
          194,
          17,
          212,
          126,
          181,
          35,
          221,
          117,
          235,
          11,
          229,
          149,
          147,
          123,
          213,
          40,
          115,
          6,
          200,
          100,
          26,
          246,
          182,
          218,
          127,
          215,
          36,
          186,
          110,
          106
        ];
        break;
      case 64:
        _gx = <int>[
          0,
          45,
          51,
          175,
          9,
          7,
          158,
          159,
          49,
          68,
          119,
          92,
          123,
          177,
          204,
          187,
          254,
          200,
          78,
          141,
          149,
          119,
          26,
          127,
          53,
          160,
          93,
          199,
          212,
          29,
          24,
          145,
          156,
          208,
          150,
          218,
          209,
          4,
          216,
          91,
          47,
          184,
          146,
          47,
          140,
          195,
          195,
          125,
          242,
          238,
          63,
          99,
          108,
          140,
          230,
          242,
          31,
          204,
          11,
          178,
          243,
          217,
          156,
          213,
          231
        ];
        break;
      case 66:
        _gx = <int>[
          0,
          5,
          118,
          222,
          180,
          136,
          136,
          162,
          51,
          46,
          117,
          13,
          215,
          81,
          17,
          139,
          247,
          197,
          171,
          95,
          173,
          65,
          137,
          178,
          68,
          111,
          95,
          101,
          41,
          72,
          214,
          169,
          197,
          95,
          7,
          44,
          154,
          77,
          111,
          236,
          40,
          121,
          143,
          63,
          87,
          80,
          253,
          240,
          126,
          217,
          77,
          34,
          232,
          106,
          50,
          168,
          82,
          76,
          146,
          67,
          106,
          171,
          25,
          132,
          93,
          45,
          105
        ];
        break;
      case 68:
        _gx = <int>[
          0,
          247,
          159,
          223,
          33,
          224,
          93,
          77,
          70,
          90,
          160,
          32,
          254,
          43,
          150,
          84,
          101,
          190,
          205,
          133,
          52,
          60,
          202,
          165,
          220,
          203,
          151,
          93,
          84,
          15,
          84,
          253,
          173,
          160,
          89,
          227,
          52,
          199,
          97,
          95,
          231,
          52,
          177,
          41,
          125,
          137,
          241,
          166,
          225,
          118,
          2,
          54,
          32,
          82,
          215,
          175,
          198,
          43,
          238,
          235,
          27,
          101,
          184,
          127,
          3,
          5,
          8,
          163,
          238
        ];
        break;
    }

    _gx = _getElement(_gx, _alpha);
    _binaryToDecimal(dataCodeWords);
    decimalRepresentation = _getPolynominalDivision();
    errorCorrectionWord = _convertDecimalToBinary(decimalRepresentation);
    return errorCorrectionWord;
  }

  /// Converts binary to decimal value
  void _binaryToDecimal(List<String?> inString) {
    _decimalValue = <int>[];
    for (int i = 0; i < inString.length; i++) {
      _decimalValue.add(int.parse(inString[i]!, radix: 2));
    }
  }

  /// Converts decimal to binary value
  List<String> _convertDecimalToBinary(List<int> decimalRepresentation) {
    final List<String> toBinary = <String>[];
    for (int i = 0; i < decimalRepresentation.length; i++) {
      final String temp = decimalRepresentation[i].toRadixString(2);
      String text = '';

      final int diff = 8 - temp.length;
      if (diff != 0) {
        for (int i = 0; i < diff; i++) {
          text += '0';
        }
      }
      toBinary.add(text + temp);
    }

    return toBinary;
  }

  /// Calculates the polynomial value
  List<int> _getPolynominalDivision() {
    Map<int, int> messagePolynom = <int, int>{};
    for (int i = 0; i < _decimalValue.length; i++) {
      messagePolynom[_decimalValue.length - 1 - i] = _decimalValue[i];
    }

    Map<int, int> generatorPolynom = <int, int>{};
    for (int i = 0; i < _gx.length; i++) {
      generatorPolynom[_gx.length - 1 - i] =
          _getElementFromAlpha(_gx[i], _alpha);
    }

    Map<int, int> tempMessagePolynom = <int, int>{};
    for (int i = 0; i < messagePolynom.length; i++) {
      final MapEntry<int, int> currentEntry =
          messagePolynom.entries.elementAt(i);
      tempMessagePolynom[currentEntry.key + eccw] = currentEntry.value;
    }

    messagePolynom = tempMessagePolynom;
    final int leadTermFactor = _decimalValue.length + eccw - _gx.length;

    tempMessagePolynom = <int, int>{};
    for (int i = 0; i < generatorPolynom.length; i++) {
      final MapEntry<int, int> currentEntry =
          generatorPolynom.entries.elementAt(i);
      tempMessagePolynom[currentEntry.key + leadTermFactor] =
          currentEntry.value;
    }

    generatorPolynom = tempMessagePolynom;
    Map<int, int> leadTermSource = messagePolynom;
    for (int i = 0; i < messagePolynom.length; i++) {
      final int largestExponent = _getLargestExponent(leadTermSource);
      if (leadTermSource[largestExponent] == 0) {
        leadTermSource.remove(largestExponent);
        if (i == 0) {
          leadTermSource =
              _updateLeadTermSource(i, leadTermSource, generatorPolynom);
        }
      } else {
        leadTermSource =
            _updateLeadTermSource(i, leadTermSource, generatorPolynom);
      }
    }

    // QR code is not scannable when the input string contains spaces.
    // eccw = leadTermSource.length;
    final List<int> returnValue = <int>[];
    for (int i = 0; i < leadTermSource.length; i++) {
      returnValue.add(leadTermSource.entries.elementAt(i).value);
    }

    return returnValue;
  }

  /// Updates the lead term source value
  Map<int, int> _updateLeadTermSource(
      int index, Map<int, int> leadTermSource, Map<int, int> generatorPolynom) {
    final Map<int, int> alphaNotation = _getAlphaNotation(leadTermSource);
    Map<int, int> resPoly = _getGeneratorPolynomByLeadTerm(generatorPolynom,
        alphaNotation[_getLargestExponent(alphaNotation)]!, index);
    resPoly = _getDecimalNotation(resPoly);
    resPoly = _getXORPolynoms(leadTermSource, resPoly);
    return resPoly;
  }

  /// Calculates the polynomial value
  Map<int, int> _getXORPolynoms(
      Map<int, int> messagePolynom, Map<int, int> resPolynom) {
    final Map<int, int> resultPolynom = <int, int>{};
    Map<int, int> longPoly = <int, int>{};
    Map<int, int> shortPoly = <int, int>{};

    if (messagePolynom.length >= resPolynom.length) {
      longPoly = messagePolynom;
      shortPoly = resPolynom;
    } else {
      longPoly = resPolynom;
      shortPoly = messagePolynom;
    }

    final int messagePolyExponent = _getLargestExponent(messagePolynom);
    final int shortPolyExponent = _getLargestExponent(shortPoly);

    for (int i = 0; i < longPoly.length; i++) {
      resultPolynom.putIfAbsent(
          messagePolyExponent - i,
          () =>
              longPoly.entries.elementAt(i).value ^
              (shortPoly.length > i ? shortPoly[shortPolyExponent - i]! : 0));
    }

    final int resultPolyExponent = _getLargestExponent(resultPolynom);
    resultPolynom.remove(resultPolyExponent);
    return resultPolynom;
  }

  /// Calculates the polynomial value
  Map<int, int> _getGeneratorPolynomByLeadTerm(
      Map<int, int> genPolynom, int leadTermCoefficient, int lowerExponentBy) {
    final Map<int, int> tempPolynom = <int, int>{};
    for (int i = 0; i < genPolynom.length; i++) {
      final MapEntry<int, int> currentEntry = genPolynom.entries.elementAt(i);
      tempPolynom.putIfAbsent(currentEntry.key - lowerExponentBy,
          () => (currentEntry.value + leadTermCoefficient) % 255);
    }

    return tempPolynom;
  }

  /// Converts the polynomial value to decimal notation
  Map<int, int> _getDecimalNotation(Map<int, int> poly) {
    final Map<int, int> tempPolynom = <int, int>{};
    for (int i = 0; i < poly.length; i++) {
      final MapEntry<int, int> currentEntry = poly.entries.elementAt(i);
      tempPolynom[currentEntry.key] =
          _getIntValFromAlphaExp(currentEntry.value, _alpha);
    }

    return tempPolynom;
  }

  /// Converts the polynomial value to alpha notation
  Map<int, int> _getAlphaNotation(Map<int, int> polynom) {
    final Map<int, int> tempPolynom = <int, int>{};
    for (int i = 0; i < polynom.length; i++) {
      final MapEntry<int, int> currentEntry = polynom.entries.elementAt(i);
      if (currentEntry.value != 0) {
        tempPolynom.putIfAbsent(currentEntry.key,
            () => _getElementFromAlpha(currentEntry.value, _alpha));
      }
    }

    return tempPolynom;
  }

  /// Finds the largest exponential number
  int _getLargestExponent(Map<int, int> polynom) {
    int largeExponent = 0;
    for (int i = 0; i < polynom.length; i++) {
      final MapEntry<int, int> currentEntry = polynom.entries.elementAt(i);
      if (currentEntry.key > largeExponent) {
        largeExponent = currentEntry.key;
      }
    }
    return largeExponent;
  }

  /// Returns the integer value
  int _getIntValFromAlphaExp(int element, List<int> alpha) {
    if (element > 255) {
      element = element - 255;
    }

    return alpha[element];
  }

  /// Specifies the alpha list contains the provided value
  int _getElementFromAlpha(int element, List<int> alpha) {
    int i = 0;
    for (; i < alpha.length; i++) {
      if (element == alpha[i]) {
        break;
      }
    }

    return i;
  }

  /// Returns the list of integer value based on the alpha
  List<int> _getElement(List<int> element, List<int> alpha) {
    final List<int> gx = <int>[];
    for (int i = 0; i < element.length; i++) {
      if (element[i] > 255) {
        element[i] = element[i] - 255;
      }

      gx.add(alpha[element[i]]);
    }

    return gx;
  }
}
