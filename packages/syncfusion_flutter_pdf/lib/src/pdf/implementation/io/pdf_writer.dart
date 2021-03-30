part of pdf;

/// Helper class to write PDF primitive elements easily.
class _PdfWriter implements _IPdfWriter {
  //Constructor
  _PdfWriter(List<int> buffer) {
    _buffer = buffer;
    _length = buffer.length;
    _position = buffer.length;
  }

  //Fields
  List<int>? _buffer;

  //_IPdfWriter members
  @override
  PdfDocument? _document;
  @override
  //ignore:unused_field
  int? _length;
  @override
  int? _position;
  @override
  void _write(dynamic data, [int? end]) {
    if (data == null) {
      throw ArgumentError.value(data, 'data', 'value cannot be null');
    }
    if (data is int) {
      _write(data.toString());
    } else if (data is double) {
      String value = data.toStringAsFixed(2);
      if (value.endsWith('.00')) {
        if (value.length == 3) {
          value = '0';
        } else {
          value = value.substring(0, value.length - 3);
        }
      }
      _write(value);
    } else if (data is String) {
      _write(utf8.encode(data));
    } else if (data is _IPdfPrimitive) {
      data.save(this);
    } else if (data is List<int>) {
      int length;
      if (end == null) {
        length = data.length;
      } else {
        length = end;
      }
      _length = _length! + length;
      _position = _position! + length;
      if (end == null) {
        _buffer!.addAll(data);
      } else {
        _buffer!.addAll(data.take(end));
      }
    }
  }
}
