import 'dart:ui';

/// Represents the size values.
class PdfSize {
  /// Initializes the [PdfSize] class.
  PdfSize(this.width, this.height);

  /// internal constructor
  PdfSize.fromSize(Size size) {
    width = size.width;
    height = size.height;
  }

  @override
  // ignore: avoid_equals_and_hash_code_on_mutable_classes
  bool operator ==(Object other) {
    return other is PdfSize && width == other.width && height == other.height;
  }

  @override
  // ignore: avoid_equals_and_hash_code_on_mutable_classes
  int get hashCode => width.hashCode;

  /// Gets or sets the width value.
  late double width;

  /// Gets or sets the height value.
  late double height;

  /// Gets the empty size.
  static PdfSize get empty => PdfSize(0, 0);

  /// internal property
  Size get size => Size(width, height);
}

/// Represents the point values.
class PdfPoint {
  /// Initializes the [PdfPoint] class.
  PdfPoint(this.x, this.y);

  /// internal constructor
  PdfPoint.fromOffset(Offset location) {
    x = location.dx;
    y = location.dy;
  }

  @override
  // ignore: avoid_equals_and_hash_code_on_mutable_classes
  bool operator ==(Object other) {
    return other is PdfPoint && x == other.x && y == other.y;
  }

  @override
  // ignore: avoid_equals_and_hash_code_on_mutable_classes
  int get hashCode => x.hashCode;

  /// Gets or sets the x value.
  late double x;

  /// Gets or sets the y value.
  late double y;

  /// Gets the empty [PdfPoint].
  static PdfPoint get empty => PdfPoint(0, 0);

  /// internal property
  Offset get offset => Offset(x, y);
}

/// Represents the rectangle values.
class PdfRectangle {
  /// Intialize the [PdfRectangle] class.
  PdfRectangle(this.x, this.y, this.width, this.height);

  /// internal constructor
  PdfRectangle.fromRect(Rect rect) {
    x = rect.left;
    y = rect.top;
    width = rect.width;
    height = rect.height;
  }

  @override
  // ignore: avoid_equals_and_hash_code_on_mutable_classes
  bool operator ==(Object other) {
    return other is PdfRectangle &&
        x == other.x &&
        y == other.y &&
        height == other.height &&
        width == other.width;
  }

  @override
  // ignore: avoid_equals_and_hash_code_on_mutable_classes
  int get hashCode => x.hashCode;

  /// Gets or sets the [x] value.
  late double x;

  /// Gets or sets the [y] value.
  late double y;

  /// Gets or sets the [width] value.
  late double width;

  /// Gets or sets the [height] value.
  late double height;

  /// Gets the [location].
  PdfPoint get location => PdfPoint(x, y);

  /// Sets the [location].
  set location(PdfPoint value) {
    x = value.x;
    y = value.y;
  }

  /// Gets the [size].
  PdfSize get size => PdfSize(width, height);

  /// Sets the [size].
  set size(PdfSize value) {
    width = value.width;
    height = value.height;
  }

  /// Gets the left.
  double get left => x;

  /// Gets the top.
  double get top => y;

  /// Gets the right.
  double get right => x + width;

  /// Gets the bottom.
  double get bottom => y + height;

  /// Gets the empty [PdfRectangle].
  static PdfRectangle get empty => PdfRectangle(0, 0, 0, 0);

  /// internal property
  Rect get rect => Rect.fromLTWH(x, y, width, height);

  ///Clones the instance of a rectangle.
  PdfRectangle clone() {
    return PdfRectangle(x, y, width, height);
  }
}
