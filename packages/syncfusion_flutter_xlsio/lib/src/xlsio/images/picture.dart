part of xlsio;

/// Represent the Excel image.
class Picture {
  /// Create an instances of Picture class.
  Picture(List<int> imageData) {
    img.Image image;
    if (isPng(imageData)) {
      image = img.decodePng(imageData);
    } else if (isJpeg(imageData)) image = img.decodeJpg(imageData);
    _imageData = imageData;
    height = image.height;
    width = image.width;
  }

  static const List<int> _jpegSignature = <int>[255, 216];
  static const List<int> _pngSignature = <int>[137, 80, 78, 71, 13, 10, 26, 10];

  /// Gets/Sets the image String.
  String image;

  /// Gets/Sets the image data.
  List<int> _imageData;

  /// Gets/Sets the image row.
  int row;

  /// Gets/Sets the image column.
  int column;

  /// Gets/Sets the image last row.
  int lastRow;

  /// Gets/Sets the image last column.
  int lastColumn;

  /// Gets/Sets the image width.
  int width;

  /// Gets/Sets the image height.
  int height;

  /// Gets/Sets the image horizontal flip.
  bool horizontalFlip = false;

  /// Gets/Sets the image vertical flip.
  bool verticalFlip = false;

  /// Gets/Sets the image rotation.
  int rotation = 0;

  /// Gets/Sets the image last row offset.
  double lastRowOffset;

  /// Gets/Sets the image last column offset.
  double lastColOffset;

  /// Gets/Sets the image String.
  List<int> get imageData {
    return _imageData;
  }

  /// Check whether the picture is png.
  static bool isPng(List<int> imageData) {
    if (imageData.length >= _pngSignature.length) {
      for (int i = 0; i < _pngSignature.length; i++) {
        if (_pngSignature[i] != imageData[i]) {
          return false;
        }
      }
      return true;
    } else {
      return false;
    }
  }

  /// Check whether the picture is jpeg.
  static bool isJpeg(List<int> imageData) {
    if (imageData.length >= _jpegSignature.length) {
      for (int i = 0; i < _jpegSignature.length; i++) {
        if (_jpegSignature[i] != imageData[i]) {
          return false;
        }
      }
      return true;
    } else {
      return false;
    }
  }

  /// clear the image data.
  void clear() {
    if (_imageData != null) {
      _imageData = null;
    }
  }
}
