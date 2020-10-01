part of gauges;

/// Create the range to add color bar in the gauge.
///
/// [GaugeRange] is a visual element that helps to quickly visualize
/// where a value falls on the axis.
/// The text can be easily annotated in range to improve the readability.
///
/// ```dart
/// Widget build(BuildContext context) {
///    return Container(
///        child: SfRadialGauge(
///          axes:<RadialAxis>[RadialAxis(
///          ranges: <GaugeRange>[GaugeRange(startValue: 50,
///          endValue: 100)],
///            )]
///        ));
///}
/// ```
class GaugeRange {
  /// Create a range with the default or required properties.
  ///
  /// The arguments [startValue], [endValue], must not be null.
  GaugeRange(
      {@required this.startValue,
      @required this.endValue,
      double startWidth,
      double endWidth,
      this.sizeUnit = GaugeSizeUnit.logicalPixel,
      this.color,
      this.gradient,
      this.rangeOffset = 0,
      this.label,
      GaugeTextStyle labelStyle})
      : startWidth =
            startWidth = startWidth ?? (label != null ? startWidth : 10),
        endWidth = endWidth = endWidth ?? (label != null ? endWidth : 10),
        labelStyle = labelStyle ??
            GaugeTextStyle(
                fontSize: 12.0,
                fontFamily: 'Segoe UI',
                fontStyle: FontStyle.normal,
                fontWeight: FontWeight.normal),
        assert(
            startValue != null,
            'It is necessary to provide the start'
            ' value for range.'),
        assert(
            endValue != null,
            'It is necessary to provide the end value'
            ' for range.'),
        assert(
            (gradient != null && gradient is SweepGradient) || gradient == null,
            'The gradient must be null or else the gradient must be equal'
            ' to sweep gradient.');

  /// Specifies the range start value.
  ///
  /// The range is drawn from [startValue] to [endValue].
  ///
  /// The [startValue] must be greater than the minimum value of the axis.
  ///
  /// Defaults to null
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfRadialGauge(
  ///          axes:<RadialAxis>[RadialAxis(
  ///          ranges: <GaugeRange>[GaugeRange(startValue: 50,
  ///          endValue: 100)],
  ///            )]
  ///        ));
  ///}
  /// ```
  final double startValue;

  /// Specifies the range end value.
  ///
  /// The range is drawn from [startValue] to [endValue].
  ///
  /// The [endValue] must be less than the maximum value of the axis.
  ///
  /// Defaults to null
  ///
  /// ```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfRadialGauge(
  ///          axes:<RadialAxis>[RadialAxis(
  ///          ranges: <GaugeRange>[GaugeRange(startValue: 50,
  ///          endValue: 100)],
  ///            )]
  ///        ));
  ///}
  /// ```
  final double endValue;

  /// Specifies the range start width.
  ///
  /// You can specify range start width either in logical pixel or radius
  /// factor using the [sizeUnit] property.
  /// if [sizeUnit] is [GaugeSizeUnit.factor], value must be given from 0 to 1.
  /// Here range start width is calculated by [startWidth] * axis radius value.
  ///
  /// Example: [startWidth] value is 0.2 and axis radius is 100, range start
  /// width is 20(0.2 * 100) logical pixels.
  /// if [sizeUnit] is [GaugeSizeUnit.logicalPixel], the defined value is set
  /// for the start width of the range.
  ///
  /// Defaults to 10 and [sizeUnit] is [GaugeSizeUnit.logicalPixel]
  ///
  /// ```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfRadialGauge(
  ///          axes:<RadialAxis>[RadialAxis(
  ///          ranges: <GaugeRange>[GaugeRange(startValue: 50,
  ///          endValue: 100, startWidth: 20)],
  ///            )]
  ///        ));
  ///}
  /// ```
  final double startWidth;

  /// Specifies the range end width.
  ///
  /// You can specify range end width either in logical pixel or radius factor
  /// using the [sizeUnit] property.
  /// if [sizeUnit] is [GaugeSizeUnit.factor], value must be given from 0 to 1.
  /// Here range end width is calculated by [endWidth] * axis radius value.
  ///
  /// Example: [endWidth] value is 0.2 and axis radius is 100, range end width
  /// is 20(0.2 * 100) logical pixels.
  /// If [sizeUnit] is [GaugeSizeUnit.logicalPixel], the defined value is set
  /// for the end width of the range.
  ///
  /// Defaults to 10 and [sizeUnit] is [GaugeSizeUnit.logicalPixel]
  ///
  /// ```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfRadialGauge(
  ///          axes:<RadialAxis>[RadialAxis(
  ///          ranges: <GaugeRange>[GaugeRange(startValue: 50,
  ///          endValue: 100, endWidth: 40)],
  ///            )]
  ///        ));
  ///}
  /// ```
  final double endWidth;

  /// Calculates the range position and size either in logical pixel
  /// or radius factor.
  ///
  /// Using [GaugeSizeUnit], range position and size is calculated.
  ///
  /// Defaults to [GaugeSizeUnit.logicalPixel].
  ///
  /// Also refer [GaugeSizeUnit].
  ///
  /// ```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfRadialGauge(
  ///          axes:<RadialAxis>[RadialAxis(
  ///          ranges: <GaugeRange>[GaugeRange(startValue: 50,
  ///          endValue: 100, rangeOffset: 0.1,
  ///          sizeUnit: GaugeSizeUnit.factor)],
  ///            )]
  ///        ));
  ///}
  /// ```
  final GaugeSizeUnit sizeUnit;

  /// Adjusts the range position in gauge.
  ///
  /// You can specify position value either in logical pixel or radius factor
  /// using the [sizeUnit] property.
  /// if [sizeUnit] is [GaugeSizeUnit.factor], value will be given from 0 to 1.
  /// Here range placing position is calculated
  /// by [rangeOffset] * axis radius value.
  ///
  /// Example: [rangeOffset] value is 0.2 and axis radius is 100, range is
  /// moving 20(0.2 * 100) logical pixels from axis outer radius.
  /// If [sizeUnit] is [GaugeSizeUnit.logicalPixel], the given value distance
  /// range moves from the outer radius axis.
  ///
  /// When you specify [rangeOffset] is negative, the range will be positioned
  /// outside the axis.
  ///
  /// Defaults to 0 and [sizeUnit] is [GaugeSizeUnit.logicalPixel]
  ///
  /// ```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfRadialGauge(
  ///          axes:<RadialAxis>[RadialAxis(
  ///          ranges: <GaugeRange>[GaugeRange(startValue: 50,
  ///          endValue: 100, rangeOffset: 10)],
  ///            )]
  ///        ));
  ///}
  /// ```
  final double rangeOffset;

  /// Specifies the range color.
  ///
  /// Defaults to null
  /// ```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfRadialGauge(
  ///          axes:<RadialAxis>[RadialAxis(
  ///          ranges: <GaugeRange>[GaugeRange(startValue: 50,
  ///          endValue: 100, color: Colors.blue)],
  ///            )]
  ///        ));
  ///}
  /// ```
  final Color color;

  /// The style to use for the range label text.
  ///
  /// Using [GaugeTextStyle] to add the style to the axis labels.
  ///
  /// Defaults to the [GaugeTextStyle] property with font size is 12.0 and
  /// font family is Segoe UI.
  ///
  /// Also refer [GaugeTextStyle].
  ///
  /// ```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfRadialGauge(
  ///          axes:<RadialAxis>[RadialAxis(
  ///          ranges: <GaugeRange>[GaugeRange(startValue: 50,
  ///          endValue: 100, label: 'High',
  ///          labelStyle: GaugeTextStyle(fontSize: 20)
  ///          )],
  ///            )]
  ///        ));
  ///}
  /// ```
  final GaugeTextStyle labelStyle;

  /// Specifies the text for range.
  ///
  /// [label] style is customized by [labelStyle].
  ///
  /// Defaults to null
  /// ```dart
  /// Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfRadialGauge(
  ///          axes:<RadialAxis>[RadialAxis(
  ///          ranges: <GaugeRange>[GaugeRange(startValue: 50,
  ///          endValue: 100, label: 'High')],
  ///            )]
  ///        ));
  ///}
  /// ```
  final String label;

  /// A gradient to use when filling the range.
  ///
  /// [gradient] of [GaugeRange] only support [SweepGradient] and
  /// specified [SweepGradient.stops] are applied within the range value.
  ///
  /// Defaults to null
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfRadialGauge(
  ///          axes:<RadialAxis>[RadialAxis(
  ///          ranges: <GaugeRange>[GaugeRange(startValue: 0,
  ///          endValue: 100, startWidth: 10, endWidth: 10,
  ///          gradient:SweepGradient(
  ///            colors: const <Color>[Colors.red, Color(0xFFFFDD00),
  ///             Color(0xFFFFDD00), Color(0xFF30B32D),],
  ///            stops: const <double>[0, 0.2722222, 0.5833333, 0.777777,],
  ///          ))],
  ///            )]
  ///        ));
  ///}
  /// ```
  final Gradient gradient;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }
    return other is GaugeRange &&
        other.startValue == startValue &&
        other.endValue == endValue &&
        other.startWidth == startWidth &&
        other.endWidth == endWidth &&
        other.gradient == gradient &&
        other.rangeOffset == rangeOffset &&
        other.sizeUnit == sizeUnit &&
        other.label == label &&
        other.color == color &&
        other.labelStyle == labelStyle;
  }

  @override
  int get hashCode {
    final List<Object> values = <Object>[
      startValue,
      endValue,
      startWidth,
      endWidth,
      gradient,
      rangeOffset,
      sizeUnit,
      label,
      color,
      labelStyle
    ];
    return hashList(values);
  }
}

/// This class has methods to render the gauge range
///
class _GaugeRangeRenderer {
  /// Creates the instance for gauge range renderer
  _GaugeRangeRenderer(GaugeRange range) {
    _range = range;
    _needsRepaintRange = true;
  }

  /// Holds the instance of corresponding gauge range
  GaugeRange _range;

  /// Holds the radial axis renderer
  RadialAxisRenderer _axisRenderer;

  /// Specifies whether to repaint the range
  bool _needsRepaintRange;

  /// Specifies the range axis
  RadialAxis _axis;

  /// Specifies the start width
  double _actualStartWidth;

  /// Specifies the actual end width
  double _actualEndWidth;

  /// Specifies the outer start offset
  double _outerStartOffset;

  /// Specifies the outer end offset
  double _outerEndOffset;

  /// Specifies the inner start offset
  double _innerStartOffset;

  /// Specifies the inner end offset
  double _innerEndOffset;

  /// Specifies the outer arc
  _ArcData _outerArc;

  /// Specifies the inner arc
  _ArcData _innerArc;

  /// Specifies the outer arc sweep angle
  double _outerArcSweepAngle;

  /// Specifies the inner arc sweep angle
  double _innerArcSweepAngle;

  /// Specifies the thickness value
  double _thickness;

  /// Specifies the range rect
  Rect _rangeRect;

  /// Specifies the range start radian
  double _rangeStartRadian;

  /// Specifies the range end radian
  double _rangeEndRadian;

  /// Specifies the range mid radian
  double _rangeMidRadian;

  /// Specifies the center value
  Offset _center;

  /// Specifies the maximum angle
  double _maxAngle;

  /// Specifies the range start value
  double _rangeStartValue;

  /// Specifies the range ed value
  double _rangeEndValue;

  /// Specifies the range mid value
  double _rangeMidValue;

  /// Specifies the label angle
  double _labelAngle;

  /// Holds the label position
  Offset _labelPosition;

  /// Holds the label size
  Size _labelSize;

  /// Holds the actual start value
  double _actualStartValue;

  /// Holds the actual end value
  double _actualEndValue;

  /// Holds the total offset
  double _totalOffset;

  /// Specifies the actual range offset
  double _actualRangeOffset;

  /// Specifies the path rect
  Rect _pathRect;

  /// Calculates the range position
  void _calculateRangePosition() {
    _calculateActualWidth();
    _actualRangeOffset = _axisRenderer._getActualValue(
        _range.rangeOffset, _range.sizeUnit, true);
    _center = !_axis.canScaleToFit
        ? Offset(_axisRenderer._axisSize.width / 2,
            _axisRenderer._axisSize.height / 2)
        : _axisRenderer._axisCenter;
    _totalOffset = _actualRangeOffset < 0
        ? _axisRenderer._getAxisOffset() + _actualRangeOffset
        : (_actualRangeOffset + _axisRenderer._axisOffset);
    _maxAngle = _axisRenderer._sweepAngle;
    _actualStartValue = _getMinMax(
        _range.startValue ?? _axis.minimum, _axis.minimum, _axis.maximum);
    _actualEndValue = _getMinMax(
        _range.endValue ?? _axis.maximum, _axis.minimum, _axis.maximum);
    _calculateRangeAngle();
    if (_actualStartWidth != _actualEndWidth) {
      _calculateInEqualWidthArc();
    } else {
      _calculateEqualWidthArc();
    }

    if (_range.label != null) {
      _labelSize = _getTextSize(_range.label, _range.labelStyle);
      _calculateLabelPosition();
    }
  }

  /// Method to calculate rect for in equal width range
  void _calculateInEqualWidthArc() {
    _outerEndOffset = 0;
    _outerStartOffset = _outerEndOffset;
    _innerStartOffset = _actualStartWidth;
    _innerEndOffset = _actualEndWidth;

    _outerArc = _getRadiusToAngleConversion(_outerStartOffset, _outerEndOffset);
    _innerArc = _getRadiusToAngleConversion(_innerStartOffset, _innerEndOffset);

    _outerArcSweepAngle =
        _getSweepAngle(_outerArc.endAngle - _outerArc.startAngle);
    _innerArcSweepAngle =
        _getSweepAngle(_innerArc.endAngle - _innerArc.startAngle);
    _innerArcSweepAngle *= -1;

    final double left = _outerArc.arcRect.left < _innerArc.arcRect.left
        ? _outerArc.arcRect.left
        : _innerArc.arcRect.left;
    final double top = _outerArc.arcRect.top < _innerArc.arcRect.top
        ? _outerArc.arcRect.top
        : _innerArc.arcRect.top;
    final double right = _outerArc.arcRect.right < _innerArc.arcRect.right
        ? _innerArc.arcRect.right
        : _outerArc.arcRect.right;
    final double bottom = _outerArc.arcRect.bottom < _innerArc.arcRect.bottom
        ? _innerArc.arcRect.bottom
        : _outerArc.arcRect.bottom;
    _pathRect = Rect.fromLTRB(left, top, right, bottom);
  }

  /// Calculates the range angle
  void _calculateRangeAngle() {
    if (!_axis.isInversed) {
      _rangeStartValue = _axis.startAngle +
          (_maxAngle /
              ((_axis.maximum - _axis.minimum) /
                  (_actualStartValue - _axis.minimum)));
      _rangeEndValue = _axis.startAngle +
          (_maxAngle /
              ((_axis.maximum - _axis.minimum) /
                  (_actualEndValue - _axis.minimum)));
      _rangeMidValue = _axis.startAngle +
          (_maxAngle /
              ((_axis.maximum - _axis.minimum) /
                  ((_actualEndValue - _actualStartValue) / 2 +
                      _actualStartValue)));
    } else {
      _rangeStartValue = _axis.startAngle +
          _maxAngle -
          (_maxAngle /
              ((_axis.maximum - _axis.minimum) /
                  (_actualStartValue - _axis.minimum)));
      _rangeEndValue = _axis.startAngle +
          _maxAngle -
          (_maxAngle /
              ((_axis.maximum - _axis.minimum) /
                  (_actualEndValue - _axis.minimum)));
      _rangeMidValue = _axis.startAngle +
          _maxAngle -
          (_maxAngle /
              ((_axis.maximum - _axis.minimum) /
                  ((_actualEndValue - _actualStartValue) / 2 +
                      _actualStartValue)));
    }

    _rangeStartRadian = _getDegreeToRadian(_rangeStartValue);
    _rangeEndRadian = _getDegreeToRadian(_rangeEndValue);
    _rangeMidRadian = _getDegreeToRadian(_rangeMidValue);
  }

  /// Method to calculate the rect for range with equal start and end width
  void _calculateEqualWidthArc() {
    _thickness = _actualStartWidth;
    _rangeStartRadian = _getDegreeToRadian(
        (_axisRenderer.valueToFactor(_actualStartValue) *
                _axisRenderer._sweepAngle) +
            _axis.startAngle);
    final double endRadian = _getDegreeToRadian(
        (_axisRenderer.valueToFactor(_actualEndValue) *
                _axisRenderer._sweepAngle) +
            _axis.startAngle);
    _rangeEndRadian = endRadian - _rangeStartRadian;

    _rangeRect = Rect.fromLTRB(
        -(_axisRenderer._radius - (_actualStartWidth / 2 + _totalOffset)),
        -(_axisRenderer._radius - (_actualStartWidth / 2 + _totalOffset)),
        _axisRenderer._radius - (_actualStartWidth / 2 + _totalOffset),
        _axisRenderer._radius - (_actualStartWidth / 2 + _totalOffset));
  }

  /// Method to calculate the sweep angle
  double _getSweepAngle(double sweepAngle) {
    if (sweepAngle < 0 && !_axis.isInversed) {
      sweepAngle += 360;
    }

    if (sweepAngle > 0 && _axis.isInversed) {
      sweepAngle -= 360;
    }
    return sweepAngle;
  }

  /// Converts radius to angle
  _ArcData _getRadiusToAngleConversion(double startOffset, double endOffset) {
    final double startRadius = _axisRenderer._radius - startOffset;
    final double endRadius = _axisRenderer._radius - endOffset;
    final double midRadius =
        _axisRenderer._radius - (startOffset + endOffset) / 2;

    final double startX = startRadius * math.cos(_getDegreeToRadian(0));
    final double startY = startRadius * math.sin(_getDegreeToRadian(0));
    final Offset rangeStartOffset = Offset(startX, startY);

    final double endX =
        endRadius * math.cos(_rangeEndRadian - _rangeStartRadian);
    final double endY =
        endRadius * math.sin(_rangeEndRadian - _rangeStartRadian);
    final Offset rangeEndOffset = Offset(endX, endY);

    final double midX =
        midRadius * math.cos(_rangeMidRadian - _rangeStartRadian);
    final double midY =
        midRadius * math.sin(_rangeMidRadian - _rangeStartRadian);
    final Offset rangeMidOffset = Offset(midX, midY);
    return _getArcData(rangeStartOffset, rangeEndOffset, rangeMidOffset);
  }

  /// Method to create the arc data
  _ArcData _getArcData(
      Offset rangeStartOffset, Offset rangeEndOffset, Offset rangeMidOffset) {
    final Offset controlPoint =
        _getPointConversion(rangeStartOffset, rangeEndOffset, rangeMidOffset);

    final double distance = math.sqrt(
        math.pow(rangeStartOffset.dx - controlPoint.dx, 2) +
            math.pow(rangeStartOffset.dy - controlPoint.dy, 2));

    double actualStartAngle = _getRadianToDegree(math.atan2(
      rangeStartOffset.dy - controlPoint.dy,
      rangeStartOffset.dx - controlPoint.dx,
    ));
    double actualEndAngle = _getRadianToDegree(math.atan2(
      rangeEndOffset.dy - controlPoint.dy,
      rangeEndOffset.dx - controlPoint.dx,
    ));

    if (actualStartAngle < 0) {
      actualStartAngle += 360;
    }

    if (actualEndAngle < 0) {
      actualEndAngle += 360;
    }

    if (_actualStartValue > _actualEndValue) {
      final double temp = actualEndAngle;
      actualEndAngle = actualStartAngle;
      actualStartAngle = temp;
    }

    final _ArcData arcData = _ArcData();
    arcData.startAngle = actualStartAngle;
    arcData.endAngle = actualEndAngle;
    arcData.arcRect = Rect.fromLTRB(
        controlPoint.dx - distance + _totalOffset,
        controlPoint.dy - distance + _totalOffset,
        controlPoint.dx + distance - _totalOffset,
        controlPoint.dy + distance - _totalOffset);
    return arcData;
  }

  /// calculates the control point for range arc
  Offset _getPointConversion(Offset offset1, Offset offset2, Offset offset3) {
    double distance1 = (offset1.dy - offset2.dy) / (offset1.dx - offset2.dx);
    distance1 = (offset1.dy - offset2.dy) == 0 || (offset1.dx - offset2.dx) == 0
        ? 0
        : distance1;
    double distance2 = (offset3.dy - offset2.dy) / (offset3.dx - offset2.dx);
    distance2 = (offset3.dy - offset2.dy) == 0 || (offset3.dx - offset2.dx) == 0
        ? 0
        : distance2;
    double x = (distance1 * distance2 * (offset3.dy - offset1.dy) +
            distance1 * (offset2.dx + offset3.dx) -
            distance2 * (offset1.dx + offset2.dx)) /
        (2 * (distance1 - distance2));
    final double diff = (1 / distance1).isInfinite ? 0 : (1 / distance1);
    double y = -diff * (x - ((offset1.dx + offset2.dx) / 2)) +
        ((offset1.dy + offset2.dy) / 2);
    x = x.isNaN ? 0 : x;
    y = y.isNaN ? 0 : y;
    return Offset(x, y);
  }

  /// Calculates the actual range width
  void _calculateActualWidth() {
    _actualStartWidth = _getRangeValue(_range.startWidth);
    _actualEndWidth = _getRangeValue(_range.endWidth);
  }

  /// Calculates the actual value
  double _getRangeValue(double value) {
    double actualValue = 0;
    if (value != null) {
      switch (_range.sizeUnit) {
        case GaugeSizeUnit.factor:
          {
            actualValue = value * _axisRenderer._radius;
          }
          break;
        case GaugeSizeUnit.logicalPixel:
          {
            actualValue = value;
          }
      }
    } else if (_range.label != null) {
      final Size size = _getTextSize(_range.label, _range.labelStyle);
      actualValue = size.height;
    }

    return actualValue;
  }

  /// Calculates the label position
  void _calculateLabelPosition() {
    final double midAngle = (_axisRenderer
                .valueToFactor((_actualEndValue + _actualStartValue) / 2) *
            _axisRenderer._sweepAngle) +
        _axis.startAngle;
    final double labelRadian = _getDegreeToRadian(midAngle);
    _labelAngle = midAngle - 90;
    final double height = _actualStartWidth != _actualEndWidth
        ? (_actualEndWidth - _actualStartWidth).abs() / 2
        : _actualEndWidth / 2;
    if (!_axis.canScaleToFit) {
      final double x = _axisRenderer._axisSize.width / 2 +
          ((_axisRenderer._radius - (_totalOffset + height)) *
              math.cos(labelRadian)) -
          _axisRenderer._centerX;
      final double y = _axisRenderer._axisSize.height / 2 +
          ((_axisRenderer._radius - (_totalOffset + height)) *
              math.sin(labelRadian)) -
          _axisRenderer._centerY;
      _labelPosition = Offset(x, y);
    } else {
      final double x = _axisRenderer._axisCenter.dx +
          ((_axisRenderer._radius - (_totalOffset + height)) *
              math.cos(labelRadian));
      final double y = _axisRenderer._axisCenter.dy +
          ((_axisRenderer._radius - (_totalOffset + height)) *
              math.sin(labelRadian));
      _labelPosition = Offset(x, y);
    }
  }
}
