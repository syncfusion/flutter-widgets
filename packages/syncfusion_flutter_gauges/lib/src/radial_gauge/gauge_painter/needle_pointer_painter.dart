part of gauges;

/// Represents the painter to render the needle pointer
class _NeedlePointerPainter extends CustomPainter {
  /// Creates the needle pointer painter
  _NeedlePointerPainter(
      this._gauge,
      this._axis,
      this._needlePointer,
      this._isRepaint,
      this._pointerAnimation,
      ValueNotifier<num> notifier,
      this._gaugeThemeData,
      this._renderingDetails,
      this._axisRenderer,
      this._needlePointerRenderer)
      : super(repaint: notifier);

  /// Specifies the circular gauge
  final SfRadialGauge _gauge;

  /// Specifies the gauge axis
  final RadialAxis _axis;

  /// Specifies the needle pointer
  final NeedlePointer _needlePointer;

  /// Specifies whether to redraw the pointer
  final bool _isRepaint;

  /// Specifies the animation value of needle pointer
  final Animation<double> _pointerAnimation;

  /// Specifies the gauge theme data.
  final SfGaugeThemeData _gaugeThemeData;

  /// Hold the radial gauge animation details
  final _RenderingDetails _renderingDetails;

  /// holds the axis renderer
  final RadialAxisRenderer _axisRenderer;

  /// Holds the needle pointer renderer
  final NeedlePointerRenderer _needlePointerRenderer;

  @override
  void paint(Canvas canvas, Size size) {
    double angle;
    bool needsShowPointer;
    final bool needsPointerAnimation =
        _needlePointerRenderer._getIsPointerAnimationEnabled();
    if (_pointerAnimation != null) {
      needsShowPointer = _axis.isInversed
          ? _pointerAnimation.value < 1
          : _pointerAnimation.value > 0;
    }

    if (_renderingDetails.needsToAnimatePointers || needsPointerAnimation) {
      if ((_renderingDetails.needsToAnimatePointers && needsShowPointer) ||
          !_renderingDetails.needsToAnimatePointers) {
        angle = (_axisRenderer._sweepAngle * _pointerAnimation.value) +
            _axis.startAngle +
            90; //Since the needle rect has been
        // calculated with -90 degree, additional 90 degree is added
      }
    } else {
      angle = _needlePointerRenderer._angle + 90; //Since the needle rect has
      //been calculated with -90 degree, additional 90 degree is added
    }
    final Offset startPosition =
        Offset(_needlePointerRenderer._startX, _needlePointerRenderer._startY);
    final Offset endPosition =
        Offset(_needlePointerRenderer._stopX, _needlePointerRenderer._stopY);
    if (angle != null) {
      final PointerPaintingDetails pointerPaintingDetails =
          PointerPaintingDetails(
              startOffset: startPosition,
              endOffset: endPosition,
              pointerAngle: angle,
              axisRadius: _axisRenderer._radius,
              axisCenter: _axisRenderer._axisCenter);
      _needlePointerRenderer.drawPointer(
          canvas, pointerPaintingDetails, _gaugeThemeData);
    }

    _setPointerAnimation(needsPointerAnimation, angle);
  }

  /// Method to set the pointer animation
  void _setPointerAnimation(bool needsPointerAnimation, double angle) {
    final bool isPointerEndAngle = _getIsEndAngle(angle);

    // Disables the animation once the animation reached the current
    // pointer angle
    if (needsPointerAnimation && isPointerEndAngle) {
      _needlePointerRenderer._needsAnimate = false;
    }

    // Disables the load time pointer animation
    if (_renderingDetails.needsToAnimatePointers &&
        _gauge.axes[_gauge.axes.length - 1] == _axis &&
        _axis.pointers[_axis.pointers.length - 1] == _needlePointer &&
        isPointerEndAngle) {
      _renderingDetails.needsToAnimatePointers = false;
    }
  }

  /// Checks whether the current angle is pointer end angle
  bool _getIsEndAngle(double angle) {
    return angle ==
        _axisRenderer._sweepAngle * _needlePointerRenderer._animationEndValue +
            _axis.startAngle +
            90;
  }

  @override
  bool shouldRepaint(_NeedlePointerPainter oldDelegate) => _isRepaint;
}
