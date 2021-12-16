import 'matrix_helper.dart';

/// internal class
class GraphicObjectData {
  /// internal constructor
  GraphicObjectData() {
    mitterLength = 0;
    horizontalScaling = 100;
    rise = 0;
    transformMatrixTM = MatrixHelper(0, 0, 0, 0, 0, 0);
    characterSpacing = 0;
    wordSpacing = 0;
    nonStrokingOpacity = 1;
    strokingOpacity = 1;
    textLeading = 0;
    fontSize = 0;
  }

  //Fields
  /// internal field
  MatrixHelper? currentTransformationMatrix;

  /// internal field
  MatrixHelper? drawing2dMatrixCTM;

  /// internal field
  MatrixHelper? documentMatrix;

  /// internal field
  MatrixHelper? textLineMatrix;

  /// internal field
  MatrixHelper? textMatrix;

  /// internal field
  MatrixHelper? textMatrixUpdate;

  /// internal field
  MatrixHelper? transformMatrixTM;

  /// internal field
  double? horizontalScaling;

  /// internal field
  double? mitterLength;

  /// internal field
  int? rise;

  /// internal field
  double? characterSpacing;

  /// internal field
  double? wordSpacing;

  /// internal field
  double? nonStrokingOpacity;

  /// internal field
  double? strokingOpacity;

  /// internal field
  String? currentFont;

  /// internal field
  double? textLeading;

  /// internal field
  double? fontSize;
}

/// internal class
class GraphicsObject {
  /// internal constructor
  GraphicsObject() {
    transformMatrix = MatrixHelper(1, 0, 0, 1, 0, 0);
  }

  /// internal field
  MatrixHelper? transformMatrix;
  GraphicsState? _graphicState;

  //Implementation
  /// internal method
  GraphicsState? save() {
    _graphicState = GraphicsState();
    _graphicState!._transformMatrix = transformMatrix;
    return _graphicState;
  }

  /// internal method
  void restore(GraphicsState graphicState) {
    transformMatrix = graphicState._transformMatrix;
  }

  /// internal method
  void multiplyTransform(MatrixHelper matrix) {
    transformMatrix = transformMatrix! * matrix;
  }

  /// internal method
  void scaleTransform(double scaleX, double scaleY) {
    transformMatrix = transformMatrix!.scale(scaleX, scaleY, 0, 0);
  }

  /// internal method
  void translateTransform(double offsetX, double offsetY) {
    transformMatrix = transformMatrix!.translate(offsetX, offsetY);
  }

  /// internal method
  void rotateTransform(double angle) {
    transformMatrix = transformMatrix!.rotate(angle, 0, 0);
  }
}

/// internal class
class GraphicsState {
  MatrixHelper? _transformMatrix;
}
