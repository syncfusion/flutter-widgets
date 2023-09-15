part of xlsio;

/// Represent the Hyperlink object.
class Hyperlink {
  /// Creates an instance of Hyperlink.
  Hyperlink(Worksheet sheet) {
    _worksheet = sheet;
  }

  /// Creates an instance of Hyperlink with parameters.
  Hyperlink.add(this.address,
      [this.screenTip, this.textToDisplay, HyperlinkType? type]) {
    if (type != null) {
      this.type = type;
    } else {
      type = HyperlinkType.url;
    }
  }

  /// Represents the hyperlink location.
  // ignore: unused_field
  String? _location;

  /// Parent worksheet.
  // ignore: unused_field
  late Worksheet _worksheet;

  /// Row index
  // ignore: prefer_final_fields
  int _row = 0;

  /// Column Index
  // ignore: prefer_final_fields
  int _column = 0;

  /// Represents the Hyperlink built in style.
  // ignore: unused_field
  BuiltInStyles? _bHyperlinkStyle;

  /// Represent the hyperlink applied object name.
  // ignore: prefer_final_fields
  ExcelHyperlinkAttachedType _attachedType = ExcelHyperlinkAttachedType.range;

  /// Represents tooltip String.
  ///  ```dart
  /// final Workbook workbook = Workbook();
  /// final Worksheet sheet = workbook.worksheets[0];
  /// final Range range = sheet.getRangeByName('A1');
  ///
  /// // Add hyperlink to sheet.
  /// final Hyperlink link = sheet.hyperlinks
  ///     .add(range, HyperlinkType.url, 'http://www.syncfusion.com');
  /// // set screen tip.
  /// link.screenTip = 'Click Here to know about Syncfusion';
  /// // set text to display.
  /// link.textToDisplay = 'Syncfusion';
  ///
  /// //Save and dispose.
  /// List<int> bytes = workbook.saveAsStream();
  /// File('Hyperlinks.xlsx').writeAsBytes(bytes);
  /// workbook.dispose();
  /// ```
  String? screenTip;

  /// Returns or sets the text to be displayed for the specified hyperlink.
  /// The default value is the address of the hyperlink.
  /// ///  ```dart
  /// final Workbook workbook = Workbook();
  /// final Worksheet sheet = workbook.worksheets[0];
  /// final Range range = sheet.getRangeByName('A1');
  ///
  /// // Add hyperlink to sheet.
  /// final Hyperlink link = sheet.hyperlinks
  ///     .add(range, HyperlinkType.url, 'http://www.syncfusion.com');
  /// // set screen tip.
  /// link.screenTip = 'Click Here to know about Syncfusion';
  /// // set text to display.
  /// link.textToDisplay = 'Syncfusion';
  ///
  /// //Save and dispose.
  /// List<int> bytes = workbook.saveAsStream();
  /// File('Hyperlinks.xlsx').writeAsBytes(bytes);
  /// workbook.dispose();
  /// ```
  String? textToDisplay;

  /// Represents hyperlink target String.
  ///  ```dart
  /// final Workbook workbook = Workbook();
  /// final Worksheet sheet = workbook.worksheets[0];
  /// final Range range = sheet.getRangeByName('A1');
  ///
  /// // Add hyperlink to sheet.
  /// final Hyperlink link = sheet.hyperlinks
  ///     .add(range, HyperlinkType.url, 'http://www.syncfusion.com');
  /// // set screen tip.
  /// link.screenTip = 'Click Here to know about Syncfusion';
  /// // set text to display.
  /// link.textToDisplay = 'Syncfusion';
  ///
  /// //Save and dispose.
  /// List<int> bytes = workbook.saveAsStream();
  /// File('Hyperlinks.xlsx').writeAsBytes(bytes);
  /// workbook.dispose();
  /// ```
  late String address;

  /// Returns or sets the hyperlink type.
  /// ```dart
  /// final Workbook workbook = Workbook();
  /// final Worksheet sheet = workbook.worksheets[0];
  /// final Range range = sheet.getRangeByName('A1');
  ///
  /// // Add hyperlink to sheet.
  /// final Hyperlink link = sheet.hyperlinks
  ///     .add(range, HyperlinkType.url, 'http://www.syncfusion.com');
  /// // set screen tip.
  /// link.screenTip = 'Click Here to know about Syncfusion';
  /// // set text to display.
  /// link.textToDisplay = 'Syncfusion';
  ///
  /// //Save and dispose.
  /// List<int> bytes = workbook.saveAsStream();
  /// File('Hyperlinks.xlsx').writeAsBytes(bytes);
  /// workbook.dispose();
  /// ```
  late HyperlinkType type;

  /// Represents the cell reference name.
  String get reference {
    return Range._getCellName(_row, _column);
  }
}
