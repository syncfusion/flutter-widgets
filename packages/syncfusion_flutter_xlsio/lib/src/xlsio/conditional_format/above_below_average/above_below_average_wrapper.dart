part of xlsio;

/// Represents the above or below conditional formatting rule.
/// Applying this rule to a range helps you highlight the cells which contain values above or below the average of selected range.
class _AboveBelowAverageWrapper implements AboveBelowAverage {
  /// Initializes new instance of the wrapper.
  _AboveBelowAverageWrapper(
      _AboveBelowAverageImpl aboveAverage, _ConditionalFormatWrapper format) {
    _wrapped = aboveAverage;
    _format = format;
  }

  /// Wrapped data Top10 object.
  late _AboveBelowAverageImpl _wrapped;

  /// Parent conditional format wrapper.
  // ignore: unused_field
  late _ConditionalFormatWrapper _format;

  @override

  /// Specifies whether the conditional formatting rule looks for cell values above or below the range average or standard deviation.
  ExcelCFAverageType get averageType {
    return _wrapped.averageType;
  }

  @override
  set averageType(ExcelCFAverageType value) {
    _wrapped.averageType = value;
  }

  @override

  /// Specifies standard deviation number for AboveAverage conditional formatting rule.
  int get stdDevValue {
    return _wrapped.stdDevValue;
  }

  @override
  set stdDevValue(int value) {
    _wrapped.stdDevValue = value;
  }
}
