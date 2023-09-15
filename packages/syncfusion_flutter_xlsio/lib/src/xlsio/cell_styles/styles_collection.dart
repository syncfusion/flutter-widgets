part of xlsio;

/// Represents styles collection.
class StylesCollection {
  /// Create an instance of Worksheets
  StylesCollection(Workbook workbook) {
    _book = workbook;
    _dictStyles = <String, CellStyle>{};
    _styles = <Style>[];
  }

  /// Parent workbook
  late Workbook _book;

  /// Collection of worksheet
  late List<Style> _styles;

  /// Collection of all the styles in the workbook.
  late Map<String, Style> _dictStyles;

  /// Represents parent workbook
  Workbook get workbook {
    return _book;
  }

  /// Collection of worksheet
  List<Style> get innerList {
    return _styles;
  }

  /// Returns the count of pivot reference collection.
  int get count {
    return _dictStyles.length;
  }

  /// Dictionary. Key - Culture, value - Number Format.
  final Map<String, String> _numberFormat = <String, String>{
    'en-US': r'_($* #,##0.00_)',
    'id-ID': r'_(Rp * #,##0.00_)',
    'en-GB': r'_(£* #,##0.00_)',
    'en-DE': r'_(#,##0.00_*€',
    'de-DE': r'_(#,##0.00_*€',
    'fr-FR': r'_(#,##0.00_*€',
    'nl-BE': r'_(€* #,##0.00_)',
    'pl-PL': r'_(#,##0.00_*zł',
    'pt-PT': r'_(#,##0.00_*€',
    'ru-RU': r'_(#,##0.00_*₽'
  };

  /// Dictionary. Key - Culture, value - Symbols.
  final Map<String, String> _symbols = <String, String>{
    'en-US': r'$',
    'id-ID': 'Rp',
    'en-GB': '£',
    'en-DE': '€',
    'de-DE': '€',
    'fr-FR': '€',
    'nl-BE': '€',
    'pl-PL': 'zł',
    'pt-PT': '€',
    'ru-RU': '₽'
  };

  /// Default styles names.
  final List<String> _defaultStyleNames = <String>[
    'normal',
    'rowLevel_',
    'colLevel_',
    'comma',
    'currency',
    'percent',
    'comma0',
    'currency0',
    'hyperlink',
    'followed Hyperlink',
    'note',
    'warningText',
    'emphasis 1',
    'emphasis 2',
    '',
    'title',
    'heading1',
    'heading2',
    'heading3',
    'heading4',
    'input',
    'output',
    'calculation',
    'checkCell',
    'linkedCell',
    'total',
    'good',
    'bad',
    'neutral',
    'accent1',
    'accent1_20',
    'accent1_40',
    'accent1_60',
    'accent2',
    'accent2_20',
    'accent2_40',
    'accent2_60',
    'accent3',
    'accent3_20',
    'accent3_40',
    'accent3_60',
    'accent4',
    'accent4_20',
    'accent4_40',
    'accent4_60',
    'accent5',
    'accent5_20',
    'accent5_40',
    'accent5_60',
    'accent6',
    'accent6_20',
    'accent6_40',
    'accent6_60',
    'explanatoryText',
  ];

  /// Indexer of the class
  Style? operator [](dynamic index) {
    if (index is String) {
      if (!_dictStyles.containsKey(index)) {
        throw Exception(
            'Style with specified name does not exist. Name: $index, value');
      }
      return _dictStyles[index];
    } else {
      return _styles[index];
    }
  }

  /// Add styles to the collection
  /// ```dart
  /// final Workbook workbook = Workbook();
  /// final Worksheet sheet = workbook.worksheets[0];
  /// // Creating Global cell style.
  /// final Style style = workbook.styles.add('style');
  /// style.backColor = '#37D8E9';
  /// style.fontName = 'Times  Roman';
  /// style.fontSize = 20;
  /// style.fontColor = '#C67878';
  /// style.italic = true;
  /// style.bold = true;
  /// style.underline = true;
  /// style.wrapText = true;
  /// style.hAlign = HAlignType.left;
  /// style.vAlign = VAlignType.bottom;
  /// style.rotation = 90;
  /// style.borders.all.lineStyle = LineStyle.thick;
  /// style.borders.all.color = '#9954CC';
  /// style.numberFormat = '_(\$* #,##0_)';
  /// final Range range1 = sheet.getRangeByIndex(3, 4);
  /// range1.number = 10;
  /// range1.cellStyle = style;
  /// final List<int> bytes = workbook.saveAsStream();
  /// File('CellStyle.xlsx').writeAsBytes(bytes);
  /// workbook.dispose();
  /// ```
  Style add(String styleName) {
    if (styleName == '') {
      throw Exception('name should not be empty');
    }

    if (_dictStyles.containsKey(styleName) &&
        !workbook.styles._defaultStyleNames.contains(styleName)) {
      throw Exception('Name of style must be unique.');
    }

    final Style style = CellStyle(_book, styleName);
    (style as CellStyle).isGlobalStyle = true;
    int index = 0;
    if (workbook.styles._defaultStyleNames.contains(style.name)) {
      _initializeStyleCollections(style.name, style);
      style._builtinId = workbook.styles._defaultStyleNames.indexOf(style.name);
    }
    index = workbook.styles._styles.length;
    style.index = index;
    _dictStyles[styleName] = style;
    _styles.add(style);
    return style;
  }

  /// Add styles to the collection
  /// ```dart
  /// final Workbook workbook = Workbook();
  /// final Worksheet sheet = workbook.worksheets[0];
  /// // Creating new style.
  /// final CellStyle cellStyle1 = CellStyle(workbook);
  /// cellStyle1.name = 'Style1';
  /// cellStyle1.backColor = '#FF5050';
  /// cellStyle1.fontName = 'Aldhabi';
  /// cellStyle1.fontColor = '#138939';
  /// cellStyle1.fontSize = 16;
  /// cellStyle1.bold = true;
  /// cellStyle1.italic = true;
  /// cellStyle1.underline = true;
  /// cellStyle1.rotation = 120;
  /// cellStyle1.hAlign = HAlignType.center;
  /// cellStyle1.vAlign = VAlignType.bottom;
  /// cellStyle1.indent = 1;
  /// cellStyle1.borders.all.lineStyle = LineStyle.double;
  /// cellStyle1.borders.all.color = '#FFFF66';
  /// cellStyle1.numberFormat = '#,##0.00';
  /// cellStyle1.wrapText = true;
  ///  // Add style to collections.
  /// workbook.styles.addStyle(cellStyle1);
  /// final Range range1 = sheet.getRangeByIndex(1, 1);
  /// range1.text = 'Hello';
  /// range1.cellStyle = cellStyle1;
  /// final List<int> bytes = workbook.saveAsStream();
  /// File('CellStyle.xlsx').writeAsBytes(bytes);
  /// workbook.dispose();
  /// ```
  void addStyle(CellStyle style) {
    int index = 0;
    index = workbook.styles._styles.length;
    style.index = index;
    _dictStyles[style.name] = style;
    _styles.add(style);
  }

  /// Method returns True if collection contains style with specified by user name.
  bool contains(String? styleName) {
    if (styleName == null) {
      throw Exception('name');
    }

    if (styleName.isEmpty) {
      throw Exception('name - string cannot be empty.');
    }

    return _dictStyles.containsKey(styleName);
  }

  /// Intialize the style collections.
  void _initializeStyleCollections(String styleName, CellStyle style) {
    switch (styleName) {
      case 'bad':
        style.backColor = '#FFC7CE';
        style.fontColor = '#9C0006';
        break;

      case 'good':
        style.backColor = '#C6EFCE';
        style.fontColor = '#006100';
        break;

      case 'neutral':
        style.backColor = '#FFEB9C';
        style.fontColor = '#9C6500';
        break;

      case 'accent1_20':
        style.backColor = '#D9E1F2';
        style.fontColor = '#000000';
        break;

      case 'accent1_40':
        style.backColor = '#B4C6E7';
        style.fontColor = '#000000';
        break;

      case 'accent1_60':
        style.backColor = '#8EA9DB';
        style.fontColor = '#000000';
        break;

      case 'accent1':
        style.backColor = '#4472C4';
        style.fontColor = '#FFFFFF';
        break;

      case 'accent2_20':
        style.backColor = '#FCE4D6';
        style.fontColor = '#000000';
        break;

      case 'accent2_40':
        style.backColor = '#F8CBAD';
        style.fontColor = '#000000';
        break;

      case 'accent2_60':
        style.backColor = '#F4B084';
        style.fontColor = '#000000';
        break;

      case 'accent2':
        style.backColor = '#ED7D31';
        style.fontColor = '#FFFFFF';
        break;

      case 'accent3_20':
        style.backColor = '#EDEDED';
        style.fontColor = '#000000';
        break;

      case 'accent3_40':
        style.backColor = '#DBDBDB';
        style.fontColor = '#000000';
        break;

      case 'accent3_60':
        style.backColor = '#C9C9C9';
        style.fontColor = '#000000';
        break;

      case 'accent3':
        style.backColor = '#A5A5A5';
        style.fontColor = '#FFFFFF';
        break;

      case 'accent4_20':
        style.backColor = '#FFF2CC';
        style.fontColor = '#000000';
        break;

      case 'accent4_40':
        style.backColor = '#FFE699';
        style.fontColor = '#000000';
        break;

      case 'accent4_60':
        style.backColor = '#FFD966';
        style.fontColor = '#000000';
        break;

      case 'accent4':
        style.backColor = '#FFC000';
        style.fontColor = '#FFFFFF';
        break;

      case 'accent5_20':
        style.backColor = '#DDEBF7';
        style.fontColor = '#000000';
        break;

      case 'accent5_40':
        style.backColor = '#BDD7EE';
        style.fontColor = '#000000';
        break;

      case 'accent5_60':
        style.backColor = '#9BC2E6';
        style.fontColor = '#000000';
        break;

      case 'accent5':
        style.backColor = '#5B9BD5';
        style.fontColor = '#FFFFFF';
        break;

      case 'accent6_20':
        style.backColor = '#E2EFDA';
        style.fontColor = '#000000';
        break;

      case 'accent6_40':
        style.backColor = '#C6E0B4';
        style.fontColor = '#000000';
        break;

      case 'accent6_60':
        style.backColor = '#A9D08E';
        style.fontColor = '#000000';
        break;

      case 'accent6':
        style.backColor = '#70AD47';
        style.fontColor = '#FFFFFF';
        break;

      case 'calculation':
        style.backColor = '#F2F2F2';
        style.fontColor = '#FA7D00';
        style.bold = true;
        style.borders.all.lineStyle = LineStyle.thin;
        style.borders.all.color = '#7F7F7F';
        break;

      case 'checkCell':
        style.backColor = '#A5A5A5';
        style.fontColor = '#FFFFFF';
        style.bold = true;
        style.borders.all.lineStyle = LineStyle.double;
        style.borders.all.color = '#3F3F3F';
        break;

      case 'explanatoryText':
        style.fontColor = '#7F7F7F';
        style.italic = true;
        break;

      case 'input':
        style.backColor = '#FFCC99';
        style.fontColor = '#3F3F76';
        style.borders.all.lineStyle = LineStyle.thin;
        style.borders.all.color = '#7F7F7F';
        break;

      case 'linkedCell':
        style.fontColor = '#FA7D00';
        style.borders.bottom.lineStyle = LineStyle.double;
        style.borders.bottom.color = '#FF8001';
        break;

      case 'note':
        style.backColor = '#FFFFCC';
        style.fontColor = '#000000';
        style.borders.all.lineStyle = LineStyle.thin;
        style.borders.all.color = '#B2B2B2';
        break;

      case 'warningText':
        style.fontColor = '#FF0000';
        break;

      case 'output':
        style.backColor = '#F2F2F2';
        style.fontColor = '#3F3F3F';
        style.borders.all.lineStyle = LineStyle.thin;
        style.borders.all.color = '#3F3F3F';
        break;

      case 'heading1':
        style.fontColor = '#44546A';
        style.fontSize = 15;
        style.bold = true;
        style.borders.bottom.lineStyle = LineStyle.thick;
        style.borders.bottom.color = '#4472C4';
        break;

      case 'heading2':
        style.fontColor = '#44546A';
        style.fontSize = 13;
        style.bold = true;
        style.borders.bottom.lineStyle = LineStyle.thick;
        style.borders.bottom.color = '#A2B8E1';
        break;

      case 'heading3':
        style.fontColor = '#44546A';
        style.fontSize = 11;
        style.bold = true;
        style.borders.bottom.lineStyle = LineStyle.medium;
        style.borders.bottom.color = '#8EA9DB';
        break;

      case 'heading4':
        style.fontColor = '#44546A';
        style.bold = true;
        break;

      case 'Title':
        style.fontName = 'Calibri Light';
        style.fontColor = '#44546A';
        style.fontSize = 18;
        break;

      case 'total':
        style.bold = true;
        style.borders.top.lineStyle = LineStyle.thin;
        style.borders.top.color = '#4472C4';
        style.borders.bottom.lineStyle = LineStyle.double;
        style.borders.bottom.color = '#4472C4';
        break;

      case 'comma':
        style.numberFormat = '_(* #,##0.00_)';
        break;

      case 'comma0':
        style.numberFormat = '_(* #,##0_)';
        break;

      case 'currency':
        final CultureInfo culture = _book.cultureInfo;
        String currency = '';

        if (_book._currency != 'USD' &&
            _book._currency != _symbols[culture._culture]) {
          currency = '[\$${_book._currency}]';
          final String? prevFormat = _numberFormat[culture._culture];
          String? symbol = _symbols[culture._culture];
          symbol = symbol!;
          style.numberFormat = prevFormat?.replaceFirst(symbol, currency);
        } else {
          style.numberFormat = _numberFormat[culture._culture];
        }
        break;

      case 'currency0':
        style.numberFormat = r'_($* #,##0_)';
        break;

      case 'percent':
        style.numberFormat = '0%';
        break;

      case 'hyperlink':
        style.fontColor = '#0000FF';
        style.underline = true;
        break;
    }
  }

  /// clear the cell style.
  void _clear() {
    for (final Style style in _styles) {
      (style as CellStyle)._clear();
    }
    _styles.clear();
    _dictStyles.clear();
  }
}
