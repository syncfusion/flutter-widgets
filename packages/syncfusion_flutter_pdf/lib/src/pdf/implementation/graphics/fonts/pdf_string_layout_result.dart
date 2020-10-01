part of pdf;

class _PdfStringLayoutResult {
  _PdfStringLayoutResult() {
    _initialize();
  }
  double _lineHeight;
  List<_LineInfo> _lines;
  _Size _size;
  //ignore:unused_field
  String _remainder;
  //Implementation
  void _initialize() {
    _lineHeight = 0;
    _size = _Size.empty;
  }

  bool get _isEmpty => _lines == null || (_lines != null && _lines.isEmpty);
  int get _lineCount => (!_isEmpty) ? _lines.length : 0;
}
