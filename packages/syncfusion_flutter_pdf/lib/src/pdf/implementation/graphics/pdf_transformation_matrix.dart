part of pdf;

/// Class for representing Root transformation matrix.
class _PdfTransformationMatrix {
  //Constructor
  ///Initializes a new instance of the [_PdfTransformationMatrix] class as the
  _PdfTransformationMatrix() {
    _matrix = _Matrix(<double>[1, 0, 0, 1, 0, 0]);
  }

  //Fields
  late _Matrix _matrix;

  //Implementation
  void _translate(double offsetX, double offsetY) {
    _matrix._translate(offsetX, offsetY);
  }

  void _scale(double scaleX, double scaleY) {
    _matrix._scale(scaleX, scaleY);
  }

  void _multiply(_PdfTransformationMatrix matrix) {
    _matrix._multiply(matrix._matrix);
  }

  void _rotate(double angle) {
    angle = double.parse(
        (angle * 3.1415926535897931 / 180).toStringAsExponential(9));
    _matrix._elements[0] = cos(angle);
    _matrix._elements[1] = sin(angle);
    _matrix._elements[2] = -sin(angle);
    _matrix._elements[3] = cos(angle);
  }

  String _toString() {
    String builder = '';
    const String whitespace = ' ';
    for (int i = 0; i < _matrix._elements.length; i++) {
      String value = _matrix._elements[i].toStringAsFixed(2);
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
class _Matrix {
  // Constructor
  ///Initializes a new instance of the [_Matrix] class as the
  _Matrix(List<double> elements) {
    _elements = elements;
  }

  //Fields
  late List<double> _elements;

  // Properties
  double? get _offsetX => _elements[4];
  double? get _offsetY => _elements[5];

  // Implementation
  void _translate(double offsetX, double offsetY) {
    _elements[4] = offsetX;
    _elements[5] = offsetY;
  }

  // ignore: unused_element
  _Point _transform(_Point point) {
    final double x = point.x;
    final double y = point.y;
    final double x2 = x * _elements[0] + y * _elements[2] + _offsetX!;
    final double y2 = x * _elements[1] + y * _elements[3] + _offsetY!;
    return _Point(x2, y2);
  }

  void _scale(double scaleX, double scaleY) {
    _elements[0] = scaleX;
    _elements[3] = scaleY;
  }

  void _multiply(_Matrix matrix) {
    final List<double> tempMatrix = List<double>.filled(6, 0, growable: true);
    tempMatrix[0] = (_elements[0] * matrix._elements[0]) +
        (_elements[1] * matrix._elements[2]);
    tempMatrix[1] = (_elements[0] * matrix._elements[1]) +
        (_elements[1] * matrix._elements[3]);
    tempMatrix[2] = (_elements[2] * matrix._elements[0]) +
        (_elements[3] * matrix._elements[2]);
    tempMatrix[3] = (_elements[2] * matrix._elements[1]) +
        (_elements[3] * matrix._elements[3]);
    tempMatrix[4] = (_offsetX! * matrix._elements[0]) +
        (_offsetY! * matrix._elements[2] + matrix._offsetX!);
    tempMatrix[5] = (_offsetX! * matrix._elements[1]) +
        (_offsetY! * matrix._elements[3] + matrix._offsetY!);
    for (int i = 0; i < tempMatrix.length; i++) {
      _elements[i] = tempMatrix[i];
    }
  }
}
