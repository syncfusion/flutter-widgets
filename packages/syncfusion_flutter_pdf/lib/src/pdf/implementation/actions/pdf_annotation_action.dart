part of pdf;

/// Represents additional actions of the annotations.
class PdfAnnotationActions implements _IPdfWrapper {
  //Constructor
  /// Initializes a new instance of the [PdfAnnotationActions] class.
  PdfAnnotationActions(
      {PdfAction? mouseEnter,
      PdfAction? mouseLeave,
      PdfAction? mouseUp,
      PdfAction? mouseDown,
      PdfAction? gotFocus,
      PdfAction? lostFocus}) {
    _initValues(
        mouseEnter, mouseLeave, mouseUp, mouseDown, gotFocus, lostFocus);
  }

  PdfAnnotationActions._loaded(_PdfDictionary? dictionary) {
    _dictionary = dictionary;
  }

  //Fields
  _PdfDictionary? _dictionary = _PdfDictionary();
  PdfAction? _mouseEnter;
  PdfAction? _mouseLeave;
  PdfAction? _mouseDown;
  PdfAction? _mouseUp;
  PdfAction? _gotFocus;
  PdfAction? _lostFocus;

  //Properties
  /// Gets or sets the action to be performed when the cursor
  /// enters the annotation’s
  PdfAction? get mouseEnter => _mouseEnter;
  set mouseEnter(PdfAction? value) {
    if (value != null && _mouseEnter != value) {
      _mouseEnter = value;
      _dictionary!.setProperty(_DictionaryProperties.e, _mouseEnter);
    }
  }

  /// Gets or sets the action to be performed when the cursor
  /// exits the annotation’s
  PdfAction? get mouseLeave => _mouseLeave;
  set mouseLeave(PdfAction? value) {
    if (value != null && _mouseLeave != value) {
      _mouseLeave = value;
      _dictionary!.setProperty(_DictionaryProperties.x, _mouseLeave);
    }
  }

  /// Gets or sets the action to be performed when the mouse button is pressed
  /// inside the annotation’s active area.
  PdfAction? get mouseDown => _mouseDown;
  set mouseDown(PdfAction? value) {
    if (value != null && _mouseDown != value) {
      _mouseDown = value;
      _dictionary!.setProperty(_DictionaryProperties.d, _mouseDown);
    }
  }

  /// Gets or sets the action to be performed when the mouse button is released
  PdfAction? get mouseUp => _mouseUp;
  set mouseUp(PdfAction? value) {
    if (value != null && _mouseUp != value) {
      _mouseUp = value;
      _dictionary!.setProperty(_DictionaryProperties.u, _mouseUp);
    }
  }

  /// Gets or sets the action to be performed when the annotation receives
  /// the input focus.
  PdfAction? get gotFocus => _gotFocus;
  set gotFocus(PdfAction? value) {
    if (value != null && _gotFocus != value) {
      _gotFocus = value;
      _dictionary!.setProperty(_DictionaryProperties.fo, _gotFocus);
    }
  }

  /// Gets or sets the action to be performed when the annotation loses the
  /// input focus.
  PdfAction? get lostFocus => _lostFocus;
  set lostFocus(PdfAction? value) {
    if (value != null && _lostFocus != value) {
      _lostFocus = value;
      _dictionary!.setProperty(_DictionaryProperties.bl, _lostFocus);
    }
  }

  // Implementation
  void _initValues(PdfAction? mEnter, PdfAction? mLeave, PdfAction? mUp,
      PdfAction? mDown, PdfAction? gotF, PdfAction? lostF) {
    if (mEnter != null) {
      mouseEnter = mEnter;
    }
    if (mLeave != null) {
      mouseLeave = mLeave;
    }
    if (mUp != null) {
      mouseUp = mUp;
    }
    if (mDown != null) {
      mouseDown = mDown;
    }
    if (gotF != null) {
      gotFocus = gotF;
    }
    if (lostF != null) {
      lostFocus = lostF;
    }
  }

  @override
  _IPdfPrimitive? get _element => _dictionary;

  @override
  // ignore: unused_element
  set _element(_IPdfPrimitive? value) {
    _element = value;
  }
}
