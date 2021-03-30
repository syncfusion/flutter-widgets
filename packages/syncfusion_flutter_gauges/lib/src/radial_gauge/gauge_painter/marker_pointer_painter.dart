import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:flutter/foundation.dart';
import '../axis/radial_axis.dart';
import '../common/common.dart';
import '../common/radial_gauge_renderer.dart';
import '../gauge/radial_gauge.dart';
import '../pointers/marker_pointer.dart';
import '../renderers/marker_pointer_renderer_base.dart';
import '../renderers/radial_axis_renderer_base.dart';
import '../utils/helper.dart';

/// Represents the painter to draw marker
class MarkerPointerPainter extends CustomPainter {
  /// Create the painter for marker pointer
  ///
  MarkerPointerPainter(
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
  final Animation<double>? _pointerAnimation;

  /// Specifies the gauge theme data.
  final SfGaugeThemeData _gaugeThemeData;

  /// Hold the radial gauge rendering details
  final RenderingDetails _renderingDetails;

  /// Holds the axis renderer
  final RadialAxisRendererBase _axisRenderer;

  /// Holds the marker pointer renderer
  final MarkerPointerRendererBase _markerPointerRenderer;

  @override
  void paint(Canvas canvas, Size size) {
    final bool needsPointerAnimation =
        _markerPointerRenderer.getIsPointerAnimationEnabled();
    double markerAngle = 0;
    Offset? offset;
    bool? needsShowPointer;
    if (_pointerAnimation != null) {
      needsShowPointer = _axis.isInversed
          ? _pointerAnimation!.value < 1
          : _pointerAnimation!.value > 0;
    }

    if ((_renderingDetails.needsToAnimatePointers &&
            (!_renderingDetails.isOpacityAnimation &&
                _axis.minimum != _markerPointerRenderer.currentValue)) ||
        (needsPointerAnimation &&
            (!_gauge.enableLoadingAnimation ||
                (_gauge.enableLoadingAnimation &&
                    _pointerAnimation!.value != 1 &&
                    !_renderingDetails.isOpacityAnimation &&
                    !_renderingDetails.needsToAnimatePointers)))) {
      if ((_renderingDetails.needsToAnimatePointers &&
              needsShowPointer != null &&
              needsShowPointer) ||
          !_renderingDetails.needsToAnimatePointers) {
        markerAngle = (_axisRenderer.sweepAngle * _pointerAnimation!.value) +
            _axis.startAngle;
        offset = _markerPointerRenderer.getMarkerOffset(
            getDegreeToRadian(markerAngle), _markerPointer);
      }
    } else {
      offset = _markerPointerRenderer.offset;
      markerAngle = _markerPointerRenderer.angle;
    }
    if (offset != null) {
      final PointerPaintingDetails pointerPaintingDetails =
          PointerPaintingDetails(
              startOffset: offset,
              endOffset: offset,
              pointerAngle: markerAngle,
              axisRadius: _axisRenderer.radius,
              axisCenter: _axisRenderer.axisCenter);
      _markerPointerRenderer.renderingDetails = _renderingDetails;
      _markerPointerRenderer.pointerAnimation =
          _pointerAnimation != null ? _pointerAnimation! : null;

      if (_markerPointerRenderer.renderer != null) {
        _markerPointerRenderer.renderer!
            .drawPointer(canvas, pointerPaintingDetails, _gaugeThemeData);
      } else {
        _markerPointerRenderer.drawPointer(
            canvas, pointerPaintingDetails, _gaugeThemeData);
      }
    }

    // Disables the animation once the animation reached the current
    // pointer angle
    if (needsPointerAnimation &&
        markerAngle ==
            _axisRenderer.sweepAngle *
                    _markerPointerRenderer.animationEndValue! +
                _axis.startAngle) {
      _markerPointerRenderer.needsAnimate = false;
    }

    if (_renderingDetails.needsToAnimatePointers &&
        _gauge.axes[_gauge.axes.length - 1] == _axis &&
        _axis.pointers![_axis.pointers!.length - 1] == _markerPointer &&
        ((!_renderingDetails.isOpacityAnimation &&
                markerAngle ==
                    _axisRenderer.sweepAngle *
                            _markerPointerRenderer.animationEndValue! +
                        _axis.startAngle) ||
            (_renderingDetails.isOpacityAnimation &&
                _pointerAnimation!.value == 1))) {
      _renderingDetails.needsToAnimatePointers = false;
    }
  }

  @override
  bool shouldRepaint(MarkerPointerPainter oldDelegate) => _isRepaint;
}
