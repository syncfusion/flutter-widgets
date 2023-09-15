part of xlsio;

/// Represent the Cell style class.
class CellStyle implements Style {
  /// Creates an new instances of the Workbook.
  CellStyle(Workbook workbook, [String? name]) {
    _book = workbook;
    backColor = '#FFFFFF';
    fontName = 'Calibri';
    fontSize = 11;
    fontColor = '#000000';
    italic = false;
    bold = false;
    underline = false;
    wrapText = false;
    hAlign = HAlignType.general;
    vAlign = VAlignType.bottom;
    indent = 0;
    rotation = 0;
    numberFormat = 'General';
    _builtinId = 0;
    borders = BordersCollection(_book);
    isGlobalStyle = false;
    locked = true;
    _borders = BordersCollection(_book);
    if (name != null) {
      this.name = name;
    }
  }

  /// Represents cell style name.
  @override
  String name = '';

  /// Represents cell style index.
  @override
  int index = -1;

  String _backColor = '';

  @override

  /// Gets/sets back color.
  String get backColor => _backColor;

  @override
  set backColor(String value) {
    _backColor = value;
    _backColorRgb =
        Color(int.parse(_backColor.substring(1, 7), radix: 16) + 0xFF000000);
  }

  /// Gets/sets borders.
  late BordersCollection _borders;

  @override

  /// Gets/sets font name.
  late String fontName;

  @override

  /// Gets/sets font size.
  late double fontSize;

  String _fontColor = '';
  @override

  /// Gets/sets font color.
  String get fontColor => _fontColor;

  @override
  set fontColor(String value) {
    _fontColor = value;
    _fontColorRgb =
        Color(int.parse(_fontColor.substring(1, 7), radix: 16) + 0xFF000000);
  }

  @override

  /// Gets/sets font italic.
  late bool italic;

  @override

  /// Gets/sets font bold.
  late bool bold;

  @override

  /// Gets/sets horizontal alignment.
  late HAlignType hAlign;

  @override

  /// Gets/sets cell indent.
  late int indent;

  @override

  /// Gets/sets cell rotation.
  late int rotation;

  @override

  /// Gets/sets vertical alignment.
  late VAlignType vAlign;

  @override

  /// Gets/sets font underline.
  late bool underline;

  @override

  /// Gets/sets cell wraptext.
  late bool wrapText;

  /// Represents the global style.
  bool isGlobalStyle = false;

  @override
  late int numberFormatIndex;

  /// Represents the workbook.
  late Workbook _book;

  int _builtinId = 0;

  @override

  /// Gets/Sets cell Lock
  late bool locked;

  @override

  /// Sets borders.
  Borders get borders {
    return _borders;
  }

  @override

  /// Sets borders.
  set borders(Borders value) {
    _borders = value as BordersCollection;
  }

  /// Gets number format object.
  // ignore: library_private_types_in_public_api
  _Format get numberFormatObject {
    //MS Excel sets 14th index by default if the index is out of range for any the datatype.
    //So, using the same here in XlsIO.
    if (_book.innerFormats.count > 14 &&
        !_book.innerFormats._contains(numberFormatIndex)) {
      numberFormatIndex = 14;
    }
    return _book.innerFormats[numberFormatIndex];
  }

  @override

  /// Returns or sets the format code for the object. Read/write String.
  String? get numberFormat {
    return numberFormatObject._formatString;
  }

  @override

  /// Sets the number format.
  set numberFormat(String? value) {
    numberFormatIndex = _book.innerFormats._findOrCreateFormat(value);
  }

  /// Represents the wookbook
  Workbook get _workbook {
    return _book;
  }

  Color _backColorRgb = const Color.fromARGB(255, 0, 0, 0);

  Color _fontColorRgb = const Color.fromARGB(255, 0, 0, 0);

  @override

  /// Gets/sets back color Rgb.
  Color get backColorRgb => _backColorRgb;

  @override
  set backColorRgb(Color value) {
    _backColorRgb = value;
    if (_backColorRgb.value.toRadixString(16).toUpperCase() != 'FFFFFFFF') {
      _backColor = _backColorRgb.value.toRadixString(16).toUpperCase();
    }
  }

  @override

  /// Gets/sets font color Rgb.
  Color get fontColorRgb => _fontColorRgb;

  @override
  set fontColorRgb(Color value) {
    _fontColorRgb = value;
    _fontColor = _fontColorRgb.value.toRadixString(16).toUpperCase();
  }

  /// clone method of cell style
  CellStyle _clone() {
    final CellStyle cellStyle = CellStyle(_workbook);
    cellStyle.name = name;
    cellStyle.backColor = backColor;
    cellStyle.fontName = fontName;
    cellStyle.fontSize = fontSize;
    cellStyle.fontColor = fontColor;
    cellStyle.italic = italic;
    cellStyle.bold = bold;
    cellStyle.underline = underline;
    cellStyle.wrapText = wrapText;
    cellStyle.hAlign = hAlign;
    cellStyle.vAlign = vAlign;
    cellStyle.indent = indent;
    cellStyle.rotation = rotation;
    cellStyle.index = index;
    cellStyle._builtinId = _builtinId;
    cellStyle.numberFormat = numberFormat;
    cellStyle.numberFormatIndex = numberFormatIndex;
    cellStyle.isGlobalStyle = isGlobalStyle;
    cellStyle.locked = locked;
    cellStyle.borders = (borders as BordersCollection)._clone();
    cellStyle.backColorRgb = backColorRgb;
    cellStyle.fontColorRgb = fontColorRgb;
    return cellStyle;
  }

  /// Compares two instances of the Cell styles.
  @override
  // ignore: avoid_equals_and_hash_code_on_mutable_classes
  bool operator ==(Object toCompare) {
    final CellStyle baseStyle = this;
    // ignore: test_types_in_equals
    final CellStyle toCompareStyle = toCompare as CellStyle;

    return baseStyle.backColor == toCompareStyle.backColor &&
        baseStyle.bold == toCompareStyle.bold &&
        baseStyle.numberFormatIndex == toCompareStyle.numberFormatIndex &&
        baseStyle.numberFormat == toCompareStyle.numberFormat &&
        baseStyle.fontColor == toCompareStyle.fontColor &&
        baseStyle.fontName == toCompareStyle.fontName &&
        baseStyle.fontSize == toCompareStyle.fontSize &&
        baseStyle.hAlign == toCompareStyle.hAlign &&
        baseStyle.italic == toCompareStyle.italic &&
        baseStyle.underline == toCompareStyle.underline &&
        baseStyle.vAlign == toCompareStyle.vAlign &&
        baseStyle.indent == toCompareStyle.indent &&
        baseStyle.rotation == toCompareStyle.rotation &&
        baseStyle.wrapText == toCompareStyle.wrapText &&
        baseStyle.borders == toCompareStyle.borders &&
        baseStyle.locked == toCompareStyle.locked &&
        baseStyle.backColorRgb == toCompareStyle.backColorRgb &&
        baseStyle.fontColorRgb == toCompareStyle.fontColorRgb;
  }

  @override
  // ignore: avoid_equals_and_hash_code_on_mutable_classes
  int get hashCode => Object.hash(
        name,
        backColor,
        fontName,
        fontSize,
        fontColor,
        italic,
        bold,
        underline,
        wrapText,
        hAlign,
        vAlign,
        indent,
        rotation,
        index,
        _builtinId,
        numberFormat,
        numberFormatIndex,
        isGlobalStyle,
        locked,
        borders,
      );

  /// clear the borders
  void _clear() {
    _borders._clear();
  }
}
