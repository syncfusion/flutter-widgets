// ignore_for_file: no_default_cases

import '../../utils/enum.dart';
import '../../utils/helper.dart';

/// Represents the module value
class ModuleValue {
  /// Creates the module value
  ModuleValue() {
    isBlack = false;
    isFilled = false;
    isPDP = false;
  }

  /// Specifies whether the the dot is black
  late bool isBlack;

  /// Specifies whether the the dot is already filled
  late bool isFilled;

  /// Specifies whether the the dot is PDP
  late bool isPDP;
}

/// Represents the QR Code value
class QRCodeValue {
  /// Creates the QR code value
  QRCodeValue({this.qrCodeVersion, this.errorCorrectionLevel}) {
    noOfDataCodeWord = _getNumberOfDataCodeWord();
    noOfErrorCorrectionCodeWord = _getNumberOfErrorCorrectionCodeWords();
    noOfErrorCorrectionBlocks = _getNumberOfErrorCorrectionBlocks();
    formatInformation = _obtainFormatInformation();
    versionInformation = _obtainVersionInformation();
  }

  /// Specifies the code version
  final QRCodeVersion? qrCodeVersion;

  /// Specifies the error correction level
  final ErrorCorrectionLevel? errorCorrectionLevel;

  /// Specifies the nuber of error correction code words
  static const List<int> _noOfErrorCorrectionCodeWords = <int>[
    7,
    10,
    13,
    17,
    10,
    16,
    22,
    28,
    15,
    26,
    36,
    44,
    20,
    36,
    52,
    64,
    26,
    48,
    72,
    88,
    36,
    64,
    96,
    112,
    40,
    72,
    108,
    130,
    48,
    88,
    132,
    156,
    60,
    110,
    160,
    192,
    72,
    130,
    192,
    224,
    80,
    150,
    224,
    264,
    96,
    176,
    260,
    308,
    104,
    198,
    288,
    352,
    120,
    216,
    320,
    384,
    132,
    240,
    360,
    432,
    144,
    280,
    408,
    480,
    168,
    308,
    448,
    532,
    180,
    338,
    504,
    588,
    196,
    364,
    546,
    650,
    224,
    416,
    600,
    700,
    224,
    442,
    644,
    750,
    252,
    476,
    690,
    816,
    270,
    504,
    750,
    900,
    300,
    560,
    810,
    960,
    312,
    588,
    870,
    1050,
    336,
    644,
    952,
    1110,
    360,
    700,
    1020,
    1200,
    390,
    728,
    1050,
    1260,
    420,
    784,
    1140,
    1350,
    450,
    812,
    1200,
    1440,
    480,
    868,
    1290,
    1530,
    510,
    924,
    1350,
    1620,
    540,
    980,
    1440,
    1710,
    570,
    1036,
    1530,
    1800,
    570,
    1064,
    1590,
    1890,
    600,
    1120,
    1680,
    1980,
    630,
    1204,
    1770,
    2100,
    660,
    1260,
    1860,
    2220,
    720,
    1316,
    1950,
    2310,
    750,
    1372,
    2040,
    2430
  ];

  /// Specifies the value of numeric data capacity of low error correction level
  static const List<int> numericDataCapacityLow = <int>[
    41,
    77,
    127,
    187,
    255,
    322,
    370,
    461,
    552,
    652,
    772,
    883,
    1022,
    1101,
    1250,
    1408,
    1548,
    1725,
    1903,
    2061,
    2232,
    2409,
    2620,
    2812,
    3057,
    3283,
    3517,
    3669,
    3909,
    4158,
    4417,
    4686,
    4965,
    5253,
    5529,
    5836,
    6153,
    6479,
    6743,
    7089,
  ];

  /// Specifies the value of numeric data capacity of medium error
  /// correction level
  static const List<int> numericDataCapacityMedium = <int>[
    34,
    63,
    101,
    149,
    202,
    255,
    293,
    365,
    432,
    513,
    604,
    691,
    796,
    871,
    991,
    1082,
    1212,
    1346,
    1500,
    1600,
    1708,
    1872,
    2059,
    2188,
    2395,
    2544,
    2701,
    2857,
    3035,
    3289,
    3486,
    3693,
    3909,
    4134,
    4343,
    4588,
    4775,
    5039,
    5313,
    5596,
  ];

  /// Specifies the value of numeric data capacity of quartile error
  /// correction level
  static const List<int> numericDataCapacityQuartile = <int>[
    27,
    48,
    77,
    111,
    144,
    178,
    207,
    259,
    312,
    364,
    427,
    489,
    580,
    621,
    703,
    775,
    876,
    948,
    1063,
    1159,
    1224,
    1358,
    1468,
    1588,
    1718,
    1804,
    1933,
    2085,
    2181,
    2358,
    2473,
    2670,
    2805,
    2949,
    3081,
    3244,
    3417,
    3599,
    3791,
    3993,
  ];

  /// Specifies the value of numeric data capacity of high error correction
  /// level
  static const List<int> numericDataCapacityHigh = <int>[
    17,
    34,
    58,
    82,
    106,
    139,
    154,
    202,
    235,
    288,
    331,
    374,
    427,
    468,
    530,
    602,
    674,
    746,
    813,
    919,
    969,
    1056,
    1108,
    1228,
    1286,
    1425,
    1501,
    1581,
    1677,
    1782,
    1897,
    2022,
    2157,
    2301,
    2361,
    2524,
    2625,
    2735,
    2927,
    3057
  ];

  /// Specifies the value of alpha numeric data capacity of low error
  /// correction level
  static const List<int> alphaNumericDataCapacityLow = <int>[
    25,
    47,
    77,
    114,
    154,
    195,
    224,
    279,
    335,
    395,
    468,
    535,
    619,
    667,
    758,
    854,
    938,
    1046,
    1153,
    1249,
    1352,
    1460,
    1588,
    1704,
    1853,
    1990,
    2132,
    2223,
    2369,
    2520,
    2677,
    2840,
    3009,
    3183,
    3351,
    3537,
    3729,
    3927,
    4087,
    4296
  ];

  /// Specifies the value of alpha numeric data capacity of high error
  /// correction level
  static const List<int> alphaNumericDataCapacityMedium = <int>[
    20,
    38,
    61,
    90,
    122,
    154,
    178,
    221,
    262,
    311,
    366,
    419,
    483,
    528,
    600,
    656,
    734,
    816,
    909,
    970,
    1035,
    1134,
    1248,
    1326,
    1451,
    1542,
    1637,
    1732,
    1839,
    1994,
    2113,
    2238,
    2369,
    2506,
    2632,
    2780,
    2894,
    3054,
    3220,
    3391
  ];

  /// Specifies the value of alpha numeric data capacity of quartile error
  /// correction level
  static const List<int> alphaNumericDataCapacityQuartile = <int>[
    16,
    29,
    47,
    67,
    87,
    108,
    125,
    157,
    189,
    221,
    259,
    296,
    352,
    376,
    426,
    470,
    531,
    574,
    644,
    702,
    742,
    823,
    890,
    963,
    1041,
    1094,
    1172,
    1263,
    1322,
    1429,
    1499,
    1618,
    1700,
    1787,
    1867,
    1966,
    2071,
    2181,
    2298,
    2420
  ];

  /// Specifies the value of alpha numeric data capacity of high error
  /// correction level
  static const List<int> alphaNumericDataCapacityHigh = <int>[
    10,
    20,
    35,
    50,
    64,
    84,
    93,
    122,
    143,
    174,
    200,
    227,
    259,
    283,
    321,
    365,
    408,
    452,
    493,
    557,
    587,
    640,
    672,
    744,
    779,
    864,
    910,
    958,
    1016,
    1080,
    1150,
    1226,
    1307,
    1394,
    1431,
    1530,
    1591,
    1658,
    1774,
    1852
  ];

  /// Specifies the value of binary data capacity of low error correction level
  static const List<int> binaryDataCapacityLow = <int>[
    17,
    32,
    53,
    78,
    106,
    134,
    154,
    192,
    230,
    271,
    321,
    367,
    425,
    458,
    520,
    586,
    644,
    718,
    792,
    858,
    929,
    1003,
    1091,
    1171,
    1273,
    1367,
    1465,
    1528,
    1628,
    1732,
    1840,
    1952,
    2068,
    2188,
    2303,
    2431,
    2563,
    2699,
    2809,
    2953
  ];

  /// Specifies the value of binary data capacity of medium error correction
  /// level
  static const List<int> binaryDataCapacityMedium = <int>[
    14,
    26,
    42,
    62,
    84,
    106,
    122,
    152,
    180,
    213,
    251,
    287,
    331,
    362,
    412,
    450,
    504,
    560,
    624,
    666,
    711,
    779,
    857,
    911,
    997,
    1059,
    1125,
    1190,
    1264,
    1370,
    1452,
    1538,
    1628,
    1722,
    1809,
    1911,
    1989,
    2099,
    2213,
    2331
  ];

  /// Specifies the value of binary data capacity of quartile error correction
  /// level
  static const List<int> binaryDataCapacityQuartile = <int>[
    11,
    20,
    32,
    46,
    60,
    74,
    86,
    108,
    130,
    151,
    177,
    203,
    241,
    258,
    292,
    322,
    364,
    394,
    442,
    482,
    509,
    565,
    611,
    661,
    715,
    751,
    805,
    868,
    908,
    982,
    1030,
    1112,
    1168,
    1228,
    1283,
    1351,
    1423,
    1499,
    1579,
    1663
  ];

  /// Specifies the value of binary data capacity of high error correction level
  static const List<int> binaryDataCapacityHigh = <int>[
    7,
    14,
    24,
    34,
    44,
    58,
    64,
    84,
    98,
    119,
    137,
    155,
    177,
    194,
    220,
    250,
    280,
    310,
    338,
    382,
    403,
    439,
    461,
    511,
    535,
    593,
    625,
    658,
    698,
    742,
    790,
    842,
    898,
    958,
    983,
    1051,
    1093,
    1139,
    1219,
    1273
  ];

  /// Returns the numeric data capacity
  static int getNumericDataCapacity(
      ErrorCorrectionLevel level, QRCodeVersion codeVersion) {
    List<int> capacity;
    switch (level) {
      case ErrorCorrectionLevel.low:
        capacity = numericDataCapacityLow;
        break;
      case ErrorCorrectionLevel.medium:
        capacity = numericDataCapacityMedium;
        break;
      case ErrorCorrectionLevel.quartile:
        capacity = numericDataCapacityQuartile;
        break;
      case ErrorCorrectionLevel.high:
        capacity = numericDataCapacityHigh;
        break;
    }

    final int version = getVersionNumber(codeVersion);
    return capacity[version - 1];
  }

  /// Specifies the alpha numeric data capcity
  static int getAlphaNumericDataCapacity(
      ErrorCorrectionLevel level, QRCodeVersion codeVersion) {
    List<int> capacity;
    switch (level) {
      case ErrorCorrectionLevel.low:
        capacity = alphaNumericDataCapacityLow;
        break;
      case ErrorCorrectionLevel.medium:
        capacity = alphaNumericDataCapacityMedium;
        break;
      case ErrorCorrectionLevel.quartile:
        capacity = alphaNumericDataCapacityQuartile;
        break;
      case ErrorCorrectionLevel.high:
        capacity = alphaNumericDataCapacityHigh;
        break;
    }

    // ignore: no_leading_underscores_for_local_identifiers
    final int _version = getVersionNumber(codeVersion);
    return capacity[_version - 1];
  }

  /// Specifies the bunary data capacity
  static int getBinaryDataCapacity(
      ErrorCorrectionLevel level, QRCodeVersion codeVersion) {
    List<int> capacity;
    switch (level) {
      case ErrorCorrectionLevel.low:
        capacity = binaryDataCapacityLow;
        break;
      case ErrorCorrectionLevel.medium:
        capacity = binaryDataCapacityMedium;
        break;
      case ErrorCorrectionLevel.quartile:
        capacity = binaryDataCapacityQuartile;
        break;
      case ErrorCorrectionLevel.high:
        capacity = binaryDataCapacityHigh;
        break;
    }

    final int version = getVersionNumber(codeVersion);
    return capacity[version - 1];
  }

  /// Specifies the number of data code word
  late int noOfDataCodeWord;

  /// Specifies the number of error correction code word
  late int noOfErrorCorrectionCodeWord;

  /// Specifies the number of error correction blocks
  late List<int>? noOfErrorCorrectionBlocks;

  /// Specifies the format information
  late List<int>? formatInformation;

  /// Specifies the version information
  late List<int>? versionInformation;

  /// Returns the alpha numeric value based on provided QR Version
  ///
  /// This is deliberately a very large method. This method could not be
  /// refactor to a smaller methods, since it has single switch condition and
  /// returns the alpha numeric value based on provided QR Version
  int? getAlphaNumericValues(String value) {
    int? valueInInt = 0;
    switch (value) {
      case '0':
        valueInInt = 0;
        break;
      case '1':
        valueInInt = 1;
        break;
      case '2':
        valueInInt = 2;
        break;
      case '3':
        valueInInt = 3;
        break;
      case '4':
        valueInInt = 4;
        break;
      case '5':
        valueInInt = 5;
        break;
      case '6':
        valueInInt = 6;
        break;
      case '7':
        valueInInt = 7;
        break;
      case '8':
        valueInInt = 8;
        break;
      case '9':
        valueInInt = 9;
        break;
      case 'A':
        valueInInt = 10;
        break;
      case 'B':
        valueInInt = 11;
        break;
      case 'C':
        valueInInt = 12;
        break;
      case 'D':
        valueInInt = 13;
        break;
      case 'E':
        valueInInt = 14;
        break;
      case 'F':
        valueInInt = 15;
        break;
      case 'G':
        valueInInt = 16;
        break;
      case 'H':
        valueInInt = 17;
        break;
      case 'I':
        valueInInt = 18;
        break;
      case 'J':
        valueInInt = 19;
        break;
      case 'K':
        valueInInt = 20;
        break;
      case 'L':
        valueInInt = 21;
        break;
      case 'M':
        valueInInt = 22;
        break;
      case 'N':
        valueInInt = 23;
        break;
      case 'O':
        valueInInt = 24;
        break;
      case 'P':
        valueInInt = 25;
        break;
      case 'Q':
        valueInInt = 26;
        break;
      case 'R':
        valueInInt = 27;
        break;
      case 'S':
        valueInInt = 28;
        break;
      case 'T':
        valueInInt = 29;
        break;
      case 'U':
        valueInInt = 30;
        break;
      case 'V':
        valueInInt = 31;
        break;
      case 'W':
        valueInInt = 32;
        break;
      case 'X':
        valueInInt = 33;
        break;
      case 'Y':
        valueInInt = 34;
        break;
      case 'Z':
        valueInInt = 35;
        break;
      case ' ':
        valueInInt = 36;
        break;
      case '\$':
        valueInInt = 37;
        break;
      case '%':
        valueInInt = 38;
        break;
      case '*':
        valueInInt = 39;
        break;
      case '+':
        valueInInt = 40;
        break;
      case '-':
        valueInInt = 41;
        break;
      case '.':
        valueInInt = 42;
        break;
      case '/':
        valueInInt = 43;
        break;
      case ':':
        valueInInt = 44;
        break;
      default:
        valueInInt = null;
        break;
    }

    return valueInInt;
  }

  ///Calculates the number of data code word
  ///
  /// This is deliberately a very large method. This method could not be
  /// refactor to a smaller methods, since it has single switch condition and
  /// returns the number of data code word based on provided QR Version
  int _getNumberOfDataCodeWord() {
    int countOfDataCodeWord = 0;
    switch (qrCodeVersion) {
      case QRCodeVersion.version01:
        countOfDataCodeWord = _getDataCodeWordForVersion01();
        break;
      case QRCodeVersion.version02:
        countOfDataCodeWord = _getDataCodeWordForVersion02();
        break;
      case QRCodeVersion.version03:
        countOfDataCodeWord = _getDataCodeWordForVersion03();
        break;
      case QRCodeVersion.version04:
        countOfDataCodeWord = _getDataCodeWordForVersion04();
        break;
      case QRCodeVersion.version05:
        countOfDataCodeWord = _getDataCodeWordForVersion05();
        break;
      case QRCodeVersion.version06:
        countOfDataCodeWord = _getDataCodeWordForVersion06();
        break;
      case QRCodeVersion.version07:
        countOfDataCodeWord = _getDataCodeWordForVersion07();
        break;
      case QRCodeVersion.version08:
        countOfDataCodeWord = _getDataCodeWordForVersion08();
        break;
      case QRCodeVersion.version09:
        countOfDataCodeWord = _getDataCodeWordForVersion09();
        break;
      case QRCodeVersion.version10:
        countOfDataCodeWord = _getDataCodeWordForVersion10();
        break;
      case QRCodeVersion.version11:
        countOfDataCodeWord = _getDataCodeWordForVersion11();
        break;
      case QRCodeVersion.version12:
        countOfDataCodeWord = _getDataCodeWordForVersion12();
        break;
      case QRCodeVersion.version13:
        countOfDataCodeWord = _getDataCodeWordForVersion13();
        break;
      case QRCodeVersion.version14:
        countOfDataCodeWord = _getDataCodeWordForVersion14();
        break;
      case QRCodeVersion.version15:
        countOfDataCodeWord = _getDataCodeWordForVersion15();
        break;
      case QRCodeVersion.version16:
        countOfDataCodeWord = _getDataCodeWordForVersion16();
        break;
      case QRCodeVersion.version17:
        countOfDataCodeWord = _getDataCodeWordForVersion17();
        break;
      case QRCodeVersion.version18:
        countOfDataCodeWord = _getDataCodeWordForVersion18();
        break;
      case QRCodeVersion.version19:
        countOfDataCodeWord = _getDataCodeWordForVersion19();
        break;
      case QRCodeVersion.version20:
        countOfDataCodeWord = _getDataCodeWordForVersion20();
        break;
      case QRCodeVersion.version21:
        countOfDataCodeWord = _getDataCodeWordForVersion21();
        break;
      case QRCodeVersion.version22:
        countOfDataCodeWord = _getDataCodeWordForVersion22();
        break;
      case QRCodeVersion.version23:
        countOfDataCodeWord = _getDataCodeWordForVersion23();
        break;
      case QRCodeVersion.version24:
        countOfDataCodeWord = _getDataCodeWordForVersion24();
        break;
      case QRCodeVersion.version25:
        countOfDataCodeWord = _getDataCodeWordForVersion25();
        break;
      case QRCodeVersion.version26:
        countOfDataCodeWord = _getDataCodeWordForVersion26();
        break;
      case QRCodeVersion.version27:
        countOfDataCodeWord = _getDataCodeWordForVersion27();
        break;
      case QRCodeVersion.version28:
        countOfDataCodeWord = _getDataCodeWordForVersion28();
        break;
      case QRCodeVersion.version29:
        countOfDataCodeWord = _getDataCodeWordForVersion29();
        break;
      case QRCodeVersion.version30:
        countOfDataCodeWord = _getDataCodeWordForVersion30();
        break;
      case QRCodeVersion.version31:
        countOfDataCodeWord = _getDataCodeWordForVersion31();
        break;
      case QRCodeVersion.version32:
        countOfDataCodeWord = _getDataCodeWordForVersion32();
        break;
      case QRCodeVersion.version33:
        countOfDataCodeWord = _getDataCodeWordForVersion33();
        break;
      case QRCodeVersion.version34:
        countOfDataCodeWord = _getDataCodeWordForVersion34();
        break;
      case QRCodeVersion.version35:
        countOfDataCodeWord = _getDataCodeWordForVersion35();
        break;
      case QRCodeVersion.version36:
        countOfDataCodeWord = _getDataCodeWordForVersion36();
        break;
      case QRCodeVersion.version37:
        countOfDataCodeWord = _getDataCodeWordForVersion37();
        break;
      case QRCodeVersion.version38:
        countOfDataCodeWord = _getDataCodeWordForVersion38();
        break;
      case QRCodeVersion.version39:
        countOfDataCodeWord = _getDataCodeWordForVersion39();
        break;
      case QRCodeVersion.version40:
        countOfDataCodeWord = _getDataCodeWordForVersion40();
        break;
      case QRCodeVersion.auto:
        break;
      default:
        break;
    }

    return countOfDataCodeWord;
  }

  /// Specifies the data code word for version 1
  int _getDataCodeWordForVersion01() {
    int countOfDataCodeWord = 0;
    switch (errorCorrectionLevel) {
      case ErrorCorrectionLevel.low:
        countOfDataCodeWord = 19;
        break;
      case ErrorCorrectionLevel.medium:
        countOfDataCodeWord = 16;
        break;
      case ErrorCorrectionLevel.quartile:
        countOfDataCodeWord = 13;
        break;
      case ErrorCorrectionLevel.high:
        countOfDataCodeWord = 9;
        break;
      default:
        break;
    }

    return countOfDataCodeWord;
  }

  /// Specifies the data code word for version 2
  int _getDataCodeWordForVersion02() {
    int countOfDataCodeWord = 0;
    switch (errorCorrectionLevel) {
      case ErrorCorrectionLevel.low:
        countOfDataCodeWord = 34;
        break;
      case ErrorCorrectionLevel.medium:
        countOfDataCodeWord = 28;
        break;
      case ErrorCorrectionLevel.quartile:
        countOfDataCodeWord = 22;
        break;
      case ErrorCorrectionLevel.high:
        countOfDataCodeWord = 16;
        break;
      default:
        break;
    }

    return countOfDataCodeWord;
  }

  /// Specifies the data code word for version 3
  int _getDataCodeWordForVersion03() {
    int countOfDataCodeWord = 0;
    switch (errorCorrectionLevel) {
      case ErrorCorrectionLevel.low:
        countOfDataCodeWord = 55;
        break;
      case ErrorCorrectionLevel.medium:
        countOfDataCodeWord = 44;
        break;
      case ErrorCorrectionLevel.quartile:
        countOfDataCodeWord = 34;
        break;
      case ErrorCorrectionLevel.high:
        countOfDataCodeWord = 26;
        break;
      default:
        break;
    }

    return countOfDataCodeWord;
  }

  /// Specifies the data code word for version 4
  int _getDataCodeWordForVersion04() {
    int countOfDataCodeWord = 0;
    switch (errorCorrectionLevel) {
      case ErrorCorrectionLevel.low:
        countOfDataCodeWord = 80;
        break;
      case ErrorCorrectionLevel.medium:
        countOfDataCodeWord = 64;
        break;
      case ErrorCorrectionLevel.quartile:
        countOfDataCodeWord = 48;
        break;
      case ErrorCorrectionLevel.high:
        countOfDataCodeWord = 36;
        break;
      default:
        break;
    }

    return countOfDataCodeWord;
  }

  /// Specifies the data code word for version 5
  int _getDataCodeWordForVersion05() {
    int countOfDataCodeWord = 0;
    switch (errorCorrectionLevel) {
      case ErrorCorrectionLevel.low:
        countOfDataCodeWord = 108;
        break;
      case ErrorCorrectionLevel.medium:
        countOfDataCodeWord = 86;
        break;
      case ErrorCorrectionLevel.quartile:
        countOfDataCodeWord = 62;
        break;
      case ErrorCorrectionLevel.high:
        countOfDataCodeWord = 46;
        break;
      default:
        break;
    }

    return countOfDataCodeWord;
  }

  /// Specifies the data code word for version 6
  int _getDataCodeWordForVersion06() {
    int countOfDataCodeWord = 0;
    switch (errorCorrectionLevel) {
      case ErrorCorrectionLevel.low:
        countOfDataCodeWord = 136;
        break;
      case ErrorCorrectionLevel.medium:
        countOfDataCodeWord = 108;
        break;
      case ErrorCorrectionLevel.quartile:
        countOfDataCodeWord = 76;
        break;
      case ErrorCorrectionLevel.high:
        countOfDataCodeWord = 60;
        break;
      default:
        break;
    }

    return countOfDataCodeWord;
  }

  /// Specifies the data code word for version 7
  int _getDataCodeWordForVersion07() {
    int countOfDataCodeWord = 0;
    switch (errorCorrectionLevel) {
      case ErrorCorrectionLevel.low:
        countOfDataCodeWord = 156;
        break;
      case ErrorCorrectionLevel.medium:
        countOfDataCodeWord = 124;
        break;
      case ErrorCorrectionLevel.quartile:
        countOfDataCodeWord = 88;
        break;
      case ErrorCorrectionLevel.high:
        countOfDataCodeWord = 66;
        break;
      default:
        break;
    }

    return countOfDataCodeWord;
  }

  /// Specifies the data code word for version 8
  int _getDataCodeWordForVersion08() {
    int countOfDataCodeWord = 0;
    switch (errorCorrectionLevel) {
      case ErrorCorrectionLevel.low:
        countOfDataCodeWord = 194;
        break;
      case ErrorCorrectionLevel.medium:
        countOfDataCodeWord = 154;
        break;
      case ErrorCorrectionLevel.quartile:
        countOfDataCodeWord = 110;
        break;
      case ErrorCorrectionLevel.high:
        countOfDataCodeWord = 86;
        break;
      default:
        break;
    }

    return countOfDataCodeWord;
  }

  /// Specifies the data code word for version 9
  int _getDataCodeWordForVersion09() {
    int countOfDataCodeWord = 0;
    switch (errorCorrectionLevel) {
      case ErrorCorrectionLevel.low:
        countOfDataCodeWord = 232;
        break;
      case ErrorCorrectionLevel.medium:
        countOfDataCodeWord = 182;
        break;
      case ErrorCorrectionLevel.quartile:
        countOfDataCodeWord = 132;
        break;
      case ErrorCorrectionLevel.high:
        countOfDataCodeWord = 100;
        break;
      default:
        break;
    }

    return countOfDataCodeWord;
  }

  /// Specifies the data code word for version 10
  int _getDataCodeWordForVersion10() {
    int countOfDataCodeWord = 0;
    switch (errorCorrectionLevel) {
      case ErrorCorrectionLevel.low:
        countOfDataCodeWord = 274;
        break;
      case ErrorCorrectionLevel.medium:
        countOfDataCodeWord = 216;
        break;
      case ErrorCorrectionLevel.quartile:
        countOfDataCodeWord = 154;
        break;
      case ErrorCorrectionLevel.high:
        countOfDataCodeWord = 122;
        break;
      default:
        break;
    }

    return countOfDataCodeWord;
  }

  /// Specifies the data code word for version 11
  int _getDataCodeWordForVersion11() {
    int countOfDataCodeWord = 0;
    switch (errorCorrectionLevel) {
      case ErrorCorrectionLevel.low:
        countOfDataCodeWord = 324;
        break;
      case ErrorCorrectionLevel.medium:
        countOfDataCodeWord = 254;
        break;
      case ErrorCorrectionLevel.quartile:
        countOfDataCodeWord = 180;
        break;
      case ErrorCorrectionLevel.high:
        countOfDataCodeWord = 140;
        break;
      default:
        break;
    }

    return countOfDataCodeWord;
  }

  /// Specifies the data code word for version 12
  int _getDataCodeWordForVersion12() {
    int countOfDataCodeWord = 0;
    switch (errorCorrectionLevel) {
      case ErrorCorrectionLevel.low:
        countOfDataCodeWord = 370;
        break;
      case ErrorCorrectionLevel.medium:
        countOfDataCodeWord = 290;
        break;
      case ErrorCorrectionLevel.quartile:
        countOfDataCodeWord = 206;
        break;
      case ErrorCorrectionLevel.high:
        countOfDataCodeWord = 158;
        break;
      default:
        break;
    }

    return countOfDataCodeWord;
  }

  /// Specifies the data code word for version 13
  int _getDataCodeWordForVersion13() {
    int countOfDataCodeWord = 0;
    switch (errorCorrectionLevel) {
      case ErrorCorrectionLevel.low:
        countOfDataCodeWord = 428;
        break;
      case ErrorCorrectionLevel.medium:
        countOfDataCodeWord = 334;
        break;
      case ErrorCorrectionLevel.quartile:
        countOfDataCodeWord = 244;
        break;
      case ErrorCorrectionLevel.high:
        countOfDataCodeWord = 180;
        break;
      default:
        break;
    }

    return countOfDataCodeWord;
  }

  /// Specifies the data code word for version 14
  int _getDataCodeWordForVersion14() {
    int countOfDataCodeWord = 0;
    switch (errorCorrectionLevel) {
      case ErrorCorrectionLevel.low:
        countOfDataCodeWord = 461;
        break;
      case ErrorCorrectionLevel.medium:
        countOfDataCodeWord = 365;
        break;
      case ErrorCorrectionLevel.quartile:
        countOfDataCodeWord = 261;
        break;
      case ErrorCorrectionLevel.high:
        countOfDataCodeWord = 197;
        break;
      default:
        break;
    }

    return countOfDataCodeWord;
  }

  /// Specifies the data code word for version 15
  int _getDataCodeWordForVersion15() {
    int countOfDataCodeWord = 0;
    switch (errorCorrectionLevel) {
      case ErrorCorrectionLevel.low:
        countOfDataCodeWord = 523;
        break;
      case ErrorCorrectionLevel.medium:
        countOfDataCodeWord = 415;
        break;
      case ErrorCorrectionLevel.quartile:
        countOfDataCodeWord = 295;
        break;
      case ErrorCorrectionLevel.high:
        countOfDataCodeWord = 223;
        break;
      default:
        break;
    }

    return countOfDataCodeWord;
  }

  /// Specifies the data code word for version 16
  int _getDataCodeWordForVersion16() {
    int countOfDataCodeWord = 0;
    switch (errorCorrectionLevel) {
      case ErrorCorrectionLevel.low:
        countOfDataCodeWord = 589;
        break;
      case ErrorCorrectionLevel.medium:
        countOfDataCodeWord = 453;
        break;
      case ErrorCorrectionLevel.quartile:
        countOfDataCodeWord = 325;
        break;
      case ErrorCorrectionLevel.high:
        countOfDataCodeWord = 253;
        break;
      default:
        break;
    }

    return countOfDataCodeWord;
  }

  /// Specifies the data code word for version 17
  int _getDataCodeWordForVersion17() {
    int countOfDataCodeWord = 0;
    switch (errorCorrectionLevel) {
      case ErrorCorrectionLevel.low:
        countOfDataCodeWord = 647;
        break;
      case ErrorCorrectionLevel.medium:
        countOfDataCodeWord = 507;
        break;
      case ErrorCorrectionLevel.quartile:
        countOfDataCodeWord = 367;
        break;
      case ErrorCorrectionLevel.high:
        countOfDataCodeWord = 283;
        break;
      default:
        break;
    }

    return countOfDataCodeWord;
  }

  /// Specifies the data code word for version 18
  int _getDataCodeWordForVersion18() {
    int countOfDataCodeWord = 0;
    switch (errorCorrectionLevel) {
      case ErrorCorrectionLevel.low:
        countOfDataCodeWord = 721;
        break;
      case ErrorCorrectionLevel.medium:
        countOfDataCodeWord = 563;
        break;
      case ErrorCorrectionLevel.quartile:
        countOfDataCodeWord = 397;
        break;
      case ErrorCorrectionLevel.high:
        countOfDataCodeWord = 313;
        break;
      default:
        break;
    }

    return countOfDataCodeWord;
  }

  /// Specifies the data code word for version 19
  int _getDataCodeWordForVersion19() {
    int countOfDataCodeWord = 0;
    switch (errorCorrectionLevel) {
      case ErrorCorrectionLevel.low:
        countOfDataCodeWord = 795;
        break;
      case ErrorCorrectionLevel.medium:
        countOfDataCodeWord = 627;
        break;
      case ErrorCorrectionLevel.quartile:
        countOfDataCodeWord = 445;
        break;
      case ErrorCorrectionLevel.high:
        countOfDataCodeWord = 341;
        break;
      default:
        break;
    }

    return countOfDataCodeWord;
  }

  /// Specifies the data code word for version 20
  int _getDataCodeWordForVersion20() {
    int countOfDataCodeWord = 0;
    switch (errorCorrectionLevel) {
      case ErrorCorrectionLevel.low:
        countOfDataCodeWord = 861;
        break;
      case ErrorCorrectionLevel.medium:
        countOfDataCodeWord = 669;
        break;
      case ErrorCorrectionLevel.quartile:
        countOfDataCodeWord = 485;
        break;
      case ErrorCorrectionLevel.high:
        countOfDataCodeWord = 385;
        break;
      default:
        break;
    }

    return countOfDataCodeWord;
  }

  /// Specifies the data code word for version 21
  int _getDataCodeWordForVersion21() {
    int countOfDataCodeWord = 0;
    switch (errorCorrectionLevel) {
      case ErrorCorrectionLevel.low:
        countOfDataCodeWord = 932;
        break;
      case ErrorCorrectionLevel.medium:
        countOfDataCodeWord = 714;
        break;
      case ErrorCorrectionLevel.quartile:
        countOfDataCodeWord = 512;
        break;
      case ErrorCorrectionLevel.high:
        countOfDataCodeWord = 406;
        break;
      default:
        break;
    }

    return countOfDataCodeWord;
  }

  /// Specifies the data code word for version 22
  int _getDataCodeWordForVersion22() {
    int countOfDataCodeWord = 0;
    switch (errorCorrectionLevel) {
      case ErrorCorrectionLevel.low:
        countOfDataCodeWord = 1006;
        break;
      case ErrorCorrectionLevel.medium:
        countOfDataCodeWord = 782;
        break;
      case ErrorCorrectionLevel.quartile:
        countOfDataCodeWord = 568;
        break;
      case ErrorCorrectionLevel.high:
        countOfDataCodeWord = 442;
        break;
      default:
        break;
    }

    return countOfDataCodeWord;
  }

  /// Specifies the data code word for version 23
  int _getDataCodeWordForVersion23() {
    int countOfDataCodeWord = 0;
    switch (errorCorrectionLevel) {
      case ErrorCorrectionLevel.low:
        countOfDataCodeWord = 1094;
        break;
      case ErrorCorrectionLevel.medium:
        countOfDataCodeWord = 860;
        break;
      case ErrorCorrectionLevel.quartile:
        countOfDataCodeWord = 614;
        break;
      case ErrorCorrectionLevel.high:
        countOfDataCodeWord = 464;
        break;
      default:
        break;
    }

    return countOfDataCodeWord;
  }

  /// Specifies the data code word for version 24
  int _getDataCodeWordForVersion24() {
    int countOfDataCodeWord = 0;
    switch (errorCorrectionLevel) {
      case ErrorCorrectionLevel.low:
        countOfDataCodeWord = 1174;
        break;
      case ErrorCorrectionLevel.medium:
        countOfDataCodeWord = 914;
        break;
      case ErrorCorrectionLevel.quartile:
        countOfDataCodeWord = 664;
        break;
      case ErrorCorrectionLevel.high:
        countOfDataCodeWord = 514;
        break;
      default:
        break;
    }

    return countOfDataCodeWord;
  }

  /// Specifies the data code word for version 25
  int _getDataCodeWordForVersion25() {
    int countOfDataCodeWord = 0;
    switch (errorCorrectionLevel) {
      case ErrorCorrectionLevel.low:
        countOfDataCodeWord = 1276;
        break;
      case ErrorCorrectionLevel.medium:
        countOfDataCodeWord = 1000;
        break;
      case ErrorCorrectionLevel.quartile:
        countOfDataCodeWord = 718;
        break;
      case ErrorCorrectionLevel.high:
        countOfDataCodeWord = 538;
        break;
      default:
        break;
    }

    return countOfDataCodeWord;
  }

  /// Specifies the data code word for version 26
  int _getDataCodeWordForVersion26() {
    int countOfDataCodeWord = 0;
    switch (errorCorrectionLevel) {
      case ErrorCorrectionLevel.low:
        countOfDataCodeWord = 1370;
        break;
      case ErrorCorrectionLevel.medium:
        countOfDataCodeWord = 1062;
        break;
      case ErrorCorrectionLevel.quartile:
        countOfDataCodeWord = 754;
        break;
      case ErrorCorrectionLevel.high:
        countOfDataCodeWord = 596;
        break;
      default:
        break;
    }

    return countOfDataCodeWord;
  }

  /// Specifies the data code word for version 27
  int _getDataCodeWordForVersion27() {
    int countOfDataCodeWord = 0;
    switch (errorCorrectionLevel) {
      case ErrorCorrectionLevel.low:
        countOfDataCodeWord = 1468;
        break;
      case ErrorCorrectionLevel.medium:
        countOfDataCodeWord = 1128;
        break;
      case ErrorCorrectionLevel.quartile:
        countOfDataCodeWord = 808;
        break;
      case ErrorCorrectionLevel.high:
        countOfDataCodeWord = 628;
        break;
      default:
        break;
    }

    return countOfDataCodeWord;
  }

  /// Specifies the data code word for version 28
  int _getDataCodeWordForVersion28() {
    int countOfDataCodeWord = 0;
    switch (errorCorrectionLevel) {
      case ErrorCorrectionLevel.low:
        countOfDataCodeWord = 1531;
        break;
      case ErrorCorrectionLevel.medium:
        countOfDataCodeWord = 1193;
        break;
      case ErrorCorrectionLevel.quartile:
        countOfDataCodeWord = 871;
        break;
      case ErrorCorrectionLevel.high:
        countOfDataCodeWord = 661;
        break;
      default:
        break;
    }

    return countOfDataCodeWord;
  }

  /// Specifies the data code word for version 29
  int _getDataCodeWordForVersion29() {
    int countOfDataCodeWord = 0;
    switch (errorCorrectionLevel) {
      case ErrorCorrectionLevel.low:
        countOfDataCodeWord = 1631;
        break;
      case ErrorCorrectionLevel.medium:
        countOfDataCodeWord = 1267;
        break;
      case ErrorCorrectionLevel.quartile:
        countOfDataCodeWord = 911;
        break;
      case ErrorCorrectionLevel.high:
        countOfDataCodeWord = 701;
        break;
      default:
        break;
    }

    return countOfDataCodeWord;
  }

  /// Specifies the data code word for version 30
  int _getDataCodeWordForVersion30() {
    int countOfDataCodeWord = 0;
    switch (errorCorrectionLevel) {
      case ErrorCorrectionLevel.low:
        countOfDataCodeWord = 1735;
        break;
      case ErrorCorrectionLevel.medium:
        countOfDataCodeWord = 1373;
        break;
      case ErrorCorrectionLevel.quartile:
        countOfDataCodeWord = 985;
        break;
      case ErrorCorrectionLevel.high:
        countOfDataCodeWord = 745;
        break;
      default:
        break;
    }

    return countOfDataCodeWord;
  }

  /// Specifies the data code word for version 31
  int _getDataCodeWordForVersion31() {
    int countOfDataCodeWord = 0;
    switch (errorCorrectionLevel) {
      case ErrorCorrectionLevel.low:
        countOfDataCodeWord = 1843;
        break;
      case ErrorCorrectionLevel.medium:
        countOfDataCodeWord = 1455;
        break;
      case ErrorCorrectionLevel.quartile:
        countOfDataCodeWord = 1033;
        break;
      case ErrorCorrectionLevel.high:
        countOfDataCodeWord = 793;
        break;
      default:
        break;
    }

    return countOfDataCodeWord;
  }

  /// Specifies the data code word for version 32
  int _getDataCodeWordForVersion32() {
    int countOfDataCodeWord = 0;
    switch (errorCorrectionLevel) {
      case ErrorCorrectionLevel.low:
        countOfDataCodeWord = 1955;
        break;
      case ErrorCorrectionLevel.medium:
        countOfDataCodeWord = 1541;
        break;
      case ErrorCorrectionLevel.quartile:
        countOfDataCodeWord = 1115;
        break;
      case ErrorCorrectionLevel.high:
        countOfDataCodeWord = 845;
        break;
      default:
        break;
    }

    return countOfDataCodeWord;
  }

  /// Specifies the data code word for version 33
  int _getDataCodeWordForVersion33() {
    int countOfDataCodeWord = 0;
    switch (errorCorrectionLevel) {
      case ErrorCorrectionLevel.low:
        countOfDataCodeWord = 2071;
        break;
      case ErrorCorrectionLevel.medium:
        countOfDataCodeWord = 1631;
        break;
      case ErrorCorrectionLevel.quartile:
        countOfDataCodeWord = 1171;
        break;
      case ErrorCorrectionLevel.high:
        countOfDataCodeWord = 901;
        break;
      default:
        break;
    }

    return countOfDataCodeWord;
  }

  /// Specifies the data code word for version 34
  int _getDataCodeWordForVersion34() {
    int countOfDataCodeWord = 0;
    switch (errorCorrectionLevel) {
      case ErrorCorrectionLevel.low:
        countOfDataCodeWord = 2191;
        break;
      case ErrorCorrectionLevel.medium:
        countOfDataCodeWord = 1725;
        break;
      case ErrorCorrectionLevel.quartile:
        countOfDataCodeWord = 1231;
        break;
      case ErrorCorrectionLevel.high:
        countOfDataCodeWord = 961;
        break;
      default:
        break;
    }

    return countOfDataCodeWord;
  }

  /// Specifies the data code word for version 35
  int _getDataCodeWordForVersion35() {
    int countOfDataCodeWord = 0;
    switch (errorCorrectionLevel) {
      case ErrorCorrectionLevel.low:
        countOfDataCodeWord = 2306;
        break;
      case ErrorCorrectionLevel.medium:
        countOfDataCodeWord = 1812;
        break;
      case ErrorCorrectionLevel.quartile:
        countOfDataCodeWord = 1286;
        break;
      case ErrorCorrectionLevel.high:
        countOfDataCodeWord = 986;
        break;
      default:
        break;
    }

    return countOfDataCodeWord;
  }

  /// Specifies the data code word for version 36
  int _getDataCodeWordForVersion36() {
    int countOfDataCodeWord = 0;
    switch (errorCorrectionLevel) {
      case ErrorCorrectionLevel.low:
        countOfDataCodeWord = 2434;
        break;
      case ErrorCorrectionLevel.medium:
        countOfDataCodeWord = 1914;
        break;
      case ErrorCorrectionLevel.quartile:
        countOfDataCodeWord = 1354;
        break;
      case ErrorCorrectionLevel.high:
        countOfDataCodeWord = 1054;
        break;
      default:
        break;
    }

    return countOfDataCodeWord;
  }

  /// Specifies the data code word for version 37
  int _getDataCodeWordForVersion37() {
    int countOfDataCodeWord = 0;
    switch (errorCorrectionLevel) {
      case ErrorCorrectionLevel.low:
        countOfDataCodeWord = 2566;
        break;
      case ErrorCorrectionLevel.medium:
        countOfDataCodeWord = 1992;
        break;
      case ErrorCorrectionLevel.quartile:
        countOfDataCodeWord = 1426;
        break;
      case ErrorCorrectionLevel.high:
        countOfDataCodeWord = 1096;
        break;
      default:
        break;
    }

    return countOfDataCodeWord;
  }

  /// Specifies the data code word for version 38
  int _getDataCodeWordForVersion38() {
    int countOfDataCodeWord = 0;
    switch (errorCorrectionLevel) {
      case ErrorCorrectionLevel.low:
        countOfDataCodeWord = 2702;
        break;
      case ErrorCorrectionLevel.medium:
        countOfDataCodeWord = 2102;
        break;
      case ErrorCorrectionLevel.quartile:
        countOfDataCodeWord = 1502;
        break;
      case ErrorCorrectionLevel.high:
        countOfDataCodeWord = 1142;
        break;
      default:
        break;
    }

    return countOfDataCodeWord;
  }

  /// Specifies the data code word for version 39
  int _getDataCodeWordForVersion39() {
    int countOfDataCodeWord = 0;
    switch (errorCorrectionLevel) {
      case ErrorCorrectionLevel.low:
        countOfDataCodeWord = 2812;
        break;
      case ErrorCorrectionLevel.medium:
        countOfDataCodeWord = 2216;
        break;
      case ErrorCorrectionLevel.quartile:
        countOfDataCodeWord = 1582;
        break;
      case ErrorCorrectionLevel.high:
        countOfDataCodeWord = 1222;
        break;
      default:
        break;
    }

    return countOfDataCodeWord;
  }

  /// Specifies the data code word for version 40
  int _getDataCodeWordForVersion40() {
    int countOfDataCodeWord = 0;
    switch (errorCorrectionLevel) {
      case ErrorCorrectionLevel.low:
        countOfDataCodeWord = 2956;
        break;
      case ErrorCorrectionLevel.medium:
        countOfDataCodeWord = 2334;
        break;
      case ErrorCorrectionLevel.quartile:
        countOfDataCodeWord = 1666;
        break;
      case ErrorCorrectionLevel.high:
        countOfDataCodeWord = 1276;
        break;
      default:
        break;
    }

    return countOfDataCodeWord;
  }

  /// Calculates the number of error corrcetion code words
  int _getNumberOfErrorCorrectionCodeWords() {
    int index = (getVersionNumber(qrCodeVersion!) - 1) * 4;
    switch (errorCorrectionLevel) {
      case ErrorCorrectionLevel.low:
        index += 0;
        break;
      case ErrorCorrectionLevel.medium:
        index += 1;
        break;
      case ErrorCorrectionLevel.quartile:
        index += 2;
        break;
      case ErrorCorrectionLevel.high:
        index += 3;
        break;
      default:
        break;
    }

    return _noOfErrorCorrectionCodeWords[index];
  }

  /// Specifies the number of error correction blocks
  ///
  /// This is deliberately a very large method. This method could not be
  /// refactored to a smaller methods, since it has single switch condition and
  /// returns the error correction blocks based om the QR code version
  List<int>? _getNumberOfErrorCorrectionBlocks() {
    List<int>? numberOfErrorCorrectionBlocks;
    final int version = getVersionNumber(qrCodeVersion!);
    switch (version) {
      case 1:
      case 2:
        numberOfErrorCorrectionBlocks = <int>[1];
        break;
      case 3:
        numberOfErrorCorrectionBlocks = _getErrorCorrectionBlocksForVersion3();
        break;
      case 4:
        numberOfErrorCorrectionBlocks = _getErrorCorrectionBlocksForVersion4();
        break;
      case 5:
        numberOfErrorCorrectionBlocks = _getErrorCorrectionBlocksForVersion5();
        break;
      case 6:
        numberOfErrorCorrectionBlocks = _getErrorCorrectionBlocksForVersion6();
        break;
      case 7:
        numberOfErrorCorrectionBlocks = _getErrorCorrectionBlocksForVersion7();
        break;
      case 8:
        numberOfErrorCorrectionBlocks = _getErrorCorrectionBlocksForVersion8();
        break;
      case 9:
        numberOfErrorCorrectionBlocks = _getErrorCorrectionBlocksForVersion9();
        break;
      case 10:
        numberOfErrorCorrectionBlocks = _getErrorCorrectionBlocksForVersion10();
        break;
      case 11:
        numberOfErrorCorrectionBlocks = _getErrorCorrectionBlocksForVersion11();
        break;
      case 12:
        numberOfErrorCorrectionBlocks = _getErrorCorrectionBlocksForVersion12();
        break;
      case 13:
        numberOfErrorCorrectionBlocks = _getErrorCorrectionBlocksForVersion13();
        break;
      case 14:
        numberOfErrorCorrectionBlocks = _getErrorCorrectionBlocksForVersion14();
        break;
      case 15:
        numberOfErrorCorrectionBlocks = _getErrorCorrectionBlocksForVersion15();
        break;
      case 16:
        numberOfErrorCorrectionBlocks = _getErrorCorrectionBlocksForVersion16();
        break;
      case 17:
        numberOfErrorCorrectionBlocks = _getErrorCorrectionBlocksForVersion17();
        break;
      case 18:
        numberOfErrorCorrectionBlocks = _getErrorCorrectionBlocksForVersion18();
        break;
      case 19:
        numberOfErrorCorrectionBlocks = _getErrorCorrectionBlocksForVersion19();
        break;
      case 20:
        numberOfErrorCorrectionBlocks = _getErrorCorrectionBlocksForVersion20();
        break;
      case 21:
        numberOfErrorCorrectionBlocks = _getErrorCorrectionBlocksForVersion21();
        break;
      case 22:
        numberOfErrorCorrectionBlocks = _getErrorCorrectionBlocksForVersion22();
        break;
      case 23:
        numberOfErrorCorrectionBlocks = _getErrorCorrectionBlocksForVersion23();
        break;
      case 24:
        numberOfErrorCorrectionBlocks = _getErrorCorrectionBlocksForVersion24();
        break;
      case 25:
        numberOfErrorCorrectionBlocks = _getErrorCorrectionBlocksForVersion25();
        break;
      case 26:
        numberOfErrorCorrectionBlocks = _getErrorCorrectionBlocksForVersion26();
        break;
      case 27:
        numberOfErrorCorrectionBlocks = _getErrorCorrectionBlocksForVersion27();
        break;
      case 28:
        numberOfErrorCorrectionBlocks = _getErrorCorrectionBlocksForVersion28();
        break;
      case 29:
        numberOfErrorCorrectionBlocks = _getErrorCorrectionBlocksForVersion29();
        break;
      case 30:
        numberOfErrorCorrectionBlocks = _getErrorCorrectionBlocksForVersion30();
        break;
      case 31:
        numberOfErrorCorrectionBlocks = _getErrorCorrectionBlocksForVersion31();
        break;
      case 32:
        numberOfErrorCorrectionBlocks = _getErrorCorrectionBlocksForVersion32();
        break;
      case 33:
        numberOfErrorCorrectionBlocks = _getErrorCorrectionBlocksForVersion33();
        break;
      case 34:
        numberOfErrorCorrectionBlocks = _getErrorCorrectionBlocksForVersion34();
        break;
      case 35:
        numberOfErrorCorrectionBlocks = _getErrorCorrectionBlocksForVersion35();
        break;
      case 36:
        numberOfErrorCorrectionBlocks = _getErrorCorrectionBlocksForVersion36();
        break;
      case 37:
        numberOfErrorCorrectionBlocks = _getErrorCorrectionBlocksForVersion37();
        break;
      case 38:
        numberOfErrorCorrectionBlocks = _getErrorCorrectionBlocksForVersion38();
        break;
      case 39:
        numberOfErrorCorrectionBlocks = _getErrorCorrectionBlocksForVersion39();
        break;
      case 40:
        numberOfErrorCorrectionBlocks = _getErrorCorrectionBlocksForVersion40();
        break;
    }

    return numberOfErrorCorrectionBlocks;
  }

  /// Specifies the error correction blocks for version 3
  List<int>? _getErrorCorrectionBlocksForVersion3() {
    List<int>? numberOfErrorCorrectionBlocks;
    switch (errorCorrectionLevel) {
      case ErrorCorrectionLevel.low:
      case ErrorCorrectionLevel.medium:
        numberOfErrorCorrectionBlocks = <int>[1];
        break;
      case ErrorCorrectionLevel.quartile:
      case ErrorCorrectionLevel.high:
        numberOfErrorCorrectionBlocks = <int>[2];
        break;
      default:
        break;
    }

    return numberOfErrorCorrectionBlocks;
  }

  /// Specifies the error correction blocks for version 4
  List<int>? _getErrorCorrectionBlocksForVersion4() {
    List<int>? numberOfErrorCorrectionBlocks;
    switch (errorCorrectionLevel) {
      case ErrorCorrectionLevel.low:
        numberOfErrorCorrectionBlocks = <int>[1];
        break;
      case ErrorCorrectionLevel.medium:
      case ErrorCorrectionLevel.quartile:
        numberOfErrorCorrectionBlocks = <int>[2];
        break;
      case ErrorCorrectionLevel.high:
        numberOfErrorCorrectionBlocks = <int>[4];
        break;
      default:
        break;
    }

    return numberOfErrorCorrectionBlocks;
  }

  /// Specifies the error correction blocks for version 5
  List<int>? _getErrorCorrectionBlocksForVersion5() {
    List<int>? numberOfErrorCorrectionBlocks;
    switch (errorCorrectionLevel) {
      case ErrorCorrectionLevel.low:
        numberOfErrorCorrectionBlocks = <int>[1];
        break;
      case ErrorCorrectionLevel.medium:
        numberOfErrorCorrectionBlocks = <int>[2];
        break;
      case ErrorCorrectionLevel.quartile:
        numberOfErrorCorrectionBlocks = <int>[2, 33, 15, 2, 34, 16];
        break;
      case ErrorCorrectionLevel.high:
        numberOfErrorCorrectionBlocks = <int>[2, 33, 11, 2, 34, 12];
        break;
      default:
        break;
    }

    return numberOfErrorCorrectionBlocks;
  }

  /// Specifies the error correction blocks for version 6
  List<int>? _getErrorCorrectionBlocksForVersion6() {
    List<int>? numberOfErrorCorrectionBlocks;
    switch (errorCorrectionLevel) {
      case ErrorCorrectionLevel.low:
        numberOfErrorCorrectionBlocks = <int>[2];
        break;
      case ErrorCorrectionLevel.medium:
      case ErrorCorrectionLevel.quartile:
      case ErrorCorrectionLevel.high:
        numberOfErrorCorrectionBlocks = <int>[4];
        break;
      default:
        break;
    }

    return numberOfErrorCorrectionBlocks;
  }

  /// Specifies the error correction blocks for version 7
  List<int>? _getErrorCorrectionBlocksForVersion7() {
    List<int>? numberOfErrorCorrectionBlocks;
    switch (errorCorrectionLevel) {
      case ErrorCorrectionLevel.low:
        numberOfErrorCorrectionBlocks = <int>[2];
        break;
      case ErrorCorrectionLevel.medium:
        numberOfErrorCorrectionBlocks = <int>[4];
        break;
      case ErrorCorrectionLevel.quartile:
        numberOfErrorCorrectionBlocks = <int>[2, 32, 14, 4, 33, 15];
        break;
      case ErrorCorrectionLevel.high:
        numberOfErrorCorrectionBlocks = <int>[4, 39, 13, 1, 40, 14];
        break;
      default:
        break;
    }

    return numberOfErrorCorrectionBlocks;
  }

  /// Specifies the error correction blocks for version 8
  List<int>? _getErrorCorrectionBlocksForVersion8() {
    List<int>? numberOfErrorCorrectionBlocks;
    switch (errorCorrectionLevel) {
      case ErrorCorrectionLevel.low:
        numberOfErrorCorrectionBlocks = <int>[2];
        break;
      case ErrorCorrectionLevel.medium:
        numberOfErrorCorrectionBlocks = <int>[2, 60, 38, 2, 61, 39];
        break;
      case ErrorCorrectionLevel.quartile:
        numberOfErrorCorrectionBlocks = <int>[4, 40, 18, 2, 41, 19];
        break;
      case ErrorCorrectionLevel.high:
        numberOfErrorCorrectionBlocks = <int>[4, 40, 14, 2, 41, 15];
        break;
      default:
        break;
    }

    return numberOfErrorCorrectionBlocks;
  }

  /// Specifies the error correction blocks for version 9
  List<int>? _getErrorCorrectionBlocksForVersion9() {
    List<int>? numberOfErrorCorrectionBlocks;
    switch (errorCorrectionLevel) {
      case ErrorCorrectionLevel.low:
        numberOfErrorCorrectionBlocks = <int>[2];
        break;
      case ErrorCorrectionLevel.medium:
        numberOfErrorCorrectionBlocks = <int>[3, 58, 36, 2, 59, 37];
        break;
      case ErrorCorrectionLevel.quartile:
        numberOfErrorCorrectionBlocks = <int>[4, 36, 16, 4, 37, 17];
        break;
      case ErrorCorrectionLevel.high:
        numberOfErrorCorrectionBlocks = <int>[4, 36, 12, 4, 37, 13];
        break;
      default:
        break;
    }

    return numberOfErrorCorrectionBlocks;
  }

  /// Specifies the error correction blocks for version 10
  List<int>? _getErrorCorrectionBlocksForVersion10() {
    List<int>? numberOfErrorCorrectionBlocks;
    switch (errorCorrectionLevel) {
      case ErrorCorrectionLevel.low:
        numberOfErrorCorrectionBlocks = <int>[2, 86, 68, 2, 87, 69];
        break;
      case ErrorCorrectionLevel.medium:
        numberOfErrorCorrectionBlocks = <int>[4, 69, 43, 1, 70, 44];
        break;
      case ErrorCorrectionLevel.quartile:
        numberOfErrorCorrectionBlocks = <int>[6, 43, 19, 2, 44, 20];
        break;
      case ErrorCorrectionLevel.high:
        numberOfErrorCorrectionBlocks = <int>[6, 43, 15, 2, 44, 16];
        break;
      default:
        break;
    }

    return numberOfErrorCorrectionBlocks;
  }

  /// Specifies the error correction blocks for version11
  List<int>? _getErrorCorrectionBlocksForVersion11() {
    List<int>? numberOfErrorCorrectionBlocks;
    switch (errorCorrectionLevel) {
      case ErrorCorrectionLevel.low:
        numberOfErrorCorrectionBlocks = <int>[4];
        break;
      case ErrorCorrectionLevel.medium:
        numberOfErrorCorrectionBlocks = <int>[1, 80, 50, 4, 81, 51];
        break;
      case ErrorCorrectionLevel.quartile:
        numberOfErrorCorrectionBlocks = <int>[4, 50, 22, 4, 51, 23];
        break;
      case ErrorCorrectionLevel.high:
        numberOfErrorCorrectionBlocks = <int>[3, 36, 12, 8, 37, 13];
        break;
      default:
        break;
    }

    return numberOfErrorCorrectionBlocks;
  }

  /// Specifies the error correction blocks for version 12
  List<int>? _getErrorCorrectionBlocksForVersion12() {
    List<int>? numberOfErrorCorrectionBlocks;
    switch (errorCorrectionLevel) {
      case ErrorCorrectionLevel.low:
        numberOfErrorCorrectionBlocks = <int>[2, 116, 92, 2, 117, 93];
        break;
      case ErrorCorrectionLevel.medium:
        numberOfErrorCorrectionBlocks = <int>[6, 58, 36, 2, 59, 37];
        break;
      case ErrorCorrectionLevel.quartile:
        numberOfErrorCorrectionBlocks = <int>[4, 46, 20, 6, 47, 21];
        break;
      case ErrorCorrectionLevel.high:
        numberOfErrorCorrectionBlocks = <int>[7, 42, 14, 4, 43, 15];
        break;
      default:
        break;
    }

    return numberOfErrorCorrectionBlocks;
  }

  /// Specifies the error correction blocks for version 13
  List<int>? _getErrorCorrectionBlocksForVersion13() {
    List<int>? numberOfErrorCorrectionBlocks;
    switch (errorCorrectionLevel) {
      case ErrorCorrectionLevel.low:
        numberOfErrorCorrectionBlocks = <int>[4];
        break;
      case ErrorCorrectionLevel.medium:
        numberOfErrorCorrectionBlocks = <int>[8, 59, 37, 1, 60, 38];
        break;
      case ErrorCorrectionLevel.quartile:
        numberOfErrorCorrectionBlocks = <int>[8, 44, 20, 4, 45, 21];
        break;
      case ErrorCorrectionLevel.high:
        numberOfErrorCorrectionBlocks = <int>[12, 33, 11, 4, 34, 12];
        break;
      default:
        break;
    }

    return numberOfErrorCorrectionBlocks;
  }

  /// Specifies the error correction blocks for version 14
  List<int>? _getErrorCorrectionBlocksForVersion14() {
    List<int>? numberOfErrorCorrectionBlocks;
    switch (errorCorrectionLevel) {
      case ErrorCorrectionLevel.low:
        numberOfErrorCorrectionBlocks = <int>[3, 145, 115, 1, 146, 116];
        break;
      case ErrorCorrectionLevel.medium:
        numberOfErrorCorrectionBlocks = <int>[4, 64, 40, 5, 65, 41];
        break;
      case ErrorCorrectionLevel.quartile:
        numberOfErrorCorrectionBlocks = <int>[11, 36, 16, 5, 37, 17];
        break;
      case ErrorCorrectionLevel.high:
        numberOfErrorCorrectionBlocks = <int>[11, 36, 12, 5, 37, 13];
        break;
      default:
        break;
    }

    return numberOfErrorCorrectionBlocks;
  }

  /// Specifies the error correction blocks for version 15
  List<int>? _getErrorCorrectionBlocksForVersion15() {
    List<int>? numberOfErrorCorrectionBlocks;
    switch (errorCorrectionLevel) {
      case ErrorCorrectionLevel.low:
        numberOfErrorCorrectionBlocks = <int>[5, 109, 87, 1, 110, 88];
        break;
      case ErrorCorrectionLevel.medium:
        numberOfErrorCorrectionBlocks = <int>[5, 65, 41, 5, 66, 42];
        break;
      case ErrorCorrectionLevel.quartile:
        numberOfErrorCorrectionBlocks = <int>[5, 54, 24, 7, 55, 25];
        break;
      case ErrorCorrectionLevel.high:
        numberOfErrorCorrectionBlocks = <int>[11, 36, 12, 7, 37, 13];
        break;
      default:
        break;
    }

    return numberOfErrorCorrectionBlocks;
  }

  /// Specifies the error correction blocks for version 16
  List<int>? _getErrorCorrectionBlocksForVersion16() {
    List<int>? numberOfErrorCorrectionBlocks;
    switch (errorCorrectionLevel) {
      case ErrorCorrectionLevel.low:
        numberOfErrorCorrectionBlocks = <int>[5, 112, 98, 1, 123, 99];
        break;
      case ErrorCorrectionLevel.medium:
        numberOfErrorCorrectionBlocks = <int>[7, 73, 45, 3, 74, 46];
        break;
      case ErrorCorrectionLevel.quartile:
        numberOfErrorCorrectionBlocks = <int>[15, 43, 19, 2, 44, 20];
        break;
      case ErrorCorrectionLevel.high:
        numberOfErrorCorrectionBlocks = <int>[3, 45, 15, 13, 46, 16];
        break;
      default:
        break;
    }

    return numberOfErrorCorrectionBlocks;
  }

  /// Specifies the error correction blocks for version 17
  List<int>? _getErrorCorrectionBlocksForVersion17() {
    List<int>? numberOfErrorCorrectionBlocks;
    switch (errorCorrectionLevel) {
      case ErrorCorrectionLevel.low:
        numberOfErrorCorrectionBlocks = <int>[1, 135, 107, 5, 136, 108];
        break;
      case ErrorCorrectionLevel.medium:
        numberOfErrorCorrectionBlocks = <int>[10, 74, 46, 1, 75, 47];
        break;
      case ErrorCorrectionLevel.quartile:
        numberOfErrorCorrectionBlocks = <int>[1, 50, 22, 15, 51, 23];
        break;
      case ErrorCorrectionLevel.high:
        numberOfErrorCorrectionBlocks = <int>[2, 42, 14, 17, 43, 15];
        break;
      default:
        break;
    }

    return numberOfErrorCorrectionBlocks;
  }

  /// Specifies the error correction blocks for version 18
  List<int>? _getErrorCorrectionBlocksForVersion18() {
    List<int>? numberOfErrorCorrectionBlocks;
    switch (errorCorrectionLevel) {
      case ErrorCorrectionLevel.low:
        numberOfErrorCorrectionBlocks = <int>[5, 150, 120, 1, 151, 121];
        break;
      case ErrorCorrectionLevel.medium:
        numberOfErrorCorrectionBlocks = <int>[9, 69, 43, 4, 70, 44];
        break;
      case ErrorCorrectionLevel.quartile:
        numberOfErrorCorrectionBlocks = <int>[17, 50, 22, 1, 51, 23];
        break;
      case ErrorCorrectionLevel.high:
        numberOfErrorCorrectionBlocks = <int>[2, 42, 14, 19, 43, 15];
        break;
      default:
        break;
    }

    return numberOfErrorCorrectionBlocks;
  }

  /// Specifies the error correction blocks for version 19
  List<int>? _getErrorCorrectionBlocksForVersion19() {
    List<int>? numberOfErrorCorrectionBlocks;
    switch (errorCorrectionLevel) {
      case ErrorCorrectionLevel.low:
        numberOfErrorCorrectionBlocks = <int>[3, 141, 113, 4, 142, 114];
        break;
      case ErrorCorrectionLevel.medium:
        numberOfErrorCorrectionBlocks = <int>[3, 70, 44, 11, 71, 45];
        break;
      case ErrorCorrectionLevel.quartile:
        numberOfErrorCorrectionBlocks = <int>[17, 47, 21, 4, 48, 22];
        break;
      case ErrorCorrectionLevel.high:
        numberOfErrorCorrectionBlocks = <int>[9, 39, 13, 16, 40, 14];
        break;
      default:
        break;
    }

    return numberOfErrorCorrectionBlocks;
  }

  /// Specifies the error correction blocks for version 20
  List<int>? _getErrorCorrectionBlocksForVersion20() {
    List<int>? numberOfErrorCorrectionBlocks;
    switch (errorCorrectionLevel) {
      case ErrorCorrectionLevel.low:
        numberOfErrorCorrectionBlocks = <int>[3, 135, 107, 5, 136, 108];
        break;
      case ErrorCorrectionLevel.medium:
        numberOfErrorCorrectionBlocks = <int>[3, 67, 41, 13, 68, 42];
        break;
      case ErrorCorrectionLevel.quartile:
        numberOfErrorCorrectionBlocks = <int>[15, 54, 24, 5, 55, 25];
        break;
      case ErrorCorrectionLevel.high:
        numberOfErrorCorrectionBlocks = <int>[15, 43, 15, 10, 44, 16];
        break;
      default:
        break;
    }

    return numberOfErrorCorrectionBlocks;
  }

  ///Specifies the error correction blocks for version 21
  List<int>? _getErrorCorrectionBlocksForVersion21() {
    List<int>? numberOfErrorCorrectionBlocks;
    switch (errorCorrectionLevel) {
      case ErrorCorrectionLevel.low:
        numberOfErrorCorrectionBlocks = <int>[4, 144, 116, 4, 145, 117];
        break;
      case ErrorCorrectionLevel.medium:
        numberOfErrorCorrectionBlocks = <int>[17];
        break;
      case ErrorCorrectionLevel.quartile:
        numberOfErrorCorrectionBlocks = <int>[17, 50, 22, 6, 51, 23];
        break;
      case ErrorCorrectionLevel.high:
        numberOfErrorCorrectionBlocks = <int>[19, 46, 16, 6, 47, 17];
        break;
      default:
        break;
    }

    return numberOfErrorCorrectionBlocks;
  }

  ///Specifies the error correction blocks for version 22
  List<int>? _getErrorCorrectionBlocksForVersion22() {
    List<int>? numberOfErrorCorrectionBlocks;
    switch (errorCorrectionLevel) {
      case ErrorCorrectionLevel.low:
        numberOfErrorCorrectionBlocks = <int>[2, 139, 111, 7, 140, 112];
        break;
      case ErrorCorrectionLevel.medium:
        numberOfErrorCorrectionBlocks = <int>[17];
        break;
      case ErrorCorrectionLevel.quartile:
        numberOfErrorCorrectionBlocks = <int>[7, 54, 24, 16, 55, 25];
        break;
      case ErrorCorrectionLevel.high:
        numberOfErrorCorrectionBlocks = <int>[34];
        break;
      default:
        break;
    }

    return numberOfErrorCorrectionBlocks;
  }

  ///Specifies the error correction blocks for version 23
  List<int>? _getErrorCorrectionBlocksForVersion23() {
    List<int>? numberOfErrorCorrectionBlocks;
    switch (errorCorrectionLevel) {
      case ErrorCorrectionLevel.low:
        numberOfErrorCorrectionBlocks = <int>[4, 151, 121, 5, 152, 122];
        break;
      case ErrorCorrectionLevel.medium:
        numberOfErrorCorrectionBlocks = <int>[4, 75, 47, 14, 76, 48];
        break;
      case ErrorCorrectionLevel.quartile:
        numberOfErrorCorrectionBlocks = <int>[11, 54, 24, 14, 55, 25];
        break;
      case ErrorCorrectionLevel.high:
        numberOfErrorCorrectionBlocks = <int>[16, 45, 15, 14, 46, 16];
        break;
      default:
        break;
    }

    return numberOfErrorCorrectionBlocks;
  }

  ///Specifies the error correction blocks for version 24
  List<int>? _getErrorCorrectionBlocksForVersion24() {
    List<int>? numberOfErrorCorrectionBlocks;
    switch (errorCorrectionLevel) {
      case ErrorCorrectionLevel.low:
        numberOfErrorCorrectionBlocks = <int>[6, 147, 117, 4, 148, 118];
        break;
      case ErrorCorrectionLevel.medium:
        numberOfErrorCorrectionBlocks = <int>[6, 73, 45, 14, 74, 46];
        break;
      case ErrorCorrectionLevel.quartile:
        numberOfErrorCorrectionBlocks = <int>[11, 54, 24, 16, 55, 25];
        break;
      case ErrorCorrectionLevel.high:
        numberOfErrorCorrectionBlocks = <int>[30, 46, 16, 2, 47, 17];
        break;
      default:
        break;
    }

    return numberOfErrorCorrectionBlocks;
  }

  ///Specifies the error correction blocks for version 25
  List<int>? _getErrorCorrectionBlocksForVersion25() {
    List<int>? numberOfErrorCorrectionBlocks;
    switch (errorCorrectionLevel) {
      case ErrorCorrectionLevel.low:
        numberOfErrorCorrectionBlocks = <int>[8, 132, 106, 4, 133, 107];
        break;
      case ErrorCorrectionLevel.medium:
        numberOfErrorCorrectionBlocks = <int>[8, 75, 47, 13, 76, 48];
        break;
      case ErrorCorrectionLevel.quartile:
        numberOfErrorCorrectionBlocks = <int>[7, 54, 24, 22, 55, 25];
        break;
      case ErrorCorrectionLevel.high:
        numberOfErrorCorrectionBlocks = <int>[22, 45, 15, 13, 46, 16];
        break;
      default:
        break;
    }

    return numberOfErrorCorrectionBlocks;
  }

  ///Specifies the error correction blocks for version 26
  List<int>? _getErrorCorrectionBlocksForVersion26() {
    List<int>? numberOfErrorCorrectionBlocks;
    switch (errorCorrectionLevel) {
      case ErrorCorrectionLevel.low:
        numberOfErrorCorrectionBlocks = <int>[10, 142, 114, 2, 143, 115];
        break;
      case ErrorCorrectionLevel.medium:
        numberOfErrorCorrectionBlocks = <int>[19, 74, 46, 4, 75, 47];
        break;
      case ErrorCorrectionLevel.quartile:
        numberOfErrorCorrectionBlocks = <int>[28, 50, 22, 6, 51, 23];
        break;
      case ErrorCorrectionLevel.high:
        numberOfErrorCorrectionBlocks = <int>[33, 46, 16, 4, 47, 17];
        break;
      default:
        break;
    }

    return numberOfErrorCorrectionBlocks;
  }

  ///Specifies the error correction blocks for version 27
  List<int>? _getErrorCorrectionBlocksForVersion27() {
    List<int>? numberOfErrorCorrectionBlocks;
    switch (errorCorrectionLevel) {
      case ErrorCorrectionLevel.low:
        numberOfErrorCorrectionBlocks = <int>[8, 152, 122, 4, 153, 123];
        break;
      case ErrorCorrectionLevel.medium:
        numberOfErrorCorrectionBlocks = <int>[22, 73, 45, 3, 74, 46];
        break;
      case ErrorCorrectionLevel.quartile:
        numberOfErrorCorrectionBlocks = <int>[8, 53, 23, 26, 54, 24];
        break;
      case ErrorCorrectionLevel.high:
        numberOfErrorCorrectionBlocks = <int>[12, 45, 15, 28, 46, 16];
        break;
      default:
        break;
    }

    return numberOfErrorCorrectionBlocks;
  }

  ///Specifies the error correction blocks for version 28
  List<int>? _getErrorCorrectionBlocksForVersion28() {
    List<int>? numberOfErrorCorrectionBlocks;
    switch (errorCorrectionLevel) {
      case ErrorCorrectionLevel.low:
        numberOfErrorCorrectionBlocks = <int>[3, 147, 117, 10, 148, 118];
        break;
      case ErrorCorrectionLevel.medium:
        numberOfErrorCorrectionBlocks = <int>[3, 73, 45, 23, 74, 46];
        break;
      case ErrorCorrectionLevel.quartile:
        numberOfErrorCorrectionBlocks = <int>[4, 54, 24, 31, 55, 25];
        break;
      case ErrorCorrectionLevel.high:
        numberOfErrorCorrectionBlocks = <int>[11, 45, 15, 31, 46, 16];
        break;
      default:
        break;
    }

    return numberOfErrorCorrectionBlocks;
  }

  ///Specifies the error correction blocks for version 29
  List<int>? _getErrorCorrectionBlocksForVersion29() {
    List<int>? numberOfErrorCorrectionBlocks;
    switch (errorCorrectionLevel) {
      case ErrorCorrectionLevel.low:
        numberOfErrorCorrectionBlocks = <int>[7, 146, 116, 7, 147, 117];
        break;
      case ErrorCorrectionLevel.medium:
        numberOfErrorCorrectionBlocks = <int>[21, 73, 45, 7, 74, 46];
        break;
      case ErrorCorrectionLevel.quartile:
        numberOfErrorCorrectionBlocks = <int>[1, 53, 23, 37, 54, 24];
        break;
      case ErrorCorrectionLevel.high:
        numberOfErrorCorrectionBlocks = <int>[19, 45, 15, 26, 46, 16];
        break;
      default:
        break;
    }

    return numberOfErrorCorrectionBlocks;
  }

  ///Specifies the error correction blocks for version 30
  List<int>? _getErrorCorrectionBlocksForVersion30() {
    List<int>? numberOfErrorCorrectionBlocks;
    switch (errorCorrectionLevel) {
      case ErrorCorrectionLevel.low:
        numberOfErrorCorrectionBlocks = <int>[5, 145, 115, 10, 146, 116];
        break;
      case ErrorCorrectionLevel.medium:
        numberOfErrorCorrectionBlocks = <int>[19, 75, 47, 10, 76, 48];
        break;
      case ErrorCorrectionLevel.quartile:
        numberOfErrorCorrectionBlocks = <int>[15, 54, 24, 25, 55, 25];
        break;
      case ErrorCorrectionLevel.high:
        numberOfErrorCorrectionBlocks = <int>[23, 45, 15, 25, 46, 16];
        break;
      default:
        break;
    }

    return numberOfErrorCorrectionBlocks;
  }

  ///Specifies the error correction blocks for version 31
  List<int>? _getErrorCorrectionBlocksForVersion31() {
    List<int>? numberOfErrorCorrectionBlocks;
    switch (errorCorrectionLevel) {
      case ErrorCorrectionLevel.low:
        numberOfErrorCorrectionBlocks = <int>[13, 145, 115, 3, 146, 116];
        break;
      case ErrorCorrectionLevel.medium:
        numberOfErrorCorrectionBlocks = <int>[2, 74, 46, 29, 75, 47];
        break;
      case ErrorCorrectionLevel.quartile:
        numberOfErrorCorrectionBlocks = <int>[42, 54, 24, 1, 55, 25];
        break;
      case ErrorCorrectionLevel.high:
        numberOfErrorCorrectionBlocks = <int>[23, 45, 15, 28, 46, 16];
        break;
      default:
        break;
    }

    return numberOfErrorCorrectionBlocks;
  }

  ///Specifies the error correction blocks for version 32
  List<int>? _getErrorCorrectionBlocksForVersion32() {
    List<int>? numberOfErrorCorrectionBlocks;
    switch (errorCorrectionLevel) {
      case ErrorCorrectionLevel.low:
        numberOfErrorCorrectionBlocks = <int>[17];
        break;
      case ErrorCorrectionLevel.medium:
        numberOfErrorCorrectionBlocks = <int>[10, 74, 46, 23, 75, 47];
        break;
      case ErrorCorrectionLevel.quartile:
        numberOfErrorCorrectionBlocks = <int>[10, 54, 24, 35, 55, 25];
        break;
      case ErrorCorrectionLevel.high:
        numberOfErrorCorrectionBlocks = <int>[19, 45, 15, 35, 46, 16];
        break;
      default:
        break;
    }

    return numberOfErrorCorrectionBlocks;
  }

  ///Specifies the error correction blocks for version 33
  List<int>? _getErrorCorrectionBlocksForVersion33() {
    List<int>? numberOfErrorCorrectionBlocks;
    switch (errorCorrectionLevel) {
      case ErrorCorrectionLevel.low:
        numberOfErrorCorrectionBlocks = <int>[17, 145, 115, 1, 146, 116];
        break;
      case ErrorCorrectionLevel.medium:
        numberOfErrorCorrectionBlocks = <int>[14, 74, 46, 21, 75, 47];
        break;
      case ErrorCorrectionLevel.quartile:
        numberOfErrorCorrectionBlocks = <int>[29, 54, 24, 19, 55, 25];
        break;
      case ErrorCorrectionLevel.high:
        numberOfErrorCorrectionBlocks = <int>[11, 45, 15, 46, 46, 16];
        break;
      default:
        break;
    }

    return numberOfErrorCorrectionBlocks;
  }

  ///Specifies the error correction blocks for version 34
  List<int>? _getErrorCorrectionBlocksForVersion34() {
    List<int>? numberOfErrorCorrectionBlocks;
    switch (errorCorrectionLevel) {
      case ErrorCorrectionLevel.low:
        numberOfErrorCorrectionBlocks = <int>[13, 145, 115, 6, 146, 116];
        break;
      case ErrorCorrectionLevel.medium:
        numberOfErrorCorrectionBlocks = <int>[14, 74, 46, 23, 75, 47];
        break;
      case ErrorCorrectionLevel.quartile:
        numberOfErrorCorrectionBlocks = <int>[44, 54, 24, 7, 55, 25];
        break;
      case ErrorCorrectionLevel.high:
        numberOfErrorCorrectionBlocks = <int>[59, 46, 16, 1, 47, 17];
        break;
      default:
        break;
    }

    return numberOfErrorCorrectionBlocks;
  }

  ///Specifies the error correction blocks for version 35
  List<int>? _getErrorCorrectionBlocksForVersion35() {
    List<int>? numberOfErrorCorrectionBlocks;
    switch (errorCorrectionLevel) {
      case ErrorCorrectionLevel.low:
        numberOfErrorCorrectionBlocks = <int>[12, 151, 121, 7, 152, 122];
        break;
      case ErrorCorrectionLevel.medium:
        numberOfErrorCorrectionBlocks = <int>[12, 75, 47, 26, 76, 48];
        break;
      case ErrorCorrectionLevel.quartile:
        numberOfErrorCorrectionBlocks = <int>[39, 54, 24, 14, 55, 25];
        break;
      case ErrorCorrectionLevel.high:
        numberOfErrorCorrectionBlocks = <int>[22, 45, 15, 41, 46, 16];
        break;
      default:
        break;
    }

    return numberOfErrorCorrectionBlocks;
  }

  ///Specifies the error correction blocks for version 36
  List<int>? _getErrorCorrectionBlocksForVersion36() {
    List<int>? numberOfErrorCorrectionBlocks;
    switch (errorCorrectionLevel) {
      case ErrorCorrectionLevel.low:
        numberOfErrorCorrectionBlocks = <int>[6, 151, 121, 14, 152, 122];
        break;
      case ErrorCorrectionLevel.medium:
        numberOfErrorCorrectionBlocks = <int>[6, 75, 47, 34, 76, 48];
        break;
      case ErrorCorrectionLevel.quartile:
        numberOfErrorCorrectionBlocks = <int>[46, 54, 24, 10, 55, 25];
        break;
      case ErrorCorrectionLevel.high:
        numberOfErrorCorrectionBlocks = <int>[2, 45, 15, 64, 46, 16];
        break;
      default:
        break;
    }

    return numberOfErrorCorrectionBlocks;
  }

  ///Specifies the error correction blocks for version 37
  List<int>? _getErrorCorrectionBlocksForVersion37() {
    List<int>? numberOfErrorCorrectionBlocks;
    switch (errorCorrectionLevel) {
      case ErrorCorrectionLevel.low:
        numberOfErrorCorrectionBlocks = <int>[17, 152, 122, 4, 153, 123];
        break;
      case ErrorCorrectionLevel.medium:
        numberOfErrorCorrectionBlocks = <int>[29, 74, 46, 14, 75, 47];
        break;
      case ErrorCorrectionLevel.quartile:
        numberOfErrorCorrectionBlocks = <int>[49, 54, 24, 10, 55, 25];
        break;
      case ErrorCorrectionLevel.high:
        numberOfErrorCorrectionBlocks = <int>[24, 45, 15, 46, 46, 16];
        break;
      default:
        break;
    }

    return numberOfErrorCorrectionBlocks;
  }

  ///Specifies the error correction blocks for version 38
  List<int>? _getErrorCorrectionBlocksForVersion38() {
    List<int>? numberOfErrorCorrectionBlocks;
    switch (errorCorrectionLevel) {
      case ErrorCorrectionLevel.low:
        numberOfErrorCorrectionBlocks = <int>[4, 152, 122, 18, 153, 123];
        break;
      case ErrorCorrectionLevel.medium:
        numberOfErrorCorrectionBlocks = <int>[13, 74, 46, 32, 75, 47];
        break;
      case ErrorCorrectionLevel.quartile:
        numberOfErrorCorrectionBlocks = <int>[48, 54, 24, 14, 55, 25];
        break;
      case ErrorCorrectionLevel.high:
        numberOfErrorCorrectionBlocks = <int>[42, 45, 15, 32, 46, 16];
        break;
      default:
        break;
    }

    return numberOfErrorCorrectionBlocks;
  }

  ///Specifies the error correction blocks for version 39
  List<int>? _getErrorCorrectionBlocksForVersion39() {
    List<int>? numberOfErrorCorrectionBlocks;
    switch (errorCorrectionLevel) {
      case ErrorCorrectionLevel.low:
        numberOfErrorCorrectionBlocks = <int>[20, 147, 117, 4, 148, 118];
        break;
      case ErrorCorrectionLevel.medium:
        numberOfErrorCorrectionBlocks = <int>[40, 75, 47, 7, 76, 48];
        break;
      case ErrorCorrectionLevel.quartile:
        numberOfErrorCorrectionBlocks = <int>[43, 54, 24, 22, 55, 25];
        break;
      case ErrorCorrectionLevel.high:
        numberOfErrorCorrectionBlocks = <int>[10, 45, 15, 67, 46, 16];
        break;
      default:
        break;
    }

    return numberOfErrorCorrectionBlocks;
  }

  ///Specifies the error correction blocks for version 40
  List<int>? _getErrorCorrectionBlocksForVersion40() {
    List<int>? numberOfErrorCorrectionBlocks;
    switch (errorCorrectionLevel) {
      case ErrorCorrectionLevel.low:
        numberOfErrorCorrectionBlocks = <int>[19, 148, 118, 6, 149, 119];
        break;
      case ErrorCorrectionLevel.medium:
        numberOfErrorCorrectionBlocks = <int>[18, 75, 47, 31, 76, 48];
        break;
      case ErrorCorrectionLevel.quartile:
        numberOfErrorCorrectionBlocks = <int>[34, 54, 24, 34, 55, 25];
        break;
      case ErrorCorrectionLevel.high:
        numberOfErrorCorrectionBlocks = <int>[20, 45, 15, 61, 46, 16];
        break;
      default:
        break;
    }

    return numberOfErrorCorrectionBlocks;
  }

  /// Specifies the version information
  ///
  /// This is deliberately a very large method. This method could not be
  /// refactored to a smaller methods, since it has single switch condition and
  /// returns the version information
  List<int>? _obtainVersionInformation() {
    List<int>? versionInformation;
    final int version = getVersionNumber(qrCodeVersion!);
    switch (version) {
      case 7:
        versionInformation = <int>[
          0,
          0,
          1,
          0,
          1,
          0,
          0,
          1,
          0,
          0,
          1,
          1,
          1,
          1,
          1,
          0,
          0,
          0
        ];
        break;
      case 8:
        versionInformation = <int>[
          0,
          0,
          1,
          1,
          1,
          1,
          0,
          1,
          1,
          0,
          1,
          0,
          0,
          0,
          0,
          1,
          0,
          0
        ];
        break;
      case 9:
        versionInformation = <int>[
          1,
          0,
          0,
          1,
          1,
          0,
          0,
          1,
          0,
          1,
          0,
          1,
          1,
          0,
          0,
          1,
          0,
          0
        ];
        break;
      case 10:
        versionInformation = <int>[
          1,
          1,
          0,
          0,
          1,
          0,
          1,
          1,
          0,
          0,
          1,
          0,
          0,
          1,
          0,
          1,
          0,
          0
        ];
        break;
      case 11:
        versionInformation = <int>[
          0,
          1,
          1,
          0,
          1,
          1,
          1,
          1,
          1,
          1,
          0,
          1,
          1,
          1,
          0,
          1,
          0,
          0
        ];
        break;
      case 12:
        versionInformation = <int>[
          0,
          1,
          0,
          0,
          0,
          1,
          1,
          0,
          1,
          1,
          1,
          0,
          0,
          0,
          1,
          1,
          0,
          0
        ];
        break;
      case 13:
        versionInformation = <int>[
          1,
          1,
          1,
          0,
          0,
          0,
          1,
          0,
          0,
          0,
          0,
          1,
          1,
          0,
          1,
          1,
          0,
          0
        ];
        break;
      case 14:
        versionInformation = <int>[
          1,
          0,
          1,
          1,
          0,
          0,
          0,
          0,
          0,
          1,
          1,
          0,
          0,
          1,
          1,
          1,
          0,
          0
        ];
        break;
      case 15:
        versionInformation = <int>[
          0,
          0,
          0,
          1,
          0,
          1,
          0,
          0,
          1,
          0,
          0,
          1,
          1,
          1,
          1,
          1,
          0,
          0
        ];
        break;
      case 16:
        versionInformation = <int>[
          0,
          0,
          0,
          1,
          1,
          1,
          1,
          0,
          1,
          1,
          0,
          1,
          0,
          0,
          0,
          0,
          1,
          0
        ];
        break;
      case 17:
        versionInformation = <int>[
          1,
          0,
          1,
          1,
          1,
          0,
          1,
          0,
          0,
          0,
          1,
          0,
          1,
          0,
          0,
          0,
          1,
          0
        ];
        break;
      case 18:
        versionInformation = <int>[
          1,
          1,
          1,
          0,
          1,
          0,
          0,
          0,
          0,
          1,
          0,
          1,
          0,
          1,
          0,
          0,
          1,
          0
        ];
        break;
      case 19:
        versionInformation = <int>[
          0,
          1,
          0,
          0,
          1,
          1,
          0,
          0,
          1,
          0,
          1,
          0,
          1,
          1,
          0,
          0,
          1,
          0
        ];
        break;
      case 20:
        versionInformation = <int>[
          0,
          1,
          1,
          0,
          0,
          1,
          0,
          1,
          1,
          0,
          0,
          1,
          0,
          0,
          1,
          0,
          1,
          0
        ];
        break;
      case 21:
        versionInformation = <int>[
          1,
          1,
          0,
          0,
          0,
          0,
          0,
          1,
          0,
          1,
          1,
          0,
          1,
          0,
          1,
          0,
          1,
          0
        ];
        break;
      case 22:
        versionInformation = <int>[
          1,
          0,
          0,
          1,
          0,
          0,
          1,
          1,
          0,
          0,
          0,
          1,
          0,
          1,
          1,
          0,
          1,
          0
        ];
        break;
      case 23:
        versionInformation = <int>[
          0,
          0,
          1,
          1,
          0,
          1,
          1,
          1,
          1,
          1,
          1,
          0,
          1,
          1,
          1,
          0,
          1,
          0
        ];
        break;
      case 24:
        versionInformation = <int>[
          0,
          0,
          1,
          0,
          0,
          0,
          1,
          1,
          0,
          1,
          1,
          1,
          0,
          0,
          0,
          1,
          1,
          0
        ];
        break;
      case 25:
        versionInformation = <int>[
          1,
          0,
          0,
          0,
          0,
          1,
          1,
          1,
          1,
          0,
          0,
          0,
          1,
          0,
          0,
          1,
          1,
          0
        ];
        break;
      case 26:
        versionInformation = <int>[
          1,
          1,
          0,
          1,
          0,
          1,
          0,
          1,
          1,
          1,
          1,
          1,
          0,
          1,
          0,
          1,
          1,
          0
        ];
        break;
      case 27:
        versionInformation = <int>[
          0,
          1,
          1,
          1,
          0,
          0,
          0,
          1,
          0,
          0,
          0,
          0,
          1,
          1,
          0,
          1,
          1,
          0
        ];
        break;
      case 28:
        versionInformation = <int>[
          0,
          1,
          0,
          1,
          1,
          0,
          0,
          0,
          0,
          0,
          1,
          1,
          0,
          0,
          1,
          1,
          1,
          0
        ];
        break;
      case 29:
        versionInformation = <int>[
          1,
          1,
          1,
          1,
          1,
          1,
          0,
          0,
          1,
          1,
          0,
          0,
          1,
          0,
          1,
          1,
          1,
          0
        ];
        break;
      case 30:
        versionInformation = <int>[
          1,
          0,
          1,
          0,
          1,
          1,
          1,
          0,
          1,
          0,
          1,
          1,
          0,
          1,
          1,
          1,
          1,
          0
        ];
        break;
      case 31:
        versionInformation = <int>[
          0,
          0,
          0,
          0,
          1,
          0,
          1,
          0,
          0,
          1,
          0,
          0,
          1,
          1,
          1,
          1,
          1,
          0
        ];
        break;
      case 32:
        versionInformation = <int>[
          1,
          0,
          1,
          0,
          1,
          0,
          1,
          1,
          1,
          0,
          0,
          1,
          0,
          0,
          0,
          0,
          0,
          1
        ];
        break;
      case 33:
        versionInformation = <int>[
          0,
          0,
          0,
          0,
          1,
          1,
          1,
          1,
          0,
          1,
          1,
          0,
          1,
          0,
          0,
          0,
          0,
          1
        ];
        break;
      case 34:
        versionInformation = <int>[
          0,
          1,
          0,
          1,
          1,
          1,
          0,
          1,
          0,
          0,
          0,
          1,
          0,
          1,
          0,
          0,
          0,
          1
        ];
        break;
      case 35:
        versionInformation = <int>[
          1,
          1,
          1,
          1,
          1,
          0,
          0,
          1,
          1,
          1,
          1,
          0,
          1,
          1,
          0,
          0,
          0,
          1
        ];
        break;
      case 36:
        versionInformation = <int>[
          1,
          1,
          0,
          1,
          0,
          0,
          0,
          0,
          1,
          1,
          0,
          1,
          0,
          0,
          1,
          0,
          0,
          1
        ];
        break;
      case 37:
        versionInformation = <int>[
          0,
          1,
          1,
          1,
          0,
          1,
          0,
          0,
          0,
          0,
          1,
          0,
          1,
          0,
          1,
          0,
          0,
          1
        ];
        break;
      case 38:
        versionInformation = <int>[
          0,
          0,
          1,
          0,
          0,
          1,
          1,
          0,
          0,
          1,
          0,
          1,
          0,
          1,
          1,
          0,
          0,
          1
        ];
        break;
      case 39:
        versionInformation = <int>[
          1,
          0,
          0,
          0,
          0,
          0,
          1,
          0,
          1,
          0,
          1,
          0,
          1,
          1,
          1,
          0,
          0,
          1
        ];
        break;
      case 40:
        versionInformation = <int>[
          1,
          0,
          0,
          1,
          0,
          1,
          1,
          0,
          0,
          0,
          1,
          1,
          0,
          0,
          0,
          1,
          0,
          1
        ];
        break;
    }

    return versionInformation;
  }

  /// Specifies the format information
  List<int>? _obtainFormatInformation() {
    List<int>? formatInformation;
    switch (errorCorrectionLevel) {
      case ErrorCorrectionLevel.low:
        formatInformation = <int>[1, 0, 1, 1, 1, 0, 0, 1, 0, 0, 0, 1, 1, 1, 1];
        break;
      case ErrorCorrectionLevel.medium:
        formatInformation = <int>[1, 1, 0, 1, 0, 0, 1, 0, 1, 1, 0, 1, 1, 0, 1];
        break;
      case ErrorCorrectionLevel.quartile:
        formatInformation = <int>[0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 1, 0, 1, 1, 0];
        break;
      case ErrorCorrectionLevel.high:
        formatInformation = <int>[0, 0, 0, 0, 1, 0, 1, 1, 1, 0, 0, 1, 1, 0, 0];
        break;
      default:
        break;
    }

    return formatInformation;
  }
}
