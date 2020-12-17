part of pdf;

/// Represents PDF Template object.
class PdfTemplate implements _IPdfWrapper {
  /// Initializes a new instance of the [PdfTemplate] class.
  PdfTemplate(double width, double height) {
    if (width != null && height != null) {
      _content = _PdfStream();
      _setSize(width, height);
      _content[_DictionaryProperties.type] =
          _PdfName(_DictionaryProperties.xObject);
      _content[_DictionaryProperties.subtype] =
          _PdfName(_DictionaryProperties.form);
    }
  }

  PdfTemplate._fromRect(Rect bounds) {
    _content = _PdfStream();
    _setBounds(bounds);
    _content[_DictionaryProperties.type] =
        _PdfName(_DictionaryProperties.xObject);
    _content[_DictionaryProperties.subtype] =
        _PdfName(_DictionaryProperties.form);
  }

  PdfTemplate._fromPdfStream(_PdfStream template) {
    ArgumentError.checkNotNull(template, 'Template stream can\'t be null');
    _content = template;
    final _IPdfPrimitive obj =
        _PdfCrossTable._dereference(_content[_DictionaryProperties.bBox]);
    final _Rectangle rect = (obj as _PdfArray).toRectangle();
    _size = rect.size;
    _isReadonly = true;
  }

  PdfTemplate._(Offset origin, Size size, List<int> stream,
      _PdfDictionary resources, bool isLoadedPage)
      : super() {
    if (size == Size.zero) {
      ArgumentError('The size of the new PdfTemplate can\'t be empty.');
    }
    ArgumentError.checkNotNull(stream, 'stream');
    _content = _PdfStream();
    if (origin.dx < 0 || origin.dy < 0) {
      _setSize(size.width, size.height, origin);
    } else {
      _setSize(size.width, size.height);
    }
    _initialize();
    _content._dataStream.addAll(stream);
    if (resources != null) {
      _content[_DictionaryProperties.resources] = _PdfDictionary(resources);
      _resources = _PdfResources(resources);
    }
    _isLoadedPageTemplate = isLoadedPage;
    _isReadonly = true;
  }

  //Fields
  _Size _size;
  _PdfStream _content;
  PdfGraphics _graphics;
  _PdfResources _resources;
  bool _writeTransformation;
  bool _isReadonly = false;
  bool _isLoadedPageTemplate = false;

  //Properties
  /// Gets the size of the template.
  Size get size => _size.size;

  /// Gets graphics context of the template.
  PdfGraphics get graphics {
    if (_isReadonly) {
      _graphics = null;
    } else if (_graphics == null) {
      _graphics = PdfGraphics._(size, _getResources, _content);
      _writeTransformation ??= true;
      if (_writeTransformation) {
        _graphics._initializeCoordinates();
      }
    }
    return _graphics;
  }

  //Public methods
  /// Resets an instance.
  void reset([double width, double height]) {
    if (width != null && height != null) {
      _setSize(size.width, size.height);
      reset();
    } else {
      if (_resources != null) {
        _resources = null;
        _content.remove(_DictionaryProperties.resources);
      }
      if (_graphics != null) {
        _graphics._reset(size);
      }
    }
  }

  //Implementation
  _PdfResources _getResources() {
    if (_resources == null) {
      _resources = _PdfResources();
      _content[_DictionaryProperties.resources] = _resources;
    }
    return _resources;
  }

  void _setSize(double width, double height, [Offset origin]) {
    if (origin != null) {
      final _PdfArray array = _PdfArray([origin.dx, origin.dy, width, height]);
      _content[_DictionaryProperties.bBox] = array;
      _size = _Size(width, height);
    } else {
      final _Rectangle rectangle = _Rectangle(0, 0, width, height);
      _content[_DictionaryProperties.bBox] = _PdfArray.fromRectangle(rectangle);
      _size = _Size(width, height);
    }
  }

  void _setBounds(Rect bounds) {
    final _Rectangle rect = _Rectangle.fromRect(bounds);
    final _PdfArray val = _PdfArray.fromRectangle(rect);
    _content[_DictionaryProperties.bBox] = val;
    _size = rect.size;
  }

  void _initialize() {
    _content[_DictionaryProperties.type] =
        _PdfName(_DictionaryProperties.xObject);
    _content[_DictionaryProperties.subtype] =
        _PdfName(_DictionaryProperties.form);
  }

  void _cloneResources(_PdfCrossTable crossTable) {
    if (_resources != null && crossTable != null) {
      final List<_PdfReference> prevReference = crossTable._prevReference;
      crossTable._prevReference = <_PdfReference>[];
      final _PdfDictionary resourceDict =
          _resources._clone(crossTable) as _PdfDictionary;
      crossTable._prevReference.addAll(prevReference);
      _resources = _PdfResources(resourceDict);
      _content[_DictionaryProperties.resources] = resourceDict;
    }
  }

  //_IPdfWrapper members
  @override
  _IPdfPrimitive get _element => _content;
  @override
  //ignore: unused_element
  set _element(_IPdfPrimitive value) {
    _content = value;
  }
}
