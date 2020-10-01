part of barcodes;

/// Quick response code ([QRCode]) is a two-dimensional barcode. It can
/// efficiently store more information in a smaller space than 1D barcodes.
/// Each barcode can store values up to 7089 characters.
/// It is mostly used for URLs, business cards, contact information, etc.
///
/// The [QRCode] consists of a grid of dark and light dots or blocks that form
/// a square.
/// The data encoded in the barcode can be numeric, alphanumeric, or Shift
/// JIS characters.
///
/// * The QR Code uses version from 1 to 40. Version 1 measures 21 modules x 21
/// modules, version 2 measures 25 modules x 25 modules, and so on.
/// The number of modules increases in steps of 4 modules per side up to
/// version 40 that measures 177 modules x 177 modules.
/// * Each version has its own capacity. By default, the barcode control
/// automatically sets the version according to the length of the input text.
/// * The [QRCode] is designed for industrial uses and also commonly used
/// in consumer advertising.
///
/// The amount of data that can be stored in the [QRCode] symbol depends on the
/// [inputMode], [codeVersion] (1, ..., 40, indicating the overall dimensions
/// of the symbol, i.e. 4 × version number + 17 dots on each side), and
/// [errorCorrectionLevel]. The maximum storage capacities occur for
/// [codeVersion] 40 and [ErrorCorrectionLevel.low].
class QRCode extends Symbology {
  /// Create a [QRCode] symbology with the default or required properties.
  ///
  /// The arguments [module] must be non-negative and greater than 0.
  ///
  QRCode(
      {this.codeVersion,
      this.errorCorrectionLevel = ErrorCorrectionLevel.high,
      this.inputMode = QRInputMode.binary,
      int module})
      : super(module: module) {
    if (codeVersion != null && codeVersion != QRCodeVersion.auto) {
      _codeVersion = codeVersion;
      _isUserMentionedVersion = true;
    } else {
      _isUserMentionedVersion = false;
    }

    if (errorCorrectionLevel != null) {
      _errorCorrectionLevel = errorCorrectionLevel;
      _isUserMentionedErrorCorrectionLevel = true;
    } else {
      _isUserMentionedErrorCorrectionLevel = false;
    }

    if (inputMode != null) {
      _inputMode = inputMode;
      _isUserMentionedMode = true;
    } else {
      _isUserMentionedMode = false;
    }
  }

  /// Define the version that is used to encode the amount of data.
  ///
  /// The [QRCode] uses version from 1 to 40. Version 1 measures
  /// 21 modules x 21 modules, version 2 measures 25 modules x 25 modules,
  /// and so on.
  ///
  /// The number of modules increases in steps of 4 modules per side up to
  /// version 40 that measures 177 modules x 177 modules.
  ///
  /// Defaults to [QRCodeVersion.auto].
  ///
  /// Also refer [QRCodeVersion].
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfBarcodeGenerator(value:'123456',
  ///        symbology: QRCode(codeVersion: 4)));
  ///}
  /// ```dart
  final QRCodeVersion codeVersion;

  /// Define the encode recovery capacity of the barcode.
  ///
  /// Below error correction capability at each of the four levels:
  ///
  /// * [ErrorCorrectionLevel.low] - approximately 7% of the codewords
  /// can be restored.
  ///
  /// * [ErrorCorrectionLevel.medium] - approximately 15% of the codewords
  /// can be restored.
  ///
  /// * [ErrorCorrectionLevel.quartile] - approximately 25% of the codewords
  /// can be restored.
  ///
  /// * [ErrorCorrectionLevel.high] - approximately 30% of the codewords
  /// can be restored.
  ///
  /// Defaults to [ErrorCorrectionLevel.high].
  ///
  /// Also refer [ErrorCorrectionLevel].
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfBarcodeGenerator(value:'123456',
  ///        symbology: QRCode(
  ///         errorCorrectionLevel: ErrorCorrectionLevel.high)));
  ///}
  /// ```dart
  final ErrorCorrectionLevel errorCorrectionLevel;

  /// Define a specific set of input mode characters.
  ///
  /// Defaults to [QRInputMode.binary].
  ///
  ///  Also refer [QRInputMode].
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfBarcodeGenerator(value:'123456',
  ///        symbology: QRCode(inputMode: m QRInputMode.low));
  ///}
  /// ```dart
  final QRInputMode inputMode;

  /// Specifies the CP437 character set
  static const List<String> _cp437CharSet = <String>[
    '2591',
    '2592',
    '2593',
    '2502',
    '2524',
    '2561',
    '2562',
    '2556',
    '2555',
    '2563',
    '2551',
    '2557',
    '255D',
    '255C',
    '255B',
    '2510',
    '2514',
    '2534',
    '252C',
    '251C',
    '2500',
    '253C',
    '255E',
    '255F',
    '255A',
    '2554',
    '2569',
    '2566',
    '2560',
    '2550',
    '256C',
    '2567',
    '2568',
    '2564',
    '2565',
    '2559',
    '2558',
    '2552',
    '2553',
    '256B',
    '256A',
    '2518',
    '250C',
    '2588',
    '2584',
    '258C',
    '2590',
    '2580',
    '25A0'
  ];

  /// Specifies the latin2 character set
  static const List<String> _latin2CharSet = <String>[
    '104',
    '2D8',
    '141',
    '13D',
    '15A',
    '160',
    '15E',
    '164',
    '179',
    '17D',
    '17B',
    '105',
    '2DB',
    '142',
    '13E',
    '15B',
    '2C7',
    '161',
    '15F',
    '165',
    '17A',
    '2DD',
    '17E',
    '17C',
    '154',
    '102',
    '139',
    '106',
    '10C',
    '118',
    '11A',
    '10E',
    '110',
    '143',
    '147',
    '150',
    '158',
    '16E',
    '170',
    '162',
    '155',
    '103',
    '13A',
    '107',
    '10D',
    '119',
    '11B',
    '10F',
    '111',
    '144',
    '148',
    '151',
    '159',
    '16F',
    '171',
    '163',
    '2D9'
  ];

  /// Specifies the latin3 character set
  static const List<String> _latin3CharSet = <String>[
    '126',
    '124',
    '130',
    '15E',
    '11E',
    '134',
    '17B',
    '127',
    '125',
    '131',
    '15F',
    '11F',
    '135',
    '17C',
    '10A',
    '108',
    '120',
    '11C',
    '16C',
    '15C',
    '10B',
    '109',
    '121',
    '11D',
    '16D',
    '15D'
  ];

  /// Specifies the latin4 character set
  static const List<String> _latin4CharSet = <String>[
    '104',
    '138',
    '156',
    '128',
    '13B',
    '160',
    '112',
    '122',
    '166',
    '17D',
    '105',
    '2DB',
    '157',
    '129',
    '13C',
    '2C7',
    '161',
    '113',
    '123',
    '167',
    '14A',
    '17E',
    '14B',
    '100',
    '12E',
    '10C',
    '118',
    '116',
    '12A',
    '110',
    '145',
    '14C',
    '136',
    '172',
    '168',
    '16A',
    '101',
    '12F',
    '10D',
    '119',
    '117',
    '12B',
    '111',
    '146',
    '14D',
    '137',
    '173',
    '169',
    '16B'
  ];

  /// Specifies the windows 1250 character set
  static const List<String> _windows1250CharSet = <String>[
    '141',
    '104',
    '15E',
    '17B',
    '142',
    '105',
    '15F',
    '13D',
    '13E',
    '17C'
  ];

  /// Specifies the windows 1251 character set
  static const List<String> _windows1251CharSet = <String>[
    '402',
    '403',
    '453',
    '409',
    '40A',
    '40C',
    '40B',
    '40F',
    '452',
    '459',
    '45A',
    '45C',
    '45B',
    '45F',
    '40E',
    '45E',
    '408',
    '490',
    '401',
    '404',
    '407',
    '406',
    '456',
    '491',
    '451',
    '454',
    '458',
    '405',
    '455',
    '457'
  ];

  /// Specifies the windows 1252 character set
  static const List<String> _windows1252CharSet = <String>[
    '20AC',
    '201A',
    '192',
    '201E',
    '2026',
    '2020',
    '202',
    '2C6',
    '2030',
    '160',
    '2039',
    '152',
    '17D',
    '2018',
    '2019',
    '201C',
    '201D',
    '2022',
    '2013',
    '2014',
    '2DC',
    '2122',
    '161',
    '203A',
    '153',
    '17E',
    '178'
  ];

  /// Specifies the QR code value
  _QRCodeValue _qrCodeValues;

  /// Specifies the QR code version
  QRCodeVersion _codeVersion = QRCodeVersion.version01;

  /// Species the module value
  int _noOfModules = 21;

  /// Specifies the list of module value
  List<List<_ModuleValue>> _moduleValues;

  /// Specifies the data alllocation value
  List<List<_ModuleValue>> _dataAllocationValues;

  /// Specifies the actual input mode
  QRInputMode _inputMode = QRInputMode.numeric;

  /// Specifies the actula error corrceton level
  ErrorCorrectionLevel _errorCorrectionLevel = ErrorCorrectionLevel.low;

  /// Specifies the dat bits value
  int _dataBits = 0;

  /// Specifies the list of blocks
  List<int> _blocks;

  /// Specifies the user mentioned level
  bool _isUserMentionedMode = false;

  /// Specifies the version is mentioned by user
  bool _isUserMentionedVersion = false;

  /// Specifies the error correction level is mentioned by user
  bool _isUserMentionedErrorCorrectionLevel = false;

  /// Specifies the bool value based on the error correction input
  bool _isEci = false;

  /// Specifies the assignment number
  int _eciAssignmentNumber = 3;

  /// Specifies the text value
  String _encodedText;

  /// Specifies the list of encode data
  List<bool> _encodeDataCodeWords;

  @override
  bool _getIsValidateInput(String value) {
    return true;
  }

  /// Specifies the character set of CP437
  bool _getIsCP437Character(int inputChar) {
    final String inputCharIndex = inputChar.toRadixString(16);
    if (_cp437CharSet.contains(inputCharIndex)) {
      return true;
    }

    return false;
  }

  /// Gets the input character is present in ISO8859_2 character set
  bool _getIsISO8859_2CharacterSet(int input) {
    final String inputInHex = input.toRadixString(16);
    if (_latin2CharSet.contains(inputInHex)) {
      return true;
    }
    return false;
  }

  /// Checks the input character is present in ISO8859_3 character set
  bool _getIsISO8859_3CharacterSet(int input) {
    final String inputInHex = input.toRadixString(16);

    if (_latin3CharSet.contains(inputInHex)) {
      return true;
    }
    return false;
  }

  /// Checks the input character is present in ISO8859_4 character set
  bool _getIsISO8859_4CharacterSet(int input) {
    final String inputInHex = input.toRadixString(16);
    if (_latin4CharSet.contains(inputInHex)) {
      return true;
    }
    return false;
  }

  /// Checks the input character is present in ISO8859_4 character set
  bool _getIsISO8859_5CharacterSet(int input) {
    if (input >= 1025 &&
        input <= 1119 &&
        input != 1037 &&
        input != 1104 &&
        input != 1117) {
      return true;
    }

    return false;
  }

  ///Checks the input character is present in ISO8859_5 character set
  bool _getIsISO8859_6CharacterSet(int input) {
    if ((input >= 1569 && input <= 1594) ||
        (input >= 1600 && input <= 1618) ||
        input == 1567 ||
        input == 1563 ||
        input == 1548) {
      return true;
    }

    return false;
  }

  ///Checks the input character is present in ISO8859_7 character set
  bool _getIsISO8859_7CharacterSet(int input) {
    if ((input >= 900 && input <= 974) || input == 890) {
      return true;
    }

    return false;
  }

  /// Checks the input character is present in ISO8859_8 character set
  bool _getIsISO8859_8CharacterSet(int input) {
    if (input >= 1488 && input <= 1514) {
      return true;
    }

    return false;
  }

  /// Checks the input character is present in ISO8859_811character set
  bool _getIsISO8859_11CharacterSet(int input) {
    if (input >= 3585 && input <= 3675) {
      return true;
    }

    return false;
  }

  /// Checks the input character is present in Windows1250Character  set
  bool _getIsWindows1250Character(int input) {
    final String inputCharHex = input.toRadixString(16);
    if (_windows1250CharSet.contains(inputCharHex)) {
      return true;
    }

    if (input >= 1569 && input <= 1610) {
      return true;
    }

    return false;
  }

  /// Checks the input character is present in Windows1251Character  set
  bool _getIsWindows1251Character(int input) {
    final String inputChar = input.toRadixString(16);
    if (_windows1251CharSet.contains(inputChar)) {
      return true;
    }

    if (input >= 1040 && input <= 1103) {
      return true;
    }

    return false;
  }

  /// Checks the input character is present in Windows1252Character  set
  bool _getIsWindows1252Character(int input) {
    final String inputChar = input.toRadixString(16);

    if (_windows1252CharSet.contains(inputChar)) {
      return true;
    }

    return false;
  }

  /// Checks the input character is present in Windows1256Character  set
  bool _getIsWindows1256Character(int input) {
    final String inputChar = input.toRadixString(16);
    final List<String> windows1256CharSet = <String>[
      '67E',
      '679',
      '152',
      '686',
      '698',
      '688',
      '6AF',
      '6A9',
      '691',
      '153',
      '6BA',
      '6BE',
      '6C1'
    ];

    if (windows1256CharSet.contains(inputChar)) {
      return true;
    }

    if (input >= 1569 && input <= 1610) {
      return true;
    }

    return false;
  }

  /// Allocates the format and the version information
  void _allocateFormatAndVersionInformation() {
    for (int i = 0; i < 9; i++) {
      _moduleValues[8][i].isFilled = true;
      _moduleValues[i][8].isFilled = true;
    }

    for (int i = _noOfModules - 8; i < _noOfModules; i++) {
      _moduleValues[8][i].isFilled = true;
      _moduleValues[i][8].isFilled = true;
    }

    final int version = _getVersionNumber(_codeVersion);
    if (version > 6) {
      final List<int> versionInformation = _qrCodeValues._versionInformation;
      int count = 0;
      for (int i = 0; i < 6; i++) {
        for (int j = 2; j >= 0; j--) {
          _moduleValues[i][_noOfModules - 9 - j].isBlack =
              versionInformation != null && versionInformation[count] == 1
                  ? true
                  : false;
          _moduleValues[i][_noOfModules - 9 - j].isFilled = true;

          _moduleValues[_noOfModules - 9 - j][i].isBlack =
              versionInformation != null && versionInformation[count++] == 1
                  ? true
                  : false;
          _moduleValues[_noOfModules - 9 - j][i].isFilled = true;
        }
      }
    }
  }

  /// Returns the alignment pattern
  ///
  /// This is  a very large method. This method could not be
  /// refactored to a smaller methods, since it has single switch condition and
  /// returns the alignment pattern based on the QR Code version
  List<int> _getAlignmentPatternCoordinates() {
    List<int> align;
    final int versionNumber = _getVersionNumber(_codeVersion);
    switch (versionNumber) {
      case 02:
        align = <int>[6, 18];
        break;
      case 03:
        align = <int>[6, 22];
        break;
      case 04:
        align = <int>[6, 26];
        break;
      case 05:
        align = <int>[6, 30];
        break;
      case 06:
        align = <int>[6, 34];
        break;
      case 07:
        align = <int>[6, 22, 38];
        break;
      case 08:
        align = <int>[6, 24, 42];
        break;
      case 09:
        align = <int>[6, 26, 46];
        break;
      case 10:
        align = <int>[6, 28, 50];
        break;
      case 11:
        align = <int>[6, 30, 54];
        break;
      case 12:
        align = <int>[6, 32, 58];
        break;
      case 13:
        align = <int>[6, 34, 62];
        break;
      case 14:
        align = <int>[6, 26, 46, 66];
        break;
      case 15:
        align = <int>[6, 26, 48, 70];
        break;
      case 16:
        align = <int>[6, 26, 50, 74];
        break;
      case 17:
        align = <int>[6, 30, 54, 78];
        break;
      case 18:
        align = <int>[6, 30, 56, 82];
        break;
      case 19:
        align = <int>[6, 30, 58, 86];
        break;
      case 20:
        align = <int>[6, 34, 62, 90];
        break;
      case 21:
        align = <int>[6, 28, 50, 72, 94];
        break;
      case 22:
        align = <int>[6, 26, 50, 74, 98];
        break;
      case 23:
        align = <int>[6, 30, 54, 78, 102];
        break;
      case 24:
        align = <int>[6, 28, 54, 80, 106];
        break;
      case 25:
        align = <int>[6, 32, 58, 84, 110];
        break;
      case 26:
        align = <int>[6, 30, 58, 86, 114];
        break;
      case 27:
        align = <int>[6, 34, 62, 90, 118];
        break;
      case 28:
        align = <int>[6, 26, 50, 74, 98, 122];
        break;
      case 29:
        align = <int>[6, 30, 54, 78, 102, 126];
        break;
      case 30:
        align = <int>[6, 26, 52, 78, 104, 130];
        break;
      case 31:
        align = <int>[6, 30, 56, 82, 108, 134];
        break;
      case 32:
        align = <int>[6, 34, 60, 86, 112, 138];
        break;
      case 33:
        align = <int>[6, 30, 58, 86, 114, 142];
        break;
      case 34:
        align = <int>[6, 34, 62, 90, 118, 146];
        break;
      case 35:
        align = <int>[6, 30, 54, 78, 102, 126, 150];
        break;
      case 36:
        align = <int>[6, 24, 50, 76, 102, 128, 154];
        break;
      case 37:
        align = <int>[6, 28, 54, 80, 106, 132, 158];
        break;
      case 38:
        align = <int>[6, 32, 58, 84, 110, 136, 162];
        break;
      case 39:
        align = <int>[6, 26, 54, 82, 110, 138, 166];
        break;
      case 40:
        align = <int>[6, 30, 58, 86, 114, 142, 170];
        break;
    }
    return align;
  }

  /// Converts the string to the list of bool
  List<bool> _getStringToBoolArray(String numberInString, int noOfBits) {
    final List<bool> numberInBool = List<bool>(noOfBits);
    int j = 0;
    for (int i = 0; i < numberInString.length; i++) {
      j = j * 10 + numberInString[i].codeUnitAt(0) - 48;
    }

    for (int i = 0; i < noOfBits; i++) {
      numberInBool[noOfBits - i - 1] = ((j >> i) & 1) == 1;
    }
    return numberInBool;
  }

  /// Converts the integer to bool array value
  List<bool> _getIntToBoolArray(int number, int noOfBits) {
    final List<bool> numberInBool = List<bool>(noOfBits);
    for (int i = 0; i < noOfBits; i++) {
      numberInBool[noOfBits - i - 1] = ((number >> i) & 1) == 1;
    }

    return numberInBool;
  }

  ///Methods to creates the block value based on the encoded data
  List<List<String>> _getBlocks(List<bool> encodeData, int noOfBlocks) {
    final List<List<String>> encodedBlocks = List<List<String>>.generate(
        noOfBlocks,
        (int i) => List<String>(encodeData.length ~/ 8 ~/ noOfBlocks));

    String stringValue = '';
    int j = 0;
    int i = 0;
    int blockNumber = 0;
    for (; j < encodeData.length; j++) {
      if (j % 8 == 0 && j != 0) {
        encodedBlocks[blockNumber][i] = stringValue;
        stringValue = '';
        i++;

        if (i == (encodeData.length / noOfBlocks / 8)) {
          blockNumber++;
          i = 0;
        }
      }

      stringValue += encodeData[j] ? '1' : '0';
    }

    encodedBlocks[blockNumber][i] = stringValue;
    return encodedBlocks;
  }

  /// Method to the split code word
  List<String> _splitCodeWord(
      List<List<String>> encodeData, int block, int count) {
    final List<String> encodeDataString = List<String>(count);
    for (int i = 0; i < count; i++) {
      encodeDataString[i] = encodeData[block][i];
    }

    return encodeDataString;
  }

  /// Method to find the actual mode, correction level and the input level
  void _initialize() {
    QRInputMode actualMode = QRInputMode.numeric;
    for (int i = 0; i < _encodedText.length; i++) {
      if (_encodedText[i].codeUnitAt(0) < 58 &&
          _encodedText[i].codeUnitAt(0) > 47) {
      } else if ((_encodedText[i].codeUnitAt(0) < 91 &&
              _encodedText[i].codeUnitAt(0) > 64) ||
          _encodedText[i] == '\$' ||
          _encodedText[i] == '%' ||
          _encodedText[i] == '*' ||
          _encodedText[i] == '+' ||
          _encodedText[i] == '-' ||
          _encodedText[i] == '.' ||
          _encodedText[i] == '/' ||
          _encodedText[i] == ':' ||
          _encodedText[i] == ' ') {
        actualMode = QRInputMode.alphaNumeric;
      } else if ((_encodedText[i].codeUnitAt(0) >= 65377 &&
              _encodedText[i].codeUnitAt(0) <= 65439) ||
          (_encodedText[i].codeUnitAt(0) >= 97 &&
              _encodedText[i].codeUnitAt(0) <= 122)) {
        actualMode = QRInputMode.binary;

        break;
      } else {
        actualMode = QRInputMode.binary;
        _isEci = true;
        break;
      }
    }

    if (_isUserMentionedMode) {
      if (actualMode != inputMode) {
        if (((actualMode == QRInputMode.alphaNumeric ||
                    actualMode == QRInputMode.binary) &&
                inputMode == QRInputMode.numeric) ||
            (actualMode == QRInputMode.binary &&
                inputMode == QRInputMode.alphaNumeric)) {
          // new BarcodeException("Mode Conflict");
        }
      }
    }

    _inputMode = actualMode;
    _initializeECI();
    _initializeVersionAndECR();
    _noOfModules = (_getVersionNumber(_codeVersion) - 1) * 4 + 21;
  }

  /// Method to initialize the error correction level
  ///
  /// This is a very large method. This method could not be
  /// refactored to a smaller methods, since it has single for loop and
  /// returns the ECI based on the encoded text
  void _initializeECI() {
    if (_isEci) {
      for (int i = 0; i < _encodedText.length; i++) {
        if (_encodedText[i].codeUnitAt(0) >= 32 &&
            _encodedText[i].codeUnitAt(0) <= 255) {
          continue;
        }
        //Check for CP437
        if (_getIsCP437Character(_encodedText[i].codeUnitAt(0))) {
          _eciAssignmentNumber = 2;
          break;
        }

        //Check for ISO/IEC 8859-2
        else if (_getIsISO8859_2CharacterSet(_encodedText[i].codeUnitAt(0))) {
          _eciAssignmentNumber = 4;
          break;
        }
        //Check for ISO/IEC 8859-3
        else if (_getIsISO8859_3CharacterSet(_encodedText[i].codeUnitAt(0))) {
          _eciAssignmentNumber = 5;
          break;
        }
        //Check for ISO/IEC 8859-4
        else if (_getIsISO8859_4CharacterSet(_encodedText[i].codeUnitAt(0))) {
          _eciAssignmentNumber = 6;
          break;
        }
        //Check for ISO/IEC 8859-5
        else if (_getIsISO8859_5CharacterSet(_encodedText[i].codeUnitAt(0))) {
          _eciAssignmentNumber = 7;
          break;
        }
        //Check for ISO/IEC 8859-6
        else if (_getIsISO8859_6CharacterSet(_encodedText[i].codeUnitAt(0))) {
          _eciAssignmentNumber = 8;
          break;
        }
        //Check for ISO/IEC 8859-7
        else if (_getIsISO8859_7CharacterSet(_encodedText[i].codeUnitAt(0))) {
          _eciAssignmentNumber = 9;
          break;
        }
        //Check for ISO/IEC 8859-8
        else if (_getIsISO8859_8CharacterSet(_encodedText[i].codeUnitAt(0))) {
          _eciAssignmentNumber = 10;
          break;
        }
        //Check for ISO/IEC 8859-8
        else if (_getIsISO8859_11CharacterSet(_encodedText[i].codeUnitAt(0))) {
          _eciAssignmentNumber = 13;
          break;
        }

        //Check for Windows1250
        else if (_getIsWindows1250Character(_encodedText[i].codeUnitAt(0))) {
          _eciAssignmentNumber = 21;
          break;
        }
        //Check for Windows1251
        else if (_getIsWindows1251Character(_encodedText[i].codeUnitAt(0))) {
          _eciAssignmentNumber = 22;
          break;
        }
        //Check for Windows1252
        else if (_getIsWindows1252Character(_encodedText[i].codeUnitAt(0))) {
          _eciAssignmentNumber = 23;
          break;
        }
        //Check for Windows1256
        else if (_getIsWindows1256Character(_encodedText[i].codeUnitAt(0))) {
          _eciAssignmentNumber = 24;
          break;
        }
      }
    }
  }

  /// Method to initialize the version and the error correction level
  ///
  /// This is a very large method. This method could not be
  /// refactored to a smaller methods, since it has single if else condition and
  /// it sets the data capacity and error correction level based on the input
  /// mode
  void _initializeVersionAndECR() {
    if (!_isUserMentionedVersion || _codeVersion == QRCodeVersion.auto) {
      List<int> dataCapacityOfVersions;
      if (_isUserMentionedErrorCorrectionLevel) {
        switch (_inputMode) {
          case QRInputMode.numeric:
            {
              dataCapacityOfVersions = _getDataCapacityForNumericMode();
              break;
            }

          case QRInputMode.alphaNumeric:
            {
              dataCapacityOfVersions = _getDataCapacityForAlphaNumericMode();
              break;
            }

          case QRInputMode.binary:
            {
              dataCapacityOfVersions = _getDataCapacityForBinaryMode();
              break;
            }
        }
      } else {
        _errorCorrectionLevel = ErrorCorrectionLevel.low;
        dataCapacityOfVersions = _getDataCapacityVersionForInputMode();
      }
      int i;
      for (i = 0; i < dataCapacityOfVersions.length; i++) {
        if (dataCapacityOfVersions[i] > _encodedText.length) {
          break;
        }
      }

      final int calculatedVersion = i + 1;

      if (calculatedVersion > 40) {
        return;
      } else {
        _codeVersion = _getVersionBasedOnNumber(calculatedVersion);
      }
    } else if (_isUserMentionedVersion) {
      if (_isUserMentionedErrorCorrectionLevel) {
        int capacity = 0;
        if (_inputMode == QRInputMode.alphaNumeric) {
          capacity = _QRCodeValue._getAlphaNumericDataCapacity(
              _errorCorrectionLevel, _codeVersion);
        } else if (_inputMode == QRInputMode.numeric) {
          capacity = _QRCodeValue._getNumericDataCapacity(
              _errorCorrectionLevel, _codeVersion);
        } else if (_inputMode == QRInputMode.binary) {
          capacity = _QRCodeValue._getBinaryDataCapacity(
              _errorCorrectionLevel, _codeVersion);
        }
        if (capacity < _encodedText.length) {
          throw 'The input value length is greater than version capacity';
        }
      } else {
        int capacityLow = 0,
            capacityMedium = 0,
            capacityQuartile = 0,
            capacityHigh = 0;
        if (_inputMode == QRInputMode.alphaNumeric) {
          capacityLow = _QRCodeValue._getAlphaNumericDataCapacity(
              ErrorCorrectionLevel.low, _codeVersion);
          capacityMedium = _QRCodeValue._getAlphaNumericDataCapacity(
              ErrorCorrectionLevel.medium, _codeVersion);
          capacityQuartile = _QRCodeValue._getAlphaNumericDataCapacity(
              ErrorCorrectionLevel.quartile, _codeVersion);
          capacityHigh = _QRCodeValue._getAlphaNumericDataCapacity(
              ErrorCorrectionLevel.high, _codeVersion);
        } else if (_inputMode == QRInputMode.numeric) {
          capacityLow = _QRCodeValue._getNumericDataCapacity(
              ErrorCorrectionLevel.low, _codeVersion);
          capacityMedium = _QRCodeValue._getNumericDataCapacity(
              ErrorCorrectionLevel.medium, _codeVersion);
          capacityQuartile = _QRCodeValue._getNumericDataCapacity(
              ErrorCorrectionLevel.quartile, _codeVersion);
          capacityHigh = _QRCodeValue._getNumericDataCapacity(
              ErrorCorrectionLevel.high, _codeVersion);
        } else if (_inputMode == QRInputMode.binary) {
          capacityLow = _QRCodeValue._getBinaryDataCapacity(
              ErrorCorrectionLevel.low, _codeVersion);
          capacityMedium = _QRCodeValue._getBinaryDataCapacity(
              ErrorCorrectionLevel.medium, _codeVersion);
          capacityQuartile = _QRCodeValue._getBinaryDataCapacity(
              ErrorCorrectionLevel.quartile, _codeVersion);
          capacityHigh = _QRCodeValue._getBinaryDataCapacity(
              ErrorCorrectionLevel.high, _codeVersion);
        }

        if (capacityHigh > _encodedText.length) {
          _errorCorrectionLevel = ErrorCorrectionLevel.high;
        } else if (capacityQuartile > _encodedText.length) {
          _errorCorrectionLevel = ErrorCorrectionLevel.quartile;
        } else if (capacityMedium > _encodedText.length) {
          _errorCorrectionLevel = ErrorCorrectionLevel.medium;
        } else if (capacityLow > _encodedText.length) {
          _errorCorrectionLevel = ErrorCorrectionLevel.low;
        } else {
          throw 'The input value length is greater than version capacity';
        }
      }
    }
  }

  /// Returns the data capacity for numeric mode
  List<int> _getDataCapacityForNumericMode() {
    List<int> dataCapacityOfVersions;
    switch (_errorCorrectionLevel) {
      case ErrorCorrectionLevel.low:
        dataCapacityOfVersions = _QRCodeValue._numericDataCapacityLow;
        break;
      case ErrorCorrectionLevel.medium:
        dataCapacityOfVersions = _QRCodeValue._numericDataCapacityMedium;
        break;
      case ErrorCorrectionLevel.quartile:
        dataCapacityOfVersions = _QRCodeValue._numericDataCapacityQuartile;
        break;
      case ErrorCorrectionLevel.high:
        dataCapacityOfVersions = _QRCodeValue._numericDataCapacityHigh;
        break;
    }

    return dataCapacityOfVersions;
  }

  /// Returns the data capacity for alpha numeric mode
  List<int> _getDataCapacityForAlphaNumericMode() {
    List<int> dataCapacityOfVersions;
    switch (_errorCorrectionLevel) {
      case ErrorCorrectionLevel.low:
        dataCapacityOfVersions = _QRCodeValue._alphaNumericDataCapacityLow;
        break;
      case ErrorCorrectionLevel.medium:
        dataCapacityOfVersions = _QRCodeValue._alphaNumericDataCapacityMedium;
        break;
      case ErrorCorrectionLevel.quartile:
        dataCapacityOfVersions = _QRCodeValue._alphaNumericDataCapacityQuartile;
        break;
      case ErrorCorrectionLevel.high:
        dataCapacityOfVersions = _QRCodeValue._alphaNumericDataCapacityHigh;
        break;
    }

    return dataCapacityOfVersions;
  }

  /// Returns the data capacity for binary mode
  List<int> _getDataCapacityForBinaryMode() {
    List<int> dataCapacityOfVersions;
    switch (_errorCorrectionLevel) {
      case ErrorCorrectionLevel.low:
        dataCapacityOfVersions = _QRCodeValue._binaryDataCapacityLow;
        break;
      case ErrorCorrectionLevel.medium:
        dataCapacityOfVersions = _QRCodeValue._binaryDataCapacityMedium;
        break;
      case ErrorCorrectionLevel.quartile:
        dataCapacityOfVersions = _QRCodeValue._binaryDataCapacityQuartile;
        break;
      case ErrorCorrectionLevel.high:
        dataCapacityOfVersions = _QRCodeValue._binaryDataCapacityHigh;
        break;
    }

    return dataCapacityOfVersions;
  }

  /// Returns the data capacity version for input
  List<int> _getDataCapacityVersionForInputMode() {
    List<int> dataCapacityOfVersions;
    switch (_inputMode) {
      case QRInputMode.numeric:
        {
          dataCapacityOfVersions = _QRCodeValue._numericDataCapacityLow;
          break;
        }

      case QRInputMode.alphaNumeric:
        {
          dataCapacityOfVersions = _QRCodeValue._alphaNumericDataCapacityLow;
          break;
        }

      case QRInputMode.binary:
        {
          dataCapacityOfVersions = _QRCodeValue._binaryDataCapacityLow;
          break;
        }
    }

    return dataCapacityOfVersions;
  }

  /// Method to draw the format information
  void _drawFormatInformation() {
    final List<int> formatInformation = _qrCodeValues._formatInformation;
    int count = 0;
    for (int i = 0; i < 7; i++) {
      if (i == 6) {
        _moduleValues[i + 1][8].isBlack =
            formatInformation[count] == 1 ? true : false;
      } else {
        _moduleValues[i][8].isBlack =
            formatInformation[count] == 1 ? true : false;
      }

      _moduleValues[8][_noOfModules - i - 1].isBlack =
          formatInformation[count++] == 1 ? true : false;
    }

    count = 14;

    for (int i = 0; i < 7; i++) {
      //Draw format information from 0 to 6
      if (i == 6) {
        _moduleValues[8][i + 1].isBlack =
            formatInformation[count] == 1 ? true : false;
      } else {
        _moduleValues[8][i].isBlack =
            formatInformation[count] == 1 ? true : false;
      }

      _moduleValues[_noOfModules - i - 1][8].isBlack =
          formatInformation[count--] == 1 ? true : false;
    }

    //Draw format information 7
    _moduleValues[8][8].isBlack = formatInformation[7] == 1 ? true : false;
    _moduleValues[8][_noOfModules - 8].isBlack =
        formatInformation[7] == 1 ? true : false;
  }

  /// Method used for data allocation and masking
  ///
  /// This is deliberately a very large method. This method could be
  /// refactored to a smaller methods, but it degrades the performance.Since it
  /// uses single for loop for calculating the data allocation values
  void _dataAllocationAndMasking(List<bool> data) {
    _dataAllocationValues = List<List<_ModuleValue>>.generate(
        _noOfModules,
        (int i) => List<_ModuleValue>.generate(
            _noOfModules, (int j) => _ModuleValue()));

    int point = 0;

    for (int i = _noOfModules - 1; i >= 0; i -= 2) {
      for (int j = _noOfModules - 1; j >= 0; j--) {
        if (!(_moduleValues[i][j].isFilled &&
            _moduleValues[i - 1][j].isFilled)) {
          if (!_moduleValues[i][j].isFilled) {
            if (point + 1 < data.length) {
              _dataAllocationValues[i][j].isBlack = data[point++];
            }

            if ((i + j) % 3 == 0) {
              if (_dataAllocationValues[i][j].isBlack) {
                _dataAllocationValues[i][j].isBlack = true;
              } else {
                _dataAllocationValues[i][j].isBlack = false;
              }
            } else {
              if (_dataAllocationValues[i][j].isBlack) {
                _dataAllocationValues[i][j].isBlack = false;
              } else {
                _dataAllocationValues[i][j].isBlack = true;
              }
            }

            _dataAllocationValues[i][j].isFilled = true;
          }

          if (!_moduleValues[i - 1][j].isFilled) {
            if (point + 1 < data.length) {
              _dataAllocationValues[i - 1][j].isBlack = data[point++];
            }

            if ((i - 1 + j) % 3 == 0) {
              if (_dataAllocationValues[i - 1][j].isBlack) {
                _dataAllocationValues[i - 1][j].isBlack = true;
              } else {
                _dataAllocationValues[i - 1][j].isBlack = false;
              }
            } else {
              if (_dataAllocationValues[i - 1][j].isBlack) {
                _dataAllocationValues[i - 1][j].isBlack = false;
              } else {
                _dataAllocationValues[i - 1][j].isBlack = true;
              }
            }
            _dataAllocationValues[i - 1][j].isFilled = true;
          }
        }
      }

      i -= 2;
      if (i == 6) {
        i--;
      }

      for (int j = 0; j < _noOfModules; j++) {
        if (!(_moduleValues[i][j].isFilled &&
            _moduleValues[i - 1][j].isFilled)) {
          if (!_moduleValues[i][j].isFilled) {
            if (point + 1 < data.length) {
              _dataAllocationValues[i][j].isBlack = data[point++];
            }

            if ((i + j) % 3 == 0) {
              if (_dataAllocationValues[i][j].isBlack) {
                _dataAllocationValues[i][j].isBlack = true;
              } else {
                _dataAllocationValues[i][j].isBlack = false;
              }
            } else {
              if (_dataAllocationValues[i][j].isBlack) {
                _dataAllocationValues[i][j].isBlack = false;
              } else {
                _dataAllocationValues[i][j].isBlack = true;
              }
            }
            _dataAllocationValues[i][j].isFilled = true;
          }

          if (!_moduleValues[i - 1][j].isFilled) {
            if (point + 1 < data.length) {
              _dataAllocationValues[i - 1][j].isBlack = data[point++];
            }

            if ((i - 1 + j) % 3 == 0) {
              if (_dataAllocationValues[i - 1][j].isBlack) {
                _dataAllocationValues[i - 1][j].isBlack = true;
              } else {
                _dataAllocationValues[i - 1][j].isBlack = false;
              }
            } else {
              if (_dataAllocationValues[i - 1][j].isBlack) {
                _dataAllocationValues[i - 1][j].isBlack = false;
              } else {
                _dataAllocationValues[i - 1][j].isBlack = true;
              }
            }
            _dataAllocationValues[i - 1][j].isFilled = true;
          }
        }
      }
    }
    for (int i = 0; i < _noOfModules; i++) {
      for (int j = 0; j < _noOfModules; j++) {
        if (!_moduleValues[i][j].isFilled) {
          final bool flag = _dataAllocationValues[i][j].isBlack;
          if (flag) {
            _dataAllocationValues[i][j].isBlack = false;
          } else {
            _dataAllocationValues[i][j].isBlack = true;
          }
        }
      }
    }
  }

  /// Method to draw the alignment pattern
  void _drawAlignmentPattern(int x, int y) {
    int i = x - 2, j = y - 2;
    for (; i < x + 3; i++, j++) {
      _moduleValues[i][y - 2].isBlack = true;
      _moduleValues[i][y - 2].isFilled = true;

      _moduleValues[i][y + 2].isBlack = true;
      _moduleValues[i][y + 2].isFilled = true;

      _moduleValues[x - 2][j].isBlack = true;
      _moduleValues[x - 2][j].isFilled = true;

      _moduleValues[x + 2][j].isBlack = true;
      _moduleValues[x + 2][j].isFilled = true;
    }

    i = x - 1;
    j = y - 1;
    for (; i < x + 2; i++, j++) {
      _moduleValues[i][y - 1].isBlack = false;
      _moduleValues[i][y - 1].isFilled = true;

      _moduleValues[i][y + 1].isBlack = false;
      _moduleValues[i][y + 1].isFilled = true;

      _moduleValues[x - 1][j].isBlack = false;
      _moduleValues[x - 1][j].isFilled = true;

      _moduleValues[x + 1][j].isBlack = false;
      _moduleValues[x + 1][j].isFilled = true;
    }

    _moduleValues[x][y].isBlack = true;
    _moduleValues[x][y].isFilled = true;
  }

  /// Method to draw the timing pattern
  void _drawTimingPattern() {
    for (int i = 8; i < _noOfModules - 8; i += 2) {
      _moduleValues[i][6].isBlack = true;
      _moduleValues[i][6].isFilled = true;

      _moduleValues[i + 1][6].isBlack = false;
      _moduleValues[i + 1][6].isFilled = true;

      _moduleValues[6][i].isBlack = true;
      _moduleValues[6][i].isFilled = true;

      _moduleValues[6][i + 1].isBlack = false;
      _moduleValues[6][i + 1].isFilled = true;
    }

    _moduleValues[_noOfModules - 8][8].isBlack = true;
    _moduleValues[_noOfModules - 8][8].isFilled = true;
  }

  /// Method to draw the PDP
  ///
  /// This is a very large method. This method could be
  /// refactored to a smaller methods, but it degrades the performance.Since it
  /// uses multiple for loop for allocating the module values values
  void _drawPDP(int x, int y) {
    int i = x;
    int j = y;
    for (; i < x + 7; i++, j++) {
      _moduleValues[i][y].isBlack = true;
      _moduleValues[i][y].isFilled = true;
      _moduleValues[i][y].isPDP = true;

      _moduleValues[i][y + 6].isBlack = true;
      _moduleValues[i][y + 6].isFilled = true;
      _moduleValues[i][y + 6].isPDP = true;

      if (y + 7 < _noOfModules) {
        _moduleValues[i][y + 7].isBlack = false;
        _moduleValues[i][y + 7].isFilled = true;
        _moduleValues[i][y + 7].isPDP = true;
      } else if (y - 1 >= 0) {
        _moduleValues[i][y - 1].isBlack = false;
        _moduleValues[i][y - 1].isFilled = true;
        _moduleValues[i][y - 1].isPDP = true;
      }

      _moduleValues[x][j].isBlack = true;
      _moduleValues[x][j].isFilled = true;
      _moduleValues[x][j].isPDP = true;

      _moduleValues[x + 6][j].isBlack = true;
      _moduleValues[x + 6][j].isFilled = true;
      _moduleValues[x + 6][j].isPDP = true;

      if (x + 7 < _noOfModules) {
        _moduleValues[x + 7][j].isBlack = false;
        _moduleValues[x + 7][j].isFilled = true;
        _moduleValues[x + 7][j].isPDP = true;
      } else if (x - 1 >= 0) {
        _moduleValues[x - 1][j].isBlack = false;
        _moduleValues[x - 1][j].isFilled = true;
        _moduleValues[x - 1][j].isPDP = true;
      }
    }

    if (x + 7 < _noOfModules && y + 7 < _noOfModules) {
      _moduleValues[x + 7][y + 7].isBlack = false;
      _moduleValues[x + 7][y + 7].isFilled = true;
      _moduleValues[x + 7][y + 7].isPDP = true;
    } else if (x + 7 < _noOfModules && y + 7 >= _noOfModules) {
      _moduleValues[x + 7][y - 1].isBlack = false;
      _moduleValues[x + 7][y - 1].isFilled = true;
      _moduleValues[x + 7][y - 1].isPDP = true;
    } else if (x + 7 >= _noOfModules && y + 7 < _noOfModules) {
      _moduleValues[x - 1][y + 7].isBlack = false;
      _moduleValues[x - 1][y + 7].isFilled = true;
      _moduleValues[x - 1][y + 7].isPDP = true;
    }

    x++;
    y++;
    i = x;
    j = y;
    for (; i < x + 5; i++, j++) {
      _moduleValues[i][y].isBlack = false;
      _moduleValues[i][y].isFilled = true;
      _moduleValues[i][y].isPDP = true;

      _moduleValues[i][y + 4].isBlack = false;
      _moduleValues[i][y + 4].isFilled = true;
      _moduleValues[i][y + 4].isPDP = true;

      _moduleValues[x][j].isBlack = false;
      _moduleValues[x][j].isFilled = true;
      _moduleValues[x][j].isPDP = true;

      _moduleValues[x + 4][j].isBlack = false;
      _moduleValues[x + 4][j].isFilled = true;
      _moduleValues[x + 4][j].isPDP = true;
    }

    x++;
    y++;
    i = x;
    j = y;
    for (; i < x + 3; i++, j++) {
      _moduleValues[i][y].isBlack = true;
      _moduleValues[i][y].isFilled = true;
      _moduleValues[i][y].isPDP = true;

      _moduleValues[i][y + 2].isBlack = true;
      _moduleValues[i][y + 2].isFilled = true;
      _moduleValues[i][y + 2].isPDP = true;

      _moduleValues[x][j].isBlack = true;
      _moduleValues[x][j].isFilled = true;
      _moduleValues[x][j].isPDP = true;

      _moduleValues[x + 2][j].isBlack = true;
      _moduleValues[x + 2][j].isFilled = true;
      _moduleValues[x + 2][j].isPDP = true;
    }

    _moduleValues[x + 1][y + 1].isBlack = true;
    _moduleValues[x + 1][y + 1].isFilled = true;
    _moduleValues[x + 1][y + 1].isPDP = true;
  }

  /// Method used to generate the value
  void _generateValues() {
    _initialize();
    _qrCodeValues = _QRCodeValue(
        qrCodeVersion: _codeVersion,
        errorCorrectionLevel: _errorCorrectionLevel);
    _moduleValues = List<List<_ModuleValue>>.generate(
        _noOfModules,
        (int i) => List<_ModuleValue>.generate(
            _noOfModules, (int j) => _ModuleValue()));
    _drawPDP(0, 0);
    _drawPDP(_noOfModules - 7, 0);
    _drawPDP(0, _noOfModules - 7);
    _drawTimingPattern();
    if (_codeVersion != QRCodeVersion.version01) {
      final List<int> alignCoordinates = _getAlignmentPatternCoordinates();

      for (int i = 0; i < alignCoordinates.length; i++) {
        for (int j = 0; j < alignCoordinates.length; j++) {
          if (!_moduleValues[alignCoordinates[i]][alignCoordinates[j]].isPDP) {
            _drawAlignmentPattern(alignCoordinates[i], alignCoordinates[j]);
          }
        }
      }
    }

    _allocateFormatAndVersionInformation();
    _encodeDataCodeWords = _encodeData();
    _dataAllocationAndMasking(_encodeDataCodeWords);
    _drawFormatInformation();
  }

  /// Method to encoded the data based on mode
  void _encodeDataBasedOnMode() {
    switch (_inputMode) {
      case QRInputMode.numeric:
        _encodeDataCodeWords.add(false);
        _encodeDataCodeWords.add(false);
        _encodeDataCodeWords.add(false);
        _encodeDataCodeWords.add(true);
        break;

      case QRInputMode.alphaNumeric:
        _encodeDataCodeWords.add(false);
        _encodeDataCodeWords.add(false);
        _encodeDataCodeWords.add(true);
        _encodeDataCodeWords.add(false);
        break;

      case QRInputMode.binary:
        if (_isEci) {
          //Add ECI Mode Indicator
          _encodeDataCodeWords.add(false);
          _encodeDataCodeWords.add(true);
          _encodeDataCodeWords.add(true);
          _encodeDataCodeWords.add(true);

          //Add ECI assignment number
          final List<bool> numberInBool =
              _getStringToBoolArray(_eciAssignmentNumber.toString(), 8);
          for (int i = 0; i < numberInBool.length; i++) {
            _encodeDataCodeWords.add(numberInBool[i]);
          }
        }
        _encodeDataCodeWords.add(false);
        _encodeDataCodeWords.add(true);
        _encodeDataCodeWords.add(false);
        _encodeDataCodeWords.add(false);
        break;
    }
  }

  /// Method to get the indicator count for lower version
  int _getIndicatorCountForLowerVersion() {
    int numberOfBitsInCharacterCountIndicator = 0;
    switch (_inputMode) {
      case QRInputMode.numeric:
        numberOfBitsInCharacterCountIndicator = 10;
        break;

      case QRInputMode.alphaNumeric:
        numberOfBitsInCharacterCountIndicator = 9;
        break;
      case QRInputMode.binary:
        numberOfBitsInCharacterCountIndicator = 8;
        break;
    }

    return numberOfBitsInCharacterCountIndicator;
  }

  /// method to get the indicator count for higher version
  int _getIndicatorCountForHigherVersion() {
    int numberOfBitsInCharacterCountIndicator = 0;
    switch (_inputMode) {
      case QRInputMode.numeric:
        numberOfBitsInCharacterCountIndicator = 12;
        break;

      case QRInputMode.alphaNumeric:
        numberOfBitsInCharacterCountIndicator = 11;
        break;

      case QRInputMode.binary:
        numberOfBitsInCharacterCountIndicator = 16;
        break;
    }

    return numberOfBitsInCharacterCountIndicator;
  }

  /// Method to get the indicator count
  int _getIndicatorCount() {
    int numberOfBitsInCharacterCountIndicator = 0;
    switch (_inputMode) {
      case QRInputMode.numeric:
        numberOfBitsInCharacterCountIndicator = 14;
        break;

      case QRInputMode.alphaNumeric:
        numberOfBitsInCharacterCountIndicator = 13;
        break;

      case QRInputMode.binary:
        numberOfBitsInCharacterCountIndicator = 16;
        break;
    }
    return numberOfBitsInCharacterCountIndicator;
  }

  /// Method to encode the data of numeric mode
  void _encodeDataInNumericMode() {
    String number = '';
    for (int i = 0; i < _encodedText.length; i++) {
      List<bool> numberInBool;
      number += _encodedText[i];

      if (i % 3 == 2 && i != 0 || i == _encodedText.length - 1) {
        if (number.length == 3) {
          numberInBool = _getStringToBoolArray(number, 10);
        } else if (number.length == 2) {
          numberInBool = _getStringToBoolArray(number, 7);
        } else {
          numberInBool = _getStringToBoolArray(number, 4);
        }

        number = '';
        for (int i = 0; i < numberInBool.length; i++) {
          _encodeDataCodeWords.add(numberInBool[i]);
        }
      }
    }
  }

  /// Method to encode the alpha numeric data
  void _encodeDataForAlphaNumeric() {
    String numberInString = '';
    int number = 0;
    for (int i = 0; i < _encodedText.length; i++) {
      List<bool> numberInBool;
      numberInString += _encodedText[i];

      if (i % 2 == 0 && i + 1 != _encodedText.length) {
        number = 45 * _qrCodeValues._getAlphaNumericValues(_encodedText[i]);
      }

      if (i % 2 == 1 && i != 0) {
        number += _qrCodeValues._getAlphaNumericValues(_encodedText[i]);
        numberInBool = _getIntToBoolArray(number, 11);
        number = 0;
        for (int i = 0; i < numberInBool.length; i++) {
          _encodeDataCodeWords.add(numberInBool[i]);
        }

        numberInString = '';
      }
      if (i != 1 && numberInString != null) {
        if (i + 1 == _encodedText.length && numberInString.length == 1) {
          number = _qrCodeValues._getAlphaNumericValues(_encodedText[i]);
          numberInBool = _getIntToBoolArray(number, 6);
          number = 0;
          for (int i = 0; i < numberInBool.length; i++) {
            _encodeDataCodeWords.add(numberInBool[i]);
          }
        }
      }
    }
  }

  /// method to encode the binary data
  void _encodeDataForBinary() {
    for (int i = 0; i < _encodedText.length; i++) {
      int number = 0;
      if ((_encodedText[i].codeUnitAt(0) >= 32 &&
              _encodedText[i].codeUnitAt(0) <= 126) ||
          _encodedText[i].codeUnitAt(0) >= 161 &&
              _encodedText[i].codeUnitAt(0) <= 255 ||
          _encodedText[i].codeUnitAt(0) == 10 ||
          _encodedText[i].codeUnitAt(0) == 13) {
        number = _encodedText[i].codeUnitAt(0);
      } else if (_encodedText[i].codeUnitAt(0) >= 65377 &&
          _encodedText[i].codeUnitAt(0) <= 65439) {
        number = _encodedText[i].codeUnitAt(0) - 65216;
      } else if (_encodedText[i].codeUnitAt(0) >= 1025 &&
          _encodedText[i].codeUnitAt(0) <= 1119) {
        number = _encodedText[i].codeUnitAt(0) - 864;
      } else if (_encodedText[i].codeUnitAt(0) >= 260 &&
          _encodedText[i].codeUnitAt(0) <= 382) {
        /// European Encoding
      } else {
        throw 'The provided input value contains non-convertible characters';
      }

      final List<bool> numberInBool = _getIntToBoolArray(number, 8);
      for (int i = 0; i < numberInBool.length; i++) {
        _encodeDataCodeWords.add(numberInBool[i]);
      }
    }
  }

  /// Method to encode the code words
  ///
  /// This is a very large method. This method could be
  /// refactored to a smaller methods, but it degrades the performance.Since it
  /// uses multiple for loop for encoding the code words
  void _encodeCodeWords() {
    for (int i = 0; i < 4; i++) {
      if (_encodeDataCodeWords.length / 8 == _qrCodeValues._noOfDataCodeWord) {
        break;
      } else {
        _encodeDataCodeWords.add(false);
      }
    }

    for (;;) {
      if (_encodeDataCodeWords.length % 8 == 0) {
        break;
      } else {
        _encodeDataCodeWords.add(false);
      }
    }

    for (;;) {
      if (_encodeDataCodeWords.length / 8 == _qrCodeValues._noOfDataCodeWord) {
        break;
      } else {
        _encodeDataCodeWords.add(true);
        _encodeDataCodeWords.add(true);
        _encodeDataCodeWords.add(true);
        _encodeDataCodeWords.add(false);
        _encodeDataCodeWords.add(true);
        _encodeDataCodeWords.add(true);
        _encodeDataCodeWords.add(false);
        _encodeDataCodeWords.add(false);
      }
      if (_encodeDataCodeWords.length / 8 == _qrCodeValues._noOfDataCodeWord) {
        break;
      } else {
        _encodeDataCodeWords.add(false);
        _encodeDataCodeWords.add(false);
        _encodeDataCodeWords.add(false);
        _encodeDataCodeWords.add(true);
        _encodeDataCodeWords.add(false);
        _encodeDataCodeWords.add(false);
        _encodeDataCodeWords.add(false);
        _encodeDataCodeWords.add(true);
      }
    }

    _dataBits = _qrCodeValues._noOfDataCodeWord;
    _blocks = _qrCodeValues._noOfErrorCorrectionBlocks;

    int totalBlockSize = _blocks[0];
    if (_blocks.length == 6) {
      totalBlockSize = _blocks[0] + _blocks[3];
    }
    final List<List<String>> ds1 =
        List<List<String>>.generate(totalBlockSize, (int i) => <String>[]);

    List<bool> testEncodeData = _encodeDataCodeWords;
    if (_blocks.length == 6) {
      final int dataCodeWordLength = _blocks[0] * _blocks[2] * 8;
      testEncodeData = <bool>[];
      for (int i = 0; i < dataCodeWordLength; i++) {
        testEncodeData.add(_encodeDataCodeWords[i]);
      }
    }

    List<List<String>> dsOne = List<List<String>>.generate(_blocks[0],
        (int i) => List<String>(testEncodeData.length ~/ 8 ~/ _blocks[0]));
    dsOne = _getBlocks(testEncodeData, _blocks[0]);

    for (int i = 0; i < _blocks[0]; i++) {
      ds1[i] =
          _splitCodeWord(dsOne, i, testEncodeData.length ~/ 8 ~/ _blocks[0]);
    }

    if (_blocks.length == 6) {
      testEncodeData = <bool>[];
      for (int i = _blocks[0] * _blocks[2] * 8;
          i < _encodeDataCodeWords.length;
          i++) {
        testEncodeData.add(_encodeDataCodeWords[i]);
      }

      List<List<String>> dsTwo = List<List<String>>.generate(_blocks[0],
          (int i) => List<String>(testEncodeData.length ~/ 8 ~/ _blocks[3]));
      dsTwo = _getBlocks(testEncodeData, _blocks[3]);

      for (int i = _blocks[0], count = 0; i < totalBlockSize; i++) {
        ds1[i] = _splitCodeWord(
            dsTwo, count++, testEncodeData.length ~/ 8 ~/ _blocks[3]);
      }
    }

    _encodeDataCodeWords = <bool>[];
    for (int i = 0; i < 125; i++) {
      for (int k = 0; k < totalBlockSize; k++) {
        for (int j = 0; j < 8; j++) {
          if (i < ds1[k].length) {
            _encodeDataCodeWords.add(ds1[k][i][j] == '1' ? true : false);
          }
        }
      }
    }

    _calculateErrorCorrectingCodeWord(totalBlockSize, ds1);
  }

  /// Method to encode the data
  List<bool> _encodeData() {
    _encodeDataCodeWords = <bool>[];
    _encodeDataBasedOnMode();

    int numberOfBitsInCharacterCountIndicator = 0;
    final int currentVersion = _getVersionNumber(_codeVersion);
    if (currentVersion < 10) {
      numberOfBitsInCharacterCountIndicator =
          _getIndicatorCountForLowerVersion();
    } else if (currentVersion < 27) {
      numberOfBitsInCharacterCountIndicator =
          _getIndicatorCountForHigherVersion();
    } else {
      numberOfBitsInCharacterCountIndicator = _getIndicatorCount();
    }

    final List<bool> numberOfBitsInCharacterCountIndicatorInBool =
        _getIntToBoolArray(
            _encodedText.length, numberOfBitsInCharacterCountIndicator);

    for (int i = 0; i < numberOfBitsInCharacterCountIndicator; i++) {
      _encodeDataCodeWords.add(numberOfBitsInCharacterCountIndicatorInBool[i]);
    }

    switch (_inputMode) {
      case QRInputMode.numeric:
        _encodeDataInNumericMode();
        break;
      case QRInputMode.alphaNumeric:
        _encodeDataForAlphaNumeric();
        break;
      case QRInputMode.binary:
        _encodeDataForBinary();
        break;
    }

    _encodeCodeWords();
    return _encodeDataCodeWords;
  }

  /// Method to calculate the error correcting code word
  void _calculateErrorCorrectingCodeWord(
      int totalBlockSize, List<List<String>> ds1) {
    final _ErrorCorrectionCodeWords errorCorrectionCodeWord =
        _ErrorCorrectionCodeWords(
            codeVersion: _codeVersion, correctionLevel: _errorCorrectionLevel);

    _dataBits = _qrCodeValues._noOfDataCodeWord;
    final int eccw = _qrCodeValues._noOfErrorCorrectionCodeWord;
    _blocks = _qrCodeValues._noOfErrorCorrectionBlocks;

    if (_blocks.length == 6) {
      errorCorrectionCodeWord._dataBits =
          (_dataBits - _blocks[3] * _blocks[5]) ~/ _blocks[0];
    } else {
      errorCorrectionCodeWord._dataBits = _dataBits ~/ _blocks[0];
    }

    errorCorrectionCodeWord._eccw = eccw ~/ totalBlockSize;

    final List<List<String>> polynomial =
        List<List<String>>.generate(totalBlockSize, (int i) => <String>[]);
    int count = 0;

    for (int i = 0; i < _blocks[0]; i++) {
      errorCorrectionCodeWord._dataCodeWords = ds1[count];
      polynomial[count++] = errorCorrectionCodeWord._getERCW();
    }
    if (_blocks.length == 6) {
      errorCorrectionCodeWord._dataBits =
          (_dataBits - _blocks[0] * _blocks[2]) ~/ _blocks[3];

      for (int i = 0; i < _blocks[3]; i++) {
        errorCorrectionCodeWord._dataCodeWords = ds1[count];
        polynomial[count++] = errorCorrectionCodeWord._getERCW();
      }
    }

    if (_blocks.length != 6) {
      for (int i = 0; i < polynomial[0].length; i++) {
        for (int k = 0; k < _blocks[0]; k++) {
          for (int j = 0; j < 8; j++) {
            if (i < polynomial[k].length) {
              _encodeDataCodeWords
                  .add(polynomial[k][i][j] == '1' ? true : false);
            }
          }
        }
      }
    } else {
      for (int i = 0; i < polynomial[0].length; i++) {
        for (int k = 0; k < totalBlockSize; k++) {
          for (int j = 0; j < 8; j++) {
            if (i < polynomial[k].length) {
              _encodeDataCodeWords
                  .add(polynomial[k][i][j] == '1' ? true : false);
            }
          }
        }
      }
    }
  }

  @override
  void _renderBarcode(
      Canvas canvas,
      Size size,
      Offset offset,
      String value,
      Color foregroundColor,
      TextStyle textStyle,
      double textSpacing,
      TextAlign textAlign,
      bool showValue) {
    _encodedText = value;
    _generateValues();

    int x = 0;
    final int w = _noOfModules;
    final int h = _noOfModules;

    final Paint paint = _getBarPaint(foregroundColor);

    final double minSize = size.width >= size.height ? size.height : size.width;
    int dimension = minSize ~/ _noOfModules;
    if (module != null) {
      dimension = module;
    }
    final double actualSize = (_noOfModules * dimension).toDouble();
    final int xPosition = (offset.dx + (size.width - actualSize) / 2).toInt();
    int yPosition = (offset.dy + (size.height - actualSize) / 2).toInt();

    for (int i = 0; i < w; i++) {
      x = xPosition;
      for (int j = 0; j < h; j++) {
        if (_moduleValues[i][j].isBlack) {
          paint.color = foregroundColor;
        } else {
          paint.color = Colors.transparent;
        }

        if (_dataAllocationValues != null &&
            _dataAllocationValues[j][i].isFilled) {
          if (_dataAllocationValues[j][i].isBlack) {
            paint.color = foregroundColor;
          }
        }

        final Rect rect = Rect.fromLTRB(x.toDouble(), yPosition.toDouble(),
            (x + dimension).toDouble(), (yPosition + dimension).toDouble());
        canvas.drawRect(rect, paint);

        x = (x + dimension).toInt();
      }

      yPosition = (yPosition + dimension).toInt();
    }

    if (showValue) {
      final Offset textOffset = Offset(offset.dx, yPosition.toDouble());
      _drawText(
          canvas, textOffset, size, value, textStyle, textSpacing, textAlign);
    }
  }

  /// Method to render the input value of the barcode
  @override
  void _drawText(Canvas canvas, Offset offset, Size size, String value,
      TextStyle textStyle, double textSpacing, TextAlign textAlign,
      [Offset actualOffset, Size actualSize]) {
    final TextSpan span = TextSpan(text: value, style: textStyle);

    final TextPainter textPainter = TextPainter(
        maxLines: 1,
        ellipsis: '.....',
        text: span,
        textDirection: TextDirection.ltr,
        textAlign: textAlign);
    textPainter.layout(minWidth: 0, maxWidth: size.width);
    double x;
    double y;
    switch (textAlign) {
      case TextAlign.justify:
      case TextAlign.center:
        {
          x = offset.dx + (size.width / 2 - textPainter.width / 2);
          y = offset.dy + textSpacing;
        }
        break;
      case TextAlign.left:
      case TextAlign.start:
        {
          x = offset.dx;
          y = offset.dy + textSpacing;
        }
        break;
      case TextAlign.right:
      case TextAlign.end:
        {
          x = offset.dx + (size.width - textPainter.width);
          y = offset.dy + textSpacing;
        }
        break;
    }
    textPainter.paint(canvas, Offset(x, y));
  }
}
