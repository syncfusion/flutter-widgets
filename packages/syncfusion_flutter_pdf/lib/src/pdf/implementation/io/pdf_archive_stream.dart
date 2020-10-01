part of pdf;

class _PdfArchiveStream extends _PdfStream {
  // Constructor
  _PdfArchiveStream(PdfDocument document) : super() {
    ArgumentError.notNull('document');
    _document = document;
    _objects = <int>[];
    _objectWriter = _PdfWriter(_objects);
    _objectWriter._document = _document;
    _indices = <Object, Object>{};
  }

  // Fields
  PdfDocument _document;
  _IPdfWriter _objectWriter;
  List<int> _objects;
  Map<Object, Object> _indices;
  _StreamWriter _writer;

  // Properties
  int get _objCount {
    if (_indices == null) {
      return 0;
    } else {
      return _indices.length;
    }
  }

  int _getIndex(int objNumber) {
    return _indices.values.toList().indexOf(objNumber);
  }

  // Implementation
  @override
  void save(_IPdfWriter writer) {
    final List<int> data = <int>[];
    _writer = _StreamWriter(data);
    _saveIndices();
    this[_DictionaryProperties.first] = _PdfNumber(_writer._position);
    _saveObjects();
    _dataStream = _writer._buffer;
    this[_DictionaryProperties.n] = _PdfNumber(_indices.length);
    this[_DictionaryProperties.type] = _PdfName('ObjStm');
    super.save(writer);
  }

  void _saveIndices() {
    for (final int position in _indices.keys) {
      _writer = _StreamWriter(_writer._buffer);
      _writer._write(_indices[position]);
      _writer._write(_Operators.whiteSpace);
      _writer._write(position);
      _writer._write(_Operators.newLine);
    }
  }

  void _saveObjects() {
    _writer._buffer.addAll(_objects);
  }

  void _saveObject(_IPdfPrimitive obj, _PdfReference reference) {
    final int position = _objectWriter._position;
    _indices[position] = reference._objNum;
    obj.save(_objectWriter);
    _objectWriter._write(_Operators.newLine);
  }
}

class _StreamWriter extends _IPdfWriter {
  // Constructor
  _StreamWriter(List<int> buffer) {
    _buffer = buffer;
    _length = buffer.length;
    _position = buffer.length;
  }

  //Fields
  List<int> _buffer;

  @override
  void _write(dynamic data) {
    if (data is List<int>) {
      for (int i = 0; i < data.length; i++) {
        _buffer.add(data[i]);
      }
      _length = _buffer.length;
      _position = _buffer.length;
    } else if (data is String) {
      _write(utf8.encode(data));
    } else if (data is int) {
      _write(data.toString());
    }
  }
}
