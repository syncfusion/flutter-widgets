part of pdf;

/// Represents the widget annotation.
class _WidgetAnnotation extends PdfAnnotation {
  //Constructor
  _WidgetAnnotation() : super._() {
    _alignment = PdfTextAlignment.left;
    _widgetAppearance = _WidgetAppearance();
    _highlightMode = PdfHighlightMode.invert;
  }

  _WidgetAnnotation._(_PdfDictionary dictionary, _PdfCrossTable crossTable)
      : super._internal(dictionary, crossTable);

  //Fields
  _PdfDefaultAppearance? _defaultAppearance;
  PdfField? _parent;
  PdfTextAlignment? _alignment;
  PdfAnnotationBorder? _widgetBorder;
  _WidgetAppearance? _widgetAppearance;
  PdfHighlightMode? _highlightMode;
  _PdfExtendedAppearance? _extendedAppearance;
  String? _appearState;
  PdfAnnotationActions? _actions;

  //Events
  _SavePdfPrimitiveCallback? _beginSave;

  //Properties
  /// Gets the default appearance.
  _PdfDefaultAppearance get defaultAppearance {
    return _defaultAppearance ??= _PdfDefaultAppearance();
  }

  /// Sets the parent.
  set parent(PdfField? value) {
    if (_parent != value) {
      _parent = value;
      _parent != null
          ? _dictionary.setProperty(
              _DictionaryProperties.parent, _PdfReferenceHolder(_parent))
          : _dictionary.remove(_DictionaryProperties.parent);
    }
  }

  /// Gets and sets the text alignment.
  PdfTextAlignment? get textAlignment => _alignment;
  set textAlignment(PdfTextAlignment? value) {
    if (_alignment != value) {
      _alignment = value;
      _dictionary.setProperty(
          _DictionaryProperties.q, _PdfNumber(_alignment!.index));
    }
  }

  /// Gets or sets the highlighting mode.
  PdfHighlightMode? get highlightMode =>
      _isLoadedAnnotation ? _obtainHighlightMode() : _highlightMode;
  set highlightMode(PdfHighlightMode? value) {
    _highlightMode = value;
    _dictionary._setName(_PdfName(_DictionaryProperties.h),
        _highlightModeToString(_highlightMode));
  }

  _PdfExtendedAppearance? get extendedAppearance {
    _extendedAppearance ??= _PdfExtendedAppearance();
    return _extendedAppearance;
  }

  set extendedAppearance(_PdfExtendedAppearance? value) {
    _extendedAppearance = value;
  }

  set _appearanceState(String value) {
    if (_appearState != value) {
      _appearState = value;
      _dictionary._setName(
          _PdfName(_DictionaryProperties.usageApplication), _appearState);
    }
  }

  PdfAnnotationActions? get actions {
    if (_actions == null) {
      _actions = PdfAnnotationActions();
      _dictionary.setProperty(_DictionaryProperties.aa, _actions);
    }
    return _actions;
  }

  set actions(PdfAnnotationActions? value) {
    if (value != null) {
      _actions = value;
      _dictionary.setProperty(_DictionaryProperties.aa, _actions);
    }
  }

  //Implementations
  @override
  void _save() {
    if (_pdfAppearance == null &&
        _page!._document != null &&
        (_page!._document!._conformanceLevel == PdfConformanceLevel.a1b ||
            _page!._document!._conformanceLevel == PdfConformanceLevel.a2b ||
            _page!._document!._conformanceLevel == PdfConformanceLevel.a3b)) {
      throw ArgumentError(
          'The appearance dictionary doesn\'t contain an entry in the conformance PDF.');
    }
    super._save();
    _onBeginSave();
    if (_extendedAppearance != null) {
      _dictionary.setProperty(_DictionaryProperties.ap, _extendedAppearance);
      _dictionary.setProperty(_DictionaryProperties.mk, _widgetAppearance);
    } else {
      _dictionary.setProperty(_DictionaryProperties.ap, null);
      bool isSignatureField = false;
      _dictionary.setProperty(
          _DictionaryProperties.ap,
          _pdfAppearance != null && _pdfAppearance!._templateNormal != null
              ? _pdfAppearance
              : null);
      if (_dictionary.containsKey(_DictionaryProperties.ft)) {
        final _IPdfPrimitive? signatureName =
            _PdfCrossTable._dereference(_dictionary[_DictionaryProperties.ft]);
        if (signatureName is _PdfName &&
            signatureName._name == _DictionaryProperties.sig) {
          isSignatureField = true;
        }
      }
      if (!isSignatureField) {
        _dictionary.setProperty(_DictionaryProperties.mk, _widgetAppearance);
      }
      _dictionary.setProperty(_DictionaryProperties.usageApplication, null);
    }
    if (_defaultAppearance != null) {
      _dictionary.setProperty(_DictionaryProperties.da,
          _PdfString(_defaultAppearance!._toString()));
    }
  }

  @override
  void _initialize() {
    super._initialize();
    _dictionary._setNumber(_DictionaryProperties.f, 4); //Sets print.
    _dictionary.setProperty(
        _DictionaryProperties.subtype, _PdfName(_DictionaryProperties.widget));
    _dictionary.setProperty(_DictionaryProperties.bs,
        _widgetBorder ??= PdfAnnotationBorder._asWidgetBorder());
  }

  String _highlightModeToString(PdfHighlightMode? highlightingMode) {
    switch (highlightingMode) {
      case PdfHighlightMode.noHighlighting:
        return 'N';
      case PdfHighlightMode.outline:
        return 'O';
      case PdfHighlightMode.push:
        return 'P';
      default:
        return 'I';
    }
  }

  void _onBeginSave({_SavePdfPrimitiveArgs? args}) {
    if (_beginSave != null) {
      _beginSave!(this, args);
    }
  }

  PdfHighlightMode _obtainHighlightMode() {
    PdfHighlightMode mode = PdfHighlightMode.noHighlighting;
    if (_dictionary.containsKey(_DictionaryProperties.h)) {
      final _PdfName name = _dictionary[_DictionaryProperties.h] as _PdfName;
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
