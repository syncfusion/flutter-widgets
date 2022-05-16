import 'dart:math';

import '../../drawing/drawing.dart';
import '../../io/big_endian_writer.dart';
import 'ttf_metrics.dart';

/// internal class
class TtfReader {
  /// internal constructor
  TtfReader(List<int> fontData) {
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

  /// internal field
  TtfMetrics? metrics;

  /// internal field
  int? currentOffset;
  late bool _isMacTtf;
  late bool _isTtcFont;
  Map<String, _TtfTableInfo>? _tableDirectory;
  Map<int, TtfGlyphInfo>? _macintoshDirectory;
  Map<int, TtfGlyphInfo>? _microsoftDirectory;
  Map<int, TtfGlyphInfo>? _macintoshGlyphInfoCollection;
  Map<int, TtfGlyphInfo>? _microsoftGlyphInfoCollection;
  Map<int, TtfGlyphInfo>? _unicodeUCS4GlyphCollection;
  int? _lowestPosition;
  late bool _isLocaShort;
  late List<int> _width;
  int _surrogateHigh = 0;
  int? _maxMacIndex;
  String _surrogateHighChar = '';

  /// internal field
  List<String>? internalUsedChars;

  /// internal field
  List<String> get usedChars {
    internalUsedChars ??= <String>[];
    return internalUsedChars!;
  }

  //Properties
  Map<int, TtfGlyphInfo>? get _macintosh {
    _macintoshDirectory ??= <int, TtfGlyphInfo>{};
    return _macintoshDirectory;
  }

  Map<int, TtfGlyphInfo>? get _microsoft {
    _microsoftDirectory ??= <int, TtfGlyphInfo>{};
    return _microsoftDirectory;
  }

  Map<int, TtfGlyphInfo>? get _macintoshGlyphs {
    _macintoshGlyphInfoCollection ??= <int, TtfGlyphInfo>{};
    return _macintoshGlyphInfoCollection;
  }

  Map<int, TtfGlyphInfo>? get _microsoftGlyphs {
    _microsoftGlyphInfoCollection ??= <int, TtfGlyphInfo>{};
    return _microsoftGlyphInfoCollection;
  }

  Map<int, TtfGlyphInfo>? get _unicodeUcs4Glyph {
    _unicodeUCS4GlyphCollection ??= <int, TtfGlyphInfo>{};
    return _unicodeUCS4GlyphCollection;
  }

  //Implementation
  void _initialize() {
    _isMacTtf = false;
    _isTtcFont = false;
    metrics = TtfMetrics();
    _readFontDictionary();
    final _TtfNameTable nameTable = _readNameTable();
    final _TtfHeadTable headTable = _readHeadTable();
    _initializeFontName(nameTable);
    metrics!.macStyle = headTable.macStyle;
  }

  void _readFontDictionary() {
    currentOffset = 0;
    _checkPreambula();
    final int numTables = _readInt16(currentOffset!);
    //searchRange
    _readInt16(currentOffset!);
    //entrySelector
    _readInt16(currentOffset!);
    //rangeShift
    _readInt16(currentOffset!);
    _tableDirectory ??= <String, _TtfTableInfo>{};
    for (int i = 0; i < numTables; ++i) {
      final _TtfTableInfo table = _TtfTableInfo();
      final String tableKey = _readString(_int32Size);
      table.checksum = _readInt32(currentOffset!);
      table.offset = _readInt32(currentOffset!);
      table.length = _readInt32(currentOffset!);
      _tableDirectory![tableKey] = table;
    }
    _lowestPosition = currentOffset;
    if (!_isTtcFont) {
      _fixOffsets();
    }
  }

  void _checkPreambula() {
    final int version = _readInt32(currentOffset!);
    _isMacTtf = version == 0x74727565;
    if (version != 0x10000 && !_isMacTtf && version != 0x4f54544f) {
      _isTtcFont = true;
      currentOffset = 0;
      if (_readString(4) != 'ttcf') {
        throw UnsupportedError('Can not read TTF font data');
      }
      currentOffset = currentOffset! + 4;
      if (_readInt32(currentOffset!) < 0) {
        throw UnsupportedError('Can not read TTF font data');
      }
      //Offset for version
      currentOffset = _readInt32(currentOffset!);
      //Version
      _readInt32(currentOffset!);
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
    currentOffset = tableInfo.offset;
    final _TtfNameTable table = _TtfNameTable();
    table.formatSelector = _readUInt16(currentOffset!);
    table.recordsCount = _readUInt16(currentOffset!);
    table.offset = _readUInt16(currentOffset!);
    table.nameRecords = <_TtfNameRecord>[];
    const int recordSize = 12;
    int? position = currentOffset;
    for (int i = 0; i < table.recordsCount; i++) {
      currentOffset = position;
      final _TtfNameRecord record = _TtfNameRecord();
      record.platformID = _readUInt16(currentOffset!);
      record.encodingID = _readUInt16(currentOffset!);
      record.languageID = _readUInt16(currentOffset!);
      record.nameID = _readUInt16(currentOffset!);
      record.length = _readUInt16(currentOffset!);
      record.offset = _readUInt16(currentOffset!);
      currentOffset = tableInfo.offset! + table.offset + record.offset;
      final bool isUnicode = record.platformID == 0 || record.platformID == 3;
      record.name = _readString(record.length, isUnicode);
      table.nameRecords.add(record);
      position = position! + recordSize;
    }
    return table;
  }

  _TtfHeadTable _readHeadTable() {
    final _TtfTableInfo tableInfo = _getTable('head')!;
    currentOffset = tableInfo.offset;
    final _TtfHeadTable table = _TtfHeadTable();
    table.version = _readFixed(currentOffset!);
    table.fontRevision = _readFixed(currentOffset!);
    table.checkSumAdjustment = _readUInt32(currentOffset!);
    table.magicNumber = _readUInt32(currentOffset!);
    table.flags = _readUInt16(currentOffset!);
    table.unitsPerEm = _readUInt16(currentOffset!);
    table.created = _readInt64(currentOffset!);
    table.modified = _readInt64(currentOffset!);
    table.xMin = _readInt16(currentOffset!);
    table.yMin = _readInt16(currentOffset!);
    table.xMax = _readInt16(currentOffset!);
    table.yMax = _readInt16(currentOffset!);
    table.macStyle = _readUInt16(currentOffset!);
    table.lowestReadableSize = _readUInt16(currentOffset!);
    table.fontDirectionHint = _readInt16(currentOffset!);
    table.indexToLocalFormat = _readInt16(currentOffset!);
    table.glyphDataFormat = _readInt16(currentOffset!);
    return table;
  }

  _TtfHorizontalHeaderTable _readHorizontalHeaderTable() {
    final _TtfTableInfo tableInfo = _getTable('hhea')!;
    currentOffset = tableInfo.offset;
    final _TtfHorizontalHeaderTable table = _TtfHorizontalHeaderTable();
    table.version = _readFixed(currentOffset!);
    table.ascender = _readInt16(currentOffset!);
    table.descender = _readInt16(currentOffset!);
    table.lineGap = _readInt16(currentOffset!);
    table.advanceWidthMax = _readUInt16(currentOffset!);
    table.minLeftSideBearing = _readInt16(currentOffset!);
    table.minRightSideBearing = _readInt16(currentOffset!);
    table.xMaxExtent = _readInt16(currentOffset!);
    table.caretSlopeRise = _readInt16(currentOffset!);
    table.caretSlopeRun = _readInt16(currentOffset!);
    currentOffset = currentOffset! + 10;
    table.metricDataFormat = _readInt16(currentOffset!);
    table.numberOfHMetrics = _readUInt16(currentOffset!);
    return table;
  }

  _TtfOS2Table _readOS2Table() {
    final _TtfTableInfo tableInfo = _getTable('OS/2')!;
    currentOffset = tableInfo.offset;
    final _TtfOS2Table table = _TtfOS2Table();
    table.version = _readUInt16(currentOffset!);
    table.xAvgCharWidth = _readInt16(currentOffset!);
    table.usWeightClass = _readUInt16(currentOffset!);
    table.usWidthClass = _readUInt16(currentOffset!);
    table.fsType = _readInt16(currentOffset!);
    table.ySubscriptXSize = _readInt16(currentOffset!);
    table.ySubscriptYSize = _readInt16(currentOffset!);
    table.ySubscriptXOffset = _readInt16(currentOffset!);
    table.ySubscriptYOffset = _readInt16(currentOffset!);
    table.ySuperscriptXSize = _readInt16(currentOffset!);
    table.ySuperscriptYSize = _readInt16(currentOffset!);
    table.ySuperscriptXOffset = _readInt16(currentOffset!);
    table.ySuperscriptYOffset = _readInt16(currentOffset!);
    table.yStrikeoutSize = _readInt16(currentOffset!);
    table.yStrikeoutPosition = _readInt16(currentOffset!);
    table.sFamilyClass = _readInt16(currentOffset!);
    table.panose = _readBytes(10);
    table.ulUnicodeRange1 = _readUInt32(currentOffset!);
    table.ulUnicodeRange2 = _readUInt32(currentOffset!);
    table.ulUnicodeRange3 = _readUInt32(currentOffset!);
    table.ulUnicodeRange4 = _readUInt32(currentOffset!);
    table.vendorIdentifier = _readBytes(4);
    table.fsSelection = _readUInt16(currentOffset!);
    table.usFirstCharIndex = _readUInt16(currentOffset!);
    table.usLastCharIndex = _readUInt16(currentOffset!);
    table.sTypoAscender = _readInt16(currentOffset!);
    table.sTypoDescender = _readInt16(currentOffset!);
    table.sTypoLineGap = _readInt16(currentOffset!);
    table.usWinAscent = _readUInt16(currentOffset!);
    table.usWinDescent = _readUInt16(currentOffset!);
    table.ulCodePageRange1 = _readUInt32(currentOffset!);
    table.ulCodePageRange2 = _readUInt32(currentOffset!);
    if (table.version > 1) {
      table.sxHeight = _readInt16(currentOffset!);
      table.sCapHeight = _readInt16(currentOffset!);
      table.usDefaultChar = _readUInt16(currentOffset!);
      table.usBreakChar = _readUInt16(currentOffset!);
      table.usMaxContext = _readUInt16(currentOffset!);
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
    currentOffset = tableInfo.offset;
    final _TtfPostTable table = _TtfPostTable();
    table.formatType = _readFixed(currentOffset!);
    table.italicAngle = _readFixed(currentOffset!);
    table.underlinePosition = _readInt16(currentOffset!);
    table.underlineThickness = _readInt16(currentOffset!);
    table.isFixedPitch = _readUInt32(currentOffset!);
    table.minType42 = _readUInt32(currentOffset!);
    table.maxType42 = _readUInt32(currentOffset!);
    table.minType1 = _readUInt32(currentOffset!);
    table.maxType1 = _readUInt32(currentOffset!);
    return table;
  }

  List<int> _readWidthTable(int glyphCount, int? unitsPerEm) {
    final _TtfTableInfo tableInfo = _getTable('hmtx')!;
    currentOffset = tableInfo.offset;
    final List<int> width = List<int>.filled(glyphCount, 0, growable: true);
    for (int i = 0; i < glyphCount; i++) {
      final _TtfLongHorMetric glyph = _TtfLongHorMetric();
      glyph.advanceWidth = _readUInt16(currentOffset!);
      glyph.lsb = _readInt16(currentOffset!);
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
    metrics!.isSymbol = bSymbol;
    metrics!.macStyle = headTable.macStyle;
    metrics!.isFixedPitch = postTable.isFixedPitch != 0;
    metrics!.italicAngle = postTable.italicAngle;
    final double factor = 1000 / headTable.unitsPerEm!;
    metrics!.winAscent = os2Table.sTypoAscender * factor;
    metrics!.macAscent = horizontalHeadTable.ascender * factor;
    metrics!.capHeight = (os2Table.sCapHeight != 0)
        ? os2Table.sCapHeight!.toDouble()
        : 0.7 * headTable.unitsPerEm! * factor;
    metrics!.winDescent = os2Table.sTypoDescender * factor;
    metrics!.macDescent = horizontalHeadTable.descender * factor;
    metrics!.leading = (os2Table.sTypoAscender -
            os2Table.sTypoDescender +
            os2Table.sTypoLineGap) *
        factor;
    metrics!.lineGap = (horizontalHeadTable.lineGap * factor).ceil();
    final double left = headTable.xMin * factor;
    final double top = (metrics!.macAscent + metrics!.lineGap!).ceilToDouble();
    final double right = headTable.xMax * factor;
    final double bottom = metrics!.macDescent;
    metrics!.fontBox = PdfRectangle(left, top, right - left, bottom - top);
    metrics!.stemV = 80;
    metrics!.widthTable = _updateWidth();
    metrics!.contains = _tableDirectory!.containsKey('CFF');
    metrics!.subscriptSizeFactor =
        headTable.unitsPerEm! / os2Table.ySubscriptYSize;
    metrics!.superscriptSizeFactor =
        headTable.unitsPerEm! / os2Table.ySuperscriptYSize;
  }

  List<_TtfCmapSubTable> _readCmapTable() {
    final _TtfTableInfo tableInfo = _getTable('cmap')!;
    currentOffset = tableInfo.offset;
    final _TtfCmapTable table = _TtfCmapTable();
    table.version = _readUInt16(currentOffset!);
    table.tablesCount = _readUInt16(currentOffset!);
    int? position = currentOffset;
    final List<_TtfCmapSubTable> subTables = <_TtfCmapSubTable>[];
    for (int i = 0; i < table.tablesCount; i++) {
      currentOffset = position;
      final _TtfCmapSubTable subTable = _TtfCmapSubTable();
      subTable.platformID = _readUInt16(currentOffset!);
      subTable.encodingID = _readUInt16(currentOffset!);
      subTable.offset = _readUInt32(currentOffset!);
      position = currentOffset;
      _readCmapSubTable(subTable);
      subTables.add(subTable);
    }
    return subTables;
  }

  void _readCmapSubTable(_TtfCmapSubTable subTable) {
    final _TtfTableInfo tableInfo = _getTable('cmap')!;
    currentOffset = tableInfo.offset! + subTable.offset;
    final _TtfCmapFormat format = _getCmapFormat(_readUInt16(currentOffset!));
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
        case _TtfCmapFormat.microsoftExt:
          _readUCS4CmapTable(subTable, encoding);
          break;
      }
    }
  }

  void _readUCS4CmapTable(
      _TtfCmapSubTable subTable, _TtfCmapEncoding encoding) {
    final _TtfTableInfo tableInfo = _getTable('cmap')!;
    currentOffset = tableInfo.offset! + subTable.offset + 12;
    final int count = _readInt32(currentOffset!);
    for (int i = 0; i < count; ++i) {
      final int start = _readInt32(currentOffset!);
      final int end = _readInt32(currentOffset!);
      int glyphID = _readInt32(currentOffset!);
      for (int j = start; j <= end; j++) {
        final TtfGlyphInfo glyphInfo = TtfGlyphInfo();
        glyphInfo.charCode = j;
        glyphInfo.width = _getWidth(glyphID);
        glyphInfo.index = glyphID;
        _addReverseGlyph(glyphInfo, encoding);
        glyphID++;
      }
    }
  }

  void _readAppleCmapTable(
      _TtfCmapSubTable subTable, _TtfCmapEncoding encoding) {
    final _TtfTableInfo tableInfo = _getTable('cmap')!;
    currentOffset = tableInfo.offset! + subTable.offset;
    final _TtfAppleCmapSubTable table = _TtfAppleCmapSubTable();
    table.format = _readUInt16(currentOffset!);
    table.length = _readUInt16(currentOffset!);
    table.version = _readUInt16(currentOffset!);
    _maxMacIndex ??= 0;
    for (int i = 0; i < 256; ++i) {
      final TtfGlyphInfo glyphInfo = TtfGlyphInfo();
      glyphInfo.index = _fontData[currentOffset!];
      currentOffset = currentOffset! + 1;
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
    currentOffset = tableInfo.offset! + subTable.offset;
    final Map<int, TtfGlyphInfo>? collection =
        encoding == _TtfCmapEncoding.unicode ? _microsoft : _macintosh;
    final _TtfMicrosoftCmapSubTable table = _TtfMicrosoftCmapSubTable();
    table.format = _readUInt16(currentOffset!);
    table.length = _readUInt16(currentOffset!);
    table.version = _readUInt16(currentOffset!);
    table.segCountX2 = _readUInt16(currentOffset!);
    table.searchRange = _readUInt16(currentOffset!);
    table.entrySelector = _readUInt16(currentOffset!);
    table.rangeShift = _readUInt16(currentOffset!);
    final int segCount = table.segCountX2 ~/ 2;
    table.endCount = _readUshortArray(segCount);
    table.reservedPad = _readUInt16(currentOffset!);
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
        final TtfGlyphInfo glyph = TtfGlyphInfo();
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
    currentOffset = tableInfo.offset! + subTable.offset;
    final _TtfTrimmedCmapSubTable table = _TtfTrimmedCmapSubTable();
    table.format = _readUInt16(currentOffset!);
    table.length = _readUInt16(currentOffset!);
    table.version = _readUInt16(currentOffset!);
    table.firstCode = _readUInt16(currentOffset!);
    table.entryCount = _readUInt16(currentOffset!);
    _maxMacIndex ??= 0;
    for (int i = 0; i < table.entryCount; ++i) {
      final TtfGlyphInfo glyphInfo = TtfGlyphInfo();
      glyphInfo.index = _readUInt16(currentOffset!);
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
    if (metrics!.isSymbol) {
      final List<int> bytes = List<int>.filled(count, 0, growable: true);
      for (int i = 0; i < count; i++) {
        final TtfGlyphInfo glyphInfo = getGlyph(char: String.fromCharCode(i))!;
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
        TtfGlyphInfo glyphInfo = getGlyph(char: ch)!;
        if (!glyphInfo.empty) {
          bytes[i] = glyphInfo.width;
        } else {
          glyphInfo = getGlyph(char: space)!;
          bytes[i] = (glyphInfo.empty) ? 0 : glyphInfo.width;
        }
      }
      return bytes;
    }
  }

  /// internal method
  double getCharWidth(String code) {
    TtfGlyphInfo? glyphInfo = getGlyph(char: code);
    glyphInfo = (glyphInfo != null && !glyphInfo.empty)
        ? glyphInfo
        : _getDefaultGlyph();
    return (!glyphInfo!.empty) ? glyphInfo.width.toDouble() : 0;
  }

  /// internal method
  TtfGlyphInfo? getGlyph(
      {int? charCode, String? char, bool? isSetSymbol = false}) {
    if (charCode != null) {
      TtfGlyphInfo? glyphInfo;
      if (!metrics!.isSymbol && _microsoftGlyphs != null) {
        if (_microsoftGlyphs!.containsKey(charCode)) {
          glyphInfo = _microsoftGlyphs![charCode];
        }
      } else if (metrics!.isSymbol && _macintoshGlyphs != null) {
        if (_macintoshGlyphs!.containsKey(charCode)) {
          glyphInfo = _macintoshGlyphs![charCode];
        }
      }
      if (glyphInfo == null &&
          _unicodeUCS4GlyphCollection != null &&
          _unicodeUCS4GlyphCollection!.containsKey(charCode)) {
        glyphInfo = _unicodeUCS4GlyphCollection![charCode];
      }
      return glyphInfo ?? _getDefaultGlyph();
    } else if (char != null) {
      TtfGlyphInfo? glyphInfo;
      int code = char.codeUnitAt(0);
      if (!metrics!.isSymbol && _microsoft != null) {
        if (_microsoft!.containsKey(code)) {
          glyphInfo = _microsoft![code];
        } else if (char != ' ') {
          if (_unicodeUCS4GlyphCollection != null && _isSurrogate(code)) {
            TtfGlyphInfo newGlyph = TtfGlyphInfo();
            if (_isHighSurrogate(code)) {
              _surrogateHighChar = char;
              _surrogateHigh = code;
              newGlyph.width = 0;
            }
            if (_isLowSurrogate(code)) {
              if (_isSurrogatePair(_surrogateHigh, code)) {
                code = (((_surrogateHigh >> 6) & ((1 << 5) - 1)) + 1) << 16 |
                    ((_surrogateHigh & ((1 << 6) - 1)) << 10 |
                        code & ((1 << 10) - 1));
                if (_unicodeUCS4GlyphCollection!.containsKey(code)) {
                  newGlyph = _unicodeUCS4GlyphCollection![code]!;
                  if (isSetSymbol!) {
                    usedChars.add(_surrogateHighChar + char);
                  }
                }
              }
            }
            return newGlyph;
          }
        }
      } else if (metrics!.isSymbol && _macintosh != null || _isMacTtf) {
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
        glyphInfo = TtfGlyphInfo();
      }
      return glyphInfo ?? _getDefaultGlyph();
    }
    return null;
  }

  TtfGlyphInfo? _getDefaultGlyph() {
    return getGlyph(char: ' ');
  }

  bool _isHighSurrogate(int charCode) {
    return charCode >= 55296 && charCode <= 56319;
  }

  bool _isLowSurrogate(int charCode) {
    return charCode >= 56320 && charCode <= 57343;
  }

  bool _isSurrogate(int charCode) {
    return charCode >= 55296 && charCode <= 57343;
  }

  bool _isSurrogatePair(int highSurrogate, int lowSurrogate) {
    return _isHighSurrogate(highSurrogate) && _isLowSurrogate(lowSurrogate);
  }

  void _initializeFontName(_TtfNameTable nameTable) {
    for (int i = 0; i < nameTable.recordsCount; i++) {
      final _TtfNameRecord record = nameTable.nameRecords[i];
      if (record.nameID == 1) {
        //font family
        metrics!.fontFamily = record.name;
      } else if (record.nameID == 6) {
        //post script name
        metrics!.postScriptName = record.name;
      }
      if (metrics!.fontFamily != null && metrics!.postScriptName != null) {
        break;
      }
    }
  }

  /// internal method
  void createInternals() {
    metrics = TtfMetrics();
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
    } else if (format == 12) {
      return _TtfCmapFormat.microsoftExt;
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
    } else if (_getPlatformID(platformID) == _TtfPlatformID.microsoft &&
        _getMicrosoftEncodingID(encodingID) ==
            _TtfMicrosoftEncodingID.unicodeUCS4) {
      format = _TtfCmapEncoding.unicodeUCS4;
    }
    return format;
  }

  void _addReverseGlyph(TtfGlyphInfo glyph, _TtfCmapEncoding encoding) {
    Map<int, TtfGlyphInfo>? collection;
    switch (encoding) {
      case _TtfCmapEncoding.unicode:
        collection = _microsoftGlyphs;
        break;
      case _TtfCmapEncoding.macintosh:
      case _TtfCmapEncoding.symbol:
        collection = _macintoshGlyphs;
        break;
      case _TtfCmapEncoding.unicodeUCS4:
        collection = _unicodeUcs4Glyph;
        break;
      case _TtfCmapEncoding.unknown:
        break;
    }
    collection![glyph.charCode] = glyph;
  }

  void _addGlyph(TtfGlyphInfo glyph, _TtfCmapEncoding encoding) {
    Map<int, TtfGlyphInfo>? collection;
    switch (encoding) {
      case _TtfCmapEncoding.unicode:
        collection = _microsoftGlyphs;
        break;
      case _TtfCmapEncoding.macintosh:
      case _TtfCmapEncoding.symbol:
        collection = _macintoshGlyphs;
        break;
      case _TtfCmapEncoding.unknown:
      case _TtfCmapEncoding.unicodeUCS4:
        break;
    }
    collection![glyph.index] = glyph;
  }

  /// internal method
  Map<int, int> getGlyphChars(List<String> chars) {
    final Map<int, int> dictionary = <int, int>{};
    for (int i = 0; i < chars.length; i++) {
      final String ch = chars[i];
      final TtfGlyphInfo glyph = getGlyph(char: ch)!;
      if (!glyph.empty) {
        dictionary[glyph.index] = ch.codeUnitAt(0);
      }
    }
    return dictionary;
  }

  /// internal method
  List<int>? readFontProgram(List<String> chars) {
    final Map<int, int> glyphChars = getGlyphChars(chars);
    final List<int> offsets = _readLocaTable(_isLocaShort);
    _updateGlyphChars(glyphChars, offsets);
    final Map<String, dynamic> returnedValue =
        _generateGlyphTable(glyphChars, offsets, null, null)
            as Map<String, dynamic>;
    final int? glyphTableSize = returnedValue['glyphTableSize'] as int?;
    final List<int> newLocaTable = returnedValue['newLocaTable'] as List<int>;
    final List<int> newGlyphTable = returnedValue['newGlyphTable'] as List<int>;
    final Map<String, dynamic> result =
        _updateLocaTable(newLocaTable, _isLocaShort, null)
            as Map<String, dynamic>;
    final int? newLocaSize = result['newLocaSize'] as int?;
    final List<int> newLocaUpdated = result['newLocaUpdated'] as List<int>;
    final List<int>? fontProgram = _getFontProgram(
        newLocaUpdated, newGlyphTable, glyphTableSize, newLocaSize);
    return fontProgram;
  }

  List<int> _readLocaTable(bool isShort) {
    final _TtfTableInfo tableInfo = _getTable('loca')!;
    currentOffset = tableInfo.offset;
    List<int> buffer;
    if (isShort) {
      final int len = tableInfo.length! ~/ 2;
      buffer = List<int>.filled(len, 0, growable: true);
      for (int i = 0; i < len; i++) {
        buffer[i] = _readUInt16(currentOffset!) * 2;
      }
    } else {
      final int len = tableInfo.length! ~/ 4;
      buffer = List<int>.filled(len, 0, growable: true);
      for (int i = 0; i < len; i++) {
        buffer[i] = _readUInt32(currentOffset!);
      }
    }
    return buffer;
  }

  dynamic _updateLocaTable(
      List<int> newLocaTable, bool isLocaShort, List<int>? newLocaTableOut) {
    final int size =
        isLocaShort ? newLocaTable.length * 2 : newLocaTable.length * 4;
    final int count = _align(size);
    final BigEndianWriter writer = BigEndianWriter(count);
    for (int i = 0; i < newLocaTable.length; i++) {
      int value = newLocaTable[i];
      if (isLocaShort) {
        value ~/= 2;
        writer.writeShort(value);
      } else {
        writer.writeInt(value);
      }
    }
    return <String, dynamic>{
      'newLocaUpdated': writer.data,
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
        currentOffset = tableInfo.offset! + glyphOffset;
        final _TtfGlyphHeader glyphHeader = _TtfGlyphHeader();
        glyphHeader.numberOfContours = _readInt16(currentOffset!);
        glyphHeader.xMin = _readInt16(currentOffset!);
        glyphHeader.yMin = _readInt16(currentOffset!);
        glyphHeader.xMax = _readInt16(currentOffset!);
        glyphHeader.yMax = _readInt16(currentOffset!);
        if (glyphHeader.numberOfContours < 0) {
          int skipBytes = 0;
          while (true) {
            final int flags = _readUInt16(currentOffset!);
            final int glyphIndex = _readUInt16(currentOffset!);
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
            currentOffset = currentOffset! + skipBytes;
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
          currentOffset = table!.offset! + oldGlyphOffset;
          final Map<String, dynamic> result =
              _read(newGlyphTable!, nextGlyphOffset, oldNextGlyphOffset)
                  as Map<String, dynamic>;
          newGlyphTable = result['buffer'] as List<int>?;
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
    final int fontProgramLength = result['fontProgramLength'] as int;
    final int numTables = result['numTables'] as int;
    final BigEndianWriter writer = BigEndianWriter(fontProgramLength);
    writer.writeInt(0x10000);
    writer.writeShort(numTables);
    final int entrySelector = _entrySelectors[numTables];
    writer.writeShort((1 << (entrySelector & 31)) * 16);
    writer.writeShort(entrySelector);
    writer.writeShort((numTables - (1 << (entrySelector & 31))) * 16);
    _writeCheckSums(writer, numTables, newLocaTableOut, newGlyphTable,
        glyphTableSize, locaTableSize);
    _writeGlyphs(writer, newLocaTableOut, newGlyphTable);
    return writer.data;
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
      BigEndianWriter writer,
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
      writer.writeString(tableName);
      if (tableName == 'glyf') {
        final int checksum = _calculateCheckSum(newGlyphTable);
        writer.writeInt(checksum);
        nextTableSize = glyphTableSize;
      } else if (tableName == 'loca') {
        final int checksum = _calculateCheckSum(newLocaTableOut);
        writer.writeInt(checksum);
        nextTableSize = locaTableSize;
      } else {
        writer.writeInt(tableInfo.checksum!);
        nextTableSize = tableInfo.length;
      }
      writer.writeUInt(usedTablesSize);
      writer.writeUInt(nextTableSize!);
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

  void _writeGlyphs(
      BigEndianWriter writer, List<int> newLocaTable, List<int> newGlyphTable) {
    final List<String> tableNames = _tableNames;
    for (int i = 0; i < tableNames.length; i++) {
      final String tableName = tableNames[i];
      final _TtfTableInfo tableInfo = _getTable(tableName)!;
      if (tableInfo.empty) {
        continue;
      }
      if (tableName == 'glyf') {
        writer.writeBytes(newGlyphTable);
      } else if (tableName == 'loca') {
        writer.writeBytes(newLocaTable);
      } else {
        final int count = _align(tableInfo.length!);
        final List<int> buff = List<int>.filled(count, 0, growable: true);
        currentOffset = tableInfo.offset;
        final dynamic result = _read(buff, 0, tableInfo.length!);
        writer.writeBytes(result['buffer']);
      }
    }
  }

  /// internal method
  String convertString(String text) {
    String glyph = '';
    for (int k = 0; k < text.length; k++) {
      final String char = text[k];
      final TtfGlyphInfo glyphInfo = getGlyph(char: char, isSetSymbol: true)!;
      if (!glyphInfo.empty) {
        glyph += String.fromCharCode(glyphInfo.index);
      }
    }
    return glyph;
  }

  int _readInt16(int offset) {
    int result = (_fontData[offset] << 8) + _fontData[offset + 1];
    result = (result & (1 << 15) != 0) ? result - 0x10000 : result;
    currentOffset = currentOffset! + 2;
    return result;
  }

  int _readUInt16(int offset) {
    final int i1 = _fontData[offset];
    final int i2 = _fontData[offset + 1];
    currentOffset = currentOffset! + 2;
    return (i1 << 8) | i2;
  }

  int _readInt32(int offset) {
    final int i1 = _fontData[offset + 3];
    final int i2 = _fontData[offset + 2];
    final int i3 = _fontData[offset + 1];
    final int i4 = _fontData[offset];
    currentOffset = currentOffset! + 4;
    return i1 + (i2 << 8) + (i3 << 16) + (i4 << 24);
  }

  int _readUInt32(int offset) {
    final int i1 = _fontData[offset + 3];
    final int i2 = _fontData[offset + 2];
    final int i3 = _fontData[offset + 1];
    final int i4 = _fontData[offset];
    currentOffset = currentOffset! + 4;
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
            result += String.fromCharCode(_fontData[currentOffset!]);
          }
          currentOffset = currentOffset! + 1;
        }
      } else {
        for (int i = 0; i < length!; i++) {
          result += String.fromCharCode(_fontData[currentOffset!]);
          currentOffset = currentOffset! + 1;
        }
      }
      return result;
    }
  }

  List<int> _readBytes(int length) {
    final List<int> result = List<int>.filled(length, 0, growable: true);
    for (int i = 0; i < length; i++) {
      result[i] = _fontData[currentOffset!];
      currentOffset = currentOffset! + 1;
    }
    return result;
  }

  List<int> _readUshortArray(int length) {
    final List<int> buffer = List<int>.filled(length, 0, growable: true);
    for (int i = 0; i < length; i++) {
      buffer[i] = _readUInt16(currentOffset!);
    }
    return buffer;
  }

  dynamic _read(List<int> buffer, int index, int count) {
    int written = 0;
    int read = 0;
    do {
      for (int i = 0;
          i < count - written && currentOffset! + i < _fontData.length;
          i++) {
        buffer[index + i] = _fontData[currentOffset! + i];
      }
      read = count - written;
      currentOffset = currentOffset! + read;
      written += read;
    } while (written < count);
    return <String, dynamic>{'buffer': buffer, 'written': written};
  }
}

class _TtfHeadTable {
  /// Modified: International date (8-byte field).
  int? modified;

  /// Created: International date (8-byte field).
  int? created;

  /// MagicNumber: Set to 0x5F0F3CF5.
  int? magicNumber;

  /// CheckSumAdjustment: To compute: set it to 0, sum the entire font as ULONG,
  /// then store 0xB1B0AFBA - sum.
  int? checkSumAdjustment;

  /// FontRevision: Set by font manufacturer.
  double? fontRevision;

  /// Table version number: 0x00010000 for version 1.0.
  double? version;

  /// Minimum x for all glyph bounding boxes.
  late int xMin;

  /// Minimum y for all glyph bounding boxes.
  int? yMin;

  /// Valid range is from 16 to 16384.
  int? unitsPerEm;

  /// Maximum y for all glyph bounding boxes.
  int? yMax;

  /// Maximum x for all glyph bounding boxes.
  late int xMax;

  /// Regular: 0
  /// Bold: 1
  /// Italic: 2
  /// Bold Italic: 3
  /// Bit 0 - bold (if set to 1)
  /// Bit 1 - italic (if set to 1)
  /// Bits 2-15 - reserved (set to 0)
  /// NOTE:
  /// Note that macStyle bits must agree with the 'OS/2' table fsSelection bits.
  /// The fsSelection bits are used over the macStyle bits in Microsoft Windows.
  /// The PANOSE values and 'post' table values are ignored
  ///  for determining bold or italic fonts.
  int? macStyle;

  /// Bit 0 - baseline for font at y=0
  /// Bit 1 - left SideBearing at x=0
  ///	Bit 2 - instructions may depend on point size
  ///	Bit 3 - force ppem to integer values for all private scaler math;
  /// may use fractional ppem sizes if this bit is clear
  ///	Bit 4 - instructions may alter advance width
  /// (the advance widths might not scale linearly)
  ///	Note: All other bits must be zero.
  int? flags;

  /// LowestRecPPEM: Smallest readable size in pixels.
  int? lowestReadableSize;

  /// FontDirectionHint:
  /// 0   Fully mixed directional glyphs
  /// 1   Only strongly left to right
  /// 2   Like 1 but also contains neutrals
  /// -1   Only strongly right to left
  /// -2   Like -1 but also contains neutrals.
  int? fontDirectionHint;

  /// 0 for short offsets, 1 for long.
  int? indexToLocalFormat;

  /// 0 for current format.
  int? glyphDataFormat;
}

class _TtfHorizontalHeaderTable {
  /// Version.
  double? version;

  /// Typographic ascent.
  late int ascender;

  /// Maximum advance width value in HTML table.
  int? advanceWidthMax;

  /// Typographic descent.
  late int descender;

  /// Number of hMetric entries in HTML table;
  /// may be smaller than the total number of glyphs in the font.
  late int numberOfHMetrics;

  /// Typographic line gap.
  /// Negative LineGap values are treated as DEF_TABLE_CHECKSUM
  /// in Windows 3.1, System 6, and System 7.
  late int lineGap;

  /// Minimum left SideBearing value in HTML table.
  int? minLeftSideBearing;

  /// Minimum right SideBearing value;
  /// calculated as Min(aw - lsb - (xMax - xMin)).
  int? minRightSideBearing;

  /// Max(lsb + (xMax - xMin)).
  int? xMaxExtent;

  /// Used to calculate the slope of the cursor (rise/run); 1 for vertical.
  int? caretSlopeRise;

  /// 0 for vertical.
  int? caretSlopeRun;

  /// 0 for current format.
  int? metricDataFormat;
}

/// name ttf table.
class _TtfNameTable {
  /// Local variable to store Format Selector.
  int? formatSelector;

  /// Local variable to store Records Count.
  late int recordsCount;

  /// Local variable to store Offset.
  late int offset;

  /// Local variable to store Name Records.
  late List<_TtfNameRecord> nameRecords;
}

class _TtfNameRecord {
  /// The PlatformID.
  int? platformID;

  /// The EncodingID.
  int? encodingID;

  /// The PlatformIDLanguageID
  int? languageID;

  /// The NameID.
  int? nameID;

  /// The Length.
  int? length;

  /// The Offset.
  late int offset;

  /// The Name.
  String? name;
}

class _TtfOS2Table {
  late int version;

  /// The Average Character Width parameter specifies
  /// the arithmetic average of the escapement (width)
  /// of all of the 26 lowercase letters a through z of the Latin alphabet
  /// and the space character. If any of the 26 lowercase letters are not
  /// present, this parameter should equal the weighted average of all
  /// glyphs in the font.
  /// For non-UGL (platform 3, encoding 0) fonts, use the unweighted average.
  int? xAvgCharWidth;

  /// Indicates the visual weight (degree of blackness or thickness of strokes)
  /// of the characters in the font.
  int? usWeightClass;

  /// Indicates a relative change from the normal aspect ratio (width to
  /// height ratio) as specified by a font designer for the glyphs in a font.
  int? usWidthClass;

  /// Indicates font embedding licensing rights for the font.
  /// Embeddable fonts may be stored in a document.
  /// When a document with embedded fonts is opened on a system that
  /// does not have the font installed (the remote system),
  /// the embedded font may be loaded for temporary
  /// (and in some cases, permanent) use on that system by an embedding-aware
  /// application.
  /// Embedding licensing rights are granted by the vendor of the font.
  int? fsType;

  /// The recommended horizontal size in font design units
  /// for subscripts for this font.
  int? ySubscriptXSize;

  /// The recommended vertical size in font design units
  /// for subscripts for this font.
  late int ySubscriptYSize;

  /// The recommended horizontal offset in font design units
  /// for subscripts for this font.
  int? ySubscriptXOffset;

  /// The recommended vertical offset in font design units from the baseline
  /// for subscripts for this font.
  int? ySubscriptYOffset;

  /// The recommended horizontal size in font design units
  /// for superscripts for this font.
  int? ySuperscriptXSize;

  /// The recommended vertical size in font design units
  /// for superscripts for this font.
  late int ySuperscriptYSize;

  /// The recommended horizontal offset in font design units
  /// for superscripts for this font.
  int? ySuperscriptXOffset;

  /// The recommended vertical offset in font design units from the baseline
  /// for superscripts for this font.
  int? ySuperscriptYOffset;

  /// Width of the strikethrough stroke in font design units.
  int? yStrikeoutSize;

  /// The position of the strikethrough stroke relative to the baseline
  /// in font design units.
  int? yStrikeoutPosition;

  /// This parameter is a classification of font-family design.
  int? sFamilyClass;

  /// This 10 byte series of numbers are used to describe the visual
  /// characteristics of a given typeface.
  /// These characteristics are then used to associate the font with
  /// other fonts of similar appearance having different names.
  /// The variables for each digit are listed below.
  /// The specifications for each variable can be obtained in the specification
  /// PANOSE v2.0 Numerical Evaluation from Microsoft or Elseware Corporation.
  List<int>? panose;

  int? ulUnicodeRange1;
  int? ulUnicodeRange2;
  int? ulUnicodeRange3;
  int? ulUnicodeRange4;

  /// The four character identifier for the vendor of the given type face.
  List<int>? vendorIdentifier;

  /// Information concerning the nature of the font patterns.
  int? fsSelection;

  /// The minimum Unicode index (character code) in this font,
  /// according to the cmap subtable for platform ID 3 and encoding ID 0 or 1.
  /// For most fonts supporting Win-ANSI or other character sets,
  /// this value would be 0x0020.
  int? usFirstCharIndex;

  /// usLastCharIndex: The maximum Unicode index (character code) in this font,
  /// according to the cmap subtable for platform ID 3 and encoding ID 0 or 1.
  /// This value depends on which character sets the font supports.
  int? usLastCharIndex;

  /// The typographic ascender for this font.
  /// Remember that this is not the same as the Ascender value
  /// in the 'hhea' table, which Apple defines in a far different manner.
  /// DEF_TABLE_OFFSET good source for usTypoAscender is the Ascender value
  /// from an AFM file.
  late int sTypoAscender;

  /// The typographic descender for this font.
  /// Remember that this is not the same as the Descender value
  ///  in the 'hhea' table,
  /// which Apple defines in a far different manner.
  /// DEF_TABLE_OFFSET good source for usTypoDescender is the Descender value
  /// from an AFM file.
  late int sTypoDescender;

  /// The typographic line gap for this font.
  /// Remember that this is not the same as the LineGap value in the
  /// 'hhea' table, which Apple defines in a far different manner.
  late int sTypoLineGap;

  /// The ascender metric for Windows.
  /// This too is distinct from Apple's Ascender value and from the
  /// usTypoAscender values, usWinAscent is computed as the yMax for all
  /// characters in the Windows ANSI character set.
  /// usTypoAscent is used to compute the Windows font height and
  /// default line spacing.
  /// For platform 3 encoding 0 fonts, it is the same as yMax.
  int? usWinAscent;

  /// The descender metric for Windows.
  /// This too is distinct from Apple's Descender value and
  /// from the usTypoDescender values.
  /// usWinDescent is computed as the -yMin for all characters
  /// in the Windows ANSI character set.
  /// usTypoAscent is used to compute the Windows font height and
  /// default line spacing.
  /// For platform 3 encoding 0 fonts, it is the same as -yMin.
  int? usWinDescent;

  /// This field is used to specify the code pages encompassed
  /// by the font file in the 'cmap' subtable for platform 3,
  /// encoding ID 1 (Microsoft platform).
  /// If the font file is encoding ID 0, then the Symbol Character Set bit
  /// should be set.
  /// If the bit is set (1) then the code page is considered functional.
  /// If the bit is clear (0) then the code page is not considered functional.
  /// Each of the bits is treated as an independent flag and the bits can be
  /// set in any combination.
  /// The determination of "functional" is left up to the font designer,
  /// although character set selection should attempt to be functional
  /// by code pages if at all possible.
  int? ulCodePageRange1;

  /// This field is used to specify the code pages encompassed
  /// by the font file in the 'cmap' subtable for platform 3,
  /// encoding ID 1 (Microsoft platform).
  /// If the font file is encoding ID 0, then the Symbol Character Set
  /// bit should be set.
  /// If the bit is set (1) then the code page is considered functional.
  /// If the bit is clear (0) then the code page is not considered functional.
  /// Each of the bits is treated as an independent flag and the bits can be
  /// set in any combination.
  /// The determination of "functional" is left up to the font designer,
  /// although character set selection should attempt to be functional by
  /// code pages if at all possible.
  int? ulCodePageRange2;

  int? sxHeight;
  int? sCapHeight;
  int? usDefaultChar;
  int? usBreakChar;
  int? usMaxContext;
}

class _TtfTableInfo {
  /// Gets or sets ofset from beginning of TrueType font file.
  int? offset;

  /// Gets or sets length of this table.
  int? length;

  /// Gets or sets table checksum.
  int? checksum;

  /// Gets a value indicating whether this [_TtfTableInfo] is empty.
  /// true if empty, otherwise false
  bool get empty =>
      offset == length &&
      length == checksum &&
      (checksum == 0 || checksum == null);
}

class _TtfPostTable {
  double? formatType;
  double? italicAngle;
  int? underlinePosition;
  int? underlineThickness;
  int? isFixedPitch;
  int? minType42;
  int? maxType42;
  int? minType1;
  int? maxType1;
}

class _TtfCmapSubTable {
  int? platformID;
  int? encodingID;
  late int offset;
}

class _TtfCmapTable {
  int? version;
  late int tablesCount;
}

class _TtfLongHorMetric {
  late int advanceWidth;
  int? lsb;
}

class _TtfAppleCmapSubTable {
  int? format;
  int? length;
  int? version;
}

/// internal class
class TtfGlyphInfo {
  /// Holds glyph index.
  int index = 0;

  /// Holds character's width.
  int width = 0;

  /// Code of the char symbol.
  int charCode = 0;

  /// Gets a value indicating whether [TtfGlyphInfo] is empty.
  bool get empty {
    return index == width && width == charCode && charCode == 0;
  }
}

class _TtfMicrosoftCmapSubTable {
  int? format;
  late int length;
  int? version;
  late int segCountX2;
  int? searchRange;
  int? entrySelector;
  int? rangeShift;
  late List<int> endCount;
  int? reservedPad;
  late List<int> startCount;
  late List<int> idDelta;
  late List<int> idRangeOffset;
  late List<int> glyphID;
}

class _TtfTrimmedCmapSubTable {
  int? format;
  int? length;
  int? version;
  late int firstCode;
  late int entryCount;
}

class _TtfGlyphHeader {
  late int numberOfContours;
  int? xMin;
  int? yMin;
  int? xMax;
  int? yMax;
}

/// Enumerator that implements CMAP formats.
enum _TtfCmapFormat {
  /// This is the Apple standard character to glyph index mapping table.
  apple,

  /// This is the Microsoft standard character to glyph index mapping table.
  microsoft,

  /// Format 6: Trimmed table mapping.
  trimmed,

  /// This is the Microsoft standard character-to-glyph-index mapping table for fonts supporting Unicode supplementary-plane characters (U+10000 to U+10FFFF).
  microsoftExt
}

/// Enumerator that implements CMAP encodings.
enum _TtfCmapEncoding {
  /// Unknown encoding.
  unknown,

  /// When building a symbol font for Windows.
  symbol,

  /// When building a Unicode font for Windows.
  unicode,

  /// For font that will be used on a Macintosh.
  macintosh,

  /// When building a Unicode font for Windows (plane characters).
  unicodeUCS4
}

/// Ttf platform ID.
enum _TtfPlatformID {
  /// Apple platform.
  appleUnicode,

  /// Macintosh platform.
  macintosh,

  /// Iso platform.
  iso,

  /// Microsoft platform.
  microsoft
}

/// Microsoft encoding ID.
enum _TtfMicrosoftEncodingID {
  /// Undefined encoding.
  undefined,

  /// Unicode encoding.
  unicode,

  /// Unicode UCS4.
  unicodeUCS4
}

/// Macintosh encoding ID.
enum _TtfMacintoshEncodingID {
  /// Roman encoding.
  roman,

  /// Japanese encoding.
  japanese,

  /// Chinese encoding.
  chinese
}
