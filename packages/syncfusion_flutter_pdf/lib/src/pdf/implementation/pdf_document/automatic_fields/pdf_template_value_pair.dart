part of pdf;

class _PdfTemplateValuePair {
  // constructor
  _PdfTemplateValuePair(PdfTemplate template, String value) {
    this.template = template;
    this.value = value;
  }

  // field
  late PdfTemplate template;
  late String value;
}
