part of xlsio;

// ignore: public_member_api_docs
class FormatsCollection {
  /// Represent the parent.
  Workbook _parent;

  /// Represents the Decimal Seprator.
  static const String decimalSeparator = '.';

  /// Represents the Thousand seprator.
  static const String thousandSeparator = ',';

  /// Represents the percentage in decimal numbers.
  static const String percentage = '%';

  /// Represents the fraction symbol.
  static const String fraction = '/';

  /// Represents the index of the date format.
  static const String date = 'date';

  /// Represents the time separator.
  static const String time = ':';

  /// Represents the Exponenet Symbol.
  static const String exponent = 'E';

  /// Represents the Minus symbol.
  static const String minus = '-';

  /// Represents the Currency Symbol.
  static const String currency = '\$';

  /// Represents the default exponential Symbol.
  static const String default_exponential = 'E+';

  /// Index to the first user-defined number format.
  static const int default_first_custom_index = 163;

  /// Default format Strings.
  final _defaultFormatString = [
    'General',
    '0',
    '0.00',
    '#,##0',
    '#,##0.00',
    '\'\$\'#,##0_);\\(\'\$\'#,##0\\)',
    '\'\$\'#,##0_);[Red]\\(\'\$\'#,##0\\)',
    '\'\$\'#,##0.00_);\\(\'\$\'#,##0.00\\)',
    '\'\$\'#,##0.00_);[Red]\\(\'\$\'#,##0.00\\)',
    '0%',
    '0.00%',
    '0.00E+00',
    '# ?/?',
    '# ??/??',
    'm/d/yyyy',
    r'd\-mmm\-yy',
    r'd\-mmm',
    r'mmm\-yy',
    'h:mm\\ AM/PM',
    'h:mm:ss\\ AM/PM',
    'h:mm',
    'h:mm:ss',
    'm/d/yyyy\\ h:mm',
    r'#,##0_);(#,##0)',
    r'#,##0_);[Red](#,##0)',
    r'#,##0.00_);(#,##0.00)',
    r'#,##0.00_);[Red](#,##0.00)',
    '_(* #,##0_);_(* \\(#,##0\\);_(* \'-\'_);_(@_)',
    '_(\'\$\'* #,##0_);_(\'\$\'* \\(#,##0\\);_(\'\$\'* \'-\'_);_(@_)',
    '_(* #,##0.00_);_(* \\(#,##0.00\\);_(* \'-\'??_);_(@_)',
    '_(\'\$\'* #,##0.00_);_(\'\$\'* \\(#,##0.00\\);_(\'\$\'* \'-\'??_);_(@_)',
    'mm:ss',
    '[h]:mm:ss',
    'mm:ss.0',
    '##0.0E+0',
    '@'
  ];

  /// Maximum number formats count in a workbook. 36 Default + 206 Custom formats.
  static const int max_formats_count = 242;

  /// Index-to-FormatImpl.
  Map<int, FormatImpl> _rawFormats = <int, FormatImpl>{};

  /// Dictionary. Key - format string, value - FormatImpl.
  Map<String, FormatImpl> _hashFormatStrings = <String, FormatImpl>{};

  /// Gets the number of elements contained in the collection. Read-only
  int get count {
    return _rawFormats.length;
  }

  /// Represents the parent object.
  Workbook get parent {
    return _parent;
  }

  /// Indexer of the class
  FormatImpl operator [](index) => _rawFormats[index];

  /// Initializes new instance and sets its application and parent objects.
  // ignore: sort_constructors_first
  FormatsCollection(Workbook workbook) {
    _parent = workbook;
  }

  /// <summary>
  /// Inserts all default formats into list.
  /// </summary>
  void insertDefaultFormats() {
    FormatImpl curFormat;
    int iFormatIndex = 0;
    final int iLength = _defaultFormatString.length;
    for (int iIndex = 0; iIndex < iLength; iIndex++) {
      curFormat = FormatImpl(this);
      curFormat.index = iFormatIndex;
      curFormat.formatString = _defaultFormatString[iIndex];
      if (!_rawFormats.containsKey(curFormat.index)) {
        _rawFormats[curFormat.index] = curFormat;
        _hashFormatStrings[curFormat.formatString] = curFormat;
      }
      if (iFormatIndex == 22) iFormatIndex = 36;
      iFormatIndex++;
    }
  }

  /// Gets all used formats.
  List<FormatImpl> getUsedFormats() {
    final List<FormatImpl> result = [];

    final List<int> keys = _rawFormats.keys.toList();
    final int index = keys.indexOf(49);

    /// 49 is last index of always present formats
    final int iCount = _rawFormats.length;

    if (index >= 0 && index < iCount - 1) {
      for (int i = index + 1; i < iCount; i++) {
        final FormatImpl format = _rawFormats[keys[i]];

        if (format.index >= default_first_custom_index) result.add(format);
      }
    }

    return result;
  }

  /// Searches for format with specified format string and creates one if a match is not found.
  int findOrCreateFormat(String formatString) {
    return _hashFormatStrings.containsKey(formatString)
        ? _hashFormatStrings[formatString].index
        : createFormat(formatString);
  }

  /// Method that creates format object based on the format string and registers it in the workbook.
  int createFormat(String formatString) {
    if (formatString == null) throw Exception('formatString');

    if (formatString.isEmpty) {
      throw Exception('formatString - string cannot be empty');
    }
    if (formatString.contains(default_exponential.toLowerCase())) {
      formatString = formatString.replaceAll(
          default_exponential.toLowerCase(), default_exponential);
    }
//      formatString = GetCustomizedString(formatString);
    if (_hashFormatStrings.containsKey(formatString)) {
      final FormatImpl format = _hashFormatStrings[formatString];
      return format.index;
    }
    if (_parent.cultureInfo._culture == 'en-US') {
      final String localStr = formatString.replaceAll('\'\$\'', '\$');

      /// To know if the format string to be created is a pre-defined one.
      for (final String formatStr in _hashFormatStrings.keys) {
        if (formatStr.replaceAll('\\', '').replaceAll('\'\$\'', '\$') ==
            localStr) {
          final FormatImpl format = _hashFormatStrings[formatStr];
          return format.index;
        }
      }
    }
    final int iCount = _rawFormats.length;
    int index = _rawFormats.keys.toList()[iCount - 1];

    /// NOTE: By Microsoft, indexes less than 163 are reserved for build-in formats.
    if (index < default_first_custom_index) index = default_first_custom_index;
    index++;

    if (iCount < max_formats_count) {
      final FormatImpl format = FormatImpl(this);
      format.formatString = formatString;
      format.index = index;
      register(format);
    } else {
      return 0;
    }
    return index;
  }

  /// Determines whether the IDictionary contains an element with the specified key.
  bool contains(int key) {
    return _rawFormats.containsKey(key);
  }

  /// Determines whether the IDictionary contains an element with the specified key.
  bool containsFormat(String format) {
    return _hashFormatStrings.containsKey(format);
  }

  /// Adding formats to collection
  void register(FormatImpl format) {
    if (format == null) throw Exception('format');

    _rawFormats[format.index] = format;
    _hashFormatStrings[format.formatString] = format;
  }

  /// <summary>
  ///  Removes all elements from the IDictionary.
  /// </summary>
  void clear() {
    for (final MapEntry<String, FormatImpl> formatImpl
        in _hashFormatStrings.entries) {
      formatImpl.value.clear();
    }
    _rawFormats.clear();
    _hashFormatStrings.clear();
    _defaultFormatString.clear();
    _rawFormats = null;
    _hashFormatStrings = null;
  }
}
