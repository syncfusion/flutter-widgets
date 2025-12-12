import '../worksheet/worksheet.dart';
import 'range_collection.dart';

/// Represents the worksheet row.
class Row {
  /// Create an instance of Row.
  Row(Worksheet sheet) {
    _worksheet = sheet;
    isHidden = false;
  }

  ///Represents the indicate wheather row hide or not.
  late bool isHidden;

  /// Represents the row height.
  double height = 0;

  /// Represents the row index.
  late int index;

  /// Parent worksheet.
  late Worksheet _worksheet;

  /// Range collection in the row.
  RangeCollection? _ranges;

  /// Represents parent worksheet.
  Worksheet get worksheet {
    return _worksheet;
  }

  ///  Gets/Sets a images collections in the worksheet.
  RangeCollection get ranges {
    _ranges ??= RangeCollection(this);
    return _ranges!;
  }

  /// clear the row.
  void clear() {
    if (_ranges != null) {
      _ranges!.clear();
    }
  }
}
