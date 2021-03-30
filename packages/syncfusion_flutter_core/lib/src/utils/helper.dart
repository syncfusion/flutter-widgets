part of core;

/// Holds the arguments for the event onTooltipRender.
///
/// Event is triggered when the tooltip is rendered, which allows you to customize tooltip arguments.
class TooltipRenderArgs {
  /// Creating an argument constructor of TooltipArgs class.
  TooltipRenderArgs(this.header, this.text, this.location);

  /// Text for the tooltip main content.
  String? text;

  /// Text for the tooltip header to be shown.
  String? header;

  /// The location at which the tooltip is shown
  Offset? location;
}

/// Used to align the tootip content.
///
/// Tooltip alignment supports the below alignments.
enum TooltipAlignment {
  ///- TooltipAlignment.near, will align the tooltip content nearby to center.
  near,

  ///- TooltipAlignment.center, will align the tooltip content at center.
  center,

  ///- TooltipAlignment.far, will align the tooltip content far from center.
  far
}

/// Data marker shapes.
///
/// Data marker supports the below shapes.
/// If the shape is DataMarkerType.image, specify the image path in the imageUrl property of markerSettings.
enum DataMarkerType {
  ///- DataMarkerType.cicle, will render marker shape  circle.
  circle,

  ///- DataMarkerType.rectangle, will render marker shape  rectangle.
  rectangle,

  ///- DataMarkerType.image, will render marker image.
  image,

  ///- DataMarkerType.pentagon, will render marker shape  pentagon.
  pentagon,

  ///- DataMarkerType.verticalLine, will render marker verticalLine.
  verticalLine,

  ///- DataMarkerType.horizontalLine, will render marker horizontalLine.
  horizontalLine,

  ///- DataMarkerType.diamond, will render marker shape  diamond.
  diamond,

  ///- DataMarkerType.triangle, will render marker shape  triangle.
  triangle,

  ///- DataMarkerType.invertedTriangle, will render marker shape  invertedTriangle.
  invertedTriangle,

  ///- DataMarkerType.none, will skip rendering marker.
  none,
}

/// Draw different marker shapes by using height and width
class ShapeMaker {
  /// Draw the circle shape marker
  static void drawCircle(
      Path path, double x, double y, double width, double height) {
    path.addArc(
        Rect.fromLTRB(
            x - width / 2, y - height / 2, x + width / 2, y + height / 2),
        0.0,
        2 * math.pi);
  }

  /// Draw the Rectangle shape marker
  static void drawRectangle(
      Path path, double x, double y, double width, double height) {
    path.addRect(Rect.fromLTRB(
        x - width / 2, y - height / 2, x + width / 2, y + height / 2));
  }

  ///Draw the Pentagon shape marker
  static void drawPentagon(
      Path path, double x, double y, double width, double height) {
    const int eq = 72;
    double xValue;
    double yValue;
    for (int i = 0; i <= 5; i++) {
      xValue = width / 2 * math.cos((math.pi / 180) * (i * eq));
      yValue = height / 2 * math.sin((math.pi / 180) * (i * eq));
      i == 0
          ? path.moveTo(x + xValue, y + yValue)
          : path.lineTo(x + xValue, y + yValue);
    }
    path.close();
  }

  ///Draw the Vertical line shape marker
  static void drawVerticalLine(
      Path path, double x, double y, double width, double height) {
    path.moveTo(x, y + height / 2);
    path.lineTo(x, y - height / 2);
  }

  ///Draw the Inverted Triangle shape marker
  static void drawInvertedTriangle(
      Path path, double x, double y, double width, double height) {
    path.moveTo(x + width / 2, y - height / 2);

    path.lineTo(x, y + height / 2);
    path.lineTo(x - width / 2, y - height / 2);
    path.lineTo(x + width / 2, y - height / 2);
    path.close();
  }

  ///Draw the Horizontal line shape marker
  static void drawHorizontalLine(
      Path path, double x, double y, double width, double height) {
    path.moveTo(x - width / 2, y);
    path.lineTo(x + width / 2, y);
  }

  ///Draw the Diamond shape marker
  static void drawDiamond(
      Path path, double x, double y, double width, double height) {
    path.moveTo(x - width / 2, y);
    path.lineTo(x, y + height / 2);
    path.lineTo(x + width / 2, y);
    path.lineTo(x, y - height / 2);
    path.lineTo(x - width / 2, y);
    path.close();
  }

  ///Draw the Triangle shape marker
  static void drawTriangle(
      Path path, double x, double y, double width, double height) {
    path.moveTo(x - width / 2, y + height / 2);
    path.lineTo(x + width / 2, y + height / 2);
    path.lineTo(x, y - height / 2);
    path.lineTo(x - width / 2, y + height / 2);
    path.close();
  }
}

/// This method measures the size for given text and textstyle
Size measureText(String textValue, TextStyle textStyle, [int? angle]) {
  Size size;
  final TextPainter textPainter = TextPainter(
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
      text: TextSpan(text: textValue, style: textStyle));
  textPainter.layout();

  if (angle != null) {
    final Rect rect = rotatedTextSize(textPainter.size, angle);
    size = Size(rect.width, rect.height);
  } else {
    size = Size(textPainter.width, textPainter.height);
  }
  return size;
}

/// This method returns the rect for given size and angle
Rect rotatedTextSize(Size size, int angle) {
  final Rect rect = Rect.fromLTWH(0, 0, size.width, size.height);
  final vector.Matrix2 _rotatorMatrix =
      vector.Matrix2.rotation(degreeToRadian(angle));

  final Rect movedToCenterAsOrigin = rect.shift(-rect.center);

  Offset _topLeft = movedToCenterAsOrigin.topLeft;
  Offset _topRight = movedToCenterAsOrigin.topRight;
  Offset _bottomLeft = movedToCenterAsOrigin.bottomLeft;
  Offset _bottomRight = movedToCenterAsOrigin.bottomRight;

  _topLeft = transform(_rotatorMatrix, _topLeft);
  _topRight = transform(_rotatorMatrix, _topRight);
  _bottomLeft = transform(_rotatorMatrix, _bottomLeft);
  _bottomRight = transform(_rotatorMatrix, _bottomRight);

  final List<Offset> rotOffsets = <Offset>[
    _topLeft,
    _topRight,
    _bottomLeft,
    _bottomRight
  ];

  final double minX =
      rotOffsets.map((Offset offset) => offset.dx).reduce(math.min);
  final double maxX =
      rotOffsets.map((Offset offset) => offset.dx).reduce(math.max);
  final double minY =
      rotOffsets.map((Offset offset) => offset.dy).reduce(math.min);
  final double maxY =
      rotOffsets.map((Offset offset) => offset.dy).reduce(math.max);

  final Rect rotateRect = Rect.fromPoints(
    Offset(minX, minY),
    Offset(maxX, maxY),
  );
  return rotateRect;
}

/// This method converts the corresponding degrees to radian
double degreeToRadian(int deg) => deg * (math.pi / 180);

/// This method converts the corresponding Offset to Vector2
vector.Vector2 offsetToVector2(Offset offset) =>
    vector.Vector2(offset.dx, offset.dy);

/// This method converts the corresponding Vector2 to Offset
Offset vector2ToOffset(vector.Vector2 vector) => Offset(vector.x, vector.y);

/// This method transforms the given offset with respect ot the given matrix
Offset transform(
  vector.Matrix2 matrix,
  Offset offset,
) {
  return vector2ToOffset(matrix * offsetToVector2(offset));
}

/// This method returns the maximum lines in the given text content
int getMaxLinesContent(String? text) {
  return text != null && text.isNotEmpty && text.contains('\n')
      ? text.split('\n').length
      : 1;
}
