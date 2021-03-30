import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:flutter/foundation.dart';
import '../axis/radial_axis.dart';
import '../common/common.dart';
import '../common/radial_gauge_renderer.dart';
import '../gauge/radial_gauge.dart';
import '../pointers/needle_pointer.dart';
import '../renderers/needle_pointer_renderer_base.dart';
import '../renderers/radial_axis_renderer_base.dart';

/// Represents the painter to render the needle pointer
class NeedlePointerPainter extends CustomPainter {
  /// Creates the needle pointer painter
  NeedlePointerPainter(
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
  final Animation<double>? _pointerAnimation;

  /// Specifies the gauge theme data.
  final SfGaugeThemeData _gaugeThemeData;

  /// Hold the radial gauge animation details
  final RenderingDetails _renderingDetails;

  /// holds the axis renderer
  final RadialAxisRendererBase _axisRenderer;

  /// Holds the needle pointer renderer
  final NeedlePointerRendererBase _needlePointerRenderer;

  @override
  void paint(Canvas canvas, Size size) {
    double? angle;
    bool? needsShowPointer;
    final bool needsPointerAnimation =
        _needlePointerRenderer.getIsPointerAnimationEnabled();
    if (_pointerAnimation != null) {
      needsShowPointer = _axis.isInversed
          ? _pointerAnimation!.value < 1
          : _pointerAnimation!.value > 0;
    }

    if ((_renderingDetails.needsToAnimatePointers &&
            (!_renderingDetails.isOpacityAnimation &&
                _axis.minimum != _needlePointerRenderer.currentValue)) ||
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
        angle = (_axisRenderer.sweepAngle * _pointerAnimation!.value) +
            _axis.startAngle +
            90; //Since the needle rect has been
        // calculated with -90 degree, additional 90 degree is added
      }
    } else {
      angle = _needlePointerRenderer.angle + 90; //Since the needle rect has
      //been calculated with -90 degree, additional 90 degree is added
    }
    final Offset startPosition =
        Offset(_needlePointerRenderer.startX, _needlePointerRenderer.startY);
    final Offset endPosition =
        Offset(_needlePointerRenderer.stopX, _needlePointerRenderer.stopY);
    if (angle != null) {
      final PointerPaintingDetails pointerPaintingDetails =
          PointerPaintingDetails(
              startOffset: startPosition,
              endOffset: endPosition,
              pointerAngle: angle,
              axisRadius: _axisRenderer.radius,
              axisCenter: _axisRenderer.axisCenter);
      _needlePointerRenderer.renderingDetails = _renderingDetails;
      _needlePointerRenderer.pointerAnimation =
          _pointerAnimation != null ? _pointerAnimation! : null;

      if (_needlePointerRenderer.renderer != null) {
        _needlePointerRenderer.renderer!
            .drawPointer(canvas, pointerPaintingDetails, _gaugeThemeData);
      } else {
        _needlePointerRenderer.drawPointer(
            canvas, pointerPaintingDetails, _gaugeThemeData);
      }
    }

    _setPointerAnimation(needsPointerAnimation, angle);
  }

  /// Method to set the pointer animation
  void _setPointerAnimation(bool needsPointerAnimation, double? angle) {
    final bool isPointerEndAngle = _getIsEndAngle(angle);

    // Disables the animation once the animation reached the current
    // pointer angle
    if (needsPointerAnimation && isPointerEndAngle) {
      _needlePointerRenderer.needsAnimate = false;
    }

    // Disables the load time pointer animation
    if (_renderingDetails.needsToAnimatePointers &&
        _gauge.axes[_gauge.axes.length - 1] == _axis &&
        _axis.pointers![_axis.pointers!.length - 1] == _needlePointer &&
        ((!_renderingDetails.isOpacityAnimation && isPointerEndAngle) ||
            (_renderingDetails.isOpacityAnimation &&
                _pointerAnimation!.value == 1))) {
      _renderingDetails.needsToAnimatePointers = false;
    }
  }

  /// Checks whether the current angle is pointer end angle
  bool _getIsEndAngle(double? angle) {
    return angle ==
        _axisRenderer.sweepAngle * _needlePointerRenderer.animationEndValue! +
            _axis.startAngle +
            90;
  }

  @override
  bool shouldRepaint(NeedlePointerPainter oldDelegate) => _isRepaint;
}
