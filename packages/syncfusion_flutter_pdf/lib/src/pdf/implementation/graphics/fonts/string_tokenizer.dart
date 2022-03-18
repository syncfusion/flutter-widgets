/// Utility class for working with strings.
class StringTokenizer {
  //Constructor
  /// internal constructor
  StringTokenizer(String text) {
    _text = text;
    position = 0;
  }

  //Constants
  /// internal field
  static const String _tab = '\t';

  /// internal field
  static const String whiteSpace = ' ';

  /// internal field
  static const List<String> spaces = <String>[whiteSpace, _tab];

  //Fields
  String? _text;

  /// internal field
  int? position;

  //Properties
  /// internal property
  bool get isEndOfFile => position == _text!.length;

  /// internal property
  int get length => _text!.length;

  //Implementation
  /// internal method
  String? peekLine() {
    final int? tempPosition = position;
    final String? line = readLine();
    position = tempPosition;
    return line;
  }

  /// internal method
  String? readLine() {
    int tempPosition = position!;
    while (tempPosition < length) {
      final String character = _text![tempPosition];
      switch (character) {
        case '\r':
        case '\n':
          {
            final String text = _text!.substring(position!, tempPosition);
            position = tempPosition + 1;
            if (((character == '\r') && (position! < length)) &&
                (_text![position!] == '\n')) {
              position = position! + 1;
            }
            return text;
          }
      }
      tempPosition++;
    }
    if (tempPosition > position!) {
      final String result = _text!.substring(position!, tempPosition);
      position = tempPosition;
      return result;
    }
    return null;
  }

  /// internal method
  String? peekWord() {
    final int? tempPosition = position;
    final String? word = readWord();
    position = tempPosition;
    return word;
  }

  /// internal method
  String? readWord() {
    int tempPosition = position!;
    while (tempPosition < length) {
      final String character = _text![tempPosition];
      switch (character) {
        case '\r':
        case '\n':
          {
            final String text = _text!.substring(position!, tempPosition);
            position = tempPosition + 1;
            if (((character == '\r') && (position! < length)) &&
                (_text![position!] == '\n')) {
              position = position! + 1;
            }
            return text;
          }
        case ' ':
        case '\t':
          {
            if (tempPosition == position) {
              tempPosition++;
            }
            final String text = _text!.substring(position!, tempPosition);
            position = tempPosition;
            return text;
          }
      }
      tempPosition++;
    }
    if (tempPosition > position!) {
      final String result = _text!.substring(position!, tempPosition);
      position = tempPosition;
      return result;
    }
    return null;
  }

  /// internal method
  String peek() {
    return (!isEndOfFile) ? _text![position!] : '\u0000';
  }

  /// internal method
  String read([int? count]) {
    if (count != null) {
      int tempLength = 0;
      String builder = '';
      while (!isEndOfFile && tempLength < count) {
        final String character = read();
        builder += character;
        tempLength++;
      }
      return builder;
    } else {
      String character = '\u0000';
      if (!isEndOfFile) {
        character = _text![position!];
        position = position! + 1;
      }
      return character;
    }
  }

  /// internal method
  void close() {
    _text = null;
    position = null;
  }

  /// internal method
  static int getCharacterCount(String text, List<String> symbols) {
    int count = 0;
    for (int i = 0; i < text.length; i++) {
      final String character = text[i];
      if (contains(symbols, character)) {
        count++;
      }
    }
    return count;
  }

  /// internal method
  static bool contains(List<String> array, String symbol) {
    bool contains = false;
    for (int i = 0; i < array.length; i++) {
      if (array[i] == symbol) {
        contains = true;
        break;
      }
    }
    return contains;
  }

  /// internal method
  String? readToEnd() {
    final String? text =
        position == 0 ? _text : _text!.substring(position!, length);
    position = length;
    return text;
  }
}
