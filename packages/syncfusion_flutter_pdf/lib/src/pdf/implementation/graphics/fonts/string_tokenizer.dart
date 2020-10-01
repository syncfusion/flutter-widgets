part of pdf;

/// Utility class for working with strings.
class _StringTokenizer {
  //Constructor
  _StringTokenizer(String text) {
    ArgumentError.checkNotNull(text, 'text');
    _text = text;
    _position = 0;
  }

  //Constants
  static const String _tab = '\t';
  static const String _whiteSpace = ' ';
  static const List<String> _spaces = <String>[_whiteSpace, _tab];

  //Fields
  String _text;
  int _position;

  //Properties
  bool get _isEndOfFile => _position == _text.length;
  int get _length => _text.length;

  //Implementation
  String _peekLine() {
    final int position = _position;
    final String line = _readLine();
    _position = position;
    return line;
  }

  String _readLine() {
    int position = _position;
    while (position < _length) {
      final String character = _text[position];
      switch (character) {
        case '\r':
        case '\n':
          {
            final String text = _text.substring(_position, position);
            _position = position + 1;
            if (((character == '\r') && (_position < _length)) &&
                (_text[_position] == '\n')) {
              _position++;
            }
            return text;
          }
      }
      position++;
    }
    if (position > _position) {
      final String result = _text.substring(_position, position);
      _position = position;
      return result;
    }
    return null;
  }

  String _peekWord() {
    final int position = _position;
    final String word = _readWord();
    _position = position;
    return word;
  }

  String _readWord() {
    int position = _position;
    while (position < _length) {
      final String character = _text[position];
      switch (character) {
        case '\r':
        case '\n':
          {
            final String text = _text.substring(_position, position);
            _position = position + 1;
            if (((character == '\r') && (_position < _length)) &&
                (_text[_position] == '\n')) {
              _position++;
            }
            return text;
          }
        case ' ':
        case '\t':
          {
            if (position == _position) {
              position++;
            }
            final String text = _text.substring(_position, position);
            _position = position;
            return text;
          }
      }
      position++;
    }
    if (position > _position) {
      final String result = _text.substring(_position, position);
      _position = position;
      return result;
    }
    return null;
  }

  String _peek() {
    return (!_isEndOfFile) ? _text[_position] : '\0';
  }

  String _read([int count]) {
    if (count != null) {
      int length = 0;
      String builder = '';
      while (!_isEndOfFile && length < count) {
        final String character = _read();
        builder += character;
        length++;
      }
      return builder;
    } else {
      String character = '\0';
      if (!_isEndOfFile) {
        character = _text[_position];
        _position++;
      }
      return character;
    }
  }

  void _close() {
    _text = null;
    _position = null;
  }

  static int _getCharacterCount(String text, List<String> symbols) {
    ArgumentError.checkNotNull(text, 'text');
    ArgumentError.checkNotNull(symbols, 'symbols');
    int count = 0;
    for (int i = 0; i < text.length; i++) {
      final String character = text[i];
      if (_contains(symbols, character)) {
        count++;
      }
    }
    return count;
  }

  static bool _contains(List<String> array, String symbol) {
    bool contains = false;
    for (int i = 0; i < array.length; i++) {
      if (array[i] == symbol) {
        contains = true;
        break;
      }
    }
    return contains;
  }

  String _readToEnd() {
    final String text =
        _position == 0 ? _text : _text.substring(_position, _length);
    _position = _length;
    return text;
  }
}
