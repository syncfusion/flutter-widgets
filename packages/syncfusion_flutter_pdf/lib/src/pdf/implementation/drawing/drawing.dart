part of pdf;

/// Represents the size values.
class _Size {
  /// Initializes the [_Size] class.
  _Size(this.width, this.height);

  _Size.fromSize(Size size) {
    width = size.width;
    height = size.height;
  }

  @override
  // ignore: avoid_equals_and_hash_code_on_mutable_classes
  bool operator ==(Object other) {
    return other is _Size && width == other.width && height == other.height;
  }

  @override
  // ignore: avoid_equals_and_hash_code_on_mutable_classes
  int get hashCode => width.hashCode;

  /// Gets or sets the width value.
  late double width;

  /// Gets or sets the height value.
  late double height;

  /// Gets the empty size.
  static _Size get empty => _Size(0, 0);

  Size get size => Size(width, height);
}

/// Represents the point values.
class _Point {
  /// Initializes the [_Point] class.
  _Point(this.x, this.y);
  _Point.fromOffset(Offset location) {
    x = location.dx;
    y = location.dy;
  }

  @override
  // ignore: avoid_equals_and_hash_code_on_mutable_classes
  bool operator ==(Object other) {
    return other is _Point && x == other.x && y == other.y;
  }

  @override
  // ignore: avoid_equals_and_hash_code_on_mutable_classes
  int get hashCode => x.hashCode;

  /// Gets or sets the x value.
  late double x;

  /// Gets or sets the y value.
  late double y;

  /// Gets the empty [_Point].
  static _Point get empty => _Point(0, 0);

  Offset get offset => Offset(x, y);
}

/// Represents the rectangle values.
class _Rectangle {
  /// Intialize the [_Rectangle] class.
  _Rectangle(this.x, this.y, this.width, this.height);

  _Rectangle.fromRect(Rect rect) {
    x = rect.left;
    y = rect.top;
    width = rect.width;
    height = rect.height;
  }

  @override
  // ignore: avoid_equals_and_hash_code_on_mutable_classes
  bool operator ==(Object other) {
    return other is _Rectangle &&
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
  _Point get location => _Point(x, y);

  /// Sets the [location].
  set location(_Point value) {
    x = value.x;
    y = value.y;
  }

  /// Gets the [size].
  _Size get size => _Size(width, height);

  /// Sets the [size].
  set size(_Size value) {
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

  /// Gets the empty [_Rectangle].
  static _Rectangle get empty => _Rectangle(0, 0, 0, 0);

  Rect get rect => Rect.fromLTWH(x, y, width, height);

  ///Clones the instance of a rectangle.
  _Rectangle _clone() {
    return _Rectangle(x, y, width, height);
  }
}
