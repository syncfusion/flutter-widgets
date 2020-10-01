part of xlsio;

/// Represents cell font.

class Font {
  /// Creates an new instances of Font.
  Font() {
    size = 11;
    name = 'Calibri';
    underline = false;
    bold = false;
    italic = false;
    color = 'FF000000';
  }

  /// Gets/sets font bold.
  bool bold;

  /// Gets/sets font italic.
  bool italic;

  /// Gets/sets font underline.
  bool underline;

  /// Gets/sets font size.
  int size;

  /// Gets/sets font name.
  String name;

  /// Gets/sets font color.
  String color;
}
