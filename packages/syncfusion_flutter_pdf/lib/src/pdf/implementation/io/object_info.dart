part of pdf;

class _ObjectInfo {
  //Constructors
  _ObjectInfo(_IPdfPrimitive? obj, [_PdfReference? reference]) {
    if (obj == null) {
      ArgumentError.notNull('obj');
    } else {
      _object = obj;
      if (reference != null) {
        _reference = reference;
      }
      _isModified = false;
    }
  }

  //Fields
  _IPdfPrimitive? _object;
  _PdfReference? _reference;
  late bool _isModified;

  //Properties
  bool? get _modified {
    if (_object is _IPdfChangable) {
      _isModified |= (_object as _IPdfChangable).changed!;
    }
    return _isModified;
  }

  //Implementation
  void _setReference(_PdfReference reference) {
    if (_reference != null) {
      throw ArgumentError.value(
          _reference, 'The object has the reference bound to it.');
    }
    _reference = reference;
  }

  @override
  String toString() {
    String reference = '';
    if (_reference != null) {
      reference = _reference.toString();
    }
    reference += ' : ' + _object.runtimeType.toString();
    return reference;
  }
}
