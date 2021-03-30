part of pdf;

class _TtfReader {
  _TtfReader(List<int> fontData) {
    _fontData = fontData;
    _initialize();
  }

  //Constants
  final int _int32Size = 4;
  final List<String> _tableNames = <String>[
    'cvt ',
    'fpgm',
    'glyf',
    'head',
    'hhea',
    'hmtx',
    'loca',
    'maxp',
    'prep'
  ];
  final List<int> _entrySelectors = <int>[
    0,
    0,
    1,
    1,
    2,
    2,
    2,
    2,
    3,
    3,
    3,
    3,
    3,
    3,
    3,
    3,
    4,
    4,
    4,
    4,
    4
  ];

  //Fields
  late List<int> _fontData;
  _TtfMetrics? _metrics;
  int? _offset;
  late bool _isMacTtf;
  late bool _isTtcFont;
  Map<String, _TtfTableInfo>? _tableDirectory;
  Map<int, _TtfGlyphInfo>? _macintoshDirectory;
  Map<int, _TtfGlyphInfo>? _microsoftDirectory;
  Map<int, _TtfGlyphInfo>? _macintoshGlyphInfoCollection;
  Map<int, _TtfGlyphInfo>? _microsoftGlyphInfoCollection;
  int? _lowestPosition;
  late bool _isLocaShort;
  late List<int> _width;
  int? _maxMacIndex;

  //Properties
  Map<int, _TtfGlyphInfo>? get _macintosh {
    _macintoshDirectory ??= <int, _TtfGlyphInfo>{};
    return _macintoshDirectory;
  }

  Map<int, _TtfGlyphInfo>? get _microsoft {
    _microsoftDirectory ??= <int, _TtfGlyphInfo>{};
    return _microsoftDirectory;
  }

  Map<int, _TtfGlyphInfo>? get _macintoshGlyphs {
    _macintoshGlyphInfoCollection ??= <int, _TtfGlyphInfo>{};
    return _macintoshGlyphInfoCollection;
  }

  Map<int, _TtfGlyphInfo>? get _microsoftGlyphs {
    _microsoftGlyphInfoCollection ??= <int, _TtfGlyphInfo>{};
    return _microsoftGlyphInfoCollection;
  }

  //Implementation
  void _initialize() {
    _isMacTtf = false;
    _isTtcFont = false;
    _metrics = _TtfMetrics();
    _readFontDictionary();
    final _TtfNameTable nameTable = _readNameTable();
    final _TtfHeadTable headTable = _readHeadTable();
    _initializeFontName(nameTable);
    _metrics!.macStyle = headTable.macStyle;
  }

  void _readFontDictionary() {
    _offset = 0;
    _checkPreambula();
    final int numTables = _readInt16(_offset!);
    //searchRange
    _readInt16(_offset!);
    //entrySelector
    _readInt16(_offset!);
    //rangeShift
    _readInt16(_offset!);
    _tableDirectory ??= <String, _TtfTableInfo>{};
    for (int i = 0; i < numTables; ++i) {
      final _TtfTableInfo table = _TtfTableInfo();
      final String tableKey = _readString(_int32Size);
      table.checksum = _readInt32(_offset!);
      table.offset = _readInt32(_offset!);
      table.length = _readInt32(_offset!);
      _tableDirectory![tableKey] = table;
    }
    _lowestPosition = _offset;
    if (!_isTtcFont) {
      _fixOffsets();
    }
  }

  void _checkPreambula() {
    final int version = _readInt32(_offset!);
    _isMacTtf = version == 0x74727565;
    if (version != 0x10000 && !_isMacTtf && version != 0x4f54544f) {
      _isTtcFont = true;
      _offset = 0;
      if (_readString(4) != 'ttcf') {
        throw UnsupportedError('Can not read TTF font data');
      }
      _offset = _offset! + 4;
      if (_readInt32(_offset!) < 0) {
        throw UnsupportedError('Can not read TTF font data');
      }
      //Offset for version
      _offset = _readInt32(_offset!);
      //Version
      _readInt32(_offset!);
    }
  }

  void _fixOffsets() {
    int minOffset = pow(2, 53) as int;
    // Search for a smallest offset and compare it
    // with the lowest position found.
    final List<String> keys = _tableDirectory!.keys.toList();
    for (int i = 0; i < keys.length; i++) {
      final int offset = _tableDirectory![keys[i]]!.offset!;
      if (minOffset > offset) {
        minOffset = offset;
        if (minOffset <= _lowestPosition!) {
          break;
        }
      }
    }
    final int shift = minOffset - _lowestPosition!;
    if (shift != 0) {
      final Map<String, _TtfTableInfo> table = <String, _TtfTableInfo>{};
      for (int i = 0; i < keys.length; i++) {
        final _TtfTableInfo value = _tableDirectory![keys[i]]!;
        value.offset = value.offset! - shift;
        table[keys[i]] = value;
      }
      _tableDirectory = table;
    }
  }

  _TtfNameTable _readNameTable() {
    final _TtfTableInfo tableInfo = _getTable('name')!;
    _offset = tableInfo.offset;
    final _TtfNameTable table = _TtfNameTable();
    table.formatSelector = _readUInt16(_offset!);
    table.recordsCount = _readUInt16(_offset!);
    table.offset = _readUInt16(_offset!);
    table.nameRecords = <_TtfNameRecord>[];
    const int recordSize = 12;
    int? position = _offset;
    for (int i = 0; i < table.recordsCount; i++) {
      _offset = position;
      final _TtfNameRecord record = _TtfNameRecord();
      record.platformID = _readUInt16(_offset!);
      record.encodingID = _readUInt16(_offset!);
      record.languageID = _readUInt16(_offset!);
      record.nameID = _readUInt16(_offset!);
      record.length = _readUInt16(_offset!);
      record.offset = _readUInt16(_offset!);
      _offset = tableInfo.offset! + table.offset + record.offset;
      final bool isUnicode = record.platformID == 0 || record.platformID == 3;
      record.name = _readString(record.length, isUnicode);
      table.nameRecords.add(record);
      position = position! + recordSize;
    }
    return table;
  }

  _TtfHeadTable _readHeadTable() {
    final _TtfTableInfo tableInfo = _getTable('head')!;
    _offset = tableInfo.offset;
    final _TtfHeadTable table = _TtfHeadTable();
    table.version = _readFixed(_offset!);
    table.fontRevision = _readFixed(_offset!);
    table.checkSumAdjustment = _readUInt32(_offset!);
    table.magicNumber = _readUInt32(_offset!);
    table.flags = _readUInt16(_offset!);
    table.unitsPerEm = _readUInt16(_offset!);
    table.created = _readInt64(_offset!);
    table.modified = _readInt64(_offset!);
    table.xMin = _readInt16(_offset!);
    table.yMin = _readInt16(_offset!);
    table.xMax = _readInt16(_offset!);
    table.yMax = _readInt16(_offset!);
    table.macStyle = _readUInt16(_offset!);
    table.lowestReadableSize = _readUInt16(_offset!);
    table.fontDirectionHint = _readInt16(_offset!);
    table.indexToLocalFormat = _readInt16(_offset!);
    table.glyphDataFormat = _readInt16(_offset!);
    return table;
  }

  _TtfHorizontalHeaderTable _readHorizontalHeaderTable() {
    final _TtfTableInfo tableInfo = _getTable('hhea')!;
    _offset = tableInfo.offset;
    final _TtfHorizontalHeaderTable table = _TtfHorizontalHeaderTable();
    table.version = _readFixed(_offset!);
    table.ascender = _readInt16(_offset!);
    table.descender = _readInt16(_offset!);
    table.lineGap = _readInt16(_offset!);
    table.advanceWidthMax = _readUInt16(_offset!);
    table.minLeftSideBearing = _readInt16(_offset!);
    table.minRightSideBearing = _readInt16(_offset!);
    table.xMaxExtent = _readInt16(_offset!);
    table.caretSlopeRise = _readInt16(_offset!);
    table.caretSlopeRun = _readInt16(_offset!);
    _offset = _offset! + 10;
    table.metricDataFormat = _readInt16(_offset!);
    table.numberOfHMetrics = _readUInt16(_offset!);
    return table;
  }

  _TtfOS2Table _readOS2Table() {
    final _TtfTableInfo tableInfo = _getTable('OS/2')!;
    _offset = tableInfo.offset;
    final _TtfOS2Table table = _TtfOS2Table();
    table.version = _readUInt16(_offset!);
    table.xAvgCharWidth = _readInt16(_offset!);
    table.usWeightClass = _readUInt16(_offset!);
    table.usWidthClass = _readUInt16(_offset!);
    table.fsType = _readInt16(_offset!);
    table.ySubscriptXSize = _readInt16(_offset!);
    table.ySubscriptYSize = _readInt16(_offset!);
    table.ySubscriptXOffset = _readInt16(_offset!);
    table.ySubscriptYOffset = _readInt16(_offset!);
    table.ySuperscriptXSize = _readInt16(_offset!);
    table.ySuperscriptYSize = _readInt16(_offset!);
    table.ySuperscriptXOffset = _readInt16(_offset!);
    table.ySuperscriptYOffset = _readInt16(_offset!);
    table.yStrikeoutSize = _readInt16(_offset!);
    table.yStrikeoutPosition = _readInt16(_offset!);
    table.sFamilyClass = _readInt16(_offset!);
    table.panose = _readBytes(10);
    table.ulUnicodeRange1 = _readUInt32(_offset!);
    table.ulUnicodeRange2 = _readUInt32(_offset!);
    table.ulUnicodeRange3 = _readUInt32(_offset!);
    table.ulUnicodeRange4 = _readUInt32(_offset!);
    table.vendorIdentifier = _readBytes(4);
    table.fsSelection = _readUInt16(_offset!);
    table.usFirstCharIndex = _readUInt16(_offset!);
    table.usLastCharIndex = _readUInt16(_offset!);
    table.sTypoAscender = _readInt16(_offset!);
    table.sTypoDescender = _readInt16(_offset!);
    table.sTypoLineGap = _readInt16(_offset!);
    table.usWinAscent = _readUInt16(_offset!);
    table.usWinDescent = _readUInt16(_offset!);
    table.ulCodePageRange1 = _readUInt32(_offset!);
    table.ulCodePageRange2 = _readUInt32(_offset!);
    if (table.version > 1) {
      table.sxHeight = _readInt16(_offset!);
      table.sCapHeight = _readInt16(_offset!);
      table.usDefaultChar = _readUInt16(_offset!);
      table.usBreakChar = _readUInt16(_offset!);
      table.usMaxContext = _readUInt16(_offset!);
    } else {
      table.sxHeight = 0;
      table.sCapHeight = 0;
      table.usDefaultChar = 0;
      table.usBreakChar = 0;
      table.usMaxContext = 0;
    }
    return table;
  }

  _TtfPostTable _readPostTable() {
    final _TtfTableInfo tableInfo = _getTable('post')!;
    _offset = tableInfo.offset;
    final _TtfPostTable table = _TtfPostTable();
    table.formatType = _readFixed(_offset!);
    table.italicAngle = _readFixed(_offset!);
    table.underlinePosition = _readInt16(_offset!);
    table.underlineThickness = _readInt16(_offset!);
    table.isFixedPitch = _readUInt32(_offset!);
    table.minType42 = _readUInt32(_offset!);
    table.maxType42 = _readUInt32(_offset!);
    table.minType1 = _readUInt32(_offset!);
    table.maxType1 = _readUInt32(_offset!);
    return table;
  }

  List<int> _readWidthTable(int glyphCount, int? unitsPerEm) {
    final _TtfTableInfo tableInfo = _getTable('hmtx')!;
    _offset = tableInfo.offset;
    final List<int> width = List<int>.filled(glyphCount, 0, growable: true);
    for (int i = 0; i < glyphCount; i++) {
      final _TtfLongHorMetric glyph = _TtfLongHorMetric();
      glyph.advanceWidth = _readUInt16(_offset!);
      glyph.lsb = _readInt16(_offset!);
      final double glyphWidth = glyph.advanceWidth * 1000 / unitsPerEm!;
      width[i] = glyphWidth.floor();
    }
    return width;
  }

  void _initializeMetrics(
      _TtfNameTable nameTable,
      _TtfHeadTable headTable,
      _TtfHorizontalHeaderTable horizontalHeadTable,
      _TtfOS2Table os2Table,
      _TtfPostTable postTable,
      List<_TtfCmapSubTable> cmapTables) {
    _initializeFontName(nameTable);
    bool bSymbol = false;
    for (int i = 0; i < cmapTables.length; i++) {
      final _TtfCmapSubTable subTable = cmapTables[i];
      final _TtfCmapEncoding encoding =
          _getCmapEncoding(subTable.platformID, subTable.encodingID);
      if (encoding == _TtfCmapEncoding.symbol) {
        bSymbol = true;
        break;
      }
    }
    _metrics!.isSymbol = bSymbol;
    _metrics!.macStyle = headTable.macStyle;
    _metrics!.isFixedPitch = postTable.isFixedPitch != 0;
    _metrics!.italicAngle = postTable.italicAngle;
    final double factor = 1000 / headTable.unitsPerEm!;
    _metrics!.winAscent = os2Table.sTypoAscender * factor;
    _metrics!.macAscent = horizontalHeadTable.ascender * factor;
    _metrics!.capHeight = (os2Table.sCapHeight != 0)
        ? os2Table.sCapHeight!.toDouble()
        : 0.7 * headTable.unitsPerEm! * factor;
    _metrics!.winDescent = os2Table.sTypoDescender * factor;
    _metrics!.macDescent = horizontalHeadTable.descender * factor;
    _metrics!.leading = (os2Table.sTypoAscender -
            os2Table.sTypoDescender +
            os2Table.sTypoLineGap) *
        factor;
    _metrics!.lineGap = (horizontalHeadTable.lineGap * factor).ceil();
    final double left = headTable.xMin * factor;
    final double top =
        (_metrics!.macAscent + _metrics!.lineGap!).ceilToDouble();
    final double right = headTable.xMax * factor;
    final double bottom = _metrics!.macDescent;
    _metrics!.fontBox = _Rectangle(left, top, right - left, bottom - top);
    _metrics!.stemV = 80;
    _metrics!.widthTable = _updateWidth();
    _metrics!.contains = _tableDirectory!.containsKey('CFF');
    _metrics!.subscriptSizeFactor =
        headTable.unitsPerEm! / os2Table.ySubscriptYSize;
    _metrics!.superscriptSizeFactor =
        headTable.unitsPerEm! / os2Table.ySuperscriptYSize;
  }

  List<_TtfCmapSubTable> _readCmapTable() {
    final _TtfTableInfo tableInfo = _getTable('cmap')!;
    _offset = tableInfo.offset;
    final _TtfCmapTable table = _TtfCmapTable();
    table.version = _readUInt16(_offset!);
    table.tablesCount = _readUInt16(_offset!);
    int? position = _offset;
    final List<_TtfCmapSubTable> subTables = <_TtfCmapSubTable>[];
    for (int i = 0; i < table.tablesCount; i++) {
      _offset = position;
      final _TtfCmapSubTable subTable = _TtfCmapSubTable();
      subTable.platformID = _readUInt16(_offset!);
      subTable.encodingID = _readUInt16(_offset!);
      subTable.offset = _readUInt32(_offset!);
      position = _offset;
      _readCmapSubTable(subTable);
      subTables.add(subTable);
    }
    return subTables;
  }

  void _readCmapSubTable(_TtfCmapSubTable subTable) {
    final _TtfTableInfo tableInfo = _getTable('cmap')!;
    _offset = tableInfo.offset! + subTable.offset;
    final _TtfCmapFormat format = _getCmapFormat(_readUInt16(_offset!));
    final _TtfCmapEncoding encoding =
        _getCmapEncoding(subTable.platformID, subTable.encodingID);
    if (encoding != _TtfCmapEncoding.unknown) {
      switch (format) {
        case _TtfCmapFormat.apple:
          _readAppleCmapTable(subTable, encoding);
          break;
        case _TtfCmapFormat.microsoft:
          _readMicrosoftCmapTable(subTable, encoding);
          break;
        case _TtfCmapFormat.trimmed:
          _readTrimmedCmapTable(subTable, encoding);
          break;
      }
    }
  }

  void _readAppleCmapTable(
      _TtfCmapSubTable subTable, _TtfCmapEncoding encoding) {
    final _TtfTableInfo tableInfo = _getTable('cmap')!;
    _offset = tableInfo.offset! + subTable.offset;
    final _TtfAppleCmapSubTable table = _TtfAppleCmapSubTable();
    table.format = _readUInt16(_offset!);
    table.length = _readUInt16(_offset!);
    table.version = _readUInt16(_offset!);
    _maxMacIndex ??= 0;
    for (int i = 0; i < 256; ++i) {
      final _TtfGlyphInfo glyphInfo = _TtfGlyphInfo();
      glyphInfo.index = _fontData[_offset!];
      _offset = _offset! + 1;
      glyphInfo.width = _getWidth(glyphInfo.index);
      glyphInfo.charCode = i;
      _macintosh![i] = glyphInfo;
      _addGlyph(glyphInfo, encoding);
      _maxMacIndex = i >= _maxMacIndex! ? i : _maxMacIndex;
    }
  }

  void _readMicrosoftCmapTable(
      _TtfCmapSubTable subTable, _TtfCmapEncoding encoding) {
    final _TtfTableInfo tableInfo = _getTable('cmap')!;
    _offset = tableInfo.offset! + subTable.offset;
    final Map<int, _TtfGlyphInfo>? collection =
        encoding == _TtfCmapEncoding.unicode ? _microsoft : _macintosh;
    final _TtfMicrosoftCmapSubTable table = _TtfMicrosoftCmapSubTable();
    table.format = _readUInt16(_offset!);
    table.length = _readUInt16(_offset!);
    table.version = _readUInt16(_offset!);
    table.segCountX2 = _readUInt16(_offset!);
    table.searchRange = _readUInt16(_offset!);
    table.entrySelector = _readUInt16(_offset!);
    table.rangeShift = _readUInt16(_offset!);
    final int segCount = table.segCountX2 ~/ 2;
    table.endCount = _readUshortArray(segCount);
    table.reservedPad = _readUInt16(_offset!);
    table.startCount = _readUshortArray(segCount);
    table.idDelta = _readUshortArray(segCount);
    table.idRangeOffset = _readUshortArray(segCount);
    final int length = ((table.length / 2 - 8) - (segCount * 4)).toInt();
    table.glyphID = _readUshortArray(length);
    // Process glyphIdArray array.
    int codeOffset = 0;
    int index = 0;
    for (int j = 0; j < segCount; j++) {
      for (int k = table.startCount[j];
          k <= table.endCount[j] && k != 65535;
          k++) {
        if (table.idRangeOffset[j] == 0) {
          codeOffset = (k + table.idDelta[j]) & 65535;
        } else {
          index = (j +
                  table.idRangeOffset[j] / 2 -
                  segCount +
                  k -
                  table.startCount[j])
              .toInt();
          if (index >= table.glyphID.length) {
            continue;
          }
          codeOffset = (table.glyphID[index] + table.idDelta[j]) & 65535;
        }
        final _TtfGlyphInfo glyph = _TtfGlyphInfo();
        glyph.index = codeOffset;
        glyph.width = _getWidth(glyph.index);
        final int id = (encoding == _TtfCmapEncoding.symbol)
            ? ((k & 0xff00) == 0xf000 ? k & 0xff : k)
            : k;
        glyph.charCode = id;
        collection![id] = glyph;
        _addGlyph(glyph, encoding);
      }
    }
  }

  void _readTrimmedCmapTable(
      _TtfCmapSubTable subTable, _TtfCmapEncoding encoding) {
    final _TtfTableInfo tableInfo = _getTable('cmap')!;
    _offset = tableInfo.offset! + subTable.offset;
    final _TtfTrimmedCmapSubTable table = _TtfTrimmedCmapSubTable();
    table.format = _readUInt16(_offset!);
    table.length = _readUInt16(_offset!);
    table.version = _readUInt16(_offset!);
    table.firstCode = _readUInt16(_offset!);
    table.entryCount = _readUInt16(_offset!);
    _maxMacIndex ??= 0;
    for (int i = 0; i < table.entryCount; ++i) {
      final _TtfGlyphInfo glyphInfo = _TtfGlyphInfo();
      glyphInfo.index = _readUInt16(_offset!);
      glyphInfo.width = _getWidth(glyphInfo.index);
      glyphInfo.charCode = i + table.firstCode;
      _macintosh![i] = glyphInfo;
      _addGlyph(glyphInfo, encoding);
      _maxMacIndex = i >= _maxMacIndex! ? i : _maxMacIndex;
    }
  }

  _TtfTableInfo? _getTable(String name) {
    _TtfTableInfo? table = _TtfTableInfo();
    if (_tableDirectory!.containsKey(name)) {
      table = _tableDirectory![name];
    }
    return table;
  }

  int _getWidth(int glyphCode) {
    glyphCode = (glyphCode < _width.length) ? glyphCode : _width.length - 1;
    return _width[glyphCode];
  }

  List<int> _updateWidth() {
    const int count = 256;
    if (_metrics!.isSymbol) {
      final List<int> bytes = List<int>.filled(count, 0, growable: true);
      for (int i = 0; i < count; i++) {
        final _TtfGlyphInfo glyphInfo =
            _getGlyph(char: String.fromCharCode(i))!;
        bytes[i] = (glyphInfo.empty) ? 0 : glyphInfo.width;
      }
      return bytes;
    } else {
      final List<int> bytes = List<int>.filled(count, 0, growable: true);
      final List<int> byteToProcess = List<int>.filled(1, 0);
      final String space = String.fromCharCode(32);
      for (int i = 0; i < count; i++) {
        byteToProcess[0] = i;
        String text = '';
        for (int index = 0; index < byteToProcess.length; index++) {
          text += String.fromCharCode(byteToProcess[index + 0]);
        }
        final String ch = text.isNotEmpty ? text[0] : '?';
        _TtfGlyphInfo glyphInfo = _getGlyph(char: ch)!;
        if (!glyphInfo.empty) {
          bytes[i] = glyphInfo.width;
        } else {
          glyphInfo = _getGlyph(char: space)!;
          bytes[i] = (glyphInfo.empty) ? 0 : glyphInfo.width;
        }
      }
      return bytes;
    }
  }

  double _getCharWidth(String code) {
    _TtfGlyphInfo? glyphInfo = _getGlyph(char: code);
    glyphInfo = (glyphInfo != null && !glyphInfo.empty)
        ? glyphInfo
        : _getDefaultGlyph();
    return (!glyphInfo!.empty) ? glyphInfo.width.toDouble() : 0;
  }

  _TtfGlyphInfo? _getGlyph({int? charCode, String? char}) {
    if (charCode != null) {
      _TtfGlyphInfo? glyphInfo;
      if (!_metrics!.isSymbol && _microsoftGlyphs != null) {
        if (_microsoftGlyphs!.containsKey(charCode)) {
          glyphInfo = _microsoftGlyphs![charCode];
        }
      } else if (_metrics!.isSymbol && _macintoshGlyphs != null) {
        if (_macintoshGlyphs!.containsKey(charCode)) {
          glyphInfo = _macintoshGlyphs![charCode];
        }
      }
      return glyphInfo ?? _getDefaultGlyph();
    } else if (char != null) {
      _TtfGlyphInfo? glyphInfo;
      int code = char.codeUnitAt(0);
      if (!_metrics!.isSymbol && _microsoft != null) {
        if (_microsoft!.containsKey(code)) {
          glyphInfo = _microsoft![code];
        }
      } else if (_metrics!.isSymbol && _macintosh != null || _isMacTtf) {
        if (_maxMacIndex != 0) {
          code %= _maxMacIndex! + 1;
        } else {
          code = (code & 0xff00) == 0xf000 ? code & 0xff : code;
        }
        if (_macintosh!.containsKey(code)) {
          glyphInfo = _macintosh![code];
        }
      }
      if (char == ' ' && glyphInfo == null) {
        glyphInfo = _TtfGlyphInfo();
      }
      return glyphInfo ?? _getDefaultGlyph();
    }
    return null;
  }

  _TtfGlyphInfo? _getDefaultGlyph() {
    return _getGlyph(char: ' ');
  }

  void _initializeFontName(_TtfNameTable nameTable) {
    for (int i = 0; i < nameTable.recordsCount; i++) {
      final _TtfNameRecord record = nameTable.nameRecords[i];
      if (record.nameID == 1) {
        //font family
        _metrics!.fontFamily = record.name;
      } else if (record.nameID == 6) {
        //post script name
        _metrics!.postScriptName = record.name;
      }
      if (_metrics!.fontFamily != null && _metrics!.postScriptName != null) {
        break;
      }
    }
  }

  void _createInternals() {
    _metrics = _TtfMetrics();
    final _TtfNameTable nameTable = _readNameTable();
    final _TtfHeadTable headTable = _readHeadTable();
    _isLocaShort = headTable.indexToLocalFormat == 0;
    final _TtfHorizontalHeaderTable horizontalHeadTable =
        _readHorizontalHeaderTable();
    final _TtfOS2Table os2Table = _readOS2Table();
    final _TtfPostTable postTable = _readPostTable();
    _width = _readWidthTable(
        horizontalHeadTable.numberOfHMetrics, headTable.unitsPerEm);
    final List<_TtfCmapSubTable> subTables = _readCmapTable();
    _initializeMetrics(nameTable, headTable, horizontalHeadTable, os2Table,
        postTable, subTables);
  }

  _TtfCmapFormat _getCmapFormat(int format) {
    if (format == 4) {
      return _TtfCmapFormat.microsoft;
    } else if (format == 6) {
      return _TtfCmapFormat.trimmed;
    } else {
      return _TtfCmapFormat.apple;
    }
  }

  _TtfPlatformID _getPlatformID(int? platformID) {
    switch (platformID) {
      case 1:
        return _TtfPlatformID.macintosh;
      case 2:
        return _TtfPlatformID.iso;
      case 3:
        return _TtfPlatformID.microsoft;
      default:
        return _TtfPlatformID.appleUnicode;
    }
  }

  _TtfMicrosoftEncodingID _getMicrosoftEncodingID(int? encodingID) {
    switch (encodingID) {
      case 1:
        return _TtfMicrosoftEncodingID.unicode;
      case 10:
        return _TtfMicrosoftEncodingID.unicodeUCS4;
      default:
        return _TtfMicrosoftEncodingID.undefined;
    }
  }

  _TtfMacintoshEncodingID _getMacintoshEncodingID(int? encodingID) {
    switch (encodingID) {
      case 1:
        return _TtfMacintoshEncodingID.japanese;
      case 2:
        return _TtfMacintoshEncodingID.chinese;
      default:
        return _TtfMacintoshEncodingID.roman;
    }
  }

  _TtfCmapEncoding _getCmapEncoding(int? platformID, int? encodingID) {
    _TtfCmapEncoding format = _TtfCmapEncoding.unknown;
    if (_getPlatformID(platformID) == _TtfPlatformID.microsoft &&
        _getMicrosoftEncodingID(encodingID) ==
            _TtfMicrosoftEncodingID.undefined) {
      format = _TtfCmapEncoding.symbol;
    } else if (_getPlatformID(platformID) == _TtfPlatformID.microsoft &&
        _getMicrosoftEncodingID(encodingID) ==
            _TtfMicrosoftEncodingID.unicode) {
      format = _TtfCmapEncoding.unicode;
    } else if (_getPlatformID(platformID) == _TtfPlatformID.macintosh &&
        _getMacintoshEncodingID(encodingID) == _TtfMacintoshEncodingID.roman) {
      format = _TtfCmapEncoding.macintosh;
    }
    return format;
  }

  void _addGlyph(_TtfGlyphInfo glyph, _TtfCmapEncoding encoding) {
    Map<int, _TtfGlyphInfo>? collection;
    switch (encoding) {
      case _TtfCmapEncoding.unicode:
        collection = _microsoftGlyphs;
        break;
      case _TtfCmapEncoding.macintosh:
      case _TtfCmapEncoding.symbol:
        collection = _macintoshGlyphs;
        break;
      default:
        break;
    }
    collection![glyph.index] = glyph;
  }

  Map<int, int> _getGlyphChars(Map<String, String> chars) {
    final Map<int, int> dictionary = <int, int>{};
    final List<String> charKeys = chars.keys.toList();
    for (int i = 0; i < charKeys.length; i++) {
      final String ch = charKeys[i];
      final _TtfGlyphInfo glyph = _getGlyph(char: ch)!;
      if (!glyph.empty) {
        dictionary[glyph.index] = ch.codeUnitAt(0);
      }
    }
    return dictionary;
  }

  List<int>? _readFontProgram(Map<String, String> chars) {
    final Map<int, int> glyphChars = _getGlyphChars(chars);
    final List<int> offsets = _readLocaTable(_isLocaShort);
    _updateGlyphChars(glyphChars, offsets);
    final Map<String, dynamic> returnedValue =
        _generateGlyphTable(glyphChars, offsets, null, null);
    final int? glyphTableSize = returnedValue['glyphTableSize'];
    final List<int> newLocaTable = returnedValue['newLocaTable'];
    final List<int> newGlyphTable = returnedValue['newGlyphTable'];
    final Map<String, dynamic> result =
        _updateLocaTable(newLocaTable, _isLocaShort, null);
    final int? newLocaSize = result['newLocaSize'];
    final List<int> newLocaUpdated = result['newLocaUpdated'];
    final List<int>? fontProgram = _getFontProgram(
        newLocaUpdated, newGlyphTable, glyphTableSize, newLocaSize);
    return fontProgram;
  }

  List<int> _readLocaTable(bool isShort) {
    final _TtfTableInfo tableInfo = _getTable('loca')!;
    _offset = tableInfo.offset;
    List<int> buffer;
    if (isShort) {
      final int len = tableInfo.length! ~/ 2;
      buffer = List<int>.filled(len, 0, growable: true);
      for (int i = 0; i < len; i++) {
        buffer[i] = _readUInt16(_offset!) * 2;
      }
    } else {
      final int len = tableInfo.length! ~/ 4;
      buffer = List<int>.filled(len, 0, growable: true);
      for (int i = 0; i < len; i++) {
        buffer[i] = _readUInt32(_offset!);
      }
    }
    return buffer;
  }

  dynamic _updateLocaTable(
      List<int> newLocaTable, bool isLocaShort, List<int>? newLocaTableOut) {
    final int size =
        isLocaShort ? newLocaTable.length * 2 : newLocaTable.length * 4;
    final int count = _align(size);
    final _BigEndianWriter writer = _BigEndianWriter(count);
    for (int i = 0; i < newLocaTable.length; i++) {
      int value = newLocaTable[i];
      if (isLocaShort) {
        value ~/= 2;
        writer._writeShort(value);
      } else {
        writer._writeInt(value);
      }
    }
    return <String, dynamic>{
      'newLocaUpdated': writer._data,
      'newLocaSize': size
    };
  }

  void _updateGlyphChars(Map<int, int> glyphChars, List<int> offsets) {
    if (!glyphChars.containsKey(0)) {
      glyphChars[0] = 0;
    }
    final List<int> glyphCharKeys = glyphChars.keys.toList();
    final Map<int, int> clone = <int, int>{};
    for (int i = 0; i < glyphCharKeys.length; i++) {
      clone[glyphCharKeys[i]] = glyphChars[glyphCharKeys[i]]!;
    }
    for (int i = 0; i < glyphCharKeys.length; i++) {
      _processCompositeGlyph(glyphChars, glyphCharKeys[i], offsets);
    }
  }

  void _processCompositeGlyph(
      Map<int, int> glyphChars, int glyph, List<int> offsets) {
    if (glyph < offsets.length - 1) {
      final int glyphOffset = offsets[glyph];
      if (glyphOffset != offsets[glyph + 1]) {
        final _TtfTableInfo tableInfo = _getTable('glyf')!;
        _offset = tableInfo.offset! + glyphOffset;
        final _TtfGlyphHeader glyphHeader = _TtfGlyphHeader();
        glyphHeader.numberOfContours = _readInt16(_offset!);
        glyphHeader.xMin = _readInt16(_offset!);
        glyphHeader.yMin = _readInt16(_offset!);
        glyphHeader.xMax = _readInt16(_offset!);
        glyphHeader.yMax = _readInt16(_offset!);
        if (glyphHeader.numberOfContours < 0) {
          int skipBytes = 0;
          while (true) {
            final int flags = _readUInt16(_offset!);
            final int glyphIndex = _readUInt16(_offset!);
            if (!glyphChars.containsKey(glyphIndex)) {
              glyphChars[glyphIndex] = 0;
            }
            if ((flags & 0x0020) == 0) {
              break;
            }
            skipBytes = (flags & 0x0001) != 0 ? 4 : 2;
            if (flags & 0x0008 != 0) {
              skipBytes += 2;
            } else if (flags & 0x0040 != 0) {
              skipBytes += 4;
            } else if (flags & 0x0080 != 0) {
              skipBytes += 2 * 4;
            }
            _offset = _offset! + skipBytes;
          }
        }
      }
    }
  }

  dynamic _generateGlyphTable(Map<int, int> glyphChars, List<int> offsets,
      List<int>? newLocaTable, List<int>? newGlyphTable) {
    newLocaTable = <int>[];
    final List<int> activeGlyphs = glyphChars.keys.toList();
    activeGlyphs.sort((int a, int b) => a - b);
    int glyphSize = 0;
    for (int i = 0; i < activeGlyphs.length; i++) {
      if (offsets.isNotEmpty) {
        glyphSize += offsets[activeGlyphs[i] + 1] - offsets[activeGlyphs[i]];
      }
    }
    final int glyphSizeAligned = _align(glyphSize);
    newGlyphTable = <int>[];
    for (int i = 0; i < glyphSizeAligned; i++) {
      newGlyphTable.add(0);
    }
    int nextGlyphOffset = 0;
    int nextGlyphIndex = 0;
    final _TtfTableInfo? table = _getTable('glyf');
    for (int i = 0; i < offsets.length; i++) {
      newLocaTable.add(nextGlyphOffset);
      if (nextGlyphIndex < activeGlyphs.length &&
          activeGlyphs[nextGlyphIndex] == i) {
        ++nextGlyphIndex;
        newLocaTable[i] = nextGlyphOffset;
        final int oldGlyphOffset = offsets[i];
        final int oldNextGlyphOffset = offsets[i + 1] - oldGlyphOffset;
        if (oldNextGlyphOffset > 0) {
          _offset = table!.offset! + oldGlyphOffset;
          final Map<String, dynamic> result =
              _read(newGlyphTable!, nextGlyphOffset, oldNextGlyphOffset);
          newGlyphTable = result['buffer'];
          nextGlyphOffset += oldNextGlyphOffset;
        }
      }
    }
    return <String, dynamic>{
      'glyphTableSize': glyphSize,
      'newLocaTable': newLocaTable,
      'newGlyphTable': newGlyphTable
    };
  }

  int _align(int value) {
    return (value + 3) & (~3);
  }

  List<int>? _getFontProgram(List<int> newLocaTableOut, List<int> newGlyphTable,
      int? glyphTableSize, int? locaTableSize) {
    final dynamic result =
        _getFontProgramLength(newLocaTableOut, newGlyphTable, 0);
    final int fontProgramLength = result['fontProgramLength'];
    final int numTables = result['numTables'];
    final _BigEndianWriter writer = _BigEndianWriter(fontProgramLength);
    writer._writeInt(0x10000);
    writer._writeShort(numTables);
    final int entrySelector = _entrySelectors[numTables];
    writer._writeShort((1 << (entrySelector & 31)) * 16);
    writer._writeShort(entrySelector);
    writer._writeShort((numTables - (1 << (entrySelector & 31))) * 16);
    _writeCheckSums(writer, numTables, newLocaTableOut, newGlyphTable,
        glyphTableSize, locaTableSize);
    _writeGlyphs(writer, newLocaTableOut, newGlyphTable);
    return writer._data;
  }

  dynamic _getFontProgramLength(
      List<int> newLocaTableOut, List<int> newGlyphTable, int numTables) {
    numTables = 2;
    final List<String> tableNames = _tableNames;
    int fontProgramLength = 0;
    for (int i = 0; i < tableNames.length; i++) {
      final String tableName = tableNames[i];
      if (tableName != 'glyf' && tableName != 'loca') {
        final _TtfTableInfo table = _getTable(tableName)!;
        if (!table.empty) {
          ++numTables;
          fontProgramLength += _align(table.length!);
        }
      }
    }
    fontProgramLength += newLocaTableOut.length;
    fontProgramLength += newGlyphTable.length;
    final int usedTablesSize = numTables * 16 + (3 * 4);
    fontProgramLength += usedTablesSize;
    return <String, dynamic>{
      'fontProgramLength': fontProgramLength,
      'numTables': numTables
    };
  }

  void _writeCheckSums(
      _BigEndianWriter writer,
      int numTables,
      List<int> newLocaTableOut,
      List<int> newGlyphTable,
      int? glyphTableSize,
      int? locaTableSize) {
    final List<String> tableNames = _tableNames;
    int usedTablesSize = numTables * 16 + (3 * 4);
    int? nextTableSize = 0;
    for (int i = 0; i < tableNames.length; i++) {
      final String tableName = tableNames[i];
      final _TtfTableInfo tableInfo = _getTable(tableName)!;
      if (tableInfo.empty) {
        continue;
      }
      writer._writeString(tableName);
      if (tableName == 'glyf') {
        final int checksum = _calculateCheckSum(newGlyphTable);
        writer._writeInt(checksum);
        nextTableSize = glyphTableSize;
      } else if (tableName == 'loca') {
        final int checksum = _calculateCheckSum(newLocaTableOut);
        writer._writeInt(checksum);
        nextTableSize = locaTableSize;
      } else {
        writer._writeInt(tableInfo.checksum!);
        nextTableSize = tableInfo.length;
      }
      writer._writeUInt(usedTablesSize);
      writer._writeUInt(nextTableSize!);
      usedTablesSize += _align(nextTableSize);
    }
  }

  int _calculateCheckSum(List<int> bytes) {
    int pos = 0;
    int byte1 = 0;
    int byte2 = 0;
    int byte3 = 0;
    int byte4 = 0;
    for (int i = 0; i < ((bytes.length + 1) ~/ 4); i++) {
      byte4 += bytes[pos++] & 255;
      byte3 += bytes[pos++] & 255;
      byte2 += bytes[pos++] & 255;
      byte1 += bytes[pos++] & 255;
    }
    return byte1 + (byte2 << 8) + (byte3 << 16) + (byte4 << 24);
  }

  void _writeGlyphs(_BigEndianWriter writer, List<int> newLocaTable,
      List<int> newGlyphTable) {
    final List<String> tableNames = _tableNames;
    for (int i = 0; i < tableNames.length; i++) {
      final String tableName = tableNames[i];
      final _TtfTableInfo tableInfo = _getTable(tableName)!;
      if (tableInfo.empty) {
        continue;
      }
      if (tableName == 'glyf') {
        writer._writeBytes(newGlyphTable);
      } else if (tableName == 'loca') {
        writer._writeBytes(newLocaTable);
      } else {
        final int count = _align(tableInfo.length!);
        final List<int> buff = List<int>.filled(count, 0, growable: true);
        _offset = tableInfo.offset;
        final dynamic result = _read(buff, 0, tableInfo.length!);
        writer._writeBytes(result['buffer']);
      }
    }
  }

  String _convertString(String text) {
    String glyph = '';
    for (int k = 0; k < text.length; k++) {
      final String char = text[k];
      final _TtfGlyphInfo glyphInfo = _getGlyph(char: char)!;
      if (!glyphInfo.empty) {
        glyph += String.fromCharCode(glyphInfo.index);
      }
    }
    return glyph;
  }

  int _readInt16(int offset) {
    int result = (_fontData[offset] << 8) + _fontData[offset + 1];
    result = (result & (1 << 15) != 0) ? result - 0x10000 : result;
    _offset = _offset! + 2;
    return result;
  }

  int _readUInt16(int offset) {
    final int i1 = _fontData[offset];
    final int i2 = _fontData[offset + 1];
    _offset = _offset! + 2;
    return (i1 << 8) | i2;
  }

  int _readInt32(int offset) {
    final int i1 = _fontData[offset + 3];
    final int i2 = _fontData[offset + 2];
    final int i3 = _fontData[offset + 1];
    final int i4 = _fontData[offset];
    _offset = _offset! + 4;
    return i1 + (i2 << 8) + (i3 << 16) + (i4 << 24);
  }

  int _readUInt32(int offset) {
    final int i1 = _fontData[offset + 3];
    final int i2 = _fontData[offset + 2];
    final int i3 = _fontData[offset + 1];
    final int i4 = _fontData[offset];
    _offset = _offset! + 4;
    return i1 | (i2 << 8) | (i3 << 16) | (i4 << 24);
  }

  int _readInt64(int offset) {
    final int low = _readInt32(offset + 4);
    int n = _readInt32(offset) * 4294967296 + low;
    if (low < 0) {
      n += 4294967296;
    }
    return n;
  }

  double _readFixed(int offset) {
    return _readInt16(offset) + (_readInt16(offset + 2) / 16384);
  }

  String _readString(int? length, [bool? isUnicode]) {
    if (isUnicode == null) {
      return _readString(length, false);
    } else {
      String result = '';
      if (isUnicode) {
        for (int i = 0; i < length!; i++) {
          if (i % 2 != 0) {
            result += String.fromCharCode(_fontData[_offset!]);
          }
          _offset = _offset! + 1;
        }
      } else {
        for (int i = 0; i < length!; i++) {
          result += String.fromCharCode(_fontData[_offset!]);
          _offset = _offset! + 1;
        }
      }
      return result;
    }
  }

  List<int> _readBytes(int length) {
    final List<int> result = List<int>.filled(length, 0, growable: true);
    for (int i = 0; i < length; i++) {
      result[i] = _fontData[_offset!];
      _offset = _offset! + 1;
    }
    return result;
  }

  List<int> _readUshortArray(int length) {
    final List<int> buffer = List<int>.filled(length, 0, growable: true);
    for (int i = 0; i < length; i++) {
      buffer[i] = _readUInt16(_offset!);
    }
    return buffer;
  }

  dynamic _read(List<int> buffer, int index, int count) {
    int written = 0;
    int read = 0;
    do {
      for (int i = 0;
          i < count - written && _offset! + i < _fontData.length;
          i++) {
        buffer[index + i] = _fontData[_offset! + i];
      }
      read = count - written;
      _offset = _offset! + read;
      written += read;
    } while (written < count);
    return <String, dynamic>{'buffer': buffer, 'written': written};
  }
}
