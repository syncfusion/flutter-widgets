import 'dart:math';
import 'dart:ui';

/// internal class
class MatrixHelper {
  /// internal constructor
  MatrixHelper(
      this.m11, this.m12, this.m21, this.m22, this.offsetX, this.offsetY) {
    type = MatrixTypes.unknown;
    _checkMatrixType();
  }

  /// internal property
  static MatrixHelper get identity =>
      MatrixHelper(1.0, 0.0, 0.0, 1.0, 0.0, 0.0);

  //Fields
  /// internal field
  late double m11;

  /// internal field
  late double m12;

  /// internal field
  late double m21;

  /// internal field
  late double m22;

  /// internal field
  late double offsetX;

  /// internal field
  late double offsetY;

  /// internal field
  late MatrixTypes type;

  //Implementation
  /// internal property
  MatrixHelper operator *(MatrixHelper matrix) {
    return MatrixHelper(
        m11 * matrix.m11 + m12 * matrix.m21,
        m11 * matrix.m12 + m12 * matrix.m22,
        m21 * matrix.m11 + m22 * matrix.m21,
        m21 * matrix.m12 + m22 * matrix.m22,
        offsetX * matrix.m11 + offsetY * matrix.m21 + matrix.offsetX,
        offsetX * matrix.m12 + offsetY * matrix.m22 + matrix.offsetY);
  }

  /// internal method
  MatrixHelper translate(double offsetX, double offsetY) {
    if (type == MatrixTypes.identity) {
      setMatrix(1.0, 0.0, 0.0, 1.0, offsetX, offsetY, MatrixTypes.translation);
    } else {
      if (type == MatrixTypes.unknown) {
        this.offsetX += offsetX;
        this.offsetY += offsetY;
      } else {
        this.offsetX += offsetX;
        this.offsetY += offsetY;
        type = _getType(
            _getTypeIndex(type) | _getTypeIndex(MatrixTypes.translation));
      }
    }
    return this;
  }

  /// internal method
  void setMatrix(double m11, double m12, double m21, double m22, double offsetX,
      double offsetY, MatrixTypes type) {
    this.m11 = m11;
    this.m12 = m12;
    this.m21 = m21;
    this.m22 = m22;
    this.offsetX = offsetX;
    this.offsetY = offsetY;
    this.type = type;
  }

  void _checkMatrixType() {
    type = MatrixTypes.identity;
    if (m21 != 0.0 || m12 != 0.0) {
      type = MatrixTypes.unknown;
      return;
    }
    if (m11 != 1.0 || m22 != 1.0) {
      type = MatrixTypes.scaling;
    }
    if (offsetX != 0.0 || offsetY != 0.0) {
      type = _getType(
          _getTypeIndex(type) | _getTypeIndex(MatrixTypes.translation));
    }
    if (_getTypeIndex(type) & 3 == _getTypeIndex(MatrixTypes.identity)) {
      type = MatrixTypes.identity;
    }
  }

  MatrixTypes _getType(int typeIndex) {
    if (typeIndex == 0) {
      return MatrixTypes.identity;
    } else if (typeIndex == 1) {
      return MatrixTypes.translation;
    } else if (typeIndex == 2) {
      return MatrixTypes.scaling;
    } else if (typeIndex == 3) {
      return MatrixTypes.scalingAndTranslation;
    } else if (typeIndex == 4) {
      return MatrixTypes.unknown;
    } else {
      throw ArgumentError.value(typeIndex, 'typeIndex', 'Invalid Type');
    }
  }

  int _getTypeIndex(MatrixTypes type) {
    switch (type) {
      case MatrixTypes.identity:
        return 0;
      case MatrixTypes.translation:
        return 1;
      case MatrixTypes.scaling:
        return 2;
      case MatrixTypes.scalingAndTranslation:
        return 3;
      case MatrixTypes.unknown:
        return 4;
    }
  }

  /// internal method
  MatrixHelper scale(
      double scaleX, double scaleY, double centerX, double centerY) {
    final MatrixHelper newMatrix =
        MatrixHelper(scaleX, 0.0, 0.0, scaleY, centerX, centerY) * this;
    setMatrix(newMatrix.m11, newMatrix.m12, newMatrix.m21, newMatrix.m22,
        newMatrix.offsetX, newMatrix.offsetY, newMatrix.type);
    return this;
  }

  /// internal method
  MatrixHelper rotate(double angle, double centerX, double centerY) {
    angle = 3.1415926535897931 * angle / 180.0;
    final double num1 = sin(angle);
    final double num2 = cos(angle);
    MatrixHelper matrix = MatrixHelper(
        num2,
        num1,
        -num1,
        num2,
        centerX * (1.0 - num2) + centerY * num1,
        centerY * (1.0 - num2) - centerX * num1);
    matrix.type = MatrixTypes.unknown;
    matrix *= this;
    setMatrix(matrix.m11, matrix.m12, matrix.m21, matrix.m22, matrix.offsetX,
        matrix.offsetY, matrix.type);
    return this;
  }

  /// internal method
  Offset transform(Offset point) {
    return Offset(point.dx * m11 + point.dy * m21 + offsetX,
        point.dx * m12 + point.dy * m22 + offsetY);
  }

  /// internal method
  MatrixHelper clone() {
    final MatrixHelper result =
        MatrixHelper(m11, m12, m21, m22, offsetX, offsetY);
    result.type = type;
    return result;
  }
}

/// internal enumerator
enum MatrixTypes {
  /// internal enumerator
  identity,

  /// internal enumerator
  translation,

  /// internal enumerator
  scaling,

  /// internal enumerator
  scalingAndTranslation,

  /// internal enumerator
  unknown
}
