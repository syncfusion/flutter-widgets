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
  Font._withNameSize(this.name, this.size) {
    underline = false;
    bold = false;
    italic = false;
    color = 'FF000000';
  }

  /// Gets/sets font bold.
  late bool bold;

  /// Gets/sets font italic.
  late bool italic;

  /// Gets/sets font underline.
  late bool underline;

  /// Gets/sets font size.
  late double size;

  /// Gets/sets font name.
  late String name;

  /// Gets/sets font color.
  late String color;
}
