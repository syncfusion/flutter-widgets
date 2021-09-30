part of pdf;

class _FontStructure {
  //constructor
  _FontStructure([_IPdfPrimitive? fontDict, String? fontRefNum]) {
    if (fontDict != null) {
      fontDictionary = fontDict as _PdfDictionary;
      if (fontDictionary.containsKey(_PdfName('Subtype'))) {
        fontType = fontDictionary._items![_PdfName('Subtype')] as _PdfName?;
      }
    }
    _initialize();
    if (fontRefNum != null) {
      fontRefNumber = fontRefNum;
      if (fontType != null) {
        if (fontType!._name == 'Type3') {
          if (fontDictionary._items!.containsKey(_PdfName('CharProcs'))) {
            _PdfDictionary? charProcs;
            if (fontDictionary['CharProcs'] is _PdfDictionary) {
              charProcs = fontDictionary['CharProcs'] as _PdfDictionary?;
            } else {
              charProcs = (fontDictionary['CharProcs']! as _PdfReferenceHolder)
                  .object as _PdfDictionary?;
            }
            final List<_PdfName?> names = charProcs!._items!.keys.toList();
            int i = 0;
            // ignore: avoid_function_literals_in_foreach_calls
            charProcs._items!.values.forEach((_IPdfPrimitive? value) {
              if (value != null && value is _PdfReferenceHolder) {
                final _PdfReferenceHolder holder = value;
                type3FontCharProcsDict[names[i]!._name] =
                    holder.object as _PdfStream?;
                i++;
              }
            });
          }
        } else if (fontType!._name == 'Type1') {
          _isStandardFont = _checkStandardFont();
        } else if (fontType!._name == 'Type0') {
          _isStandardCJKFont = _checkStandardCJKFont();
        }
      }
    }
    _fontStyle = <PdfFontStyle>[PdfFontStyle.regular];
    defaultGlyphWidth = 0;
    _containsCmap = true;
    differenceEncoding = <int, String>{};
  }

  //Fields
  bool isWhiteSpace = false;
  bool isSameFont = false;
  String? _fontEncoding;
  late _PdfDictionary fontDictionary;
  String? _fontName;
  double? fontSize;
  Map<double, String>? _characterMapTable;
  Map<String, double>? _reverseMapTable;
  Map<double, String> tempMapTable = <double, String>{};
  Map<int, String>? differenceEncoding;
  List<String> tempStringList = <String>[];
  Map<String, String?>? _differencesDictionary;
  late Map<int, String> differenceTable;
  Map<int, int>? _octDecMapTable;
  Map<int, String>? _macEncodeTable;
  final Map<int, String> _macRomanMapTable = <int, String>{};
  final Map<int, String> _winansiMapTable = <int, String>{};
  Map<String?, int> reverseDictMapping = <String?, int>{};
  _PdfDictionary? cidSystemInfoDictionary;
  Map<double, String>? cidToGidTable;
  Map<int, int>? _cidToGidReverseMapTable;
  Map<String?, _PdfStream?> type3FontCharProcsDict = <String?, _PdfStream?>{};
  bool isContainFontfile2 = false;
  bool isMappingDone = false;
  bool isSystemFontExist = false;
  bool isTextExtraction = false;
  bool isEmbedded = false;
  bool containsCmap = true;
  late String zapfPostScript;
  late String fontRefNumber;
  _PdfName? fontType;
  bool isAdobeIdentity = false;
  bool _isCidFontType = false;
  List<PdfFontStyle>? _fontStyle;
  Map<int, int>? _fontGlyphWidth;
  double? defaultGlyphWidth;
  late bool _containsCmap;
  Map<int, String>? _unicodeCharMapTable;
  late double _type1GlyphHeight;
  late bool _isStandardFont;
  late bool _isStandardCJKFont;
  PdfFont? font;
  String? _standardFontName = '';
  String? _standardCJKFontName = '';
  late List<String> standardFontNames;
  late List<String> standardCJKFontNames;
  late List<String> cjkEncoding;
  late List<String> _windows1252MapTable;

//Properties
  String? get fontEncoding => _fontEncoding ??= getFontEncoding();

  Map<double, String> get characterMapTable =>
      _characterMapTable ??= getCharacterMapTable();

  set characterMapTable(Map<double, String> value) {
    _characterMapTable = value;
  }

  Map<String, String?> get differencesDictionary =>
      _differencesDictionary ??= getDifferencesDictionary();

  set differencesDictionary(Map<String, String?> value) {
    _differencesDictionary = value;
  }

  Map<int, int> get octDecMapTable => _octDecMapTable ??= <int, int>{};

  set octDecMapTable(Map<int, int> value) {
    _octDecMapTable = value;
  }

  Map<String, double>? get reverseMapTable =>
      _reverseMapTable ??= getReverseMapTable();

  set reverseMapTable(Map<String, double>? value) {
    _reverseMapTable = value;
  }

  Map<int, int> get cidToGidReverseMapTable =>
      _cidToGidReverseMapTable ??= <int, int>{};

  set cidToGidReverseMapTable(Map<int, int> value) {
    _cidToGidReverseMapTable = value;
  }

  Map<int, String>? get macEncodeTable {
    if (_macEncodeTable == null) {
      getMacEncodeTable();
    }
    return _macEncodeTable;
  }

  set macEncodeTable(Map<int, String>? value) {
    _macEncodeTable = value;
  }

  String? get fontName => _fontName ??= getFontName();

  bool get isCid {
    _isCidFontType = isCIDFontType();
    return _isCidFontType;
  }

  set isCid(bool value) {
    _isCidFontType = value;
  }

  List<PdfFontStyle>? get fontStyle {
    if (_fontStyle!.length == 1 && _fontStyle![0] == PdfFontStyle.regular) {
      _fontStyle = getFontStyle();
    }
    return _fontStyle;
  }

  Map<int, int>? get fontGlyphWidths {
    if (fontEncoding == 'Identity-H' || fontEncoding == 'Identity#2DH') {
      _getGlyphWidths();
    } else {
      _getGlyphWidthsNonIdH();
    }
    return _fontGlyphWidth;
  }

  Map<int, String>? get unicodeCharMapTable {
    _unicodeCharMapTable ??= <int, String>{};
    return _unicodeCharMapTable;
  }

  set unicodeCharMapTable(Map<int, String>? value) {
    _unicodeCharMapTable = value;
  }

  _PdfNumber? get flags => _getFlagValue();

  //Implementation
  void _initialize() {
    differenceTable = <int, String>{};
    zapfPostScript = '';
    fontRefNumber = '';
    _type1GlyphHeight = 0;
    _isStandardFont = false;
    _isStandardCJKFont = false;
    standardCJKFontNames = <String>[
      'HYGoThic-Medium,BoldItalic',
      'HYGoThic-Medium,Bold',
      'HYGoThic-Medium,Italic',
      'HYGoThic-Medium',
      'MHei-Medium,BoldItalic',
      'MHei-Medium,Bold',
      'MHei-Medium',
      'MHei-Medium,Italic',
      'MSung-Light,BoldItalic',
      'MSung-Light,Bold',
      'MSung-Light,Italic',
      'MSung-Light',
      'STSong-Light,BoldItalic',
      'STSong-Light,Bold',
      'STSong-Light,Italic',
      'STSong-Light',
      'HeiseiMin-W3,BoldItalic',
      'HeiseiMin-W3,Bold',
      'HeiseiMin-W3,Italic',
      'HeiseiMin-W3',
      'HeiseiKakuGo-W5,BoldItalic',
      'HeiseiKakuGo-W5,Bold',
      'HeiseiKakuGo-W5,Italic',
      'HeiseiKakuGo-W5',
      'HYSMyeongJo-Medium,BoldItalic',
      'HYSMyeongJo-Medium,Bold',
      'HYSMyeongJo-Medium,Italic',
      'HYSMyeongJo-Medium'
    ];
    cjkEncoding = <String>[
      'UniKS-UCS2-H',
      'UniJIS-UCS2-H',
      'UniCNS-UCS2-H',
      'UniGB-UCS2-H'
    ];
    standardFontNames = <String>[
      'Helvetica',
      'Helvetica-Bold',
      'Helvetica,Bold',
      'Helvetica-BoldOblique',
      'Helvetica,BoldItalic',
      'Helvetica-Oblique',
      'Helvetica,Italic',
      'Courier New',
      'Courier',
      'Courier-Bold',
      'Courier New,Bold',
      'Courier-BoldOblique',
      'Courier New,BoldItalic',
      'Courier-Oblique',
      'Courier New,Italic',
      'Times New Roman',
      'Times New Roman,Bold',
      'Times New Roman,BoldItalic',
      'Times New Roman,Italic',
      'Times-Roman',
      'Times-Bold',
      'Times-Italic',
      'Times-BoldItalic',
      'Symbol',
      'ZapfDingbats'
    ];
    _windows1252MapTable = <String>[
      '\u0000',
      '\u0001',
      '\u0002',
      '\u0003',
      '\u0004',
      '\u0005',
      '\u0006',
      '\u0007',
      '\b',
      '\t',
      '\n',
      '\v',
      '\f',
      '\r',
      '\u000e',
      '\u000f',
      '\u0010',
      '\u0011',
      '\u0012',
      '\u0013',
      '\u0014',
      '\u0015',
      '\u0016',
      '\u0017',
      '\u0018',
      '\u0019',
      '\u001a',
      '\u001b',
      '\u001c',
      '\u001d',
      '\u001e',
      '\u001f',
      ' ',
      '!',
      '"',
      '#',
      r'$',
      '%',
      '&',
      '\'',
      '(',
      ')',
      '*',
      '+',
      ',',
      '-',
      '.',
      '/',
      '0',
      '1',
      '2',
      '3',
      '4',
      '5',
      '6',
      '7',
      '8',
      '9',
      ':',
      ';',
      '<',
      '=',
      '>',
      '?',
      '@',
      'A',
      'B',
      'C',
      'D',
      'E',
      'F',
      'G',
      'H',
      'I',
      'J',
      'K',
      'L',
      'M',
      'N',
      'O',
      'P',
      'Q',
      'R',
      'S',
      'T',
      'U',
      'V',
      'W',
      'X',
      'Y',
      'Z',
      '[',
      r'\',
      ']',
      '^',
      '_',
      '`',
      'a',
      'b',
      'c',
      'd',
      'e',
      'f',
      'g',
      'h',
      'i',
      'j',
      'k',
      'l',
      'm',
      'n',
      'o',
      'p',
      'q',
      'r',
      's',
      't',
      'u',
      'v',
      'w',
      'x',
      'y',
      'z',
      '{',
      '|',
      '}',
      '~',
      '\u007f',
      '€',
      '\u0081',
      '‚',
      'ƒ',
      '„',
      '…',
      '†',
      '‡',
      'ˆ',
      '‰',
      'Š',
      '‹',
      'Œ',
      '\u008d',
      'Ž',
      '\u008f',
      '\u0090',
      '‘',
      '’',
      '“',
      '”',
      '•',
      '–',
      '—',
      '˜',
      '™',
      'š',
      '›',
      'œ',
      '\u009d',
      'ž',
      'Ÿ',
      ' ',
      '¡',
      '¢',
      '£',
      '¤',
      '¥',
      '¦',
      '§',
      '¨',
      '©',
      'ª',
      '«',
      '¬',
      '­',
      '®',
      '¯',
      '°',
      '±',
      '²',
      '³',
      '´',
      'µ',
      '¶',
      '·',
      '¸',
      '¹',
      'º',
      '»',
      '¼',
      '½',
      '¾',
      '¿',
      'À',
      'Á',
      'Â',
      'Ã',
      'Ä',
      'Å',
      'Æ',
      'Ç',
      'È',
      'É',
      'Ê',
      'Ë',
      'Ì',
      'Í',
      'Î',
      'Ï',
      'Ð',
      'Ñ',
      'Ò',
      'Ó',
      'Ô',
      'Õ',
      'Ö',
      '×',
      'Ø',
      'Ù',
      'Ú',
      'Û',
      'Ü',
      'Ý',
      'Þ',
      'ß',
      'à',
      'á',
      'â',
      'ã',
      'ä',
      'å',
      'æ',
      'ç',
      'è',
      'é',
      'ê',
      'ë',
      'ì',
      'í',
      'î',
      'ï',
      'ð',
      'ñ',
      'ò',
      'ó',
      'ô',
      'õ',
      'ö',
      '÷',
      'ø',
      'ú',
      'û',
      'ü',
      'ý',
      'þ',
      'ÿ'
    ];
  }

  _PdfNumber? _getFlagValue() {
    _PdfNumber? flagvalue;
    if (fontEncoding != 'Identity-H') {
      if (fontDictionary.containsKey(_DictionaryProperties.fontDescriptor)) {
        _IPdfPrimitive? primitive =
            fontDictionary[_DictionaryProperties.fontDescriptor];
        if (primitive != null && primitive is _PdfReferenceHolder) {
          primitive = primitive.object;
          if (primitive != null && primitive is _PdfDictionary) {
            final _PdfDictionary dic = primitive;
            if (dic.containsKey(_DictionaryProperties.flags)) {
              primitive = dic[_DictionaryProperties.flags];
              if (primitive is _PdfNumber) {
                flagvalue = primitive;
                return flagvalue;
              }
            }
          }
        }
      }
    } else {
      if (fontDictionary.containsKey(_DictionaryProperties.descendantFonts)) {
        _IPdfPrimitive? primitive =
            fontDictionary[_DictionaryProperties.descendantFonts];
        if (primitive is _PdfReferenceHolder) {
          primitive = primitive.object;
        }
        if (primitive != null && primitive is _PdfArray) {
          final _PdfArray descenarray = primitive;
          if (descenarray.count > 0 && descenarray[0] is _PdfReferenceHolder) {
            final _PdfReferenceHolder referenceholder =
                descenarray[0]! as _PdfReferenceHolder;
            final _IPdfPrimitive? primitiveObject = referenceholder.object;
            if (primitiveObject != null && primitiveObject is _PdfDictionary) {
              final _PdfDictionary dictionary = primitiveObject;
              if (dictionary
                  .containsKey(_DictionaryProperties.fontDescriptor)) {
                _IPdfPrimitive? fontDescriptor =
                    dictionary[_DictionaryProperties.fontDescriptor];
                _PdfDictionary? descriptorDictionary;
                if (fontDescriptor is _PdfReferenceHolder) {
                  fontDescriptor = fontDescriptor.object;
                  if (fontDescriptor != null &&
                      fontDescriptor is _PdfDictionary) {
                    descriptorDictionary = fontDescriptor;
                  }
                } else if (fontDescriptor is _PdfDictionary) {
                  descriptorDictionary = fontDescriptor;
                }
                if (descriptorDictionary != null &&
                    descriptorDictionary
                        .containsKey(_DictionaryProperties.flags)) {
                  primitive = descriptorDictionary[_DictionaryProperties.flags];
                  if (primitive is _PdfNumber) {
                    flagvalue = primitive;
                    return flagvalue;
                  }
                }
              }
            }
          }
        }
      }
    }
    return flagvalue;
  }

  void _getGlyphWidths() {
    if (fontEncoding == 'Identity-H' || fontEncoding == 'Identity#2DH') {
      _PdfDictionary dictionary = fontDictionary;
      if (dictionary.containsKey(_DictionaryProperties.descendantFonts)) {
        _IPdfPrimitive? primitive =
            dictionary[_DictionaryProperties.descendantFonts];
        _PdfArray? arr;
        if (primitive is _PdfReferenceHolder) {
          primitive = primitive.object;
          if (primitive != null && primitive is _PdfArray) {
            arr = primitive;
          }
        } else if (primitive is _PdfArray) {
          arr = primitive;
        }
        if (arr != null && arr.count > 0) {
          if (arr[0] is _PdfDictionary) {
            dictionary = arr[0]! as _PdfDictionary;
          } else if (arr[0] is _PdfReferenceHolder) {
            final _IPdfPrimitive? holder =
                (arr[0]! as _PdfReferenceHolder).object;
            if (holder != null && holder is _PdfDictionary) {
              dictionary = holder;
            }
          }
        }
      }
      _fontGlyphWidth = <int, int>{};
      _PdfArray? w;
      int index = 0;
      int endIndex = 0;
      _PdfArray? widthArray;
      if (dictionary.containsKey(_DictionaryProperties.w)) {
        _IPdfPrimitive? holder = dictionary[_DictionaryProperties.w];
        if (holder is _PdfArray) {
          w = holder;
        } else if (holder is _PdfReferenceHolder) {
          holder = holder.object;
          if (holder != null && holder is _PdfArray) {
            w = holder;
          }
        }
      }
      if (dictionary.containsKey(_DictionaryProperties.dw)) {
        final _IPdfPrimitive? holder = dictionary[_DictionaryProperties.dw];
        if (holder is _PdfNumber) {
          defaultGlyphWidth = holder.value!.toDouble();
        }
      }
      try {
        if (w == null) {
          return;
        }
        for (int i = 0; i < w.count;) {
          if (w[i] is _PdfNumber) {
            index = (w[i]! as _PdfNumber).value!.toInt();
          }
          i++;
          if (w[i] is _PdfArray) {
            widthArray = w[i]! as _PdfArray;
            for (int j = 0; j < widthArray.count; j++) {
              if (!_containsCmap) {
                _fontGlyphWidth![index] =
                    (widthArray[j]! as _PdfNumber).value!.toInt();
              } else if (!_fontGlyphWidth!.containsKey(index)) {
                _fontGlyphWidth![index] =
                    (widthArray[j]! as _PdfNumber).value!.toInt();
              }
              index++;
            }
          } else if (w[i] is _PdfNumber) {
            endIndex = (w[i]! as _PdfNumber).value!.toInt();
            i++;
            for (; index <= endIndex; index++) {
              if (!_fontGlyphWidth!.containsKey(index)) {
                _fontGlyphWidth![index] = (w[i]! as _PdfNumber).value!.toInt();
              }
            }
          } else if (w[i] is _PdfReferenceHolder) {
            widthArray = (w[i]! as _PdfReferenceHolder).object as _PdfArray?;
            for (int j = 0; j < widthArray!.count; j++) {
              if (!_containsCmap) {
                _fontGlyphWidth![index] =
                    (widthArray[j]! as _PdfNumber).value!.toInt();
              } else {
                if (!_fontGlyphWidth!.containsKey(index)) {
                  _fontGlyphWidth![index] =
                      (widthArray[j]! as _PdfNumber).value!.toInt();
                }
              }
              index++;
            }
          }
          i++;
        }
      } catch (e) {
        _fontGlyphWidth = null;
      }
      w = null;
      widthArray = null;
    }
  }

  void _getGlyphWidthsNonIdH() {
    int firstChar = 0;
    final _PdfDictionary dictionary = fontDictionary;
    if (dictionary.containsKey(_DictionaryProperties.dw)) {
      defaultGlyphWidth = (dictionary[_DictionaryProperties.dw]! as _PdfNumber)
          .value!
          .toDouble();
    }
    if (dictionary.containsKey(_DictionaryProperties.firstChar)) {
      firstChar = (dictionary[_DictionaryProperties.firstChar]! as _PdfNumber)
          .value!
          .toInt();
    }
    _fontGlyphWidth = <int, int>{};
    _PdfArray? w;
    int index = 0;
    if (dictionary.containsKey(_DictionaryProperties.widths)) {
      _IPdfPrimitive? primitive = dictionary[_DictionaryProperties.widths];
      if (primitive is _PdfArray) {
        w = primitive;
      } else if (primitive is _PdfReferenceHolder) {
        primitive = primitive.object;
        if (primitive != null && primitive is _PdfArray) {
          w = primitive;
        }
      }
    }
    if (dictionary.containsKey(_DictionaryProperties.descendantFonts)) {
      _IPdfPrimitive? primitive =
          dictionary[_DictionaryProperties.descendantFonts];
      if (primitive != null && primitive is _PdfArray) {
        final _PdfArray descendantdicArray = primitive;
        if (descendantdicArray.count > 0 &&
            descendantdicArray[0] is _PdfReferenceHolder) {
          primitive = (descendantdicArray[0]! as _PdfReferenceHolder).object;
          if (primitive != null && primitive is _PdfDictionary) {
            final _PdfDictionary descendantDictionary = primitive;
            if (descendantDictionary.containsKey(_DictionaryProperties.w)) {
              primitive = descendantDictionary[_DictionaryProperties.w];
              if (primitive is _PdfArray) {
                w = primitive;
              }
            }
          }
        }
      }
    }

    if (w != null) {
      try {
        for (int i = 0; i < w.count; i++) {
          index = firstChar + i;
          if (characterMapTable.isNotEmpty ||
              differencesDictionary.isNotEmpty) {
            if (characterMapTable.containsKey(index)) {
              if (!_fontGlyphWidth!.containsKey(index)) {
                _fontGlyphWidth![index] = (w[i]! as _PdfNumber).value!.toInt();
              }
            } else if (differencesDictionary.containsKey(index.toString())) {
              if (!_fontGlyphWidth!.containsKey(index)) {
                _fontGlyphWidth![index] = (w[i]! as _PdfNumber).value!.toInt();
              }
            } else if (!_fontGlyphWidth!.containsKey(index)) {
              _fontGlyphWidth![index] = (w[i]! as _PdfNumber).value!.toInt();
            }
          } else if (w[i] is _PdfArray) {
            final _PdfArray tempW = w[i]! as _PdfArray;
            for (int j = i; j < tempW.count; j++) {
              index = firstChar + j;
              if (characterMapTable.isNotEmpty ||
                  differencesDictionary.isNotEmpty) {
                if (characterMapTable.containsKey(index)) {
                  final String mappingString = characterMapTable[index]!;
                  final int entryValue = mappingString.codeUnitAt(0);
                  if (!_fontGlyphWidth!.containsKey(entryValue)) {
                    _fontGlyphWidth![entryValue] =
                        (tempW[j]! as _PdfNumber).value!.toInt();
                  }
                } else if (differencesDictionary
                    .containsKey(index.toString())) {
                  if (!_fontGlyphWidth!.containsKey(index)) {
                    _fontGlyphWidth![index] =
                        (tempW[j]! as _PdfNumber).value!.toInt();
                  }
                } else {
                  if (!_fontGlyphWidth!.containsKey(index)) {
                    _fontGlyphWidth![index] =
                        (tempW[j]! as _PdfNumber).value!.toInt();
                  }
                }
              } else {
                _fontGlyphWidth![index] =
                    (tempW[j]! as _PdfNumber).value!.toInt();
              }
            }
          } else {
            final int value = (w[i]! as _PdfNumber).value!.toInt();
            if (!_fontGlyphWidth!.containsKey(index)) {
              _fontGlyphWidth![index] = value;
            }
          }
        }
      } catch (e) {
        _fontGlyphWidth = null;
      }
    }
  }

  bool _checkStandardFont() {
    bool result = !_checkStandardFontDictionary();
    if (result && fontDictionary.containsKey(_DictionaryProperties.baseFont)) {
      _IPdfPrimitive? primitive =
          fontDictionary[_DictionaryProperties.baseFont];
      _PdfName? baseFont;
      if (primitive is _PdfName) {
        baseFont = primitive;
      } else if (primitive is _PdfReferenceHolder) {
        primitive = primitive.object;
        if (primitive != null && primitive is _PdfName) {
          baseFont = primitive;
        }
      }
      if (baseFont != null) {
        _standardFontName = baseFont._name;
        result &=
            standardFontNames.contains(_resolveFontName(_standardFontName));
      } else {
        result = false;
      }
    } else {
      result = false;
    }
    return result;
  }

  bool _checkStandardCJKFont() {
    bool result = !_checkStandardFontDictionary();
    if (result && fontDictionary.containsKey(_DictionaryProperties.baseFont)) {
      _IPdfPrimitive? primitive =
          fontDictionary[_DictionaryProperties.baseFont];
      _PdfName? baseFont;
      if (primitive is _PdfName) {
        baseFont = primitive;
      } else if (primitive is _PdfReferenceHolder) {
        primitive = primitive.object;
        if (primitive != null && primitive is _PdfName) {
          baseFont = primitive;
        }
      }
      if (baseFont != null) {
        _standardCJKFontName = baseFont._name;
        _PdfName? encoding;
        if (fontDictionary.containsKey(_DictionaryProperties.encoding)) {
          primitive = fontDictionary[_DictionaryProperties.encoding];
          if (primitive is _PdfName) {
            encoding = primitive;
          } else if (primitive is _PdfReferenceHolder) {
            primitive = primitive.object;
            if (primitive != null && primitive is _PdfName) {
              encoding = primitive;
            }
          }
        }
        result &= encoding != null && cjkEncoding.contains(encoding._name);
        result &= _standardCJKFontName != '' &&
            standardCJKFontNames.contains(_standardCJKFontName);
      } else {
        result = false;
      }
    } else {
      result = false;
    }
    return result;
  }

  String _resolveFontName(String? fontName) {
    final String tempFontName = fontName.toString();
    if (tempFontName.contains('times') || tempFontName.contains('Times')) {
      return 'Times New Roman';
    }
    if (tempFontName.contains('Helvetica')) {
      return 'Helvetica';
    }
    return tempFontName;
  }

  bool _checkStandardFontDictionary() {
    return fontDictionary.containsKey(_DictionaryProperties.widths) ||
        fontDictionary.containsKey(_DictionaryProperties.firstChar) ||
        fontDictionary.containsKey(_DictionaryProperties.lastChar) ||
        fontDictionary.containsKey(_DictionaryProperties.fontDescriptor);
  }

  PdfFont? _createStandardFont(double size) {
    if (_standardFontName != '') {
      final PdfFontFamily fontFamily = _getFontFamily(_standardFontName!);
      final List<PdfFontStyle> styles = _getFontStyle(_standardFontName!);
      if (styles.contains(PdfFontStyle.bold) &&
          styles.contains(PdfFontStyle.italic)) {
        font = PdfStandardFont(fontFamily, size,
            multiStyle: <PdfFontStyle>[PdfFontStyle.bold, PdfFontStyle.italic]);
      } else if (styles.contains(PdfFontStyle.bold)) {
        font = PdfStandardFont(fontFamily, size, style: PdfFontStyle.bold);
      } else if (styles.contains(PdfFontStyle.italic)) {
        font = PdfStandardFont(fontFamily, size, style: PdfFontStyle.italic);
      } else {
        font = PdfStandardFont(fontFamily, size);
      }
    }
    return font;
  }

  PdfFont? _createStandardCJKFont(double size) {
    if (_standardCJKFontName != '') {
      final PdfCjkFontFamily fontFamily =
          _getCJKFontFamily(_standardCJKFontName!);
      final List<PdfFontStyle> styles = _getCJKFontStyle(_standardCJKFontName!);
      if (styles.contains(PdfFontStyle.bold) &&
          styles.contains(PdfFontStyle.italic)) {
        font = PdfCjkStandardFont(fontFamily, size,
            multiStyle: <PdfFontStyle>[PdfFontStyle.bold, PdfFontStyle.italic]);
      } else if (styles.contains(PdfFontStyle.bold)) {
        font = PdfCjkStandardFont(fontFamily, size, style: PdfFontStyle.bold);
      } else if (styles.contains(PdfFontStyle.italic)) {
        font = PdfCjkStandardFont(fontFamily, size, style: PdfFontStyle.italic);
      } else {
        font = PdfCjkStandardFont(fontFamily, size);
      }
    }
    return font;
  }

  PdfFontFamily _getFontFamily(String fontName) {
    PdfFontFamily fontFamily;
    if (fontName.contains('-')) {
      fontName = fontName.split('-')[0];
    }
    switch (fontName) {
      case 'Times':
        fontFamily = PdfFontFamily.timesRoman;
        break;
      case 'Helvetica':
        fontFamily = PdfFontFamily.helvetica;
        break;
      case 'Courier':
        fontFamily = PdfFontFamily.courier;
        break;
      case 'Symbol':
        fontFamily = PdfFontFamily.symbol;
        break;
      case 'ZapfDingbats':
        fontFamily = PdfFontFamily.zapfDingbats;
        break;
      default:
        throw ArgumentError.value(fontName, 'fontName', 'invalid font name');
    }
    return fontFamily;
  }

  PdfCjkFontFamily _getCJKFontFamily(String fontName) {
    PdfCjkFontFamily fontFamily;
    if (fontName.contains(',')) {
      fontName = fontName.split(',')[0];
    }
    switch (fontName) {
      case 'HYGoThic-Medium':
        fontFamily = PdfCjkFontFamily.hanyangSystemsGothicMedium;
        break;
      case 'MHei-Medium':
        fontFamily = PdfCjkFontFamily.monotypeHeiMedium;
        break;
      case 'MSung-Light':
        fontFamily = PdfCjkFontFamily.monotypeSungLight;
        break;
      case 'STSong-Light':
        fontFamily = PdfCjkFontFamily.sinoTypeSongLight;
        break;
      case 'HeiseiMin-W3':
        fontFamily = PdfCjkFontFamily.heiseiMinchoW3;
        break;
      case 'HeiseiKakuGo-W5':
        fontFamily = PdfCjkFontFamily.heiseiKakuGothicW5;
        break;
      case 'HYSMyeongJo-Medium':
        fontFamily = PdfCjkFontFamily.hanyangSystemsShinMyeongJoMedium;
        break;
      default:
        throw ArgumentError.value(fontName, 'fontName', 'invalid font name');
    }
    return fontFamily;
  }

  // Extracts the font encoding associated with the text string
  // Font style.
  String? getFontEncoding() {
    _PdfName? baseFont = _PdfName();
    String? fontEncoding = '';
    if (fontDictionary.containsKey(_DictionaryProperties.encoding)) {
      if (fontDictionary[_DictionaryProperties.encoding] is _PdfName) {
        baseFont = fontDictionary[_DictionaryProperties.encoding] as _PdfName?;
        fontEncoding = baseFont!._name;
      } else {
        _PdfDictionary? baseFontDict = _PdfDictionary();
        if (fontDictionary[_DictionaryProperties.encoding] is _PdfDictionary) {
          baseFontDict =
              fontDictionary[_DictionaryProperties.encoding] as _PdfDictionary?;
          if (baseFontDict == null) {
            baseFont = (fontDictionary[_DictionaryProperties.encoding]!
                    as _PdfReferenceHolder)
                .object as _PdfName?;
            fontEncoding = baseFont!._name;
          }
        } else if (fontDictionary[_DictionaryProperties.encoding]
            is _PdfReferenceHolder) {
          baseFontDict = (fontDictionary[_DictionaryProperties.encoding]!
                  as _PdfReferenceHolder)
              .object as _PdfDictionary?;
        }
        if (baseFontDict != null &&
            baseFontDict.containsKey(_DictionaryProperties.type)) {
          fontEncoding =
              (baseFontDict[_DictionaryProperties.type]! as _PdfName)._name;
        }
      }
    }
    if (fontEncoding == 'CMap') {
      fontEncoding = 'Identity-H';
    }
    return fontEncoding;
  }

  Map<String, double>? getReverseMapTable() {
    _reverseMapTable = <String, double>{};
    characterMapTable.forEach((double k, String v) {
      if (!_reverseMapTable!.containsKey(v)) {
        _reverseMapTable![v] = k;
      }
    });
    return _reverseMapTable;
  }

  // Extracts the font name associated with the string.
  String? getFontName() {
    String? fontName = '';
    isSystemFontExist = false;
    if (fontDictionary.containsKey(_DictionaryProperties.baseFont)) {
      _PdfName? baseFont =
          fontDictionary[_DictionaryProperties.baseFont] as _PdfName?;
      baseFont ??= (fontDictionary[_DictionaryProperties.baseFont]!
              as _PdfReferenceHolder)
          .object as _PdfName?;
      String font = baseFont!._name!;
      if (font.contains('#20') && !font.contains('+')) {
        final int startIndex = font.lastIndexOf('#20');
        font = font.substring(0, startIndex);
        font = font + '+';
      }
      if (font.contains('+')) {}
      if (!isSystemFontExist) {
        if (baseFont._name!.contains('+')) {
          fontName = baseFont._name!.split('+')[1];
        } else {
          fontName = baseFont._name;
        }

        if (fontName!.contains('-')) {
          fontName = fontName.split('-')[0];
        } else if (fontName.contains(',')) {
          fontName = fontName.split(',')[0];
        }
        if (fontName.contains('MT')) {
          fontName = fontName.replaceAll('MT', '');
        }
        if (fontName.contains('#20')) {
          fontName = fontName.replaceAll('#20', ' ');
        }
        if (fontName.contains('#')) {
          fontName = decodeHexFontName(fontName);
        }
      }
    }
    return fontName;
  }

  List<PdfFontStyle> getFontStyle() {
    List<PdfFontStyle> styles = <PdfFontStyle>[];
    if (fontDictionary.containsKey(_DictionaryProperties.baseFont)) {
      _IPdfPrimitive? primitive =
          fontDictionary[_DictionaryProperties.baseFont];
      _PdfName? baseFont;
      if (primitive is _PdfName) {
        baseFont = primitive;
      } else if (primitive is _PdfReferenceHolder) {
        primitive = primitive.object;
        if (primitive is _PdfName) {
          baseFont = primitive;
        }
      }
      if (baseFont != null) {
        styles = _getFontStyle(baseFont._name!);
      }
    }
    if (styles.isEmpty) {
      styles.add(PdfFontStyle.regular);
    }
    return styles;
  }

  List<PdfFontStyle> _getCJKFontStyle(String baseFont) {
    final List<PdfFontStyle> styles = <PdfFontStyle>[];
    String style = '';
    if (baseFont.contains(',')) {
      style = baseFont.split(',')[1];
    }
    switch (style) {
      case 'Italic':
        styles.add(PdfFontStyle.italic);
        break;
      case 'Bold':
        styles.add(PdfFontStyle.bold);
        break;
      case 'BoldItalic':
        styles.add(PdfFontStyle.bold);
        styles.add(PdfFontStyle.italic);
        break;
      default:
        styles.add(PdfFontStyle.regular);
    }
    return styles;
  }

  List<PdfFontStyle> _getFontStyle(String baseFont) {
    final List<PdfFontStyle> styles = <PdfFontStyle>[];
    if (baseFont.contains('-') || baseFont.contains(',')) {
      String style = '';
      if (baseFont.contains('-')) {
        style = baseFont.split('-')[1];
      } else if (baseFont.contains(',')) {
        style = baseFont.split(',')[1];
      }
      style = style.replaceAll('MT', '');
      switch (style) {
        case 'Italic':
        case 'Oblique':
          styles.add(PdfFontStyle.italic);
          break;
        case 'Bold':
          styles.add(PdfFontStyle.bold);
          break;
        case 'BoldItalic':
        case 'BoldOblique':
          styles.add(PdfFontStyle.bold);
          styles.add(PdfFontStyle.italic);
          break;
        default:
          styles.add(PdfFontStyle.regular);
      }
    } else {
      if (baseFont.contains('Bold')) {
        styles.add(PdfFontStyle.bold);
      }
      if (baseFont.contains('BoldItalic') || baseFont.contains('BoldOblique')) {
        styles.add(PdfFontStyle.bold);
        styles.add(PdfFontStyle.italic);
      }
      if (baseFont.contains('Italic') || baseFont.contains('Oblique')) {
        styles.add(PdfFontStyle.italic);
      }
    }
    if (styles.isEmpty) {
      styles.add(PdfFontStyle.regular);
    }
    return styles;
  }

  String decodeHexFontName(String fontName) {
    String? newFontname;
    for (int i = 0; i < fontName.length; i++) {
      if (fontName[i] == '#') {
        final String hexValue =
            fontName[i + 1].toString() + fontName[i + 2].toString();
        final int decimalValue = int.parse(hexValue, radix: 16);
        if (decimalValue != 0) {
          final String charValue = String.fromCharCode(decimalValue);
          newFontname = fontName.replaceAll(
              '#' + hexValue.toString(), charValue.toString());
          i = i + 2;
        }
        if (!fontName.toString().contains('#')) {
          break;
        }
      }
    }
    return newFontname.toString();
  }

  // Builds the mapping table that is used to map the
  // decoded text to get the expected text.
  // Returns a Map with key as the encoded
  // element and value as the value to be mapped to.
  Map<double, String> getCharacterMapTable() {
    int endOfTable = 0;
    final Map<double, String> mapTable = <double, String>{};
    if (fontDictionary.containsKey(_DictionaryProperties.toUnicode)) {
      _IPdfPrimitive? unicodeMap =
          fontDictionary[_DictionaryProperties.toUnicode];

      _PdfStream? mapStream;
      if (unicodeMap is _PdfReferenceHolder) {
        mapStream = unicodeMap.object as _PdfStream?;
      } else {
        mapStream = unicodeMap as _PdfStream?;
      }
      unicodeMap = null;
      if (mapStream != null) {
        mapStream._decompress();
        mapStream._isChanged = false;
        final String text = utf8.decode(mapStream._dataStream!);
        bool isBfRange = false, isBfChar = false;
        int start, end, startCmap, endCmap, endPointer;
        startCmap = text.indexOf('begincmap');
        endCmap = text.indexOf('endcmap');
        endPointer = startCmap;
        start = startCmap;
        end = endCmap;
        if (endPointer == -1) {
          return mapTable;
        }
        while (true) {
          if (!isBfRange) {
            start = text.indexOf('beginbfchar', endPointer);
            if (start < 0) {
              isBfChar = false;
              start = startCmap;
              endPointer = startCmap;
              end = endCmap;
            } else {
              end = text.indexOf('endbfchar', start);
              endPointer = end;
              isBfChar = true;
            }
          }
          if (!isBfChar) {
            final int bfrangestart = text.indexOf('beginbfrange', endPointer);

            if (bfrangestart < 0) {
              isBfRange = false;
            } else {
              final int bfrangeend = text.indexOf('endbfrange', endPointer + 5);
              start = bfrangestart;
              end = bfrangeend;
              endPointer = end;
              isBfRange = true;
            }
          }
          if (isBfChar || isBfRange) {
            final String sub = text.substring(start, end);
            if (isBfChar) {
              final List<String> tableEntry = sub.split(RegExp('[\n-\r]'));
              if (!tableEntry[0].contains('\n') &&
                  !tableEntry[0].contains('\r')) {
                List<String> tempTmp = <String>[];
                for (int j = 0; j < tableEntry.length; j++) {
                  tempTmp = getHexCode(tableEntry[j]);
                  final int c = tempTmp.length;
                  for (int k = 0; k < c / 2; k++) {
                    if (tempTmp.length >= 2) {
                      final List<String> tmpList = <String>[];
                      tmpList.add(tempTmp[0]);
                      tmpList.add(tempTmp[1]);
                      tempTmp.remove(tempTmp[0]);
                      tempTmp.remove(tempTmp[0]);
                      if (tmpList.length > 1) {
                        if (tmpList[1].length > 4) {
                          String tableValue = tmpList[1];
                          tableValue = tableValue.replaceAll(' ', '');
                          String mapValue = '';
                          final int numberOfCharacters = tableValue.length ~/ 4;
                          for (int j2 = 0; j2 < numberOfCharacters; j2++) {
                            final String mapChar = String.fromCharCode(
                                int.parse(tableValue.substring(0, 4), radix: 16)
                                    .toSigned(64));
                            tableValue = tableValue.substring(4);
                            mapValue += mapChar.toString();
                          }
                          mapValue = checkContainInvalidChar(mapValue);
                          if (!mapTable.containsKey(
                              int.parse(tmpList[0], radix: 16).toSigned(64))) {
                            mapTable[int.parse(tmpList[0], radix: 16)
                                .toSigned(64)
                                .toDouble()] = mapValue.toString();
                          }
                          continue;
                        }
                        if (!mapTable.containsKey(
                            int.parse(tmpList[0], radix: 16).toSigned(64))) {
                          final String mapValue = String.fromCharCode(
                              int.parse(tmpList[1], radix: 16).toSigned(64));
                          mapTable[int.parse(tmpList[0], radix: 16)
                              .toSigned(64)
                              .toDouble()] = mapValue.toString();
                        }
                      }
                    }
                  }
                }
              } else {
                for (int i = 0; i < tableEntry.length; i++) {
                  tempStringList = getHexCode(tableEntry[i]);
                  if (tempStringList.length > 1) {
                    if (tempStringList[1].length > 4) {
                      String tableValue = tempStringList[1];
                      tableValue = tableValue.replaceAll(' ', '');
                      String mapValue = '';
                      final int numberOfCharacters = tableValue.length ~/ 4;
                      for (int j = 0; j < numberOfCharacters; j++) {
                        final String mapChar = String.fromCharCode(
                            int.parse(tableValue.substring(0, 4), radix: 16)
                                .toSigned(64));
                        tableValue = tableValue.substring(4);
                        mapValue += mapChar.toString();
                      }
                      mapValue = checkContainInvalidChar(mapValue);
                      if (!mapTable.containsKey(
                          int.parse(tempStringList[0], radix: 16)
                              .toSigned(64))) {
                        mapTable[int.parse(tempStringList[0], radix: 16)
                            .toSigned(64)
                            .toDouble()] = mapValue.toString();
                      }
                      continue;
                    }
                    if (!mapTable.containsKey(
                        int.parse(tempStringList[0]).toSigned(64))) {
                      final String mapValue = String.fromCharCode(
                          int.parse(tempStringList[1], radix: 16).toSigned(64));
                      mapTable[int.parse(tempStringList[0], radix: 16)
                          .toSigned(64)
                          .toDouble()] = mapValue.toString();
                    }
                  }
                }
              }
            } else if (isBfRange) {
              double startRange, endRange;
              final List<String> tableEntry = sub.split(RegExp('[\n-\r]'));
              String str = ' ';
              for (int i = 0; i < tableEntry.length; i++) {
                if (tableEntry[i].contains('[')) {
                  final int subArrayStatIndex = tableEntry[i].indexOf('[');
                  final int subArrayEndIndex = tableEntry[i].indexOf(']');
                  if (subArrayEndIndex == -1) {
                    str = tableEntry[i]
                        .substring(subArrayStatIndex, tableEntry[i].length);
                    i++;
                    while (true) {
                      if (tableEntry[i].contains(']')) {
                        str += tableEntry[i]
                            .substring(0, tableEntry[i].indexOf(']'));
                        break;
                      } else {
                        str += tableEntry[i];
                        i++;
                      }
                    }
                  } else {
                    str = tableEntry[i]
                        .substring(subArrayStatIndex, subArrayEndIndex);
                  }
                  List<String> subArray = <String>[];
                  subArray = getHexCode(str);
                  String tableEntryValue = ' ';
                  if (subArrayEndIndex == -1) {
                    for (int j = endOfTable + 1; j <= i; j++) {
                      tableEntryValue += tableEntry[j];
                    }
                    tempStringList = getHexCode(tableEntryValue);
                  } else {
                    tempStringList = getHexCode(tableEntry[i]);
                  }
                  endOfTable = i;
                  if (tempStringList.length > 1) {
                    startRange = int.parse(tempStringList[0], radix: 16)
                        .toSigned(64)
                        .toDouble();
                    endRange = int.parse(tempStringList[1], radix: 16)
                        .toSigned(64)
                        .toDouble();
                    int t = 0;
                    for (double j = startRange, k = 0;
                        j <= endRange;
                        j++, k++, t++) {
                      String mapString = '';
                      int l = 0;
                      while (l < subArray[t].length) {
                        final String mapValueHex =
                            subArray[t].substring(l, l + 4);
                        final int hexEquivalent =
                            int.parse(mapValueHex, radix: 16).toSigned(64);
                        final int hex = hexEquivalent;
                        final String hexString = hex.toRadixString(16);
                        final int mapValue =
                            int.parse(hexString, radix: 16).toSigned(64);
                        final String mapChar = String.fromCharCode(mapValue);
                        mapString += mapChar;
                        l += 4;
                      }
                      if (!mapTable.containsKey(j)) {
                        mapTable[j] = mapString;
                      }
                    }
                  }
                } else {
                  tempStringList = getHexCode(tableEntry[i]);
                  if (tempStringList.length == 3) {
                    startRange = int.parse(tempStringList[0], radix: 16)
                        .toSigned(64)
                        .toDouble();
                    endRange = int.parse(tempStringList[1], radix: 16)
                        .toSigned(64)
                        .toDouble();
                    String mapValueHex = tempStringList[2];
                    if (tempStringList[2].length > 4) {
                      final String mapFirstHex = mapValueHex.substring(0, 4);
                      final int hexFirstEquivalent =
                          int.parse(mapFirstHex, radix: 16).toSigned(64);
                      final int mapFirstValue = int.parse(
                              hexFirstEquivalent.toRadixString(16),
                              radix: 16)
                          .toSigned(64);
                      final String mapFirstChar =
                          String.fromCharCode(mapFirstValue);
                      mapValueHex = mapValueHex.substring(5, 8);
                      final int hexEquivalent =
                          int.parse(mapValueHex, radix: 16).toSigned(64);
                      for (double j = startRange, k = 0;
                          j <= endRange;
                          j++, k++) {
                        final int hex = hexEquivalent + k.toInt();
                        final String hexString = hex.toRadixString(16);
                        final int mapValue =
                            int.parse(hexString, radix: 16).toSigned(64);
                        String mapChar =
                            mapFirstChar + String.fromCharCode(mapValue);
                        mapChar = checkContainInvalidChar(mapChar);
                        if (!mapTable.containsKey(j)) {
                          mapTable[j] = mapChar.toString();
                        }
                      }
                    } else {
                      final int hexEquivalent =
                          int.parse(mapValueHex, radix: 16).toSigned(64);
                      for (double j = startRange, k = 0;
                          j <= endRange;
                          j++, k++) {
                        final int hex = hexEquivalent + k.toInt();
                        final String hexString = hex.toRadixString(16);
                        final int mapValue =
                            int.parse(hexString, radix: 16).toSigned(64);
                        final String mapChar = String.fromCharCode(mapValue);
                        if (!mapTable.containsKey(j)) {
                          mapTable[j] = mapChar.toString();
                        }
                      }
                    }
                  } else if (tempStringList.length > 1) {
                    int semiCount;
                    semiCount = tempStringList.length;
                    for (int k = 0; k < semiCount;) {
                      final String mapValue = String.fromCharCode(
                          int.parse(tempStringList[k + 2], radix: 16)
                              .toSigned(64));
                      mapTable[int.parse(tempStringList[k], radix: 16)
                          .toSigned(64)
                          .toDouble()] = mapValue.toString();
                      k = k + 3;
                    }
                  }
                }
              }
            }
          } else {
            break;
          }
        }
      }
      mapStream = null;
    }
    if (isSameFont == true) {
      mapTable.forEach((double k, String v) {
        if (!tempMapTable.containsKey(k)) {
          tempMapTable[k] = v;
        } else {
          tempMapTable.remove(k);
          tempMapTable[k] = v;
        }
      });
    }
    return mapTable;
  }

// Builds the mapping table that is used to map the decoded
// text to get the expected text.
  Map<String, String?> getDifferencesDictionary() {
    final Map<String, String?> differencesDictionary = <String, String?>{};
    _PdfDictionary? encodingDictionary;

    if (fontDictionary.containsKey(_DictionaryProperties.encoding)) {
      if (fontDictionary[_DictionaryProperties.encoding]
          is _PdfReferenceHolder) {
        encodingDictionary = (fontDictionary[_DictionaryProperties.encoding]!
                as _PdfReferenceHolder)
            .object as _PdfDictionary?;
      } else if (fontDictionary[_DictionaryProperties.encoding]
          is _PdfDictionary) {
        encodingDictionary =
            fontDictionary[_DictionaryProperties.encoding] as _PdfDictionary?;
      }

      if (encodingDictionary != null) {
        if (encodingDictionary.containsKey(_DictionaryProperties.differences)) {
          int differenceCount = 0;
          final _IPdfPrimitive? obj =
              encodingDictionary[_DictionaryProperties.differences];
          _PdfArray? differences;
          if (obj is _PdfArray) {
            differences = obj;
          } else if (obj is _PdfReferenceHolder && obj.object is _PdfArray) {
            differences = obj.object as _PdfArray?;
          }
          if (differences != null) {
            for (int i = 0; i < differences.count; i++) {
              String? text = '';
              if (differences[i] is _PdfNumber) {
                final _PdfNumber number = differences[i]! as _PdfNumber;
                text = number.value.toString();
                differenceCount = number.value!.toInt();
              } else if (differences[i] is _PdfName) {
                text = (differences[i]! as _PdfName)._name;
                if ((fontType!._name == 'Type1') && (text == '.notdef')) {
                  text = ' ';
                  differencesDictionary[differenceCount.toString()] =
                      getLatinCharacter(text);
                  differenceCount++;
                } else {
                  text = getLatinCharacter(text);
                  text = getSpecialCharacter(text);
                  if (!differencesDictionary
                      .containsKey(differenceCount.toString())) {
                    differencesDictionary[differenceCount.toString()] =
                        getLatinCharacter(text);
                  }
                  differenceCount++;
                }
              }
            }
            differences = null;
          }
        }
      }
    }
    encodingDictionary = null;
    return differencesDictionary;
  }

  //  Gets Latin Character
  //Latin Character Set (APPENDIX D Pdf version-1.7) Page- 997
  String? getLatinCharacter(String? decodedCharacter) {
    switch (decodedCharacter) {
      case 'zero':
        return '0';
      case 'one':
        return '1';
      case 'two':
        return '2';
      case 'three':
        return '3';
      case 'four':
        return '4';
      case 'five':
        return '5';
      case 'six':
        return '6';
      case 'seven':
        return '7';
      case 'eight':
        return '8';
      case 'nine':
        return '9';
      case 'aacute':
        return 'á';
      case 'asciicircum':
        return '^';
      case 'asciitilde':
        return '~';
      case 'asterisk':
        return '*';
      case 'at':
        return '@';
      case 'atilde':
        return 'ã';
      case 'backslash':
        return r'\';
      case 'bar':
        return '|';
      case 'braceleft':
        return '{';
      case 'braceright':
        return '}';
      case 'bracketleft':
        return '[';
      case 'bracketright':
        return ']';
      case 'breve':
        return '˘';
      case 'brokenbar':
        return '|';
      case 'bullet3':
        return '•';
      case 'bullet':
        return '•';
      case 'caron':
        return 'ˇ';
      case 'ccedilla':
        return 'ç';
      case 'cedilla':
        return '¸';
      case 'cent':
        return '¢';
      case 'circumflex':
        return 'ˆ';
      case 'colon':
        return ':';
      case 'comma':
        return ',';
      case 'copyright':
        return '©';
      case 'currency1':
        return '¤';
      case 'dagger':
        return '†';
      case 'daggerdbl':
        return '‡';
      case 'degree':
        return '°';
      case 'dieresis':
        return '¨';
      case 'divide':
        return '÷';
      case 'dollar':
        return r'$';
      case 'dotaccent':
        return '˙';
      case 'dotlessi':
        return 'ı';
      case 'eacute':
        return 'é';
      case 'middot':
        return '˙';
      case 'edieresis':
        return 'ë';
      case 'egrave':
        return 'è';
      case 'ellipsis':
        return '...';
      case 'emdash':
        return '—';
      case 'endash':
        return '–';
      case 'equal':
        return '=';
      case 'eth':
        return 'ð';
      case 'exclam':
        return '!';
      case 'exclamdown':
        return '¡';
      //case 'fi':
      //    return 'fl';
      case 'florin':
        return 'ƒ';
      case 'fraction':
        return '⁄';
      case 'germandbls':
        return 'ß';
      case 'grave':
        return '`';
      case 'greater':
        return '>';
      case 'guillemotleft4':
        return '«';
      case 'guillemotright4':
        return '»';
      case 'guilsinglleft':
        return '‹';
      case 'guilsinglright':
        return '›';
      case 'hungarumlaut':
        return '˝';
      case 'hyphen5':
        return '-';
      case 'iacute':
        return 'í';
      case 'icircumflex':
        return 'î';
      case 'idieresis':
        return 'ï';
      case 'igrave':
        return 'ì';
      case 'less':
        return '<';
      case 'logicalnot':
        return '¬';
      case 'lslash':
        return 'ł';
      case 'Lslash':
        return 'Ł';
      case 'macron':
        return '¯';
      case 'minus':
        return '−';
      case 'mu':
        return 'μ';
      case 'multiply':
        return '×';
      case 'ntilde':
        return 'ñ';
      case 'numbersign':
        return '#';
      case 'oacute':
        return 'ó';
      case 'ocircumflex':
        return 'ô';
      case 'odieresis':
        return 'ö';
      case 'oe':
        return 'oe';
      case 'ogonek':
        return '˛';
      case 'ograve':
        return 'ò';
      case 'onehalf':
        return '1/2';
      case 'onequarter':
        return '1/4';
      case 'onesuperior':
        return '¹';
      case 'ordfeminine':
        return 'ª';
      case 'ordmasculine':
        return 'º';
      case 'otilde':
        return 'õ';
      case 'paragraph':
        return '¶';
      case 'parenleft':
        return '(';
      case 'parenright':
        return ')';
      case 'percent':
        return '%';
      case 'period':
        return '.';
      case 'periodcentered':
        return '·';
      case 'perthousand':
        return '‰';
      case 'plus':
        return '+';
      case 'plusminus':
        return '±';
      case 'question':
        return '?';
      case 'questiondown':
        return '¿';
      case 'quotedbl':
        return '"';
      case 'quotedblbase':
        return '„';
      case 'quotedblleft':
        return '“';
      case 'quotedblright':
        return '”';
      case 'quoteleft':
        return '‘';
      case 'quoteright':
        return '’';
      case 'quotesinglbase':
        return '‚';
      case 'quotesingle':
        return "'";
      case 'registered':
        return '®';
      case 'ring':
        return '˚';
      case 'scaron':
        return 'š';
      case 'section':
        return '§';
      case 'semicolon':
        return ';';
      case 'slash':
        return '/';
      case 'space6':
        return ' ';
      case 'space':
        return ' ';
      case 'udieresis':
        return 'ü';
      case 'uacute':
        return 'ú';
      case 'Ecircumflex':
        return 'Ê';
      case 'hyphen':
        return '-';
      case 'underscore':
        return '_';
      case 'adieresis':
        return 'ä';
      case 'ampersand':
        return '&';
      case 'Adieresis':
        return 'Ä';
      case 'Udieresis':
        return 'Ü';
      case 'ccaron':
        return 'č';
      case 'Scaron':
        return 'Š';
      case 'zcaron':
        return 'ž';
      case 'sterling':
        return '£';
      case 'agrave':
        return 'à';
      case 'ecircumflex':
        return 'ê';
      case 'acircumflex':
        return 'â';
      case 'Oacute':
        return 'Ó';
      default:
        return decodedCharacter;
    }
  }

  //  Gets Latin Character
  //Latin Character Set (APPENDIX D Pdf version-1.7) Page- 997
  String? getSpecialCharacter(String? decodedCharacter) {
    switch (decodedCharacter) {
      case 'head2right':
        return '\u27A2';
      case 'aacute':
        return 'a\u0301';
      case 'eacute':
        return 'e\u0301';
      case 'iacute':
        return 'i\u0301';
      case 'oacute':
        return 'o\u0301';
      case 'uacute':
        return 'u\u0301';
      case 'circleright':
        return '\u27B2';
      case 'bleft':
        return '\u21E6';
      case 'bright':
        return '\u21E8';
      case 'bup':
        return '\u21E7';
      case 'bdown':
        return '\u21E9';
      case 'barb4right':
        return '\u2794';
      case 'bleftright':
        return '\u2B04';
      case 'bupdown':
        return '\u21F3';
      case 'bnw':
        return '\u2B00';
      case 'bne':
        return '\u2B01';
      case 'bsw':
        return '\u2B03';
      case 'bse':
        return '\u2B02';
      case 'bdash1':
        return '\u25AD';
      case 'bdash2':
        return '\u25AB';
      case 'xmarkbld':
        return '\u2717';
      case 'checkbld':
        return '\u2713';
      case 'boxxmarkbld':
        return '\u2612';
      case 'boxcheckbld':
        return '\u2611';
      case 'space':
        return '\u0020';
      case 'pencil':
        return '\u270F';
      case 'scissors':
        return '\u2702';
      case 'scissorscutting':
        return '\u2701';
      case 'readingglasses':
        return '\u2701';
      case 'bell':
        return '\u2701';
      case 'book':
        return '\u2701';
      case 'telephonesolid':
        return '\u2701';
      case 'telhandsetcirc':
        return '\u2701';
      case 'envelopeback':
        return '\u2701';
      case 'hourglass':
        return '\u231B';
      case 'keyboard':
        return '\u2328';
      case 'tapereel':
        return '\u2707';
      case 'handwrite':
        return '\u270D';
      case 'handv':
        return '\u270C';
      case 'handptleft':
        return '\u261C';
      case 'handptright':
        return '\u261E';
      case 'handptup':
        return '\u261D';
      case 'handptdown':
        return '\u261F';
      case 'smileface':
        return '\u263A';
      case 'frownface':
        return '\u2639';
      case 'skullcrossbones':
        return '\u2620';
      case 'flag':
        return '\u2690';
      case 'pennant':
        return '\u1F6A9';
      case 'airplane':
        return '\u2708';
      case 'sunshine':
        return '\u263C';
      case 'droplet':
        return '\u1F4A7';
      case 'snowflake':
        return '\u2744';
      case 'crossshadow':
        return '\u271E';
      case 'crossmaltese':
        return '\u2720';
      case 'starofdavid':
        return '\u2721';
      case 'crescentstar':
        return '\u262A';
      case 'yinyang':
        return '\u262F';
      case 'om':
        return '\u0950';
      case 'wheel':
        return '\u2638';
      case 'aries':
        return '\u2648';
      case 'taurus':
        return '\u2649';
      case 'gemini':
        return '\u264A';
      case 'cancer':
        return '\u264B';
      case 'leo':
        return '\u264C';
      case 'virgo':
        return '\u264D';
      case 'libra':
        return '\u264E';
      case 'scorpio':
        return '\u264F';
      case 'saggitarius':
        return '\u2650';
      case 'capricorn':
        return '\u2651';
      case 'aquarius':
        return '\u2652';
      case 'pisces':
        return '\u2653';
      case 'ampersanditlc':
        return '\u0026';
      case 'ampersandit':
        return '\u0026';
      case 'circle6':
        return '\u25CF';
      case 'circleshadowdwn':
        return '\u274D';
      case 'square6':
        return '\u25A0';
      case 'box3':
        return '\u25A1';
      case 'boxshadowdwn':
        return '\u2751';
      case 'boxshadowup':
        return '\u2752';
      case 'lozenge4':
        return '\u2B27';
      case 'lozenge6':
        return '\u29EB';
      case 'rhombus6':
        return '\u25C6';
      case 'xrhombus':
        return '\u2756';
      case 'rhombus4':
        return '\u2B25';
      case 'clear':
        return '\u2327';
      case 'escape':
        return '\u2353';
      case 'command':
        return '\u2318';
      case 'rosette':
        return '\u2740';
      case 'rosettesolid':
        return '\u273F';
      case 'quotedbllftbld':
        return '\u275D';
      case 'quotedblrtbld':
        return '\u275E';
      case '.notdef':
        return '\u25AF';
      case 'zerosans':
        return '\u24EA';
      case 'onesans':
        return '\u2460';
      case 'twosans':
        return '\u2461';
      case 'threesans':
        return '\u2462';
      case 'foursans':
        return '\u2463';
      case 'fivesans':
        return '\u2464';
      case 'sixsans':
        return '\u2465';
      case 'sevensans':
        return '\u2466';
      case 'eightsans':
        return '\u2467';
      case 'ninesans':
        return '\u2468';
      case 'tensans':
        return '\u2469';
      case 'zerosansinv':
        return '\u24FF';
      case 'onesansinv':
        return '\u2776';
      case 'twosansinv':
        return '\u2777';
      case 'threesansinv':
        return '\u2778';
      case 'foursansinv':
        return '\u2779';
      case 'circle2':
        return '\u00B7';
      case 'circle4':
        return '\u2022';
      case 'square2':
        return '\u25AA';
      case 'ring2':
        return '\u25CB';
      case 'ringbutton2':
        return '\u25C9';
      case 'target':
        return '\u25CE';
      case 'square4':
        return '\u25AA';
      case 'box2':
        return '\u25FB';
      case 'crosstar2':
        return '\u2726';
      case 'pentastar2':
        return '\u2605';
      case 'hexstar2':
        return '\u2736';
      case 'octastar2':
        return '\u2734';
      case 'dodecastar3':
        return '\u2739';
      case 'octastar4':
        return '\u2735';
      case 'registercircle':
        return '\u2316';
      case 'cuspopen':
        return '\u27E1';
      case 'cuspopen1':
        return '\u2311';
      case 'circlestar':
        return '\u2605';
      case 'starshadow':
        return '\u2730';
      case 'deleteleft':
        return '\u232B';
      case 'deleteright':
        return '\u2326';
      case 'scissorsoutline':
        return '\u2704';
      case 'telephone':
        return '\u260F';
      case 'telhandset':
        return '\u1F4DE';
      case 'handptlft1':
        return '\u261C';
      case 'handptrt1':
        return '\u261E';
      case 'handptlftsld1':
        return '\u261A';
      case 'handptrtsld1':
        return '\u261B';
      case 'handptup1':
        return '\u261D';
      case 'handptdwn1':
        return '\u261F';
      case 'xmark':
        return '\u2717';
      case 'check':
        return '\u2713';
      case 'boxcheck':
        return '\u2611';
      case 'boxx':
        return '\u2612';
      case 'boxxbld':
        return '\u2612';
      case 'circlex':
        return '=\u2314';
      case 'circlexbld':
        return '\u2314';
      case 'prohibit':
      case 'prohibitbld':
        return '\u29B8';
      case 'ampersanditaldm':
      case 'ampersandbld':
      case 'ampersandsans':
      case 'ampersandsandm':
        return '\u0026';
      case 'interrobang':
      case 'interrobangdm':
      case 'interrobangsans':
      case 'interrobngsandm':
        return '\u203D';
      case 'sacute':
        return 'ś';
      case 'Sacute':
        return 'Ś';
      case 'eogonek':
        return 'ę';
      case 'cacute':
        return 'ć';
      case 'aogonek':
        return 'ą';
      default:
        return decodedCharacter;
    }
  }

  void getMacEncodeTable() {
    _macEncodeTable = <int, String>{};
    _macEncodeTable![127] = ' ';
    _macEncodeTable![128] = 'Ä';
    _macEncodeTable![129] = 'Å';
    _macEncodeTable![130] = 'Ç';
    _macEncodeTable![131] = 'É';
    _macEncodeTable![132] = 'Ñ';
    _macEncodeTable![133] = 'Ö';
    _macEncodeTable![134] = 'Ü';
    _macEncodeTable![135] = 'á';
    _macEncodeTable![136] = 'à';
    _macEncodeTable![137] = 'â';
    _macEncodeTable![138] = 'ä';
    _macEncodeTable![139] = 'ã';
    _macEncodeTable![140] = 'å';
    _macEncodeTable![141] = 'ç';
    _macEncodeTable![142] = 'é';
    _macEncodeTable![143] = 'è';
    _macEncodeTable![144] = 'ê';
    _macEncodeTable![145] = 'ë';
    _macEncodeTable![146] = 'í';
    _macEncodeTable![147] = 'ì';
    _macEncodeTable![148] = 'î';
    _macEncodeTable![149] = 'ï';
    _macEncodeTable![150] = 'ñ';
    _macEncodeTable![151] = 'ó';
    _macEncodeTable![152] = 'ò';
    _macEncodeTable![153] = 'ô';
    _macEncodeTable![154] = 'ö';
    _macEncodeTable![155] = 'õ';
    _macEncodeTable![156] = 'ú';
    _macEncodeTable![157] = 'ù';
    _macEncodeTable![158] = 'û';
    _macEncodeTable![159] = 'ü';
    _macEncodeTable![160] = '†';
    _macEncodeTable![161] = '°';
    _macEncodeTable![162] = '¢';
    _macEncodeTable![163] = '£';
    _macEncodeTable![164] = '§';
    _macEncodeTable![165] = '•';
    _macEncodeTable![166] = '¶';
    _macEncodeTable![167] = 'ß';
    _macEncodeTable![168] = '®';
    _macEncodeTable![169] = '©';
    _macEncodeTable![170] = '™';
    _macEncodeTable![171] = '´';
    _macEncodeTable![172] = '¨';
    _macEncodeTable![173] = '≠';
    _macEncodeTable![174] = 'Æ';
    _macEncodeTable![175] = 'Ø';
    _macEncodeTable![176] = '∞';
    _macEncodeTable![177] = '±';
    _macEncodeTable![178] = '≤';
    _macEncodeTable![179] = '≥';
    _macEncodeTable![180] = '¥';
    _macEncodeTable![181] = 'µ';
    _macEncodeTable![182] = '∂';
    _macEncodeTable![183] = '∑';
    _macEncodeTable![184] = '∏';
    _macEncodeTable![185] = 'π';
    _macEncodeTable![186] = '∫';
    _macEncodeTable![187] = 'ª';
    _macEncodeTable![188] = 'º';
    _macEncodeTable![189] = 'Ω';
    _macEncodeTable![190] = 'æ';
    _macEncodeTable![191] = 'ø';
    _macEncodeTable![192] = '¿';
    _macEncodeTable![193] = '¡';
    _macEncodeTable![194] = '¬';
    _macEncodeTable![195] = '√';
    _macEncodeTable![196] = 'ƒ';
    _macEncodeTable![197] = '≈';
    _macEncodeTable![198] = '∆';
    _macEncodeTable![199] = '«';
    _macEncodeTable![200] = '»';
    _macEncodeTable![201] = '…';
    _macEncodeTable![202] = ' ';
    _macEncodeTable![203] = 'À';
    _macEncodeTable![204] = 'Ã';
    _macEncodeTable![205] = 'Õ';
    _macEncodeTable![206] = 'Œ';
    _macEncodeTable![207] = 'œ';
    _macEncodeTable![208] = '–';
    _macEncodeTable![209] = '—';
    _macEncodeTable![210] = '“';
    _macEncodeTable![211] = '”';
    _macEncodeTable![212] = '‘';
    _macEncodeTable![213] = '’';
    _macEncodeTable![214] = '÷';
    _macEncodeTable![215] = '◊';
    _macEncodeTable![216] = 'ÿ';
    _macEncodeTable![217] = 'Ÿ';
    _macEncodeTable![218] = '⁄';
    _macEncodeTable![219] = '€';
    _macEncodeTable![220] = '‹';
    _macEncodeTable![221] = '›';
    _macEncodeTable![222] = 'ﬁ';
    _macEncodeTable![223] = 'ﬂ';
    _macEncodeTable![224] = '‡';
    _macEncodeTable![225] = '·';
    _macEncodeTable![226] = ',';
    _macEncodeTable![227] = '„';
    _macEncodeTable![228] = '‰';
    _macEncodeTable![229] = 'Â';
    _macEncodeTable![230] = 'Ê';
    _macEncodeTable![231] = 'Á';
    _macEncodeTable![232] = 'Ë';
    _macEncodeTable![233] = 'È';
    _macEncodeTable![234] = 'Í';
    _macEncodeTable![235] = 'Î';
    _macEncodeTable![236] = 'Ï';
    _macEncodeTable![237] = 'Ì';
    _macEncodeTable![238] = 'Ó';
    _macEncodeTable![239] = 'Ô';
    _macEncodeTable![240] = '';
    _macEncodeTable![241] = 'Ò';
    _macEncodeTable![242] = 'Ú';
    _macEncodeTable![243] = 'Û';
    _macEncodeTable![244] = 'Ù';
    _macEncodeTable![245] = 'ı';
    _macEncodeTable![246] = 'ˆ';
    _macEncodeTable![247] = '˜';
    _macEncodeTable![248] = '¯';
    _macEncodeTable![249] = '˘';
    _macEncodeTable![250] = '˙';
    _macEncodeTable![251] = '˚';
    _macEncodeTable![252] = '¸';
    _macEncodeTable![253] = '˝';
    _macEncodeTable![254] = '˛';
    _macEncodeTable![255] = 'ˇ';
  }

  String skipEscapeSequence(String text) {
    if (text.contains(r'\')) {
      final int i = text.indexOf(r'\');
      if (i + 1 != text.length) {
        final String escapeSequence = text.substring(i + 1, i + 2);
        switch (escapeSequence) {
          case 'a':
            text = text.replaceAll(r'\u0007', '\u0007');
            break;
          case 'b':
            text = text.replaceAll(r'\b', '\b');
            break;
          case 'e':
            text = text.replaceAll(r'\e', r'\e');
            break;
          case 'f':
            text = text.replaceAll(r'\f', '\f');
            break;
          case 'n':
            text = text.replaceAll(r'\n', '\n');
            break;
          case 'r':
            text = text.replaceAll(r'\r', '\r');
            break;
          case 't':
            text = text.replaceAll(r'\t', '\t');
            break;
          case 'v':
            text = text.replaceAll(r'\v', '\v');
            break;
          case "'":
            // ignore: use_raw_strings
            text = text.replaceAll("\\'", "'");
            break;
          default:
            {
              if (escapeSequence.codeUnitAt(0) == 3) {
                text = text.replaceAll(r'\', r'\"');
              } else if (escapeSequence.codeUnitAt(0) >= 127) {
                text = text.replaceAll(r'\', '');
              } else {
                try {
                  text = _unescape(text);
                } catch (e) {
                  if (text.isNotEmpty) {
                    text = _unescape(RegExp.escape(text));
                  } else {
                    throw Exception();
                  }
                }
              }
              break;
            }
        }
      }
    }
    return text;
  }

  // Organizes the hex string enclosed within the '<' '>' brackets
  // hexCode - Mapping string in the map table of the document</param>
  List<String> getHexCode(String hexCode) {
    final List<String> tmp = <String>[];
    String _tmp = hexCode;
    int _start = 0;
    int _stop = 0;
    String _txt;
    for (int j1 = 0; _start >= 0; j1++) {
      _start = _tmp.indexOf('<');
      _stop = _tmp.indexOf('>');
      if (_start >= 0 && _stop >= 0) {
        _txt = _tmp.substring(_start + 1, _stop);
        tmp.add(_txt);
        _tmp = _tmp.substring(_stop + 1, _tmp.length);
      }
    }
    return tmp;
  }

  String checkContainInvalidChar(String charvalue) {
    for (int i = 0; i < charvalue.length; i++) {
      switch (charvalue.codeUnitAt(i)) {
        case 160: //No-break space
          {
            charvalue = ' ';
            break;
          }
        case 61558: //Invalid Character
          {
            charvalue = '';
            break;
          }
      }
    }
    return charvalue;
  }

  String decodeTextExtraction(String textToDecode, bool isSameFont) {
    String decodedText = '';
    String encodedText = textToDecode;
    this.isSameFont = isSameFont;
    bool hasEscapeChar = false;
    switch (encodedText[0]) {
      case '(':
        {
          while (encodedText.contains('\\\n')) {
            final int n = encodedText.indexOf('\\\n');
            final List<String> str = encodedText.split('');
            str.removeRange(n, n + 2);
            encodedText = str.join();
          }
          encodedText = encodedText.substring(1, encodedText.length - 1);
          decodedText = getLiteralString(encodedText);
          // ignore: use_raw_strings
          if (decodedText.contains('\\\\') && fontEncoding == 'Identity-H') {
            hasEscapeChar = true;
            decodedText = skipEscapeSequence(decodedText);
          }
          if (fontDictionary.containsKey(_DictionaryProperties.encoding)) {
            if (fontDictionary[_DictionaryProperties.encoding] is _PdfName) {
              if (<String>[
                'Identity-H',
                'UniCNS-UCS2-H',
                'UniKS-UCS2-H',
                'UniJIS-UCS2-H',
                'UniGB-UCS2-H'
              ].contains(
                  (fontDictionary[_DictionaryProperties.encoding]! as _PdfName)
                      ._name)) {
                String text = decodedText;
                if (!hasEscapeChar) {
                  do {
                    text = skipEscapeSequence(text);
                  } while (hasEscapeCharacter(text));
                }
                final List<int> bytes = <int>[];
                for (int i = 0; i < text.length; i++) {
                  bytes.add(text[i].codeUnitAt(0).toUnsigned(8));
                }
                decodedText = _decodeBigEndian(bytes);
              }
            }
          }
        }
        break;
      case '[':
        {
          while (encodedText.contains('\\\n')) {
            final int n = encodedText.indexOf('\\\n');
            final List<String> str = encodedText.split('');
            str.removeRange(n, n + 2);
            encodedText = str.join();
          }
          encodedText = encodedText.substring(1, encodedText.length - 1);
          while (encodedText.isNotEmpty) {
            bool isHex = false;
            int textStart = encodedText.indexOf('(');
            int textEnd = encodedText.indexOf(')');
            final int textHexStart = encodedText.indexOf('<');
            final int textHexEnd = encodedText.indexOf('>');

            if (textHexStart < textStart && textHexStart > -1) {
              textStart = textHexStart;
              textEnd = textHexEnd;
              isHex = true;
            }
            if (textStart < 0) {
              textStart = encodedText.indexOf('<');
              textEnd = encodedText.indexOf('>');
              if (textStart >= 0) {
                isHex = true;
              } else {
                break;
              }
            } else if (textEnd > 0) {
              while (encodedText[textEnd - 1] == r'\') {
                if (encodedText.contains(')', textEnd + 1)) {
                  textEnd = encodedText.indexOf(')', textEnd + 1);
                } else {
                  break;
                }
              }
            }

            final String tempString =
                encodedText.substring(textStart + 1, textEnd);
            if (isHex) {
              decodedText += getHexaDecimalString(tempString);
            } else {
              decodedText += getLiteralString(tempString);
            }

            encodedText =
                encodedText.substring(textEnd + 1, encodedText.length);
          }
        }
        break;
      case '<':
        {
          final String hexEncodedText =
              encodedText.substring(1, encodedText.length - 1);
          decodedText = getHexaDecimalString(hexEncodedText);
        }
        break;
      default:
        break;
    }

    if (fontEncoding != 'Identity-H' ||
        (fontEncoding == 'Identity-H') ||
        (fontEncoding == 'Identity-H' && containsCmap)) {
      isMappingDone = true;
      if (characterMapTable.isNotEmpty) {
        decodedText = mapCharactersFromTable(decodedText);
      } else if (differencesDictionary.isNotEmpty) {
        decodedText = mapDifferences(decodedText);
      } else if (fontEncoding != '') {
        decodedText = skipEscapeSequence(decodedText);
      }
    }

    if (cidToGidTable != null && !isTextExtraction) {
      decodedText = mapCidToGid(decodedText);
    }
    if (_fontName == 'ZapfDingbats' && !isEmbedded) {
      decodedText = mapZapf(decodedText);
    }
    if (fontEncoding == 'MacRomanEncoding') {
      String tempstring = '';
      for (int i = 0; i < decodedText.length; i++) {
        final int b = decodedText[i].codeUnitAt(0).toUnsigned(8);
        if (b > 126) {
          final String x = macEncodeTable![b]!;
          tempstring += x;
        } else {
          tempstring += decodedText[i];
        }
      }
      if (tempstring != '') {
        decodedText = tempstring;
      }
    }
    if (decodedText.contains('\u0092')) {
      decodedText = decodedText.replaceAll('\u0092', '’');
    }
    if (decodedText.contains(RegExp('[\n-\r]'))) {
      decodedText = decodedText.replaceAll(RegExp('[\n-\r]'), '’');
    }
    isWhiteSpace = decodedText.isEmpty || (decodedText.trimRight() == '');
    return decodedText;
  }

  List<String> decodeCjkTextExtractionTJ(String textToDecode, bool isSameFont) {
    String decodedText = '';
    String encodedText = textToDecode;
    String listElement;
    this.isSameFont = isSameFont;
    final List<String> decodedList = <String>[];
    if (encodedText[0] == '[') {
      while (encodedText.contains('\\\n')) {
        final int n = encodedText.indexOf('\\\n');
        final List<String> str = encodedText.split('');
        str.removeRange(n, n + 2);
        encodedText = str.join();
      }
      encodedText = encodedText.substring(1, encodedText.length - 1);
      while (encodedText.isNotEmpty) {
        bool isHex = false;
        int textStart = encodedText.indexOf('(');
        int textEnd = encodedText.indexOf(')');
        for (int j = textEnd + 1; j < encodedText.length; j++) {
          if (encodedText[j] == '(') {
            break;
          } else if (encodedText[j] == ')') {
            textEnd = j;
            break;
          }
        }
        final int textHexStart = encodedText.indexOf('<');
        final int textHexEnd = encodedText.indexOf('>');
        if (textHexStart < textStart && textHexStart > -1) {
          textStart = textHexStart;
          textEnd = textHexEnd;
          isHex = true;
        }
        if (textStart < 0) {
          textStart = encodedText.indexOf('<');
          textEnd = encodedText.indexOf('>');
          if (textStart >= 0) {
            isHex = true;
          } else {
            listElement = encodedText;
            decodedList.add(listElement);
            break;
          }
        }
        if (textEnd < 0 && encodedText.isNotEmpty) {
          listElement = encodedText;
          decodedList.add(listElement);
          break;
        } else if (textEnd > 0) {
          while (encodedText[textEnd - 1] == r'\') {
            if (textEnd - 1 > 0 && encodedText[textEnd - 2] == r'\') {
              break;
            }
            if (encodedText.contains(')', textEnd + 1)) {
              textEnd = encodedText.indexOf(')', textEnd + 1);
            } else {
              break;
            }
          }
        }
        if (textStart != 0) {
          listElement = encodedText.substring(0, textStart);
          decodedList.add(listElement);
        }
        final String tempString = encodedText.substring(textStart + 1, textEnd);
        listElement = isHex
            ? getHexaDecimalCJKString(tempString)
            : getLiteralString(tempString);
        decodedText += listElement;
        listElement = skipEscapeSequence(listElement);
        if (listElement.isNotEmpty) {
          if (listElement[0].codeUnitAt(0) >= 3584 &&
              listElement[0].codeUnitAt(0) <= 3711 &&
              decodedList.isNotEmpty) {
            String previous = decodedList[0];
            previous =
                previous.replaceRange(previous.length - 1, previous.length, '');
            previous += listElement;
            listElement = previous;
            decodedList[0] = fromUnicodeText(listElement) + 's';
          } else if ((listElement[0].codeUnitAt(0) == 32 ||
                  listElement[0].codeUnitAt(0) == 47) &&
              listElement.length > 1) {
            if (listElement[1].codeUnitAt(0) >= 3584 &&
                listElement[1].codeUnitAt(0) <= 3711 &&
                decodedList.isNotEmpty) {
              String previous = decodedList[0];
              previous = previous.replaceRange(
                  previous.length - 1, previous.length, '');
              previous += listElement;
              listElement = previous;
              decodedList[0] = fromUnicodeText(listElement) + 's';
            } else {
              listElement = fromUnicodeText(listElement) + 's';
              decodedList.add(listElement);
            }
          } else {
            listElement = fromUnicodeText(listElement) + 's';
            decodedList.add(listElement);
          }
        } else {
          listElement = fromUnicodeText(listElement) + 's';
          decodedList.add(listElement);
        }
        encodedText = encodedText.substring(textEnd + 1, encodedText.length);
      }
    }
    decodedText = skipEscapeSequence(decodedText);
    isWhiteSpace = decodedText.isEmpty || (decodedText.trimRight() == '');
    return decodedList;
  }

  String getHexaDecimalCJKString(String hexEncodedText) {
    int index = 0;
    String result = '';
    while (index < hexEncodedText.length) {
      final String hex = hexEncodedText.substring(index, index + 2);
      final int charCode = int.parse(hex, radix: 16);
      result += String.fromCharCode(charCode);
      index += 2;
    }
    return result;
  }

  List<String> decodeTextExtractionTJ(String textToDecode, bool isSameFont) {
    String decodedText = '';
    String encodedText = textToDecode;
    String listElement;
    this.isSameFont = isSameFont;
    final List<String> decodedList = <String>[];
    switch (encodedText[0]) {
      case '(':
        {
          while (encodedText.contains('\\\n')) {
            final int n = encodedText.indexOf('\\\n');
            final List<String> str = encodedText.split('');
            str.removeRange(n, n + 2);
            encodedText = str.join();
          }
          encodedText = encodedText.substring(1, encodedText.length - 1);
          decodedText = getLiteralString(encodedText);
          if (fontDictionary.containsKey(_DictionaryProperties.encoding)) {
            if (fontDictionary[_DictionaryProperties.encoding] is _PdfName) {
              if ((fontDictionary[_DictionaryProperties.encoding]! as _PdfName)
                      ._name ==
                  'Identity-H') {
                final String text = skipEscapeSequence(decodedText);

                final List<int> bytes = <int>[];
                for (int i = 0; i < text.length; i++) {
                  bytes.add(text[i].codeUnitAt(0).toUnsigned(8));
                }
                decodedText = _decodeBigEndian(bytes);
              }
            }
          }
        }
        break;
      case '[':
        {
          while (encodedText.contains('\\\n')) {
            final int n = encodedText.indexOf('\\\n');
            final List<String> str = encodedText.split('');
            str.removeRange(n, n + 2);
            encodedText = str.join();
          }
          encodedText = encodedText.substring(1, encodedText.length - 1);
          while (encodedText.isNotEmpty) {
            bool isHex = false;
            int textStart = encodedText.indexOf('(');
            int textEnd = encodedText.indexOf(')');
            for (int j = textEnd + 1; j < encodedText.length; j++) {
              if (encodedText[j] == '(') {
                break;
              } else if (encodedText[j] == ')') {
                textEnd = j;
                break;
              }
            }
            final int textHexStart = encodedText.indexOf('<');
            final int textHexEnd = encodedText.indexOf('>');
            if (textHexStart < textStart && textHexStart > -1) {
              textStart = textHexStart;
              textEnd = textHexEnd;
              isHex = true;
            }
            if (textStart < 0) {
              textStart = encodedText.indexOf('<');
              textEnd = encodedText.indexOf('>');
              if (textStart >= 0) {
                isHex = true;
              } else {
                listElement = encodedText;
                if (listElement.trim() != '') {
                  decodedList.add(listElement);
                }
                break;
              }
            }
            if (textEnd < 0 && encodedText.isNotEmpty) {
              listElement = encodedText;
              if (listElement.trim() != '') {
                decodedList.add(listElement);
              }
              break;
            } else if (textEnd > 0) {
              while (encodedText[textEnd - 1] == r'\') {
                if (textEnd - 1 > 0 && encodedText[textEnd - 2] == r'\') {
                  break;
                }
                if (encodedText.contains(')', textEnd + 1)) {
                  textEnd = encodedText.indexOf(')', textEnd + 1);
                } else {
                  break;
                }
              }
            }
            if (textStart != 0) {
              listElement = encodedText.substring(0, textStart);
              if (listElement.trim() != '') {
                decodedList.add(listElement);
              }
            }
            final String tempString =
                encodedText.substring(textStart + 1, textEnd);
            if (isHex) {
              listElement = getHexaDecimalString(tempString);
              if (listElement.contains(r'\')) {
                // ignore: use_raw_strings
                listElement = listElement.replaceAll('\\', '\\\\');
              }
              decodedText += listElement;
            } else {
              listElement = getLiteralString(tempString);
              decodedText += listElement;
            }
            if (listElement.contains('\u0000') &&
                !characterMapTable.containsKey(0)) {
              listElement = listElement.replaceAll(
                  '\u0000', ''); //replace empty character.
            }
            listElement = skipEscapeSequence(listElement);
            if (fontEncoding != 'Identity-H' ||
                (fontEncoding == 'Identity-H') ||
                (fontEncoding == 'Identity-H' && containsCmap)) {
              isMappingDone = true;
              if (characterMapTable.isNotEmpty) {
                listElement = mapCharactersFromTable(listElement);
              } else if (differencesDictionary.isNotEmpty) {
                listElement = mapDifferences(listElement);
              } else if (fontEncoding != '') {
                listElement = skipEscapeSequence(listElement);
              }
            }
            if (cidToGidTable != null && !isTextExtraction) {
              listElement = mapCidToGid(listElement);
            }
            if (encodedText
                .substring(textEnd + 1, encodedText.length)
                .trim()
                .isEmpty) {
              listElement = listElement.trimRight();
            }
            if (listElement.contains(RegExp('[\n-\r]'))) {
              listElement = listElement.replaceAll(RegExp('[\n-\r]'), '');
            }
            if (listElement.isNotEmpty) {
              if (listElement[0].codeUnitAt(0) >= 3584 &&
                  listElement[0].codeUnitAt(0) <= 3711 &&
                  decodedList.isNotEmpty) {
                String previous = decodedList[0];
                previous = previous.replaceRange(
                    previous.length - 1, previous.length, '');
                previous += listElement;
                listElement = previous;
                decodedList[0] = listElement + 's';
              } else if ((listElement[0].codeUnitAt(0) == 32 ||
                      listElement[0].codeUnitAt(0) == 47) &&
                  listElement.length > 1) {
                if (listElement[1].codeUnitAt(0) >= 3584 &&
                    listElement[1].codeUnitAt(0) <= 3711 &&
                    decodedList.isNotEmpty) {
                  String previous = decodedList[0];
                  previous = previous.replaceRange(
                      previous.length - 1, previous.length, '');
                  previous += listElement;
                  listElement = previous;
                  decodedList[0] = listElement + 's';
                } else {
                  listElement += 's';
                  decodedList.add(listElement);
                }
              } else {
                listElement += 's';
                decodedList.add(listElement);
              }
            } else {
              listElement = listElement.trimRight() + 's';
              decodedList.add(listElement);
            }
            encodedText =
                encodedText.substring(textEnd + 1, encodedText.length);
          }
        }
        break;
      case '<':
        {
          final String hexEncodedText =
              encodedText.substring(1, encodedText.length - 1);
          decodedText = getHexaDecimalString(hexEncodedText);
        }
        break;
      default:
        break;
    }
    decodedText = skipEscapeSequence(decodedText);
    isWhiteSpace = decodedText.isEmpty || decodedText.trimRight() == '';
    return decodedList;
  }

  String fromUnicodeText(String value) {
    String result = '';
    if (value.length % 2 != 0) {
      for (int i = 0; i < value.length; i++) {
        if (i + 1 < value.length) {
          result += String.fromCharCode(
              (value.codeUnitAt(i) * 256) + value.codeUnitAt(i + 1));
          i++;
        } else {
          result += String.fromCharCode(value.codeUnitAt(i));
        }
      }
    } else {
      for (int i = 0; i < value.length; i++) {
        result += String.fromCharCode(
            (value.codeUnitAt(i) * 256) + value.codeUnitAt(i + 1));
        i++;
      }
    }
    isWhiteSpace = result.isEmpty || result.trimRight() == '';
    return result;
  }

  String getEncodedText(String textElement, bool isSameFont) {
    String encodedText = '';
    String textToEncode = textElement;
    this.isSameFont = isSameFont;
    bool hasEscapeChar = false;
    switch (textToEncode[0]) {
      case '(':
        {
          if (textToEncode.contains('\\\n')) {
            final int n = textToEncode.indexOf('\\\n');
            final List<String> str = textToEncode.split('');
            str.removeRange(n, n + 2);
            textToEncode = str.join();
          }
          textToEncode = textToEncode.substring(1, textToEncode.length - 1);
          encodedText = getLiteralString(textToEncode);
          // ignore: use_raw_strings
          if (encodedText.contains('\\\\') && fontEncoding == 'Identity-H') {
            hasEscapeChar = true;
            encodedText = skipEscapeSequence(encodedText);
          }
          if (fontDictionary.containsKey(_DictionaryProperties.encoding)) {
            final _IPdfPrimitive? primitive =
                fontDictionary[_DictionaryProperties.encoding];
            if (primitive is _PdfName) {
              final String? encoding = primitive._name;
              if (encoding == 'Identity-H') {
                String text = encodedText;
                if (!hasEscapeChar) {
                  if (text.contains(r'\a') ||
                      text.contains(r'\') ||
                      text.contains(r'\b') ||
                      text.contains(r'\f') ||
                      text.contains(r'\r') ||
                      text.contains(r'\t') ||
                      text.contains(r'\n') ||
                      text.contains(r'\v') ||
                      text.contains('\\\'')) {
                    while (text.contains(r'\a') ||
                        text.contains(r'\') ||
                        text.contains(r'\b') ||
                        text.contains(r'\f') ||
                        text.contains(r'\r') ||
                        text.contains(r'\t') ||
                        text.contains(r'\n') ||
                        text.contains(r'\v') ||
                        text.contains('\\\'')) {
                      text = skipEscapeSequence(text);
                    }
                  } else {
                    text = skipEscapeSequence(text);
                  }
                }
                final List<int> bytes = <int>[];
                for (int i = 0; i < text.length; i++) {
                  bytes.add(text.codeUnitAt(0).toUnsigned(8));
                }
                if (encoding == 'Identity-H') {
                  encodedText = _decodeBigEndian(bytes);
                }
                if (encodedText.contains(r'\')) {
                  // ignore: use_raw_strings
                  encodedText = encodedText.replaceAll('\\', '\\\\');
                }
              }
            }
          }
        }
        break;
      case '[':
        {
          if (textToEncode.contains('\\\n')) {
            final int n = textToEncode.indexOf('\\\n');
            final List<String> str = textToEncode.split('');
            str.removeRange(n, n + 2);
            textToEncode = str.join();
          }
          textToEncode = textToEncode.substring(1, textToEncode.length - 1);
          while (textToEncode.isNotEmpty) {
            bool isHex = false;
            int textStart = textToEncode.indexOf('(');
            int textEnd = textToEncode.indexOf(')');
            final int textHexStart = textToEncode.indexOf('<');
            final int textHexEnd = textToEncode.indexOf('>');
            for (int j = textEnd + 1; j < textToEncode.length; j++) {
              if (textToEncode[j] == '(') {
                break;
              } else if (textToEncode[j] == ')') {
                textEnd = j;
                break;
              }
            }
            if (textHexStart < textStart && textHexStart > -1) {
              textStart = textHexStart;
              textEnd = textHexEnd;
              isHex = true;
            }
            if (textStart < 0) {
              textStart = textToEncode.indexOf('<');
              textEnd = textToEncode.indexOf('>');
              if (textStart >= 0) {
                isHex = true;
              } else {
                break;
              }
            } else if (textEnd > 0) {
              while (textToEncode[textEnd - 1] == r'\') {
                if (textToEncode.contains(')', textEnd + 1)) {
                  textEnd = textToEncode.indexOf(')', textEnd + 1);
                } else {
                  break;
                }
              }
            }
            final String tempString =
                textToEncode.substring(textStart + 1, textEnd);
            if (isHex) {
              encodedText += getHexaDecimalString(tempString);
            } else if (!isHex && fontEncoding == 'Identity-H') {
              encodedText += getRawString(tempString);
            } else {
              encodedText += getLiteralString(tempString);
            }
            textToEncode =
                textToEncode.substring(textEnd + 1, textToEncode.length);
          }
        }
        break;
      case '<':
        {
          final String hexEncodedText =
              textToEncode.substring(1, textToEncode.length - 1);
          encodedText = getHexaDecimalString(hexEncodedText);
          if (encodedText.contains(r'\')) {
            // ignore: use_raw_strings
            encodedText = encodedText.replaceAll('\\', '\\\\');
          }
        }
        break;
      default:
        break;
    }
    if (encodedText.contains('\u0000') &&
        characterMapTable.isNotEmpty &&
        !characterMapTable.containsKey('\u0000'.codeUnitAt(0))) {
      encodedText = encodedText.replaceAll('\u0000', '');
    }
    if (!isTextExtraction) {
      encodedText = skipEscapeSequence(encodedText);
    }
    isWhiteSpace = encodedText.isEmpty || encodedText.trimRight() == '';
    return encodedText;
  }

  bool isCIDFontType() {
    bool iscid = false;
    if (fontDictionary.containsKey(_DictionaryProperties.descendantFonts)) {
      _IPdfPrimitive? primitive =
          fontDictionary[_DictionaryProperties.descendantFonts];
      if (primitive is _PdfReferenceHolder) {
        final _PdfReferenceHolder descendantFontArrayReference = primitive;
        primitive = descendantFontArrayReference.object;
        if (primitive is _PdfArray) {
          final _PdfArray descendantFontArray = primitive;
          if (descendantFontArray.count > 0 &&
              descendantFontArray[0] is _PdfReferenceHolder) {
            primitive = (descendantFontArray[0]! as _PdfReferenceHolder).object;
            if (primitive is _PdfDictionary) {
              final _PdfDictionary descendantDictionary = primitive;
              if (descendantDictionary
                  .containsKey(_DictionaryProperties.subtype)) {
                primitive = descendantDictionary[_DictionaryProperties.subtype];
                if (primitive is _PdfName) {
                  final _PdfName subtype =
                      descendantDictionary[_DictionaryProperties.subtype]!
                          as _PdfName;
                  if (subtype._name == 'CIDFontType2' ||
                      subtype._name == 'CIDFontType0') {
                    iscid = true;
                  }
                }
              }
            }
          }
        }
      } else if (primitive is _PdfArray) {
        final _PdfArray descendantFontArray = primitive;
        if (descendantFontArray.count > 0 &&
            descendantFontArray[0] is _PdfReferenceHolder) {
          primitive = (descendantFontArray[0]! as _PdfReferenceHolder).object;
          if (primitive is _PdfDictionary) {
            final _PdfDictionary descendantDictionary = primitive;
            if (descendantDictionary
                .containsKey(_DictionaryProperties.subtype)) {
              primitive = descendantDictionary[_DictionaryProperties.subtype];
              if (primitive is _PdfName) {
                final _PdfName subtype =
                    descendantDictionary[_DictionaryProperties.subtype]!
                        as _PdfName;
                if (subtype._name == 'CIDFontType2' ||
                    subtype._name == 'CIDFontType0') {
                  iscid = true;
                }
              }
            }
          }
        }
      }
    }
    return iscid;
  }

  String getRawString(String decodedText) {
    String rawString = '';
    int charCode = 0;
    bool isNonPrintable = false;
    if (fontEncoding != null && fontEncoding == 'Identity-H' && isCid) {
      for (int i = 0; i < decodedText.length; i++) {
        final String rawChar = decodedText[i];
        final int codeUnit = decodedText.codeUnitAt(i);
        if (codeUnit == 1) {
          charCode = codeUnit;
          rawString += rawChar;
        } else if (rawChar == r'\') {
          isNonPrintable = true;
          rawString += r'\';
        } else if (isNonPrintable) {
          String escapeChar = rawChar;
          bool isEscapeCharacter = false;
          switch (escapeChar) {
            case 'n':
              {
                escapeChar = '\n';
                isEscapeCharacter = true;
                break;
              }
            case 'b':
              {
                escapeChar = '\b';
                isEscapeCharacter = true;
                break;
              }
            case 't':
              {
                escapeChar = '\t';
                isEscapeCharacter = true;
                break;
              }
            case 'r':
              {
                escapeChar = '\r';
                isEscapeCharacter = true;
                break;
              }
            case 'f':
              {
                escapeChar = '\f';
                isEscapeCharacter = true;
                break;
              }
            default:
              {
                charCode = (charCode * 256) + codeUnit;
                rawString += String.fromCharCode(charCode);
                isNonPrintable = false;
                charCode = 0;
              }
              break;
          }
          if (isEscapeCharacter) {
            rawString += escapeChar;
            isNonPrintable = false;
            charCode = 0;
          }
        } else {
          charCode = (charCode * 256) + codeUnit;
          rawString += String.fromCharCode(charCode);
          charCode = 0;
        }
      }
      decodedText = rawString;
    }
    return decodedText;
  }

  // Takes in the decoded text and maps it with its
  // corresponding entry in the CharacterMapTable
  String mapDifferences(String? encodedText) {
    String decodedText = '';
    bool skip = false;
    if (isTextExtraction) {
      try {
        encodedText = _unescape(encodedText!);
      } catch (e) {
        if (encodedText != null && encodedText.isNotEmpty) {
          encodedText = RegExp.escape(encodedText)
              .replaceAll(r"\'''", r"'''")
              .replaceAll(r'\\', r'\');
        } else {
          throw ArgumentError(e.toString());
        }
      }
    } else {
      skipEscapeSequence(encodedText!);
    }
    for (int i = 0; i < encodedText.length; i++) {
      final int character = encodedText.codeUnitAt(i);
      if (differencesDictionary.containsKey(character.toString())) {
        final String tempString = differencesDictionary[character.toString()]!;
        if ((tempString.length > 1) &&
            (fontType!._name != 'Type3') &&
            (!isTextExtraction)) {
          decodedText += character.toString();
        } else {
          if (!isTextExtraction) {
            String textDecoded = differencesDictionary[character.toString()]!;
            if (textDecoded.length == 7 &&
                textDecoded.toLowerCase().startsWith('uni')) {
              textDecoded = String.fromCharCode(
                  int.parse(textDecoded.substring(3), radix: 16));
            }
            decodedText += textDecoded;
          } else {
            if (!differencesDictionary.containsKey(character.toString())) {
              final _AdobeGlyphList glyphList = _AdobeGlyphList();
              decodedText += glyphList.getUnicode(tempString)!;
              glyphList.map!.clear();
            } else {
              final String textDecoded =
                  differencesDictionary[character.toString()]!;
              decodedText += textDecoded;
            }
          }
        }
        if (!reverseDictMapping
            .containsKey(differencesDictionary[character.toString()])) {
          reverseDictMapping[differencesDictionary[character.toString()]] =
              character;
        }
        if (fontName == 'Wingdings') {
          decodedText = mapDifferenceOfWingDings(decodedText);
        }

        final String? specialCharacter = getSpecialCharacter(decodedText);
        if (decodedText != specialCharacter && !isEmbedded) {
          decodedText = decodedText.replaceAll(decodedText, specialCharacter!);
        }
        skip = false;
      } else {
        if (skip) {
          switch (encodedText[i]) {
            case 'n':
              if (differencesDictionary
                  .containsKey('\n'.codeUnitAt(0).toString())) {
                decodedText +=
                    differencesDictionary['\n'.codeUnitAt(0).toString()]!;
              }
              break;
            case 'r':
              if (differencesDictionary
                  .containsKey('\r'.codeUnitAt(0).toString())) {
                decodedText +=
                    differencesDictionary['\r'.codeUnitAt(0).toString()]!;
              }
              break;
            default:
              break;
          }
          skip = false;
        } else if (encodedText[i] == r'\') {
          skip = true;
        } else {
          decodedText += encodedText[i];
        }
      }
    }
    return decodedText;
  }

  String mapZapf(String encodedText) {
    String decodedtext = '';
    for (int i = 0; i < encodedText.length; i++) {
      final int character = encodedText.codeUnitAt(i);
      final String result = character.toRadixString(16);
      switch (result.toUpperCase()) {
        case '20':
          decodedtext += '\u0020';
          zapfPostScript += 'space ';
          break;
        case '21':
          decodedtext += '\u2701';
          zapfPostScript += 'a1 ';
          break;
        case '22':
          decodedtext += '\u2702';
          zapfPostScript += 'a2 ';
          break;
        case '23':
          decodedtext += '\u2703';
          zapfPostScript += 'a202 ';
          break;
        case '24':
          decodedtext += '\u2704';
          zapfPostScript += 'a3 ';
          break;
        case '25':
          decodedtext += '\u260E';
          zapfPostScript += 'a4 ';
          break;
        case '26':
          decodedtext += '\u2706';
          zapfPostScript += 'a5 ';
          break;
        case '27':
          decodedtext += '\u2707';
          zapfPostScript += 'a119 ';
          break;
        case '28':
          decodedtext += '\u2708';
          zapfPostScript += 'a118 ';
          break;
        case '29':
          decodedtext += '\u2709';
          zapfPostScript += 'a117 ';
          break;
        case '2A':
          decodedtext += '\u261B';
          zapfPostScript += 'a11 ';
          break;
        case '2B':
          decodedtext += '\u261E';
          zapfPostScript += 'a12 ';
          break;
        case '2C':
          decodedtext += '\u270C';
          zapfPostScript += 'a13 ';
          break;
        case '2D':
          decodedtext += '\u270D';
          zapfPostScript += 'a14 ';
          break;
        case '2E':
          decodedtext += '\u270E';
          zapfPostScript += 'a15 ';
          break;
        case '2F':
          decodedtext += '\u270F';
          zapfPostScript += 'a16 ';
          break;
        case '30':
          decodedtext += '\u2710';
          zapfPostScript += 'a105 ';
          break;
        case '31':
          decodedtext += '\u2711';
          zapfPostScript += 'a17 ';
          break;
        case '32':
          decodedtext += '\u2712';
          zapfPostScript += 'a18 ';
          break;
        case '33':
          decodedtext += '\u2713';
          zapfPostScript += 'a19 ';
          break;
        case '34':
          decodedtext += '\u2714';
          zapfPostScript += 'a20 ';
          break;
        case '35':
          decodedtext += '\u2715';
          zapfPostScript += 'a21 ';
          break;
        case '36':
          decodedtext += '\u2716';
          zapfPostScript += 'a22 ';
          break;
        case '37':
          decodedtext += '\u2717';
          zapfPostScript += 'a23 ';
          break;
        case '38':
          decodedtext += '\u2718';
          zapfPostScript += 'a24 ';
          break;
        case '39':
          decodedtext += '\u2719';
          zapfPostScript += 'a25 ';
          break;
        case '3A':
          decodedtext += '\u271A';
          zapfPostScript += 'a26 ';
          break;
        case '3B':
          decodedtext += '\u271B';
          zapfPostScript += 'a27 ';
          break;
        case '3C':
          decodedtext += '\u271C';
          zapfPostScript += 'a28 ';
          break;
        case '3D':
          decodedtext += '\u271D';
          zapfPostScript += 'a6 ';
          break;
        case '3E':
          decodedtext += '\u271E';
          zapfPostScript += 'a7 ';
          break;
        case '3F':
          decodedtext += '\u271F';
          zapfPostScript += 'a8 ';
          break;
        case '40':
          decodedtext += '\u2720';
          zapfPostScript += 'a9 ';
          break;
        case '41':
          decodedtext += '\u2721';
          zapfPostScript += 'a10 ';
          break;
        case '42':
          decodedtext += '\u2722';
          zapfPostScript += 'a29 ';
          break;
        case '43':
          decodedtext += '\u2723';
          zapfPostScript += 'a30 ';
          break;
        case '44':
          decodedtext += '\u2724';
          zapfPostScript += 'a31 ';
          break;
        case '45':
          decodedtext += '\u2725';
          zapfPostScript += 'a32 ';
          break;
        case '46':
          decodedtext += '\u2726';
          zapfPostScript += 'a33 ';
          break;
        case '47':
          decodedtext += '\u2727';
          zapfPostScript += 'a34 ';
          break;
        case '48':
          decodedtext += '\u2605';
          zapfPostScript += 'a35 ';
          break;
        case '49':
          decodedtext += '\u2729';
          zapfPostScript += 'a36 ';
          break;
        case '4A':
          decodedtext += '\u272A';
          zapfPostScript += 'a37 ';
          break;
        case '4B':
          decodedtext += '\u272B';
          zapfPostScript += 'a38 ';
          break;
        case '4C':
          decodedtext += '\u272C';
          zapfPostScript += 'a39 ';
          break;
        case '4D':
          decodedtext += '\u272D';
          zapfPostScript += 'a40 ';
          break;
        case '4E':
          decodedtext += '\u272E';
          zapfPostScript += 'a41 ';
          break;
        case '4F':
          decodedtext += '\u272F';
          zapfPostScript += 'a42 ';
          break;
        case '50':
          decodedtext += '\u2730';
          zapfPostScript += 'a43 ';
          break;
        case '51':
          decodedtext += '\u2731';
          zapfPostScript += 'a44 ';
          break;
        case '52':
          decodedtext += '\u2732';
          zapfPostScript += 'a45 ';
          break;
        case '53':
          decodedtext += '\u2733';
          zapfPostScript += 'a46 ';
          break;
        case '54':
          decodedtext += '\u2734';
          zapfPostScript += 'a47 ';
          break;
        case '55':
          decodedtext += '\u2735';
          zapfPostScript += 'a48 ';
          break;
        case '56':
          decodedtext += '\u2736';
          zapfPostScript += 'a49 ';
          break;
        case '57':
          decodedtext += '\u2737';
          zapfPostScript += 'a50 ';
          break;
        case '58':
          decodedtext += '\u2738';
          zapfPostScript += 'a51 ';
          break;
        case '59':
          decodedtext += '\u2739';
          zapfPostScript += 'a52 ';
          break;
        case '5A':
          decodedtext += '\u273A';
          zapfPostScript += 'a53 ';
          break;
        case '5B':
          decodedtext += '\u273B';
          zapfPostScript += 'a54 ';
          break;
        case '5C':
          decodedtext += '\u273C';
          zapfPostScript += 'a55 ';
          break;
        case '5D':
          decodedtext += '\u273D';
          zapfPostScript += 'a56 ';
          break;
        case '5E':
          decodedtext += '\u273E';
          zapfPostScript += 'a57 ';
          break;
        case '5F':
          decodedtext += '\u273F';
          zapfPostScript += 'a58 ';
          break;
        case '60':
          decodedtext += '\u2740';
          zapfPostScript += 'a59 ';
          break;
        case '61':
          decodedtext += '\u2741';
          zapfPostScript += 'a60 ';
          break;
        case '62':
          decodedtext += '\u2742';
          zapfPostScript += 'a61 ';
          break;
        case '63':
          decodedtext += '\u2743';
          zapfPostScript += 'a62 ';
          break;
        case '64':
          decodedtext += '\u2744';
          zapfPostScript += 'a63 ';
          break;
        case '65':
          decodedtext += '\u2745';
          zapfPostScript += 'a64 ';
          break;
        case '66':
          decodedtext += '\u2746';
          zapfPostScript += 'a65 ';
          break;
        case '67':
          decodedtext += '\u2747';
          zapfPostScript += 'a66 ';
          break;
        case '68':
          decodedtext += '\u2748';
          zapfPostScript += 'a67 ';
          break;
        case '69':
          decodedtext += '\u2749';
          zapfPostScript += 'a68 ';
          break;
        case '6A':
          decodedtext += '\u274A';
          zapfPostScript += 'a69 ';
          break;
        case '6B':
          decodedtext += '\u274B';
          zapfPostScript += 'a70 ';
          break;
        case '6C':
          decodedtext += '\u25CF';
          zapfPostScript += 'a71 ';
          break;
        case '6D':
          decodedtext += '\u254D';
          zapfPostScript += 'a72 ';
          break;
        case '6E':
          decodedtext += '\u25A0';
          zapfPostScript += 'a73 ';
          break;
        case '6F':
          decodedtext += '\u274F';
          zapfPostScript += 'a74 ';
          break;
        case '70':
          decodedtext += '\u2750';
          zapfPostScript += 'a203 ';
          break;
        case '71':
          decodedtext += '\u2751';
          zapfPostScript += 'a75 ';
          break;
        case '72':
          decodedtext += '\u2752';
          zapfPostScript += 'a204 ';
          break;
        case '73':
          decodedtext += '\u25B2';
          zapfPostScript += 'a76 ';
          break;
        case '74':
          decodedtext += '\u25BC';
          zapfPostScript += 'a77 ';
          break;
        case '75':
          decodedtext += '\u27C6';
          zapfPostScript += 'a78 ';
          break;
        case '76':
          decodedtext += '\u2756';
          zapfPostScript += 'a79 ';
          break;
        case '77':
          decodedtext += '\u25D7';
          zapfPostScript += 'a81 ';
          break;
        case '78':
          decodedtext += '\u2758';
          zapfPostScript += 'a82 ';
          break;
        case '79':
          decodedtext += '\u2759';
          zapfPostScript += 'a83 ';
          break;
        case '7A':
          decodedtext += '\u275A';
          zapfPostScript += 'a84 ';
          break;
        case '7B':
          decodedtext += '\u275B';
          zapfPostScript += 'a97 ';
          break;
        case '7C':
          decodedtext += '\u275C';
          zapfPostScript += 'a98 ';
          break;
        case '7D':
          decodedtext += '\u275D';
          zapfPostScript += 'a99 ';
          break;
        case '7E':
          decodedtext += '\u275E';
          zapfPostScript += 'a100 ';
          break;
        case '80':
          decodedtext += '\uF8D7';
          zapfPostScript += 'a89 ';
          break;
        case '81':
          decodedtext += '\uF8D8';
          zapfPostScript += 'a90 ';
          break;
        case '82':
          decodedtext += '\uF8D9';
          zapfPostScript += 'a93 ';
          break;
        case '83':
          decodedtext += '\uF8DA';
          zapfPostScript += 'a94 ';
          break;
        case '84':
          decodedtext += '\uF8DB';
          zapfPostScript += 'a91 ';
          break;
        case '85':
          decodedtext += '\uF8DC';
          zapfPostScript += 'a92 ';
          break;
        case '86':
          decodedtext += '\uF8DD';
          zapfPostScript += 'a205 ';
          break;
        case '87':
          decodedtext += '\uF8DE';
          zapfPostScript += 'a85 ';
          break;
        case '88':
          decodedtext += '\uF8DF';
          zapfPostScript += 'a206 ';
          break;
        case '89':
          decodedtext += '\uF8E0';
          zapfPostScript += 'a86 ';
          break;
        case '8A':
          decodedtext += '\uF8E1';
          zapfPostScript += 'a87 ';
          break;
        case '8B':
          decodedtext += '\uF8E2';
          zapfPostScript += 'a88 ';
          break;
        case '8C':
          decodedtext += '\uF8E3';
          zapfPostScript += 'a95 ';
          break;
        case '8D':
          decodedtext += '\uF8E4';
          zapfPostScript += 'a96 ';
          break;
        case 'A1':
          decodedtext += '\u2761';
          zapfPostScript += 'a101 ';
          break;
        case 'A2':
          decodedtext += '\u2762';
          zapfPostScript += 'a102 ';
          break;
        case 'A3':
          decodedtext += '\u2763';
          zapfPostScript += 'a103 ';
          break;
        case 'A4':
          decodedtext += '\u2764';
          zapfPostScript += 'a104 ';
          break;
        case 'A5':
          decodedtext += '\u2765';
          zapfPostScript += 'a106 ';
          break;
        case 'A6':
          decodedtext += '\u2766';
          zapfPostScript += 'a107 ';
          break;
        case 'A7':
          decodedtext += '\u2767';
          zapfPostScript += 'a108 ';
          break;
        case 'A8':
          decodedtext += '\u2663';
          zapfPostScript += 'a112 ';
          break;
        case 'A9':
          decodedtext += '\u2666';
          zapfPostScript += 'a111 ';
          break;
        case 'AA':
          decodedtext += '\u2665';
          zapfPostScript += 'a110 ';
          break;
        case 'AB':
          decodedtext += '\u2660';
          zapfPostScript += 'a109 ';
          break;
        case 'AC':
          decodedtext += '\u2460';
          zapfPostScript += 'a120 ';
          break;
        case 'AD':
          decodedtext += '\u2461';
          zapfPostScript += 'a121 ';
          break;
        case 'AE':
          decodedtext += '\u2462';
          zapfPostScript += 'a122 ';
          break;
        case 'AF':
          decodedtext += '\u2463';
          zapfPostScript += 'a123 ';
          break;
        case 'B0':
          decodedtext += '\u2464';
          zapfPostScript += 'a124 ';
          break;
        case 'B1':
          decodedtext += '\u2465';
          zapfPostScript += 'a125 ';
          break;
        case 'B2':
          decodedtext += '\u2466';
          zapfPostScript += 'a126 ';
          break;
        case 'B3':
          decodedtext += '\u2467';
          zapfPostScript += 'a127 ';
          break;
        case 'B4':
          decodedtext += '\u2468';
          zapfPostScript += 'a128 ';
          break;
        case 'B5':
          decodedtext += '\u2469';
          zapfPostScript += 'a129 ';
          break;
        case 'B6':
          decodedtext += '\u2776';
          zapfPostScript += 'a130 ';
          break;
        case 'B7':
          decodedtext += '\u2777';
          zapfPostScript += 'a131 ';
          break;
        case 'B8':
          decodedtext += '\u2778';
          zapfPostScript += 'a132 ';
          break;
        case 'B9':
          decodedtext += '\u2779';
          zapfPostScript += 'a133 ';
          break;
        case 'BA':
          decodedtext += '\u277A';
          zapfPostScript += 'a134 ';
          break;
        case 'BB':
          decodedtext += '\u277B';
          zapfPostScript += 'a135 ';
          break;
        case 'BC':
          decodedtext += '\u277C';
          zapfPostScript += 'a136 ';
          break;
        case 'BD':
          decodedtext += '\u277D';
          zapfPostScript += 'a137 ';
          break;
        case 'BE':
          decodedtext += '\u277E';
          zapfPostScript += 'a138 ';
          break;
        case 'BF':
          decodedtext += '\u277F';
          zapfPostScript += 'a139 ';
          break;
        case 'C0':
          decodedtext += '\u2780';
          zapfPostScript += 'a140 ';
          break;
        case 'C1':
          decodedtext += '\u2781';
          zapfPostScript += 'a141 ';
          break;
        case 'C2':
          decodedtext += '\u2782';
          zapfPostScript += 'a142 ';
          break;
        case 'C3':
          decodedtext += '\u2783';
          zapfPostScript += 'a143 ';
          break;
        case 'C4':
          decodedtext += '\u2784';
          zapfPostScript += 'a144 ';
          break;
        case 'C5':
          decodedtext += '\u2785';
          zapfPostScript += 'a145 ';
          break;
        case 'C6':
          decodedtext += '\u2786';
          zapfPostScript += 'a146 ';
          break;
        case 'C7':
          decodedtext += '\u2787';
          zapfPostScript += 'a147 ';
          break;
        case 'C8':
          decodedtext += '\u2788';
          zapfPostScript += 'a148 ';
          break;
        case 'C9':
          decodedtext += '\u2789';
          zapfPostScript += 'a149 ';
          break;
        case 'CA':
          decodedtext += '\u278A';
          zapfPostScript += '150 ';
          break;
        case 'CB':
          decodedtext += '\u278B';
          zapfPostScript += 'a151 ';
          break;
        case 'CC':
          decodedtext += '\u278C';
          zapfPostScript += 'a152 ';
          break;
        case 'CD':
          decodedtext += '\u278D';
          zapfPostScript += 'a153 ';
          break;
        case 'CE':
          decodedtext += '\u278E';
          zapfPostScript += 'a154 ';
          break;
        case 'CF':
          decodedtext += '\u278F';
          zapfPostScript += 'a155 ';
          break;
        case 'D0':
          decodedtext += '\u2790';
          zapfPostScript += 'a156 ';
          break;
        case 'D1':
          decodedtext += '\u2791';
          zapfPostScript += 'a157 ';
          break;
        case 'D2':
          decodedtext += '\u2792';
          zapfPostScript += 'a158 ';
          break;
        case 'D3':
          decodedtext += '\u2793';
          zapfPostScript += 'a159 ';
          break;
        case 'D4':
          decodedtext += '\u2794';
          zapfPostScript += 'a160 ';
          break;
        case 'D5':
          decodedtext += '\u2192';
          zapfPostScript += 'a161 ';
          break;
        case 'D6':
          decodedtext += '\u2194';
          zapfPostScript += 'a163 ';
          break;
        case 'D7':
          decodedtext += '\u2195';
          zapfPostScript += 'a164 ';
          break;
        case 'D8':
          decodedtext += '\u2798';
          zapfPostScript += 'a196 ';
          break;
        case 'D9':
          decodedtext += '\u2799';
          zapfPostScript += 'a165 ';
          break;
        case 'DA':
          decodedtext += '\u279A';
          zapfPostScript += 'a192 ';
          break;
        case 'DB':
          decodedtext += '\u279B';
          zapfPostScript += 'a166 ';
          break;
        case 'DC':
          decodedtext += '\u279C';
          zapfPostScript += 'a167 ';
          break;
        case 'DD':
          decodedtext += '\u279D';
          zapfPostScript += 'a168 ';
          break;
        case 'DE':
          decodedtext += '\u279E';
          zapfPostScript += 'a169 ';
          break;
        case 'DF':
          decodedtext += '\u279F';
          zapfPostScript += 'a170 ';
          break;
        case 'E0':
          decodedtext += '\u27A0';
          zapfPostScript += 'a171 ';
          break;
        case 'E1':
          decodedtext += '\u27A1';
          zapfPostScript += 'a172 ';
          break;
        case 'E2':
          decodedtext += '\u27A2';
          zapfPostScript += 'a173 ';
          break;
        case 'E3':
          decodedtext += '\u27A3';
          zapfPostScript += 'a162 ';
          break;
        case 'E4':
          decodedtext += '\u27A4';
          zapfPostScript += 'a174 ';
          break;
        case 'E5':
          decodedtext += '\u27A5';
          zapfPostScript += 'a175 ';
          break;
        case 'E6':
          decodedtext += '\u27A6';
          zapfPostScript += 'a176 ';
          break;
        case 'E7':
          decodedtext += '\u27A7';
          zapfPostScript += 'a177 ';
          break;
        case 'E8':
          decodedtext += '\u27A8';
          zapfPostScript += 'a178 ';
          break;
        case 'E9':
          decodedtext += '\u27A9';
          zapfPostScript += 'a179 ';
          break;
        case 'EA':
          decodedtext += '\u27AA';
          zapfPostScript += 'a193 ';
          break;
        case 'EB':
          decodedtext += '\u27AB';
          zapfPostScript += 'a180 ';
          break;
        case 'EC':
          decodedtext += '\u27AC';
          zapfPostScript += 'a199 ';
          break;
        case 'ED':
          decodedtext += '\u27AD';
          zapfPostScript += 'a181 ';
          break;
        case 'EE':
          decodedtext += '\u27AE';
          zapfPostScript += 'a200 ';
          break;
        case 'EF':
          decodedtext += '\u27AF';
          zapfPostScript += 'a182 ';
          break;
        case 'F1':
          decodedtext += '\u27B1';
          zapfPostScript += 'a201 ';
          break;
        case 'F2':
          decodedtext += '\u27B2';
          zapfPostScript += 'a183 ';
          break;
        case 'F3':
          decodedtext += '\u27B3';
          zapfPostScript += 'a184 ';
          break;
        case 'F4':
          decodedtext += '\u27B4';
          zapfPostScript += 'a197 ';
          break;
        case 'F5':
          decodedtext += '\u27B5';
          zapfPostScript += 'a185 ';
          break;
        case 'F6':
          decodedtext += '\u27B6';
          zapfPostScript += 'a194 ';
          break;
        case 'F7':
          decodedtext += '\u27B7';
          zapfPostScript += 'a198 ';
          break;
        case 'F8':
          decodedtext += '\u27B8';
          zapfPostScript += 'a186 ';
          break;
        case 'F9':
          decodedtext += '\u27B9';
          zapfPostScript += 'a195 ';
          break;
        case 'FA':
          decodedtext += '\u27BA';
          zapfPostScript += 'a187 ';
          break;
        case 'FB':
          decodedtext += '\u27BB';
          zapfPostScript += 'a188 ';
          break;
        case 'FC':
          decodedtext += '\u27BC';
          zapfPostScript += 'a189 ';
          break;
        case 'FD':
          decodedtext += '\u27BD';
          zapfPostScript += 'a190 ';
          break;
        case 'FE':
          decodedtext += '\u27BE';
          zapfPostScript += 'a191 ';
          break;

        default:
          if (reverseMapTable!.containsKey(encodedText)) {
            decodedtext = encodedText;
            final int charPosition = reverseMapTable![decodedtext]!.toInt();
            zapfPostScript = differenceTable[charPosition]!;
          } else {
            decodedtext = '\u2708';
            zapfPostScript = 'a118';
          }
          break;
      }
    }
    return decodedtext;
  }

  String mapDifferenceOfWingDings(String decodedText) {
    if (decodedText.length > 1 && decodedText.contains('c')) {
      if (decodedText.indexOf('c') == 0) {
        decodedText = decodedText.replaceAll(decodedText[0], '');
        int characterValue = 0;
        try {
          characterValue = int.parse(decodedText).toSigned(32);
        } catch (e) {
          characterValue = 0;
        }
        decodedText = String.fromCharCode(characterValue);
      }
    }
    return decodedText;
  }

  String mapCidToGid(String decodedText) {
    String finalText = '';
    bool skip = false;

    for (int i = 0; i < decodedText.length; i++) {
      final int character = decodedText.codeUnitAt(0);
      if (cidToGidTable!.containsKey(character) && !skip) {
        String mappingString = cidToGidTable![character]!;
        if (mappingString.contains('�')) {
          final int index = mappingString.indexOf('�');
          mappingString = mappingString.replaceAll(mappingString[index], '');
        }
        if (mappingString.isNotEmpty) {
          if (!cidToGidReverseMapTable
              .containsKey(mappingString.codeUnitAt(0))) {
            cidToGidReverseMapTable[mappingString.codeUnitAt(0)] = character;
          }
        }
        finalText += mappingString;
        skip = false;
      } else if (tempMapTable.containsKey(character) && !skip) {
        String mappingString = tempMapTable[character]!;
        if (mappingString.contains('�')) {
          final int index = mappingString.indexOf('�');
          mappingString = mappingString.replaceAll(mappingString[index], '');
        }
        finalText += mappingString;
        skip = false;
      } else {
        if (skip) {
          switch (String.fromCharCode(character)) {
            case 'n':
              if (cidToGidTable!.containsKey(10)) {
                finalText += characterMapTable[10]!;
              }
              break;
            case 'r':
              if (cidToGidTable!.containsKey(13)) {
                finalText += characterMapTable[13]!;
              }
              break;
            case 'b':
              if (cidToGidTable!.containsKey(8)) {
                finalText += characterMapTable[8]!;
              }
              break;
            case 'a':
              if (cidToGidTable!.containsKey(7)) {
                finalText += characterMapTable[7]!;
              }
              break;
            case 'f':
              if (cidToGidTable!.containsKey(12)) {
                finalText += characterMapTable[12]!;
              }
              break;
            case 't':
              if (cidToGidTable!.containsKey(9)) {
                finalText += characterMapTable[9]!;
              }
              break;
            case 'v':
              if (cidToGidTable!.containsKey(11)) {
                finalText += characterMapTable[11]!;
              }
              break;
            case "'":
              if (cidToGidTable!.containsKey(39)) {
                finalText += characterMapTable[39]!;
              }
              break;
            default:
              {
                if (cidToGidTable!.containsKey(character)) {
                  finalText += characterMapTable[character]!;
                }
              }
              break;
          }
          skip = false;
        } else if (decodedText[i] == r'\') {
          skip = true;
        }
      }
    }
    return finalText;
  }

  bool hasEscapeCharacter(String text) {
    return text.contains(r'\u0007') ||
        text.contains(r'\') ||
        text.contains(r'\b') ||
        text.contains(r'\f') ||
        text.contains(r'\r') ||
        text.contains(r'\t') ||
        text.contains(r'\n') ||
        text.contains(r'\v') ||
        text.contains(r"\'") ||
        text.contains(r'\u0000');
  }

  // Decodes the octal text in the encoded text.
  String getLiteralString(String encodedText) {
    String decodedText = encodedText;
    int octalIndex = -1;
    int limit = 3;
    bool isMacCharProcessed = false;
    bool isWinAnsiProcessed = false;
    // ignore: use_raw_strings
    while ((decodedText.contains(r'\') && (!decodedText.contains('\\\\'))) ||
        decodedText.contains('\u0000')) {
      String octalText = '';
      if (decodedText.contains(r'\', octalIndex + 1)) {
        octalIndex = decodedText.indexOf(r'\', octalIndex + 1);
      } else {
        octalIndex = decodedText.indexOf('\u0000', octalIndex + 1);
        if (octalIndex < 0) {
          break;
        }
        limit = 2;
      }
      for (int i = octalIndex + 1;
          i <= octalIndex + limit;
          i++) //check for octal characters
      {
        if (i < decodedText.length) {
          int val = 0;
          try {
            val = int.parse(decodedText[i]).toSigned(32);
            if (val <= 8) {
              octalText += decodedText[i];
            }
          } on Exception {
            octalText = '';
            break;
          }
        } else {
          octalText = '';
        }
      }

      if (octalText != '') {
        final int decimalValue = int.parse(octalText, radix: 8).toUnsigned(64);
        String temp = '';
        final String decodedChar = String.fromCharCode(decimalValue);
        if (characterMapTable.isNotEmpty) {
          temp = decodedChar.toString();
        } else if (differencesDictionary.isNotEmpty &&
            differencesDictionary.containsKey(decimalValue.toString())) {
          temp = decodedChar.toString();
        } else {
          if (fontEncoding != 'MacRomanEncoding') {
            final List<int> charbytes = <int>[decimalValue.toUnsigned(8)];
            temp = _getWindows1252DecodedText(charbytes);
            List<String> tempchar;
            tempchar = <String>[
              _getWindows1252DecodedText(<int>[decimalValue.toUnsigned(8)])
            ];
            int charvalue = 0;
            for (final String tempchar1 in tempchar) {
              charvalue = tempchar1.codeUnitAt(0);
            }
            if (!octDecMapTable.containsKey(charvalue)) {
              octDecMapTable[charvalue] = decimalValue;
            }
            isWinAnsiProcessed = true;
          } else {
            final List<int> charbytes = <int>[decimalValue.toUnsigned(8)];
            temp = utf8.decode(charbytes);
            final List<String> tempchar = <String>[
              utf8.decode(<int>[decimalValue.toUnsigned(8)])
            ];
            int charvalue = 0;
            for (final String tempchar1 in tempchar) {
              charvalue = tempchar1.codeUnitAt(0);
            }
            if (!octDecMapTable.containsKey(charvalue)) {
              octDecMapTable[charvalue] = decimalValue;
            }
            isMacCharProcessed = true;
          }
        }
        decodedText =
            decodedText.replaceRange(octalIndex, octalIndex + limit + 1, '');
        final List<String> str = decodedText.split('');
        str.insert(octalIndex, temp);
        decodedText = str.join();
      }
    }
    if (decodedText.contains(r'\') && fontEncoding != 'Identity-H') {
      if (decodedText.length > 1) {
        final int index = decodedText.indexOf(r'\');
        final String char = decodedText[index + 1];
        if (char == '(' || char == ')') {
          _unescape(decodedText);
          // ignore: use_raw_strings
        } else if (!decodedText.contains('\\\\')) {
          int initialLength = 0;
          while ((decodedText.contains(r'\')) &&
              (decodedText.length != initialLength)) {
            initialLength = decodedText.length;
            decodedText = skipEscapeSequence(decodedText);
          }
        }
      }
    }
    if ((fontEncoding == 'MacRomanEncoding') && (!isMacCharProcessed)) {
      getMacEncodeTable();
      for (int i = 0; i < decodedText.length; i++) {
        final int decimalValue = decodedText[i].codeUnitAt(0);
        if (_macEncodeTable!.containsValue(decodedText[i].toString())) {
          if (!_macRomanMapTable.containsKey(decimalValue)) {
            final int charbytes = decimalValue.toUnsigned(8);
            _macRomanMapTable[decimalValue] = String.fromCharCode(charbytes);
          }
        }
      }
    }
    if ((fontEncoding == 'WinAnsiEncoding') && (!isWinAnsiProcessed)) {
      for (int i = 0; i < encodedText.length; i++) {
        final int decimalValue = encodedText[i].codeUnitAt(0);
        //// In WinAnsiEncoding, all unused codes greater than 40 map to the bullet character.
        if (decimalValue == 127 ||
            decimalValue == 129 ||
            decimalValue == 131 ||
            decimalValue == 136 ||
            decimalValue == 141 ||
            decimalValue == 143 ||
            decimalValue == 144 ||
            decimalValue == 152 ||
            decimalValue == 157 ||
            decimalValue == 173 ||
            decimalValue == 209) {
          final String mappedChar = String.fromCharCode(149);
          if (!_winansiMapTable.containsKey(decimalValue)) {
            _winansiMapTable[decimalValue] = mappedChar.toString();
          }
        }
      }
    }
    return decodedText;
  }

  String _getWindows1252DecodedText(List<int> charcodes) {
    String result = '';
    // ignore: avoid_function_literals_in_foreach_calls
    charcodes.forEach((int code) {
      if (code >= 0 && code < 256) {
        result += _windows1252MapTable[code];
      }
    });
    return result;
  }

// Decodes the HEX encoded string and returns Decoded string.
  String getHexaDecimalString(String hexEncodedText) {
    String decodedText = '';
    // IsHexaDecimalString = true;
    if (hexEncodedText.isNotEmpty) {
      final _PdfName fontType =
          fontDictionary._items![_PdfName('Subtype')]! as _PdfName;
      int limit = 2;
      if (fontType._name != 'Type1' &&
          fontType._name != 'TrueType' &&
          fontType._name != 'Type3') {
        limit = 4;
      }
      hexEncodedText = escapeSymbols(hexEncodedText);
      final String tempHexEncodedText = hexEncodedText;
      final String tempDecodedText = decodedText;
      late String decodedTxt;
      while (hexEncodedText.isNotEmpty) {
        if (hexEncodedText.length % 4 != 0) {
          limit = 2;
        }
        String hexChar = hexEncodedText.substring(0, limit);

        if (fontDictionary.containsKey(_DictionaryProperties.descendantFonts) &&
            !fontDictionary.containsKey(_DictionaryProperties.toUnicode)) {
          final _PdfArray? descendantArray =
              fontDictionary[_DictionaryProperties.descendantFonts]
                  as _PdfArray?;
          if (descendantArray != null) {
            _PdfDictionary? descendantDictionary;
            if (descendantArray[0] is _PdfReferenceHolder) {
              descendantDictionary =
                  (descendantArray[0]! as _PdfReferenceHolder).object
                      as _PdfDictionary?;
            } else if (descendantArray[0] is _PdfDictionary) {
              descendantDictionary = descendantArray[0]! as _PdfDictionary;
            }
            if (descendantDictionary != null) {
              _PdfDictionary? descriptorDictionary;
              if (descendantDictionary
                  .containsKey(_DictionaryProperties.fontDescriptor)) {
                _IPdfPrimitive? primitive =
                    descendantDictionary[_DictionaryProperties.fontDescriptor];
                if (primitive is _PdfReferenceHolder) {
                  primitive = primitive.object;
                  if (primitive != null && primitive is _PdfDictionary) {
                    descriptorDictionary = primitive;
                  }
                } else if (primitive is _PdfDictionary) {
                  descriptorDictionary = primitive;
                }
              }
              if (descriptorDictionary != null) {
                if (descendantDictionary
                        .containsKey(_DictionaryProperties.subtype) &&
                    !descriptorDictionary
                        .containsKey(_DictionaryProperties.fontFile2)) {
                  final _PdfName subtype =
                      descendantDictionary[_DictionaryProperties.subtype]!
                          as _PdfName;
                  if (subtype._name == 'CIDFontType2') {
                    hexChar = mapHebrewCharacters(hexChar);
                  }
                }
              }
            }
          } else if (fontDictionary._items!
              .containsKey(_PdfName(_DictionaryProperties.descendantFonts))) {
            final _PdfReferenceHolder? descendantFontArrayReference =
                fontDictionary._items![
                        _PdfName(_DictionaryProperties.descendantFonts)]
                    as _PdfReferenceHolder?;
            if (descendantFontArrayReference != null) {
              _PdfName? subtype;
              final _PdfArray descendantFontArray =
                  descendantFontArrayReference.object! as _PdfArray;
              if (descendantFontArray[0] is _PdfReferenceHolder) {
                final _PdfDictionary? descendantDictionary =
                    (descendantFontArray[0]! as _PdfReferenceHolder).object
                        as _PdfDictionary?;
                if (descendantDictionary != null &&
                    descendantDictionary
                        .containsKey(_DictionaryProperties.cidSystemInfo) &&
                    descendantDictionary
                        .containsKey(_DictionaryProperties.subtype)) {
                  subtype = descendantDictionary[_DictionaryProperties.subtype]
                      as _PdfName?;
                  final _PdfDictionary? cidSystemInfo = (descendantDictionary[
                              _DictionaryProperties.cidSystemInfo]!
                          as _PdfReferenceHolder)
                      .object as _PdfDictionary?;
                  if (cidSystemInfo != null &&
                      cidSystemInfo
                          .containsKey(_DictionaryProperties.registry) &&
                      cidSystemInfo
                          .containsKey(_DictionaryProperties.ordering) &&
                      cidSystemInfo
                          .containsKey(_DictionaryProperties.supplement)) {
                    final _PdfString pdfRegistry =
                        cidSystemInfo[_DictionaryProperties.registry]!
                            as _PdfString;
                    final _PdfNumber? pdfSupplement =
                        cidSystemInfo[_DictionaryProperties.supplement]
                            as _PdfNumber?;
                    final _PdfString? pdfOrdering =
                        cidSystemInfo[_DictionaryProperties.ordering]
                            as _PdfString?;
                    if (pdfRegistry.value != null &&
                        pdfSupplement!.value != null &&
                        pdfOrdering!.value != null) {
                      if (pdfRegistry.value == 'Adobe' &&
                          pdfOrdering.value == 'Identity' &&
                          pdfSupplement.value == 0 &&
                          subtype!._name == 'CIDFontType2' &&
                          cidSystemInfoDictionary == null &&
                          !isContainFontfile2) {
                        isAdobeIdentity = true;
                        hexChar = mapIdentityCharacters(hexChar);
                      }
                    }
                  }
                }
              }
            }
          }
        }
        decodedText +=
            String.fromCharCode(int.parse(hexChar, radix: 16).toSigned(64));
        hexEncodedText = hexEncodedText.substring(limit, hexEncodedText.length);
        decodedTxt = decodedText.toString();
      }
      if ((decodedTxt.contains('') ||
              decodedTxt.contains('') ||
              decodedTxt.contains('')) &&
          tempHexEncodedText.length < limit) {
        decodedText = tempDecodedText;
        final int hexNum =
            int.parse(tempHexEncodedText, radix: 16).toSigned(32);
        hexEncodedText = String.fromCharCode(hexNum);
        decodedText += hexEncodedText;
      }
    }
    return decodedText;
  }

  String mapHebrewCharacters(String hexChar) {
    if (hexChar.substring(0, 2) == '02') {
      int i = int.parse(hexChar);
      i += 816;
      hexChar = i.toRadixString(16);
    } else if (hexChar.substring(0, 2) == '00') {
      if (hexChar.substring(2, 3) == '0' || hexChar.substring(2, 3) == '1') {
        int i = int.parse(hexChar);
        i += 29;
        hexChar = i.toRadixString(16);
      } else {
        int i = int.parse(hexChar);
        i += 1335;
        hexChar = i.toRadixString(16);
      }
    }
    return hexChar;
  }

  String mapIdentityCharacters(String hexChar) {
    if (hexChar.substring(0, 2) == '00') {
      if (hexChar.substring(2, 3) != '0' || hexChar.substring(2, 3) != '1') {
        int i = int.parse(hexChar);
        i += 29;
        hexChar = i.toRadixString(16);
      } else {
        int i = int.parse(hexChar);
        i += 1335;
        hexChar = i.toRadixString(16);
      }
    }
    return hexChar;
  }

  // Method to remove the new line character
  String escapeSymbols(String text) {
    while (text.contains('\n')) {
      text = text.replaceAll('\n', '');
    }
    return text;
  }

  // Takes in the decoded text and maps it with its
  // corresponding entry in the CharacterMapTable
  String mapCharactersFromTable(String decodedText) {
    String finalText = '';
    bool skip = false;
    for (int i = 0; i < decodedText.length; i++) {
      final String character = decodedText[i];
      if (characterMapTable.containsKey(character.codeUnitAt(0)) && !skip) {
        String mappingString = characterMapTable[character.codeUnitAt(0)]!;
        if (mappingString.contains('�')) {
          mappingString = mappingString.replaceAll('�', '');
          if (fontName!.contains('ZapfDingbats')) {
            mappingString = character.toString();
          }
        }
        if (fontEncoding != 'Identity-H' &&
            !isTextExtraction &&
            characterMapTable.length != reverseMapTable!.length) {
          if (isCancel(mappingString) ||
              isNonPrintableCharacter(
                  character)) //Contains 'CANCEL' of ASCII value 24
          {
            mappingString = character.toString();
          }
        }
        finalText += mappingString;
        skip = false;
      } else if (!characterMapTable.containsKey(character.codeUnitAt(0)) &&
          !skip) {
        final List<int> bytes = _encodeBigEndian(character.toString());
        if (bytes[0] != 92) {
          if (characterMapTable.containsKey(bytes[0])) {
            finalText += characterMapTable[bytes[0]]!;
            skip = false;
          }
        }
      } else if (tempMapTable.containsKey(character.codeUnitAt(0)) && !skip) {
        String? mappingString = tempMapTable[character.codeUnitAt(0)];
        if (character == r'\' && isTextExtraction) {
          mappingString = '';
        }
        if (mappingString!.contains('�')) {
          final int index = mappingString.indexOf('�');
          mappingString = mappingString.replaceAll(mappingString[index], '');
        }
        finalText += mappingString;
        skip = false;
      } else {
        if (skip) {
          switch (character.toString()) {
            case 'n':
              if (characterMapTable.containsKey(10)) {
                finalText += characterMapTable[10]!;
              }
              break;
            case 'r':
              if (characterMapTable.containsKey(13)) {
                finalText += characterMapTable[13]!;
              }
              break;
            case 'b':
              if (characterMapTable.containsKey(8)) {
                finalText += characterMapTable[8]!;
              }
              break;
            case 'a':
              if (characterMapTable.containsKey(7)) {
                finalText += characterMapTable[7]!;
              }
              break;
            case 'f':
              if (characterMapTable.containsKey(12)) {
                finalText += characterMapTable[12]!;
              }
              break;
            case 't':
              if (characterMapTable.containsKey(9)) {
                finalText += characterMapTable[9]!;
              }
              break;
            case 'v':
              if (characterMapTable.containsKey(11)) {
                finalText += characterMapTable[11]!;
              }
              break;
            case "'":
              if (characterMapTable.containsKey(39)) {
                finalText += characterMapTable[39]!;
              }
              break;
            default:
              {
                if (characterMapTable.containsKey(character.codeUnitAt(0))) {
                  finalText += characterMapTable[character.codeUnitAt(0)]!;
                }
              }
              break;
          }
          skip = false;
        } else if (character == r'\') {
          skip = true;
        } else {
          finalText += character;
        }
      }
    }
    return finalText;
  }

  bool isCancel(String mappingString) {
    bool isCancel = false;
    if (mappingString == '') {
      isCancel = true;
    }
    return isCancel;
  }

  // Checks whether the specified character is Non-Printable character or not.
  bool isNonPrintableCharacter(String str) {
    bool isNonPrintable = false;
    if (!isTextExtraction &&
        fontType!._name == 'Type1' &&
        fontEncoding == 'Encoding' &&
        fontName != 'ZapfDingbats' &&
        (characterMapTable.length == differencesDictionary.length)) {
      final int character = str.codeUnitAt(0);
      if ((character >= 0 && character <= 31) || character == 127) {
        isNonPrintable = true;
      }
    }
    return isNonPrintable;
  }
}
