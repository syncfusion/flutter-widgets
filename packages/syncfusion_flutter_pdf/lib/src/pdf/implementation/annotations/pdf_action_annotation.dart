part of pdf;

/// Represents the base class for the link annotations.
abstract class PdfLinkAnnotation extends PdfAnnotation {
  // constructor
  /// Initializes new instance of
  /// [PdfLinkAnnotation] class with specified bounds.
  PdfLinkAnnotation(Rect bounds) : super._(bounds: bounds);

  PdfLinkAnnotation._(_PdfDictionary dictionary, _PdfCrossTable crossTable)
      : super._internal(dictionary, crossTable);

  // fields
  PdfHighlightMode _highlightMode = PdfHighlightMode.noHighlighting;

  //properties
  /// Gets or sets the highlight mode of the link annotation.
  /// ```dart
  /// //Create a new Pdf document
  /// PdfDocument document = PdfDocument();
  /// //Create document link annotation and add to the PDF page.
  /// document.pages.add()
  ///   ..annotations.add(PdfDocumentLinkAnnotation(Rect.fromLTWH(10, 40, 30, 30),
  ///       PdfDestination(document.pages.add(), Offset(10, 0)))
  ///     ..highlightMode = PdfHighlightMode.outline);
  /// //Save the document.
  /// List<int> bytes = document.save();
  /// //Dispose the document.
  /// document.dispose();
  /// ```
  PdfHighlightMode get highlightMode =>
      _isLoadedAnnotation ? _obtainHighlightMode() : _highlightMode;
  set highlightMode(PdfHighlightMode value) {
    _highlightMode = value;
    final String mode = _getHighlightMode(_highlightMode);
    _dictionary._setName(_PdfName(_DictionaryProperties.h), mode);
  }

  // implementation
  @override
  void _initialize() {
    super._initialize();
    _dictionary.setProperty(_PdfName(_DictionaryProperties.subtype),
        _PdfName(_DictionaryProperties.link));
  }

  String _getHighlightMode(PdfHighlightMode mode) {
    String hightlightMode = 'N';
    switch (mode) {
      case PdfHighlightMode.invert:
        hightlightMode = 'I';
        break;
      case PdfHighlightMode.noHighlighting:
        hightlightMode = 'N';
        break;
      case PdfHighlightMode.outline:
        hightlightMode = 'O';
        break;
      case PdfHighlightMode.push:
        hightlightMode = 'P';
        break;
    }
    return hightlightMode;
  }

  PdfHighlightMode _obtainHighlightMode() {
    PdfHighlightMode mode = PdfHighlightMode.noHighlighting;
    if (_dictionary.containsKey(_DictionaryProperties.h)) {
      final _PdfName name = _dictionary[_DictionaryProperties.h]! as _PdfName;
      switch (name._name) {
        case 'I':
          mode = PdfHighlightMode.invert;
          break;
        case 'N':
          mode = PdfHighlightMode.noHighlighting;
          break;
        case 'O':
          mode = PdfHighlightMode.outline;
          break;
        case 'P':
          mode = PdfHighlightMode.push;
          break;
      }
    }
    return mode;
  }
}

/// Represents base class for link annotations with associated action.
abstract class PdfActionLinkAnnotation extends PdfLinkAnnotation {
  // constructor
  /// Initializes a new instance of the [PdfActionLinkAnnotation]
  ///  class with specified bounds and action to be performed.
  PdfActionLinkAnnotation(Rect bounds, [PdfAction? action]) : super(bounds) {
    if (action != null) {
      _action = action;
    }
  }

  PdfActionLinkAnnotation._(
      _PdfDictionary dictionary, _PdfCrossTable crossTable)
      : super._(dictionary, crossTable);

  // fields
  PdfAction? _action;

  // properties
  /// Gets or sets the action for the link annotation.
  PdfAction? get action => _action;
  set action(PdfAction? value) {
    if (value != null) {
      _action = value;
    }
  }
}

/// Represents the annotation with associated action.
class PdfActionAnnotation extends PdfActionLinkAnnotation {
  // constructor
  /// Initializes a new instance of the
  /// [PdfActionAnnotation] class with specified bounds and action.
  PdfActionAnnotation(Rect bounds, PdfAction action) : super(bounds, action);

  @override
  void _save() {
    super._save();
    _dictionary.setProperty(
        _PdfName(_DictionaryProperties.a), action!._element);
  }

  @override
  _IPdfPrimitive? _element;
}
