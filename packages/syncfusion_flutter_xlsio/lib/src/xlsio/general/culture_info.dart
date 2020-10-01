part of xlsio;

/// Represent the Culture Info class.
class CultureInfo {
  /// Create an instances of culture info class.
  CultureInfo(String name) {
    _culture = name;
    initializeDateFormatting(_culture, null);
    _dateTimeFormat = DateTimeFormatInfo(_culture);
    _numberFormat = NumberFormatInfo(_culture);
    _textInfo = TextInfo();
  }

  String _culture;

  NumberFormatInfo _numberFormat;
  DateTimeFormatInfo _dateTimeFormat;
  TextInfo _textInfo;

  /// Set the current culture.
  static CultureInfo currentCulture = CultureInfo('en-US');

  /// Represents NumberFormatInfo separator.
  NumberFormatInfo get numberFormat {
    return _numberFormat;
  }

  /// Represents DateTimeFormatInfo separator.
  DateTimeFormatInfo get dateTimeFormat {
    return _dateTimeFormat;
  }

  /// Represents TextInfo separator.
  TextInfo get textInfo {
    return _textInfo;
  }
}

/// Represents the Number Format Info class.
class NumberFormatInfo {
  /// Create an instances of Number Format class.
  NumberFormatInfo(String locale) {
    _locale = locale;
  }
  String _locale;
  NumberSymbols _numberSymbols;

  String _currencySymbol;
  String _decimalSeparator;
  String _groupSeparator;

  /// Gets the number symbol.
  NumberSymbols get numberSymbols {
    if (_numberSymbols == null) {
      _numberSymbols = numberFormatSymbols[_locale] as NumberSymbols;
      if (_numberSymbols == null && _locale.length > 2) {
        _numberSymbols =
            numberFormatSymbols[_locale.replaceAll('-', '_')] as NumberSymbols;
      }
      _numberSymbols ??=
          numberFormatSymbols[_locale.substring(0, 2)] as NumberSymbols;
    }
    return _numberSymbols;
  }

  /// Represents decimal separator.
  String get numberDecimalSeparator {
    if (_decimalSeparator == null) {
      if (numberSymbols != null) {
        _decimalSeparator = numberSymbols.DECIMAL_SEP;
      } else {
        _decimalSeparator = '.';
      }
    }

    return _decimalSeparator;
  }

  set numberDecimalSeparator(String value) {
    _decimalSeparator = value;
  }

  /// Represents group separator.
  String get numberGroupSeparator {
    if (_groupSeparator == null) {
      if (numberSymbols != null) {
        _groupSeparator = numberSymbols.GROUP_SEP;
      }
    } else {
      _groupSeparator = ',';
    }
    return _groupSeparator;
  }

  set numberGroupSeparator(String value) {
    _groupSeparator = value;
  }

  /// Represents Currency Symbol.
  String get currencySymbol {
    if (_currencySymbol == null) {
      if (numberSymbols != null) {
        final format = NumberFormat.currency(locale: _locale);
        _currencySymbol = format.currencySymbol;
      } else {
        _currencySymbol = '\$';
      }
    }
    return _currencySymbol;
  }

  set currencySymbol(String value) {
    _currencySymbol = value;
  }
}

/// Represents the Date Time Format Info class.
class DateTimeFormatInfo {
  /// Create an instances of Date Time Format Info class.
  DateTimeFormatInfo(String locale) {
    _locale = locale;
    _dateTimeSymbols = dateTimeSymbolMap();
  }
  String _locale;
  DateSymbols _dateSymbols;

  /// Represents date separator.
  String _dateSeparator;

  /// Represents time separator.
  String timeSeparator = ':';

  /// The custom format string for a short date value.
  String _shortDatePattern;

  /// The custom format string for a short time value.
  String _shortTimePattern = ':';

  final _fractionSeperators = ['/', '-', '.'];

  /// Represents the DateTime symbols map.
  Map<dynamic, dynamic> _dateTimeSymbols;

  /// Maximum supported date time.
  DateTime maxSupportedDateTime = DateTime(9999, 12, 31);

  /// Minimum supported date time.
  DateTime minSupportedDateTime = DateTime(0001, 01, 01);

  /// Gets the date symbols.
  DateSymbols get dateSymbols {
    if (_dateSymbols == null) {
      _dateSymbols = _dateTimeSymbols[_locale] as DateSymbols;
      if (_dateSymbols == null && _locale.length > 2) {
        _dateSymbols =
            _dateTimeSymbols[_locale.replaceAll('-', '_')] as DateSymbols;
      }

      _dateSymbols ??= _dateTimeSymbols[_locale.substring(0, 2)] as DateSymbols;
    }
    return _dateSymbols;
  }

  /// Represents date separator.
  String get dateSeparator {
    if (_dateSeparator == null) {
      if (dateSymbols != null) {
        final dateFormat = dateSymbols.DATEFORMATS[3];
        for (final String fraction in _fractionSeperators) {
          final index = dateFormat.indexOf(fraction);
          if (index != -1) {
            _dateSeparator = dateFormat[index];
            break;
          }
        }
      } else {
        _dateSeparator = '/';
      }
    }
    return _dateSeparator;
  }

  set dateSeparator(String value) {
    _dateSeparator = value;
  }

  /// The custom format string for a short date value.
  String get shortDatePattern {
    if (_shortDatePattern == null) {
      if (dateSymbols != null) {
        return dateSymbols.DATEFORMATS[3];
      } else {
        _shortDatePattern = 'M/d/yyyy';
      }
    }
    return _shortDatePattern;
  }

  set shortDatePattern(String value) {
    _shortDatePattern = value;
  }

  /// The custom format string for a short time value.
  String get shortTimePattern {
    if (_shortTimePattern == null) {
      if (dateSymbols != null) {
        return dateSymbols.TIMEFORMATS[3];
      } else {
        _shortTimePattern = 'h:mm tt';
      }
    }
    return _shortTimePattern;
  }

  set shortTimePattern(String value) {
    _shortTimePattern = value;
  }
}

/// Represents the Text info class.
class TextInfo {
  /// Represents argument separator.
  String argumentSeparator = ',';
}
