import '../../general/enums.dart';
import '../above_below_average/above_below_average.dart';
import '../above_below_average/above_below_average_impl.dart';
import '../condformat_wrapper.dart';

/// Represents the above or below conditional formatting rule.
/// Applying this rule to a range helps you highlight the cells which contain values above or below the average of selected range.
class AboveBelowAverageWrapper implements AboveBelowAverage {
  /// Initializes new instance of the wrapper.
  AboveBelowAverageWrapper(
      AboveBelowAverageImpl aboveAverage, ConditionalFormatWrapper format) {
    _wrapped = aboveAverage;
    _format = format;
  }

  /// Wrapped data Top10 object.
  late AboveBelowAverageImpl _wrapped;

  /// Parent conditional format wrapper.
  // ignore: unused_field
  late ConditionalFormatWrapper _format;

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
