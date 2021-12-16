import 'dart:math';
import '../drawing/drawing.dart';

/// Class for representing Root transformation matrix.
class PdfTransformationMatrix {
  //Constructor
  ///Initializes a new instance of the [PdfTransformationMatrix] class as the
  PdfTransformationMatrix() {
    matrix = Matrix(<double>[1, 0, 0, 1, 0, 0]);
  }

  //Fields
  /// internal field
  late Matrix matrix;

  //Implementation
  /// internal method
  void translate(double offsetX, double offsetY) {
    matrix.translate(offsetX, offsetY);
  }

  /// internal method
  void scale(double scaleX, double scaleY) {
    matrix.scale(scaleX, scaleY);
  }

  /// internal method
  void multiply(PdfTransformationMatrix matrix) {
    this.matrix.multiply(matrix.matrix);
  }

  /// internal method
  void rotate(double angle) {
    angle = double.parse(
        (angle * 3.1415926535897931 / 180).toStringAsExponential(9));
    matrix.elements[0] = cos(angle);
    matrix.elements[1] = sin(angle);
    matrix.elements[2] = -sin(angle);
    matrix.elements[3] = cos(angle);
  }

  /// internal method
  void skew(double angleX, double angleY) {
    matrix.multiply(Matrix(<double>[
      1,
      tan((pi / 180) * angleX),
      tan((pi / 180) * angleY),
      1,
      0,
      0
    ]));
  }

  /// internal method
  String getString() {
    String builder = '';
    const String whitespace = ' ';
    for (int i = 0; i < matrix.elements.length; i++) {
      String value = matrix.elements[i].toStringAsFixed(2);
      if (value.endsWith('.00')) {
        if (value.length == 3) {
          value = '0';
        } else {
          value = value.substring(0, value.length - 3);
        }
      }
      builder += value + whitespace;
    }
    return builder;
  }
}

/// Encapsulates a 3-by-3 affine matrix that represents a geometric transform.
class Matrix {
  // Constructor
  /// Initializes a new instance of the [Matrix] class as the
  Matrix(this.elements);

  //Fields
  /// internal field
  late List<double> elements;

  // Properties
  double? get _offsetX => elements[4];
  double? get _offsetY => elements[5];

  // Implementation
  /// internal field
  void translate(double offsetX, double offsetY) {
    elements[4] = offsetX;
    elements[5] = offsetY;
  }

  // ignore: unused_element
  /// internal method
  PdfPoint transform(PdfPoint point) {
    final double x = point.x;
    final double y = point.y;
    final double x2 = x * elements[0] + y * elements[2] + _offsetX!;
    final double y2 = x * elements[1] + y * elements[3] + _offsetY!;
    return PdfPoint(x2, y2);
  }

  /// internal method
  void scale(double scaleX, double scaleY) {
    elements[0] = scaleX;
    elements[3] = scaleY;
  }

  /// internal method
  void multiply(Matrix matrix) {
    final List<double> tempMatrix = List<double>.filled(6, 0, growable: true);
    tempMatrix[0] =
        (elements[0] * matrix.elements[0]) + (elements[1] * matrix.elements[2]);
    tempMatrix[1] =
        (elements[0] * matrix.elements[1]) + (elements[1] * matrix.elements[3]);
    tempMatrix[2] =
        (elements[2] * matrix.elements[0]) + (elements[3] * matrix.elements[2]);
    tempMatrix[3] =
        (elements[2] * matrix.elements[1]) + (elements[3] * matrix.elements[3]);
    tempMatrix[4] = (_offsetX! * matrix.elements[0]) +
        (_offsetY! * matrix.elements[2] + matrix._offsetX!);
    tempMatrix[5] = (_offsetX! * matrix.elements[1]) +
        (_offsetY! * matrix.elements[3] + matrix._offsetY!);
    for (int i = 0; i < tempMatrix.length; i++) {
      elements[i] = tempMatrix[i];
    }
  }
}
