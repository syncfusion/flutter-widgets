part of pdf;

class _PdfUtils {
  static const List<int> _jpegSignature = <int>[255, 216];
  static const List<int> _pngSignature = <int>[137, 80, 78, 71, 13, 10, 26, 10];
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
}
