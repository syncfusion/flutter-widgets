part of pdf;

/// Represents an annotation object with holds link on
/// another location within a document.
class PdfDocumentLinkAnnotation extends PdfLinkAnnotation {
  // constructor
  /// Initializes new [PdfDocumentLinkAnnotation] instance
  /// with specified bounds and destination.
  PdfDocumentLinkAnnotation(Rect bounds, PdfDestination destination)
      : super(bounds) {
    ArgumentError.checkNotNull(destination, 'destination');
    this.destination = destination;
  }

  PdfDocumentLinkAnnotation._(
      _PdfDictionary dictionary, _PdfCrossTable crossTable)
      : super._(dictionary, crossTable);

  // fields
  PdfDestination _destination;

  // properties
  /// Gets the destination of the annotation.
  PdfDestination get destination =>
      _isLoadedAnnotation ? _obtainDestination() : _destination;

  /// Sets the destination of the annotation.
  set destination(PdfDestination value) {
    ArgumentError.checkNotNull(value, 'destibation');
    if (value != _destination) {
      _destination = value;
    }
    if (_isLoadedAnnotation) {
      _dictionary.setProperty(_DictionaryProperties.dest, value);
    }
  }

  // implementation
  // Gets the destination of the document link annotation
  PdfDestination _obtainDestination() {
    PdfDestination _destination;
    if (_dictionary.containsKey(_DictionaryProperties.dest)) {
      final _IPdfPrimitive obj =
          _crossTable._getObject(_dictionary[_DictionaryProperties.dest]);
      final _PdfArray array = obj as _PdfArray;
      PdfPage page;
      if (array[0] is _PdfReferenceHolder) {
        final _PdfDictionary dic = _crossTable
            ._getObject(array[0] as _PdfReferenceHolder) as _PdfDictionary;
        page = _crossTable._document.pages._getPage(dic);
        final _PdfName mode = array[1] as _PdfName;
        if (page != null && mode != null) {
          if (mode._name == 'XYZ') {
            final _PdfNumber left = array[2] as _PdfNumber;
            final _PdfNumber top = array[3] as _PdfNumber;
            final _PdfNumber zoom = array[4] as _PdfNumber;
            final double topValue =
                (top == null) ? 0 : page.size.height - (top.value.toDouble());
            final double leftValue = (left == null) ? 0 : left.value.toDouble();
            _destination = PdfDestination(page, Offset(leftValue, topValue));
            if (zoom != null) {
              _destination.zoom = zoom.value.toDouble();
            }
          } else if (mode._name == 'Fit') {
            _destination = PdfDestination(page);
            _destination.mode = PdfDestinationMode.fitToPage;
          } else if (mode._name == 'FitH') {
            final _PdfNumber top = array[2] as _PdfNumber;
            final double topValue = (page.size.height - top.value).toDouble();
            _destination = PdfDestination(page, Offset(0, topValue));
            _destination.mode = PdfDestinationMode.fitH;
          } else if (mode._name == 'FitR') {
            if (array.count == 6) {
              final double left = (array[2] as _PdfNumber).value.toDouble();
              final double top = (array[3] as _PdfNumber).value.toDouble();
              final double width = (array[4] as _PdfNumber).value.toDouble();
              final double height = (array[5] as _PdfNumber).value.toDouble();
              _destination =
                  PdfDestination._(page, _Rectangle(left, top, width, height));
              _destination.mode = PdfDestinationMode.fitR;
            }
          }
        }
      }
    } else if (_dictionary.containsKey(_DictionaryProperties.a) &&
        (_destination == null)) {
      _IPdfPrimitive obj =
          _crossTable._getObject(_dictionary[_DictionaryProperties.a]);
      final _PdfDictionary destDic = obj as _PdfDictionary;
      obj = destDic[_DictionaryProperties.d];
      if (obj is _PdfReferenceHolder) {
        obj = (obj as _PdfReferenceHolder).object;
      }
      final _PdfArray array = obj as _PdfArray;
      if (array != null) {
        final _PdfReferenceHolder holder = array[0] as _PdfReferenceHolder;
        PdfPage page;
        if (holder != null) {
          final _IPdfPrimitive primitiveObj =
              _PdfCrossTable._dereference(holder);
          final _PdfDictionary dic = primitiveObj as _PdfDictionary;
          if (dic != null) {
            page = _crossTable._document.pages._getPage(dic);
          }
        }
        if (page != null) {
          final _PdfName mode = array[1] as _PdfName;
          if (mode._name == 'FitBH' || mode._name == 'FitH') {
            final _PdfNumber top = array[2] as _PdfNumber;
            final double topValue =
                (top == null) ? 0 : page.size.height - (top.value.toDouble());
            _destination = PdfDestination(page, Offset(0, topValue));
            _destination.mode = PdfDestinationMode.fitH;
          } else if (mode._name == 'XYZ') {
            final _PdfNumber left = array[2] as _PdfNumber;
            final _PdfNumber top = array[3] as _PdfNumber;
            final _PdfNumber zoom = array[4] as _PdfNumber;
            if (page != null) {
              final double topValue =
                  (top == null) ? 0 : page.size.height - (top.value.toDouble());
              final double leftValue =
                  (left == null) ? 0 : left.value.toDouble();
              _destination = PdfDestination(page, Offset(leftValue, topValue));
              if (zoom != null) {
                _destination.zoom = zoom.value.toDouble();
              }
              _destination.mode = PdfDestinationMode.location;
            }
          } else if (mode._name == 'FitR') {
            if (array.count == 6) {
              final _PdfNumber left = array[2] as _PdfNumber;
              final _PdfNumber bottom = array[3] as _PdfNumber;
              final _PdfNumber right = array[4] as _PdfNumber;
              final _PdfNumber top = array[5] as _PdfNumber;
              _destination = PdfDestination._(
                  page,
                  _Rectangle(left.value.toDouble(), bottom.value.toDouble(),
                      right.value.toDouble(), top.value.toDouble()));
              _destination.mode = PdfDestinationMode.fitR;
            }
          } else {
            if (page != null && mode._name == 'Fit') {
              _destination = PdfDestination(page);
              _destination.mode = PdfDestinationMode.fitToPage;
            }
          }
        }
      }
    }
    return _destination;
  }

  @override
  void _save() {
    super._save();
    if (_destination != null) {
      _dictionary.setProperty(
          _PdfName(_DictionaryProperties.dest), _destination._element);
    }
  }

  @override
  _IPdfPrimitive _element;
}
