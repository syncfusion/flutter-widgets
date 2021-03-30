part of pdf;

/// Base class for elements lay outing.
abstract class _ElementLayouter {
  //Constructor
  /// Initializes a new instance of the [ElementLayouter] class.
  _ElementLayouter(PdfLayoutElement element) {
    _element = element;
  }

  //Fields
  /// Layout the element.
  PdfLayoutElement? _element;

  //Properties
  /// Gets  element`s layout.
  PdfLayoutElement? get element => _element;

  //Implementation
  PdfLayoutResult? _layout(_PdfLayoutParams param) {
    return _layoutInternal(param);
  }

  PdfLayoutResult? _layoutInternal(_PdfLayoutParams param);
  PdfPage? _getNextPage(PdfPage currentPage) {
    final PdfSection section = currentPage._section!;
    PdfPage? nextPage;
    final int index = section._indexOf(currentPage);
    if (index == section._count - 1) {
      nextPage = section.pages.add();
    } else {
      nextPage = section._getPageByIndex(index + 1);
    }
    return nextPage;
  }

  _Rectangle _getPaginateBounds(_PdfLayoutParams param) {
    return param.format!._boundsSet
        ? _Rectangle.fromRect(param.format!.paginateBounds)
        : _Rectangle(
            param.bounds!.x, 0, param.bounds!.width, param.bounds!.height);
  }
}

/// Represents a layouting format
class PdfLayoutFormat {
  //Constructor
  /// Initializes a new instance of the [PdfLayoutFormat] class.
  PdfLayoutFormat(
      {PdfLayoutType? layoutType,
      PdfLayoutBreakType? breakType,
      Rect? paginateBounds}) {
    this.breakType = breakType ?? PdfLayoutBreakType.fitPage;
    this.layoutType = layoutType ?? PdfLayoutType.paginate;
    if (paginateBounds != null) {
      _paginateBounds = _Rectangle.fromRect(paginateBounds);
      _boundsSet = true;
    } else {
      _paginateBounds = _Rectangle.empty;
      _boundsSet = false;
    }
  }

  /// Initializes a new instance of the [PdfLayoutFormat] class
  /// from an existing format.
  PdfLayoutFormat.fromFormat(PdfLayoutFormat baseFormat) {
    breakType = baseFormat.breakType;
    layoutType = baseFormat.layoutType;
    _paginateBounds = baseFormat._paginateBounds;
    _boundsSet = baseFormat._boundsSet;
  }

  //Fields
  /// Layout type of the element.
  PdfLayoutType layoutType = PdfLayoutType.paginate;

  /// Gets the bounds on the next page.
  Rect get paginateBounds => _paginateBounds.rect;

  /// Sets the bounds on the next page.
  set paginateBounds(Rect value) {
    _paginateBounds = _Rectangle.fromRect(value);
    _boundsSet = true;
  }

  /// Break type of the element.
  PdfLayoutBreakType breakType = PdfLayoutBreakType.fitPage;

  /// Indicates whether PaginateBounds were set and should be used or not.
  late bool _boundsSet;

  /// Bounds for the paginating.
  late _Rectangle _paginateBounds;
}

/// Represents the layouting result format.
class PdfLayoutResult {
  //Constructors
  /// Represents the layouting result format
  /// including bounds and resultant page.
  PdfLayoutResult._(PdfPage page, Rect bounds) {
    _page = page;
    _bounds = bounds;
  }

  //Fields
  /// The last page where the element was drawn.
  late PdfPage _page;

  /// The bounds of the element on the last page where it was drawn.
  late Rect _bounds;

  //Properties
  /// Gets the last page where the element was drawn.
  PdfPage get page => _page;

  /// Gets the bounds of the element on the last page where it was drawn.
  Rect get bounds => _bounds;
}

/// Represents the layouting parameters.
class _PdfLayoutParams {
  /// Gets and Sets Start lay outing page.
  PdfPage? page;

  /// Gets and Sets Lay outing bounds.
  _Rectangle? bounds;

  /// Gets and Sets Layout settings.
  PdfLayoutFormat? format;
}
