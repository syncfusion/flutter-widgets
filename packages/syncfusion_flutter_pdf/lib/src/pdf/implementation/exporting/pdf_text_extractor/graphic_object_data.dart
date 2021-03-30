part of pdf;

class _GraphicObjectData {
  //constructor
  _GraphicObjectData() {
    _mitterLength = 0;
    _horizontalScaling = 100;
    rise = 0;
    transformMatrixTM = _MatrixHelper(0, 0, 0, 0, 0, 0);
    characterSpacing = 0;
    wordSpacing = 0;
    _nonStrokingOpacity = 1;
    _strokingOpacity = 1;
    textLeading = 0;
    fontSize = 0;
  }

  //Fields
  _MatrixHelper? currentTransformationMatrix;
  _MatrixHelper? drawing2dMatrixCTM;
  _MatrixHelper? documentMatrix;
  _MatrixHelper? textLineMatrix;
  _MatrixHelper? textMatrix;
  _MatrixHelper? textMatrixUpdate;
  _MatrixHelper? transformMatrixTM;
  double? _horizontalScaling;
  double? _mitterLength;
  int? rise;
  double? characterSpacing;
  double? wordSpacing;
  double? _nonStrokingOpacity;
  double? _strokingOpacity;
  String? currentFont;
  double? textLeading;
  double? fontSize;
}

class _GraphicsObject {
  _GraphicsObject() {
    _transformMatrix = _MatrixHelper(1, 0, 0, 1, 0, 0);
  }
  _MatrixHelper? _transformMatrix;
  _GraphicsState? _graphicState;

  //Implementation
  _GraphicsState? _save() {
    _graphicState = _GraphicsState();
    _graphicState!._transformMatrix = _transformMatrix;
    return _graphicState;
  }

  void _restore(_GraphicsState graphicState) {
    _transformMatrix = graphicState._transformMatrix;
  }

  void _multiplyTransform(_MatrixHelper matrix) {
    _transformMatrix = _transformMatrix! * matrix;
  }

  void _scaleTransform(double scaleX, double scaleY) {
    _transformMatrix = _transformMatrix!._scale(scaleX, scaleY, 0, 0);
  }

  void _translateTransform(double offsetX, double offsetY) {
    _transformMatrix = _transformMatrix!._translate(offsetX, offsetY);
  }

  void _rotateTransform(double angle) {
    _transformMatrix = _transformMatrix!._rotate(angle, 0, 0);
  }
}

class _GraphicsState {
  _MatrixHelper? _transformMatrix;
}
