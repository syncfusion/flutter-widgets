part of xlsio;

/// Represents an Excel Workbook.
class Workbook {
  /// Creates an new instances of the Workbook.
  Workbook([int count]) {
    initializeWorkbook(null, null, count);
  }

  /// Creates an new instances of the Workbook with currency.
  Workbook.withCulture(String culture, [String currency, int count]) {
    if (count != null) {
      initializeWorkbook(culture, currency, count);
    } else {
      initializeWorkbook(culture, currency, 1);
    }
  }

  /// Represents zip archive to save the workbook.
  Archive _archive;

  /// Represents the shared string dictionary.
  Map<String, int> _sharedString;

  /// Represents the shared string count in the workbook.
  int sharedStringCount = 0;

  /// Represents the maximum row count in the workbook.
  final int _maxRowCount = 1048576;

  /// Represents the maximum column count in the workbook.
  final int _maxColumnCount = 16384;

  /// Represents the cell style collection in the workbok.
  Map<String, GlobalStyle> _cellStyles;

  /// Represents the merged cell collection in the workbok.
  Map<String, ExtendStyle> _mergedCellsStyle;

  /// Represents the worksheet collection.
  WorksheetCollection _worksheets;

  /// Represents the build in properties.
  BuiltInProperties _builtInProperties;

  /// Represents the font collection in the workbook.
  List<Font> fonts;

  /// Represents the border collection in the workbook.
  List<Borders> borders;

  /// Represents the Fill collection in the workbook.
  Map<String, int> fills;

  /// Represents the cell style collection in the workbook.
  StylesCollection _styles;

  /// Represents the CellXf collection in the workbook.
  List<CellXfs> cellXfs;

  /// Represents the CellStyleXf collection in the workbook.
  List<CellStyleXfs> cellStyleXfs;

  /// Represents the print title collection.
  Map<int, String> _printTitles;

  /// Represents the current culture.
  String culture;

  /// Represents the current culture currency.
  String currency;

  /// Represents the RGB colors.
  Map<String, String> _rgbColors;

  /// Represents the drawing count in the workbook.
  int drawingCount = 0;

  /// Represents the image count in the workbook.
  int imageCount = 0;

  /// Represents the chart count in the workbook.
  int chartCount = 0;

  /// Indicates whether the workbook is saving.
  bool _saving = false;

  // Collection of workbook's formats.
  FormatsCollection _rawFormats;

  /// Indicates whether all the formula in the workbook is evaluated.
  bool enabledCalcEngine;

  /// Represents the culture info.
  CultureInfo _cultureInfo;

  final Map<String, String> _defaultContentTypes = <String, String>{};

  /// Represents the unit conversion list.
  List<double> _unitsProportions = [
    96 / 75.0, // Display
    96 / 300.0, // Document
    96, // Inch
    96 / 25.4, // Millimeter
    96 / 2.54, // Centimeter
    1, // Pixel
    96 / 72.0, // Point
    96 / 72.0 / 12700 // EMU
  ];

  /// Indicates whether the workbook is Parsed.
  // bool get isParsed {
  //   return _isParsing;
  // }

  // set isParsed(bool value) {
  //   _isParsing = value;
  // }

  /// Represents zip archive to save the workbook.
  Archive get archive {
    _archive ??= Archive();
    return _archive;
  }

  set archive(Archive value) {
    _archive = value;
  }

  /// Represents the shared string list.
  Map<String, int> get sharedStrings {
    return _sharedString;
  }

  // set sharedStrings(Map<String, int> value) {
  //   _sharedString = value;
  // }

  /// Represents the shared string count in the workbook.
  // int get sharedStringCount {
  //   return _sharedStringCount;
  // }

  // set sharedStringCount(int value) {
  //   _sharedStringCount = value;
  // }

  /// Gets dictionary with default content types.
  Map get defaultContentTypes {
    return _defaultContentTypes;
  }

  /// Represents the cell style collection in the workbok.
  Map<String, GlobalStyle> get globalStyles {
    _cellStyles ??= <String, GlobalStyle>{};
    return _cellStyles;
  }

  set globalStyles(Map<String, GlobalStyle> value) {
    _cellStyles = value;
  }

  /// Represents the merged cell collection in the workbok.
  Map<String, ExtendStyle> get mergedCellsStyle {
    _mergedCellsStyle ??= <String, ExtendStyle>{};
    return _mergedCellsStyle;
  }

  set mergedCellsStyle(Map<String, ExtendStyle> value) {
    _mergedCellsStyle = value;
  }

  /// Represents the worksheet collection.
  WorksheetCollection get worksheets {
    _worksheets ??= WorksheetCollection(this);
    return _worksheets;
  }

  /// Represents the build in properties.
  BuiltInProperties get builtInProperties {
    _builtInProperties ??= BuiltInProperties();
    return _builtInProperties;
  }

  set builtInProperties(BuiltInProperties value) {
    _builtInProperties = value;
  }

  // /// Represents the border collection in the workbook.
  // List<Borders> get borders {
  //   return _borders;
  // }

  // set borders(List<Borders> value) {
  //   _borders = value;
  // }

  // /// Represents the Fill collection in the workbook.
  // Map<String, int> get fills {
  //   return _fills;
  // }

  // set fills(Map<String, int> value) {
  //   _fills = value;
  // }

  /// Represents the cell style collection in the workbook.
  StylesCollection get styles {
    _styles ??= StylesCollection(this);
    return _styles;
  }

  // /// Represents the CellXf collection in the workbook.
  // List<CellXfs> get cellXfs {
  //   return _cellXfs;
  // }

  // set cellXfs(List<CellXfs> value) {
  //   _cellXfs = value;
  // }

  // /// Represents the CellStyleXf collection in the workbook.
  // List<CellStyleXfs> get cellStyleXfs {
  //   return _cellStyleXfs;
  // }

  // set cellStyleXfs(List<CellStyleXfs> value) {
  //   _cellStyleXfs = value;
  // }

  /// Represents the unit conversion list.
  List<double> get unitProportions {
    return _unitsProportions;
  }

  /// Represents the print title collection.
  // Map<int, String> get printTitles {
  //   return _printTitles;
  // }

  // set printTitles(Map<int, String> value) {
  //   _printTitles = value;
  // }

  // /// Represents the current culture.
  // String get culture {
  //   return _culture;
  // }

  // set culture(String value) {
  //   _culture = value;
  // }

  // /// Represents the current culture currency.
  // String get currency {
  //   return _currency;
  // }

  // set currency(String value) {
  //   _currency = value;
  // }

  /// Represents the current culture info.
  CultureInfo get cultureInfo {
    return _cultureInfo;
  }

  /// Represents the formats collection.
  FormatsCollection get innerFormats {
    return _rawFormats;
  }

  /// Initialize the workbook.
  void initializeWorkbook(
      String givenCulture, String givenCurrency, int count) {
    if (givenCulture != null) {
      culture = givenCulture;
    } else {
      culture = 'en-US';
    }
    if (givenCurrency != null) {
      currency = givenCurrency;
    } else {
      currency = 'USD';
    }
    _cultureInfo = CultureInfo(culture);
    _initialize();
    if (count != null) {
      _worksheets = WorksheetCollection(this, count);
    } else {
      _worksheets = WorksheetCollection(this, 1);
    }
  }

  void _initialize() {
    _sharedString = <String, int>{};
    fonts = [];
    borders = [];
    _styles = StylesCollection(this);
    _rawFormats = FormatsCollection(this);
    _rawFormats.insertDefaultFormats();
    fills = <String, int>{};
    _styles.addStyle(CellStyle(this));
    fonts.add(Font());
    cellXfs = [];
    cellStyleXfs = [];
    drawingCount = 0;
    imageCount = 0;
  }

  /// Saves workbook with the specified file name.
  void save(String fileName) {
    if (fileName == null || fileName == '') {
      throw Exception('fileName should not be null or empty');
    }
    _saving = true;
    final SerializeWorkbook serializer = SerializeWorkbook(this);
    serializer.saveInternal();
    final bytes = ZipEncoder().encode(archive);

    File(fileName).writeAsBytes(bytes);
    _saving = false;
  }

  /// Saves workbook as stream.
  List<int> saveStream() {
    _saving = true;
    final SerializeWorkbook serializer = SerializeWorkbook(this);
    serializer.saveInternal();
    final bytes = ZipEncoder().encode(archive);

    _saving = false;
    return bytes;
  }

  /// Check whether the cell style font already exists.
  ExtendCompareStyle _isNewFont(CellStyle toCompareStyle) {
    bool result = false;
    int index = 0;
    for (final Font font in fonts) {
      index++;
      String fontColor = '';
      if (toCompareStyle.fontColor != null) {
        fontColor = ('FF' + toCompareStyle.fontColor.replaceAll('#', ''));
      }
      result = font.color == fontColor &&
          font.bold == toCompareStyle.bold &&
          font.italic == toCompareStyle.italic &&
          font.underline == toCompareStyle.underline &&
          font.name == toCompareStyle.fontName &&
          font.size == toCompareStyle.fontSize;
      if (result) {
        break;
      }
    }
    index -= 1;
    final ExtendCompareStyle style = ExtendCompareStyle();
    style.index = index;
    style.result = result;
    return style;
  }

  /// Check whether the cell border already exists.
  static bool _isNewBorder(CellStyle toCompareStyle) {
    final CellStyle bStyle = CellStyle(toCompareStyle.workbook);
    if (_isAllBorder(toCompareStyle.borders)) {
      return (bStyle.borders.all.color == toCompareStyle.borders.all.color &&
          bStyle.borders.all.lineStyle == toCompareStyle.borders.all.lineStyle);
    } else {
      return (bStyle.borders.left.color == toCompareStyle.borders.left.color &&
          bStyle.borders.left.lineStyle ==
              toCompareStyle.borders.left.lineStyle &&
          bStyle.borders.right.color == toCompareStyle.borders.right.color &&
          bStyle.borders.right.lineStyle ==
              toCompareStyle.borders.right.lineStyle &&
          bStyle.borders.top.color == toCompareStyle.borders.top.color &&
          bStyle.borders.top.lineStyle ==
              toCompareStyle.borders.top.lineStyle &&
          bStyle.borders.bottom.color == toCompareStyle.borders.bottom.color &&
          bStyle.borders.bottom.lineStyle ==
              toCompareStyle.borders.bottom.lineStyle);
    }
  }

  /// Check if line style and color is applied for all borders.
  static bool _isAllBorder(Borders toCompareBorder) {
    final CellStyle allBorderStyle = CellStyle(toCompareBorder.workbook);
    return allBorderStyle.borders.all.color != toCompareBorder.all.color ||
        allBorderStyle.borders.all.lineStyle != toCompareBorder.all.lineStyle;
  }

  /// Gets the culture info.
  CultureInfo getCultureInfo() {
    return _cultureInfo;
  }

  /// Dispose  objects.
  void dispose() {
    if (_archive != null) {
      _archive.files.clear();
      _archive = null;
    }

    if (_worksheets != null) {
      _worksheets.clear();
      _worksheets = null;
    }

    if (_sharedString != null) {
      _sharedString.clear();
      _sharedString = null;
    }

    if (_cellStyles != null) {
      _cellStyles.clear();
      _cellStyles = null;
    }

    if (_mergedCellsStyle != null) {
      _mergedCellsStyle.clear();
      _mergedCellsStyle = null;
    }

    if (fonts != null) {
      fonts.clear();
      fonts = null;
    }

    if (borders != null) {
      borders.clear();
      borders = null;
    }

    if (fills != null) {
      fills.clear();
      fills = null;
    }

    if (_styles != null) {
      _styles.clear();
      _styles = null;
    }

    if (cellXfs != null) {
      cellXfs.clear();
      cellXfs = null;
    }

    if (_rawFormats != null) {
      _rawFormats.clear();
      _rawFormats = null;
    }

    if (cellStyleXfs != null) {
      cellStyleXfs.clear();
      cellStyleXfs = null;
    }

    if (_printTitles != null) {
      _printTitles.clear();
      _printTitles = null;
    }

    if (_rgbColors != null) {
      _rgbColors.clear();
      _rgbColors = null;
    }

    if (_unitsProportions != null) {
      _unitsProportions.clear();
      _unitsProportions = null;
    }
  }
}
