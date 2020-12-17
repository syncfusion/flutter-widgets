part of xlsio;

/// Represents the Style class.
class Style {
  /// Represents cell style name.
  String name;

  /// Represents cell style index.
  int index;

  /// Gets/sets back color.
  String backColor;

  /// Gets/sets borders.
  Borders borders;

  /// Gets/sets font name.
  String fontName;

  /// Gets/sets font size.
  double fontSize;

  /// Gets/sets font color.
  String fontColor;

  /// Gets/sets font italic.
  bool italic;

  /// Gets/sets font bold.
  bool bold;

  /// Gets/sets horizontal alignment.
  HAlignType hAlign;

  /// Gets/sets cell indent.
  int indent;

  /// Gets/sets cell italic.
  int rotation;

  /// Gets/sets vertical alignment.
  VAlignType vAlign;

  /// Gets/sets font underline.
  bool underline;

  /// Gets/sets cell wraptext.
  bool wrapText;

  /// Gets/sets cell numberFormat index.
  int numberFormatIndex;

  /// Gets/sets cell numberFormat.
  String numberFormat;

  /// Gets/Sets cell Lock
  bool locked;
}
