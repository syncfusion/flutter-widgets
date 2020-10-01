part of pdf;

class _PdfTemplateValuePair {
  // constructor
  _PdfTemplateValuePair([PdfTemplate template, String value]) {
    this.template = template;
    this.value = value;
  }

  // field
  PdfTemplate _template;
  String _value;

  // properties

  PdfTemplate get template => _template;
  set template(PdfTemplate value) {
    ArgumentError.checkNotNull(value, 'template');
    _template = value;
  }

  String get value => _value;
  set value(String value) {
    ArgumentError.checkNotNull(value, 'value');
    _value = value;
  }
}
