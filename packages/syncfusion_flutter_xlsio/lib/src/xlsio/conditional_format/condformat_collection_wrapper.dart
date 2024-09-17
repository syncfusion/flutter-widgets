import '../range/range.dart';
import '../worksheet/worksheet.dart';
import 'condformat_wrapper.dart';
import 'conditionalformat.dart';
import 'conditionalformat_collections.dart';

/// Wrapper over conditional format collection for range.
class CondFormatCollectionWrapper implements ConditionalFormats {
  /// Create an instances of culture info class.
  CondFormatCollectionWrapper(Range range) {
    _range = range;
    _arrConditionFormat = <ConditionalFormat>[];
    _sheet = range.worksheet;
  }

  /// Worksheet
  late Worksheet _sheet;

  /// Wrapped range object.
  late Range _range;

  ConditionalFormatsImpl? condFormats;

  /// List with all wrapped conditions.
  late List<ConditionalFormat> _arrConditionFormat;

  /// Number of begin update calls that have no corresponding end update.
  int _iBeginCount = 0;

  /// Gets the inner list.
  List<ConditionalFormat> get innerList {
    return _arrConditionFormat;
  }

  /// Gets worksheet.
  Worksheet get sheet {
    return _sheet;
  }

  @override

  /// Gets the number of conditional formats in the collection. Read-only.
  int get count {
    return condFormats!.innerList.length;
  }

  @override

  /// Gets the number of conditional formats in the collection. Read-only.
  set count(int value) {
    condFormats!.innerList.length = value;
  }

  @override

  /// Adds new condition to the collection.
  ConditionalFormat addCondition() {
    if (condFormats == null) {
      final Worksheet worksheet = sheet;
      condFormats = ConditionalFormatsImpl(worksheet, _range);
      worksheet.conditionalFormats.add(condFormats!);
    }
    ConditionalFormat format = condFormats!.addCondition();
    format = ConditionalFormatWrapper(this, count - 1);
    (format as ConditionalFormatWrapper).range = _range;
    _arrConditionFormat.add(format);
    return format;
  }

  /// This method should be called before several updates to the object will take place.
  void beginUpdate() {
    _iBeginCount++;
  }

  /// This method should be called after several updates to the object.
  void endUpdate() {
    if (_iBeginCount > 0) {
      _iBeginCount--;
    }
  }
}
