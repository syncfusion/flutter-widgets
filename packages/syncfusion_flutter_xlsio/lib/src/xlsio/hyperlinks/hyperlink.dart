part of xlsio;

/// Represent the Hyperlink object.
class Hyperlink {
  /// Creates an instance of Hyperlink.
  Hyperlink(Worksheet sheet) {
    _worksheet = sheet;
  }

  /// Represents hyperlink id.
  int _rId;

  /// Represents tooltip String.
  String screenTip;

  /// Represents the hyperlink location.
  // ignore: unused_field
  String _location;

  /// Returns or sets the text to be displayed for the specified hyperlink.
  /// The default value is the address of the hyperlink.
  String textToDisplay;

  /// Represents hyperlink target String.
  String address;

  /// Returns or sets the hyperlink type.
  HyperlinkType type;

  /// Parent worksheet.
  // ignore: unused_field
  Worksheet _worksheet;

  /// Row index
  int _row;

  /// Column Index
  int _column;

  /// Represents the Hyperlink built in style.
  // ignore: unused_field
  BuiltInStyles _bHyperlinkStyle;

  /// Represents the cell reference name.
  String get reference {
    return Range._getCellName(_row, _column);
  }

  /// Represent the hyperlink applied object name.
  ExcelHyperlinkAttachedType _attachedType;
}
