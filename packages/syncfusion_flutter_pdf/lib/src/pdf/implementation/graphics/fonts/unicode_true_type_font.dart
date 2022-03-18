import 'dart:math';

import '../../../interfaces/pdf_interface.dart';
import '../../drawing/drawing.dart';
import '../../io/pdf_constants.dart';
import '../../primitives/pdf_array.dart';
import '../../primitives/pdf_dictionary.dart';
import '../../primitives/pdf_name.dart';
import '../../primitives/pdf_number.dart';
import '../../primitives/pdf_reference_holder.dart';
import '../../primitives/pdf_stream.dart';
import '../../primitives/pdf_string.dart';
import 'pdf_font_metrics.dart';
import 'ttf_metrics.dart';
import 'ttf_reader.dart';

/// internal class
class UnicodeTrueTypeFont {
  /// internal constructor
  UnicodeTrueTypeFont(List<int> fontData, double size) {
    _initialize(fontData, size);
  }

  //Constants
  final String _cmapPrefix =
      '/CIDInit /ProcSet findresource begin\n12 dict begin\nbegincmap${PdfOperators.newLine}/CIDSystemInfo << /Registry (Adobe)/Ordering (UCS)/Supplement 0>> def\n/CMapName /Adobe-Identity-UCS def\n/CMapType 2 def\n1 begincodespacerange${PdfOperators.newLine}';

  /// Cmap table's start suffix.
  final String _cmapEndCodespaceRange =
      'endcodespacerange${PdfOperators.newLine}';

  /// Cmap's begin range marker.
  final String _cmapBeginRange = 'beginbfrange${PdfOperators.newLine}';

  /// Cmap's end range marker.
  final String _cmapEndRange = 'endbfrange${PdfOperators.newLine}';

  /// Cmap table's end
  final String _cmapSuffix =
      'endbfrange\nendcmap\nCMapName currentdict /CMap defineresource pop\nend end${PdfOperators.newLine}';

  //Fields
  /// internal field
  late List<int> fontData;

  /// internal field
  late double _size;

  /// internal field
  late TtfReader reader;

  /// internal field
  TtfMetrics? ttfMetrics;

  /// internal field
  late PdfFontMetrics metrics;

  /// internal field
  PdfDictionary? fontDictionary;
  PdfStream? _fontProgram;
  PdfStream? _cmap;
  PdfDictionary? _descendantFont;
  String? _subsetName;
  List<String>? _usedChars;
  List<String>? _surrogateChars;
  PdfDictionary? _fontDescriptor;
  PdfStream? _cidStream;

  //Implementation
  void _initialize(List<int> fontData, double size) {
    this.fontData = fontData;
    _size = size;
    reader = TtfReader(this.fontData);
    ttfMetrics = reader.metrics;
  }

  /// internal method
  void createInternals() {
    fontDictionary = PdfDictionary();
    _fontProgram = PdfStream();
    _cmap = PdfStream();
    _descendantFont = PdfDictionary();
    metrics = PdfFontMetrics();
    reader.createInternals();
    ttfMetrics = reader.metrics;
    _initializeMetrics();
    _subsetName = _getFontName(reader.metrics!.postScriptName!);
    _createDescendantFont();
    _createCmap();
    _createFontDictionary();
    _createFontProgram();
  }

  void _initializeMetrics() {
    final TtfMetrics ttfMetrics = reader.metrics!;
    metrics.ascent = ttfMetrics.macAscent;
    metrics.descent = ttfMetrics.macDescent;
    metrics.height =
        ttfMetrics.macAscent - ttfMetrics.macDescent + ttfMetrics.lineGap!;
    metrics.name = ttfMetrics.fontFamily!;
    metrics.postScriptName = ttfMetrics.postScriptName;
    metrics.size = _size;
    metrics.widthTable = StandardWidthTable(ttfMetrics.widthTable);
    metrics.lineGap = ttfMetrics.lineGap!;
    metrics.subscriptSizeFactor = ttfMetrics.subscriptSizeFactor;
    metrics.superscriptSizeFactor = ttfMetrics.superscriptSizeFactor;
    metrics.isBold = ttfMetrics.isBold;
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
    return '$name+$builder';
  }

  void _createDescendantFont() {
    _descendantFont!.beginSave = _descendantFontBeginSave;
    _descendantFont![PdfDictionaryProperties.type] =
        PdfName(PdfDictionaryProperties.font);
    _descendantFont![PdfDictionaryProperties.subtype] =
        PdfName(PdfDictionaryProperties.cidFontType2);
    _descendantFont![PdfDictionaryProperties.baseFont] = PdfName(_subsetName);
    _descendantFont![PdfDictionaryProperties.cidToGIDMap] =
        PdfName(PdfDictionaryProperties.identity);
    _descendantFont![PdfDictionaryProperties.dw] = PdfNumber(1000);
    _fontDescriptor = _createFontDescriptor();
    _descendantFont![PdfDictionaryProperties.fontDescriptor] =
        PdfReferenceHolder(_fontDescriptor);
    _descendantFont![PdfDictionaryProperties.cidSystemInfo] =
        _createSystemInfo();
  }

  PdfDictionary _createFontDescriptor() {
    final PdfDictionary descriptor = PdfDictionary();
    final TtfMetrics metrics = reader.metrics!;
    descriptor[PdfDictionaryProperties.type] =
        PdfName(PdfDictionaryProperties.fontDescriptor);
    descriptor[PdfDictionaryProperties.fontName] = PdfName(_subsetName);
    descriptor[PdfDictionaryProperties.flags] =
        PdfNumber(_getDescriptorFlags());
    final PdfRectangle rect = reader.metrics!.fontBox;
    descriptor[PdfDictionaryProperties.fontBBox] = PdfArray(
        <double?>[rect.x, rect.y + rect.height, rect.width, -rect.height]);
    descriptor[PdfDictionaryProperties.missingWidth] =
        PdfNumber(metrics.widthTable[32]);
    descriptor[PdfDictionaryProperties.stemV] = PdfNumber(metrics.stemV);
    descriptor[PdfDictionaryProperties.italicAngle] =
        PdfNumber(metrics.italicAngle!);
    descriptor[PdfDictionaryProperties.capHeight] =
        PdfNumber(metrics.capHeight);
    descriptor[PdfDictionaryProperties.ascent] = PdfNumber(metrics.winAscent);
    descriptor[PdfDictionaryProperties.descent] = PdfNumber(metrics.winDescent);
    descriptor[PdfDictionaryProperties.leading] = PdfNumber(metrics.leading);
    descriptor[PdfDictionaryProperties.avgWidth] =
        PdfNumber(metrics.widthTable[32]);
    descriptor[PdfDictionaryProperties.fontFile2] =
        PdfReferenceHolder(_fontProgram);
    descriptor[PdfDictionaryProperties.maxWidth] =
        PdfNumber(metrics.widthTable[32]);
    descriptor[PdfDictionaryProperties.xHeight] = PdfNumber(0);
    descriptor[PdfDictionaryProperties.stemH] = PdfNumber(0);
    return descriptor;
  }

  int _getDescriptorFlags() {
    int flags = 0;
    final TtfMetrics metrics = reader.metrics!;
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

  IPdfPrimitive _createSystemInfo() {
    final PdfDictionary systemInfo = PdfDictionary();
    systemInfo[PdfDictionaryProperties.registry] = PdfString('Adobe');
    systemInfo[PdfDictionaryProperties.ordering] =
        PdfString(PdfDictionaryProperties.identity);
    systemInfo[PdfDictionaryProperties.supplement] = PdfNumber(0);
    return systemInfo;
  }

  void _descendantFontBeginSave(Object sender, SavePdfPrimitiveArgs? ars) {
    if (_usedChars != null && _usedChars!.isNotEmpty) {
      final PdfArray width = _getDescendantWidth();
      _descendantFont![PdfDictionaryProperties.w] = width;
    }
  }

  void _createCmap() {
    _cmap!.beginSave = _cmapBeginSave;
  }

  void _cmapBeginSave(Object sender, SavePdfPrimitiveArgs? ars) {
    _generateCmap();
  }

  void _createFontDictionary() {
    fontDictionary!.beginSave = _fontDictionaryBeginSave;
    fontDictionary![PdfDictionaryProperties.type] =
        PdfName(PdfDictionaryProperties.font);
    fontDictionary![PdfDictionaryProperties.baseFont] = PdfName(_subsetName);
    fontDictionary![PdfDictionaryProperties.subtype] =
        PdfName(PdfDictionaryProperties.type0);
    fontDictionary![PdfDictionaryProperties.encoding] =
        PdfName(PdfDictionaryProperties.identityH);
    final PdfArray descFonts = PdfArray();
    final PdfReferenceHolder reference = PdfReferenceHolder(_descendantFont);
    descFonts.add(reference);
    fontDictionary![PdfDictionaryProperties.descendantFonts] = descFonts;
  }

  void _fontDictionaryBeginSave(Object sender, SavePdfPrimitiveArgs? ars) {
    if (_usedChars != null &&
        _usedChars!.isNotEmpty &&
        !fontDictionary!.containsKey(PdfDictionaryProperties.toUnicode)) {
      fontDictionary![PdfDictionaryProperties.toUnicode] =
          PdfReferenceHolder(_cmap);
    }
  }

  PdfArray _getDescendantWidth() {
    final PdfArray array = PdfArray();
    if (_usedChars != null && _usedChars!.isNotEmpty) {
      final List<TtfGlyphInfo> glyphInfo = <TtfGlyphInfo>[];
      for (int i = 0; i < _usedChars!.length; i++) {
        final String chLen = _usedChars![i];
        final TtfGlyphInfo glyph = reader.getGlyph(char: chLen)!;
        if (glyph.empty) {
          continue;
        }
        glyphInfo.add(glyph);
      }
      glyphInfo
          .sort((TtfGlyphInfo a, TtfGlyphInfo b) => a.index.compareTo(b.index));
      int firstGlyphIndex = 0;
      int lastGlyphIndex = 0;
      bool firstGlyphIndexWasSet = false;
      PdfArray widthDetails = PdfArray();
      for (int i = 0; i < glyphInfo.length; i++) {
        final TtfGlyphInfo glyph = glyphInfo[i];
        if (!firstGlyphIndexWasSet) {
          firstGlyphIndexWasSet = true;
          firstGlyphIndex = glyph.index;
          lastGlyphIndex = glyph.index - 1;
        }
        if ((lastGlyphIndex + 1 != glyph.index ||
                (i + 1 == glyphInfo.length)) &&
            glyphInfo.length > 1) {
          array.add(PdfNumber(firstGlyphIndex));
          if (i != 0) {
            array.add(widthDetails);
          }
          firstGlyphIndex = glyph.index;
          widthDetails = PdfArray();
        }
        widthDetails.add(PdfNumber(glyph.width));
        if (i + 1 == glyphInfo.length) {
          array.add(PdfNumber(firstGlyphIndex));
          array.add(widthDetails);
        }
        lastGlyphIndex = glyph.index;
      }
    }
    return array;
  }

  void _generateCmap() {
    if (_usedChars != null && _usedChars!.isNotEmpty) {
      final Map<int, int> glyphChars = reader.getGlyphChars(_usedChars!);
      if (glyphChars.isNotEmpty) {
        final List<int> keys = glyphChars.keys.toList();
        keys.sort();
        final int first = keys[0];
        final int last = keys[keys.length - 1];
        final String middlePart = _getHexString(first, false) +
            _getHexString(last, false) +
            PdfOperators.newLine;
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
            builder += PdfOperators.whiteSpace;
            builder += _cmapBeginRange;
          }
          nextRange -= 1;
          final int key = keys[i];
          builder +=
              '${_getHexString(key, true)}${_getHexString(key, true)}${_getHexString(glyphChars[key]!, true)}\n';
        }
        builder += _cmapSuffix;
        _cmap!.clearStream();
        _cmap!.write(builder);
      }
    }
  }

  void _createFontProgram() {
    _fontProgram!.beginSave = _fontProgramBeginSave;
  }

  void _fontProgramBeginSave(Object sender, SavePdfPrimitiveArgs? ars) {
    _generateFontProgram();
  }

  void _generateFontProgram() {
    List<int>? fontProgram;
    _usedChars ??= <String>[];
    reader.currentOffset = 0;
    fontProgram = reader.readFontProgram(_usedChars!);
    _fontProgram!.clearStream();
    _fontProgram!.write(fontProgram);
  }

  String _getHexString(int n, bool isCaseChange) {
    String s = n.toRadixString(16);
    if (isCaseChange) {
      s = s.toUpperCase();
    }
    return '${'<0000'.substring(0, 5 - s.length)}$s>';
  }

  /// internal method
  double getLineWidth(String line) {
    double width = 0;
    for (int i = 0; i < line.length; i++) {
      width += reader.getCharWidth(line[i]);
    }
    return width;
  }

  /// internal method
  void setSymbols(String text, List<String>? usedChars) {
    _usedChars ??= <String>[];
    if (usedChars != null && usedChars.isNotEmpty) {
      _surrogateChars ??= <String>[];
      for (final String surrogateChar in usedChars) {
        if (!_surrogateChars!.contains(surrogateChar)) {
          _surrogateChars!.add(surrogateChar);
          _usedChars!.add(surrogateChar[0]);
          _usedChars!.add(surrogateChar[1]);
        }
      }
    }
    for (int i = 0; i < text.length; i++) {
      if (!_usedChars!.contains(text[i])) {
        _usedChars!.add(text[i]);
      }
    }
    _getDescendantWidth();
  }

  /// internal method
  double getCharWidth(String charCode) {
    return reader.getCharWidth(charCode);
  }

  /// internal method
  void initializeCidSet() {
    _cidStream = PdfStream();
    _cidStream!.beginSave = _cidBeginSave;
    _fontDescriptor!.beginSave = _fontDescriptorBeginSave;
  }

  //Runs before Cid will be saved.
  void _cidBeginSave(Object sender, SavePdfPrimitiveArgs? ars) {
    _generateCidSet();
  }

  //Runs before font Dictionary will be saved.
  void _fontDescriptorBeginSave(Object sender, SavePdfPrimitiveArgs? ars) {
    if ((_usedChars != null && _usedChars!.isNotEmpty) &&
        !_fontDescriptor!.containsKey(PdfDictionaryProperties.cidSet)) {
      _fontDescriptor![PdfDictionaryProperties.cidSet] =
          PdfReferenceHolder(_cidStream);
    }
  }

  //This is important for PDF/A conformance validation
  void _generateCidSet() {
    final List<int> dummyBits = <int>[
      0x80,
      0x40,
      0x20,
      0x10,
      0x08,
      0x04,
      0x02,
      0x01
    ];
    if (_usedChars != null && _usedChars!.isNotEmpty) {
      final Map<int, int> glyphChars = reader.getGlyphChars(_usedChars!);
      List<int>? charBytes;
      if (glyphChars.isNotEmpty) {
        final List<int> cidChars = glyphChars.keys.toList();
        cidChars.sort();
        final int last = cidChars[cidChars.length - 1];
        charBytes = List<int>.filled((last ~/ 8) + 1, 0, growable: true);
        charBytes.fillRange(0, (last ~/ 8) + 1, 0);
        for (int i = 0; i < cidChars.length; i++) {
          final int cid = cidChars[i];
          charBytes[cid ~/ 8] |= dummyBits[cid % 8];
        }
      }
      _cidStream!.write(charBytes);
    }
  }
}
