part of pdf;

/// Represents base class for lists.
abstract class PdfList extends PdfLayoutElement {
  // Creates an item collection.
  static PdfListItemCollection _createItems(String text) {
    ArgumentError.checkNotNull(text, 'text');
    return PdfListItemCollection(text.split('\n'));
  }

  /// Holds collection of items.
  PdfListItemCollection _items;

  /// Tabulation for items.
  double indent;

  /// Indent between marker and text.
  double textIndent;

  /// List's font.
  PdfFont _font;

  /// The pen for the list.
  PdfPen pen;

  /// The brush for the list.
  PdfBrush brush;

  /// The string format for the list.
  PdfStringFormat stringFormat;

  /// Gets items of the list.
  PdfListItemCollection get items {
    _items ??= PdfListItemCollection();
    return _items;
  }

  /// Gets the list font.
  PdfFont get font => _font;

  /// Sets the list font.
  set font(PdfFont value) {
    ArgumentError.checkNotNull(value, 'font');
    _font = value;
  }

  //Events
  /// Event that rises when item begin layout.
  BeginItemLayoutCallback beginItemLayout;

  /// Event that rises when item end layout.
  EndItemLayoutCallback endItemLayout;

  /// Layouts on the specified Page.
  @override
  PdfLayoutResult _layout(_PdfLayoutParams param) {
    final _PdfListLayouter layouter = _PdfListLayouter(this);
    return layouter._layout(param);
  }

  /// Draws list on the Graphics.
  @override
  void _drawInternal(PdfGraphics graphics, _Rectangle bounds) {
    final _PdfLayoutParams param = _PdfLayoutParams();
    param.bounds = bounds;
    param.format = PdfLayoutFormat();
    param.format.layoutType = PdfLayoutType.onePage;
    final _PdfListLayouter layouter = _PdfListLayouter(this);
    layouter.graphics = graphics;
    layouter._layoutInternal(param);
  }

  /// Rise the BeginItemLayout event.
  void _onBeginItemLayout(BeginItemLayoutArgs args) {
    if (beginItemLayout != null) {
      beginItemLayout(this, args);
    }
  }

  /// Rise the EndItemLayout event.
  void _onEndItemLayout(EndItemLayoutArgs args) {
    if (endItemLayout != null) {
      endItemLayout(this, args);
    }
  }
}

/// Represents begin layout event arguments.
class BeginItemLayoutArgs {
  /// Initializes a new instance of the [BeginItemLayoutArgs] class.
  BeginItemLayoutArgs._internal(this._item, this._page);

  /// Item that layout.
  final PdfListItem _item;

  /// The page in which item start layout.
  final PdfPage _page;

  /// Gets the item.
  PdfListItem get item => _item;

  /// Gets the page.
  PdfPage get page => _page;
}

/// Represents end layout event arguments.
class EndItemLayoutArgs {
  /// Initializes a new instance of the [EndItemLayoutArgs] class.
  EndItemLayoutArgs._internal(this._item, this._page);

  /// Item that layouted.
  final PdfListItem _item;

  /// The page in which item ended layout.
  final PdfPage _page;

  /// Gets the item.
  PdfListItem get item => _item;

  /// Gets the page.
  PdfPage get page => _page;
}

/// typedef for handling BeginItemLayoutEvent.
typedef BeginItemLayoutCallback = void Function(
    Object sender, BeginItemLayoutArgs args);

/// typedef for handling EndItemLayoutEvent.
typedef EndItemLayoutCallback = void Function(
    Object sender, EndItemLayoutArgs args);
