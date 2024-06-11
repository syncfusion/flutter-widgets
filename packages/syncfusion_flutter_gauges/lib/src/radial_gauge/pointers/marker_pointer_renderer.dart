import 'dart:math' as math;
import 'dart:ui' as dart_ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:syncfusion_flutter_core/core.dart' as core;
import 'package:syncfusion_flutter_core/theme.dart';

import '../../radial_gauge/axis/radial_axis_widget.dart';
import '../../radial_gauge/pointers/pointer_painting_details.dart';
import '../../radial_gauge/renderers/marker_pointer_renderer.dart';
import '../../radial_gauge/styles/radial_text_style.dart';
import '../../radial_gauge/utils/enum.dart';
import '../../radial_gauge/utils/helper.dart';
import '../../radial_gauge/utils/radial_callback_args.dart';

/// Represents the renderer of radial gauge marker pointer.
class RenderMarkerPointer extends RenderBox {
  /// Creates a object for [RenderMarkerPointer].
  RenderMarkerPointer({
    required double value,
    required this.enableDragging,
    this.onValueChanged,
    this.onValueChangeStart,
    this.onValueChangeEnd,
    this.onValueChanging,
    required MarkerType markerType,
    Color? color,
    required double markerWidth,
    required double markerHeight,
    required double borderWidth,
    required double markerOffset,
    String? text,
    Color? borderColor,
    required GaugeSizeUnit offsetUnit,
    String? imageUrl,
    MarkerPointerRenderer? markerPointerRenderer,
    required GaugeTextStyle textStyle,
    Color? overlayColor,
    double? overlayRadius,
    double elevation = 0,
    AnimationController? pointerAnimationController,
    this.pointerInterval,
    required this.animationType,
    required this.enableAnimation,
    required this.isRadialGaugeAnimationEnabled,
    required ValueNotifier<int> repaintNotifier,
    required SfGaugeThemeData gaugeThemeData,
    required ThemeData themeData,
    required SfColorScheme colorScheme,
  })  : _value = value,
        _markerType = markerType,
        _color = color,
        _markerWidth = markerWidth,
        _markerHeight = markerHeight,
        _borderWidth = borderWidth,
        _markerOffset = markerOffset,
        _text = text,
        _borderColor = borderColor,
        _offsetUnit = offsetUnit,
        _imageUrl = imageUrl,
        _textStyle = textStyle,
        _overlayColor = overlayColor,
        _overlayRadius = overlayRadius,
        _elevation = elevation,
        _markerPointerRenderer = markerPointerRenderer,
        _pointerAnimationController = pointerAnimationController,
        _repaintNotifier = repaintNotifier,
        _gaugeThemeData = gaugeThemeData,
        _themeData = themeData,
        _colorScheme = colorScheme;

  final double _margin = 15;
  dart_ui.Image? _image;
  late double _radian;
  Size? _textSize;
  late double _totalOffset;
  late double _actualMarkerOffset;
  late double _angle;
  late Offset _offset;
  late Rect _markerRect;
  late core.ShapeMarkerType _shapeMarkerType;
  bool _isAnimating = false;
  bool _isInitialLoading = true;
  late double _radius;
  late double _actualAxisWidth;
  late double _sweepAngle;
  late double _centerXPoint;
  late double _centerYPoint;
  late Offset _axisCenter;

  /// Marker pointer old value.
  double? oldValue;

  /// Pointer rect.
  Rect? pointerRect;

  /// Specifies the value whether the pointer is dragged
  bool? isDragStarted;

  /// Gets or Sets the enableDragging value.
  bool enableDragging;

  /// Gets or Sets the onValueChanged value.
  ValueChanged<double>? onValueChanged;

  /// Gets or Sets the onValueChangeStart value.
  ValueChanged<double>? onValueChangeStart;

  /// Gets or Sets the onValueChangeEnd value.
  ValueChanged<double>? onValueChangeEnd;

  /// Gets or Sets the onValueChanging value.
  ValueChanged<ValueChangingArgs>? onValueChanging;

  /// AnimationType.
  AnimationType animationType;

  /// Gets or Sets the enableAnimation.
  bool enableAnimation;

  /// Gets or sets the pointer interval.
  List<double?>? pointerInterval;

  /// Whether the gauge animation enabled or not.
  bool isRadialGaugeAnimationEnabled;

  /// Gets the animation controller assigned to [RenderMarkerPointer].
  AnimationController? get pointerAnimationController =>
      _pointerAnimationController;
  AnimationController? _pointerAnimationController;

  /// Gets the animation controller for [RenderMarkerPointer].
  set pointerAnimationController(AnimationController? value) {
    if (value == _pointerAnimationController) {
      return;
    }

    _pointerAnimationController = value;

    if (_axisRenderer != null && _pointerAnimationController != null) {
      _updateAnimation();
    }
  }

  /// Gets the axisRenderer assigned to [RenderMarkerPointer].
  RenderRadialAxisWidget? get axisRenderer => _axisRenderer;
  RenderRadialAxisWidget? _axisRenderer;

  /// Gets the axisRenderer assigned to [RenderMarkerPointer].
  set axisRenderer(RenderRadialAxisWidget? value) {
    if (value == _axisRenderer) {
      return;
    }

    _axisRenderer = value;

    if (_axisRenderer != null) {
      _updateAxisValues();
    }

    if (_axisRenderer != null && pointerAnimationController != null) {
      _isAnimating = true;
      pointerAnimation = _axisRenderer!.createPointerAnimation(this);
    }
  }

  /// Gets the animation assigned to [RenderMarkerPointer].
  Animation<double>? get pointerAnimation => _pointerAnimation;
  Animation<double>? _pointerAnimation;

  /// Sets the animation for [RenderMarkerPointer].
  set pointerAnimation(Animation<double>? value) {
    if (value == _pointerAnimation) {
      return;
    }

    _removeListeners();
    _pointerAnimation = value;
    _addListeners();
  }

  /// Gets the isHovered assigned to [RenderMarkerPointer].
  bool? get isHovered => _isHovered;
  bool? _isHovered;

  /// Sets the isHovered for [RenderMarkerPointer].
  set isHovered(bool? value) {
    if (value == _isHovered) {
      return;
    }

    _isHovered = value;
    markNeedsPaint();
  }

  /// Gets the gaugeThemeData assigned to [RenderMarkerPointer].
  SfGaugeThemeData get gaugeThemeData => _gaugeThemeData;
  SfGaugeThemeData _gaugeThemeData;

  /// Sets the gaugeThemeData for [RenderMarkerPointer].
  set gaugeThemeData(SfGaugeThemeData value) {
    if (value == _gaugeThemeData) {
      return;
    }
    _gaugeThemeData = value;
    markNeedsPaint();
  }

  /// Gets the themeData assigned to [RenderRadialAxisWidget].
  ThemeData get themeData => _themeData;
  ThemeData _themeData;

  /// Sets the themeData for [RenderRadialAxisWidget].
  set themeData(ThemeData value) {
    if (value == _themeData) {
      return;
    }
    _themeData = value;
    markNeedsPaint();
  }

  /// Gets the colors of SfColorScheme
  SfColorScheme get colorScheme => _colorScheme;
  SfColorScheme _colorScheme;
  set colorScheme(SfColorScheme value) {
    if (value == _colorScheme) {
      return;
    }
    _colorScheme = value;
    markNeedsPaint();
  }

  /// Gets the value assigned to [RenderMarkerPointer].
  double get value => _value;
  double _value;

  /// Sets the value for [RenderMarkerPointer].
  set value(double value) {
    if (value == _value) {
      return;
    }

    if (pointerAnimationController != null &&
        pointerAnimationController!.isAnimating &&
        enableAnimation) {
      oldValue = _value;
      pointerAnimationController!.stop();
      _isAnimating = false;
    }

    _value = value;

    if (pointerAnimationController != null &&
        oldValue != value &&
        enableAnimation) {
      pointerAnimation = _axisRenderer!.createPointerAnimation(this);
      _isAnimating = true;
      pointerAnimationController!.forward(from: 0.0);
    }

    if (!enableAnimation) {
      oldValue = value;
      markNeedsPaint();
    }
  }

  /// Gets the markerType assigned to [RenderMarkerPointer].
  MarkerType get markerType => _markerType;
  MarkerType _markerType;

  /// Sets the markerType for [RenderMarkerPointer].
  set markerType(MarkerType value) {
    if (value == _markerType) {
      return;
    }

    _markerType = value;
    markNeedsPaint();
  }

  /// Gets the color assigned to [RenderMarkerPointer].
  Color? get color => _color;
  Color? _color;

  /// Sets the color for [RenderMarkerPointer].
  set color(Color? value) {
    if (value == _color) {
      return;
    }

    _color = value;
    markNeedsPaint();
  }

  /// Gets the markerWidth assigned to [RenderMarkerPointer].
  double get markerWidth => _markerWidth;
  double _markerWidth;

  /// Sets the markerWidth for [RenderMarkerPointer].
  set markerWidth(double value) {
    if (value == _markerWidth) {
      return;
    }

    _markerWidth = value;
    markNeedsPaint();
  }

  /// Gets the markerHeight assigned to [RenderMarkerPointer].
  double get markerHeight => _markerHeight;
  double _markerHeight;

  /// Sets the markerHeight for [RenderMarkerPointer].
  set markerHeight(double value) {
    if (value == _markerHeight) {
      return;
    }

    _markerHeight = value;
    markNeedsPaint();
  }

  /// Gets the borderWidth assigned to [RenderMarkerPointer].
  double get borderWidth => _borderWidth;
  double _borderWidth;

  /// Sets the borderWidth for [RenderMarkerPointer].
  set borderWidth(double value) {
    if (value == _borderWidth) {
      return;
    }

    _borderWidth = value;
    markNeedsPaint();
  }

  /// Gets the markerOffset assigned to [RenderMarkerPointer].
  double get markerOffset => _markerOffset;
  double _markerOffset;

  /// Sets the markerOffset for [RenderMarkerPointer].
  set markerOffset(double value) {
    if (value == _markerOffset) {
      return;
    }

    _markerOffset = value;
    markNeedsPaint();
  }

  /// Gets the text assigned to [RenderMarkerPointer].
  String? get text => _text;
  String? _text;

  /// Sets the text for [RenderMarkerPointer].
  set text(String? value) {
    if (value == _text) {
      return;
    }

    _text = value;
    markNeedsPaint();
  }

  /// Gets the borderColor assigned to [RenderMarkerPointer].
  Color? get borderColor => _borderColor;
  Color? _borderColor;

  /// Sets the borderColor for [RenderMarkerPointer].
  set borderColor(Color? value) {
    if (value == _borderColor) {
      return;
    }

    _borderColor = value;
    markNeedsPaint();
  }

  /// Gets the offsetUnit assigned to [RenderMarkerPointer].
  GaugeSizeUnit get offsetUnit => _offsetUnit;
  GaugeSizeUnit _offsetUnit;

  /// Sets the offsetUnit for [RenderMarkerPointer].
  set offsetUnit(GaugeSizeUnit value) {
    if (value == _offsetUnit) {
      return;
    }

    _offsetUnit = value;
    markNeedsPaint();
  }

  /// Gets the imageUrl assigned to [RenderMarkerPointer].
  String? get imageUrl => _imageUrl;
  String? _imageUrl;

  /// Sets the imageUrl for [RenderMarkerPointer].
  set imageUrl(String? value) {
    if (value == _imageUrl) {
      return;
    }

    _imageUrl = value;
    _loadImage();
  }

  /// Gets the textStyle assigned to [RenderMarkerPointer].
  GaugeTextStyle get textStyle => _textStyle;
  GaugeTextStyle _textStyle;

  /// Sets the textStyle for [RenderMarkerPointer].
  set textStyle(GaugeTextStyle value) {
    if (value == _textStyle) {
      return;
    }

    _textStyle = value;
    markNeedsPaint();
  }

  /// Gets the overlayColor assigned to [RenderMarkerPointer].
  Color? get overlayColor => _overlayColor;
  Color? _overlayColor;

  /// Sets the overlayColor for [RenderMarkerPointer].
  set overlayColor(Color? value) {
    if (value == _overlayColor) {
      return;
    }

    _overlayColor = value;
    markNeedsPaint();
  }

  /// Gets the overlayRadius assigned to [RenderMarkerPointer].
  double? get overlayRadius => _overlayRadius;
  double? _overlayRadius;

  /// Sets the overlayRadius for [RenderMarkerPointer].
  set overlayRadius(double? value) {
    if (value == _overlayRadius) {
      return;
    }

    _overlayRadius = value;
    markNeedsPaint();
  }

  /// Gets the elevation assigned to [RenderMarkerPointer].
  double get elevation => _elevation;
  double _elevation;

  /// Sets the elevation for [RenderMarkerPointer].
  set elevation(double value) {
    if (value == _elevation) {
      return;
    }

    _elevation = value;
    markNeedsPaint();
  }

  /// Gets the text markerPointerRenderer to [RenderMarkerPointer].
  MarkerPointerRenderer? get markerPointerRenderer => _markerPointerRenderer;
  MarkerPointerRenderer? _markerPointerRenderer;

  /// Sets the markerPointerRenderer for [RenderMarkerPointer].
  set markerPointerRenderer(MarkerPointerRenderer? value) {
    if (value == _markerPointerRenderer) {
      return;
    }

    _markerPointerRenderer = value;
    markNeedsPaint();
  }

  /// Gets the repaintNotifier assigned to [RenderMarkerPointer].
  ValueNotifier<int> get repaintNotifier => _repaintNotifier;
  ValueNotifier<int> _repaintNotifier;

  /// Sets the repaintNotifier for [RenderMarkerPointer].
  set repaintNotifier(ValueNotifier<int> value) {
    if (value == _repaintNotifier) {
      return;
    }

    _removeListeners();
    _repaintNotifier = value;
    _addListeners();
  }

  void _updateAnimation() {
    _isAnimating = true;
    _isInitialLoading = true;
    oldValue = axisRenderer!.minimum;
    pointerAnimation = _axisRenderer!.createPointerAnimation(this);
  }

  void _updateAxisValues() {
    _sweepAngle = axisRenderer!.getAxisSweepAngle();
    _centerXPoint = axisRenderer!.getCenterX();
    _centerYPoint = axisRenderer!.getCenterY();
    _axisCenter = axisRenderer!.getAxisCenter();
    _radius = _axisRenderer!.getRadius();
    _actualAxisWidth = _axisRenderer!.getActualValue(
        _axisRenderer!.thickness, _axisRenderer!.thicknessUnit, false);
  }

  void _animationStatusListener(AnimationStatus status) {
    if (status == AnimationStatus.completed) {
      _isAnimating = false;
      if (oldValue != value) {
        oldValue = value;
      }
    }

    _isInitialLoading = false;
  }

  void _addListeners() {
    if (_pointerAnimation != null) {
      _pointerAnimation!.addListener(markNeedsPaint);
      _pointerAnimation!.addStatusListener(_animationStatusListener);
    }

    repaintNotifier.addListener(markNeedsPaint);
  }

  void _removeListeners() {
    if (_pointerAnimation != null) {
      _pointerAnimation!.removeListener(markNeedsPaint);
      _pointerAnimation!.removeStatusListener(_animationStatusListener);
    }

    repaintNotifier.removeListener(markNeedsPaint);
  }

  @override
  void attach(PipelineOwner owner) {
    super.attach(owner);
    _addListeners();
  }

  @override
  void detach() {
    _removeListeners();
    super.detach();
  }

  /// Method to calculate the marker position.
  void _calculatePosition() {
    _updateAxisValues();
    _angle = _getPointerAngle();
    _radian = getDegreeToRadian(_angle);
    final Offset offset = _getMarkerOffset(_radian);
    if (markerType == MarkerType.text && text != null) {
      _textSize = getTextSize(text!, textStyle);
    }

    pointerRect = Rect.fromLTRB(
        offset.dx - markerWidth / 2 - _margin,
        offset.dy - markerHeight / 2 - _margin,
        offset.dx + markerWidth / 2 + _margin,
        offset.dy + markerHeight / 2 + _margin);
  }

  @override
  void performLayout() {
    size = Size(constraints.maxWidth, constraints.maxHeight);
    if (markerType == MarkerType.image && imageUrl != null) {
      _loadImage();
    }
  }

  @override
  bool hitTestSelf(Offset position) {
    if (enableDragging && pointerRect != null) {
      return pointerRect!.contains(position);
    } else {
      return false;
    }
  }

  /// Method returns the angle of  current pointer value
  double _getPointerAngle() {
    final double currentFactor = (axisRenderer!.renderer != null &&
            axisRenderer!.renderer?.valueToFactor(value) != null)
        ? axisRenderer!.renderer?.valueToFactor(value) ??
            axisRenderer!.valueToFactor(value)
        : axisRenderer!.valueToFactor(value);
    return (currentFactor * _sweepAngle) + axisRenderer!.startAngle;
  }

  /// Calculates the marker offset position
  Offset _getMarkerOffset(double markerRadian) {
    _actualMarkerOffset =
        axisRenderer!.getActualValue(markerOffset, offsetUnit, true);
    _totalOffset = _actualMarkerOffset < 0
        ? axisRenderer!.getAxisOffset() + _actualMarkerOffset
        : (_actualMarkerOffset + axisRenderer!.getAxisOffset());
    if (!axisRenderer!.canScaleToFit) {
      final double x = (size.width / 2) +
          (_radius - _totalOffset - (_actualAxisWidth / 2)) *
              math.cos(markerRadian) -
          _centerXPoint;
      final double y = (size.height / 2) +
          (_radius - _totalOffset - (_actualAxisWidth / 2)) *
              math.sin(markerRadian) -
          _centerYPoint;
      _offset = Offset(x, y);
    } else {
      final double x = _axisCenter.dx +
          (_radius - _totalOffset - (_actualAxisWidth / 2)) *
              math.cos(markerRadian);
      final double y = _axisCenter.dy +
          (_radius - _totalOffset - (_actualAxisWidth / 2)) *
              math.sin(markerRadian);
      _offset = Offset(x, y);
    }

    return _offset;
  }

  /// To load the image from the image url
  // ignore: avoid_void_async
  void _loadImage() async {
    await _renderImage().then((void value) {
      WidgetsBinding.instance
          .addPostFrameCallback((Duration duration) => markNeedsPaint());
    });
  }

  /// Renders the image from the image url
  Future<void> _renderImage() async {
    final ByteData imageData = await rootBundle.load(imageUrl!);
    final dart_ui.Codec imageCodec =
        await dart_ui.instantiateImageCodec(imageData.buffer.asUint8List());
    final dart_ui.FrameInfo frameInfo = await imageCodec.getNextFrame();
    _image = frameInfo.image;
  }

  /// Method to draw pointer the marker pointer.
  ///
  /// By overriding this method, you can draw the customized marker
  /// pointer using required values.
  ///
  void drawPointer(Canvas canvas, PointerPaintingDetails pointerPaintingDetails,
      SfGaugeThemeData gaugeThemeData) {
    final Paint paint = Paint()
      ..color = color ??
          gaugeThemeData.markerColor ??
          colorScheme.secondaryContainer[205]!
      ..style = PaintingStyle.fill;
    const Color shadowColor = Colors.black;

    Paint? overlayPaint;
    if ((isHovered != null && isHovered!) &&
        overlayColor != colorScheme.transparent) {
      overlayPaint = Paint()
        ..color = overlayColor ??
            color?.withOpacity(0.12) ??
            gaugeThemeData.markerColor?.withOpacity(0.12) ??
            _themeData.colorScheme.secondaryContainer.withOpacity(0.12)
        ..style = PaintingStyle.fill;
    }

    Paint? borderPaint;
    if (borderWidth > 0) {
      borderPaint = Paint()
        ..color = borderColor ?? gaugeThemeData.markerBorderColor
        ..strokeWidth = borderWidth
        ..style = PaintingStyle.stroke;
    }

    canvas.save();
    switch (markerType) {
      case MarkerType.circle:
        _drawCircle(canvas, paint, pointerPaintingDetails.startOffset,
            borderPaint, overlayPaint, shadowColor);
        break;
      case MarkerType.rectangle:
        _drawRectangle(
            canvas,
            paint,
            pointerPaintingDetails.startOffset,
            pointerPaintingDetails.pointerAngle,
            borderPaint,
            overlayPaint,
            shadowColor);
        break;
      case MarkerType.image:
        _drawMarkerImage(canvas, paint, pointerPaintingDetails.startOffset,
            pointerPaintingDetails.pointerAngle);
        canvas.restore();
        break;
      case MarkerType.triangle:
      case MarkerType.invertedTriangle:
        _drawTriangle(
            canvas,
            paint,
            pointerPaintingDetails.startOffset,
            pointerPaintingDetails.pointerAngle,
            borderPaint,
            overlayPaint,
            shadowColor);
        break;
      case MarkerType.diamond:
        _drawDiamond(
            canvas,
            paint,
            pointerPaintingDetails.startOffset,
            pointerPaintingDetails.pointerAngle,
            borderPaint,
            overlayPaint,
            shadowColor);
        break;
      case MarkerType.text:
        if (text != null) {
          _drawText(canvas, paint, pointerPaintingDetails.startOffset,
              pointerPaintingDetails.pointerAngle, gaugeThemeData);
          canvas.restore();
        }
        break;
    }

    if (markerType != MarkerType.text && markerType != MarkerType.image) {
      core.paint(
          canvas: canvas,
          rect: _markerRect,
          paint: paint,
          elevation: elevation,
          elevationColor: shadowColor,
          shapeType: _shapeMarkerType,
          borderPaint: borderPaint);
      canvas.restore();
    }
  }

  /// To render the MarkerShape.Text
  void _drawText(Canvas canvas, Paint paint, Offset startPosition,
      double pointerAngle, SfGaugeThemeData gaugeThemeData) {
    final TextStyle markerTextStyle = _themeData.textTheme.bodySmall!.copyWith(
      color: textStyle.color ??
          _gaugeThemeData.markerTextStyle?.color ??
          _gaugeThemeData.axisLabelColor ??
          colorScheme.onSurface[184],
      fontSize: textStyle.fontSize ?? _gaugeThemeData.markerTextStyle?.fontSize,
      fontFamily:
          textStyle.fontFamily ?? _gaugeThemeData.markerTextStyle?.fontFamily,
      fontStyle:
          textStyle.fontStyle ?? _gaugeThemeData.markerTextStyle?.fontStyle,
      fontWeight:
          textStyle.fontWeight ?? _gaugeThemeData.markerTextStyle?.fontWeight,
    );
    final TextSpan span = TextSpan(text: text, style: markerTextStyle);
    final TextPainter textPainter = TextPainter(
        text: span,
        textDirection: TextDirection.ltr,
        textAlign: TextAlign.center);
    textPainter.layout();
    canvas.save();
    canvas.translate(startPosition.dx, startPosition.dy);
    canvas.rotate(getDegreeToRadian(pointerAngle - 90));
    canvas.scale(-1);
    textPainter.paint(
        canvas, Offset(-_textSize!.width / 2, -_textSize!.height / 2));
    canvas.restore();
  }

  /// Renders the MarkerShape.circle
  void _drawCircle(Canvas canvas, Paint paint, Offset startPosition,
      Paint? borderPaint, Paint? overlayPaint, Color shadowColor) {
    final double pointerOverlayRadius = overlayRadius ?? 15;
    _markerRect = Rect.fromLTRB(
        startPosition.dx - markerWidth / 2,
        startPosition.dy - markerHeight / 2,
        startPosition.dx + markerWidth / 2,
        startPosition.dy + markerHeight / 2);

    Rect overlayRect;
    if (overlayRadius != null) {
      overlayRect = Rect.fromLTRB(
          startPosition.dx - pointerOverlayRadius,
          startPosition.dy - pointerOverlayRadius,
          startPosition.dx + pointerOverlayRadius,
          startPosition.dy + pointerOverlayRadius);
    } else {
      overlayRect = Rect.fromLTRB(
          _markerRect.left - pointerOverlayRadius,
          _markerRect.top - pointerOverlayRadius,
          _markerRect.right + pointerOverlayRadius,
          _markerRect.bottom + pointerOverlayRadius);
    }

    if (overlayPaint != null) {
      canvas.drawOval(overlayRect, overlayPaint);
    }

    _shapeMarkerType = core.ShapeMarkerType.circle;
  }

  /// Renders the MarkerShape.rectangle
  void _drawRectangle(
      Canvas canvas,
      Paint paint,
      Offset startPosition,
      double pointerAngle,
      Paint? borderPaint,
      Paint? overlayPaint,
      Color shadowColor) {
    final double pointerOverlayRadius = overlayRadius ?? 15;
    Rect overlayRect;
    if (overlayRadius != null) {
      overlayRect = Rect.fromLTRB(-pointerOverlayRadius, -pointerOverlayRadius,
          pointerOverlayRadius, pointerOverlayRadius);
    } else {
      overlayRect = Rect.fromLTRB(
          _markerRect.left - pointerOverlayRadius,
          _markerRect.top - pointerOverlayRadius,
          _markerRect.right + pointerOverlayRadius,
          _markerRect.bottom + pointerOverlayRadius);
    }

    canvas.translate(startPosition.dx, startPosition.dy);
    canvas.rotate(getDegreeToRadian(pointerAngle));
    if (overlayPaint != null) {
      canvas.drawRect(overlayRect, overlayPaint);
    }

    _shapeMarkerType = core.ShapeMarkerType.rectangle;
  }

  /// Renders the MarkerShape.image
  void _drawMarkerImage(
      Canvas canvas, Paint paint, Offset startPosition, double pointerAngle) {
    canvas.translate(startPosition.dx, startPosition.dy);
    canvas.rotate(getDegreeToRadian(pointerAngle + 90));
    final Rect rect = Rect.fromLTRB(
        -markerWidth / 2, -markerHeight / 2, markerWidth / 2, markerHeight / 2);
    if (_image != null) {
      canvas.drawImageNine(_image!, rect, rect, paint);
    }
  }

  /// Renders the MarkerShape.diamond
  void _drawDiamond(
      Canvas canvas,
      Paint paint,
      Offset startPosition,
      double pointerAngle,
      Paint? borderPaint,
      Paint? overlayPaint,
      Color shadowColor) {
    canvas.translate(startPosition.dx, startPosition.dy);
    canvas.rotate(getDegreeToRadian(pointerAngle - 90));

    if (overlayPaint != null) {
      final double pointerOverlayRadius = overlayRadius ?? 30;
      final Path overlayPath = Path();
      if (overlayRadius != null) {
        overlayPath.moveTo(-pointerOverlayRadius, 0);
        overlayPath.lineTo(0, pointerOverlayRadius);
        overlayPath.lineTo(pointerOverlayRadius, 0);
        overlayPath.lineTo(0, -pointerOverlayRadius);
        overlayPath.lineTo(-pointerOverlayRadius, 0);
      } else {
        overlayPath.moveTo(-((markerWidth + pointerOverlayRadius) / 2), 0);
        overlayPath.lineTo(0, (markerHeight + pointerOverlayRadius) / 2);
        overlayPath.lineTo((markerWidth + pointerOverlayRadius) / 2, 0);
        overlayPath.lineTo(0, -((markerHeight + pointerOverlayRadius) / 2));
        overlayPath.lineTo(-((markerWidth + pointerOverlayRadius) / 2), 0);
      }

      overlayPath.close();
      canvas.drawPath(overlayPath, overlayPaint);
    }

    _shapeMarkerType = core.ShapeMarkerType.diamond;
  }

  /// Renders the triangle and the inverted triangle
  void _drawTriangle(
      Canvas canvas,
      Paint paint,
      Offset startPosition,
      double pointerAngle,
      Paint? borderPaint,
      Paint? overlayPaint,
      Color shadowColor) {
    canvas.translate(startPosition.dx, startPosition.dy);
    final double triangleAngle = markerType == MarkerType.triangle
        ? pointerAngle + 90
        : pointerAngle - 90;
    canvas.rotate(getDegreeToRadian(triangleAngle));

    if (overlayPaint != null) {
      final double pointerOverlayRadius = overlayRadius ?? 30;
      final Path overlayPath = Path();
      if (overlayRadius != null) {
        overlayPath.moveTo(-pointerOverlayRadius, pointerOverlayRadius);
        overlayPath.lineTo(pointerOverlayRadius, pointerOverlayRadius);
        overlayPath.lineTo(0, -pointerOverlayRadius);
        overlayPath.lineTo(-pointerOverlayRadius, pointerOverlayRadius);
      } else {
        overlayPath.moveTo(-((markerWidth + pointerOverlayRadius) / 2),
            (markerHeight + pointerOverlayRadius) / 2);
        overlayPath.lineTo((markerWidth + pointerOverlayRadius) / 2,
            (markerHeight + pointerOverlayRadius) / 2);
        overlayPath.lineTo(0, -((markerHeight + pointerOverlayRadius) / 2));
        overlayPath.lineTo(-((markerWidth + pointerOverlayRadius) / 2),
            (markerHeight + pointerOverlayRadius) / 2);
      }

      overlayPath.close();
      canvas.drawPath(overlayPath, overlayPaint);
    }

    _shapeMarkerType = core.ShapeMarkerType.triangle;
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    final Canvas canvas = context.canvas;
    _calculatePosition();
    double? markerAngle;
    Offset? markerOffset;
    bool needsShowPointer = false;

    if (_pointerAnimation != null && _isAnimating) {
      markerAngle =
          (_sweepAngle * _pointerAnimation!.value) + axisRenderer!.startAngle;
      markerOffset = _getMarkerOffset(getDegreeToRadian(markerAngle));
    } else {
      markerAngle = _angle;
      markerOffset = _offset;
    }

    if (isRadialGaugeAnimationEnabled) {
      if (_pointerAnimation != null && _isInitialLoading) {
        needsShowPointer = axisRenderer!.isInversed
            ? _pointerAnimation!.value < 1
            : _pointerAnimation!.value > 0;
      } else {
        needsShowPointer = true;
      }
    } else {
      needsShowPointer = true;
    }

    if (needsShowPointer) {
      final PointerPaintingDetails pointerPaintingDetails =
          PointerPaintingDetails(
              startOffset: markerOffset,
              endOffset: markerOffset,
              pointerAngle: markerAngle,
              axisRadius: _radius,
              axisCenter: _axisCenter);

      _markerRect = Rect.fromLTRB(-markerWidth / 2, -markerHeight / 2,
          markerWidth / 2, markerHeight / 2);
      if (markerPointerRenderer != null) {
        markerPointerRenderer!
            .drawPointer(canvas, pointerPaintingDetails, _gaugeThemeData);
      } else {
        drawPointer(canvas, pointerPaintingDetails, _gaugeThemeData);
      }
    }
  }
}
