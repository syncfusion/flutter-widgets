part of pdf;

class _UnicodeTrueTypeFont {
  _UnicodeTrueTypeFont(List<int> fontData, double size) {
    _initialize(fontData, size);
  }

  //Constants
  final String _cmapPrefix =
      '/CIDInit /ProcSet findresource begin\n12 dict begin\nbegincmap' +
          _Operators.newLine +
          '/CIDSystemInfo << /Registry (Adobe)/Ordering (UCS)/Supplement 0>> def\n/CMapName ' +
          '/Adobe-Identity-UCS def\n/CMapType 2 def\n1 begincodespacerange' +
          _Operators.newLine;

  /// Cmap table's start suffix.
  final String _cmapEndCodespaceRange =
      'endcodespacerange' + _Operators.newLine;

  /// Cmap's begin range marker.
  final String _cmapBeginRange = 'beginbfrange' + _Operators.newLine;

  /// Cmap's end range marker.
  final String _cmapEndRange = 'endbfrange' + _Operators.newLine;

  /// Cmap table's end
  final String _cmapSuffix =
      'endbfrange\nendcmap\nCMapName currentdict /CMap defineresource pop\nend end' +
          _Operators.newLine;

  //Fields
  List<int> _fontData;
  double _size;
  _TtfReader _reader;
  _TtfMetrics _ttfMetrics;
  _PdfFontMetrics _metrics;
  _PdfDictionary _fontDictionary;
  _PdfStream _fontProgram;
  _PdfStream _cmap;
  _PdfDictionary _descendantFont;
  String _subsetName;
  Map<String, String> _usedChars;
  _PdfDictionary _fontDescriptor;
  _PdfStream _cidStream;

  //Implementation
  void _initialize(List<int> fontData, double size) {
    _fontData = fontData;
    _size = size;
    _reader = _TtfReader(_fontData);
    _ttfMetrics = _reader._metrics;
  }

  void _createInternals() {
    _fontDictionary = _PdfDictionary();
    _fontProgram = _PdfStream();
    _cmap = _PdfStream();
    _descendantFont = _PdfDictionary();
    _metrics = _PdfFontMetrics();
    _reader._createInternals();
    _ttfMetrics = _reader._metrics;
    _initializeMetrics();
    _subsetName = _getFontName(_reader._metrics.postScriptName);
    _createDescendantFont();
    _createCmap();
    _createFontDictionary();
    _createFontProgram();
  }

  void _initializeMetrics() {
    final _TtfMetrics ttfMetrics = _reader._metrics;
    _metrics.ascent = ttfMetrics.macAscent;
    _metrics.descent = ttfMetrics.macDescent;
    _metrics.height =
        ttfMetrics.macAscent - ttfMetrics.macDescent + ttfMetrics.lineGap;
    _metrics.name = ttfMetrics.fontFamily;
    _metrics.postScriptName = ttfMetrics.postScriptName;
    _metrics.size = _size;
    _metrics._widthTable = _StandardWidthTable(ttfMetrics.widthTable);
    _metrics.lineGap = ttfMetrics.lineGap;
    _metrics.subscriptSizeFactor = ttfMetrics.subscriptSizeFactor;
    _metrics.superscriptSizeFactor = ttfMetrics.superscriptSizeFactor;
    _metrics.isBold = ttfMetrics.isBold;
  }

  String _getFontName(String postScriptName) {
    const String nameString = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    String builder = '';
    for (int i = 0; i < postScriptName.length; i++) {
      switch (postScriptName[i]) {
        case '(':
          builder += '#28';
          break;
        case ')':
          builder += '#29';
          break;
        case '[':
          builder += '#5B';
          break;
        case ']':
          builder += '#5D';
          break;
        case '<':
          builder += '#3C';
          break;
        case '>':
          builder += '#3E';
          break;
        case '{':
          builder += '#7B';
          break;
        case '}':
          builder += '#7D';
          break;
        case '/':
          builder += '#2F';
          break;
        case '%':
          builder += '#25';
          break;
        case ' ':
          builder += '#20';
          break;
        default:
          builder += postScriptName[i];
      }
    }
    String name = '';
    for (int i = 0; i < 6; i++) {
      name += nameString[Random().nextInt(26)];
    }
    return name + '+' + builder;
  }

  void _createDescendantFont() {
    _descendantFont._beginSave = _descendantFontBeginSave;
    _descendantFont[_DictionaryProperties.type] =
        _PdfName(_DictionaryProperties.font);
    _descendantFont[_DictionaryProperties.subtype] =
        _PdfName(_DictionaryProperties.cidFontType2);
    _descendantFont[_DictionaryProperties.baseFont] = _PdfName(_subsetName);
    _descendantFont[_DictionaryProperties.cidToGIDMap] =
        _PdfName(_DictionaryProperties.identity);
    _descendantFont[_DictionaryProperties.dw] = _PdfNumber(1000);
    _fontDescriptor = _createFontDescriptor();
    _descendantFont[_DictionaryProperties.fontDescriptor] =
        _PdfReferenceHolder(_fontDescriptor);
    _descendantFont[_DictionaryProperties.cidSystemInfo] = _createSystemInfo();
  }

  _PdfDictionary _createFontDescriptor() {
    final _PdfDictionary descriptor = _PdfDictionary();
    final _TtfMetrics metrics = _reader._metrics;
    descriptor[_DictionaryProperties.type] =
        _PdfName(_DictionaryProperties.fontDescriptor);
    descriptor[_DictionaryProperties.fontName] = _PdfName(_subsetName);
    descriptor[_DictionaryProperties.flags] = _PdfNumber(_getDescriptorFlags());
    final _Rectangle rect = _reader._metrics.fontBox;
    descriptor[_DictionaryProperties.fontBBox] = _PdfArray(
        <double>[rect.x, rect.y + rect.height, rect.width, -rect.height]);
    descriptor[_DictionaryProperties.missingWidth] =
        _PdfNumber(metrics.widthTable[32]);
    descriptor[_DictionaryProperties.stemV] = _PdfNumber(metrics.stemV);
    descriptor[_DictionaryProperties.italicAngle] =
        _PdfNumber(metrics.italicAngle);
    descriptor[_DictionaryProperties.capHeight] = _PdfNumber(metrics.capHeight);
    descriptor[_DictionaryProperties.ascent] = _PdfNumber(metrics.winAscent);
    descriptor[_DictionaryProperties.descent] = _PdfNumber(metrics.winDescent);
    descriptor[_DictionaryProperties.leading] = _PdfNumber(metrics.leading);
    descriptor[_DictionaryProperties.avgWidth] =
        _PdfNumber(metrics.widthTable[32]);
    descriptor[_DictionaryProperties.fontFile2] =
        _PdfReferenceHolder(_fontProgram);
    descriptor[_DictionaryProperties.maxWidth] =
        _PdfNumber(metrics.widthTable[32]);
    descriptor[_DictionaryProperties.xHeight] = _PdfNumber(0);
    descriptor[_DictionaryProperties.stemH] = _PdfNumber(0);
    return descriptor;
  }

  int _getDescriptorFlags() {
    int flags = 0;
    final _TtfMetrics metrics = _reader._metrics;
    if (metrics.isFixedPitch) {
      flags |= 1;
    }
    if (metrics.isSymbol) {
      flags |= 4;
    } else {
      flags |= 32;
    }
    if (metrics.isItalic) {
      flags |= 64;
    }
    if (metrics.isBold) {
      flags |= 0x40000;
    }
    return flags;
  }

  _IPdfPrimitive _createSystemInfo() {
    final _PdfDictionary systemInfo = _PdfDictionary();
    systemInfo[_DictionaryProperties.registry] = _PdfString('Adobe');
    systemInfo[_DictionaryProperties.ordering] =
        _PdfString(_DictionaryProperties.identity);
    systemInfo[_DictionaryProperties.supplement] = _PdfNumber(0);
    return systemInfo;
  }

  void _descendantFontBeginSave(Object sender, _SavePdfPrimitiveArgs ars) {
    if (_usedChars != null && _usedChars.isNotEmpty) {
      final _PdfArray width = _getDescendantWidth();
      if (width != null) {
        _descendantFont[_DictionaryProperties.w] = width;
      }
    }
  }

  void _createCmap() {
    _cmap._beginSave = _cmapBeginSave;
  }

  void _cmapBeginSave(Object sender, _SavePdfPrimitiveArgs ars) {
    _generateCmap();
  }

  void _createFontDictionary() {
    _fontDictionary._beginSave = _fontDictionaryBeginSave;
    _fontDictionary[_DictionaryProperties.type] =
        _PdfName(_DictionaryProperties.font);
    _fontDictionary[_DictionaryProperties.baseFont] = _PdfName(_subsetName);
    _fontDictionary[_DictionaryProperties.subtype] =
        _PdfName(_DictionaryProperties.type0);
    _fontDictionary[_DictionaryProperties.encoding] =
        _PdfName(_DictionaryProperties.identityH);
    final _PdfArray descFonts = _PdfArray();
    final _PdfReferenceHolder reference = _PdfReferenceHolder(_descendantFont);
    descFonts._add(reference);
    _fontDictionary[_DictionaryProperties.descendantFonts] = descFonts;
  }

  void _fontDictionaryBeginSave(Object sender, _SavePdfPrimitiveArgs ars) {
    if (_usedChars != null &&
        _usedChars.isNotEmpty &&
        !_fontDictionary.containsKey(_DictionaryProperties.toUnicode)) {
      _fontDictionary[_DictionaryProperties.toUnicode] =
          _PdfReferenceHolder(_cmap);
    }
  }

  _PdfArray _getDescendantWidth() {
    final _PdfArray array = _PdfArray();
    if (_usedChars != null && _usedChars.isNotEmpty) {
      final List<_TtfGlyphInfo> glyphInfo = <_TtfGlyphInfo>[];
      final List<String> keys = _usedChars.keys.toList();
      for (int i = 0; i < keys.length; i++) {
        final String chLen = keys[i];
        final _TtfGlyphInfo glyph = _reader._getGlyph(char: chLen);
        if (glyph.empty) {
          continue;
        }
        glyphInfo.add(glyph);
      }
      glyphInfo.sort(
          (_TtfGlyphInfo a, _TtfGlyphInfo b) => a.index.compareTo(b.index));
      int firstGlyphIndex = 0;
      int lastGlyphIndex = 0;
      bool firstGlyphIndexWasSet = false;
      _PdfArray widthDetails = _PdfArray();
      for (int i = 0; i < glyphInfo.length; i++) {
        final _TtfGlyphInfo glyph = glyphInfo[i];
        if (!firstGlyphIndexWasSet) {
          firstGlyphIndexWasSet = true;
          firstGlyphIndex = glyph.index;
          lastGlyphIndex = glyph.index - 1;
        }
        if ((lastGlyphIndex + 1 != glyph.index ||
                (i + 1 == glyphInfo.length)) &&
            glyphInfo.length > 1) {
          array._add(_PdfNumber(firstGlyphIndex));
          if (i != 0) {
            array._add(widthDetails);
          }
          firstGlyphIndex = glyph.index;
          widthDetails = _PdfArray();
        }
        widthDetails._add(_PdfNumber(glyph.width));
        if (i + 1 == glyphInfo.length) {
          array._add(_PdfNumber(firstGlyphIndex));
          array._add(widthDetails);
        }
        lastGlyphIndex = glyph.index;
      }
    }
    return array;
  }

  void _generateCmap() {
    if (_usedChars != null && _usedChars.isNotEmpty) {
      final Map<int, int> glyphChars = _reader._getGlyphChars(_usedChars);
      if (glyphChars.isNotEmpty) {
        final List<int> keys = glyphChars.keys.toList();
        keys.sort();
        final int first = keys[0];
        final int last = keys[keys.length - 1];
        final String middlePart = _getHexString(first, false) +
            _getHexString(last, false) +
            _Operators.newLine;
        String builder = '';
        builder += _cmapPrefix;
        builder += middlePart;
        builder += _cmapEndCodespaceRange;
        int nextRange = 0;
        for (int i = 0; i < keys.length; i++) {
          if (nextRange == 0) {
            if (i != 0) {
              builder += _cmapEndRange;
            }
            nextRange = 100 <= keys.length - i ? 100 : keys.length - i;
            builder += nextRange.toString();
            builder += _Operators.whiteSpace;
            builder += _cmapBeginRange;
          }
          nextRange -= 1;
          final int key = keys[i];
          builder += _getHexString(key, true) +
              _getHexString(key, true) +
              _getHexString(glyphChars[key], true) +
              '\n';
        }
        builder += _cmapSuffix;
        _cmap._clearStream();
        _cmap._write(builder);
      }
    }
  }

  void _createFontProgram() {
    _fontProgram._beginSave = _fontProgramBeginSave;
  }

  void _fontProgramBeginSave(Object sender, _SavePdfPrimitiveArgs ars) {
    _generateFontProgram();
  }

  void _generateFontProgram() {
    List<int> fontProgram;
    _usedChars ??= <String, String>{};
    _reader._offset = 0;
    fontProgram = _reader._readFontProgram(_usedChars);
    _fontProgram._clearStream();
    _fontProgram._write(fontProgram);
  }

  String _getHexString(int n, bool isCaseChange) {
    String s = n.toRadixString(16);
    if (isCaseChange) {
      s = s.toUpperCase();
    }
    return '<0000'.substring(0, 5 - s.length) + s + '>';
  }

  double _getLineWidth(String line) {
    double width = 0;
    for (int i = 0; i < line.length; i++) {
      width += _reader._getCharWidth(line[i]);
    }
    return width;
  }

  void _setSymbols(String text) {
    ArgumentError.checkNotNull(text);
    _usedChars ??= <String, String>{};
    for (int i = 0; i < text.length; i++) {
      _usedChars[text[i]] = String.fromCharCode(0);
    }
    _getDescendantWidth();
  }

  double _getCharWidth(String charCode) {
    return _reader._getCharWidth(charCode);
  }

  void _initializeCidSet() {
    _cidStream = _PdfStream();
    _cidStream._beginSave = _cidBeginSave;
    _fontDescriptor._beginSave = _fontDescriptorBeginSave;
  }

  //Runs before Cid will be saved.
  void _cidBeginSave(Object sender, _SavePdfPrimitiveArgs ars) {
    _generateCidSet();
  }

  //Runs before font Dictionary will be saved.
  void _fontDescriptorBeginSave(Object sender, _SavePdfPrimitiveArgs ars) {
    if ((_usedChars != null && _usedChars.isNotEmpty) &&
        !_fontDescriptor.containsKey(_DictionaryProperties.cidSet)) {
      _fontDescriptor[_DictionaryProperties.cidSet] =
          _PdfReferenceHolder(_cidStream);
    }
  }

  //This is important for PDF/A conformance validation
  void _generateCidSet() {
    final List<int> dummyBits = [
      0x80,
      0x40,
      0x20,
      0x10,
      0x08,
      0x04,
      0x02,
      0x01
    ];
    if (_usedChars != null && _usedChars.isNotEmpty) {
      final Map<int, int> glyphChars = _reader._getGlyphChars(_usedChars);
      List<int> charBytes;
      if (glyphChars.isNotEmpty) {
        final List<int> cidChars = glyphChars.keys.toList();
        cidChars.sort();
        final int last = cidChars[cidChars.length - 1];
        charBytes = List<int>((last ~/ 8) + 1);
        charBytes.fillRange(0, ((last ~/ 8) + 1), 0);
        for (int i = 0; i < cidChars.length; i++) {
          final int cid = cidChars[i];
          charBytes[cid ~/ 8] |= dummyBits[cid % 8];
        }
      }
      _cidStream._write(charBytes);
    }
  }
}
