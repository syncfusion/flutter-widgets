part of pdf;

/// Represents an anchor in the document where bookmarks
/// or annotations can direct when clicked.
class PdfDestination implements _IPdfWrapper {
  // constructor
  /// Initializes a new instance of the [PdfDestination] class with
  /// specified page and location.
  PdfDestination(PdfPage page, [Offset location]) {
    ArgumentError.checkNotNull(page, 'page');
    this.page = page;
    this.location = (location == null) ? Offset(0, _location.y) : location;
  }

  PdfDestination._(PdfPage page, _Rectangle rect) {
    ArgumentError.checkNotNull(page, 'page');
    this.page = page;
    location = rect.location.offset;
    _bounds = rect;
  }

  // fields
  double _zoom = 0;
  _Point _location = _Point.empty;
  _Rectangle _rect = _Rectangle.empty;
  PdfPage _page;
  final _PdfArray _array = _PdfArray();
  PdfDestinationMode _destinationMode;

  // Properties
  /// Gets zoom factor.
  double get zoom => _zoom;

  /// Sets zoom factor.
  set zoom(double value) {
    if (value != _zoom) {
      _zoom = value;
      _initializePrimitive();
    }
  }

  /// Gets a page where the destination is situated.
  PdfPage get page => _page;

  /// Sets a page where the destination is situated.
  set page(PdfPage value) {
    ArgumentError.checkNotNull(value, 'page');
    if (value != _page) {
      _page = value;
      _initializePrimitive();
    }
  }

  /// Gets mode of the destination.
  PdfDestinationMode get mode {
    _destinationMode ??= PdfDestinationMode.location;
    return _destinationMode;
  }

  /// Sets mode of the destination.
  set mode(PdfDestinationMode value) {
    if (value != _destinationMode) {
      _destinationMode = value;
      _initializePrimitive();
    }
  }

  /// Gets a location of the destination.
  Offset get location => _location.offset;

  /// Sets a location of the destination.
  set location(Offset value) {
    ArgumentError.checkNotNull(value);
    final _Point position = _Point.fromOffset(value);
    if (position != null && position != _location) {
      _location = position;
      _initializePrimitive();
    }
  }

  _Rectangle get _bounds => _rect;

  set _bounds(_Rectangle value) {
    if (_rect != value) {
      _rect = value;
      _initializePrimitive();
    }
  }

  // implementation
  void _initializePrimitive() {
    _array._clear();
    _array._add(_PdfReferenceHolder(_page));
    switch (mode) {
      case PdfDestinationMode.location:
        _Point point = _Point.empty;
        if (page._isLoadedPage) {
          point.x = _location.x;
          point.y = page.size.height - _location.y;
        } else {
          point = _pointToNativePdf(page, _Point(_location.x, _location.y));
        }
        _array._add(_PdfName(_DictionaryProperties.xyz));
        _array._add(_PdfNumber(point.x));
        _array._add(_PdfNumber(point.y));
        _array._add(_PdfNumber(_zoom));
        break;

      case PdfDestinationMode.fitToPage:
        _array._add(_PdfName(_DictionaryProperties.fit));
        break;

      case PdfDestinationMode.fitR:
        {
          _array._add(_PdfName(_DictionaryProperties.fitR));
          _array._add(_PdfNumber(_bounds.x));
          _array._add(_PdfNumber(_bounds.y));
          _array._add(_PdfNumber(_bounds.width));
          _array._add(_PdfNumber(_bounds.height));
        }
        break;

      case PdfDestinationMode.fitH:
        final PdfPage page = _page;
        double value = 0;
        if (page._isLoadedPage) {
          value = page.size.height - _location.y;
        } else {
          value = page.size.height - _location.y;
        }
        _array._add(_PdfName(_DictionaryProperties.fitH));
        _array._add(_PdfNumber(value));
        break;
    }
    _element = _array;
  }

  _Point _pointToNativePdf(PdfPage page, _Point point) {
    final PdfSection section = page._section;
    return section._pointToNativePdf(page, point);
  }

  @override
  _IPdfPrimitive _element;
}
