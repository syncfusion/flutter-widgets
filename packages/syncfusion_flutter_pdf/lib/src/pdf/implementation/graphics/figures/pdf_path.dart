import 'dart:math';
import 'dart:ui';

import '../../drawing/drawing.dart';
import '../brushes/pdf_solid_brush.dart';
import '../enums.dart';
import '../pdf_graphics.dart';
import '../pdf_pen.dart';
import 'base/pdf_shape_element.dart';
import 'enums.dart';

/// Implements graphics path, which is a sequence of
/// primitive graphics elements.
class PdfPath extends PdfShapeElement {
  // constructor
  /// Initializes a new instance of the [PdfPath] class
  /// with pen, brush, fillMode, points and pathTypes
  PdfPath(
      {PdfPen? pen,
      PdfBrush? brush,
      PdfFillMode fillMode = PdfFillMode.winding,
      List<Offset> points = const <Offset>[],
      List<int>? pathTypes}) {
    _helper = PdfPathHelper(this);
    if (pen != null) {
      super.pen = pen;
    }
    if (points.isNotEmpty && pathTypes != null) {
      addPath(points, pathTypes);
    }
    _helper.fillMode = fillMode;
    this.brush = brush;
  }

  // fields
  late PdfPathHelper _helper;
  final bool _isBeziers3 = false;
  bool _bStartFigure = true;

  // properties
  /// Gets the brush of the element
  PdfBrush? get brush {
    return PdfShapeElementHelper.getHelper(this).brush;
  }

  /// Sets the brush of the element
  set brush(PdfBrush? value) {
    if (value != null) {
      PdfShapeElementHelper.getHelper(this).brush = value;
    }
  }

  // implementation
  List<PathPointType> _assignPathtype(List<int> types) {
    final List<PathPointType> pathType = <PathPointType>[];
    for (final dynamic t in types) {
      switch (t) {
        case 0:
          pathType.add(PathPointType.start);
          break;
        case 1:
          pathType.add(PathPointType.line);
          break;
        case 3:
          pathType.add(PathPointType.bezier3);
          break;
        case 129:
          pathType.add(PathPointType.closeSubpath);
          break;
        default:
          throw ArgumentError('Invalid pathType');
      }
    }
    return pathType;
  }

  /// Appends the path specified by the points and their types to this one.
  void addPath(List<Offset> pathPoints, List<int> pathTypes) {
    final int count = pathPoints.length;
    if (count != pathTypes.length) {
      throw ArgumentError.value(
          'The argument arrays should be of equal length.');
    }
    _helper.points.addAll(pathPoints);
    _helper.pathTypes.addAll(_assignPathtype(pathTypes));
  }

  /// Adds a line
  void addLine(Offset point1, Offset point2) {
    _addPoints(<double>[point1.dx, point1.dy, point2.dx, point2.dy],
        PathPointType.line);
  }

  /// Adds a rectangle
  void addRectangle(Rect bounds) {
    startFigure();
    _addPoints(<double>[
      bounds.left,
      bounds.top,
      bounds.left + bounds.width,
      bounds.top,
      bounds.left + bounds.width,
      bounds.top + bounds.height,
      bounds.left,
      bounds.top + bounds.height
    ], PathPointType.line);
    closeFigure();
  }

  /// Adds a pie
  void addPie(Rect bounds, double startAngle, double sweepAngle) {
    startFigure();
    addArc(bounds, startAngle, sweepAngle);
    _addPoint(
        Offset(bounds.left + bounds.width / 2, bounds.top + bounds.height / 2),
        PathPointType.line);
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
    _addPoints(points, PathPointType.bezier3);
  }

  /// Adds an arc
  void addArc(Rect bounds, double startAngle, double sweepAngle) {
    final List<List<double>> points = PdfGraphicsHelper.getBezierArcPoints(
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
      _addPoints(list, PathPointType.bezier3);
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
    _addPoints(p, PathPointType.line);
    closeFigure();
  }

  /// Starts a new figure.
  void startFigure() {
    _bStartFigure = true;
  }

  /// Closes the last figure.
  void closeFigure() {
    if (_helper.points.isNotEmpty) {
      _helper.points.add(Offset.zero);
      _helper.pathTypes.add(PathPointType.closeSubpath);
    }
    startFigure();
  }

  void _addPoints(List<double> points, PathPointType pointType) {
    for (int i = 0; i < points.length; ++i) {
      final Offset point = Offset(points[i], points[i + 1]);
      if (i == 0) {
        if (_helper.points.isEmpty || _bStartFigure) {
          _addPoint(point, PathPointType.start);
          _bStartFigure = false;
        } else if (point !=
                _helper.points.elementAt(_helper.points.length - 1) &&
            !_isBeziers3) {
          _addPoint(point, PathPointType.line);
        } else if (point !=
            _helper.points.elementAt(_helper.points.length - 1)) {
          _addPoint(point, PathPointType.bezier3);
        }
      } else {
        _addPoint(point, pointType);
      }
      ++i;
    }
  }

  void _addPoint(Offset point, PathPointType pointType) {
    _helper.points.add(point);
    _helper.pathTypes.add(pointType);
  }
}

/// [PdfPath] helper
class PdfPathHelper {
  /// internal constructor
  PdfPathHelper(this.path);

  /// internal field
  PdfPath path;

  /// internal field
  // ignore: prefer_final_fields
  List<Offset> points = <Offset>[];

  /// internal field
  final List<PathPointType> pathTypes = <PathPointType>[];

  /// internal field
  late PdfFillMode fillMode;

  /// internal method
  static PdfPathHelper getHelper(PdfPath path) {
    return path._helper;
  }

  /// internal method
  PdfRectangle getBoundsInternal() {
    final List<Offset> points = this.points;
    PdfRectangle bounds = PdfRectangle.empty;
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
      bounds = PdfRectangle(xmin, ymin, xmax - xmin, ymax - ymin);
    }
    return bounds;
  }

  /// internal method
  void drawInternal(PdfGraphics graphics, PdfRectangle bounds) {
    graphics.drawPath(path, pen: path.pen, brush: path.brush);
  }

  /// internal method
  void addLines(List<Offset> linePoints) {
    Offset start = linePoints[0];
    if (linePoints.length == 1) {
      path._addPoint(linePoints[0], PathPointType.line);
    } else {
      for (int i = 1; i < linePoints.length; i++) {
        final Offset last = linePoints[i];
        path.addLine(start, last);
        start = last;
      }
    }
  }
}
