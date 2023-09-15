part of xlsio;

/// Represents Worksheet Hyperlink collection.
class HyperlinkCollection {
  /// Create a instances of Hyperlink collection.
  HyperlinkCollection(Worksheet worksheet) {
    _worksheet = worksheet;
    _hyperlink = <Hyperlink>[];
  }

  /// Represent the parent worksheet.
  late Worksheet _worksheet;

  late List<Hyperlink> _hyperlink;

  /// Gets the inner list.
  List<Hyperlink> get innerList {
    return _hyperlink;
  }

  /// Hyperlink cell index.
  Hyperlink operator [](dynamic index) => _hyperlink[index];

  /// Returns the count of hyperlink reference collection.
  int get count {
    return _hyperlink.length;
  }

  /// Add hyperlink to the hyperlink collection.
  /// ```dart
  /// final Workbook workbook = Workbook();
  /// final Worksheet sheet = workbook.worksheets[0];
  /// final Range range = sheet.getRangeByName('A1');
  ///
  /// // Add hyperlink to sheet.
  /// final Hyperlink link = sheet.hyperlinks
  ///     .add(range, HyperlinkType.url, 'http://www.syncfusion.com');
  /// link.screenTip = 'Click Here to know about Syncfusion';
  /// link.textToDisplay = 'Syncfusion';
  ///
  /// //Save and dispose.
  /// List<int> bytes = workbook.saveAsStream();
  /// File('Hyperlinks.xlsx').writeAsBytes(bytes);
  /// workbook.dispose();
  /// ```
  Hyperlink add(Range range, HyperlinkType linkType, String address,
      [String? screenTip, String? textToDisplay]) {
    final Hyperlink hyperlink = Hyperlink(_worksheet);
    hyperlink._bHyperlinkStyle = range.builtInStyle = BuiltInStyles.hyperlink;
    hyperlink._row = range.row;
    hyperlink._column = range.column;
    hyperlink.type = linkType;
    hyperlink.address = address;
    if (screenTip != null) {
      hyperlink.screenTip = screenTip;
    }
    if (textToDisplay != null) {
      hyperlink.textToDisplay = textToDisplay;
    }
    hyperlink._attachedType = ExcelHyperlinkAttachedType.range;
    addHyperlink(hyperlink);
    return hyperlink;
  }

  /// Add Image hyperlink to the hyperlink collection.
  /// ```dart
  /// final Workbook workbook = Workbook(1);
  /// final Worksheet sheet = workbook.worksheets[0];
  /// // Add picture to sheet.
  /// final Picture picture1 = sheet.pictures.addBase64(1, 1, image14png);
  ///
  /// // Add image hyperlink to sheet.
  /// Hyperlink link = sheet.hyperlinks.addImage(picture1, HyperlinkType.url,
  ///     'mailto:Username@syncfusion.com');
  /// link.screenTip = 'Mail to User';
  ///
  /// //Save and dispose.
  /// List<int> bytes = workbook.saveAsStream();
  /// File('HyperlinksImage.xlsx').writeAsBytes(bytes);
  /// workbook.dispose();
  /// ```
  Hyperlink addImage(Picture picture, HyperlinkType linkType, String address,
      [String? screenTip]) {
    final Hyperlink hyperlink = Hyperlink(_worksheet);
    hyperlink.type = linkType;
    hyperlink.address = address;
    if (screenTip != null) {
      hyperlink.screenTip = screenTip;
    }
    hyperlink._attachedType = ExcelHyperlinkAttachedType.shape;
    picture._isHyperlink = true;
    picture.hyperlink = hyperlink;
    addHyperlink(hyperlink);
    return hyperlink;
  }

  /// Add hyperlink to the hyperlinks collection.
  void addHyperlink(Hyperlink hyperlink) {
    innerList.add(hyperlink);
  }
}
