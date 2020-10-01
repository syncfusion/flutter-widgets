part of charts;

// ignore: must_be_immutable
class _TooltipTemplate extends StatefulWidget {
  // ignore: prefer_const_constructors_in_immutables
  _TooltipTemplate(
      {this.rect,
      this.template,
      this.show,
      this.clipRect,
      this.duration = 3000,
      this.tooltipBehavior,
      this.chartState});

  Rect rect;

  Widget template;

  bool show;

  bool _alwaysShow;

  Rect clipRect;

  _TooltipTemplateState state;

  double duration;

  TooltipBehavior tooltipBehavior;

  dynamic chartState;

  @override
  State<StatefulWidget> createState() {
    return _TooltipTemplateState();
  }
}

class _TooltipTemplateState extends State<_TooltipTemplate>
    with SingleTickerProviderStateMixin {
  BuildContext tooltipContext;

  bool needMeasure;

  Size tooltipSize = const Size(0, 0);

  AnimationController _controller;
  Animation<double> _animation;

  //properties hold the previous and current tooltip values when the interaction is done through mouse hovering
  TooltipValue prevTooltipValue;
  TooltipValue currentTooltipValue;
  //This stores the tooltip value when the mode of interation is touch.
  TooltipValue presentTooltipValue;
  int seriesIndex;

  Timer tooltipTimer;

  bool isOutOfBoundInTop = false;

  @override
  void initState() {
    widget.state = this;
    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 300));
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.1, 0.8, curve: Curves.easeOutBack),
    ));
    super.initState();
  }

  @override
  void didUpdateWidget(_TooltipTemplate oldWidget) {
    widget.state = this;
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    Widget tooltipWidget;
    isOutOfBoundInTop = false;
    const double arrowHeight = 5.0, arrowWidth = 10.0;
    if (widget.show) {
      if (needMeasure) {
        tooltipWidget =
            Opacity(opacity: 0.0, child: Container(child: widget.template));
        tooltipContext = context;
        SchedulerBinding.instance.addPostFrameCallback((_) => _loaded());
      } else {
        _controller.forward(from: 0.0);
        num top = widget.rect.top;
        final Rect tooltipRect = Rect.fromLTWH(
            widget.rect.left - tooltipSize.width / 2,
            top - tooltipSize.height - arrowHeight,
            tooltipSize.width,
            tooltipSize.height);
        final Offset tooltipLocation =
            _getTooltipLocation(tooltipRect, widget.clipRect);

        final Offset arrowLocation = Offset(
            tooltipLocation.dx, isOutOfBoundInTop ? top : top - arrowHeight);
        top = isOutOfBoundInTop ? top + arrowHeight : tooltipRect.top;
        tooltipWidget = Stack(children: <Widget>[
          CustomPaint(
              size: Size(arrowHeight, arrowWidth),
              painter: _ArrowPainter(
                  arrowLocation,
                  Size(tooltipSize.width.toDouble(), arrowHeight.toDouble()),
                  widget.tooltipBehavior,
                  widget.chartState,
                  isOutOfBoundInTop,
                  _animation,
                  tooltipSize)),
          Container(
              child: Padding(
                  padding: EdgeInsets.fromLTRB(tooltipLocation.dx, top, 0, 0),
                  child: ScaleTransition(
                      scale: _animation, child: widget.template)))
        ]);
      }
    } else {
      tooltipWidget = Container();
      presentTooltipValue = null;
    }
    if (tooltipTimer != null) {
      tooltipTimer.cancel();
    }
    if (widget.show &&
        (prevTooltipValue == null && currentTooltipValue == null)) {
      tooltipTimer = Timer(
          Duration(milliseconds: widget.duration.toInt()), hideTooltipTemplate);
    }
    return tooltipWidget;
  }

  @override
  void dispose() {
    _controller.dispose();
    tooltipTimer?.cancel();
    super.dispose();
  }

  /// To hide tooltip template with timer
  void hideOnTimer() {
    if (prevTooltipValue == null && currentTooltipValue == null) {
      hideTooltipTemplate();
    } else {
      if (tooltipTimer != null) {
        tooltipTimer.cancel();
      }
      tooltipTimer = Timer(
          Duration(milliseconds: widget.duration.toInt()), hideTooltipTemplate);
    }
  }

  /// To hide tooltip templates
  void hideTooltipTemplate() {
    presentTooltipValue = null;
    if (mounted && !(widget._alwaysShow ?? false)) {
      setState(() {
        widget.show = false;
      });
      prevTooltipValue = null;
      currentTooltipValue = null;
    }
  }

  /// To perform rendering of tooltip
  void _performTooltip() {
    //for mouse hover the tooltip is redrawn only when the current tooltip value differs from the previous one
    if (widget.show &&
        mounted &&
        ((prevTooltipValue == null && currentTooltipValue == null) ||
            (prevTooltipValue?.seriesIndex !=
                    currentTooltipValue?.seriesIndex ||
                prevTooltipValue?.pointIndex !=
                    currentTooltipValue?.pointIndex))) {
      needMeasure = true;
      tooltipSize = const Size(0, 0);
      setState(() {});
    }
  }

  /// For rebuilding this state after finding render object size.
  void _loaded() {
    final RenderBox renderBox = tooltipContext.findRenderObject();
    tooltipSize = renderBox.size;
    needMeasure = false;
    if (mounted) {
      setState(() {});
    }
  }

  /// It returns the offset values of tooltip location
  Offset _getTooltipLocation(Rect tooltipRect, Rect bounds) {
    double left = tooltipRect.left, top = tooltipRect.top;
    if (tooltipRect.left < bounds.left) {
      left = bounds.left;
    }
    if (tooltipRect.top < bounds.top) {
      top = bounds.top;
      isOutOfBoundInTop = true;
    }
    if (tooltipRect.left + tooltipRect.width > bounds.left + bounds.width) {
      left = (bounds.left + bounds.width) - tooltipRect.width;
    }
    if (tooltipRect.top + tooltipRect.height > bounds.top + bounds.height) {
      top = (bounds.top + bounds.height) - tooltipRect.height;
    }
    return Offset(left, top);
  }
}

class _ArrowPainter extends CustomPainter {
  const _ArrowPainter(
      this._location,
      this._currentSize,
      this._tooltipBehavior,
      this._chartState,
      this._isOutOfBoundInTop,
      this._animation,
      this._templateSize);
  final Offset _location;
  final Size _currentSize;
  final Size _templateSize;
  final TooltipBehavior _tooltipBehavior;
  final dynamic _chartState;
  final bool _isOutOfBoundInTop;
  final Animation<double> _animation;
  @override
  void paint(Canvas canvas, Size size) {
    const num padding = 2;
    final num templateHeight = _templateSize.height;
    final num arrowHeight = (_currentSize.height + padding) * _animation.value;
    final num centerTemplateY = _isOutOfBoundInTop
        ? _location.dy + _currentSize.height + templateHeight / 2 + padding
        : _location.dy - templateHeight / 2 - padding;
    final num locationY = _isOutOfBoundInTop
        ? centerTemplateY -
            ((templateHeight / 2) * _animation.value) -
            arrowHeight
        : centerTemplateY + ((templateHeight / 2) * _animation.value);
    final num centerX = _location.dx + _currentSize.width / 2;
    final num arrowWidth = 8 * _animation.value;
    final Path path = Path()
      ..moveTo(centerX + (_isOutOfBoundInTop ? 0 : -arrowWidth), locationY)
      ..lineTo(centerX + (_isOutOfBoundInTop ? -arrowWidth : arrowWidth),
          (locationY) + (_isOutOfBoundInTop ? arrowHeight : 0))
      ..lineTo(centerX + (_isOutOfBoundInTop ? arrowWidth : 0),
          locationY + arrowHeight)
      ..close();
    canvas.drawPath(
        path,
        Paint()
          ..color =
              (_tooltipBehavior.color ?? _chartState._chartTheme.tooltipColor)
                  .withOpacity(_tooltipBehavior.opacity)
          ..style = PaintingStyle.fill);
  }

  @override
  bool shouldRepaint(_ArrowPainter oldDelegate) => true;
}
