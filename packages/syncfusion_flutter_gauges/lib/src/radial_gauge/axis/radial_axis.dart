part of gauges;

/// The [RadialAxis] is a circular arc in which a set of values are
/// displayed along a linear or custom scale
/// based on the design requirements.
///
/// ```dart
/// Widget build(BuildContext context) {
///    return Container(
///        child: SfRadialGauge(
///          axes:<RadialAxis>[RadialAxis(
///            )]
///        ));
///}
/// ```
class RadialAxis extends GaugeAxis {
  /// Create [RadialAxis] with the default or required scale range and
  /// customized axis properties.
  ///
  /// The arguments [minimum], [maximum], [startAngle], [endAngle],
  /// [radiusFactor], [centerX], [centerY],
  /// [tickOffset] and [labelOffset] must not be null.
  /// Additionally [centerX], [centerY] must be non-negative
  /// and [maximum] must be creater than [minimum].
  RadialAxis(
      {this.startAngle = 130,
      this.endAngle = 50,
      this.radiusFactor = 0.95,
      this.centerX = 0.5,
      this.onLabelCreated,
      this.onAxisTapped,
      this.canRotateLabels = false,
      this.centerY = 0.5,
      this.showFirstLabel = true,
      this.showLastLabel = false,
      this.canScaleToFit = false,
      List<GaugeRange> ranges,
      List<GaugePointer> pointers,
      List<GaugeAnnotation> annotations,
      GaugeTextStyle axisLabelStyle,
      AxisLineStyle axisLineStyle,
      MajorTickStyle majorTickStyle,
      MinorTickStyle minorTickStyle,
      this.backgroundImage,
      GaugeAxisRendererFactory onCreateAxisRenderer,
      double minimum = 0,
      double maximum = 100,
      double interval,
      double minorTicksPerInterval,
      bool showLabels,
      bool showAxisLine,
      bool showTicks,
      double tickOffset = 0,
      double labelOffset = 15,
      bool isInversed,
      GaugeSizeUnit offsetUnit,
      num maximumLabels = 3,
      bool useRangeColorForAxis,
      String labelFormat,
      NumberFormat numberFormat,
      ElementsPosition ticksPosition,
      ElementsPosition labelsPosition})
      : assert(minimum != null, 'Minimum must not be null.'),
        assert(maximum != null, 'Maximum must not be null.'),
        assert(startAngle != null, 'Start angle must not be null.'),
        assert(endAngle != null, 'End angle must not be null.'),
        assert(radiusFactor != null, 'Radius factor must not be null.'),
        assert(centerX != null, 'Center X must not be null.'),
        assert(centerY != null, 'Center Y must not be null.'),
        assert(
            radiusFactor >= 0, 'Radius factor must be a non-negative value.'),
        assert(centerX >= 0, 'Center X must be a non-negative value.'),
        assert(centerY >= 0, 'Center Y must be a non-negative value.'),
        assert(minimum < maximum, 'Maximum should be greater than minimum.'),
        assert(tickOffset != null, 'Tick offset should not be equal to null.'),
        assert(labelOffset != null, 'Label offset must not be equal to null.'),
        super(
            ranges: ranges,
            annotations: annotations,
            pointers: pointers,
            onCreateAxisRenderer: onCreateAxisRenderer,
            minimum: minimum,
            maximum: maximum,
            interval: interval,
            minorTicksPerInterval: minorTicksPerInterval ?? 1,
            showLabels: showLabels ?? true,
            showAxisLine: showAxisLine ?? true,
            showTicks: showTicks ?? true,
            tickOffset: tickOffset,
            labelOffset: labelOffset,
            isInversed: isInversed ?? false,
            maximumLabels: maximumLabels,
            useRangeColorForAxis: useRangeColorForAxis ?? false,
            labelFormat: labelFormat,
            offsetUnit: offsetUnit ?? GaugeSizeUnit.logicalPixel,
            numberFormat: numberFormat,
            ticksPosition: ticksPosition ?? ElementsPosition.inside,
            labelsPosition: labelsPosition ?? ElementsPosition.inside,
            axisLabelStyle: axisLabelStyle ??
                GaugeTextStyle(
                    fontSize: 12.0,
                    fontFamily: 'Segoe UI',
                    fontStyle: FontStyle.normal,
                    fontWeight: FontWeight.normal),
            axisLineStyle: axisLineStyle ??
                AxisLineStyle(
                  thickness: 10,
                ),
            majorTickStyle: majorTickStyle ?? MajorTickStyle(),
            minorTickStyle: minorTickStyle ?? MinorTickStyle());

  /// Specifies the start angle of axis.
  ///
  /// The axis line begins from [startAngle] to [endAngle].
  ///
  /// The picture below illustrates the direction of the angle from 0 degree
  /// to 360 degree.
  ///
  /// ![The radial gauge direction of the angle from 0 degree to
  /// 360 degree.](https://cdn.syncfusion.com/content/images/FTControl/Gauge-Angle.jpg)
  ///
  /// Defaults to 130
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfRadialGauge(
  ///          axes:<RadialAxis>[RadialAxis(
  ///           startAngle: 90,
  ///            )]
  ///        ));
  ///}
  /// ```
  final double startAngle;

  /// Specifies the end angle of axis.
  ///
  /// The axis line begins from [startAngle] to [endAngle].
  ///
  /// The picture below illustrates the direction of the angle from 0 degree
  /// to 360 degree.
  ///
  /// ![The radial gauge direction of the angle from 0 degree to
  /// 360 degree.](https://cdn.syncfusion.com/content/images/FTControl/Gauge-Angle.jpg)
  ///
  /// Defaults to 50
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfRadialGauge(
  ///          axes:<RadialAxis>[RadialAxis(
  ///           endAngle: 90,
  ///            )]
  ///        ));
  ///}
  /// ```
  final double endAngle;

  /// The size of the axis, expressed as the radius (half the diameter)
  /// in factor.
  ///
  /// The [radiusFactor] must be between 0 and 1. Axis radius is determined
  /// by multiplying this factor
  /// value to the minimum width or height of the widget.
  ///
  /// Defaults to 0.95
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfRadialGauge(
  ///          axes:<RadialAxis>[RadialAxis(
  ///           radiusFactor: 0.8,
  ///            )]
  ///        ));
  ///}
  /// ```
  final double radiusFactor;

  /// Left location of center axis.
  ///
  /// The [centerX] value must be between 0 to 1. Change the left position
  /// of the axis inside the boundary of the widget.
  ///
  /// Defaults to 0.5
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfRadialGauge(
  ///          axes:<RadialAxis>[RadialAxis(
  ///           centerX: 0.2,
  ///            )]
  ///        ));
  ///}
  /// ```
  final double centerX;

  /// Top location of center axis.
  ///
  /// The [centerY] value must be between 0 to 1. Change the top position
  /// of the axis inside the boundary of the widget.
  ///
  /// Defaults to 0.5
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfRadialGauge(
  ///          axes:<RadialAxis>[RadialAxis(
  ///           centerY: 0.2,
  ///            )]
  ///        ));
  ///}
  /// ```
  final double centerY;

  /// Whether to show the first label of the axis.
  ///
  /// When [startAngle] and [endAngle] are the same, the first and
  /// last labels are intersected.
  /// To prevent this, enable this property to be false,
  /// if [showLastLabel] is true.
  ///
  /// Defaults to true
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfRadialGauge(
  ///          axes:<RadialAxis>[RadialAxis(
  ///           showFirstLabel: false,
  ///            )]
  ///        ));
  ///}
  /// ```
  final bool showFirstLabel;

  /// Whether to show the last label of the axis.
  ///
  /// Defaults to false
  /// ```dart
  /// Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfRadialGauge(
  ///          axes:<RadialAxis>[RadialAxis(
  ///           showLastLabel: false,
  ///            )]
  ///        ));
  ///}
  /// ```
  final bool showLastLabel;

  /// The callback that is called when an axis label is created.
  ///
  /// The [RadialAxis] passes the [AxisLabelCreatedArgs] to the callback
  /// is used to change text value and rotate the
  /// text based on angle.
  /// ```dart
  /// Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfRadialGauge(
  ///          axes:<RadialAxis>[RadialAxis(
  ///           labelCreated: _handleAxisLabelCreated,
  ///            )]
  ///        ));
  ///}
  ///
  ///   void _handleAxisLabelCreated(AxisLabelCreatedArgs args){
  //    if(args.text == '100'){
  //      args.text = 'Completed';
  //      args.canRotate = true;
  //    }
  //  }
  /// ```
  final ValueChanged<AxisLabelCreatedArgs> onLabelCreated;

  /// The callback that is called when an axis is tapped.
  ///
  /// The [RadialAxis] passes the tapped axis value to the callback.
  ///
  /// ``` dart
  /// Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfRadialGauge(
  ///          axes:<RadialAxis>[RadialAxis(
  ///           onAxisTapped: (double value) {
  ///             print('Axis tapped on $value');
  ///            })]
  ///        ));
  ///}
  ///
  /// ```
  final ValueChanged<double> onAxisTapped;

  /// whether to rotate the labels based on angle.
  ///
  /// Defaults to false
  /// ```dart
  /// Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfRadialGauge(
  ///          axes:<RadialAxis>[RadialAxis(
  ///           canRotateLabels: true,
  ///            )]
  ///        ));
  ///}
  /// ```
  final bool canRotateLabels;

  /// The background image of the [RadialAxis]. Changing the image
  /// will set the background to the new image.
  ///
  /// The [backgroundImage] applied for the [RadialAxis] boundary.
  ///
  /// This property is a type of [ImageProvider]. Therefore, you can set
  /// the following types of image on this.
  ///
  /// * [AssetImage]
  /// * [NetworkImage]
  /// * [FileImage]
  /// * [MemoryImage]
  ///
  /// Defaults to null.
  ///
  ///```dart
  /// Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfRadialGauge(
  ///          axes:<RadialAxis>[RadialAxis(
  ///           backgroundImage: AssetImage('images/dark_background.png')
  ///            )]
  ///        ));
  ///}
  ///```
  final ImageProvider backgroundImage;

  /// Adjust the half or quarter gauge to fit the axis boundary.
  ///
  /// if [canScaleToFit] true, the center and radius position of the axis
  /// will be modified on the basis of the angle value.
  ///
  /// Defaults to false
  ///```dart
  /// Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfRadialGauge(
  ///          axes:<RadialAxis>[RadialAxis(
  ///           canScaleToFit : true
  ///            )]
  ///        ));
  ///}
  ///```
  final bool canScaleToFit;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }
    return other is RadialAxis &&
        other.startAngle == startAngle &&
        other.endAngle == endAngle &&
        other.minimum == minimum &&
        other.maximum == maximum &&
        other.axisLineStyle == axisLineStyle &&
        other.labelOffset == labelOffset &&
        other.tickOffset == tickOffset &&
        other.showLabels == showLabels &&
        other.showTicks == showTicks &&
        other.showAxisLine == showAxisLine &&
        other.showLastLabel == showLastLabel &&
        other.showFirstLabel == showFirstLabel &&
        other.interval == interval &&
        other.minorTicksPerInterval == minorTicksPerInterval &&
        other.maximumLabels == maximumLabels &&
        other.isInversed == isInversed &&
        other.labelFormat == labelFormat &&
        other.numberFormat == numberFormat &&
        other.radiusFactor == radiusFactor &&
        other.ticksPosition == ticksPosition &&
        other.labelsPosition == labelsPosition &&
        other.onLabelCreated == onLabelCreated &&
        other.centerX == centerX &&
        other.centerY == centerY &&
        other.canScaleToFit == canScaleToFit &&
        other.onAxisTapped == onAxisTapped &&
        other.canRotateLabels == canRotateLabels &&
        other.majorTickStyle == majorTickStyle &&
        other.minorTickStyle == minorTickStyle &&
        other.useRangeColorForAxis == useRangeColorForAxis &&
        other.axisLabelStyle == axisLabelStyle &&
        other.onCreateAxisRenderer == other.onCreateAxisRenderer &&
        other.backgroundImage == backgroundImage;
  }

  @override
  int get hashCode {
    final List<Object> values = <Object>[
      startAngle,
      endAngle,
      hashList(ranges),
      hashList(pointers),
      hashList(annotations),
      minimum,
      maximum,
      axisLineStyle,
      labelOffset,
      tickOffset,
      offsetUnit,
      showLabels,
      showTicks,
      showAxisLine,
      showLastLabel,
      showFirstLabel,
      interval,
      minorTicksPerInterval,
      maximumLabels,
      isInversed,
      labelFormat,
      numberFormat,
      radiusFactor,
      ticksPosition,
      labelsPosition,
      onLabelCreated,
      centerX,
      centerY,
      canScaleToFit,
      onAxisTapped,
      canRotateLabels,
      majorTickStyle,
      minorTickStyle,
      useRangeColorForAxis,
      axisLabelStyle,
      backgroundImage,
      onCreateAxisRenderer
    ];
    return hashList(values);
  }
}

/// Represents the renderer for radial axis
class RadialAxisRenderer extends GaugeAxisRenderer {
  /// Creates the instance for radial axis renderer
  RadialAxisRenderer() {
    _needsRepaintAxis = true;
  }

  /// Specifies whether to include axis elements when calculating the radius
  final bool _useAxisElementsInsideRadius = true;

  /// Specifies the axis corresponding to this renderer;
  RadialAxis _axis;

  ///Specifies the axis rect
  Rect _axisRect;

  /// Specifies the start radian value
  double _startRadian;

  /// Specifies the end radian value
  double _endRadian;

  ///Specifies the radius value
  double _radius;

  ///Specifies the axis center
  double _center;

  ///Specifies the center X value of axis
  double _centerX;

  ///Specifies the center  Y value od axis
  double _centerY;

  /// Specifies the actual axis width
  double _actualAxisWidth;

  /// Specifies the list of axis labels
  List<CircularAxisLabel> _axisLabels;

  /// Specifies the offset value of major ticks
  List<_TickOffset> _majorTickOffsets;

  /// Specifies the offset value of minor ticks
  List<_TickOffset> _minorTickOffsets;

  /// Specifies the major tick count
  num _majorTicksCount;

  ///Holds the sweep angle of the axis
  double _sweepAngle;

  /// Holds the size of the axis
  Size _axisSize;

  /// Holds the length of major tick based on coordinate unit
  double _actualMajorTickLength;

  /// Holds the length of minor tick based on coordinate unit
  double _actualMinorTickLength;

  /// Specifies the maximum label size
  Size _maximumLabelSize;

  /// Specifies whether the ticks are placed outside
  bool _isTicksOutside;

  /// Specifies whether the labels are placed outside
  bool _isLabelsOutside;

  /// Specifies the maximum length of tick by comparing major and minor tick
  double _maximumTickLength;

  /// Specifies whether to repaint the axis;
  bool _needsRepaintAxis;

  /// Specifies the axis path
  Path _axisPath;

  /// Specifies the axis offset
  double _axisOffset;

  /// Specifies the start corner radian
  double _startCornerRadian;

  /// Specifies the sweep corner radian
  double _sweepCornerRadian;

  /// Specifies the actual label offset
  double _actualLabelOffset;

  /// Specifies the actual tick offset
  double _actualTickOffset;

  /// Specifies the corner angle
  double _cornerAngle;

  /// Specifies the listener
  ImageStreamListener _listener;

  /// Specifies the background image info;
  ImageInfo _backgroundImageInfo;

  /// Specifies the image stream
  ImageStream _imageStream;

  /// Specifies the difference in the radius
  double _diffInRadius;

  /// Specifies the center point of the axis
  Offset _axisCenter;

  /// Specifies the rendering details corresponding to the gauge.
  _RenderingDetails _renderingDetails;

  /// Specifies the actual interval of the axis
  num _actualInterval;

  /// Specifies whether the maximum value is included in axis labels
  bool _isMaxiumValueIncluded = false;

  /// To calculate the radius and the center point based on the angle
  Offset _getAxisBounds() {
    final Offset centerOffset = _getCenter();
    final double minScale = math.min(_axisSize.height, _axisSize.width);
    final double x = ((centerOffset.dx * 2) - minScale) / 2;
    final double y = ((centerOffset.dy * 2) - minScale) / 2;
    Rect bounds = Rect.fromLTRB(x, y, minScale, minScale);
    final double centerYDiff = (_axisSize.height / 2 - centerOffset.dy).abs();
    final double centerXDiff = (_axisSize.width / 2 - centerOffset.dx).abs();
    double diff = 0;
    if (_axisSize.width > _axisSize.height) {
      diff = centerYDiff / 2;
      final double angleRadius = _axisSize.height / 2 + diff;
      if (_axisSize.width / 2 < angleRadius) {
        final double actualDiff = _axisSize.width / 2 - _axisSize.height / 2;
        diff = actualDiff * 0.7;
      }

      bounds = Rect.fromLTRB(
          x - diff / 2, y, x + minScale + (diff / 2), y + minScale + diff);
    } else {
      diff = centerXDiff / 2;
      final double angleRadius = _axisSize.width / 2 + diff;

      if (_axisSize.height / 2 < angleRadius) {
        final double actualDiff = _axisSize.height / 2 - _axisSize.width / 2;
        diff = actualDiff * 0.7;
      }

      bounds = Rect.fromLTRB(x - diff / 2, y - diff / 2,
          x + minScale + (diff / 2), y + minScale + (diff / 2));
    }

    _diffInRadius = diff;

    return Offset(
        bounds.left + (bounds.width / 2), bounds.top + (bounds.height / 2));
  }

  /// Calculates the default values of the axis
  void _calculateDefaultValues() {
    _startRadian = _getDegreeToRadian(_axis.startAngle);
    _sweepAngle = _getSweepAngle();
    _endRadian = _getDegreeToRadian(_sweepAngle);
    _center = math.min(_axisSize.width / 2, _axisSize.height / 2);

    if (!_axis.canScaleToFit) {
      _radius = _center * _axis.radiusFactor;
      _centerX = (_axisSize.width / 2) - (_axis.centerX * _axisSize.width);
      _centerY = (_axisSize.height / 2) - (_axis.centerY * _axisSize.height);
      _axisCenter = Offset(
          _axisSize.width / 2 - _centerX, _axisSize.height / 2 - _centerY);
    } else {
      final Offset centerPoint = _getAxisBounds();
      _centerX = centerPoint.dx;
      _centerY = centerPoint.dy;
      _radius = (_center + _diffInRadius) * _axis.radiusFactor;
      _axisCenter = Offset(_centerX, _centerY);
    }

    _actualAxisWidth = _getActualValue(_axis.axisLineStyle.thickness,
        _axis.axisLineStyle.thicknessUnit, false);
    _actualMajorTickLength = _getTickLength(true);
    _actualMinorTickLength = _getTickLength(false);
    _maximumTickLength = _actualMajorTickLength > _actualMinorTickLength
        ? _actualMajorTickLength
        : _actualMinorTickLength;
    _actualLabelOffset =
        _getActualValue(_axis.labelOffset, _axis.offsetUnit, true);
    _actualTickOffset =
        _getActualValue(_axis.tickOffset, _axis.offsetUnit, true);
    if (_axis.backgroundImage != null) {
      _listener = ImageStreamListener(_updateBackgroundImage);
    }
  }

  /// Method to calculate the axis range
  void _calculateAxisRange(BoxConstraints constraints, BuildContext context,
      SfGaugeThemeData gaugeThemeData, _RenderingDetails animationDetails) {
    _renderingDetails = animationDetails;
    _axisSize = Size(constraints.maxWidth, constraints.maxHeight);
    _calculateAxisElementsPosition(context);
    if (_axis.pointers != null && _axis.pointers.isNotEmpty) {
      _renderPointers();
    }

    if (_axis.ranges != null && _axis.ranges.isNotEmpty) {
      _renderRanges();
    }
  }

  /// Methods to calculate axis elements position
  void _calculateAxisElementsPosition(BuildContext context) {
    _isTicksOutside = _axis.ticksPosition == ElementsPosition.outside;
    _isLabelsOutside = _axis.labelsPosition == ElementsPosition.outside;
    _calculateDefaultValues();
    _axisLabels = generateVisibleLabels();
    if (_axis.showLabels) {
      _measureAxisLabels();
    }

    _axisOffset = _useAxisElementsInsideRadius ? _getAxisOffset() : 0;

    if (_axis.showTicks) {
      _calculateMajorTicksPosition();
      _calculateMinorTickPosition();
    }

    if (_axis.showLabels) {
      _calculateAxisLabelsPosition();
    }

    _calculateAxisRect();
    if (_axis.showAxisLine) {
      _calculateCornerStylePosition();
    }

    if (_axis.backgroundImage != null && _backgroundImageInfo?.image == null) {
      _loadBackgroundImage(context);
    }
  }

  /// To calculate the center based on the angle
  Offset _getCenter() {
    final double x = _axisSize.width / 2;
    final double y = _axisSize.height / 2;
    _radius = _center;
    Offset actualCenter = Offset(x, y);
    final double actualStartAngle = _getWrapAngle(_axis.startAngle, -630, 630);
    final double actualEndAngle =
        _getWrapAngle(_axis.startAngle + _sweepAngle.abs(), -630, 630);
    final List<double> regions = <double>[
      -630,
      -540,
      -450,
      -360,
      -270,
      -180,
      -90,
      0,
      90,
      180,
      270,
      360,
      450,
      540,
      630
    ];
    final List<int> region = <int>[];
    if (actualStartAngle < actualEndAngle) {
      for (int i = 0; i < regions.length; i++) {
        if (regions[i] > actualStartAngle && regions[i] < actualEndAngle) {
          region.add(((regions[i] % 360) < 0
                  ? (regions[i] % 360) + 360
                  : (regions[i] % 360))
              .toInt());
        }
      }
    } else {
      for (int i = 0; i < regions.length; i++) {
        if (regions[i] < actualStartAngle && regions[i] > actualEndAngle) {
          region.add(((regions[i] % 360) < 0
                  ? (regions[i] % 360) + 360
                  : (regions[i] % 360))
              .toInt());
        }
      }
    }

    final double startRadian = 2 * math.pi * (actualStartAngle / 360);
    final double endRadian = 2 * math.pi * (actualEndAngle / 360);
    final Offset startPoint = Offset(x + (_radius * math.cos(startRadian)),
        y + (_radius * math.sin(startRadian)));
    final Offset endPoint = Offset(x + (_radius * math.cos(endRadian)),
        y + (_radius * math.sin(endRadian)));

    switch (region.length) {
      case 0:
        actualCenter = _getCenterForLengthZero(
            startPoint, endPoint, x, y, _radius, region);
        break;
      case 1:
        actualCenter =
            _getCenterLengthOne(startPoint, endPoint, x, y, _radius, region);
        break;
      case 2:
        actualCenter =
            _getCenterForLengthTwo(startPoint, endPoint, x, y, _radius, region);
        break;
      case 3:
        actualCenter = _getCenterForLengthThree(
            startPoint, endPoint, x, y, _radius, region);
        break;
    }

    return actualCenter;
  }

  /// Calculate the center point when the region length is zero
  Offset _getCenterForLengthZero(Offset startPoint, Offset endPoint, double x,
      double y, double radius, List<int> region) {
    final double longX = (x - startPoint.dx).abs() > (x - endPoint.dx).abs()
        ? startPoint.dx
        : endPoint.dx;
    final double longY = (y - startPoint.dy).abs() > (y - endPoint.dy).abs()
        ? startPoint.dy
        : endPoint.dy;
    final Offset midPoint =
        Offset((x + longX).abs() / 2, (y + longY).abs() / 2);
    final double xValue = x + (x - midPoint.dx);
    final double yValue = y + (y - midPoint.dy);
    return Offset(xValue, yValue);
  }

  ///Calculates the center when the region length is two.
  Offset _getCenterLengthOne(Offset startPoint, Offset endPoint, double x,
      double y, double radius, List<int> region) {
    Offset point1;
    Offset point2;
    final double maxRadian = 2 * math.pi * region[0] / 360;
    final Offset maxPoint = Offset(
        x + (radius * math.cos(maxRadian)), y + (radius * math.sin(maxRadian)));

    switch (region[0]) {
      case 270:
        point1 = Offset(startPoint.dx, maxPoint.dy);
        point2 = Offset(endPoint.dx, y);
        break;
      case 0:
      case 360:
        point1 = Offset(x, endPoint.dy);
        point2 = Offset(maxPoint.dx, startPoint.dy);
        break;
      case 90:
        point1 = Offset(endPoint.dx, y);
        point2 = Offset(startPoint.dx, maxPoint.dy);
        break;
      case 180:
        point1 = Offset(maxPoint.dx, startPoint.dy);
        point2 = Offset(x, endPoint.dy);
        break;
    }

    final Offset midPoint =
        Offset((point1.dx + point2.dx) / 2, (point1.dy + point2.dy) / 2);
    final double xValue =
        x + ((x - midPoint.dx) >= radius ? 0 : (x - midPoint.dx));
    final double yValue =
        y + ((y - midPoint.dy) >= radius ? 0 : (y - midPoint.dy));
    return Offset(xValue, yValue);
  }

  ///Calculates the center when the region length is two.
  Offset _getCenterForLengthTwo(Offset startPoint, Offset endPoint, double x,
      double y, double radius, List<int> region) {
    Offset point1;
    Offset point2;
    final double minRadian = 2 * math.pi * region[0] / 360;
    final double maxRadian = 2 * math.pi * region[1] / 360;
    final Offset maxPoint = Offset(
        x + (radius * math.cos(maxRadian)), y + (radius * math.sin(maxRadian)));
    final Offset minPoint = Offset(
        x + (radius * math.cos(minRadian)), y + (radius * math.sin(minRadian)));

    if ((region[0] == 0 && region[1] == 90) ||
        (region[0] == 180 && region[1] == 270)) {
      point1 = Offset(minPoint.dx, maxPoint.dy);
    } else {
      point1 = Offset(maxPoint.dx, minPoint.dy);
    }

    if (region[0] == 0 || region[0] == 180) {
      point2 = Offset(_getMinMaxValue(startPoint, endPoint, region[0]),
          _getMinMaxValue(startPoint, endPoint, region[1]));
    } else {
      point2 = Offset(_getMinMaxValue(startPoint, endPoint, region[1]),
          _getMinMaxValue(startPoint, endPoint, region[0]));
    }

    final Offset midPoint = Offset(
        (point1.dx - point2.dx).abs() / 2 >= radius
            ? 0
            : (point1.dx + point2.dx) / 2,
        (point1.dy - point2.dy).abs() / 2 >= radius
            ? 0
            : (point1.dy + point2.dy) / 2);
    final double xValue = x +
        (midPoint.dx == 0
            ? 0
            : (x - midPoint.dx) >= radius ? 0 : (x - midPoint.dx));
    final double yValue = y +
        (midPoint.dy == 0
            ? 0
            : (y - midPoint.dy) >= radius ? 0 : (y - midPoint.dy));
    return Offset(xValue, yValue);
  }

  ///Calculates the center when the region length is three.
  Offset _getCenterForLengthThree(Offset startPoint, Offset endPoint, double x,
      double y, double radius, List<int> region) {
    final double region0Radian = 2 * math.pi * region[0] / 360;
    final double region1Radian = 2 * math.pi * region[1] / 360;
    final double region2Radian = 2 * math.pi * region[2] / 360;
    final Offset region0Point = Offset(x + (radius * math.cos(region0Radian)),
        y + (radius * math.sin(region0Radian)));
    final Offset region1Point = Offset(x + (radius * math.cos(region1Radian)),
        y + (radius * math.sin(region1Radian)));
    final Offset region2Point = Offset(x + (radius * math.cos(region2Radian)),
        y + (radius * math.sin(region2Radian)));
    Offset regionStartPoint;
    Offset regionEndPoint;
    switch (region[2]) {
      case 0:
      case 360:
        regionStartPoint = Offset(region0Point.dx, region1Point.dy);
        regionEndPoint =
            Offset(region2Point.dx, math.max(startPoint.dy, endPoint.dy));
        break;
      case 90:
        regionStartPoint =
            Offset(math.min(startPoint.dx, endPoint.dx), region0Point.dy);
        regionEndPoint = Offset(region1Point.dx, region2Point.dy);
        break;
      case 180:
        regionStartPoint =
            Offset(region2Point.dx, math.min(startPoint.dy, endPoint.dy));
        regionEndPoint = Offset(region0Point.dx, region1Point.dy);
        break;
      case 270:
        regionStartPoint = Offset(region1Point.dx, region2Point.dy);
        regionEndPoint =
            Offset(math.max(startPoint.dx, endPoint.dx), region0Point.dy);
        break;
    }

    final Offset midRegionPoint = Offset(
        (regionStartPoint.dx - regionEndPoint.dx).abs() / 2 >= radius
            ? 0
            : (regionStartPoint.dx + regionEndPoint.dx) / 2,
        (regionStartPoint.dy - regionEndPoint.dy).abs() / 2 >= radius
            ? 0
            : (regionStartPoint.dy + regionEndPoint.dy) / 2);
    final double xValue = x +
        (midRegionPoint.dx == 0
            ? 0
            : (x - midRegionPoint.dx) >= radius ? 0 : (x - midRegionPoint.dx));
    final double yValue = y +
        (midRegionPoint.dy == 0
            ? 0
            : (y - midRegionPoint.dy) >= radius ? 0 : (y - midRegionPoint.dy));
    return Offset(xValue, yValue);
  }

  /// To calculate the value based on the angle
  double _getMinMaxValue(Offset startPoint, Offset endPoint, int degree) {
    final double minX = math.min(startPoint.dx, endPoint.dx);
    final double minY = math.min(startPoint.dy, endPoint.dy);
    final double maxX = math.max(startPoint.dx, endPoint.dx);
    final double maxY = math.max(startPoint.dy, endPoint.dy);
    switch (degree) {
      case 270:
        return maxY;
      case 0:
      case 360:
        return minX;
      case 90:
        return minY;
      case 180:
        return maxX;
    }

    return 0;
  }

  /// To calculate the wrap angle
  double _getWrapAngle(double angle, double min, double max) {
    if (max - min == 0) {
      return min;
    }

    angle = ((angle - min) % (max - min)) + min;
    while (angle < min) {
      angle += max - min;
    }

    return angle;
  }

  /// Calculates the rounded corner position
  void _calculateCornerStylePosition() {
    final double cornerCenter = (_axisRect.right - _axisRect.left) / 2;
    _cornerAngle = _cornerRadiusAngle(cornerCenter, _actualAxisWidth / 2);

    switch (_axis.axisLineStyle.cornerStyle) {
      case CornerStyle.startCurve:
        {
          _startCornerRadian = _axis.isInversed
              ? _getDegreeToRadian(-_cornerAngle)
              : _getDegreeToRadian(_cornerAngle);
          _sweepCornerRadian = _axis.isInversed
              ? _getDegreeToRadian((-_sweepAngle) + _cornerAngle)
              : _getDegreeToRadian(_sweepAngle - _cornerAngle);
        }
        break;
      case CornerStyle.endCurve:
        {
          _startCornerRadian = _getDegreeToRadian(0);
          _sweepCornerRadian = _axis.isInversed
              ? _getDegreeToRadian((-_sweepAngle) + _cornerAngle)
              : _getDegreeToRadian(_sweepAngle - _cornerAngle);
        }
        break;
      case CornerStyle.bothCurve:
        {
          _startCornerRadian = _axis.isInversed
              ? _getDegreeToRadian(-_cornerAngle)
              : _getDegreeToRadian(_cornerAngle);
          _sweepCornerRadian = _axis.isInversed
              ? _getDegreeToRadian((-_sweepAngle) + (2 * _cornerAngle))
              : _getDegreeToRadian(_sweepAngle - (2 * _cornerAngle));
        }
        break;
      case CornerStyle.bothFlat:
        _startCornerRadian = !_axis.isInversed
            ? _getDegreeToRadian(0)
            : _getDegreeToRadian(_axis.startAngle + _sweepAngle);
        final double _value = _axis.isInversed ? -1 : 1;
        _sweepCornerRadian = _getDegreeToRadian(_sweepAngle * _value);
        break;
    }
  }

  /// Calculates the axis rect
  void _calculateAxisRect() {
    _axisRect = Rect.fromLTRB(
        -(_radius - (_actualAxisWidth / 2 + _axisOffset)),
        -(_radius - (_actualAxisWidth / 2 + _axisOffset)),
        _radius - (_actualAxisWidth / 2 + _axisOffset),
        _radius - (_actualAxisWidth / 2 + _axisOffset));
    _axisPath = Path();
    final Rect rect = Rect.fromLTRB(
      _axisRect.left + _axisSize.width / 2,
      _axisRect.top + _axisSize.height / 2,
      _axisRect.right + _axisSize.width / 2,
      _axisRect.bottom + _axisSize.height / 2,
    );
    _axisPath.arcTo(rect, _startRadian, _endRadian, false);
  }

  /// Method to calculate the angle from the tapped point
  void _calculateAngleFromOffset(Offset offset) {
    final double actualCenterX = _axisSize.width * _axis.centerX;
    final double actualCenterY = _axisSize.height * _axis.centerY;
    double angle =
        math.atan2(offset.dy - actualCenterY, offset.dx - actualCenterX) *
                (180 / math.pi) +
            360;
    final double actualEndAngle = _axis.startAngle + _sweepAngle;
    if (angle < 360 && angle > 180) {
      angle += 360;
    }

    if (angle > actualEndAngle) {
      angle %= 360;
    }

    if (angle >= _axis.startAngle && angle <= actualEndAngle) {
      final double angleFactor = (angle - _axis.startAngle) / _sweepAngle;
      final double value = factorToValue(angleFactor);
      if (value >= _axis.minimum && value <= _axis.maximum) {
        final double _tappedValue = _angleToValue(angle);
        _axis.onAxisTapped(_tappedValue);
      }
    }
  }

  /// Calculate the offset for axis line based on ticks and labels
  double _getAxisOffset() {
    double offset = 0;
    offset = _isTicksOutside
        ? _axis.showTicks ? (_maximumTickLength + _actualTickOffset) : 0
        : 0;
    offset += _isLabelsOutside
        ? _axis.showLabels
            ? (math.max(_maximumLabelSize.height, _maximumLabelSize.width) / 2 +
                _actualLabelOffset)
            : 0
        : 0;
    return offset;
  }

  /// Converts the axis value to angle
  double _valueToAngle(double value) {
    double angle = 0;
    value = _getMinMax(value, _axis.minimum, _axis.maximum);
    if (!_axis.isInversed) {
      angle = (_sweepAngle / (_axis.maximum - _axis.minimum).abs()) *
          (_axis.minimum - value).abs();
    } else {
      angle = _sweepAngle -
          ((_sweepAngle / (_axis.maximum - _axis.minimum).abs()) *
              (_axis.minimum - value).abs());
    }

    return angle;
  }

  /// Converts the angle to corresponding axis value
  double _angleToValue(double angle) {
    double value = 0;
    if (!_axis.isInversed) {
      value = (angle -
              _axis.startAngle +
              ((_sweepAngle / (_axis.maximum - _axis.minimum)) *
                  _axis.minimum)) *
          ((_axis.maximum - _axis.minimum) / _sweepAngle);
    } else {
      value = -(angle -
              _axis.startAngle -
              _sweepAngle +
              ((_sweepAngle / (_axis.maximum - _axis.minimum)) *
                  _axis.minimum.abs())) *
          ((_axis.maximum - _axis.minimum) / _sweepAngle);
    }

    return value;
  }

  /// Calculates the major ticks position
  void _calculateMajorTicksPosition() {
    if (_axisLabels != null && _axisLabels.isNotEmpty) {
      double angularSpaceForTicks;
      if (_actualInterval != null) {
        _majorTicksCount = (_axis.maximum - _axis.minimum) / _actualInterval;
        angularSpaceForTicks =
            _getDegreeToRadian(_sweepAngle / (_majorTicksCount));
      } else {
        _majorTicksCount = _axisLabels.length;
        angularSpaceForTicks =
            _getDegreeToRadian(_sweepAngle / (_majorTicksCount - 1));
      }

      final double axisLineWidth = _axis.showAxisLine ? _actualAxisWidth : 0;
      double angleForTicks = 0;
      double tickStartOffset = 0;
      double tickEndOffset = 0;
      _majorTickOffsets = <_TickOffset>[];
      angleForTicks = _axis.isInversed
          ? _getDegreeToRadian(_axis.startAngle + _sweepAngle - 90)
          : _getDegreeToRadian(_axis.startAngle - 90);
      final double offset = _isLabelsOutside
          ? _axis.showLabels
              ? (math.max(_maximumLabelSize.height, _maximumLabelSize.width) /
                      2 +
                  _actualLabelOffset)
              : 0
          : 0;
      if (!_isTicksOutside) {
        tickStartOffset =
            _radius - (axisLineWidth + _actualTickOffset + offset);
        tickEndOffset = _radius -
            (axisLineWidth +
                _actualMajorTickLength +
                _actualTickOffset +
                offset);
      } else {
        final bool isGreater = _actualMajorTickLength > _actualMinorTickLength;

        // Calculates the major tick position based on the tick length
        // and another features offset value
        if (!_useAxisElementsInsideRadius) {
          tickStartOffset = _radius + _actualTickOffset;
          tickEndOffset = _radius + _actualMajorTickLength + _actualTickOffset;
        } else {
          tickStartOffset = isGreater
              ? _radius - offset
              : _radius -
                  (_maximumTickLength - _actualMajorTickLength + offset);
          tickEndOffset = _radius - (offset + _maximumTickLength);
        }
      }

      _calculateOffsetForMajorTicks(
          tickStartOffset, tickEndOffset, angularSpaceForTicks, angleForTicks);
    }
  }

  /// Calculates the offset for major ticks
  void _calculateOffsetForMajorTicks(double tickStartOffset,
      double tickEndOffset, double angularSpaceForTicks, double angleForTicks) {
    final num length =
        _actualInterval != null ? _majorTicksCount : _majorTicksCount - 1;
    for (num i = 0; i <= length; i++) {
      double tickAngle = 0;
      final num count =
          _actualInterval != null ? _majorTicksCount : _majorTicksCount - 1;
      if (i == 0 || i == count) {
        tickAngle =
            _getTickPositionInCorner(i, angleForTicks, tickStartOffset, true);
      } else {
        tickAngle = angleForTicks;
      }
      final List<Offset> tickPosition =
          _getTickPosition(tickStartOffset, tickEndOffset, tickAngle);
      final _TickOffset tickOffset = _TickOffset();
      tickOffset.startPoint = tickPosition[0];
      tickOffset.endPoint = tickPosition[1];
      tickOffset.value = factorToValue(
          (_getRadianToDegree(tickAngle) + 90 - _axis.startAngle) /
              _sweepAngle);
      final Offset centerPoint = !_axis.canScaleToFit
          ? Offset(_centerX, _centerY)
          : const Offset(0, 0);
      tickOffset.startPoint = Offset(tickOffset.startPoint.dx - centerPoint.dx,
          tickOffset.startPoint.dy - centerPoint.dy);
      tickOffset.endPoint = Offset(tickOffset.endPoint.dx - centerPoint.dx,
          tickOffset.endPoint.dy - centerPoint.dy);
      _majorTickOffsets.add(tickOffset);
      if (_axis.isInversed) {
        angleForTicks -= angularSpaceForTicks;
      } else {
        angleForTicks += angularSpaceForTicks;
      }
    }
  }

  /// Returns the corresponding range color for the value
  Color _getRangeColor(double value, SfGaugeThemeData gaugeThemeData) {
    Color color;
    if (_axis.ranges != null && _axis.ranges.isNotEmpty) {
      for (num i = 0; i < _axis.ranges.length; i++) {
        if (_axis.ranges[i].startValue <= value &&
            _axis.ranges[i].endValue >= value) {
          color = _axis.ranges[i].color ?? gaugeThemeData.rangeColor;
          break;
        }
      }
    }
    return color;
  }

  /// Calculates the angle to adjust the start and end tick
  double _getTickPositionInCorner(
      num num, double angleForTicks, double startOffset, bool isMajor) {
    final double thickness = isMajor
        ? _axis.majorTickStyle.thickness
        : _axis.minorTickStyle.thickness;
    final double angle =
        _cornerRadiusAngle(startOffset + _actualAxisWidth / 2, thickness / 2);
    if (num == 0) {
      final double ticksAngle = !_axis.isInversed
          ? _getRadianToDegree(angleForTicks) + angle
          : _getRadianToDegree(angleForTicks) - angle;
      return _getDegreeToRadian(ticksAngle);
    } else {
      final double ticksAngle = !_axis.isInversed
          ? _getRadianToDegree(angleForTicks) - angle
          : _getRadianToDegree(angleForTicks) + angle;
      return _getDegreeToRadian(ticksAngle);
    }
  }

  /// Calculates the minor tick position
  void _calculateMinorTickPosition() {
    if (_axisLabels != null && _axisLabels.isNotEmpty) {
      final double axisLineWidth = _axis.showAxisLine ? _actualAxisWidth : 0;
      double tickStartOffset = 0;
      double tickEndOffset = 0;
      final double offset = _isLabelsOutside
          ? _axis.showLabels
              ? (_actualLabelOffset +
                  math.max(_maximumLabelSize.height, _maximumLabelSize.width) /
                      2)
              : 0
          : 0;
      if (!_isTicksOutside) {
        tickStartOffset =
            _radius - (axisLineWidth + _actualTickOffset + offset);
        tickEndOffset = _radius -
            (axisLineWidth +
                _actualMinorTickLength +
                _actualTickOffset +
                offset);
      } else {
        final bool isGreater = _actualMinorTickLength > _actualMajorTickLength;
        if (!_useAxisElementsInsideRadius) {
          tickStartOffset = _radius + _actualTickOffset;
          tickEndOffset = _radius + _actualMinorTickLength + _actualTickOffset;
        } else {
          tickStartOffset = isGreater
              ? _radius - offset
              : _radius -
                  (_maximumTickLength - _actualMinorTickLength + offset);
          tickEndOffset = _radius - (_maximumTickLength + offset);
        }
      }

      _calculateOffsetForMinorTicks(tickStartOffset, tickEndOffset);
    }
  }

  /// Calculates the offset for minor ticks
  ///
  /// This method is quite a long method. This method could be refactored into
  /// the smaller method but it leads to passing more number of parameter and
  /// which degrades the performance
  void _calculateOffsetForMinorTicks(
      double tickStartOffset, double tickEndOffset) {
    _minorTickOffsets = <_TickOffset>[];
    double angularSpaceForTicks;
    double totalMinorTicks;
    if (_actualInterval != null) {
      final double majorTicksInterval =
          (_axis.maximum - _axis.minimum) / _actualInterval;
      angularSpaceForTicks =
          _getDegreeToRadian(_sweepAngle / majorTicksInterval);
      final double maximumLabelValue =
          _axisLabels[_axisLabels.length - 2].value.toDouble();
      final double difference = (_axis.maximum - maximumLabelValue);
      final double minorTickInterval =
          ((_actualInterval / 2) / _axis.minorTicksPerInterval);
      final int remainingTicks = difference ~/ minorTickInterval;
      totalMinorTicks =
          ((_axisLabels.length - 1) * _axis.minorTicksPerInterval) +
              remainingTicks;
    } else {
      angularSpaceForTicks =
          _getDegreeToRadian(_sweepAngle / (_majorTicksCount - 1));
      totalMinorTicks = (_axisLabels.length - 1) * _axis.minorTicksPerInterval;
    }

    double angleForTicks = _axis.isInversed
        ? _getDegreeToRadian(_axis.startAngle + _sweepAngle - 90)
        : _getDegreeToRadian(_axis.startAngle - 90);

    const num minorTickIndex = 1; // Since the minor tick rendering
    // needs to be start in the index one
    final double minorTickAngle =
        angularSpaceForTicks / (_axis.minorTicksPerInterval + 1);

    for (num i = minorTickIndex; i <= totalMinorTicks; i++) {
      if (_axis.isInversed) {
        angleForTicks -= minorTickAngle;
      } else {
        angleForTicks += minorTickAngle;
      }

      final double tickValue = double.parse(factorToValue(
              (_getRadianToDegree(angleForTicks) + 90 - _axis.startAngle) /
                  _sweepAngle)
          .toStringAsFixed(5));
      if (tickValue <= _axis.maximum) {
        if (tickValue == _axis.maximum) {
          angleForTicks = _getTickPositionInCorner(
              i, angleForTicks, tickStartOffset, false);
        }
        final List<Offset> tickPosition =
            _getTickPosition(tickStartOffset, tickEndOffset, angleForTicks);
        final _TickOffset tickOffset = _TickOffset();
        tickOffset.startPoint = tickPosition[0];
        tickOffset.endPoint = tickPosition[1];
        tickOffset.value = tickValue;

        final Offset centerPoint = !_axis.canScaleToFit
            ? Offset(_centerX, _centerY)
            : const Offset(0, 0);
        tickOffset.startPoint = Offset(
            tickOffset.startPoint.dx - centerPoint.dx,
            tickOffset.startPoint.dy - centerPoint.dy);
        tickOffset.endPoint = Offset(tickOffset.endPoint.dx - centerPoint.dx,
            tickOffset.endPoint.dy - centerPoint.dy);
        _minorTickOffsets.add(tickOffset);
        if (i % _axis.minorTicksPerInterval == 0) {
          if (_axis.isInversed) {
            angleForTicks -= minorTickAngle;
          } else {
            angleForTicks += minorTickAngle;
          }
        }
      }
    }
  }

  /// Calculate the axis label position
  void _calculateAxisLabelsPosition() {
    if (_axisLabels != null && _axisLabels.isNotEmpty) {
      // Calculates the angle between each  axis label
      double labelsInterval;
      if (_actualInterval != null) {
        labelsInterval = (_axis.maximum - _axis.minimum) / _actualInterval;
      } else {
        labelsInterval = (_axisLabels.length - 1).toDouble();
      }
      final double labelSpaceInAngle = _sweepAngle / labelsInterval;
      final double labelSpaceInRadian = _getDegreeToRadian(labelSpaceInAngle);
      final double tickLength = _actualMajorTickLength > _actualMinorTickLength
          ? _actualMajorTickLength
          : _actualMinorTickLength;
      final double tickPadding =
          _axis.showTicks ? tickLength + _actualTickOffset : 0;
      double labelRadian = 0;
      double labelAngle = 0;
      double labelPosition = 0;
      if (!_axis.isInversed) {
        labelAngle = _axis.startAngle - 90;
        labelRadian = _getDegreeToRadian(labelAngle);
      } else {
        labelAngle = _axis.startAngle + _sweepAngle - 90;
        labelRadian = _getDegreeToRadian(labelAngle);
      }

      final double labelSize =
          math.max(_maximumLabelSize.height, _maximumLabelSize.width) / 2;
      if (_isLabelsOutside) {
        final double featureOffset = labelSize;
        labelPosition = _useAxisElementsInsideRadius
            ? _radius - featureOffset
            : _radius + tickPadding + _actualLabelOffset;
      } else {
        labelPosition =
            _radius - (_actualAxisWidth + tickPadding + _actualLabelOffset);
      }

      _calculateLabelPosition(labelPosition, labelRadian, labelAngle,
          labelSpaceInRadian, labelSpaceInAngle);
    }
  }

  // Method to calculate label position
  void _calculateLabelPosition(double labelPosition, double labelRadian,
      double labelAngle, double labelSpaceInRadian, double labelSpaceInAngle) {
    for (num i = 0; i < _axisLabels.length; i++) {
      final CircularAxisLabel label = _axisLabels[i];
      label.angle = labelAngle;
      if (_isMaxiumValueIncluded && i == _axisLabels.length - 1) {
        labelAngle = _axis.isInversed
            ? _axis.startAngle - 90
            : _axis.startAngle + _sweepAngle - 90;
        label.value = _axis.maximum;
        label.angle = labelAngle;
        labelRadian = _getDegreeToRadian(labelAngle);
      } else {
        label.value =
            factorToValue((labelAngle + 90 - _axis.startAngle) / _sweepAngle);
      }

      if (!_axis.canScaleToFit) {
        final double x =
            ((_axisSize.width / 2) - (labelPosition * math.sin(labelRadian))) -
                _centerX;
        final double y =
            ((_axisSize.height / 2) + (labelPosition * math.cos(labelRadian))) -
                _centerY;
        label.position = Offset(x, y);
      } else {
        final double x =
            _axisCenter.dx - (labelPosition * math.sin(labelRadian));
        final double y =
            _axisCenter.dy + (labelPosition * math.cos(labelRadian));
        label.position = Offset(x, y);
      }

      if (!_axis.isInversed) {
        labelRadian += labelSpaceInRadian;
        labelAngle += labelSpaceInAngle;
      } else {
        labelRadian -= labelSpaceInRadian;
        labelAngle -= labelSpaceInAngle;
      }
    }
  }

  /// To find the maximum label size
  void _measureAxisLabels() {
    _maximumLabelSize = const Size(0, 0);
    for (num i = 0; i < _axisLabels.length; i++) {
      final CircularAxisLabel label = _axisLabels[i];
      label.labelSize = _getTextSize(label.text, label.labelStyle);
      final double maxWidth = _maximumLabelSize.width < label.labelSize.width
          ? label._needsRotateLabel
              ? label.labelSize.height
              : label.labelSize.width
          : _maximumLabelSize.width;
      final double maxHeight = _maximumLabelSize.height < label.labelSize.height
          ? label.labelSize.height
          : _maximumLabelSize.height;

      _maximumLabelSize = Size(maxWidth, maxHeight);
    }
  }

  /// Gets the start and end offset of tick
  List<Offset> _getTickPosition(
      double tickStartOffset, double tickEndOffset, double angleForTicks) {
    final Offset centerPoint = !_axis.canScaleToFit
        ? Offset(_axisSize.width / 2, _axisSize.height / 2)
        : _axisCenter;
    final double tickStartX =
        centerPoint.dx - tickStartOffset * math.sin(angleForTicks);
    final double tickStartY =
        centerPoint.dy + tickStartOffset * math.cos(angleForTicks);
    final double tickStopX =
        centerPoint.dx + (1 - tickEndOffset) * math.sin(angleForTicks);
    final double tickStopY =
        centerPoint.dy - (1 - tickEndOffset) * math.cos(angleForTicks);
    final Offset startOffset = Offset(tickStartX, tickStartY);
    final Offset endOffset = Offset(tickStopX, tickStopY);
    return <Offset>[startOffset, endOffset];
  }

  ///Method to calculate teh sweep angle of axis
  double _getSweepAngle() {
    final double actualEndAngle =
        _axis.endAngle > 360 ? _axis.endAngle % 360 : _axis.endAngle;
    double totalAngle = actualEndAngle - _axis.startAngle;
    totalAngle = totalAngle <= 0 ? (totalAngle + 360) : totalAngle;
    return totalAngle;
  }

  ///Calculates the axis width based on the coordinate unit
  double _getActualValue(double value, GaugeSizeUnit sizeUnit, bool isOffset) {
    double actualValue = 0;
    if (value != null) {
      switch (sizeUnit) {
        case GaugeSizeUnit.factor:
          {
            if (!isOffset) {
              value = value < 0 ? 0 : value;
              value = value > 1 ? 1 : value;
            }

            actualValue = value * _radius;
          }
          break;
        case GaugeSizeUnit.logicalPixel:
          {
            actualValue = value;
          }
          break;
      }
    }

    return actualValue;
  }

  ///Calculates the maximum tick length
  double _getTickLength(bool isMajorTick) {
    if (isMajorTick) {
      return _getActualValue(
          _axis.majorTickStyle.length, _axis.majorTickStyle.lengthUnit, false);
    } else {
      return _getActualValue(
          _axis.minorTickStyle.length, _axis.minorTickStyle.lengthUnit, false);
    }
  }

  /// Renders the axis pointers
  void _renderPointers() {
    final int index = _renderingDetails.axisRenderers.indexOf(this);
    for (num i = 0; i < _axis.pointers.length; i++) {
      final List<_GaugePointerRenderer> pointerRenderers =
          _renderingDetails.gaugePointerRenderers[index];
      final _GaugePointerRenderer pointerRenderer = pointerRenderers[i];
      pointerRenderer._axis = _axis;
      pointerRenderer._calculatePosition();
    }
  }

  /// Method to render the range
  void _renderRanges() {
    final int index = _renderingDetails.axisRenderers.indexOf(this);
    for (num i = 0; i < _axis.ranges.length; i++) {
      final List<_GaugeRangeRenderer> rangeRenderers =
          _renderingDetails.gaugeRangeRenderers[index];
      final _GaugeRangeRenderer rangeRenderer = rangeRenderers[i];
      rangeRenderer._axis = _axis;
      rangeRenderer._calculateRangePosition();
    }
  }

  /// Calculates the interval of axis based on its range
  num _getNiceInterval() {
    if (_axis.interval != null) {
      return _axis.interval;
    }

    return _calculateAxisInterval(_axis.maximumLabels);
  }

  /// To calculate the axis label based on the maximum axis label
  num _calculateAxisInterval(int actualMaximumValue) {
    final num delta = _getAxisRange();
    final num circumference = 2 * math.pi * _center * (_sweepAngle / 360);
    final num desiredIntervalCount =
        math.max(circumference * ((0.533 * actualMaximumValue) / 100), 1);
    num niceInterval = delta / desiredIntervalCount;
    final num minimumInterval =
        math.pow(10, (math.log(niceInterval) / math.log(10)).floor());
    final List<double> intervalDivisions = <double>[10, 5, 2, 1];
    for (int i = 0; i < intervalDivisions.length; i++) {
      final num currentInterval = minimumInterval * intervalDivisions[i];
      if (desiredIntervalCount < (delta / currentInterval)) {
        break;
      }
      niceInterval = currentInterval;
    }

    return niceInterval; // Returns the interval based on the maximum number
    // of labels for 100 labels
  }

  /// To load the image from the image provider
  void _loadBackgroundImage(BuildContext context) {
    final ImageStream newImageStream =
        _axis.backgroundImage.resolve(createLocalImageConfiguration(context));
    if (newImageStream.key != _imageStream?.key) {
      _imageStream?.removeListener(_listener);
      _imageStream = newImageStream;
      _imageStream.addListener(_listener);
    }
  }

  /// Update the background image
  void _updateBackgroundImage(ImageInfo imageInfo, bool synchronousCall) {
    if (imageInfo?.image != null) {
      _backgroundImageInfo = imageInfo;
      _renderingDetails.axisRepaintNotifier.value++;
    }
  }

  /// Gets the current axis labels
  CircularAxisLabel _getAxisLabel(num i) {
    num value = i;
    String labelText = value.toString();
    final List<String> list = labelText.split('.');
    value = double.parse(value.toStringAsFixed(3));
    if (list != null &&
        list.length > 1 &&
        (list[1] == '0' || list[1] == '00' || list[1] == '000')) {
      value = value.round();
    }

    labelText = value.toString();

    if (_axis.numberFormat != null) {
      labelText = _axis.numberFormat.format(value);
    }
    if (_axis.labelFormat != null) {
      labelText = _axis.labelFormat.replaceAll(RegExp('{value}'), labelText);
    }
    AxisLabelCreatedArgs labelCreatedArgs;
    GaugeTextStyle argsLabelStyle;
    if (_axis.onLabelCreated != null) {
      labelCreatedArgs = AxisLabelCreatedArgs();
      labelCreatedArgs.text = labelText;
      _axis.onLabelCreated(labelCreatedArgs);

      labelText = labelCreatedArgs.text;
      argsLabelStyle = labelCreatedArgs.labelStyle;
    }

    final GaugeTextStyle labelStyle = argsLabelStyle ?? _axis.axisLabelStyle;
    final CircularAxisLabel label = CircularAxisLabel(labelStyle, labelText, i,
        labelCreatedArgs != null ? labelCreatedArgs.canRotate ?? false : false);
    label.value = value;
    return label;
  }

  /// Returns the axis range
  num _getAxisRange() {
    return _axis.maximum - _axis.minimum;
  }

  /// Calculates the visible labels based on axis interval and range
  @override
  List<CircularAxisLabel> generateVisibleLabels() {
    _isMaxiumValueIncluded = false;
    final List<CircularAxisLabel> visibleLabels = <CircularAxisLabel>[];
    _actualInterval = _getNiceInterval();
    for (num i = _axis.minimum; i <= _axis.maximum; i += _actualInterval) {
      final CircularAxisLabel currentLabel = _getAxisLabel(i);
      visibleLabels.add(currentLabel);
    }

    final CircularAxisLabel label = visibleLabels[visibleLabels.length - 1];
    if (label.value != _axis.maximum && label.value < _axis.maximum) {
      _isMaxiumValueIncluded = true;
      final CircularAxisLabel currentLabel = _getAxisLabel(_axis.maximum);
      visibleLabels.add(currentLabel);
    }

    return visibleLabels;
  }

  /// Converts the axis value to factor based on angle
  @override
  double valueToFactor(double value) {
    final double angle = _valueToAngle(value);
    return angle / _sweepAngle;
  }

  /// Converts the factor value to axis value
  @override
  double factorToValue(double factor) {
    final double angle = (factor * _sweepAngle) + _axis.startAngle;
    return _angleToValue(angle);
  }
}
