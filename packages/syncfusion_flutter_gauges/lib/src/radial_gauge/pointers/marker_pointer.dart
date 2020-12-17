part of gauges;

/// Create the pointer to indicate the value with built-in shape.
///
/// To highlight values, set the marker pointer type to a built-in shape,
/// such as a circle, text, image, triangle, inverted triangle, square,
/// or diamond.
///
/// ```dart
/// Widget build(BuildContext context) {
///    return Container(
///        child: SfRadialGauge(
///          axes:<RadialAxis>[RadialAxis(
///             pointers: <GaugePointer>[MarkerPointer(value: 50,
///             )],
///            )]
///        ));
///}
/// ```
class MarkerPointer extends GaugePointer {
  /// Create a marker pointer with the default or required properties.
  ///
  /// The arguments [value], [markerOffset], must not be null and
  /// [animationDuration], [markerWidth], [markerHeight], [borderWidth]
  /// must be non-negative.
  ///
  MarkerPointer(
      {double value = 0,
      bool enableDragging,
      ValueChanged<double> onValueChanged,
      ValueChanged<double> onValueChangeStart,
      ValueChanged<double> onValueChangeEnd,
      ValueChanged<ValueChangingArgs> onValueChanging,
      this.markerType = MarkerType.invertedTriangle,
      this.color,
      this.markerWidth = 10,
      this.markerHeight = 10,
      this.borderWidth = 0,
      this.markerOffset = 0,
      this.text,
      this.borderColor,
      this.offsetUnit = GaugeSizeUnit.logicalPixel,
      this.imageUrl,
      this.onCreatePointerRenderer,
      AnimationType animationType,
      GaugeTextStyle textStyle,
      bool enableAnimation,
      double animationDuration = 1000})
      : textStyle = textStyle ??
            GaugeTextStyle(
                fontSize: 12.0,
                fontFamily: 'Segoe UI',
                fontStyle: FontStyle.normal,
                fontWeight: FontWeight.normal),
        assert(animationDuration > 0,
            'Animation duration must be a non-negative value.'),
        assert(value != null, 'Pointer value should not be null.'),
        assert(markerWidth >= 0, 'Marker width must be a non-negative value.'),
        assert(markerHeight >= 0, 'Marker height must be non-negative value.'),
        assert(borderWidth >= 0, 'Border width must be non-negative value.'),
        assert(markerOffset != null, 'Marker offset should not be null.'),
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

  /// Specifies the built-in shape type for  pointer.
  ///
  /// When use [MarkerType.text], [text] value must be set along with
  /// [textStyle] to apply style for text.
  ///
  /// When use [MarkerType.image], [imageUrl] must be set.
  ///
  /// To customize the marker size use [markerHeight] and
  /// [markerWidth] properties.
  ///
  /// Defaults to [MarkerType.invertedTriangle].
  ///
  /// Also refer [MarkerType.invertedTriangle].
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfRadialGauge(
  ///          axes:<RadialAxis>[RadialAxis(
  ///             pointers: <GaugePointer>[MarkerPointer(value: 50,
  ///             markerType: MarkerType.circle)],
  ///            )]
  ///        ));
  ///}
  /// ```
  final MarkerType markerType;

  /// Specifies the color for marker pointer.
  ///
  /// Defaults to `null`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfRadialGauge(
  ///          axes:<RadialAxis>[RadialAxis(
  ///             pointers: <GaugePointer>[MarkerPointer(value: 50,
  ///             color: Colors.red)],
  ///            )]
  ///        ));
  ///}
  /// ```
  final Color color;

  /// Specifies the marker height in logical pixels.
  ///
  /// Defaults to 10
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfRadialGauge(
  ///          axes:<RadialAxis>[RadialAxis(
  ///             pointers: <GaugePointer>[MarkerPointer(value: 50,
  ///             markerHeight: 20
  ///             )],
  ///            )]
  ///        ));
  ///}
  /// ```
  final double markerHeight;

  /// Specifies the marker width in logical pixels.
  ///
  /// Defaults to 10
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfRadialGauge(
  ///          axes:<RadialAxis>[RadialAxis(
  ///             pointers: <GaugePointer>[MarkerPointer(value: 50,
  ///             markerWidth: 20
  ///             )],
  ///            )]
  ///        ));
  ///}
  /// ```
  final double markerWidth;

  /// Specifies the image Url path for marker pointer.
  ///
  /// [imageUrl] is required when setting [MarkerType.image].
  ///
  /// Defaults to `null`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfRadialGauge(
  ///          axes:<RadialAxis>[RadialAxis(
  ///             pointers: <GaugePointer>[MarkerPointer(value: 50,
  ///             imageUrl:'images/pin.png',
  ///             markerType: MarkerShape.image
  ///             )],
  ///            )]
  ///        ));
  ///}
  /// ```
  final String imageUrl;

  /// Specifies the text for marker pointer.
  ///
  /// [text] is required when setting [MarkerType.text].
  ///
  /// Defaults to `null`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfRadialGauge(
  ///          axes:<RadialAxis>[RadialAxis(
  ///             pointers: <GaugePointer>[MarkerPointer(value: 50,
  ///             text: 'marker',
  ///             markerType: MarkerShape.text
  ///             )],
  ///            )]
  ///        ));
  ///}
  /// ```
  final String text;

  /// The style to use for the marker pointer text.
  ///
  /// Using [GaugeTextStyle] to add the style to the pointer text.
  ///
  /// Defaults to the [GaugeTextStyle] property with font size is 12.0 and
  /// font family is Segoe UI.
  ///
  /// Defaults to `null`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfRadialGauge(
  ///          axes:<RadialAxis>[RadialAxis(
  ///             pointers: <GaugePointer>[MarkerPointer(value: 50,
  ///             text: 'marker', textStyle:
  ///             GaugeTextStyle(fontSize: 20, fontStyle: FontStyle.italic),
  ///             markerType: MarkerType.text
  ///             )],
  ///            )]
  ///        ));
  ///}
  /// ```
  final GaugeTextStyle textStyle;

  /// Adjusts the marker pointer position.
  ///
  /// You can specify position value either in logical pixel or radius factor
  /// using the [offsetUnit] property.
  /// if [offsetUnit] is [GaugeSizeUnit.factor], value will be given from 0 to
  /// 1. Here pointer placing position is calculated by
  /// [markerOffset] * axis radius value.
  ///
  /// Example: [markerOffset] value is 0.2 and axis radius is 100, pointer
  /// is moving 20(0.2 * 100) logical pixels from axis outer radius.
  /// if [offsetUnit] is [GaugeSizeUnit.logicalPixel], defined value distance
  /// pointer will move from the outer radius axis.
  ///
  /// When you specify [markerOffset] is negative, the pointer will be
  /// positioned outside the axis.
  ///
  /// Defaults to 0 and [offsetUnit] is [GaugeSizeUnit.logicalPixel]
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfRadialGauge(
  ///          axes:<RadialAxis>[RadialAxis(
  ///             pointers: <GaugePointer>[MarkerPointer(value: 50,
  ///             markerOffset: 10
  ///             )],
  ///            )]
  ///        ));
  ///}
  /// ```
  final double markerOffset;

  /// Calculates the marker position either in logical pixel or radius factor.
  ///
  /// Using [GaugeSizeUnit], marker pointer position is calculated.
  ///
  /// Defaults to [GaugeSizeUnit.logicalPixel].
  ///
  /// Also refer [GaugeSizeUnit].
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfRadialGauge(
  ///          axes:<RadialAxis>[RadialAxis(
  ///             pointers: <GaugePointer>[MarkerPointer(value: 50,
  ///             markerUnit: GaugeSizeUnit.factor, markerOffset = 0.2
  ///             )],
  ///            )]
  ///        ));
  ///}
  /// ```
  final GaugeSizeUnit offsetUnit;

  /// Specifies the border color for marker.
  ///
  /// [borderColor] is applicable for [MarkerType.circle],
  /// [MarkerType.diamond], [MarkerType.invertedTriangle],
  /// [MarkerType.triangle] and [MarkerType.rectangle].
  ///
  /// Defaults to `null`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfRadialGauge(
  ///          axes:<RadialAxis>[RadialAxis(
  ///             pointers: <GaugePointer>[MarkerPointer(value: 50,
  ///             borderColor: Colors.red, borderWidth : 2)],
  ///            )]
  ///        ));
  ///}
  /// ```
  final Color borderColor;

  /// Specifies the border width for marker.
  ///
  /// [borderWidth] is applicable for [MarkerType.circle],
  /// [MarkerType.diamond], [MarkerType.invertedTriangle],
  /// [MarkerType.triangle] and [MarkerType.rectangle].
  ///
  /// Defaults to 0
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfRadialGauge(
  ///          axes:<RadialAxis>[RadialAxis(
  ///             pointers: <GaugePointer>[MarkerPointer(value: 50,
  ///             borderColor: Colors.red, borderWidth : 2)],
  ///            )]
  ///        ));
  ///}
  /// ```
  final double borderWidth;

  /// The callback that is called when the custom renderer for
  /// the marker pointer is created. and it is not applicable for
  /// built-in marker pointer
  ///
  /// The marker pointer is passed as the argument to the callback in
  /// order to access the pointer property
  ///
  ///```dart
  /// Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfRadialGauge(
  ///          axes:<RadialAxis>[RadialAxis(
  ///             pointers: <GaugePointer>[MarkerPointer(value: 50,
  ///                onCreatePointerRenderer: handleCreatePointerRenderer,
  ///             )],
  ///            )]
  ///        ));
  ///}
  ///
  /// Called before creating the renderer
  /// MarkerPointerRenderer handleCreatePointerRenderer(MarkerPointer pointer){
  /// final _CustomPointerRenderer _customPointerRenderer =
  ///                                                 _CustomPointerRenderer();
  /// return _customPointerRenderer;
  ///}
  ///
  /// class _CustomPointerRenderer extends MarkerPointerRenderer{
  /// _CustomPointerRenderer class implementation
  /// }
  ///```
  final MarkerPointerRendererFactory<MarkerPointerRenderer>
      onCreatePointerRenderer;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }
    return other is MarkerPointer &&
        other.value == value &&
        other.enableDragging == enableDragging &&
        other.onValueChanged == onValueChanged &&
        other.onValueChangeStart == onValueChangeStart &&
        other.onValueChanging == onValueChanging &&
        other.onValueChangeEnd == onValueChangeEnd &&
        other.enableAnimation == enableAnimation &&
        other.animationDuration == animationDuration &&
        other.markerType == markerType &&
        other.color == color &&
        other.markerWidth == markerWidth &&
        other.markerHeight == markerHeight &&
        other.borderWidth == borderWidth &&
        other.markerOffset == markerOffset &&
        other.text == text &&
        other.borderColor == borderColor &&
        other.imageUrl == imageUrl &&
        other.offsetUnit == offsetUnit &&
        other.onCreatePointerRenderer == onCreatePointerRenderer &&
        other.textStyle == textStyle;
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
      markerType,
      color,
      markerWidth,
      markerHeight,
      borderWidth,
      markerOffset,
      text,
      borderColor,
      imageUrl,
      offsetUnit,
      textStyle,
      onCreatePointerRenderer
    ];
    return hashList(values);
  }
}

///  The [MarkerPointerRenderer] has methods to render marker pointer
///
class MarkerPointerRenderer extends _GaugePointerRenderer {
  /// Creates the instance for marker pointer renderer
  MarkerPointerRenderer() : super();

  /// Represents the marker pointer which is corresponding to this renderer
  MarkerPointer pointer;

  /// Specifies the margin for calculating
  /// marker pointer rect
  final double _margin = 15;

  /// Specifies the marker image
  dart_ui.Image _image;

  /// Specifies the marker offset
  Offset _offset;

  /// Specifies the radian value of the marker
  double _radian;

  /// Specifies the angle value
  double _angle;

  /// Specifies the marker text size
  Size _textSize;

  /// Specifies the total offset considering axis element
  double _totalOffset;

  /// Specifies actual marker offset value
  double _actualMarkerOffset;

  /// method to calculate the marker position
  @override
  void _calculatePosition() {
    final MarkerPointer markerPointer = _gaugePointer;
    _angle = _getPointerAngle();
    _radian = _getDegreeToRadian(_angle);
    final Offset offset = _getMarkerOffset(_radian, markerPointer);
    if (markerPointer.markerType == MarkerType.image &&
        markerPointer.imageUrl != null) {
      _loadImage(markerPointer);
    } else if (markerPointer.markerType == MarkerType.text &&
        markerPointer.text != null) {
      _textSize = _getTextSize(markerPointer.text, markerPointer.textStyle);
    }

    _pointerRect = Rect.fromLTRB(
        offset.dx - markerPointer.markerWidth / 2 - _margin,
        offset.dy - markerPointer.markerHeight / 2 - _margin,
        offset.dx + markerPointer.markerWidth / 2 + _margin,
        offset.dy + markerPointer.markerHeight / 2 + _margin);
  }

  /// Method returns the angle of  current pointer value
  double _getPointerAngle() {
    _currentValue = _getMinMax(_currentValue, _axis.minimum, _axis.maximum);
    return (_axisRenderer.valueToFactor(_currentValue) *
            _axisRenderer._sweepAngle) +
        _axis.startAngle;
  }

  /// Method returns the sweep angle of pointer
  double _getSweepAngle() {
    return _axisRenderer.valueToFactor(_currentValue);
  }

  /// Calculates the marker offset position
  Offset _getMarkerOffset(double markerRadian, MarkerPointer markerPointer) {
    _actualMarkerOffset = _axisRenderer._getActualValue(
        markerPointer.markerOffset, markerPointer.offsetUnit, true);
    _totalOffset = _actualMarkerOffset < 0
        ? _axisRenderer._getAxisOffset() + _actualMarkerOffset
        : (_actualMarkerOffset + _axisRenderer._axisOffset);
    if (!_axis.canScaleToFit) {
      final double x = (_axisRenderer._axisSize.width / 2) +
          (_axisRenderer._radius -
                  _totalOffset -
                  (_axisRenderer._actualAxisWidth / 2)) *
              math.cos(markerRadian) -
          _axisRenderer._centerX;
      final double y = (_axisRenderer._axisSize.height / 2) +
          (_axisRenderer._radius -
                  _totalOffset -
                  (_axisRenderer._actualAxisWidth / 2)) *
              math.sin(markerRadian) -
          _axisRenderer._centerY;
      _offset = Offset(x, y);
    } else {
      final double x = _axisRenderer._axisCenter.dx +
          (_axisRenderer._radius -
                  _totalOffset -
                  (_axisRenderer._actualAxisWidth / 2)) *
              math.cos(markerRadian);
      final double y = _axisRenderer._axisCenter.dy +
          (_axisRenderer._radius -
                  _totalOffset -
                  (_axisRenderer._actualAxisWidth / 2)) *
              math.sin(markerRadian);
      _offset = Offset(x, y);
    }
    return _offset;
  }

  /// To load the image from the image url
// ignore: avoid_void_async
  void _loadImage(MarkerPointer markerPointer) async {
    await _renderImage(markerPointer);
    _axisRenderer._renderingDetails.pointerRepaintNotifier.value++;
  }

  /// Renders the image from the image url
// ignore: prefer_void_to_null
  Future<Null> _renderImage(MarkerPointer markerPointer) async {
    final ByteData imageData = await rootBundle.load(markerPointer.imageUrl);
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
    final MarkerPointer markerPointer = _gaugePointer;
    final Paint paint = Paint()
      ..color = markerPointer.color ?? gaugeThemeData.markerColor
      ..style = PaintingStyle.fill;

    Paint borderPaint;
    if (markerPointer.borderWidth != null && markerPointer.borderWidth > 0) {
      borderPaint = Paint()
        ..color = markerPointer.borderColor ?? gaugeThemeData.markerBorderColor
        ..strokeWidth = markerPointer.borderWidth
        ..style = PaintingStyle.stroke;
    }
    canvas.save();
    switch (markerPointer.markerType) {
      case MarkerType.circle:
        _drawCircle(canvas, paint, pointerPaintingDetails.startOffset,
            borderPaint, markerPointer);
        break;
      case MarkerType.rectangle:
        _drawRectangle(canvas, paint, pointerPaintingDetails.startOffset,
            pointerPaintingDetails.pointerAngle, borderPaint, markerPointer);
        break;
      case MarkerType.image:
        _drawMarkerImage(canvas, paint, pointerPaintingDetails.startOffset,
            pointerPaintingDetails.pointerAngle, markerPointer);
        break;
      case MarkerType.triangle:
      case MarkerType.invertedTriangle:
        _drawTriangle(canvas, paint, pointerPaintingDetails.startOffset,
            pointerPaintingDetails.pointerAngle, borderPaint, markerPointer);
        break;
      case MarkerType.diamond:
        _drawDiamond(canvas, paint, pointerPaintingDetails.startOffset,
            pointerPaintingDetails.pointerAngle, borderPaint, markerPointer);
        break;
      case MarkerType.text:
        if (markerPointer.text != null) {
          _drawText(
              canvas,
              paint,
              pointerPaintingDetails.startOffset,
              pointerPaintingDetails.pointerAngle,
              gaugeThemeData,
              markerPointer);
        }

        break;
    }

    canvas.restore();
  }

  /// To render the MarkerShape.Text
  void _drawText(
      Canvas canvas,
      Paint paint,
      Offset startPosition,
      double pointerAngle,
      SfGaugeThemeData gaugeThemeData,
      MarkerPointer markerPointer) {
    final TextSpan span = TextSpan(
        text: markerPointer.text,
        style: TextStyle(
            color:
                markerPointer.textStyle.color ?? gaugeThemeData.axisLabelColor,
            fontSize: markerPointer.textStyle.fontSize,
            fontFamily: markerPointer.textStyle.fontFamily,
            fontStyle: markerPointer.textStyle.fontStyle,
            fontWeight: markerPointer.textStyle.fontWeight));
    final TextPainter textPainter = TextPainter(
        text: span,
        textDirection: TextDirection.ltr,
        textAlign: TextAlign.center);
    textPainter.layout();
    canvas.save();
    canvas.translate(startPosition.dx, startPosition.dy);
    canvas.rotate(_getDegreeToRadian(pointerAngle - 90));
    canvas.scale(-1);
    textPainter.paint(
        canvas, Offset(-_textSize.width / 2, -_textSize.height / 2));
    canvas.restore();
  }

  /// Renders the MarkerShape.circle
  void _drawCircle(Canvas canvas, Paint paint, Offset startPosition,
      Paint borderPaint, MarkerPointer markerPointer) {
    final Rect rect = Rect.fromLTRB(
        startPosition.dx - markerPointer.markerWidth / 2,
        startPosition.dy - markerPointer.markerHeight / 2,
        startPosition.dx + markerPointer.markerWidth / 2,
        startPosition.dy + markerPointer.markerHeight / 2);
    canvas.drawOval(rect, paint);
    if (borderPaint != null) {
      canvas.drawOval(rect, borderPaint);
    }
  }

  /// Renders the MarkerShape.rectangle
  void _drawRectangle(Canvas canvas, Paint paint, Offset startPosition,
      double pointerAngle, Paint borderPaint, MarkerPointer markerPointer) {
    canvas.translate(startPosition.dx, startPosition.dy);
    canvas.rotate(_getDegreeToRadian(pointerAngle));
    canvas.drawRect(
        Rect.fromLTRB(
            -markerPointer.markerWidth / 2,
            -markerPointer.markerHeight / 2,
            markerPointer.markerWidth / 2,
            markerPointer.markerHeight / 2),
        paint);
    if (borderPaint != null) {
      canvas.drawRect(
          Rect.fromLTRB(
              -markerPointer.markerWidth / 2,
              -markerPointer.markerHeight / 2,
              markerPointer.markerWidth / 2,
              markerPointer.markerHeight / 2),
          borderPaint);
    }
  }

  /// Renders the MarkerShape.image
  void _drawMarkerImage(Canvas canvas, Paint paint, Offset startPosition,
      double pointerAngle, MarkerPointer markerPointer) {
    canvas.translate(startPosition.dx, startPosition.dy);
    canvas.rotate(_getDegreeToRadian(pointerAngle + 90));
    final Rect rect = Rect.fromLTRB(
        -markerPointer.markerWidth / 2,
        -markerPointer.markerHeight / 2,
        markerPointer.markerWidth / 2,
        markerPointer.markerHeight / 2);
    if (_image != null) {
      canvas.drawImageNine(_image, rect, rect, paint);
    }
  }

  /// Renders the MarkerShape.diamond
  void _drawDiamond(Canvas canvas, Paint paint, Offset startPosition,
      double pointerAngle, Paint borderPaint, MarkerPointer markerPointer) {
    canvas.translate(startPosition.dx, startPosition.dy);
    canvas.rotate(_getDegreeToRadian(pointerAngle - 90));
    final Path path = Path();
    path.moveTo(-markerPointer.markerWidth / 2, 0);
    path.lineTo(0, markerPointer.markerHeight / 2);
    path.lineTo(markerPointer.markerWidth / 2, 0);
    path.lineTo(0, -markerPointer.markerHeight / 2);
    path.lineTo(-markerPointer.markerWidth / 2, 0);
    path.close();
    canvas.drawPath(path, paint);
    if (borderPaint != null) {
      canvas.drawPath(path, borderPaint);
    }
  }

  /// Renders the triangle and the inverted triangle
  void _drawTriangle(Canvas canvas, Paint paint, Offset startPosition,
      double pointerAngle, Paint borderPaint, MarkerPointer markerPointer) {
    canvas.translate(startPosition.dx, startPosition.dy);
    final double triangleAngle = markerPointer.markerType == MarkerType.triangle
        ? pointerAngle + 90
        : pointerAngle - 90;
    canvas.rotate(_getDegreeToRadian(triangleAngle));

    final Path path = Path();
    path.moveTo(-markerPointer.markerWidth / 2, markerPointer.markerHeight / 2);
    path.lineTo(markerPointer.markerWidth / 2, markerPointer.markerHeight / 2);
    path.lineTo(0, -markerPointer.markerHeight / 2);
    path.lineTo(-markerPointer.markerWidth / 2, markerPointer.markerHeight / 2);
    path.close();
    canvas.drawPath(path, paint);
    if (borderPaint != null) {
      canvas.drawPath(path, borderPaint);
    }
  }
}
