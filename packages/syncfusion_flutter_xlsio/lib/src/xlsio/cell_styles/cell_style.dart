part of xlsio;

/// Represent the Cell style class.
class CellStyle implements Style {
  /// Creates an new instances of the Workbook.
  CellStyle(Workbook workbook, [String name]) {
    _book = workbook;
    backColor = 'none';
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
    if (name != null) this.name = name;
  }

  /// Represents cell style name.
  @override
  String name;

  /// Represents cell style index.
  @override
  int index;

  @override

  /// Gets/sets back color.
  String backColor;

  /// Gets/sets borders.
  Borders _borders;

  @override

  /// Gets/sets font name.
  String fontName;

  @override

  /// Gets/sets font size.
  double fontSize;

  @override

  /// Gets/sets font color.
  String fontColor;

  @override

  /// Gets/sets font italic.
  bool italic;

  @override

  /// Gets/sets font bold.
  bool bold;

  @override

  /// Gets/sets horizontal alignment.
  HAlignType hAlign;

  @override

  /// Gets/sets cell indent.
  int indent;

  @override

  /// Gets/sets cell rotation.
  int rotation;

  @override

  /// Gets/sets vertical alignment.
  VAlignType vAlign;

  @override

  /// Gets/sets font underline.
  bool underline;

  @override

  /// Gets/sets cell wraptext.
  bool wrapText;

  /// Represents the global style.
  bool isGlobalStyle;

  @override
  int numberFormatIndex;

  /// Represents the workbook.
  Workbook _book;

  int _builtinId;

  @override

  /// Gets/Sets cell Lock
  bool locked;

  @override

  /// Sets borders.
  BordersCollection get borders {
    _borders ??= BordersCollection(_book);
    return _borders;
  }

  @override

  /// Sets borders.
  set borders(Borders value) {
    _borders = value;
  }

  /// Gets number format object.
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
  String get numberFormat {
    return numberFormatObject._formatString;
  }

  @override

  /// Sets the number format.
  set numberFormat(String value) {
    numberFormatIndex = _book.innerFormats._findOrCreateFormat(value);
  }

  /// Represents the wookbook
  Workbook get _workbook {
    return _book;
  }

  /// clone method of cell style
  CellStyle _clone() {
    final CellStyle _cellStyle = CellStyle(_workbook);
    _cellStyle.name = name;
    _cellStyle.backColor = backColor;
    _cellStyle.fontName = fontName;
    _cellStyle.fontSize = fontSize;
    _cellStyle.fontColor = fontColor;
    _cellStyle.italic = italic;
    _cellStyle.bold = bold;
    _cellStyle.underline = underline;
    _cellStyle.wrapText = wrapText;
    _cellStyle.hAlign = hAlign;
    _cellStyle.vAlign = vAlign;
    _cellStyle.indent = indent;
    _cellStyle.rotation = rotation;
    _cellStyle.index = index;
    _cellStyle._builtinId = _builtinId;
    _cellStyle.numberFormat = numberFormat;
    _cellStyle.numberFormatIndex = numberFormatIndex;
    _cellStyle.isGlobalStyle = isGlobalStyle;
    _cellStyle.locked = locked;
    _cellStyle.borders = borders._clone();
    return _cellStyle;
  }

  /// Compares two instances of the Cell styles.
  @override
  bool operator ==(Object toCompare) {
    final CellStyle baseStyle = this;
    final CellStyle toCompareStyle = toCompare;

    return (baseStyle.backColor == toCompareStyle.backColor &&
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
        baseStyle.locked == toCompareStyle.locked);
  }

  @override
  int get hashCode => hashValues(
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
      borders);

  /// clear the borders
  void _clear() {
    if (_borders != null) {
      (_borders as BordersCollection)._clear();
      _borders = null;
    }
  }
}
