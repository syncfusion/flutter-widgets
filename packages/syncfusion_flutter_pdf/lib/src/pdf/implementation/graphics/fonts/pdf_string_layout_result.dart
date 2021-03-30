part of pdf;

class _PdfStringLayoutResult {
  _PdfStringLayoutResult() {
    _lineHeight = 0;
    _size = _Size.empty;
  }
  late double _lineHeight;
  late _Size _size;
  List<_LineInfo>? _lines;
  //ignore:unused_field
  String? _remainder;

  bool get _isEmpty => _lines == null || (_lines != null && _lines!.isEmpty);
  int get _lineCount => (!_isEmpty) ? _lines!.length : 0;
}
