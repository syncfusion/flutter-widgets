part of xlsio;

/// Represents Worksheet Hyperlink collection.
class HyperlinkCollection {
  /// Create a instances of Hyperlink collection.
  HyperlinkCollection([Worksheet worksheet]) {
    _worksheet = worksheet;
    _hyperlink = [];
  }

  /// Represent the parent worksheet.
  Worksheet _worksheet;

  List<Hyperlink> _hyperlink;

  /// Gets the inner list.
  List<Hyperlink> get innerList {
    return _hyperlink;
  }

  /// Hyperlink cell index.
  Hyperlink operator [](index) => _hyperlink[index];

  /// Returns the count of hyperlink reference collection.
  int get count {
    return _hyperlink.length;
  }

  /// Add hyperlink to the hyperlink collection.
  Hyperlink add(Range range, HyperlinkType linkType, String address,
      [String screenTip, String textToDisplay]) {
    final Hyperlink hyperlink = Hyperlink(_worksheet);
    hyperlink._bHyperlinkStyle = range.builtInStyle = BuiltInStyles.hyperlink;
    hyperlink._row = range.row;
    hyperlink._column = range.column;
    hyperlink.type = linkType;
    hyperlink.address = address;
    if (screenTip != null) hyperlink.screenTip = screenTip;
    if (textToDisplay != null) hyperlink.textToDisplay = textToDisplay;
    hyperlink._attachedType = ExcelHyperlinkAttachedType.range;
    addHyperlink(hyperlink);
    return hyperlink;
  }

  /// Add Image hyperlink to the hyperlink collection.
  Hyperlink addImage(Picture picture, HyperlinkType linkType, String address,
      [String screenTip]) {
    if (picture == null) throw Exception('Picture');
    final Hyperlink hyperlink = Hyperlink(_worksheet);
    hyperlink.type = linkType;
    hyperlink.address = address;
    if (screenTip != null) hyperlink.screenTip = screenTip;
    hyperlink._attachedType = ExcelHyperlinkAttachedType.shape;
    picture._isHyperlink = true;
    picture._link = hyperlink;
    addHyperlink(hyperlink);
    return hyperlink;
  }

  /// Add hyperlink to the hyperlinks collection.
  void addHyperlink(Hyperlink hyperlink) {
    if (hyperlink != null) {
      innerList.add(hyperlink);
      hyperlink._rId = count;
    }
  }
}
