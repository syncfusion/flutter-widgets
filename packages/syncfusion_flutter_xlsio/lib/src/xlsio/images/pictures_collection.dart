part of xlsio;

/// Represents worksheet collection.
class PicturesCollection {
  /// Create an instance of Pictures collection.
  PicturesCollection(Worksheet sheet) {
    _worksheet = sheet;
    _pictures = [];
  }

  // Parent workbook
  Worksheet _worksheet;

  // Collection of worksheet
  List<Picture> _pictures;

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
  Picture operator [](index) {
    return _pictures[index];
  }

  /// Add styles to the collection
  Picture addFile(int topRow, int leftColumn, String fileName) {
    if (fileName == null || fileName == '') {
      throw Exception('name should not be null or empty');
    }

    final Picture picture = Picture(File(fileName).readAsBytesSync());
    picture.row = topRow;
    picture.column = leftColumn;
    _pictures.add(picture);
    return picture;
  }

  /// Add styles to the collection
  Picture addStream(int topRow, int leftColumn, List<int> stream) {
    if (stream == null || stream.isEmpty) {
      throw Exception('stream should not be null or empty');
    }

    final Picture picture = Picture(stream);
    picture.row = topRow;
    picture.column = leftColumn;
    _pictures.add(picture);
    return picture;
  }

  /// Add styles to the collection
  Picture addBase64(int topRow, int leftColumn, String base64Data) {
    if (base64Data == null || base64Data == '') {
      throw Exception('base64Data should not be null or empty');
    }

    final Picture picture = Picture(base64.decode(base64Data));
    picture.row = topRow;
    picture.column = leftColumn;
    _pictures.add(picture);
    return picture;
  }

  /// clear the Picture.
  void clear() {
    if (_pictures != null) {
      for (final Picture picture in _pictures) {
        picture.clear();
      }
      _pictures.clear();
    }
  }
}
