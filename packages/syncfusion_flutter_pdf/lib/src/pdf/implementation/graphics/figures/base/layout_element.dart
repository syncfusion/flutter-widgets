part of pdf;

/// Represents the base class for all elements that can be layout on the pages.
abstract class PdfLayoutElement {
  //Constructor
  /// Initializes a insteace of the [PdfLayoutElement] class.
  PdfLayoutElement();

  //Properties
  bool get _raiseBeginPageLayout => beginPageLayout != null;
  bool get _raisePageLayouted => endPageLayout != null;

  //Public methods
  /// Draws an element on the graphics or page.
  ///
  /// If both graphics and page provide in the arguments
  /// then page takes more precedence than graphics
  PdfLayoutResult? draw(
      {PdfGraphics? graphics,
      PdfPage? page,
      Rect? bounds,
      PdfLayoutFormat? format}) {
    return _draw(graphics, page, bounds, format);
  }

  //Implementation
  PdfLayoutResult? _layout(_PdfLayoutParams param);

  PdfLayoutResult? _draw(PdfGraphics? graphics, PdfPage? page, Rect? bounds,
      PdfLayoutFormat? format) {
    if (page != null) {
      final _PdfLayoutParams param = _PdfLayoutParams();
      param.page = page;
      param.bounds =
          bounds != null ? _Rectangle.fromRect(bounds) : _Rectangle.empty;
      param.format = (format != null) ? format : PdfLayoutFormat();
      return _layout(param);
    } else if (graphics != null) {
      final _Rectangle rectangle =
          bounds != null ? _Rectangle.fromRect(bounds) : _Rectangle.empty;
      if (rectangle.x != 0 || rectangle.y != 0) {
        final PdfGraphicsState gState = graphics.save();
        graphics.translateTransform(rectangle.x, rectangle.y);
        rectangle.x = 0;
        rectangle.y = 0;
        _drawInternal(graphics, rectangle);
        graphics.restore(gState);
      } else {
        _drawInternal(graphics, rectangle);
      }
      return null;
    } else {
      return null;
    }
  }

  void _onBeginPageLayout(BeginPageLayoutArgs e) {
    if (beginPageLayout != null) {
      beginPageLayout!(this, e);
    }
  }

  void _onEndPageLayout(EndPageLayoutArgs e) {
    if (endPageLayout != null) {
      endPageLayout!(this, e);
    }
  }

  void _drawInternal(PdfGraphics graphics, _Rectangle bounds);

  //Events
  /// Raises before the element should be printed on the page.
  BeginPageLayoutCallback? beginPageLayout;

  /// Raises after the element was printed on the page.
  EndPageLayoutCallback? endPageLayout;
}

/// Represents the base class for classes that contain event data, and provides
/// a value to use for events, once completed the text lay outing on the page.
class EndTextPageLayoutArgs extends EndPageLayoutArgs {
  /// Initializes a new instance of the [EndTextPageLayoutArgs] class
  /// with the specified [PdfTextLayoutResult].
  EndTextPageLayoutArgs(PdfTextLayoutResult result) : super(result);
}

/// Provides data for event once lay outing completed on the new page.
class EndPageLayoutArgs extends PdfCancelArgs {
  //Constructor
  /// Initialize an instance of [EndPageLayoutArgs].
  EndPageLayoutArgs(PdfLayoutResult result) {
    _result = result;
  }

  //Fields
  /// The next page for lay outing.
  PdfPage? nextPage;
  late PdfLayoutResult _result;

  //Properties
  /// Gets the lay outing result of the page.
  PdfLayoutResult get result => _result;
}

/// Provides data for event before lay outing the new page.
class BeginPageLayoutArgs extends PdfCancelArgs {
  //Constructor
  /// Initialize an instance of [BeginPageLayoutArgs].
  BeginPageLayoutArgs(Rect bounds, PdfPage page) {
    _bounds = _Rectangle.fromRect(bounds);
    _page = page;
  }

  //Fields
  /// The bounds of the lay outing on the page.
  late _Rectangle _bounds;
  late PdfPage _page;

  //Properties
  /// Gets the page where the lay outing should start.
  PdfPage get page => _page;

  /// The bounds of the lay outing on the page.
  Rect get bounds => _bounds.rect;

  /// Sets value that indicates the lay outing bounds on the page.
  set bounds(Rect value) {
    _bounds = _Rectangle.fromRect(value);
  }
}

/// Provides the data for a cancelable event.
class PdfCancelArgs {
  ///The value indicating whether this [PdfCancelArgs] is cancel.
  bool cancel = false;
}

/// Represents the method that will handle an event
/// that before lay outing on the page.
typedef BeginPageLayoutCallback = void Function(
    Object sender, BeginPageLayoutArgs args);

/// Represents the method that will handle an event,
/// once completed the lay outing on the page.
typedef EndPageLayoutCallback = void Function(
    Object sender, EndPageLayoutArgs args);
