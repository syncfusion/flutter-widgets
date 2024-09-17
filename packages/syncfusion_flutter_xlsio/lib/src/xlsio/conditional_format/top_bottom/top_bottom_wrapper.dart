import '../../conditional_format/top_bottom/top_bottom.dart';
import '../../conditional_format/top_bottom/top_bottom_impl.dart';
import '../../general/enums.dart';
import '../condformat_wrapper.dart';

/// Represents the top or bottom conditional formatting rule.
/// Applying this rule to a range helps you highlight the top or bottom “n” cells from the selected range
class TopBottomWrapper implements TopBottom {
  /// Initializes new instance of the wrapper.
  TopBottomWrapper(TopBottomImpl top10, ConditionalFormatWrapper format) {
    _wrapped = top10;
    _format = format;
  }

  /// Wrapped data Top10 object.
  late TopBottomImpl _wrapped;

  /// Parent conditional format wrapper.
  // ignore: unused_field
  late ConditionalFormatWrapper _format;

  @override

  /// Specifies whether the ranking is evaluated from the top or bottom.
  ExcelCFTopBottomType get type {
    return _wrapped.type;
  }

  @override

  /// Specifies whether the ranking is evaluated from the top or bottom.
  set type(ExcelCFTopBottomType value) {
    _wrapped.type = value;
  }

  @override

  /// Specifies whether the rank is determined by a percentage value.
  bool get percent {
    return _wrapped.percent;
  }

  @override

  /// Specifies whether the rank is determined by a percentage value.
  set percent(bool value) {
    _wrapped.percent = value;
  }

  @override

  /// Specifies the maximum number or percentage of cells to be highlighted for this conditional formatting rule.
  int get rank {
    return _wrapped.rank;
  }

  @override

  /// Specifies the maximum number or percentage of cells to be highlighted for this conditional formatting rule.
  set rank(int value) {
    _wrapped.rank = value;
  }
}
