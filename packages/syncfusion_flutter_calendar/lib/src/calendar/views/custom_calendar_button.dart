part of calendar;

/// Specifies the unconfirmed ripple animation duration used on custom splash.
/// The duration was unconfirmed because the ripple animation duration changed
/// based on its radius value.
const Duration _kUnconfirmedRippleSplashDuration = Duration(seconds: 1);

/// Specifies the fade animation duration used on custom splash.
const Duration _kSplashFadeDuration = Duration(milliseconds: 500);

/// Used to create the custom splash factory that shows the splash for inkwell
/// interaction.
class _CustomSplashFactory extends InteractiveInkFeatureFactory {
  /// Called when the inkwell pressed and it return custom splash.
  @override
  InteractiveInkFeature create({
    @required MaterialInkController controller,
    @required RenderBox referenceBox,
    @required Offset position,
    @required Color color,
    @required TextDirection textDirection,
    bool containedInkWell = false,
    RectCallback rectCallback,
    BorderRadius borderRadius,
    ShapeBorder customBorder,
    double radius,
    VoidCallback onRemoved,
  }) {
    return _CustomSplash(
      controller: controller,
      referenceBox: referenceBox,
      position: position,
      color: color,
      containedInkWell: containedInkWell,
      borderRadius: borderRadius,
      rectCallback: rectCallback,
      onRemoved: onRemoved,
    );
  }
}

/// Custom ink splash used to animate the inkwell on intercation.
class _CustomSplash extends InteractiveInkFeature {
  /// Begin a splash, centered at position relative to [referenceBox].
  ///
  /// The [controller] argument is typically obtained via
  /// `Material.of(context)`.
  ///
  /// If `containedInkWell` is true, then the splash will be sized to fit
  /// the well rectangle, then clipped to it when drawn. The well
  /// rectangle is the box returned by `rectCallback`, if provided, or
  /// otherwise is the bounds of the [referenceBox].
  ///
  /// If `containedInkWell` is false, then `rectCallback` should be null.
  /// The ink splash is clipped only to the edges of the [Material].
  /// This is the default.
  ///
  /// When the splash is removed, `onRemoved` will be called.
  _CustomSplash({
    @required MaterialInkController controller,
    @required RenderBox referenceBox,
    Offset position,
    Color color,
    bool containedInkWell = false,
    RectCallback rectCallback,
    BorderRadius borderRadius,
    VoidCallback onRemoved,
  })  : _position = position,
        _borderRadius = borderRadius ?? BorderRadius.zero,
        _targetRadius = _getTargetRadius(
            referenceBox, containedInkWell, rectCallback, position),
        _clipCallback =
            _getClipCallback(referenceBox, containedInkWell, rectCallback),
        _repositionToReferenceBox = !containedInkWell,
        super(
            controller: controller,
            referenceBox: referenceBox,
            color: color,
            onRemoved: onRemoved) {
    _radiusController = AnimationController(
        duration: _kUnconfirmedRippleSplashDuration, vsync: controller.vsync)
      ..addListener(controller.markNeedsPaint)
      ..forward();
    _radius = _radiusController.drive(Tween<double>(
      begin: 0.0,
      end: _targetRadius,
    ));
    _alphaController = AnimationController(
        duration: _kSplashFadeDuration, vsync: controller.vsync)
      ..addListener(controller.markNeedsPaint)
      ..addStatusListener(_handleAlphaStatusChanged);
    _alpha = _alphaController.drive(IntTween(
      begin: color.alpha,
      end: 0,
    ));

    controller.addInkFeature(this);
  }

  /// Position holds the input touch point.
  final Offset _position;

  /// Specifies the border radius used on the inkwell
  final BorderRadius _borderRadius;

  /// Radius of ink circle to be drawn on canvas based on its position.
  final double _targetRadius;

  /// clipCallback is the callback used to obtain the rect used for clipping
  /// the ink effect. If it is null, no clipping is performed on the ink circle.
  final RectCallback _clipCallback;

  /// Specifies the reference box repositioned or not. Its value depends on
  /// contained inkwell property.
  final bool _repositionToReferenceBox;

  /// Animation used to show a ripple.
  Animation<double> _radius;

  /// Controller used to handle the ripple animation.
  AnimationController _radiusController;

  /// Animation used to handle a opacity.
  Animation<int> _alpha;

  /// Controller used to handle the opacity animation.
  AnimationController _alphaController;

  @override
  void confirm() {
    /// Calculate the ripple animation duration from its radius value and start
    /// the animation.
    Duration duration = Duration(milliseconds: (_targetRadius * 10).floor());
    duration = duration > _kUnconfirmedRippleSplashDuration
        ? _kUnconfirmedRippleSplashDuration
        : duration;
    _radiusController
      ..duration = duration
      ..forward();
    _alphaController.forward();
  }

  @override
  void cancel() {
    _alphaController?.forward();
  }

  void _handleAlphaStatusChanged(AnimationStatus status) {
    /// Dispose inkwell animation when the animation completed.
    if (status == AnimationStatus.completed) dispose();
  }

  @override
  void dispose() {
    _radiusController.dispose();
    _alphaController.dispose();
    _radiusController = null;
    _alphaController = null;
    super.dispose();
  }

  ///Draws an ink splash or ink ripple on the canvas.
  @override
  void paintFeature(Canvas canvas, Matrix4 transform) {
    final Paint paint = Paint()..color = color.withAlpha(_alpha.value);
    Offset center = _position;

    /// If the reference box needs to reposition then its 'rectCallback' value
    /// is null, so calculate the position based on reference box.
    if (_repositionToReferenceBox) {
      center = Offset.lerp(center, referenceBox.size.center(Offset.zero),
          _radiusController.value);
    }

    /// Get the offset needs to translate, if it not specified then it
    /// returns null value.
    final Offset originOffset = MatrixUtils.getAsTranslation(transform);
    canvas.save();

    /// Translate the canvas based on offset value.
    if (originOffset == null) {
      canvas.transform(transform.storage);
    } else {
      canvas.translate(originOffset.dx, originOffset.dy);
    }

    if (_clipCallback != null) {
      /// Clip and draw the rect with fade animation value on canvas.
      final Rect rect = _clipCallback();
      if (_borderRadius != BorderRadius.zero) {
        final RRect roundedRect = RRect.fromRectAndCorners(
          rect,
          topLeft: _borderRadius.topLeft,
          topRight: _borderRadius.topRight,
          bottomLeft: _borderRadius.bottomLeft,
          bottomRight: _borderRadius.bottomRight,
        );
        canvas.clipRRect(roundedRect);
        canvas.drawRRect(roundedRect, paint);
      } else {
        canvas.clipRect(rect);
        canvas.drawRect(rect, paint);
      }
    }

    /// Draw the ripple on canvas.
    canvas.drawCircle(center, _radius.value, paint);
    canvas.restore();
  }
}

/// Returns the maximum radius value calculated based on input touch position.
double _getTargetRadius(RenderBox referenceBox, bool containedInkWell,
    RectCallback rectCallback, Offset position) {
  /// If `containedInkWell` is false, then `rectCallback` should be null.
  if (!containedInkWell) {
    return Material.defaultSplashRadius;
  }

  final Size size =
      rectCallback != null ? rectCallback().size : referenceBox.size;
  final double d1 = (position - size.topLeft(Offset.zero)).distance;
  final double d2 = (position - size.topRight(Offset.zero)).distance;
  final double d3 = (position - size.bottomLeft(Offset.zero)).distance;
  final double d4 = (position - size.bottomRight(Offset.zero)).distance;
  return math.max(math.max(d1, d2), math.max(d3, d4)).ceilToDouble();
}

/// Return the rect callback value based on its argument value.
RectCallback _getClipCallback(
    RenderBox referenceBox, bool containedInkWell, RectCallback rectCallback) {
  if (rectCallback != null) {
    /// If `containedInkWell` is false, then `rectCallback` should be null.
    assert(containedInkWell);
    return rectCallback;
  }
  if (containedInkWell) return () => Offset.zero & referenceBox.size;
  return null;
}
