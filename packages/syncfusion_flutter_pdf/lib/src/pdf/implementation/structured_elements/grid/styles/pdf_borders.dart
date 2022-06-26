import '../../../graphics/enums.dart';
import '../../../graphics/pdf_color.dart';
import '../../../graphics/pdf_pen.dart';

/// The class used represents the cell border of the PDF grid
class PdfBorders {
  //Constructor
  /// Initialize a new instance of the [PdfBorders] class.
  PdfBorders({PdfPen? left, PdfPen? right, PdfPen? top, PdfPen? bottom}) {
    if (left == null) {
      final PdfPen defaultBorderPenLeft = PdfPen(PdfColor(0, 0, 0));
      defaultBorderPenLeft.dashStyle = PdfDashStyle.solid;
      this.left = defaultBorderPenLeft;
    } else {
      this.left = left;
    }
    if (right == null) {
      final PdfPen defaultBorderPenRight = PdfPen(PdfColor(0, 0, 0));
      defaultBorderPenRight.dashStyle = PdfDashStyle.solid;
      this.right = defaultBorderPenRight;
    } else {
      this.right = right;
    }
    if (top == null) {
      final PdfPen defaultBorderPenTop = PdfPen(PdfColor(0, 0, 0));
      defaultBorderPenTop.dashStyle = PdfDashStyle.solid;
      this.top = defaultBorderPenTop;
    } else {
      this.top = top;
    }
    if (bottom == null) {
      final PdfPen defaultBorderPenBottom = PdfPen(PdfColor(0, 0, 0));
      defaultBorderPenBottom.dashStyle = PdfDashStyle.solid;
      this.bottom = defaultBorderPenBottom;
    } else {
      this.bottom = bottom;
    }
  }

  /// Gets the default border.
  static PdfBorders get defaultBorder {
    _defaultBorder ??= PdfBorders();
    return _defaultBorder!;
  }

  //Fields
  static PdfBorders? _defaultBorder;

  /// Gets or sets the pen for the left line of border.
  late PdfPen left;

  /// Gets or sets the pen for the right line of border.
  late PdfPen right;

  /// Gets or sets the pen for the bottom line of border.
  late PdfPen bottom;

  /// Gets or sets the pen for the top line of border.
  late PdfPen top;

  //Properties
  /// Sets all.
  // ignore: avoid_setters_without_getters
  set all(PdfPen pen) {
    left = right = bottom = top = pen;
  }

  bool get _isAll => left == right && right == bottom && bottom == top;
}

// ignore: avoid_classes_with_only_static_members
/// [PdfBorders] helper
class PdfBordersHelper {
  /// internal method
  static bool isAll(PdfBorders borders) {
    return borders._isAll;
  }
}

/// The class used represents the cell padding of the PDF grid
class PdfPaddings {
  //Constructors
  /// Initializes a new instance of the [PdfPaddings] class.
  PdfPaddings({double? left, double? right, double? top, double? bottom}) {
    _initialize(left, right, top, bottom);
  }

  //Fields
  late double _left;
  late double _right;
  late double _bottom;
  late double _top;

  //Properties
  @override
  // ignore: avoid_equals_and_hash_code_on_mutable_classes
  bool operator ==(Object other) {
    return other is PdfPaddings &&
        left == other.left &&
        right == other.right &&
        top == other.top &&
        bottom == other.bottom;
  }

  @override
  // ignore: avoid_equals_and_hash_code_on_mutable_classes
  int get hashCode => _left.hashCode;

  /// Sets space value to all sides of a cell Left,Right,Top,Bottom.
  // ignore: avoid_setters_without_getters
  set all(double value) {
    if (value < 0) {
      ArgumentError.value(
          value, 'all', 'value should greater than or equal to zero');
    }
    _left = _right = _bottom = _top = value;
  }

  /// Gets the left space of padding.
  double get left => _left;

  /// Sets the left space of padding.
  set left(double value) {
    if (value < 0) {
      ArgumentError.value(
          value, 'left', 'value should greater than or equal to zero');
    }
    _left = value;
  }

  /// Gets the right space of padding.
  double get right => _right;

  /// Sets the right space of padding.
  set right(double value) {
    if (value < 0) {
      ArgumentError.value(
          value, 'right', 'value should greater than or equal to zero');
    }
    _right = value;
  }

  /// Gets the top space of padding.
  double get top => _top;

  /// Sets the top space of padding.
  set top(double value) {
    if (value < 0) {
      ArgumentError.value(
          value, 'top', 'value should greater than or equal to zero');
    }
    _top = value;
  }

  /// Gets the bottom space of padding.
  double get bottom => _bottom;

  /// Sets the bottom space of padding.
  set bottom(double value) {
    if (value < 0) {
      ArgumentError.value(
          value, 'bottom', 'value should greater than or equal to zero');
    }
    _bottom = value;
  }

  //Implementation
  void _initialize(double? left, double? right, double? top, double? bottom) {
    this.left = left ?? 0.5;
    this.right = right ?? 0.5;
    this.top = top ?? 0.5;
    this.bottom = bottom ?? 0.5;
  }
}
