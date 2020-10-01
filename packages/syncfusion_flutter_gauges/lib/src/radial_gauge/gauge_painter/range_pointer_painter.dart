part of gauges;

/// Represents the painter to render the range pointer
class _RangePointerPainter extends CustomPainter {
  /// Creates the range pointer
  _RangePointerPainter(
      this._gauge,
      this._axis,
      this._rangePointer,
      this._isRepaint,
      this._pointerAnimation,
      ValueNotifier<num> notifier,
      this._gaugeThemeData,
      this._renderingDetails,
      this._axisRenderer,
      this._rangePointerRenderer)
      : super(repaint: notifier);

  /// Specifies the circular gauge
  final SfRadialGauge _gauge;

  /// Specifies the gauge axis
  final RadialAxis _axis;

  /// Specifies the needle pointer
  final RangePointer _rangePointer;

  /// Specifies whether to redraw the pointer
  final bool _isRepaint;

  /// Specifies the pointer animation
  final Animation<double> _pointerAnimation;

  /// Specifies the gauge theme data.
  final SfGaugeThemeData _gaugeThemeData;

  /// Hold the radial gauge rendering details
  final _RenderingDetails _renderingDetails;

  /// Holds the radial axis renderer
  final RadialAxisRenderer _axisRenderer;

  /// Holds the gauge range renderer
  final _RangePointerRenderer _rangePointerRenderer;

  @override
  void paint(Canvas canvas, Size size) {
    final bool needsToAnimatePointer = _getNeedsPointerAnimation();
    double sweepRadian =
        _getPointerSweepRadian(_rangePointerRenderer._sweepCornerRadian);
    final double outerRadius =
        _axisRenderer._radius - _rangePointerRenderer._totalOffset;
    final double innerRadius =
        outerRadius - _rangePointerRenderer._actualRangeThickness;
    final double cornerRadius = (innerRadius - outerRadius).abs() / 2;
    final double value = (2 *
            math.pi *
            (innerRadius + outerRadius) /
            2 *
            _getRadianToDegree(_rangePointerRenderer._sweepCornerRadian) /
            360)
        .abs();
    final Path path = Path();
    final bool isDashedPointerLine = _getIsDashedLine();
    // Specifies whether the painting style is fill
    bool isFill;
    if (_rangePointerRenderer._currentValue > _axis.minimum) {
      canvas.save();
      canvas.translate(
          _axisRenderer._axisCenter.dx, _axisRenderer._axisCenter.dy);
      canvas.rotate(_getDegreeToRadian(_rangePointerRenderer._startArc));
      final double curveRadius =
          _rangePointer.cornerStyle != CornerStyle.bothFlat
              ? _rangePointer.cornerStyle == CornerStyle.startCurve
                  ? cornerRadius
                  : cornerRadius * 2
              : 0;
      if (_rangePointer.cornerStyle != CornerStyle.bothFlat &&
          !isDashedPointerLine &&
          (value.floorToDouble() > curveRadius)) {
        isFill = true;
        if (_rangePointer.cornerStyle == CornerStyle.startCurve ||
            _rangePointer.cornerStyle == CornerStyle.bothCurve) {
          if (needsToAnimatePointer) {
            _drawStartCurve(path, innerRadius, outerRadius);
          }
        }

        if (needsToAnimatePointer) {
          path.addArc(
              Rect.fromCircle(center: const Offset(0, 0), radius: outerRadius),
              _rangePointerRenderer._startCornerRadian,
              sweepRadian);
        }

        if (_rangePointer.cornerStyle == CornerStyle.endCurve ||
            _rangePointer.cornerStyle == CornerStyle.bothCurve) {
          if (needsToAnimatePointer) {
            _drawEndCurve(path, sweepRadian, innerRadius, outerRadius);
          }
        }

        if (needsToAnimatePointer) {
          path.arcTo(
              Rect.fromCircle(center: const Offset(0, 0), radius: innerRadius),
              sweepRadian + _rangePointerRenderer._startCornerRadian,
              -sweepRadian,
              false);
        }
      } else {
        isFill = false;
        sweepRadian = _rangePointer.cornerStyle == CornerStyle.bothFlat
            ? sweepRadian
            : _getDegreeToRadian(_rangePointerRenderer._endArc);

        path.addArc(_rangePointerRenderer._arcRect, 0, sweepRadian);
      }

      final Paint paint =
          _getPointerPaint(_rangePointerRenderer._arcRect, isFill);
      if (!isDashedPointerLine) {
        canvas.drawPath(path, paint);
      } else {
        canvas.drawPath(
            _dashPath(path,
                dashArray:
                    _CircularIntervalList<double>(_rangePointer.dashArray)),
            paint);
      }

      canvas.restore();
      _updateAnimation(sweepRadian, isFill);
    }
  }

  /// Draws the start corner style
  void _drawStartCurve(Path path, double innerRadius, double outerRadius) {
    final Offset midPoint = _getDegreeToPoint(
        _axis.isInversed
            ? -_rangePointerRenderer._cornerAngle
            : _rangePointerRenderer._cornerAngle,
        (innerRadius + outerRadius) / 2,
        const Offset(0, 0));
    final double midStartAngle = _getDegreeToRadian(180);

    double midEndAngle = midStartAngle + _getDegreeToRadian(180);
    midEndAngle = _axis.isInversed ? -midEndAngle : midEndAngle;
    path.addArc(
        Rect.fromCircle(
            center: midPoint, radius: (innerRadius - outerRadius).abs() / 2),
        midStartAngle,
        midEndAngle);
  }

  ///Draws the end corner curve
  void _drawEndCurve(
      Path path, double sweepRadian, double innerRadius, double outerRadius) {
    final double cornerAngle =
        _rangePointer.cornerStyle == CornerStyle.bothCurve
            ? _rangePointerRenderer._cornerAngle
            : 0;
    final double angle = _axis.isInversed
        ? _getRadianToDegree(sweepRadian) - cornerAngle
        : _getRadianToDegree(sweepRadian) + cornerAngle;
    final Offset midPoint = _getDegreeToPoint(
        angle, (innerRadius + outerRadius) / 2, const Offset(0, 0));

    final double midStartAngle = sweepRadian / 2;

    final double midEndAngle = _axis.isInversed
        ? midStartAngle - _getDegreeToRadian(180)
        : midStartAngle + _getDegreeToRadian(180);

    path.arcTo(
        Rect.fromCircle(
            center: midPoint, radius: (innerRadius - outerRadius).abs() / 2),
        midStartAngle,
        midEndAngle,
        false);
  }

  /// Updates the range pointer animation based on the sweep angle
  void _updateAnimation(double sweepRadian, bool isFill) {
    final bool isPointerEndAngle = _getIsEndAngle(sweepRadian, isFill);

    // Disables the pointer animation once its reached the end value
    if (_rangePointerRenderer._getIsPointerAnimationEnabled() &&
        isPointerEndAngle) {
      _rangePointerRenderer._needsAnimate = false;
    }

    // Disables the load time animation of pointers once
    // its reached the end value
    if (_renderingDetails.needsToAnimatePointers &&
        _gauge.axes[_gauge.axes.length - 1] == _axis &&
        _axis.pointers[_axis.pointers.length - 1] == _rangePointer &&
        (isPointerEndAngle || _pointerAnimation.isCompleted)) {
      _renderingDetails.needsToAnimatePointers = false;
    }
  }

  /// Checks whether the current angle is end angle
  bool _getIsEndAngle(double sweepRadian, bool isFill) {
    return sweepRadian == _rangePointerRenderer._sweepCornerRadian ||
        (_rangePointer.cornerStyle != CornerStyle.bothFlat &&
            isFill &&
            sweepRadian == _getDegreeToRadian(_rangePointerRenderer._endArc));
  }

  /// Checks whether the axis line is dashed line
  bool _getIsDashedLine() {
    return _rangePointer.dashArray != null &&
        _rangePointer.dashArray.isNotEmpty &&
        _rangePointer.dashArray.length > 1 &&
        _rangePointer.dashArray[0] > 0 &&
        _rangePointer.dashArray[1] > 0;
  }

  /// Returns the sweep radian for pointer
  double _getPointerSweepRadian(double sweepRadian) {
    if (_renderingDetails.needsToAnimatePointers ||
        _rangePointerRenderer._getIsPointerAnimationEnabled()) {
      return _getDegreeToRadian(
          _axisRenderer._sweepAngle * _pointerAnimation.value);
    } else {
      return sweepRadian;
    }
  }

  /// Returns whether to animate the pointers
  bool _getNeedsPointerAnimation() {
    return _pointerAnimation == null ||
        !_rangePointerRenderer._needsAnimate ||
        (_pointerAnimation.value.abs() > 0 &&
            (_renderingDetails.needsToAnimatePointers ||
                _rangePointerRenderer._needsAnimate));
  }

  /// Returns the paint for the pointer
  Paint _getPointerPaint(Rect rect, bool isFill) {
    final Paint paint = Paint()
      ..color = _rangePointer.color ?? _gaugeThemeData.rangePointerColor
      ..strokeWidth = _rangePointerRenderer._actualRangeThickness
      ..style = isFill ? PaintingStyle.fill : PaintingStyle.stroke;
    if (_rangePointer.gradient != null &&
        _rangePointer.gradient.colors != null &&
        _rangePointer.gradient.colors.isNotEmpty) {
      // Holds the color for gradient
      List<Color> gradientColors;
      final double sweepAngle =
          _getRadianToDegree(_rangePointerRenderer._sweepCornerRadian).abs();
      final List<double> offsets = _getGradientOffsets();
      gradientColors = _rangePointer.gradient.colors;
      if (_axis.isInversed) {
        gradientColors = _rangePointer.gradient.colors.reversed.toList();
      }
      // gradient for the range pointer
      final SweepGradient gradient = SweepGradient(
          colors: gradientColors,
          stops:
              _calculateGradientStops(offsets, _axis.isInversed, sweepAngle));
      paint.shader = gradient.createShader(rect);
    }

    return paint;
  }

  /// Returns the gradient offset
  List<double> _getGradientOffsets() {
    if (_rangePointer.gradient.stops != null &&
        _rangePointer.gradient.stops.isNotEmpty) {
      return _rangePointer.gradient.stops;
    } else {
      // Calculates the gradient stop values based on the number of
      // provided color
      final double difference = 1 / _rangePointer.gradient.colors.length;
      final List<double> offsets =
          List<double>(_rangePointer.gradient.colors.length);
      for (int i = 0; i < _rangePointer.gradient.colors.length; i++) {
        offsets[i] = i * difference;
      }

      return offsets;
    }
  }

  @override
  bool shouldRepaint(_RangePointerPainter oldDelegate) => _isRepaint;
}
