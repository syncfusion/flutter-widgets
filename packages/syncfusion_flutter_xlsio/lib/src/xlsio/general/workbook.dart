part of xlsio;

/// Represents an Excel Workbook.
class Workbook {
  /// Creates an new instances of the Workbook.
  Workbook([int count]) {
    _initializeWorkbook(null, null, count);
  }

  /// Creates an new instances of the Workbook with currency.
  Workbook.withCulture(String culture, [String currency, int count]) {
    if (count != null) {
      _initializeWorkbook(culture, currency, count);
    } else {
      _initializeWorkbook(culture, currency, 1);
    }
  }

  /// Represents zip archive to save the workbook.
  Archive _archives;

  /// Represents the shared string dictionary.
  Map<String, int> _sharedString;

  /// Represents the shared string count in the workbook.
  int _sharedStringCount = 0;

  /// Represents the maximum row count in the workbook.
  final int _maxRowCount = 1048576;

  /// Represents the maximum column count in the workbook.
  final int _maxColumnCount = 16384;

  /// Represents the cell style collection in the workbok.
  Map<String, _GlobalStyle> _cellStyles;

  /// Represents the merged cell collection in the workbok.
  Map<String, _ExtendStyle> _mergedCellsStyles;

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
  List<CellXfs> _cellXfs;

  /// Represents the CellStyleXf collection in the workbook.
  List<CellStyleXfs> _cellStyleXfs;

  /// Represents the print title collection.
  Map<int, String> _printTitles;

  /// Represents the current culture.
  String _culture;

  /// Represents the current culture currency.
  // ignore: unused_field
  String _currency;

  /// Represents the RGB colors.
  Map<String, String> _rgbColors;

  /// Represents the drawing count in the workbook.
  int _drawingCount = 0;

  /// Represents the image count in the workbook.
  int _imageCount = 0;

  /// Represents the chart count in the workbook.
  int chartCount = 0;

  /// Indicates whether the workbook is saving.
  bool _saving = false;

  // Collection of workbook's formats.
  FormatsCollection _rawFormats;

  /// Indicates whether all the formula in the workbook is evaluated.
  // ignore: unused_field
  bool _enabledCalcEngine;

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

  /// Represents zip archive to save the workbook.
  Archive get archive {
    _archives ??= Archive();
    return _archives;
  }

  set archive(Archive value) {
    _archives = value;
  }

  /// Represents the shared string list.
  Map<String, int> get _sharedStrings {
    return _sharedString;
  }

  /// Gets dictionary with default content types.
  Map get _defaultContentType {
    return _defaultContentTypes;
  }

  /// Represents the cell style collection in the workbok.
  Map<String, _GlobalStyle> get _globalStyles {
    _cellStyles ??= <String, _GlobalStyle>{};
    return _cellStyles;
  }

  /// Represents the merged cell collection in the workbok.
  Map<String, _ExtendStyle> get _mergedCellsStyle {
    _mergedCellsStyles ??= <String, _ExtendStyle>{};
    return _mergedCellsStyles;
  }

  set _mergedCellsStyle(Map<String, _ExtendStyle> value) {
    _mergedCellsStyles = value;
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

  /// Represents the cell style collection in the workbook.
  StylesCollection get styles {
    _styles ??= StylesCollection(this);
    return _styles;
  }

  /// Represents the unit conversion list.
  List<double> get _unitProportions {
    return _unitsProportions;
  }

  /// Represents the current culture info.
  CultureInfo get cultureInfo {
    return _cultureInfo;
  }

  /// Represents the formats collection.
  FormatsCollection get innerFormats {
    return _rawFormats;
  }

  /// Initialize the workbook.
  void _initializeWorkbook(
      String givenCulture, String givenCurrency, int count) {
    if (givenCulture != null) {
      _culture = givenCulture;
    } else {
      _culture = 'en-US';
    }
    if (givenCurrency != null) {
      _currency = givenCurrency;
    } else {
      _currency = 'USD';
    }
    _cultureInfo = CultureInfo(_culture);
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
    _rawFormats._insertDefaultFormats();
    fills = <String, int>{};
    _styles.addStyle(CellStyle(this));
    fonts.add(Font());
    _cellXfs = [];
    _cellStyleXfs = [];
    _drawingCount = 0;
    _imageCount = 0;
    _sharedStringCount = 0;
    chartCount = 0;
  }

  /// Saves workbook with the specified file name.
  void save(String fileName) {
    if (fileName == null || fileName == '') {
      throw Exception('fileName should not be null or empty');
    }
    _saving = true;
    final SerializeWorkbook serializer = SerializeWorkbook(this);
    serializer._saveInternal();
    final bytes = ZipEncoder().encode(archive);

    File(fileName).writeAsBytes(bytes);
    _saving = false;
  }

  /// Saves workbook as stream.
  List<int> saveStream() {
    _saving = true;
    final SerializeWorkbook serializer = SerializeWorkbook(this);
    serializer._saveInternal();
    final bytes = ZipEncoder().encode(archive);

    _saving = false;
    return bytes;
  }

  /// Check whether the cell style font already exists.
  _ExtendCompareStyle _isNewFont(CellStyle toCompareStyle) {
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
    final _ExtendCompareStyle style = _ExtendCompareStyle();
    style._index = index;
    style._result = result;
    return style;
  }

  /// Check whether the cell border already exists.
  static bool _isNewBorder(CellStyle toCompareStyle) {
    final CellStyle bStyle = CellStyle(toCompareStyle._workbook);
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
    final CellStyle allBorderStyle = CellStyle(toCompareBorder._workbook);
    return allBorderStyle.borders.all.color != toCompareBorder.all.color ||
        allBorderStyle.borders.all.lineStyle != toCompareBorder.all.lineStyle;
  }

  /// Gets the culture info.
  CultureInfo _getCultureInfo() {
    return _cultureInfo;
  }

  /// Dispose  objects.
  void dispose() {
    if (_archives != null) {
      _archives.files.clear();
      _archives = null;
    }

    if (_worksheets != null) {
      _worksheets._clear();
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
      _styles._clear();
      _styles = null;
    }

    if (_cellXfs != null) {
      _cellXfs.clear();
      _cellXfs = null;
    }

    if (_rawFormats != null) {
      _rawFormats._clear();
      _rawFormats = null;
    }

    if (_cellStyleXfs != null) {
      _cellStyleXfs.clear();
      _cellStyleXfs = null;
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
