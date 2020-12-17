part of gauges;

/// Create the pointer to indicate the value with needle or arrow shape.
///
/// [NeedlePointer] contains three parts, namely needle, knob, and tail
/// and that can be placed on a gauge to mark the values.
///
/// ```dart
///Widget build(BuildContext context) {
///    return Container(
///        child: SfRadialGauge(
///          axes:<RadialAxis>[RadialAxis
///          ( pointers: <GaugePointer>[
///             NeedlePointer( value: 30,
///           )])]
///        ));
///}
/// ```
class NeedlePointer extends GaugePointer {
  /// Create a needle pointer with the default or required properties.
  ///
  /// The arguments [value], must not be null and [animationDuration],
  /// [needleLength], [needleStartWidth], [needleEndWidth] must be non-negative.
  NeedlePointer(
      {double value = 0,
      bool enableDragging,
      ValueChanged<double> onValueChanged,
      ValueChanged<double> onValueChangeStart,
      ValueChanged<double> onValueChangeEnd,
      ValueChanged<ValueChangingArgs> onValueChanging,
      KnobStyle knobStyle,
      this.tailStyle,
      this.gradient,
      this.needleLength = 0.6,
      this.lengthUnit = GaugeSizeUnit.factor,
      this.needleStartWidth = 1,
      this.needleEndWidth = 10,
      this.onCreatePointerRenderer,
      bool enableAnimation,
      double animationDuration = 1000,
      AnimationType animationType,
      this.needleColor})
      : knobStyle = knobStyle ?? KnobStyle(knobRadius: 0.08),
        assert(animationDuration > 0,
            'Animation duration must be a non-negative value'),
        assert(value != null, 'Value should not be null.'),
        assert(needleLength >= 0, 'Needle length must be greater than zero.'),
        assert(needleStartWidth >= 0,
            'Needle start width must be greater than zero.'),
        assert(
            needleEndWidth >= 0, 'Needle end width must be greater than zero.'),
        super(
            value: value,
            enableDragging: enableDragging ?? false,
            onValueChanged: onValueChanged,
            onValueChangeStart: onValueChangeStart,
            onValueChangeEnd: onValueChangeEnd,
            onValueChanging: onValueChanging,
            animationType: animationType ?? AnimationType.ease,
            enableAnimation: enableAnimation ?? false,
            animationDuration: animationDuration);

  /// The style to use for the needle knob.
  ///
  /// A knob is a rounded ball at the end of an needle or arrow which style
  /// customized by [knobStyle].
  ///
  /// Defaults to the [knobStyle] property with knobRadius is 0.08 radius
  /// factor.
  ///
  /// Also refer [KnobStyle].
  ///
  /// ```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfRadialGauge(
  ///          axes:<RadialAxis>[RadialAxis
  ///          ( pointers: <GaugePointer>[
  ///             NeedlePointer( value: 30,
  ///              knobStyle: KnobStyle(knobRadius: 0.1),
  ///           )])]
  ///        ));
  ///}
  /// ```
  final KnobStyle knobStyle;

  /// The style to use for the needle tail.
  ///
  /// Defaults to `null`..
  ///
  /// Also refer [TailStyle].
  ///
  /// ```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfRadialGauge(
  ///          axes:<RadialAxis>[RadialAxis
  ///          ( pointers: <GaugePointer>[
  ///             NeedlePointer( value: 20, tailStyle:
  ///                 TailStyle(width: 5, lengthFactor: 0.2)
  ///           )])]
  ///        ));
  ///}
  /// ```
  final TailStyle tailStyle;

  /// Adjusts the needle pointer length from center.
  ///
  /// You can specify length value either in logical pixel or radius factor
  /// using the [lengthUnit] property. if [lengthUnit] is
  /// [GaugeSizeUnit.factor], value will be given from 0 to 1.
  /// Here pointer length is calculated by [needleLength] * axis radius value.
  ///
  /// Example: [needleLength] value is 0.5 and axis radius is 100, pointer
  /// length is 50(0.5 * 100) logical pixels from axis center.
  /// if [lengthUnit] is [GaugeSizeUnit.logicalPixel], defined value length
  /// from axis center.
  ///
  /// Defaults to 0.6 and [lengthUnit] is [GaugeSizeUnit.factor].
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfRadialGauge(
  ///          axes:<RadialAxis>[RadialAxis
  ///          ( pointers: <GaugePointer>[
  ///             NeedlePointer( needleLength: 0.8, value: 20,
  ///           )])]
  ///        ));
  ///}
  /// ```
  final double needleLength;

  /// Calculates the needle pointer length either in logical pixel
  /// or radius factor.
  ///
  /// Using [GaugeSizeUnit], needle pointer length is calculated.
  ///
  /// Defaults to [GaugeSizeUnit.factor].
  ///
  /// Also refer [GaugeSizeUnit].
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfRadialGauge(
  ///          axes:<RadialAxis>[RadialAxis
  ///          ( pointers: <GaugePointer>[
  ///             NeedlePointer( needleLength: 30,
  ///             lengthUnit: GaugeSizeUnit.logicalPixel
  ///           )])]
  ///        ));
  ///}
  /// ```
  final GaugeSizeUnit lengthUnit;

  /// Specifies the start width of the needle pointer in logical pixels.
  ///
  /// Using [needleStartWidth] and [needleEndWidth], you can customize the
  /// needle shape as rectangle or triangle.
  ///
  ///  Defaults to 1
  ///  ```dart
  /// Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfRadialGauge(
  ///          axes:<RadialAxis>[RadialAxis
  ///          ( pointers: <GaugePointer>[
  ///             NeedlePointer( needleStartWidth: 20, value: 30
  ///           )])]
  ///        ));
  ///}
  ///  ```
  final double needleStartWidth;

  /// Specifies the end width of the needle pointer in logical pixels.
  ///
  /// Using [needleStartWidth] and [needleEndWidth], you can customize
  /// the needle shape as rectangle or triangle.
  ///
  /// Defaults to 10
  /// ```dart
  /// Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfRadialGauge(
  ///          axes:<RadialAxis>[RadialAxis
  ///          ( pointers: <GaugePointer>[
  ///             NeedlePointer( needleEndWidth: 30
  ///           )])]
  ///        ));
  ///}
  /// ```
  final double needleEndWidth;

  /// Specifies the color of the needle pointer.
  ///
  /// Defaults to `null`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfRadialGauge(
  ///          axes:<RadialAxis>[RadialAxis
  ///          ( pointers: <GaugePointer>[
  ///             NeedlePointer( color: Colors.blue, value: 30
  ///           )])]
  ///        ));
  ///}
  /// ```
  final Color needleColor;

  /// A gradient to use when filling the needle pointer.
  ///
  /// [gradient] of [NeedlePointer] only support [LinearGradient]. You can use
  /// this to display the depth effect of the needle pointer.
  ///
  /// Defaults to `null`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfRadialGauge(
  ///          axes:<RadialAxis>[RadialAxis
  ///          ( pointers: <GaugePointer>[
  ///             NeedlePointer( color: Colors.blue, value: 30
  ///             gradient: LinearGradient(
  ///                colors: const <Color>[Color.fromRGBO(28, 114, 189, 1),
  ///                Color.fromRGBO(28, 114, 189, 1),
  ///                  Color.fromRGBO(23, 173, 234, 1),
  ///                  Color.fromRGBO(23, 173, 234, 1)],
  ///                stops: const <double>[0,0.5,0.5,1],
  ///            )
  ///           )])]
  ///        ));
  ///}
  /// ```
  final LinearGradient gradient;

  /// The callback that is called when the custom renderer for
  /// the needle pointer is created. and it is not applicable for
  /// built-in needle pointer
  ///
  /// The needle pointer is passed as the argument to the callback in
  /// order to access the pointer property
  ///
  ///```dart
  /// Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfRadialGauge(
  ///          axes:<RadialAxis>[RadialAxis(
  ///             pointers: <GaugePointer>[NeedlePointer(value: 50,
  ///                onCreatePointerRenderer: handleCreatePointerRenderer,
  ///             )],
  ///            )]
  ///        ));
  ///}
  ///
  /// Called before creating the renderer
  /// NeedlePointerRenderer handleCreatePointerRenderer(NeedlePointer pointer){
  /// final _CustomPointerRenderer _customPointerRenderer =
  ///                                                 _CustomPointerRenderer();
  /// return _customPointerRenderer;
  ///}
  ///
  /// class _CustomPointerRenderer extends NeedlePointerRenderer{
  /// _CustomPointerRenderer class implementation
  /// }
  ///```
  final NeedlePointerRendererFactory<NeedlePointerRenderer>
      onCreatePointerRenderer;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }
    return other is NeedlePointer &&
        other.value == value &&
        other.enableDragging == enableDragging &&
        other.onValueChanged == onValueChanged &&
        other.onValueChangeStart == onValueChangeStart &&
        other.onValueChanging == onValueChanging &&
        other.onValueChangeEnd == onValueChangeEnd &&
        other.enableAnimation == enableAnimation &&
        other.animationDuration == animationDuration &&
        other.knobStyle == knobStyle &&
        other.tailStyle == tailStyle &&
        other.gradient == gradient &&
        other.needleLength == needleLength &&
        other.lengthUnit == lengthUnit &&
        other.needleStartWidth == needleStartWidth &&
        other.needleEndWidth == needleEndWidth &&
        other.onCreatePointerRenderer == onCreatePointerRenderer &&
        other.needleColor == needleColor;
  }

  @override
  int get hashCode {
    final List<Object> values = <Object>[
      value,
      enableDragging,
      onValueChanged,
      onValueChangeStart,
      onValueChanging,
      onValueChangeEnd,
      enableAnimation,
      animationDuration,
      knobStyle,
      tailStyle,
      gradient,
      needleLength,
      lengthUnit,
      needleStartWidth,
      needleEndWidth,
      needleColor,
      onCreatePointerRenderer
    ];
    return hashList(values);
  }
}

/// The [NeedlePointerRenderer] has methods to render needle pointer
class NeedlePointerRenderer extends _GaugePointerRenderer {
  /// Creates the instance for needle pointer renderer
  NeedlePointerRenderer() : super();

  /// Represents the needle pointer which is corresponding to this renderer
  NeedlePointer pointer;

  /// Specifies the actual tail length
  double _actualTailLength;

  /// Specifies the actual length of the pointer based on the coordinate unit
  double _actualNeedleLength;

  /// Specifies the actual knob radius
  double _actualCapRadius;

  /// Specifies the angle of the needle pointer
  double _angle;

  /// Specifies the radian value of needle pointer
  double _radian;

  /// Specifies the stop x value
  double _stopX;

  /// Specifies the stop y value
  double _stopY;

  /// Specifies the start left x value
  double _startLeftX;

  /// Specifies the start left y value
  double _startLeftY;

  /// Specifies the start right x value
  double _startRightX;

  /// Specifies the start right y value
  double _startRightY;

  /// Specifies the stop left x value
  double _stopLeftX;

  /// Specifies the stop left y value
  double _stopLeftY;

  /// Specifies the stop right x value
  double _stopRightX;

  /// Specifies the stop right y value
  double _stopRightY;

  /// Specifies the start x value
  double _startX;

  /// Specifies the start y value
  double _startY;

  /// Specifies the tail left start x value
  double _tailLeftStartX;

  /// Specifies the tail left start y value
  double _tailLeftStartY;

  /// Specifies the tail left end x value
  double _tailLeftEndX;

  /// Specifies the tail left end y value
  double _tailLeftEndY;

  /// Specifies the tail right start x value
  double _tailRightStartX;

  /// Specifies the tail right start y value
  double _tailRightStartY;

  /// Specifies the tail right end x value
  double _tailRightEndX;

  /// Specifies the tail right end y value
  double _tailRightEndY;

  /// Specified the axis center point
  Offset _centerPoint;

  /// Calculates the needle position
  @override
  void _calculatePosition() {
    final NeedlePointer needlePointer = _gaugePointer;
    _calculateDefaultValue(needlePointer);
    _calculateNeedleOffset(needlePointer);
  }

  /// Calculates the sweep angle of the pointer
  double _getSweepAngle() {
    return _axisRenderer.valueToFactor(_currentValue);
  }

  /// Calculates the default value
  void _calculateDefaultValue(NeedlePointer needlePointer) {
    _actualNeedleLength = _axisRenderer._getActualValue(
        needlePointer.needleLength, needlePointer.lengthUnit, false);
    _actualCapRadius = _axisRenderer._getActualValue(
        needlePointer.knobStyle.knobRadius,
        needlePointer.knobStyle.sizeUnit,
        false);
    _currentValue = _getMinMax(_currentValue, _axis.minimum, _axis.maximum);
    _angle = (_axisRenderer.valueToFactor(_currentValue) *
            _axisRenderer._sweepAngle) +
        _axis.startAngle;
    _radian = _getDegreeToRadian(_angle);
    _centerPoint = _axisRenderer._axisCenter;
  }

  /// Calculates the needle pointer offset
  void _calculateNeedleOffset(NeedlePointer needlePointer) {
    final double needleRadian = _getDegreeToRadian(-90);
    _stopX = _actualNeedleLength * math.cos(needleRadian);
    _stopY = _actualNeedleLength * math.sin(needleRadian);
    _startX = 0;
    _startY = 0;

    if (needlePointer.needleEndWidth != null) {
      _startLeftX =
          _startX - needlePointer.needleEndWidth * math.cos(needleRadian - 90);
      _startLeftY =
          _startY - needlePointer.needleEndWidth * math.sin(needleRadian - 90);
      _startRightX =
          _startX - needlePointer.needleEndWidth * math.cos(needleRadian + 90);
      _startRightY =
          _startY - needlePointer.needleEndWidth * math.sin(needleRadian + 90);
    }

    if (needlePointer.needleStartWidth != null) {
      _stopLeftX =
          _stopX - needlePointer.needleStartWidth * math.cos(needleRadian - 90);
      _stopLeftY =
          _stopY - needlePointer.needleStartWidth * math.sin(needleRadian - 90);
      _stopRightX =
          _stopX - needlePointer.needleStartWidth * math.cos(needleRadian + 90);
      _stopRightY =
          _stopY - needlePointer.needleStartWidth * math.sin(needleRadian + 90);
    }

    _calculatePointerRect();
    if (needlePointer.tailStyle != null &&
        needlePointer.tailStyle.width != null &&
        needlePointer.tailStyle.width > 0) {
      _calculateTailPosition(needleRadian, needlePointer);
    }
  }

  /// Calculates the needle pointer rect based on
  /// its start and the stop value
  void _calculatePointerRect() {
    double x1 = _centerPoint.dx;
    double x2 = _centerPoint.dx + _actualNeedleLength * math.cos(_radian);
    double y1 = _centerPoint.dy;
    double y2 = _centerPoint.dy + _actualNeedleLength * math.sin(_radian);

    if (x1 > x2) {
      final double temp = x1;
      x1 = x2;
      x2 = temp;
    }

    if (y1 > y2) {
      final double temp = y1;
      y1 = y2;
      y2 = temp;
    }

    if (y2 - y1 < 20) {
      y1 -= 10; // Creates the pointer rect with minimum height
      y2 += 10;
    }

    if (x2 - x1 < 20) {
      x1 -= 10; // Creates the pointer rect with minimum width
      x2 += 10;
    }

    _pointerRect = Rect.fromLTRB(x1, y1, x2, y2);
  }

  /// Calculates the values to render the needle tail
  void _calculateTailPosition(
      double needleRadian, NeedlePointer needlePointer) {
    final double pointerWidth = needlePointer.tailStyle.width;
    _actualTailLength = _axisRenderer._getActualValue(
        needlePointer.tailStyle.length,
        needlePointer.tailStyle.lengthUnit,
        false);
    if (_actualTailLength > 0) {
      final double tailEndX =
          _startX - _actualTailLength * math.cos(needleRadian);
      final double tailEndY =
          _startY - _actualTailLength * math.sin(needleRadian);
      _tailLeftStartX = _startX - pointerWidth * math.cos(needleRadian - 90);
      _tailLeftStartY = _startY - pointerWidth * math.sin(needleRadian - 90);
      _tailRightStartX = _startX - pointerWidth * math.cos(needleRadian + 90);
      _tailRightStartY = _startY - pointerWidth * math.sin(needleRadian + 90);

      _tailLeftEndX = tailEndX - pointerWidth * math.cos(needleRadian - 90);
      _tailLeftEndY = tailEndY - pointerWidth * math.sin(needleRadian - 90);
      _tailRightEndX = tailEndX - pointerWidth * math.cos(needleRadian + 90);
      _tailRightEndY = tailEndY - pointerWidth * math.sin(needleRadian + 90);
    }
  }

  /// Method to draw pointer the needle pointer.
  ///
  /// By overriding this method, you can draw the customized needled pointer
  /// using required values.
  ///
  void drawPointer(Canvas canvas, PointerPaintingDetails pointerPaintingDetails,
      SfGaugeThemeData gaugeThemeData) {
    final NeedlePointer needlePointer = _gaugePointer;
    final double pointerRadian =
        _getDegreeToRadian(pointerPaintingDetails.pointerAngle);
    if (_actualNeedleLength != null && _actualNeedleLength > 0) {
      _renderNeedle(canvas, pointerRadian, gaugeThemeData, needlePointer);
    }
    if (_actualTailLength != null && _actualTailLength > 0) {
      _renderTail(canvas, pointerRadian, gaugeThemeData, needlePointer);
    }
    _renderCap(canvas, gaugeThemeData, needlePointer);
  }

  /// To render the needle of the pointer
  void _renderNeedle(Canvas canvas, double pointerRadian,
      SfGaugeThemeData gaugeThemeData, NeedlePointer needlePointer) {
    final Paint paint = Paint()
      ..color = needlePointer.needleColor ?? gaugeThemeData.needleColor
      ..style = PaintingStyle.fill;
    final Path path = Path();
    path.moveTo(_startLeftX, _startLeftY);
    path.lineTo(_stopLeftX, _stopLeftY);
    path.lineTo(_stopRightX, _stopRightY);
    path.lineTo(_startRightX, _startRightY);
    path.close();

    if (needlePointer.gradient != null) {
      paint.shader = needlePointer.gradient.createShader(path.getBounds());
    }

    canvas.save();
    canvas.translate(_centerPoint.dx, _centerPoint.dy);
    canvas.rotate(pointerRadian);
    canvas.drawPath(path, paint);
    canvas.restore();
  }

  /// To render the tail of the pointer
  void _renderTail(Canvas canvas, double pointerRadian,
      SfGaugeThemeData gaugeThemeData, NeedlePointer needlePointer) {
    final Path tailPath = Path();
    tailPath.moveTo(_tailLeftStartX, _tailLeftStartY);
    tailPath.lineTo(_tailLeftEndX, _tailLeftEndY);
    tailPath.lineTo(_tailRightEndX, _tailRightEndY);
    tailPath.lineTo(_tailRightStartX, _tailRightStartY);
    tailPath.close();

    canvas.save();
    canvas.translate(_centerPoint.dx, _centerPoint.dy);
    canvas.rotate(pointerRadian);

    final Paint tailPaint = Paint()
      ..color = needlePointer.tailStyle.color ?? gaugeThemeData.tailColor;
    if (needlePointer.tailStyle.gradient != null) {
      tailPaint.shader =
          needlePointer.tailStyle.gradient.createShader(tailPath.getBounds());
    }

    canvas.drawPath(tailPath, tailPaint);

    if (needlePointer.tailStyle.borderWidth > 0) {
      final Paint tailStrokePaint = Paint()
        ..color = needlePointer.tailStyle.borderColor ??
            gaugeThemeData.tailBorderColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = needlePointer.tailStyle.borderWidth;
      canvas.drawPath(tailPath, tailStrokePaint);
    }

    canvas.restore();
  }

  /// To render the cap of needle
  void _renderCap(Canvas canvas, SfGaugeThemeData gaugeThemeData,
      NeedlePointer needlePointer) {
    if (_actualCapRadius > 0) {
      final Paint knobPaint = Paint()
        ..color = needlePointer.knobStyle.color ?? gaugeThemeData.knobColor;
      canvas.drawCircle(_axisRenderer._axisCenter, _actualCapRadius, knobPaint);

      if (needlePointer.knobStyle.borderWidth > 0) {
        final double actualBorderWidth = _axisRenderer._getActualValue(
            needlePointer.knobStyle.borderWidth,
            needlePointer.knobStyle.sizeUnit,
            false);
        final Paint strokePaint = Paint()
          ..color = needlePointer.knobStyle.borderColor ??
              gaugeThemeData.knobBorderColor
          ..style = PaintingStyle.stroke
          ..strokeWidth = actualBorderWidth;
        canvas.drawCircle(_centerPoint, _actualCapRadius, strokePaint);
      }
    }
  }
}
