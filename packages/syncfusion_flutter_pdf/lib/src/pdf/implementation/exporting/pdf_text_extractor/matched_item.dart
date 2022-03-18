import 'dart:ui';

/// Details of the searched text
class MatchedItem {
  //Constructor
  MatchedItem._(this.text, this._boundsCollection, this.pageIndex);

  //Fields
  /// The searched text.
  late String text;

  /// Rectangle bounds of the searched text.
  late Rect bounds = _boundsCollection[0];

  /// Page number of the searched text.
  late int pageIndex;

  //Internal fields
  /// Rectangle bounds collection of the searched text.
  final List<Rect> _boundsCollection;
}

// ignore: avoid_classes_with_only_static_members
/// [MatchedItem] helper
class MatchedItemHelper {
  /// internal method
  static MatchedItem initialize(String text, List<Rect> bounds, int pageIndex) {
    return MatchedItem._(text, bounds, pageIndex);
  }
}
