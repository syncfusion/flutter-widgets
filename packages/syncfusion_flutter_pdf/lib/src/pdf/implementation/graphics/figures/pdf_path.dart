part of pdf;

/// Implements graphics path, which is a sequence of
/// primitive graphics elements.
class PdfPath extends PdfShapeElement {
  // constructor
  /// Initializes a new instance of the [PdfPath] class
  /// with pen, brush, fillMode, points and pathTypes
  PdfPath(
      {PdfPen pen,
      PdfBrush brush,
      PdfFillMode fillMode,
      List<Offset> points,
      List<int> pathTypes})
      : super._(pen: pen) {
    if (points != null && pathTypes != null) {
      addPath(points, pathTypes);
    }
    _fillMode = (fillMode == null) ? _fillMode : fillMode;
    this.brush = brush;
  }

  // fields
  final List<Offset> _points = <Offset>[];
  final List<_PathPointType> _pathTypes = <_PathPointType>[];
  final bool _isBeziers3 = false;
  bool _bStartFigure = true;
  PdfFillMode _fillMode = PdfFillMode.winding;

  // properties
  /// Gets the brush of the element
  PdfBrush get brush {
    return _brush;
  }

  /// Sets the brush of the element
  set brush(PdfBrush value) {
    if (value != null) {
      _brush = value;
    }
  }

  // implementation
  List<_PathPointType> _assignPathtype(List<int> types) {
    final List<_PathPointType> pathType = <_PathPointType>[];
    for (final dynamic t in types) {
      switch (t) {
        case 0:
          pathType.add(_PathPointType.start);
          break;
        case 1:
          pathType.add(_PathPointType.line);
          break;
        case 3:
          pathType.add(_PathPointType.bezier3);
          break;
        case 129:
          pathType.add(_PathPointType.closeSubpath);
          break;
        default:
          throw ArgumentError('Invalid pathType');
      }
    }
    return pathType;
  }

  /// Appends the path specified by the points and their types to this one.
  void addPath(List<Offset> pathPoints, List<int> pathTypes) {
    ArgumentError.checkNotNull(pathPoints, 'pathPoints');
    ArgumentError.checkNotNull(pathTypes, 'pathTypes');
    final int count = pathPoints.length;
    if (count != pathTypes.length) {
      throw ArgumentError.value(
          'The argument arrays should be of equal length.');
    }
    _points.addAll(pathPoints);
    _pathTypes.addAll(_assignPathtype(pathTypes));
  }

  /// Adds a line
  void addLine(Offset point1, Offset point2) {
    final List<double> points = <double>[];
    points.add(point1.dx);
    points.add(point1.dy);
    points.add(point2.dx);
    points.add(point2.dy);
    _addPoints(points, _PathPointType.line);
  }

  /// Adds a rectangle
  void addRectangle(Rect bounds) {
    final List<double> points = <double>[];
    startFigure();
    points.add(bounds.left);
    points.add(bounds.top);
    points.add(bounds.left + bounds.width);
    points.add(bounds.top);
    points.add(bounds.left + bounds.width);
    points.add(bounds.top + bounds.height);
    points.add(bounds.left);
    points.add(bounds.top + bounds.height);
    _addPoints(points, _PathPointType.line);
    closeFigure();
  }

  /// Adds a pie
  void addPie(Rect bounds, double startAngle, double sweepAngle) {
    startFigure();
    addArc(bounds, startAngle, sweepAngle);
    _addPoint(
        Offset(bounds.left + bounds.width / 2, bounds.top + bounds.height / 2),
        _PathPointType.line);
    closeFigure();
  }

  /// Adds an ellipse
  void addEllipse(Rect bounds) {
    startFigure();
    addArc(bounds, 0, 360);
    closeFigure();
  }

  /// Adds an bezier curve
  void addBezier(Offset startPoint, Offset firstControlPoint,
      Offset secondControlPoint, Offset endPoint) {
    final List<double> points = <double>[];
    points.add(startPoint.dx);
    points.add(startPoint.dy);
    points.add(firstControlPoint.dx);
    points.add(firstControlPoint.dy);
    points.add(secondControlPoint.dx);
    points.add(secondControlPoint.dy);
    points.add(endPoint.dx);
    points.add(endPoint.dy);
    _addPoints(points, _PathPointType.bezier3);
  }

  /// Adds an arc
  void addArc(Rect bounds, double startAngle, double sweepAngle) {
    final List<List<double>> points = PdfGraphics._getBezierArcPoints(
        bounds.left,
        bounds.top,
        bounds.left + bounds.width,
        bounds.top + bounds.height,
        startAngle,
        sweepAngle);
    final List<double> list = <double>[];
    for (int i = 0; i < points.length; ++i) {
      final List<double> pt = points[i];
      list.clear();
      list.addAll(pt);
      _addPoints(list, _PathPointType.bezier3);
    }
  }

  /// Adds a polygon
  void addPolygon(List<Offset> points) {
    final List<double> p = <double>[];
    startFigure();
    for (final Offset point in points) {
      p.add(point.dx);
      p.add(point.dy);
    }
    _addPoints(p, _PathPointType.line);
    closeFigure();
  }

  /// Starts a new figure.
  void startFigure() {
    _bStartFigure = true;
  }

  /// Closes the last figure.
  void closeFigure() {
    if (_points.isNotEmpty) {
      // _pathTypes[_points.length - 1] = _PathPointType.closeSubpath;
      _points.add(const Offset(0, 0));
      _pathTypes.add(_PathPointType.closeSubpath);
    }
    startFigure();
  }

  void _addPoints(List<double> points, _PathPointType pointType) {
    for (int i = 0; i < points.length; ++i) {
      final Offset point = Offset(points[i], points[i + 1]);
      if (i == 0) {
        if (_points.isEmpty || _bStartFigure) {
          _addPoint(point, _PathPointType.start);
          _bStartFigure = false;
        } else if (point != _points.elementAt(_points.length - 1) &&
            !_isBeziers3) {
          _addPoint(point, _PathPointType.line);
        } else if (point != _points.elementAt(_points.length - 1)) {
          _addPoint(point, _PathPointType.bezier3);
        }
      } else {
        _addPoint(point, pointType);
      }
      ++i;
    }
  }

  void _addPoint(Offset point, _PathPointType pointType) {
    _points.add(point);
    _pathTypes.add(pointType);
  }

  _Rectangle _getBoundsInternal() {
    final List<Offset> points = _points;
    _Rectangle bounds = _Rectangle.empty;
    if (points.isNotEmpty) {
      double xmin = points[0].dx;
      double xmax = points[0].dx;
      double ymin = points[0].dy;
      double ymax = points[0].dy;
      for (int i = 1; i < points.length; ++i) {
        if (points.length - 1 == i) {
          if (points[i] == Offset.zero) {
            break;
          }
        }
        final Offset point = points[i];
        xmin = min(point.dx, xmin);
        xmax = max(point.dx, xmax);
        ymin = min(point.dy, ymin);
        ymax = max(point.dy, ymax);
      }
      bounds = _Rectangle(xmin, ymin, xmax - xmin, ymax - ymin);
    }
    return bounds;
  }

  @override
  void _drawInternal(PdfGraphics graphics, _Rectangle bounds) {
    ArgumentError.checkNotNull(graphics, 'graphics');
    graphics.drawPath(this, pen: pen, brush: brush);
  }
}
