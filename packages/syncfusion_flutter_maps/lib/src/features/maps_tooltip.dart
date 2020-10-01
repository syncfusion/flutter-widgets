part of maps;

/// Shows additional information about a particular shape in maps.
class _MapTooltip extends StatefulWidget {
  const _MapTooltip({
    Key key,
    this.mapDelegate,
    this.shapeTooltipBuilder,
    this.bubbleTooltipBuilder,
    this.enableShapeTooltip,
    this.enableBubbleTooltip,
    this.tooltipSettings,
    this.themeData,
    this.defaultController,
  }) : super(key: key);

  final MapShapeLayerDelegate mapDelegate;
  final IndexedWidgetBuilder shapeTooltipBuilder;
  final IndexedWidgetBuilder bubbleTooltipBuilder;
  final bool enableShapeTooltip;
  final bool enableBubbleTooltip;
  final MapTooltipSettings tooltipSettings;
  final SfMapsThemeData themeData;
  final _DefaultController defaultController;

  @override
  _MapTooltipState createState() => _MapTooltipState();
}

class _MapTooltipState extends State<_MapTooltip>
    with SingleTickerProviderStateMixin {
  AnimationController tooltipAnimationController;

  Widget _tooltipChild;

  // Specifies index based on the shape layer data count.
  void addChild(int index, _Layer layer) {
    switch (layer) {
      case _Layer.shape:
        _tooltipChild = widget.shapeTooltipBuilder(context, index);
        setState(() {
          // Rebuilds to visually add a builder for shape tooltip when a
          // shape is tapped or hovered.
        });
        break;
      case _Layer.bubble:
        _tooltipChild = widget.bubbleTooltipBuilder(context, index);
        setState(() {
          // Rebuilds to visually add a builder for bubble tooltip when a
          // bubble is tapped or hovered.
        });
        break;
    }
  }

  void removeChild() {
    _tooltipChild = null;
    setState(() {
      // Rebuilds to visually remove the tooltip child from the tooltip widget.
    });
  }

  @override
  void initState() {
    super.initState();
    tooltipAnimationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 200));
  }

  @override
  void dispose() {
    tooltipAnimationController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _MapTooltipRenderObjectWidget(
      key: widget.key,
      child: _tooltipChild,
      delegate: widget.mapDelegate,
      enableShapeTooltip: widget.enableShapeTooltip,
      enableBubbleTooltip: widget.enableBubbleTooltip,
      tooltipSettings: widget.tooltipSettings,
      themeData: widget.themeData,
      state: this,
    );
  }
}

/// A Render object widget which draws tooltip shape.
class _MapTooltipRenderObjectWidget extends SingleChildRenderObjectWidget {
  const _MapTooltipRenderObjectWidget({
    Key key,
    Widget child,
    this.delegate,
    this.enableShapeTooltip,
    this.enableBubbleTooltip,
    this.tooltipSettings,
    this.themeData,
    this.state,
  }) : super(key: key, child: child);

  final MapShapeLayerDelegate delegate;
  final bool enableShapeTooltip;
  final bool enableBubbleTooltip;
  final MapTooltipSettings tooltipSettings;
  final SfMapsThemeData themeData;
  final _MapTooltipState state;

  @override
  _RenderMapTooltip createRenderObject(BuildContext context) {
    return _RenderMapTooltip(
      delegate: delegate,
      enableShapeTooltip: enableShapeTooltip,
      enableBubbleTooltip: enableBubbleTooltip,
      tooltipSettings: tooltipSettings,
      themeData: themeData,
      context: context,
      mediaQueryData: MediaQuery.of(context),
      state: state,
    );
  }

  @override
  void updateRenderObject(
      BuildContext context, _RenderMapTooltip renderObject) {
    renderObject
      ..delegate = delegate
      ..enableShapeTooltip = enableShapeTooltip
      ..enableBubbleTooltip = enableBubbleTooltip
      ..tooltipSettings = tooltipSettings
      ..themeData = themeData
      ..context = context
      ..mediaQueryData = MediaQuery.of(context);
  }
}

class _RenderMapTooltip extends _ShapeLayerChildRenderBoxBase {
  _RenderMapTooltip({
    MapShapeLayerDelegate delegate,
    bool enableShapeTooltip,
    bool enableBubbleTooltip,
    MapTooltipSettings tooltipSettings,
    SfMapsThemeData themeData,
    BuildContext context,
    MediaQueryData mediaQueryData,
    _MapTooltipState state,
  })  : _delegate = delegate,
        _enableShapeTooltip = enableShapeTooltip,
        _enableBubbleTooltip = enableBubbleTooltip,
        _tooltipSettings = tooltipSettings,
        _themeData = themeData,
        _mediaQueryData = mediaQueryData,
        _state = state,
        context = context {
    _textPainter = TextPainter(textDirection: TextDirection.ltr);
    _textPainter.textScaleFactor = _mediaQueryData.textScaleFactor;
    _tooltipAnimation = CurvedAnimation(
        parent: _state.tooltipAnimationController, curve: Curves.easeOutBack);
  }

  final _MapTooltipState _state;
  final _TooltipShape _tooltipShape = const _TooltipShape();
  Animation<double> _tooltipAnimation;
  Timer _tooltipDelayTimer;
  TextPainter _textPainter;
  String _tooltipText;
  Offset _touchPosition;
  BuildContext context;

  bool get drawTooltip =>
      (_tooltipText != null || child != null) && _touchPosition != null;

  MapTooltipSettings get tooltipSettings => _tooltipSettings;
  MapTooltipSettings _tooltipSettings;
  set tooltipSettings(MapTooltipSettings value) {
    if (_tooltipSettings == value) {
      return;
    }
    _tooltipSettings = value;
  }

  MapShapeLayerDelegate get delegate => _delegate;
  MapShapeLayerDelegate _delegate;
  set delegate(MapShapeLayerDelegate value) {
    if (_delegate == value) {
      return;
    }
    _delegate = value;
    _tooltipText = null;
    // Tooltip will remain in the UI for 3 seconds.
    // Between this time when mapDelegate changes,
    // We need to remove the tooltip from the UI immediately.
    if (_state.tooltipAnimationController.value > 0) {
      _state.tooltipAnimationController.reverse();
    }
  }

  bool get enableShapeTooltip => _enableShapeTooltip;
  bool _enableShapeTooltip;
  set enableShapeTooltip(bool value) {
    if (_enableShapeTooltip == value) {
      return;
    }
    _enableShapeTooltip = value;
  }

  bool get enableBubbleTooltip => _enableBubbleTooltip;
  bool _enableBubbleTooltip;
  set enableBubbleTooltip(bool value) {
    if (_enableBubbleTooltip == value) {
      return;
    }
    _enableBubbleTooltip = value;
  }

  SfMapsThemeData get themeData => _themeData;
  SfMapsThemeData _themeData;
  set themeData(SfMapsThemeData value) {
    if (_themeData == value) {
      return;
    }
    _themeData = value;
    markNeedsPaint();
  }

  MediaQueryData get mediaQueryData => _mediaQueryData;
  MediaQueryData _mediaQueryData;
  set mediaQueryData(MediaQueryData value) {
    if (_mediaQueryData == value) {
      return;
    }
    _mediaQueryData = value;
    _tooltipText = null;
    _touchPosition = null;
    _textPainter.textScaleFactor = _mediaQueryData.textScaleFactor;
  }

  void _updateTooltipTextAndPosition(
      Offset position, _MapModel model, _Layer layer,
      {bool isHover = false}) {
    bool hasChild = false;
    String tooltipText;
    if (model != null) {
      if (_enableBubbleTooltip && layer == _Layer.bubble) {
        if (model.dataIndex != null &&
            _state.widget.bubbleTooltipBuilder != null) {
          _state.addChild(model.dataIndex, layer);
          hasChild = true;
        } else if (model.dataIndex != null &&
            _delegate.bubbleTooltipTextMapper != null) {
          tooltipText = _delegate.bubbleTooltipTextMapper(model.dataIndex);
        } else {
          tooltipText = model.primaryKey;
        }
        _touchPosition =
            tooltipText != null || hasChild ? position : _touchPosition;
      } else if (_enableShapeTooltip && layer == _Layer.shape) {
        if (model.dataIndex != null &&
            _state.widget.shapeTooltipBuilder != null) {
          _state.addChild(model.dataIndex, layer);
          hasChild = true;
        } else if (model.dataIndex != null &&
            _delegate.shapeTooltipTextMapper != null) {
          tooltipText = _delegate.shapeTooltipTextMapper(model.dataIndex);
        } else {
          tooltipText = model.primaryKey;
        }
        _touchPosition =
            tooltipText != null || hasChild ? position : _touchPosition;
      }
    }

    if (isHover) {
      if (model != null && (tooltipText != null || hasChild)) {
        if (tooltipText != null && child != null) {
          _state.removeChild();
        }

        _tooltipDelayTimer?.cancel();
        if (_state.tooltipAnimationController.value == 0) {
          _state.tooltipAnimationController.forward(from: 0.0);
          _touchPosition = position;
          _tooltipText = tooltipText;
        } else {
          _tooltipText = tooltipText;
          markNeedsPaint();
        }
      } else if (_state.tooltipAnimationController.value > 0) {
        _tooltipDelayTimer?.cancel();
        _tooltipDelayTimer = Timer(
          const Duration(milliseconds: 300),
          () {
            _tooltipDelayTimer = null;
            if (tooltipText == null) {
              _state.tooltipAnimationController.reverse();
            }
          },
        );
      }
    } else if (model != null && (tooltipText != null || hasChild)) {
      if (tooltipText != null && child != null) {
        _state.removeChild();
      }
      _forwardTooltipAnimation();
      _touchPosition = position;
      _tooltipText = tooltipText;
    }
  }

  void _forwardTooltipAnimation() {
    _state.tooltipAnimationController.forward(from: 0.0);
    _tooltipDelayTimer?.cancel();
    _tooltipDelayTimer = Timer(
      const Duration(seconds: 3),
      () {
        _tooltipDelayTimer = null;
        if (_state.tooltipAnimationController.status ==
            AnimationStatus.completed) {
          _state.tooltipAnimationController.reverse();
        }
      },
    );
  }

  void _handleAnimationStatusChange(AnimationStatus status) {
    if (status == AnimationStatus.dismissed) {
      _tooltipText = null;
      _touchPosition = null;
    }
  }

  void _forceRemoveTooltip() {
    if (_tooltipText != null) {
      _tooltipDelayTimer?.cancel();
      _tooltipDelayTimer = null;
      _tooltipText = null;
      _touchPosition = null;
      markNeedsPaint();
    }
  }

  void _handleZooming(MapZoomDetails details) {
    _forceRemoveTooltip();
  }

  void _handlePanning(MapPanDetails details) {
    _forceRemoveTooltip();
  }

  void _handleReset() {
    _forceRemoveTooltip();
  }

  @override
  void onTap(Offset position, {_MapModel model, _Layer layer}) {
    _updateTooltipTextAndPosition(position, model, layer);
  }

  @override
  void onHover(Offset position, {_MapModel model, _Layer layer}) {
    _updateTooltipTextAndPosition(position, model, layer, isHover: true);
  }

  @override
  bool get isRepaintBoundary => true;

  @override
  void performLayout() {
    size = _getBoxSize(constraints);
    if (child != null) {
      child.layout(constraints, parentUsesSize: true);
    }
  }

  @override
  void attach(PipelineOwner owner) {
    super.attach(owner);
    _tooltipAnimation.addListener(markNeedsPaint);
    _tooltipAnimation.addStatusListener(_handleAnimationStatusChange);
    if (_state.widget.defaultController != null) {
      _state.widget.defaultController.addZoomingListener(_handleZooming);
      _state.widget.defaultController.addPanningListener(_handlePanning);
      _state.widget.defaultController.addResetListener(_handleReset);
    }
  }

  @override
  void detach() {
    _tooltipAnimation.removeListener(markNeedsPaint);
    _tooltipAnimation.removeStatusListener(_handleAnimationStatusChange);
    if (_state.widget.defaultController != null) {
      _state.widget.defaultController.removeZoomingListener(_handleZooming);
      _state.widget.defaultController.removePanningListener(_handlePanning);
      _state.widget.defaultController.removeResetListener(_handleReset);
    }
    _tooltipDelayTimer?.cancel();
    super.detach();
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    if (drawTooltip) {
      if (_tooltipText != null) {
        _textPainter.text = TextSpan(
            text: _tooltipText,
            style: _tooltipSettings.textStyle ?? _themeData.tooltipTextStyle);
        _textPainter.layout();
      }

      _tooltipShape.paint(
          context,
          offset,
          _touchPosition,
          _textPainter,
          Paint()
            ..style = PaintingStyle.fill
            ..color = _tooltipSettings.color ?? _themeData.tooltipColor,
          this,
          _tooltipAnimation,
          _themeData,
          _tooltipSettings);
    }
  }
}
