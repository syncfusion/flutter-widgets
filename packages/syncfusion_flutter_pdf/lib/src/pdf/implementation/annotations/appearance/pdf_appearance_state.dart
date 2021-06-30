part of pdf;

/// Represents the states of an annotation's appearance.
class _PdfAppearanceState implements _IPdfWrapper {
  //Constructor
  /// Initializes a new instance of the [PdfAppearanceState] class.
  _PdfAppearanceState() : super() {
    _dictionary._beginSave = _dictionaryBeginSave;
  }

  //Fields
  final _PdfDictionary _dictionary = _PdfDictionary();
  PdfTemplate? _on;
  PdfTemplate? _off;
  // ignore: prefer_final_fields
  String _onMappingName = _DictionaryProperties.yes;
  static const String _offMappingName = _DictionaryProperties.off;

  //Properties
  /// Gets the active state template.
  PdfTemplate? get activate => _on;

  /// Sets the active state template.
  set activate(PdfTemplate? value) {
    if (value != _on) {
      _on = value;
    }
  }

  /// Gets or sets the inactive state.
  PdfTemplate? get off => _off;
  set off(PdfTemplate? value) {
    if (value != _off) {
      _off = value;
    }
  }

  //Implementation
  void _dictionaryBeginSave(Object sender, _SavePdfPrimitiveArgs? ars) {
    if (_on != null) {
      _dictionary.setProperty(_onMappingName, _PdfReferenceHolder(_on));
    }
    if (_off != null) {
      _dictionary.setProperty(_offMappingName, _PdfReferenceHolder(_off));
    }
  }

  @override
  _IPdfPrimitive get _element => _dictionary;

  @override
  // ignore: unused_element
  set _element(_IPdfPrimitive? value) {
    _element = value;
  }
}
