part of pdf;

/// Represents an annotation object with holds link on
/// another location within a document.
/// ```dart
/// //Create a new Pdf document
/// PdfDocument document = PdfDocument();
/// //Create a document link and add to the PDF page.
/// document.pages.add().annotations.add(PdfDocumentLinkAnnotation(
///     Rect.fromLTWH(10, 40, 30, 30),
///     PdfDestination(document.pages.add(), Offset(10, 0))));
/// //Save the document.
/// List<int> bytes = document.save();
/// //Dispose the document.
/// document.dispose();
/// ```
class PdfDocumentLinkAnnotation extends PdfLinkAnnotation {
  // constructor
  /// Initializes new [PdfDocumentLinkAnnotation] instance
  /// with specified bounds and destination.
  /// ```dart
  /// //Create a new Pdf document
  /// PdfDocument document = PdfDocument();
  /// //Create a document link and add to the PDF page.
  /// document.pages.add().annotations.add(PdfDocumentLinkAnnotation(
  ///     Rect.fromLTWH(10, 40, 30, 30),
  ///     PdfDestination(document.pages.add(), Offset(10, 0))));
  /// //Save the document.
  /// List<int> bytes = document.save();
  /// //Dispose the document.
  /// document.dispose();
  /// ```
  PdfDocumentLinkAnnotation(Rect bounds, PdfDestination destination)
      : super(bounds) {
    this.destination = destination;
  }

  PdfDocumentLinkAnnotation._(
      _PdfDictionary dictionary, _PdfCrossTable crossTable)
      : super._(dictionary, crossTable);

  // fields
  PdfDestination? _destination;

  // properties
  /// Gets or sets the destination of the annotation.
  ///
  /// ```dart
  /// //Create a new Pdf document
  /// PdfDocument document = PdfDocument();
  /// //Create PDF page.
  /// PdfPage page = document.pages.add();
  /// //Create a document link
  /// PdfDocumentLinkAnnotation documentLinkAnnotation = PdfDocumentLinkAnnotation(
  ///     Rect.fromLTWH(10, 40, 30, 30),
  ///     PdfDestination(document.pages.add(), Offset(10, 0)));
  /// //Gets the destination and set the destination mode.
  /// documentLinkAnnotation.destination!.mode = PdfDestinationMode.fitToPage;
  /// //Add the document link to the page
  /// page.annotations.add(documentLinkAnnotation);
  /// //Save the document.
  /// List<int> bytes = document.save();
  /// //Dispose the document.
  /// document.dispose();
  /// ```
  PdfDestination? get destination =>
      _isLoadedAnnotation ? _obtainDestination() : _destination;
  set destination(PdfDestination? value) {
    if (value != null) {
      if (value != _destination) {
        _destination = value;
      }
      if (_isLoadedAnnotation) {
        _dictionary.setProperty(_DictionaryProperties.dest, value);
      }
    }
  }

  // implementation
  // Gets the destination of the document link annotation
  PdfDestination? _obtainDestination() {
    PdfDestination? _destination;
    if (_dictionary.containsKey(_DictionaryProperties.dest)) {
      final _IPdfPrimitive? obj =
          _crossTable._getObject(_dictionary[_DictionaryProperties.dest]);
      _PdfArray? array;
      if (obj is _PdfArray) {
        array = obj;
      } else if (_crossTable._document != null &&
          _crossTable._document!._isLoadedDocument) {
        if (obj is _PdfName || obj is _PdfString) {
          array = _crossTable._document!._getNamedDestination(obj!);
        }
      }
      PdfPage page;
      if (array != null && array[0] is _PdfReferenceHolder) {
        final _PdfDictionary? dic = _crossTable
            ._getObject(array[0]! as _PdfReferenceHolder) as _PdfDictionary?;
        page = _crossTable._document!.pages._getPage(dic);
        final _PdfName? mode = array[1] as _PdfName?;
        if (mode != null) {
          if (mode._name == 'XYZ') {
            _PdfNumber? left;
            _PdfNumber? top;
            _PdfNumber? zoom;
            if (array[2] is _PdfNumber) {
              left = array[2]! as _PdfNumber;
            }
            if (array[3] is _PdfNumber) {
              top = array[3]! as _PdfNumber;
            }
            if (array[4] is _PdfNumber) {
              zoom = array[4]! as _PdfNumber;
            }
            final double topValue =
                (top == null) ? 0 : page.size.height - (top.value!.toDouble());
            final double leftValue =
                (left == null) ? 0 : left.value!.toDouble();
            _destination = PdfDestination(page, Offset(leftValue, topValue));
            if (zoom != null) {
              _destination.zoom = zoom.value!.toDouble();
            }
            _destination.mode = PdfDestinationMode.location;
          } else if (mode._name == 'Fit') {
            _destination = PdfDestination(page);
            _destination.mode = PdfDestinationMode.fitToPage;
          } else if (mode._name == 'FitH') {
            late _PdfNumber top;
            if (array[2] is _PdfNumber) {
              top = array[2]! as _PdfNumber;
            }
            final double topValue = (page.size.height - top.value!).toDouble();
            _destination = PdfDestination(page, Offset(0, topValue));
            _destination.mode = PdfDestinationMode.fitH;
          } else if (mode._name == 'FitR') {
            if (array.count == 6) {
              final double left = (array[2]! as _PdfNumber).value!.toDouble();
              final double top = (array[3]! as _PdfNumber).value!.toDouble();
              final double width = (array[4]! as _PdfNumber).value!.toDouble();
              final double height = (array[5]! as _PdfNumber).value!.toDouble();
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
          _crossTable._getObject(_dictionary[_DictionaryProperties.a])!;
      final _PdfDictionary destDic = obj as _PdfDictionary;
      obj = destDic[_DictionaryProperties.d]!;
      if (obj is _PdfReferenceHolder) {
        obj = obj.object!;
      }
      _PdfArray? array;
      if (obj is _PdfArray) {
        array = obj;
      } else if (_crossTable._document != null &&
          _crossTable._document!._isLoadedDocument) {
        if (obj is _PdfName || obj is _PdfString) {
          array = _crossTable._document!._getNamedDestination(obj);
        }
      }
      if (array != null && array[0] is _PdfReferenceHolder) {
        final _PdfReferenceHolder holder = array[0]! as _PdfReferenceHolder;
        PdfPage? page;
        final _IPdfPrimitive? primitiveObj =
            _PdfCrossTable._dereference(holder);
        final _PdfDictionary? dic = primitiveObj as _PdfDictionary?;
        if (dic != null) {
          page = _crossTable._document!.pages._getPage(dic);
        }
        if (page != null) {
          final _PdfName mode = array[1]! as _PdfName;
          if (mode._name == 'FitBH' || mode._name == 'FitH') {
            _PdfNumber? top;
            if (array[2] is _PdfNumber) {
              top = array[2]! as _PdfNumber;
            }
            final double topValue =
                (top == null) ? 0 : page.size.height - (top.value!.toDouble());
            _destination = PdfDestination(page, Offset(0, topValue));
            _destination.mode = PdfDestinationMode.fitH;
          } else if (mode._name == 'XYZ') {
            _PdfNumber? left;
            _PdfNumber? top;
            _PdfNumber? zoom;
            if (array[2] is _PdfNumber) {
              left = array[2]! as _PdfNumber;
            }
            if (array[3] is _PdfNumber) {
              top = array[3]! as _PdfNumber;
            }
            if (array[4] is _PdfNumber) {
              zoom = array[4]! as _PdfNumber;
            }
            final double topValue =
                (top == null) ? 0 : page.size.height - (top.value!.toDouble());
            final double leftValue =
                (left == null) ? 0 : left.value!.toDouble();
            _destination = PdfDestination(page, Offset(leftValue, topValue));
            if (zoom != null) {
              _destination.zoom = zoom.value!.toDouble();
            }
            _destination.mode = PdfDestinationMode.location;
          } else if (mode._name == 'FitR') {
            if (array.count == 6) {
              final _PdfNumber left = array[2]! as _PdfNumber;
              final _PdfNumber bottom = array[3]! as _PdfNumber;
              final _PdfNumber right = array[4]! as _PdfNumber;
              final _PdfNumber top = array[5]! as _PdfNumber;
              _destination = PdfDestination._(
                  page,
                  _Rectangle(left.value!.toDouble(), bottom.value!.toDouble(),
                      right.value!.toDouble(), top.value!.toDouble()));
              _destination.mode = PdfDestinationMode.fitR;
            }
          } else {
            if (mode._name == 'Fit') {
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
          _PdfName(_DictionaryProperties.dest), _destination!._element);
    }
  }

  @override
  _IPdfPrimitive? _element;
}
