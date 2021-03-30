part of pdf;

/// Details of the searched text
class MatchedItem {
  //Constructor
  MatchedItem._(String text, Rect bounds, int pageIndex) {
    this.text = text;
    this.bounds = bounds;
    this.pageIndex = pageIndex;
  }

  //Fields
  /// The searched text.
  late String text;

  /// Rectangle bounds of the searched text.
  late Rect bounds;

  /// Page number of the searched text.
  late int pageIndex;
}

/// Defines the constants that specify the option for text search.
enum TextSearchOption {
  /// Searches whole words only but not case sensitive.
  wholeWords,

  /// Searches words with case sensitive.
  caseSensitive,

  /// Searches words with both the case sensitive and whole word.
  both
}
