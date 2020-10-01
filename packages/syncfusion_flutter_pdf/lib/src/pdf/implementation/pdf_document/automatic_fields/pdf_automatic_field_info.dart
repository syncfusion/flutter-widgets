part of pdf;

class _PdfAutomaticFieldInfo {
  // constructor
  _PdfAutomaticFieldInfo(PdfAutomaticField field,
      [_Point location, double scalingX, double scalingY]) {
    this.field = field;
    this.location = location;
    scalingX = scalingX;
    scalingY = scalingY;
  }

  // fields
  _Point _location;
  PdfAutomaticField _field;
  double scalingX = 1;
  double scalingY = 1;

  // properties
  PdfAutomaticField get field => _field;
  set field(PdfAutomaticField value) {
    (value == null) ? throw ArgumentError.notNull('field') : _field = value;
  }

  _Point get location {
    _location ??= _Point.empty;
    return _location;
  }

  set location(_Point value) {
    if (value != null) {
      _location = value;
    }
  }
}

class _PdfAutomaticFieldInfoCollection extends PdfObjectCollection {
  // constructor
  _PdfAutomaticFieldInfoCollection() : super();

  // implementaion
  int add(_PdfAutomaticFieldInfo fieldInfo) {
    ArgumentError.checkNotNull(fieldInfo, 'fieldInfo');
    _list.add(fieldInfo);
    return count - 1;
  }
}
