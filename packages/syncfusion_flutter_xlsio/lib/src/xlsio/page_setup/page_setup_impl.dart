part of xlsio;

/// Represents implementations of pagesetup in a worksheet.
class _PageSetupImpl implements PageSetup {
  /// Create a instances of tables collection.
  _PageSetupImpl(Worksheet sheet) {
    _sheet = sheet;
    _showGridlines = false;
    _isFitToPage = false;
    _showHeadings = false;
    _isCenterHorizontally = false;
    _isCenterVertically = false;
    _isBlackAndWhite = false;
    _autoFirstPageNumber = true;
    _isDraft = false;
    _firstPageNumber = 1;
    _printArea = '';
    _printQuality = 600;
    _printTitleRows = '';
    _isprintTitleRows = false;
    _printTitleColumns = '';
    _isprintTitleColumns = false;
    _fitToPagesTall = _fitToPagesWide = 0;
    _leftMargin = _rightMargin = 0.75;
    _bottomMargin = _topMargin = 1;
    _footerMargin = _headerMargin = 0.5;
    _orientation = ExcelPageOrientation.portrait;
    _order = ExcelPageOrder.downThenOver;
    _printErrors = CellErrorPrintOptions.displayed;
    _paperSize = ExcelPaperSize.paperA4;
    _paperHight = <ExcelPaperSize, double>{
      ExcelPaperSize.a2Paper: _convertUnits(594, 'MMtoInch'),
      ExcelPaperSize.paperDsheet: 34,
      ExcelPaperSize.paperEnvelope10: 9.5,
      ExcelPaperSize.paperEnvelope11: 10.375,
      ExcelPaperSize.paperEnvelope12: 11,
      ExcelPaperSize.paperEnvelope14: 11.5,
      ExcelPaperSize.paperEnvelope9: 8.875,
      ExcelPaperSize.paperEnvelopeB4: _convertUnits(353, 'MMtoInch'),
      ExcelPaperSize.paperEnvelopeB5: _convertUnits(250, 'MMtoInch'),
      ExcelPaperSize.paperEnvelopeB6: _convertUnits(125, 'MMtoInch'),
      ExcelPaperSize.paperEnvelopeC3: _convertUnits(458, 'MMtoInch'),
      ExcelPaperSize.paperEnvelopeC4: _convertUnits(324, 'MMtoInch'),
      ExcelPaperSize.paperEnvelopeC5: _convertUnits(269, 'MMtoInch'),
      ExcelPaperSize.paperEnvelopeC6: _convertUnits(122, 'MMtoInch'),
      ExcelPaperSize.paperEnvelopeC65: _convertUnits(229, 'MMtoInch'),
      ExcelPaperSize.paperEnvelopeDL: _convertUnits(220, 'MMtoInch'),
      ExcelPaperSize.paperEnvelopeItaly: _convertUnits(230, 'MMtoInch'),
      ExcelPaperSize.paperEnvelopeMonarch: 7.5,
      ExcelPaperSize.paperEnvelopePersonal: 6.5,
      ExcelPaperSize.paperEsheet: 34,
      ExcelPaperSize.paperExecutive: 7.5,
      ExcelPaperSize.paperFanfoldLegalGerman: 13,
      ExcelPaperSize.paperFanfoldStdGerman: 12,
      ExcelPaperSize.paperFanfoldUS: 11,
      ExcelPaperSize.paperFolio: 13,
      ExcelPaperSize.paperLedger: 11,
      ExcelPaperSize.paperLegal: 14,
      ExcelPaperSize.paperLetter: 11,
      ExcelPaperSize.paperLetterSmall: 11,
      ExcelPaperSize.paperNote: 11,
      ExcelPaperSize.paperQuarto: 275,
      ExcelPaperSize.paperStatement: 8.5,
      ExcelPaperSize.paperTabloid: 17,
      ExcelPaperSize.standardPaper9By11: 11,
      ExcelPaperSize.standardPaper10By11: 11,
      ExcelPaperSize.standardPaper15By11: 11,
      ExcelPaperSize.tabloidExtraPaper: 18,
      ExcelPaperSize.superASuperAA4Paper: _convertUnits(356, 'MMtoInch'),
      ExcelPaperSize.superBSuperBA3Paper: _convertUnits(487, 'MMtoInch'),
      ExcelPaperSize.paper10x14: 14,
      ExcelPaperSize.paper11x17: 17,
      ExcelPaperSize.paperA3: _convertUnits(420, 'MMtoInch'),
      ExcelPaperSize.paperA4: _convertUnits(297, 'MMtoInch'),
      ExcelPaperSize.paperA4Small: _convertUnits(297, 'MMtoInch'),
      ExcelPaperSize.paperA5: _convertUnits(210, 'MMtoInch'),
      ExcelPaperSize.paperB4: _convertUnits(353, 'MMtoInch'),
      ExcelPaperSize.paperB5: _convertUnits(250, 'MMtoInch'),
      ExcelPaperSize.paperCsheet: 22,
      ExcelPaperSize.iSOB4: _convertUnits(353, 'MMtoInch'),
      ExcelPaperSize.japaneseDoublePostcard: _convertUnits(148, 'MMtoInch'),
      ExcelPaperSize.inviteEnvelope: _convertUnits(220, 'MMtoInch'),
      ExcelPaperSize.letterExtraPaper9275By12: 12,
      ExcelPaperSize.legalExtraPaper9275By15: 15,
      ExcelPaperSize.a4ExtraPaper: _convertUnits(332, 'MMtoInch'),
      ExcelPaperSize.letterTransversePaper: 11,
      ExcelPaperSize.a4TransversePaper: _convertUnits(297, 'MMtoInch'),
      ExcelPaperSize.letterExtraTransversePaper: 12,
      ExcelPaperSize.letterPlusPaper: 12.69,
      ExcelPaperSize.a4PlusPaper: _convertUnits(330, 'MMtoInch'),
      ExcelPaperSize.a5TransversePaper: _convertUnits(210, 'MMtoInch'),
      ExcelPaperSize.jISB5TransversePaper: _convertUnits(257, 'MMtoInch'),
      ExcelPaperSize.a3ExtraPaper: _convertUnits(445, 'MMtoInch'),
      ExcelPaperSize.a5ExtraPpaper: _convertUnits(235, 'MMtoInch'),
      ExcelPaperSize.iSOB5ExtraPaper: _convertUnits(276, 'MMtoInch'),
      ExcelPaperSize.a3TransversePaper: _convertUnits(297, 'MMtoInch'),
      ExcelPaperSize.a3ExtraTransversePaper: _convertUnits(445, 'MMtoInch')
    };
    _paperWidth = <ExcelPaperSize, double>{
      ExcelPaperSize.a2Paper: _convertUnits(420, 'MMtoInch'),
      ExcelPaperSize.paperDsheet: 22,
      ExcelPaperSize.paperEnvelope10: 4.125,
      ExcelPaperSize.paperEnvelope11: 4.5,
      ExcelPaperSize.paperEnvelope12: 4.75,
      ExcelPaperSize.paperEnvelope14: 5,
      ExcelPaperSize.paperEnvelope9: 3.875,
      ExcelPaperSize.paperEnvelopeB4: _convertUnits(250, 'MMtoInch'),
      ExcelPaperSize.paperEnvelopeB5: _convertUnits(176, 'MMtoInch'),
      ExcelPaperSize.paperEnvelopeB6: _convertUnits(176, 'MMtoInch'),
      ExcelPaperSize.paperEnvelopeC3: _convertUnits(324, 'MMtoInch'),
      ExcelPaperSize.paperEnvelopeC4: _convertUnits(229, 'MMtoInch'),
      ExcelPaperSize.paperEnvelopeC5: _convertUnits(162, 'MMtoInch'),
      ExcelPaperSize.paperEnvelopeC6: _convertUnits(144, 'MMtoInch'),
      ExcelPaperSize.paperEnvelopeC65: _convertUnits(144, 'MMtoInch'),
      ExcelPaperSize.paperEnvelopeDL: _convertUnits(110, 'MMtoInch'),
      ExcelPaperSize.paperEnvelopeItaly: _convertUnits(110, 'MMtoInch'),
      ExcelPaperSize.paperEnvelopeMonarch: 3.675,
      ExcelPaperSize.paperEnvelopePersonal: 3.265,
      ExcelPaperSize.paperEsheet: 34,
      ExcelPaperSize.paperExecutive: 7.5,
      ExcelPaperSize.paperFanfoldLegalGerman: 8.5,
      ExcelPaperSize.paperFanfoldStdGerman: 8.5,
      ExcelPaperSize.paperFanfoldUS: 14.875,
      ExcelPaperSize.paperFolio: 8.5,
      ExcelPaperSize.paperLedger: 17,
      ExcelPaperSize.paperLegal: 8.5,
      ExcelPaperSize.paperLetter: 8.5,
      ExcelPaperSize.paperLetterSmall: 8.5,
      ExcelPaperSize.paperNote: 8.5,
      ExcelPaperSize.paperQuarto: 215,
      ExcelPaperSize.paperStatement: 5.5,
      ExcelPaperSize.paperTabloid: 11,
      ExcelPaperSize.standardPaper9By11: 10,
      ExcelPaperSize.standardPaper10By11: 15,
      ExcelPaperSize.standardPaper15By11: 9,
      ExcelPaperSize.tabloidExtraPaper: 11.69,
      ExcelPaperSize.superASuperAA4Paper: _convertUnits(227, 'MMtoInch'),
      ExcelPaperSize.superBSuperBA3Paper: _convertUnits(305, 'MMtoInch'),
      ExcelPaperSize.paper10x14: 10,
      ExcelPaperSize.paper11x17: 11,
      ExcelPaperSize.paperA3: _convertUnits(297, 'MMtoInch'),
      ExcelPaperSize.paperA4: _convertUnits(210, 'MMtoInch'),
      ExcelPaperSize.paperA4Small: _convertUnits(210, 'MMtoInch'),
      ExcelPaperSize.paperA5: _convertUnits(148, 'MMtoInch'),
      ExcelPaperSize.paperB4: _convertUnits(250, 'MMtoInch'),
      ExcelPaperSize.paperB5: _convertUnits(176, 'MMtoInch'),
      ExcelPaperSize.paperCsheet: 17,
      ExcelPaperSize.iSOB4: _convertUnits(250, 'MMtoInch'),
      ExcelPaperSize.japaneseDoublePostcard: _convertUnits(200, 'MMtoInch'),
      ExcelPaperSize.inviteEnvelope: _convertUnits(220, 'MMtoInch'),
      ExcelPaperSize.letterExtraPaper9275By12: 9.275,
      ExcelPaperSize.legalExtraPaper9275By15: 9.275,
      ExcelPaperSize.a4ExtraPaper: _convertUnits(236, 'MMtoInch'),
      ExcelPaperSize.letterTransversePaper: 8.275,
      ExcelPaperSize.a4TransversePaper: _convertUnits(210, 'MMtoInch'),
      ExcelPaperSize.letterExtraTransversePaper: 9.275,
      ExcelPaperSize.letterPlusPaper: 8.5,
      ExcelPaperSize.a4PlusPaper: _convertUnits(210, 'MMtoInch'),
      ExcelPaperSize.a5TransversePaper: _convertUnits(148, 'MMtoInch'),
      ExcelPaperSize.jISB5TransversePaper: _convertUnits(188, 'MMtoInch'),
      ExcelPaperSize.a3ExtraPaper: _convertUnits(322, 'MMtoInch'),
      ExcelPaperSize.a5ExtraPpaper: _convertUnits(174, 'MMtoInch'),
      ExcelPaperSize.iSOB5ExtraPaper: _convertUnits(210, 'MMtoInch'),
      ExcelPaperSize.a3TransversePaper: _convertUnits(420, 'MMtoInch'),
      ExcelPaperSize.a3ExtraTransversePaper: _convertUnits(322, 'MMtoInch')
    };
  }

  // Worksheet
  late Worksheet _sheet;

  /// Indicates whether to print the gridlines in the worksheet.
  late bool _showGridlines;

  /// Indcates whether the fit to page is selected.
  late bool _isFitToPage;

  /// Indicates whether to print row and column heading in the worksheet.
  late bool _showHeadings;

  /// Indicates whether to center the sheet content horizontally when it is printed.
  late bool _isCenterHorizontally;

  /// Indicates whether to center the sheet content vertically when it is printed.
  late bool _isCenterVertically;

  /// Indicates whether to print the worksheet as black and white.
  late bool _isBlackAndWhite;

  /// Indicates whether to use auto first page number.
  late bool _autoFirstPageNumber;

  /// Indicates whether to print the worksheet as draft without graphics.
  late bool _isDraft;

  /// Represents the print quality, in dpi.
  late int _printQuality;

  /// Represents the height of the pages that the worksheet will be scaled.
  late int _fitToPagesTall;

  /// Represents the width of the pages the worksheet will be scaled.
  late int _fitToPagesWide;

  /// Represents the size of the left margin, in inches.
  late double _leftMargin;

  /// Represents the size of the bottom margin, in inches
  late double _bottomMargin;

  /// Represents the size of the footer margin, in inches
  late double _footerMargin;

  /// Represents the size of the header margin, in inches
  late double _headerMargin;

  /// Represents the size of the right margin, in inches
  late double _rightMargin;

  /// Represents the size of the top margin, in inches
  late double _topMargin;

  /// Represents the printing orientation of the worksheet.
  late ExcelPageOrientation _orientation;

  /// Represents the order in which the worksheet to be printed.
  late ExcelPageOrder _order;

  /// Represents the paper size for the worksheet.
  late ExcelPaperSize _paperSize;

  /// Represents the values to be printed insead of cell errors in the worksheet.
  late CellErrorPrintOptions _printErrors;

  /// Represents the first page number to be used.
  late int _firstPageNumber;

  /// Represents the columns to be repeated at each page.
  late String _printTitleColumns;

  /// Is print area applied
  late bool _isprintTitleColumns;

  /// Represents the rows to be repeated at each page.
  late String _printTitleRows;

  /// Is print area applied
  late bool _isprintTitleRows;

  /// Represents the range to be printed.
  late String _printArea;

  /// Map which stores Max paper hight
  late Map<ExcelPaperSize, double> _paperHight;

  /// Map which stores Max paper width
  late Map<ExcelPaperSize, double> _paperWidth;

  @override
  bool get isBlackAndWhite {
    return _isBlackAndWhite;
  }

  @override
  set isBlackAndWhite(bool value) {
    _isBlackAndWhite = value;
  }

  @override
  double get bottomMargin {
    return _bottomMargin;
  }

  @override
  set bottomMargin(double value) {
    _bottomMargin = value;
  }

  @override
  bool get isCenterHorizontally {
    return _isCenterHorizontally;
  }

  @override
  set isCenterHorizontally(bool value) {
    _isCenterHorizontally = value;
  }

  @override
  bool get isCenterVertically {
    return _isCenterVertically;
  }

  @override
  set isCenterVertically(bool value) {
    _isCenterVertically = value;
  }

  @override
  bool get isDraft {
    return _isDraft;
  }

  @override
  set isDraft(bool value) {
    _isDraft = value;
  }

  @override
  int get firstPageNumber {
    return _firstPageNumber;
  }

  @override
  set firstPageNumber(int value) {
    if (value > -32766 && value <= 32767) {
      _autoFirstPageNumber = false;
      _firstPageNumber = value;
    }
  }

  @override
  int get fitToPagesTall {
    return _fitToPagesTall;
  }

  @override
  set fitToPagesTall(int value) {
    if (value > 0 && value <= 32767) {
      _isFitToPage = true;
      _fitToPagesTall = value;
    } else {
      _isFitToPage = true;
      _fitToPagesTall = 1;
    }
  }

  @override
  int get fitToPagesWide {
    return _fitToPagesWide;
  }

  @override
  set fitToPagesWide(int value) {
    if (value > 0 && value <= 32767) {
      _isFitToPage = true;
      _fitToPagesWide = value;
    } else {
      _isFitToPage = true;
      _fitToPagesWide = 1;
    }
  }

  @override
  double get footerMargin {
    return _footerMargin;
  }

  @override
  set footerMargin(double value) {
    _footerMargin = value;
  }

  @override
  double get headerMargin {
    return _headerMargin;
  }

  @override
  set headerMargin(double value) {
    _headerMargin = value;
  }

  @override
  bool get isFitToPage {
    return _isFitToPage;
  }

  @override
  set isFitToPage(bool value) {
    _isFitToPage = value;
  }

  @override
  bool get showGridlines {
    return _showGridlines;
  }

  @override
  set showGridlines(bool value) {
    _showGridlines = value;
  }

  @override
  double get leftMargin {
    return _leftMargin;
  }

  @override
  set leftMargin(double value) {
    _leftMargin = value;
  }

  @override
  ExcelPageOrder get order {
    return _order;
  }

  @override
  set order(ExcelPageOrder value) {
    _order = value;
  }

  @override
  ExcelPageOrientation get orientation {
    return _orientation;
  }

  @override
  set orientation(ExcelPageOrientation value) {
    _orientation = value;
  }

  @override
  ExcelPaperSize get paperSize {
    return _paperSize;
  }

  @override
  set paperSize(ExcelPaperSize value) {
    _paperSize = value;
  }

  @override
  String get printArea {
    return _printArea;
  }

  @override
  set printArea(String value) {
    value = '${_sheet.name}!$value';
    final _NameImpl nameImpl = _NameImpl(_sheet.workbook);
    nameImpl.name = '_xlnm.Print_Area';
    nameImpl._isLocal = true;
    nameImpl._worksheet = _sheet;
    nameImpl._scope = _sheet._name;
    nameImpl._value = value;
    _sheet.workbook.innerNamesCollection.add(nameImpl);
    _printArea = value;
  }

  @override
  CellErrorPrintOptions get printErrors {
    return _printErrors;
  }

  @override
  set printErrors(CellErrorPrintOptions value) {
    _printErrors = value;
  }

  @override
  bool get showHeadings {
    return _showHeadings;
  }

  @override
  set showHeadings(bool value) {
    _showHeadings = value;
  }

  @override
  bool get autoFirstPageNumber {
    return _autoFirstPageNumber;
  }

  @override
  set autoFirstPageNumber(bool value) {
    _autoFirstPageNumber = value;
  }

  @override
  int get printQuality {
    return _printQuality;
  }

  @override
  set printQuality(int value) {
    _printQuality = value;
  }

  @override
  String get printTitleColumns {
    return _printTitleColumns;
  }

  @override
  set printTitleColumns(String value) {
    _isprintTitleColumns = true;
    value = _convertToRangeName(value);
    final _NameImpl nameImpl = _NameImpl(_sheet.workbook);
    nameImpl.name = '_xlnm.Print_Titles';
    nameImpl._isLocal = true;
    nameImpl._worksheet = _sheet;
    nameImpl._scope = _sheet._name;
    nameImpl._value = value;
    _sheet.workbook.innerNamesCollection.add(nameImpl);
    _printTitleColumns = value;
  }

  @override
  String get printTitleRows {
    return _printTitleRows;
  }

  @override
  set printTitleRows(String value) {
    _isprintTitleRows = true;
    value = _convertToRangeName(value);
    final _NameImpl nameImpl = _NameImpl(_sheet.workbook);
    nameImpl.name = '_xlnm.Print_Titles';
    nameImpl._isLocal = true;
    nameImpl._worksheet = _sheet;
    nameImpl._scope = _sheet._name;
    nameImpl._value = value;
    _sheet.workbook.innerNamesCollection.add(nameImpl);
    _printTitleRows = value;
  }

  @override
  double get rightMargin {
    return _rightMargin;
  }

  @override
  set rightMargin(double value) {
    _rightMargin = value;
  }

  @override
  double get topMargin {
    return _topMargin;
  }

  @override
  set topMargin(double value) {
    _topMargin = value;
  }

  /// Converts cell range to Range name.
  String _convertToRangeName(String input) {
    final RegExp exp = RegExp(
        r'(?<Column1>[\$]?[A-Za-z]{1,3})(?<Row1>[\$]?\d+):(?<Column2>[\$]?[A-Za-z]{1,3})(?<Row2>[\$]?\d+)');
    final RegExpMatch? output = exp.firstMatch(input);
    final String column1 = output![1].toString();
    final String row1 = output[2].toString();
    final String column2 = output[3].toString();
    final String row2 = output[4].toString();
    if (_isprintTitleRows) {
      return '${_sheet.name}!$row1:$row2';
    } else if (_isprintTitleColumns) {
      return '${_sheet.name}!$column1:$column2';
    }
    return '';
  }

  double _convertUnits(double value, String convertion) {
    late double result;
    switch (convertion) {
      case 'MMtoInch':
        result = value * 3.7795275590551185 / 96;
        break;
      case 'InchtoMM':
        result = value * 96 / 3.7795275590551185;
        break;
    }
    return result;
  }
}
