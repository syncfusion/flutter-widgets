part of gauges;

/// Represents the painter to draw marker
class _MarkerPointerPainter extends CustomPainter {
  _MarkerPointerPainter(
      this._gauge,
      this._axis,
      this._markerPointer,
      this._isRepaint,
      this._pointerAnimation,
      ValueNotifier<num> notifier,
      this._gaugeThemeData,
      this._renderingDetails,
      this._axisRenderer,
      this._markerPointerRenderer)
      : super(repaint: notifier);

  /// Specifies the circular gauge
  final SfRadialGauge _gauge;

  /// Specifies whether to repaint the series
  final bool _isRepaint;

  /// Specifies the axis of the painter
  final RadialAxis _axis;

  /// Specifies the marker pointer
  final MarkerPointer _markerPointer;

  /// Specifies the pointer animation
  final Animation<double> _pointerAnimation;

  /// Specifies the gauge theme data.
  final SfGaugeThemeData _gaugeThemeData;

  /// Hold the radial gauge rendering details
  final _RenderingDetails _renderingDetails;

  /// Holds the axis renderer
  final RadialAxisRenderer _axisRenderer;

  /// Holds the marker pointer renderer
  final MarkerPointerRenderer _markerPointerRenderer;

  @override
  void paint(Canvas canvas, Size size) {
    final bool needsPointerAnimation =
        _markerPointerRenderer._getIsPointerAnimationEnabled();
    double markerAngle = 0;
    Offset offset;
    bool needsShowPointer;
    if (_pointerAnimation != null) {
      needsShowPointer = _axis.isInversed
          ? _pointerAnimation.value < 1
          : _pointerAnimation.value > 0;
    }

    if (_renderingDetails.needsToAnimatePointers || needsPointerAnimation) {
      if ((_renderingDetails.needsToAnimatePointers && needsShowPointer) ||
          !_renderingDetails.needsToAnimatePointers) {
        markerAngle = (_axisRenderer._sweepAngle * _pointerAnimation.value) +
            _axis.startAngle;
        offset = _markerPointerRenderer._getMarkerOffset(
            _getDegreeToRadian(markerAngle), _markerPointer);
      }
    } else {
      offset = _markerPointerRenderer._offset;
      markerAngle = _markerPointerRenderer._angle;
    }
    if (offset != null) {
      final PointerPaintingDetails pointerPaintingDetails =
          PointerPaintingDetails(
              startOffset: offset,
              endOffset: offset,
              pointerAngle: markerAngle,
              axisRadius: _axisRenderer._radius,
              axisCenter: _axisRenderer._axisCenter);
      _markerPointerRenderer.drawPointer(
          canvas, pointerPaintingDetails, _gaugeThemeData);
    }

    // Disables the animation once the animation reached the current
    // pointer angle
    if (needsPointerAnimation &&
        markerAngle ==
            _axisRenderer._sweepAngle *
                    _markerPointerRenderer._animationEndValue +
                _axis.startAngle) {
      _markerPointerRenderer._needsAnimate = false;
    }

    if (_renderingDetails.needsToAnimatePointers &&
        _gauge.axes[_gauge.axes.length - 1] == _axis &&
        _axis.pointers[_axis.pointers.length - 1] == _markerPointer &&
        markerAngle ==
            _axisRenderer._sweepAngle *
                    _markerPointerRenderer._animationEndValue +
                _axis.startAngle) {
      _renderingDetails.needsToAnimatePointers = false;
    }
  }

  @override
  bool shouldRepaint(_MarkerPointerPainter oldDelegate) => _isRepaint;
}
