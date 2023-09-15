part of xlsio;

/// Represents the top or bottom conditional formatting rule.
/// Applying this rule to a range helps you highlight the top or bottom 'n' cells from the selected range
class _AboveBelowAverageImpl implements AboveBelowAverage {
  /// Specifies whether the conditional formatting rule looks for cell values above or below the range average or standard deviation.
  ExcelCFAverageType _averageType = ExcelCFAverageType.above;

  /// Specifies standard deviation number for AboveAverage conditional formatting rule.
  int _stdDevValue = 1;

  @override

  /// Specifies whether the conditional formatting rule looks for cell values above or below the range average or standard deviation.
  ExcelCFAverageType get averageType {
    return _averageType;
  }

  @override
  set averageType(ExcelCFAverageType value) {
    if (_averageType != value) {
      _stdDevValue = 1;
    }
    _averageType = value;
  }

  @override

  /// Specifies standard deviation number for AboveAverage conditional formatting rule.
  int get stdDevValue {
    return _stdDevValue;
  }

  @override
  set stdDevValue(int value) {
    if (value < 1 || value > 3) {
      throw Exception('NumStd must be between 1 and 3');
    }
    _stdDevValue = value;
  }
}
