part of xlsio;

/// Represents worksheet collection.
class PicturesCollection {
  /// Create an instance of Pictures collection.
  PicturesCollection(Worksheet sheet) {
    _worksheet = sheet;
    _pictures = <Picture>[];
  }

  // Parent workbook
  late Worksheet _worksheet;

  // Collection of worksheet
  late List<Picture> _pictures;

  /// Represents parent workbook
  Worksheet get worksheet {
    return _worksheet;
  }

  /// Collection of worksheet
  List<Picture> get innerList {
    return _pictures;
  }

  /// Returns the count of pivot reference collection.
  int get count {
    return _pictures.length;
  }

  /// Indexer of the class
  Picture operator [](dynamic index) {
    return _pictures[index];
  }

  /// Add styles to the collection
  ///
  /// ```dart
  /// Workbook workbook = new Workbook();
  /// Worksheet sheet = workbook.worksheets[0];
  /// List<int> bytes = File('image.png').readAsBytesSync();
  /// sheet.picutes.addStream(1, 1, bytes);
  /// List<int> bytes = workbook.saveAsStream();
  /// File('Picutes.xlsx').writeAsBytes(bytes);
  /// workbook.dispose();
  /// ```
  Picture addStream(int topRow, int leftColumn, List<int> stream) {
    if (stream.isEmpty) {
      throw Exception('stream should not be null or empty');
    }

    final Picture picture = Picture(stream);
    picture.row = topRow;
    picture.column = leftColumn;
    _pictures.add(picture);
    return picture;
  }

  /// Add styles to the collection
  ///
  /// ```dart
  /// Workbook workbook = new Workbook();
  /// Worksheet sheet = workbook.worksheets[0];
  /// String base64Image = base64Encode(File('image.png').readAsBytesSync());
  /// sheet.picutes.addBase64(1, 1, base64Image);
  /// List<int> bytes = workbook.saveAsStream();
  /// File('Picutes.xlsx').writeAsBytes(bytes);
  /// workbook.dispose();
  /// ```
  Picture addBase64(int topRow, int leftColumn, String base64Data) {
    if (base64Data == '') {
      throw Exception('base64Data should not be null or empty');
    }

    final Picture picture = Picture(base64.decode(base64Data));
    picture.row = topRow;
    picture.column = leftColumn;
    _pictures.add(picture);
    return picture;
  }

  /// clear the Picture.
  void _clear() {
    for (final Picture picture in _pictures) {
      picture._clear();
    }
    _pictures.clear();
  }
}
