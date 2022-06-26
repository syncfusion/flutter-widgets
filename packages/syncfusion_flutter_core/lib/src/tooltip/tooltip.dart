// ignore_for_file: avoid_setters_without_getters

part of tooltip_internal;

/// Renders the tooltip widget.
///
/// This class provides options for customizing the properties of the tooltip.
class SfTooltip extends StatefulWidget {
  /// Creating an argument constructor of SfTooltip class.
  // ignore: prefer_const_constructors_in_immutables
  SfTooltip(
      {this.textStyle = const TextStyle(),
      this.animationDuration = 500,
      this.animationCurve = const Interval(0.0, 1.0),
      this.enable = true,
      this.opacity = 1,
      this.borderColor = Colors.black,
      this.borderWidth = 0,
      this.duration = 3000,
      this.shouldAlwaysShow = false,
      this.elevation = 0,
      this.canShowMarker = true,
      this.textAlignment = TooltipAlignment.near,
      this.decimalPlaces = 2,
      this.color = Colors.black,
      this.labelColor = Colors.white,
      this.header,
      this.format,
      this.shadowColor,
      Key? key,
      this.onTooltipRender})
      : super(key: key);

  ///Toggles the visibility of the tooltip.
  ///
  ///Defaults to `true`.
  final bool enable;

  ///Color of the tooltip.
  ///
  ///Defaults to `Colors.black`.
  final Color color;

  ///Color of the tooltip label.
  ///
  ///Defaults to `Colors.white`.
  final Color labelColor;

  ///Color of the tooltip border.
  ///
  ///Defaults to `Colors.black`.
  final Color borderColor;

  ///Color of the tooltip shadow.
  ///
  ///Defaults to tooltip color.
  final Color? shadowColor;

  /// Header of the tooltip. By default, there will be no header.
  final String? header;

  ///Opacity of the tooltip.
  ///
  ///The value ranges from 0 to 1.
  ///
  ///Defaults to `1`.
  final double opacity;

  ///Customizes the tooltip text style
  final TextStyle textStyle;

  ///Specifies the number decimals to be displayed in tooltip text
  ///
  ///Defaults to `2`.
  final int decimalPlaces;

  ///Formats the tooltip text.
  ///
  ///By default, the tooltip will be rendered with x and y-values.
  ///
  ///You can add prefix or suffix to x, y values in the
  ///tooltip by formatting them.
  final String? format;

  ///Duration for animating the tooltip.
  ///
  ///Defaults to `500`.
  final int animationDuration;

  ///Curve for animating the tooltip.
  ///
  ///Defaults to interval of `0` to `1` with `Curves.linear`.
  final Interval animationCurve;

  ///Toggles the visibility of the marker in the tooltip.
  ///
  ///Defaults to `true`.
  final bool canShowMarker;

  ///Border width of the tooltip.
  ///
  ///Defaults to `0`.
  final double borderWidth;

  ///Elevation of the tooltip.
  ///
  ///Defaults to `0`.
  final double elevation;

  ///Shows or hides the tooltip.
  ///
  ///By default, the tooltip will be hidden on touch.
  ///To avoid this, set this property to true.
  ///
  ///Defaults to `false`.
  final bool shouldAlwaysShow;

  ///Duration for displaying the tooltip.
  ///
  ///Defaults to `3000`.
  final int duration;

  ///Alignment of the text in the tooltip
  final dynamic textAlignment;

  /// Occurs while tooltip is rendered.
  /// You can customize the text, position and header.
  /// Here, you can get the text, header, x and y-positions.
  final void Function(TooltipRenderArgs tooltipRenderArgs)? onTooltipRender;

  @override
  SfTooltipState createState() => SfTooltipState();
}

/// Represents the state class of [SfTooltip] widget
class SfTooltipState extends State<SfTooltip>
    with SingleTickerProviderStateMixin {
  /// Animation controller for tooltip
  AnimationController? animationController;

  /// Determibes the visibility of the tooltip.
  late bool _show;

  /// whether to render marker or not.
  late bool needMarker;

  /// holds the instance of the tooltip renderbox associated with this state.
  TooltipRenderBox? renderBox;

  Widget? _template;

  Timer? _timer;

  bool _hidden = false, _animating = false, _didUpdate = false, _isRtl = false;

  Object? _previousTooltipData;

  late int _showDuration;

  ///Setter for the boundary rect within which the tooltip could be shown
  set boundaryRect(Rect value) {
    if (renderBox != null) {
      if (renderBox!._boundaryRect == value) {
        return;
      }
      renderBox!._boundaryRect = value;
    }
  }

  /// Displays the tooltip at the position.
  ///
  ///
  /// *position - the x and y position at which the tooltip needs to be shown.
  /// *duration - the duration in milliseconds for which the tooltip animation
  /// needs to happen.
  /// *template - the widget that will be rendered instead of default tooltip
  /// *tooltipData - the data which allows this widget to decide whether it is
  /// activated for the same point
  void show(
      {int? duration,
      Offset? position,
      Object? tooltipData,
      String? tooltipContent,
      String? tooltipHeader,
      Widget? template}) {
    duration ??= widget.animationDuration;
    _hidden = false;
    animationController!.duration = Duration(milliseconds: duration);
    if (renderBox != null) {
      renderBox!._position = position;
    }
    _timer?.cancel();
    if (_previousTooltipData == null ||
        !(_previousTooltipData == tooltipData)) {
      _show = true;
      _template = template;
      _previousTooltipData = tooltipData;
      _animating = true;
      _showDuration = duration;
      if (tooltipContent != null) {
        renderBox!._stringValue = tooltipContent;
      }
      if (tooltipHeader != null) {
        renderBox!._header = tooltipHeader;
      }
      if (mounted) {
        setState(() {
          animationController!.duration = Duration(milliseconds: duration!);
          if (animationController?.status != AnimationStatus.forward) {
            animationController!.forward(from: 0.0);
          }
        });
      }
    } else {
      if (!_animating) {
        animationController!.duration = Duration.zero;
      }
    }
  }

  /// Hides the tooltip if it is currently displayed.
  /// *duration - the duration in milliseconds for which the tooltip animation
  /// needs to happen.
  /// *hideDelay - the duration in milliseconds after which the tooltip needs
  /// to be hidden
  void hide({int? duration, int? hideDelay}) {
    if (!_hidden || hideDelay == 0) {
      _timer?.cancel();
      _hidden = true;
      _timer = Timer(Duration(milliseconds: hideDelay ?? widget.duration), () {
        _previousTooltipData = null;
        if (animationController != null) {
          animationController!.duration = Duration(milliseconds: duration ?? 0);
          animationController!.reverse(from: 1.0);
        }
      });
    }
  }

  @override
  void initState() {
    _show = false;
    needMarker = widget.canShowMarker;
    animationController = AnimationController(
        duration: Duration(milliseconds: widget.animationDuration), vsync: this)
      ..addStatusListener(_animationStatusListener);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    _isRtl = Directionality.of(context) == TextDirection.rtl;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final Animation<double> tooltipAnimation =
        Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
      parent: animationController!,
      curve: widget.animationCurve,
    ));
    if (_show && !_didUpdate) {
      if (animationController?.status != AnimationStatus.forward) {
        animationController!.forward(from: 0.0);
      } else {
        animationController!.reset();
        animationController!.forward(from: 0.0);
      }
    }
    _didUpdate = false;
    _template = _template != null ? (_template ?? Container()) : null;
    return AnimatedBuilder(
      animation: animationController!,
      builder: (BuildContext context, Widget? child) {
        if (renderBox != null) {
          renderBox!.animationFactor = tooltipAnimation.value;
        }
        return child!;
      },
      child: TooltipRenderObject(
          template: _template,
          tooltipAnimation: tooltipAnimation,
          tooltipState: this,
          animationController: animationController!),
    );
  }

  @override
  void didUpdateWidget(SfTooltip oldWidget) {
    _didUpdate = true;
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    animationController!.removeStatusListener(_animationStatusListener);
    animationController!.dispose();
    animationController = null;
    super.dispose();
  }

  void _animationStatusListener(AnimationStatus status) {
    if (status == AnimationStatus.completed) {
      _animating = false;
    }
  }
}

/// Single child render object widget classfor rendering the tooltip
class TooltipRenderObject extends SingleChildRenderObjectWidget {
  /// Creating an argument constructor of TooltipRenderObject class.
  // ignore: prefer_const_constructors_in_immutables
  TooltipRenderObject(
      {Widget? template,
      required SfTooltipState tooltipState,
      required Animation<double> tooltipAnimation,
      required AnimationController animationController})
      : _tooltipState = tooltipState,
        _tooltipAnimation = tooltipAnimation,
        _animationController = animationController,
        super(child: template);

  final SfTooltipState _tooltipState;
  final Animation<double> _tooltipAnimation;
  final AnimationController _animationController;

  @override
  TooltipRenderBox createRenderObject(BuildContext context) {
    _tooltipState.renderBox = TooltipRenderBox(
        _tooltipState, _tooltipAnimation, _animationController);
    return _tooltipState.renderBox!;
  }

  @override
  void updateRenderObject(BuildContext context, TooltipRenderBox renderObject) {
    renderObject
      ..tooltipAnimation = _tooltipAnimation
      ..animationController = _animationController
      ..tooltipState = _tooltipState;
  }
}

/// tooltip render box class. This class holds the properties needed to render
/// the tooltip widget.
class TooltipRenderBox extends RenderShiftedBox {
  /// Creating an argument constructor of TooltipRenderBox class.
  TooltipRenderBox(
      this._tooltipState, this._tooltipAnimation, this._animationController,
      [RenderBox? child])
      : super(child);
  SfTooltip get _tooltip => _tooltipState.widget;
  SfTooltipState _tooltipState;

  ///Setter for tooltipState
  set tooltipState(SfTooltipState value) {
    if (_tooltipState == value) {
      return;
    }
    _tooltipState = value;
  }

  late Animation<double> _tooltipAnimation;

  ///Setter for tooltip animation instance
  set tooltipAnimation(Animation<double> value) {
    if (_tooltipAnimation == value) {
      return;
    }
    _tooltipAnimation = value;
  }

  late AnimationController _animationController;

  ///Setter for tooltip animation controller instance
  set animationController(AnimationController value) {
    if (_animationController == value) {
      return;
    }
    _animationController = value;
  }

  late double _animationFactor;

  ///Setter for tooltip animation factor
  set animationFactor(double value) {
    _animationFactor = value;
    markNeedsLayout();
    markNeedsPaint();
    markNeedsSemanticsUpdate();
  }

  String? _stringValue = '';

  ///Setter for tooltip content text
  set stringValue(String? value) {
    if (_stringValue == value) {
      return;
    }
    _stringValue = value;
  }

  String? _header = '';

  ///Setter for tooltip header text
  set header(String? value) {
    if (_header == value) {
      return;
    }
    _header = value;
  }

  double? _normalPadding = 0;

  ///Setter for tooltip padding
  set normalPadding(double value) {
    if (_normalPadding == value) {
      return;
    }
    _normalPadding = value;
  }

  double? _inversePadding;

  ///Setter for the tooltip padding when the tooltip is rendered upside
  set inversePadding(double value) {
    if (_inversePadding == value) {
      return;
    }
    _inversePadding = value;
  }

  late double _markerSize;

  ///Getter for size of marker rendered in tooltip
  double get markerSize => _markerSize;

  Rect _boundaryRect = Rect.zero;

  List<DataMarkerType?> _markerTypes = <DataMarkerType?>[];

  ///Setter for the tooltip marker type
  set markerTypes(List<DataMarkerType?> types) {
    _markerTypes = types;
  }

  List<Paint?> _markerPaints = <Paint?>[];

  ///Setter for tooltip marker paint
  set markerPaints(List<Paint?> paints) {
    _markerPaints = paints;
  }

  List<dynamic> _markerImages = <dynamic>[];

  ///Setter for the marker image of tooltip when the data marker type is image
  set markerImages(List<dynamic> images) {
    _markerImages = images;
  }

  List<LinearGradient?>? _markerGradients;

  ///Setter for the tooltip marker gradient
  set markerGradients(List<LinearGradient?> values) {
    _markerGradients = values;
  }

  final double _pointerLength = 10;
  double? _xPos, _yPos, _x, _y;
  Offset? _position;
  double _nosePointX = 0, _nosePointY = 0, _borderRadius = 5, _totalWidth = 0;
  bool _isLeft = false,
      _isRight = false,
      _isTop = false,
      _isOutOfBoundInTop = false;
  final double _templateArrowHeight = 5.0;
  late double _markerPointY;
  Rect? _tooltipRect;
  final Path _arrowPath = Path();
  late Size _templateSize;

  @override
  bool hitTest(BoxHitTestResult result, {required Offset position}) {
    if (child == null || _tooltipRect == null) {
      return false;
    } else {
      return child!.hitTest(result,
          position: position -
              (_isOutOfBoundInTop
                  ? _tooltipRect!.topLeft +
                      Offset(0, _templateArrowHeight + _tooltipRect!.height)
                  : _tooltipRect!.topLeft));
    }
  }

  @override
  void performLayout() {
    if (_tooltipState._show) {
      if (child != null) {
        _isOutOfBoundInTop = false;
        child!.layout(constraints, parentUsesSize: true);
        size = Size.copy(child!.size);
      }
    } else {
      size = Size(constraints.maxWidth.isFinite ? constraints.maxWidth : 0,
          constraints.maxHeight.isFinite ? constraints.maxHeight : 0);
      child?.layout(constraints);
    }
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    final Offset parentOffset = parentData is BoxParentData
        //ignore: avoid_as
        ? (parentData! as BoxParentData).offset
        : Offset.zero;
    final Offset relativeOffset = offset - parentOffset;
    calculateLocation(_position != null ? (_position!) : parentOffset);
    context.canvas.translate(relativeOffset.dx, relativeOffset.dy);
    if (_tooltipState._show) {
      if (((_animationController.value == 0 ||
                  _tooltipState._showDuration == 0) &&
              _animationController.status != AnimationStatus.dismissed) &&
          _tooltipState.widget.onTooltipRender != null) {
        final TooltipRenderArgs tooltipRenderArgs = TooltipRenderArgs(_header,
            _stringValue, _x != null && _y != null ? Offset(_x!, _y!) : null);
        _tooltipState.widget.onTooltipRender!(tooltipRenderArgs);
        _x = tooltipRenderArgs.location!.dx;
        _y = tooltipRenderArgs.location!.dy;
        _stringValue = tooltipRenderArgs.text;
        _header = tooltipRenderArgs.header;
      }
      if (_tooltipState._template == null) {
        _renderDefaultTooltipView(context.canvas);
      } else {
        _renderTemplateTooltipView(context, relativeOffset);
        context.canvas.translate(relativeOffset.dx, relativeOffset.dy);
      }
    }
    context.canvas.translate(-relativeOffset.dx, -relativeOffset.dy);
  }

  /// Renders the tooltip template view with tooltip background, arrow and
  /// template
  void _renderTemplateTooltipView(PaintingContext context, Offset offset) {
    _templateSize = Size.copy(child!.size);
    _tooltipRect = Rect.fromLTWH(
        _x! - _templateSize.width / 2,
        _y! - _templateSize.height - _templateArrowHeight,
        _templateSize.width,
        _templateSize.height);

    double top = _y!;
    double paddingTop = 0;
    final Rect bounds = _boundaryRect.translate(-offset.dx, -offset.dy);
    final Offset tooltipLocation =
        _getTemplateLocation(_tooltipRect!, bounds, offset);
    Offset arrowLocation = Offset(_x! - _templateSize.width / 2,
        _isOutOfBoundInTop ? _y! : _y! - _templateArrowHeight);
    if (_y! < bounds.top + offset.dy) {
      paddingTop = bounds.top + offset.dy + _templateArrowHeight;
      top = tooltipLocation.dy;
      arrowLocation = Offset(arrowLocation.dx, tooltipLocation.dy);
    }
    top = _isOutOfBoundInTop ? top + _templateArrowHeight : _tooltipRect!.top;
    if (_y! >= bounds.top + offset.dy) {
      paddingTop = top;
    }
    final Offset renderOffset = (_isOutOfBoundInTop
            ? Offset(tooltipLocation.dx, tooltipLocation.dy + paddingTop)
            : tooltipLocation) +
        offset;
    context.pushTransform(true, Offset(_x!, arrowLocation.dy) + offset,
        Matrix4.diagonal3Values(_animationFactor, _animationFactor, 1),
        (PaintingContext tooltipTemplateContext, Offset tooltipTemplateOffset) {
      _renderArrowAndTemplatePath(
          tooltipTemplateContext.canvas, arrowLocation + offset, renderOffset);
      tooltipTemplateContext.paintChild(child!, renderOffset);
    });
  }

  /// This method renders the path for tooltip template mode
  void _renderArrowAndTemplatePath(
      Canvas canvas, Offset location, Offset templateLocation) {
    final Paint strokePaint = Paint()
      ..style = PaintingStyle.stroke
      ..color =
          _tooltip.borderWidth == 0 ? Colors.transparent : _tooltip.borderColor
      ..strokeWidth = _tooltip.borderWidth;
    final Paint fillPaint = Paint()
      ..color = (_tooltip.color).withOpacity(_tooltip.opacity)
      ..style = PaintingStyle.fill;
    const double currentHeight = 5.0;
    const double arrowWidth = 8;
    const double padding = 0.1;
    final Size currentSize = Size(_templateSize.width, currentHeight);
    final num templateHeight = _templateSize.height;
    final num arrowHeight = currentSize.height + padding;
    final num centerTemplateY = _isOutOfBoundInTop
        ? location.dy + currentSize.height + templateHeight / 2 + padding
        : location.dy - templateHeight / 2 - padding;
    double locationY = _isOutOfBoundInTop
        ? centerTemplateY - (templateHeight / 2) - arrowHeight
        : centerTemplateY + templateHeight / 2;
    final num centerX = location.dx + currentSize.width / 2;
    final Path path = Path();
    final RRect rect = RRect.fromLTRBAndCorners(
        templateLocation.dx,
        templateLocation.dy,
        templateLocation.dx + _templateSize.width,
        templateLocation.dy + _templateSize.height,
        topLeft: Radius.circular(_borderRadius),
        topRight: Radius.circular(_borderRadius),
        bottomRight: Radius.circular(_borderRadius),
        bottomLeft: Radius.circular(_borderRadius));
    bool isVTypeArrow = true;
    final String side =
        (centerX < rect.left + rect.width / 2) ? 'left' : 'right';
    if (!_isOutOfBoundInTop) {
      locationY += arrowHeight - padding;
    }
    path.moveTo(rect.left + rect.tlRadiusX, rect.top);
    path.arcToPoint(Offset(rect.left, rect.top + rect.tlRadiusY),
        radius: rect.tlRadius, clockwise: false);
    path.lineTo(rect.left, rect.bottom - rect.blRadiusY);
    path.arcToPoint(Offset(rect.left + rect.blRadiusX, rect.bottom),
        radius: rect.blRadius, clockwise: false);
    if ((centerX > rect.left + rect.blRadiusX + arrowWidth / 2) &&
        (centerX < rect.right - rect.brRadiusX - arrowWidth / 2)) {
      path.lineTo(centerX - arrowWidth / 2, rect.bottom);
    } else {
      isVTypeArrow = false;
      if (side == 'right') {
        path.lineTo(rect.right - rect.brRadiusX - arrowWidth * 2, rect.bottom);
      }
    }
    if (!_isOutOfBoundInTop) {
      //bottom arrow
      path.lineTo(centerX.toDouble(), locationY);
      path.lineTo(
          isVTypeArrow
              ? (centerX + arrowWidth / 2)
              : side == 'left'
                  ? (rect.left + rect.blRadiusX + arrowWidth * 2)
                  : (rect.right - rect.brRadiusX),
          rect.bottom);
    }
    path.lineTo(rect.right - rect.brRadiusX, rect.bottom);
    path.arcToPoint(Offset(rect.right, rect.bottom - rect.brRadiusY),
        radius: rect.brRadius, clockwise: false);
    path.lineTo(rect.right, rect.top + rect.trRadiusY);
    path.arcToPoint(Offset(rect.right - rect.brRadiusX, rect.top),
        radius: rect.trRadius, clockwise: false);
    if (isVTypeArrow) {
      path.lineTo(centerX + arrowWidth / 2, rect.top);
    } else {
      if (side == 'left') {
        path.lineTo(rect.left + rect.tlRadiusX + arrowWidth * 2, rect.top);
      }
    }
    if (_isOutOfBoundInTop) {
      //top arrow
      path.lineTo(centerX.toDouble(), locationY);
      path.lineTo(
          isVTypeArrow
              ? (centerX - arrowWidth / 2)
              : side == 'left'
                  ? (rect.left + rect.blRadiusX)
                  : (rect.right - rect.brRadiusX - arrowWidth * 2),
          rect.top);
    }
    path.lineTo(rect.left + rect.tlRadiusX, rect.top);

    canvas.drawPath(path, fillPaint);
    canvas.drawPath(path, strokePaint);
  }

  /// To get the location of chart tooltip
  void calculateLocation(Offset? position) {
    _x = position?.dx;
    _y = position?.dy;
  }

  /// Renders the default tooltip view with a tooltip rect, arrow, header and
  /// content
  void _renderDefaultTooltipView(Canvas canvas) {
    _isLeft = false;
    _isRight = false;
    double height = 0, width = 0, headerTextWidth = 0, headerTextHeight = 0;
    _markerSize = 0;
    _totalWidth = _boundaryRect.left + _boundaryRect.width;
    //ignore: prefer_final_locals
    TextStyle style = _tooltip.textStyle;
    final TextStyle textStyle =
        style.copyWith(color: style.color ?? _tooltip.labelColor);
    width = measureText(_stringValue!, textStyle).width;
    height = measureText(_stringValue!, textStyle).height;
    if (_header!.isNotEmpty) {
      final TextStyle headerTextStyle = style.copyWith(
          color: style.color ?? _tooltip.labelColor,
          fontWeight: FontWeight.bold);
      headerTextWidth = measureText(_header!, headerTextStyle).width;
      headerTextHeight = measureText(_header!, headerTextStyle).height + 10;
      width = width > headerTextWidth ? width : headerTextWidth;
    }

    if (width < 10) {
      width = 10; // minimum width for tooltip to render
      _borderRadius = _borderRadius > 5 ? 5 : _borderRadius;
    }
    if (_borderRadius > 15) {
      _borderRadius = 15;
    }
    if (_x != null &&
        _y != null &&
        (_inversePadding != null || _normalPadding != null) &&
        (_stringValue != '' || _header != '')) {
      final Rect backRect =
          _calculateBackgroundRect(canvas, height, width, headerTextHeight);
      final double startArrow = _pointerLength / 2;
      final double endArrow = _pointerLength / 2;
      final double xPosition = _nosePointX;
      final double yPosition = _nosePointY;
      _drawTooltipBackground(
          canvas,
          _isTop,
          backRect,
          xPosition,
          yPosition,
          xPosition - startArrow,
          _isTop ? (yPosition - startArrow) : (yPosition + startArrow),
          xPosition + endArrow,
          _isTop ? (yPosition - endArrow) : (yPosition + endArrow),
          _borderRadius,
          _arrowPath,
          _isLeft,
          _isRight,
          _tooltipAnimation);
    }
  }

  /// calculate tooltip rect and arrow head for default tooltip mode
  Rect _calculateBackgroundRect(
      Canvas canvas, double height, double width, double headerTextHeight) {
    double widthPadding = 15;
    if (_tooltip.canShowMarker && _tooltipState.needMarker) {
      _markerSize = 5;
      widthPadding = 17;
    }

    final Rect rect = Rect.fromLTWH(
        _x!,
        _y!,
        width + (2 * _markerSize) + widthPadding,
        height + headerTextHeight + 10);
    final Rect newRect = Rect.fromLTWH(_boundaryRect.left + 20,
        _boundaryRect.top, _boundaryRect.width - 40, _boundaryRect.height);
    final Rect leftRect = Rect.fromLTWH(
        _boundaryRect.left - 5,
        _boundaryRect.top - 20,
        newRect.left - (_boundaryRect.left - 5),
        _boundaryRect.height + 40);
    final Rect rightRect = Rect.fromLTWH(newRect.right, _boundaryRect.top - 20,
        (_boundaryRect.right + 5) + newRect.right, _boundaryRect.height + 40);

    if (leftRect.contains(Offset(_x!, _y!))) {
      _isLeft = true;
      _isRight = false;
    } else if (rightRect.contains(Offset(_x!, _y!))) {
      _isLeft = false;
      _isRight = true;
    }

    if (_y! > _pointerLength + rect.height && _y! > _boundaryRect.top) {
      _isTop = true;
      _xPos = _x! - (rect.width / 2);
      _yPos = (_y! - rect.height) - (_normalPadding ?? 0);
      _nosePointY = rect.top - (_normalPadding ?? 0);
      _nosePointX = rect.left;
      final double tooltipRightEnd = _x! + (rect.width / 2);
      _xPos = _xPos! < _boundaryRect.left
          ? _boundaryRect.left
          : tooltipRightEnd > _totalWidth
              ? _totalWidth - rect.width
              : _xPos;
      _yPos = _yPos! - (_pointerLength / 2);
    } else {
      _isTop = false;
      _xPos = _x! - (rect.width / 2);
      _yPos = ((_y! >= _boundaryRect.top ? _y! : _boundaryRect.top) +
              _pointerLength / 2) +
          (_inversePadding ?? 0);
      _nosePointX = rect.left;
      _nosePointY = (_y! >= _boundaryRect.top ? _y! : _boundaryRect.top) +
          (_inversePadding ?? 0);
      final double tooltipRightEnd = _x! + (rect.width / 2);
      _xPos = _xPos! < _boundaryRect.left
          ? _boundaryRect.left
          : tooltipRightEnd > _totalWidth
              ? _totalWidth - rect.width
              : _xPos;
    }
    if (_xPos! <= _boundaryRect.left + 5) {
      _xPos = _xPos! + 5;
    } else if (_xPos! + rect.width >= _totalWidth - 5) {
      _xPos = _xPos! - 5;
    }
    return Rect.fromLTWH(_xPos!, _yPos!, rect.width, rect.height);
  }

  /// This method renders the tooltip background on which the content is to be
  /// displayed
  void _drawTooltipBackground(
      Canvas canvas,
      bool isTop,
      Rect rectF,
      double xPosition,
      double yPosition,
      double startX,
      double startY,
      double endX,
      double endY,
      double borderRadius,
      Path backgroundPath,
      bool isLeft,
      bool isRight,
      Animation<double>? tooltipAnimation) {
    final double animationFactor =
        tooltipAnimation == null ? 1 : tooltipAnimation.value;
    backgroundPath.reset();
    if (isLeft) {
      startX = rectF.left + (2 * borderRadius);
      endX = startX + _pointerLength;
    } else if (isRight) {
      startX = endX - _pointerLength;
      endX = rectF.right - (2 * borderRadius);
    }

    final Rect rect = Rect.fromLTWH(
        rectF.width / 2 + (rectF.left - rectF.width / 2 * animationFactor),
        rectF.height / 2 + (rectF.top - rectF.height / 2 * animationFactor),
        rectF.width * animationFactor,
        rectF.height * animationFactor);

    _tooltipRect = rect;

    final RRect tooltipRect = RRect.fromRectAndCorners(
      rect,
      bottomLeft: Radius.circular(borderRadius),
      bottomRight: Radius.circular(borderRadius),
      topLeft: Radius.circular(borderRadius),
      topRight: Radius.circular(borderRadius),
    );
    _drawTooltipPath(canvas, tooltipRect, rect, backgroundPath, isTop, isLeft,
        isRight, startX, endX, animationFactor, xPosition, yPosition);

    final TextStyle textStyle = _tooltip.textStyle.copyWith(
      color: _tooltip.textStyle.color?.withOpacity(_tooltip.opacity) ??
          _tooltip.labelColor,
      fontSize: (_tooltip.textStyle.fontSize ?? 12.0) * animationFactor,
    );
    final Size result = measureText(_stringValue!, textStyle);
    _drawTooltipText(canvas, tooltipRect, textStyle, result, animationFactor);

    if (_tooltip.canShowMarker &&
        _tooltipState.needMarker &&
        _markerTypes.isNotEmpty) {
      if (_markerTypes.length == 1) {
        final Offset markerPoint =
            _getMarkerPosition(result, markerSize, tooltipRect);
        _drawMarkers(markerPoint, canvas, animationFactor, 0);
      } else {
        double height = 0;
        Size textSize = Size.zero;
        final List<String> textValues = _stringValue!.split('\n');
        for (int i = 0; i < _markerTypes.length && i < textValues.length; i++) {
          String str = '';
          str += textValues[i];
          final Size result1 = measureText(str, textStyle);
          final Offset markerPoint = Offset(
              _tooltipState._isRtl
                  ? tooltipRect.right - tooltipRect.width / 2 + result.width / 2
                  : tooltipRect.left + tooltipRect.width / 2 - result.width / 2,
              (_markerPointY + height) - markerSize);
          textSize = result1;
          height += textSize.height;
          if (_markerTypes[i] != null) {
            _drawMarkers(markerPoint, canvas, animationFactor, i);
          }
        }
      }
    }
    _xPos = null;
    _yPos = null;
  }

  /// To get the marker offset.
  Offset _getMarkerPosition(
          Size textSize, double markerSize, RRect tooltipRect) =>
      Offset(
          _tooltipState._isRtl
              ? tooltipRect.right - tooltipRect.width / 2 + textSize.width / 2
              : tooltipRect.left + tooltipRect.width / 2 - textSize.width / 2,
          ((tooltipRect.top + tooltipRect.height) - textSize.height / 2) -
              markerSize);

  /// This method renders the tooltip marker shapes at the specific line indices
  ///  of the marker paint list
  void _drawMarkers(
      Offset markerPoint, Canvas canvas, double animationFactor, int i) {
    if (_markerImages[i] == null) {
      final Path markerPath = _getMarkerShapesPath(
        _markerTypes[i]!,
        markerPoint,
        _markerImages[i],
        Size((2 * _markerSize) * animationFactor,
            (2 * _markerSize) * animationFactor),
      );
      if (_markerGradients![i] != null) {
        _markerPaints[i] = Paint()
          ..shader = _markerGradients![i]!.createShader(
            _getMarkerShapesPath(
                    _markerTypes[i]!,
                    Offset(markerPoint.dx, markerPoint.dy),
                    _markerImages[i],
                    Size((2 * _markerSize) * animationFactor,
                        (2 * _markerSize) * animationFactor))
                .getBounds(),
          )
          ..style = PaintingStyle.fill;
      }
      canvas.drawPath(markerPath, _markerPaints[i]!);
      // ignore: omit_local_variable_types
      final Paint markerBorderPaint = Paint();
      markerBorderPaint.color = Colors.white.withOpacity(_tooltip.opacity);
      markerBorderPaint.strokeWidth = 1;
      markerBorderPaint.style = PaintingStyle.stroke;
      canvas.drawPath(markerPath, markerBorderPaint);
    } else {
      _markerSize *= 2 * animationFactor;
      // ignore: omit_local_variable_types
      final Rect positionRect = Rect.fromLTWH(markerPoint.dx - _markerSize / 2,
          markerPoint.dy - _markerSize / 2, _markerSize, _markerSize);
      paintImage(
          canvas: canvas,
          image: _markerImages[i],
          rect: positionRect,
          fit: BoxFit.fill);
    }
  }

  /// This method renders the tooltip rect and arrow for default tooltip mode
  void _drawTooltipPath(
      Canvas canvas,
      RRect tooltipRect,
      Rect rect,
      Path backgroundPath,
      bool isTop,
      bool isLeft,
      bool isRight,
      double startX,
      double endX,
      double animationFactor,
      double xPosition,
      double yPosition) {
    double factor = 0;
    assert(_tooltip.elevation >= 0,
        'The elevation of the tooltip for all series must not be less than 0.');
    if (isRight) {
      factor = isTop ? rect.bottom : rect.top;
      backgroundPath.moveTo(rect.right - 20, factor);
      backgroundPath.lineTo(xPosition, yPosition);
      backgroundPath.lineTo(rect.right,
          isTop ? (factor - _borderRadius) : (factor + _borderRadius));
      backgroundPath.arcToPoint(Offset(rect.right - _borderRadius, factor),
          radius: Radius.circular(_borderRadius), clockwise: isTop);
      backgroundPath.lineTo(rect.right - 20, factor);
    } else if (isLeft) {
      factor = isTop ? rect.bottom : rect.top;
      backgroundPath.moveTo(rect.left + 20, factor);
      backgroundPath.lineTo(xPosition, yPosition);
      backgroundPath.lineTo(rect.left,
          isTop ? (factor - _borderRadius) : (factor + _borderRadius));
      backgroundPath.arcToPoint(Offset(rect.left + _borderRadius, factor),
          radius: Radius.circular(_borderRadius), clockwise: !isTop);
      backgroundPath.lineTo(rect.left + 20, factor);
    } else {
      factor = isTop ? tooltipRect.bottom : tooltipRect.top;
      backgroundPath.moveTo(startX - ((endX - startX) / 4), factor);
      backgroundPath.lineTo(xPosition, yPosition);
      backgroundPath.lineTo(endX + ((endX - startX) / 4), factor);
      backgroundPath.lineTo(startX + ((endX - startX) / 4), factor);
    }
    final Paint fillPaint = Paint()
      ..color = (_tooltip.color).withOpacity(_tooltip.opacity)
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.fill;

    final Paint strokePaint = Paint()
      ..color = _tooltip.borderColor == Colors.transparent
          ? Colors.transparent
          : _tooltip.borderColor.withOpacity(_tooltip.opacity)
      ..strokeCap = StrokeCap.butt
      ..style = PaintingStyle.stroke
      ..strokeWidth = _tooltip.borderWidth;
    _tooltip.borderWidth == 0
        ? strokePaint.color = Colors.transparent
        : strokePaint.color = strokePaint.color;

    final Path tooltipPath = Path();
    tooltipPath.addRRect(tooltipRect);
    if (_tooltip.elevation > 0) {
      if (tooltipRect.width * animationFactor > tooltipRect.width * 0.85) {
        canvas.drawShadow(_arrowPath, _tooltip.shadowColor ?? fillPaint.color,
            _tooltip.elevation, true);
      }
      canvas.drawShadow(tooltipPath, _tooltip.shadowColor ?? fillPaint.color,
          _tooltip.elevation, true);
    }

    if (tooltipRect.width * animationFactor > tooltipRect.width * 0.85) {
      canvas.drawPath(_arrowPath, fillPaint);
      canvas.drawPath(_arrowPath, strokePaint);
    }
    canvas.drawPath(tooltipPath, fillPaint);
    canvas.drawPath(tooltipPath, strokePaint);
  }

  /// This method renders the tooltip header text, content text and the divider
  /// line for default tooltip mode
  void _drawTooltipText(Canvas canvas, RRect tooltipRect, TextStyle textStyle,
      Size result, double animationFactor) {
    const double padding = 10;
    final int maxLinesOfTooltipContent = getMaxLinesContent(_stringValue);
    if (_header!.isNotEmpty) {
      final TextStyle headerTextStyle = _tooltip.textStyle.copyWith(
        color: textStyle.color?.withOpacity(_tooltip.opacity) ??
            _tooltip.labelColor,
        fontSize: (textStyle.fontSize ?? 12) * animationFactor,
        fontWeight: FontWeight.bold,
      );
      final Size headerResult = measureText(_header!, headerTextStyle);
      _markerPointY = tooltipRect.top +
          ((_header!.isNotEmpty)
              ? headerResult.height + (padding * 2) + 6
              : (padding * 1.7));
      final int maxLinesOfHeader = getMaxLinesContent(_header);
      _drawText(
          _tooltip,
          canvas,
          _header!,
          Offset(
              (tooltipRect.left + tooltipRect.width / 2) -
                  headerResult.width / 2,
              tooltipRect.top + padding / 2),
          headerTextStyle,
          maxLines: maxLinesOfHeader);

      final Paint dividerPaint = Paint();
      dividerPaint.color = _tooltip.labelColor.withOpacity(_tooltip.opacity);
      dividerPaint.strokeWidth = 0.5 * animationFactor;
      dividerPaint.style = PaintingStyle.stroke;
      num lineOffset = 0;
      if (_tooltip.format != null && _tooltip.format!.isNotEmpty) {
        if (_tooltip.textAlignment == TooltipAlignment.near) {
          lineOffset = padding;
        } else if (_tooltip.textAlignment == TooltipAlignment.far) {
          lineOffset = -padding;
        }
      }
      if (animationFactor > 0.5) {
        canvas.drawLine(
            Offset(tooltipRect.left + padding - lineOffset,
                tooltipRect.top + headerResult.height + padding),
            Offset(tooltipRect.right - padding - lineOffset,
                tooltipRect.top + headerResult.height + padding),
            dividerPaint);
      }
    }
    _renderTooltipText(
        canvas, tooltipRect, result, textStyle, maxLinesOfTooltipContent);
  }

  void _renderTooltipText(Canvas canvas, RRect tooltipRect, Size textSize,
      TextStyle textStyle, int maxLines) {
    if (_tooltipState._isRtl && _stringValue!.contains('\n')) {
      _drawMultiLineRtlText(_tooltip, canvas, _stringValue!,
          _getTextPosition(textSize, tooltipRect, maxLines), textStyle,
          markerSize: markerSize,
          tooltipRect: tooltipRect,
          totalTextSize: textSize);
    } else {
      _drawText(
        _tooltip,
        canvas,
        _stringValue!,
        _getTextPosition(textSize, tooltipRect, maxLines),
        textStyle,
        maxLines: maxLines,
      );
    }
  }

  Offset _getTextPosition(Size textSize, RRect tooltipRect, int maxLines) {
    double textOffsetX = 0.0;
    if (_tooltipState._isRtl) {
      if (maxLines > 1 && !(markerSize > 0)) {
        textOffsetX =
            tooltipRect.left + tooltipRect.width / 2 - textSize.width / 2;
      } else {
        textOffsetX = tooltipRect.right -
            tooltipRect.width / 2 -
            textSize.width / 2 -
            2 * markerSize;
      }
    } else {
      textOffsetX =
          (tooltipRect.left + 2 * markerSize + tooltipRect.width / 2) -
              textSize.width / 2;
    }
    return Offset(
        textOffsetX,
        _header!.isNotEmpty
            ? (tooltipRect.top + tooltipRect.height) - textSize.height - 5
            : (tooltipRect.top + tooltipRect.height / 2) - textSize.height / 2);
  }

  void _drawMultiLineRtlText(SfTooltip tooltip, Canvas canvas, String text,
      Offset point, TextStyle style,
      {double? markerSize, RRect? tooltipRect, Size? totalTextSize}) {
    final List<String> textCollections = text.split('\n');
    final double rectEndPointBeforeMarker = _getMarkerPosition(
                totalTextSize ?? Size.zero,
                markerSize ?? 0.0,
                tooltipRect ?? RRect.zero)
            .dx -
        (2 * (markerSize ?? 0.0));
    for (int count = 0; count < textCollections.length; count++) {
      final Size currentTextSize = measureText(textCollections[count], style);
      _drawText(
          tooltip,
          canvas,
          textCollections[count],
          Offset(rectEndPointBeforeMarker - currentTextSize.width,
              point.dy + (currentTextSize.height * count)),
          style);
    }
  }

  /// This method paints the given text at the required offset for default
  /// tooltip mode
  void _drawText(
    SfTooltip tooltip,
    Canvas canvas,
    String text,
    Offset point,
    TextStyle style, {
    int? maxLines,
    int? rotation,
  }) {
    TextAlign tooltipTextAlign = TextAlign.start;
    double pointX = point.dx;
    // ignore: unnecessary_null_comparison
    if (tooltip != null &&
        tooltip.format != null &&
        tooltip.format!.isNotEmpty) {
      if (tooltip.textAlignment == 'near') {
        tooltipTextAlign = TextAlign.start;
        pointX = _tooltipRect!.left;
      } else if (tooltip.textAlignment == 'far') {
        tooltipTextAlign = TextAlign.end;
        pointX = _tooltipRect!.right - measureText(text, style).width;
      }
    }
    if (kIsWeb) {
      if (_animationFactor < 0.5) {
        style =
            style.copyWith(color: style.color!.withOpacity(_animationFactor));
      } else if (_animationFactor <= 1) {
        style =
            style.copyWith(color: style.color!.withOpacity(tooltip.opacity));
      }
    }
    final TextSpan span = TextSpan(text: text, style: style);
    final TextPainter tp = TextPainter(
        text: span,
        textDirection: TextDirection.ltr,
        textAlign: tooltipTextAlign,
        maxLines: maxLines ?? 1);
    tp.layout();
    canvas.save();
    canvas.translate(pointX, point.dy);
    if (rotation != null && rotation > 0) {
      canvas.rotate(degreeToRadian(rotation));
    }
    tp.paint(canvas, Offset.zero);
    canvas.restore();
  }

  /// This method returns the offset values of tooltip location in the template
  /// mode
  Offset _getTemplateLocation(Rect tooltipRect, Rect bounds, Offset offset) {
    double left = tooltipRect.left, top = tooltipRect.top;
    const int padding = 5;
    if (tooltipRect.left < bounds.left + offset.dx) {
      left = bounds.left + offset.dx + padding;
    }
    if (tooltipRect.top < bounds.top + offset.dy) {
      top = bounds.top + offset.dy;
      _isOutOfBoundInTop = true;
    }
    if (tooltipRect.left + tooltipRect.width >
        bounds.left + offset.dx + bounds.width) {
      left = (bounds.left + bounds.width + offset.dx) -
          tooltipRect.width -
          padding;
    }
    if (tooltipRect.top + tooltipRect.height >
        bounds.top + offset.dy + bounds.height) {
      top = (bounds.top + offset.dy + bounds.height) - tooltipRect.height;
    }
    return Offset(left, top);
  }
}

/// This method returns the path of marker shapes at the position at which the
/// marker needs to be rendered
Path _getMarkerShapesPath(
    DataMarkerType markerType, Offset position, dynamic image, Size size) {
  final Path path = Path();
  switch (markerType) {
    case DataMarkerType.circle:
      {
        drawCircle(path, position.dx, position.dy, size.width, size.height);
      }
      break;
    case DataMarkerType.rectangle:
      {
        drawRectangle(path, position.dx, position.dy, size.width, size.height);
      }
      break;
    case DataMarkerType.image:
      {}
      break;
    case DataMarkerType.pentagon:
      {
        drawPentagon(path, position.dx, position.dy, size.width, size.height);
      }
      break;
    case DataMarkerType.verticalLine:
      {
        drawVerticalLine(
            path, position.dx, position.dy, size.width, size.height);
      }
      break;
    case DataMarkerType.invertedTriangle:
      {
        drawInvertedTriangle(
            path, position.dx, position.dy, size.width, size.height);
      }
      break;
    case DataMarkerType.horizontalLine:
      {
        drawHorizontalLine(
            path, position.dx, position.dy, size.width, size.height);
      }
      break;
    case DataMarkerType.diamond:
      {
        drawDiamond(path, position.dx, position.dy, size.width, size.height);
      }
      break;
    case DataMarkerType.triangle:
      {
        drawTriangle(path, position.dx, position.dy, size.width, size.height);
      }
      break;
    case DataMarkerType.none:
      break;
  }
  return path;
}
