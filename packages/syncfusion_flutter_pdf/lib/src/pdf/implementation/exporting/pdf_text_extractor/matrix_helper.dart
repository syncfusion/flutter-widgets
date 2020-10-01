part of pdf;

class _MatrixHelper {
  //constructor
  _MatrixHelper(double m11, double m12, double m21, double m22, double offsetX,
      double offsetY) {
    this.m11 = m11;
    this.m12 = m12;
    this.m21 = m21;
    this.m22 = m22;
    this.offsetX = offsetX;
    this.offsetY = offsetY;
    type = _MatrixTypes.unknown;
    _checkMatrixType();
  }

  //static fields
  static _MatrixHelper get identity =>
      _MatrixHelper(1.0, 0.0, 0.0, 1.0, 0.0, 0.0);

  //Fields
  double m11;
  double m12;
  double m21;
  double m22;
  double offsetX;
  double offsetY;
  _MatrixTypes type;

  //Implementation
  _MatrixHelper operator *(_MatrixHelper matrix) {
    return _MatrixHelper(
        m11 * matrix.m11 + m12 * matrix.m21,
        m11 * matrix.m12 + m12 * matrix.m22,
        m21 * matrix.m11 + m22 * matrix.m21,
        m21 * matrix.m12 + m22 * matrix.m22,
        offsetX * matrix.m11 + offsetY * matrix.m21 + matrix.offsetX,
        offsetX * matrix.m12 + offsetY * matrix.m22 + matrix.offsetY);
  }

  _MatrixHelper _translate(double offsetX, double offsetY) {
    if (type == _MatrixTypes.identity) {
      _setMatrix(
          1.0, 0.0, 0.0, 1.0, offsetX, offsetY, _MatrixTypes.translation);
    } else {
      if (type == _MatrixTypes.unknown) {
        this.offsetX += offsetX;
        this.offsetY += offsetY;
      } else {
        this.offsetX += offsetX;
        this.offsetY += offsetY;
        type = _getType(
            _getTypeIndex(type) | _getTypeIndex(_MatrixTypes.translation));
      }
    }
    return this;
  }

  void _setMatrix(double m11, double m12, double m21, double m22,
      double offsetX, double offsetY, _MatrixTypes type) {
    this.m11 = m11;
    this.m12 = m12;
    this.m21 = m21;
    this.m22 = m22;
    this.offsetX = offsetX;
    this.offsetY = offsetY;
    this.type = type;
  }

  void _checkMatrixType() {
    type = _MatrixTypes.identity;
    if (m21 != 0.0 || m12 != 0.0) {
      type = _MatrixTypes.unknown;
      return;
    }
    if (m11 != 1.0 || m22 != 1.0) {
      type = _MatrixTypes.scaling;
    }
    if (offsetX != 0.0 || offsetY != 0.0) {
      type = _getType(
          _getTypeIndex(type) | _getTypeIndex(_MatrixTypes.translation));
    }
    if (_getTypeIndex(type) & 3 == _getTypeIndex(_MatrixTypes.identity)) {
      type = _MatrixTypes.identity;
    }
  }

  _MatrixTypes _getType(int typeIndex) {
    if (typeIndex == 0) {
      return _MatrixTypes.identity;
    } else if (typeIndex == 1) {
      return _MatrixTypes.translation;
    } else if (typeIndex == 2) {
      return _MatrixTypes.scaling;
    } else if (typeIndex == 3) {
      return _MatrixTypes.scalingAndTranslation;
    } else if (typeIndex == 4) {
      return _MatrixTypes.unknown;
    } else {
      throw ArgumentError.value(typeIndex);
    }
  }

  int _getTypeIndex(_MatrixTypes type) {
    switch (type) {
      case _MatrixTypes.identity:
        return 0;
        break;
      case _MatrixTypes.translation:
        return 1;
        break;
      case _MatrixTypes.scaling:
        return 2;
        break;
      case _MatrixTypes.scalingAndTranslation:
        return 3;
        break;
      case _MatrixTypes.unknown:
        return 4;
        break;
      default:
        throw ArgumentError.value(type);
        break;
    }
  }

  _MatrixHelper _scale(
      double scaleX, double scaleY, double centerX, double centerY) {
    final _MatrixHelper newMatrix =
        _MatrixHelper(scaleX, 0.0, 0.0, scaleY, centerX, centerY) * this;
    _setMatrix(newMatrix.m11, newMatrix.m12, newMatrix.m21, newMatrix.m22,
        newMatrix.offsetX, newMatrix.offsetY, newMatrix.type);
    return this;
  }

  _MatrixHelper _rotate(double angle, double centerX, double centerY) {
    angle = 3.1415926535897931 * angle / 180.0;
    final double num1 = sin(angle);
    final double num2 = cos(angle);
    _MatrixHelper matrix = _MatrixHelper(
        num2,
        num1,
        -num1,
        num2,
        centerX * (1.0 - num2) + centerY * num1,
        centerY * (1.0 - num2) - centerX * num1);
    matrix.type = _MatrixTypes.unknown;
    matrix *= this;
    _setMatrix(matrix.m11, matrix.m12, matrix.m21, matrix.m22, matrix.offsetX,
        matrix.offsetY, matrix.type);
    return this;
  }

  Offset _transform(Offset point) {
    return Offset(point.dx * m11 + point.dy * m21 + offsetX,
        point.dx * m12 + point.dy * m22 + offsetY);
  }

  _MatrixHelper _clone() {
    final _MatrixHelper result =
        _MatrixHelper(m11, m12, m21, m22, offsetX, offsetY);
    result.type = type;
    return result;
  }
}

enum _MatrixTypes {
  identity,
  translation,
  scaling,
  scalingAndTranslation,
  unknown
}
