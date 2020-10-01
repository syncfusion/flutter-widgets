part of pdf;

/// Represents marker for ordered list.
class PdfOrderedMarker extends PdfMarker {
  /// Initializes a new instance of the [PdfOrderedMarker] class.
  PdfOrderedMarker(
      {this.style, PdfFont font, String suffix = '', String delimiter = ''}) {
    _delimiter = delimiter;
    _suffix = suffix;
    this.font = font;
  }

  /// Holds numbering style.
  PdfNumberStyle style = PdfNumberStyle.none;

  /// Start number for ordered list.
  int _startNumber = 1;

  /// Delimiter for numbers.
  String _delimiter;

  /// Finalizer for numbers.
  String _suffix;

  /// Current index of item.
  int _currentIndex;

  /// Gets start number for ordered list. Default value is 1.
  int get startNumber => _startNumber;

  /// Sets start number for ordered list. Default value is 1.
  set startNumber(int value) {
    if (value <= 0) {
      throw ArgumentError('Start number should be greater than 0');
    }
    _startNumber = value;
  }

  /// Gets the delimiter.
  String get delimiter {
    if (_delimiter == '' || _delimiter == null) {
      return '.';
    }
    return _delimiter;
  }

  /// Sets the delimiter.
  set delimiter(String value) => _delimiter = value;

  /// Gets the suffix of the marker.
  String get suffix {
    if (_suffix == null || _suffix == '') {
      return '.';
    }
    return _suffix;
  }

  /// Sets the suffix of the marker.
  set suffix(String value) => _suffix = value;

  /// Gets the marker number.
  String _getNumber() {
    return _PdfNumberConvertor._convert(_startNumber + _currentIndex, style);
  }
}
