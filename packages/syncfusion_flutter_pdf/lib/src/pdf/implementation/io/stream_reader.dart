part of pdf;

class _StreamReader {
  //Constructor
  _StreamReader(List<int> data) {
    if (data == null || data.isEmpty) {
      ArgumentError.value(data, 'data cannot be null or empty');
    }
    _data = data;
    position = 0;
  }

  //Fields
  List<int> _data;
  int position;

  //Properties
  int get length => _data.length;

  //Implementation
  int readByte() {
    if (position != length) {
      final int result = _data[position];
      position++;
      return result;
    } else {
      return -1;
    }
  }
}
