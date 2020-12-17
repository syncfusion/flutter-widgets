part of gauges;

/// Create radial gauge widget to displays numerical values on a circular scale.
/// It has a rich set of features
/// such as axes, ranges, pointers, and annotations that are fully
/// customizable and extendable.
/// Use it to create speedometers, temperature monitors, dashboards,
/// meter gauges, multiaxis clocks, watches, activity gauges, compasses,
/// and more.
///
/// The radial gauge widget allows to customize its appearance
/// using [SfGaugeThemeData] available from [SfGaugeTheme] widget or
/// the [SfTheme] with the help of [SfThemeData].
///
/// ```dart
/// Widget build(BuildContext context) {
///    return Container(
///        child: SfRadialGauge());
///}
/// ```
/// See also:
///
/// * [SfTheme] and [SfThemeData], for customizing the visual appearance
/// of the radial gauge.
/// * [SfGaugeTheme] and [SfGaugeThemeData], for customizing the visual
/// appearance of the radial gauge.
class SfRadialGauge extends StatefulWidget {
  /// Creates a radial gauge with default or required axis.
  ///
  /// To enable the loading animation set [enableLoadingAnimation] is true.
  // ignore: prefer_const_constructors_in_immutables
  SfRadialGauge(
      {Key key,
      List<RadialAxis> axes,
      this.enableLoadingAnimation = false,
      this.animationDuration = 2000,
      this.backgroundColor = Colors.transparent,
      this.title})
      : axes = axes ?? <RadialAxis>[RadialAxis()],
        super(key: key);

  /// Add a list of radial axis to the gauge and customize each axis by
  /// adding it to the [axes] collection.
  ///
  /// Also refer [RadialAxis]
  /// ```dart
  /// Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfRadialGauge(
  ///          axes:<RadialAxis>[RadialAxis(
  ///            )]
  ///        ));
  ///}
  /// ```
  final List<RadialAxis> axes;

  /// Add the title to the top of the radial gauge.
  ///
  /// The [title] is a type of [GaugeTitle].
  ///
  /// To specify title description to [GaugeTitle.text] property and
  /// title style to [GaugeTitle.textStyle] property.
  ///
  /// Defaults to `null`..
  ///
  /// Also refer [GaugeTitle].
  ///
  ///
  /// ```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfRadialGauge(
  ///            title: GaugeTitle(
  ///                    text: 'Gauge Title',
  ///                    textStyle: TextStyle(
  ///                                 color: Colors.red,
  ///                                 fontSize: 12,
  ///                                 fontStyle: FontStyle.normal,
  ///                                 fontWeight: FontWeight.w400,
  ///                                 fontFamily: 'Roboto'
  ///                               ))
  ///        ));
  ///}
  /// ```
  final GaugeTitle title;

  /// Specifies the load time animation for axis elements, range and
  /// pointers with [animationDuration].
  ///
  /// Defaults to false
  ///
  /// ```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfRadialGauge(enableLoadingAnimation: true
  ///        ));
  ///}
  /// ```
  final bool enableLoadingAnimation;

  /// Specifies the load time animation duration.
  ///
  /// Duration is defined in milliseconds.
  ///
  /// Defaults to 2000
  /// ```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfRadialGauge(animationDuration: 4000
  ///        ));
  ///}
  /// ```
  final double animationDuration;

  /// The background color of the [SfRadialGauge].
  ///
  /// The [backgroundColor] applied for the [SfRadialGauge] boundary.
  ///
  /// This property is a type of [Color].
  ///
  /// Defaults to Colors.transparent.
  ///
  ///```dart
  /// Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfRadialGauge(
  ///           backgroundColor: Colors.yellow
  ///          axes:<RadialAxis>[RadialAxis(
  ///            )]
  ///        ));
  ///}
  ///```
  final Color backgroundColor;

  @override
  State<StatefulWidget> createState() {
    return SfRadialGaugeState();
  }
}

/// Represents the radial gauge state
class SfRadialGaugeState extends State<SfRadialGauge>
    with SingleTickerProviderStateMixin {
  /// Represents the gauge theme
  SfGaugeThemeData _gaugeTheme;

  /// Hold the radial gauge rendering details
  _RenderingDetails _renderingDetails;

  @override
  void initState() {
    _renderingDetails = _RenderingDetails();
    _renderingDetails.axisRenderers = <RadialAxisRenderer>[];
    _renderingDetails.gaugePointerRenderers =
        <int, List<_GaugePointerRenderer>>{};
    _renderingDetails.gaugeRangeRenderers = <int, List<_GaugeRangeRenderer>>{};
    _renderingDetails.pointerRepaintNotifier = ValueNotifier<int>(0);
    _renderingDetails.rangeRepaintNotifier = ValueNotifier<int>(0);
    _renderingDetails.axisRepaintNotifier = ValueNotifier<int>(0);
    _renderingDetails.animationController = AnimationController(vsync: this)
      ..addListener(_repaintGaugeElements);
    _renderingDetails.needsToAnimateAxes =
        widget.enableLoadingAnimation && widget.animationDuration > 0;
    _renderingDetails.needsToAnimateRanges =
        widget.enableLoadingAnimation && widget.animationDuration > 0;
    _renderingDetails.needsToAnimatePointers =
        widget.enableLoadingAnimation && widget.animationDuration > 0;
    _renderingDetails.needsToAnimateAnnotation =
        widget.enableLoadingAnimation && widget.animationDuration > 0;
    _createRenderer();
    super.initState();
  }

  @override
  void didUpdateWidget(SfRadialGauge oldWidget) {
    if (widget.axes != null && widget.axes.isNotEmpty) {
      _renderingDetails.needsToAnimateAnnotation = false;
      _renderingDetails.needsToAnimatePointers = false;
      _renderingDetails.needsToAnimateRanges = false;
      _renderingDetails.needsToAnimateAxes = false;

      _needsRepaintGauge(oldWidget, widget, _renderingDetails);
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void didChangeDependencies() {
    _gaugeTheme = SfGaugeTheme.of(context);
    super.didChangeDependencies();
  }

  /// Method is used to create renderers for gauge features
  void _createRenderer() {
    if (widget.axes != null && widget.axes.isNotEmpty) {
      for (int i = 0; i < widget.axes.length; i++) {
        final RadialAxis axis = widget.axes[i];
        final RadialAxisRenderer axisRenderer = _createAxisRenderer(axis);
        _renderingDetails.axisRenderers.add(axisRenderer);
        if (axis.ranges != null && axis.ranges.isNotEmpty) {
          _createRangesRenderer(i, axisRenderer);
        }

        if (axis.pointers != null && axis.pointers.isNotEmpty) {
          _createPointersRenderers(i, axisRenderer);
        }
      }
    }
  }

  /// Method is used to create gauge range renderer
  void _createRangesRenderer(int axisIndex, RadialAxisRenderer axisRenderer) {
    final List<_GaugeRangeRenderer> rangeRenderers = <_GaugeRangeRenderer>[];
    final RadialAxis axis = widget.axes[axisIndex];
    for (int j = 0; j < axis.ranges.length; j++) {
      final GaugeRange range = axis.ranges[j];
      final _GaugeRangeRenderer renderer = _createRangeRenderer(range);
      renderer._axisRenderer = axisRenderer;
      rangeRenderers.add(renderer);
    }

    _renderingDetails.gaugeRangeRenderers[axisIndex] = rangeRenderers;
  }

  /// Method is used to create gauge pointer renderer
  void _createPointersRenderers(
      int axisIndex, RadialAxisRenderer axisRenderer) {
    final List<_GaugePointerRenderer> pointerRenderers =
        <_GaugePointerRenderer>[];
    final RadialAxis axis = widget.axes[axisIndex];
    for (int j = 0; j < axis.pointers.length; j++) {
      final GaugePointer pointer = axis.pointers[j];
      final _GaugePointerRenderer renderer = _createPointerRenderer(pointer);
      renderer._axisRenderer = axisRenderer;
      renderer._needsAnimate = true;
      renderer._animationStartValue =
          axis.isInversed && !(pointer is RangePointer) ? 1 : 0;
      pointerRenderers.add(renderer);
    }

    _renderingDetails.gaugePointerRenderers[axisIndex] = pointerRenderers;
  }

  /// Method to repaint the gauge elements
  void _repaintGaugeElements() {
    if (_renderingDetails.needsToAnimateAxes) {
      _renderingDetails.axisRepaintNotifier.value++;
    }
    if (_renderingDetails.needsToAnimateRanges) {
      _renderingDetails.rangeRepaintNotifier.value++;
    }
    _renderingDetails.pointerRepaintNotifier.value++;
  }

  /// Method to check whether the gauge needs to be repainted
  void _needsRepaintGauge(SfRadialGauge oldGauge, SfRadialGauge newGauge,
      _RenderingDetails _renderingDetails) {
    final List<RadialAxisRenderer> oldAxisRenderers =
        _renderingDetails.axisRenderers;
    final Map<int, List<_GaugeRangeRenderer>> oldRangeRenderers =
        _renderingDetails.gaugeRangeRenderers;
    final Map<int, List<_GaugePointerRenderer>> oldPointerRenderers =
        _renderingDetails.gaugePointerRenderers;
    _renderingDetails.axisRenderers = <RadialAxisRenderer>[];
    _renderingDetails.gaugeRangeRenderers = <int, List<_GaugeRangeRenderer>>{};
    _renderingDetails.gaugePointerRenderers =
        <int, List<_GaugePointerRenderer>>{};
    if (newGauge.axes != null) {
      for (int i = 0; i < newGauge.axes.length; i++) {
        final RadialAxis newAxis = newGauge.axes[i];
        int index;
        RadialAxisRenderer axisRenderer;
        if (oldGauge.axes != null) {
          index = i < oldGauge.axes.length && newAxis == oldGauge.axes[i]
              ? i
              : _getExistingAxisIndex(newAxis, oldGauge);
        }

        if (index != null &&
            index < oldGauge.axes.length &&
            oldAxisRenderers[index] != null) {
          axisRenderer = oldAxisRenderers[index];
          axisRenderer.axis = newAxis;
          _needsRepaintAxis(oldGauge.axes[i], newGauge.axes[i], axisRenderer,
              index, oldRangeRenderers, oldPointerRenderers);
        } else if (oldGauge.axes.length == newGauge.axes.length) {
          axisRenderer = oldAxisRenderers[i];
          axisRenderer.axis = newAxis;
          final RadialAxis oldAxis = oldGauge.axes[i];
          _needsRepaintExistingAxis(oldAxis, newAxis, axisRenderer, i,
              _renderingDetails, oldPointerRenderers, oldRangeRenderers);
        } else {
          axisRenderer = _createAxisRenderer(newAxis);
          axisRenderer._needsRepaintAxis = true;

          if (newAxis.ranges != null && newAxis.ranges.isNotEmpty) {
            _createRangesRenderer(i, axisRenderer);
          }

          if (newAxis.pointers != null && newAxis.pointers.isNotEmpty) {
            _createPointersRenderers(i, axisRenderer);
          }
        }
        axisRenderer._axis = newAxis;
        _renderingDetails.axisRenderers.add(axisRenderer);
      }
    }
  }

  /// Checks whether to repaint the existing axes
  void _needsRepaintExistingAxis(
      RadialAxis oldAxis,
      RadialAxis newAxis,
      RadialAxisRenderer axisRenderer,
      int axisIndex,
      _RenderingDetails _renderingDetails,
      Map<int, List<_GaugePointerRenderer>> oldPointerRenderers,
      Map<int, List<_GaugeRangeRenderer>> oldRangeRenderers) {
    if (newAxis != oldAxis) {
      axisRenderer._needsRepaintAxis = true;
    } else {
      axisRenderer._needsRepaintAxis = false;
    }
    if (oldAxis.pointers != null &&
        newAxis.pointers != null &&
        oldAxis.pointers.isNotEmpty &&
        newAxis.pointers.isNotEmpty &&
        oldAxis.pointers.length == newAxis.pointers.length) {
      final List<_GaugePointerRenderer> pointerRenderers =
          oldPointerRenderers[axisIndex];
      final List<_GaugePointerRenderer> newPointerRenderers =
          <_GaugePointerRenderer>[];
      for (int j = 0; j < newAxis.pointers.length; j++) {
        _needsAnimatePointers(
            oldAxis.pointers[j], newAxis.pointers[j], pointerRenderers[j]);
        _needsResetPointerValue(
            oldAxis.pointers[j], newAxis.pointers[j], pointerRenderers[j]);
        if (newAxis.pointers[j] != oldAxis.pointers[j]) {
          pointerRenderers[j]._needsRepaintPointer = true;
        } else {
          if (axisRenderer._needsRepaintAxis) {
            pointerRenderers[j]._needsRepaintPointer = true;
          } else {
            pointerRenderers[j]._needsRepaintPointer = false;
          }
        }

        if (pointerRenderers[j] is MarkerPointerRenderer) {
          final MarkerPointerRenderer markerRenderer = pointerRenderers[j];
          final MarkerPointer marker = newAxis.pointers[j];
          markerRenderer.pointer = marker;
        } else if (pointerRenderers[j] is NeedlePointerRenderer) {
          final NeedlePointerRenderer needleRenderer = pointerRenderers[j];
          final NeedlePointer needle = newAxis.pointers[j];
          needleRenderer.pointer = needle;
        }

        pointerRenderers[j]._gaugePointer = newAxis.pointers[j];
        newPointerRenderers.add(pointerRenderers[j]);
      }

      _renderingDetails.gaugePointerRenderers[axisIndex] = newPointerRenderers;
    } else {
      if (newAxis.pointers != null && newAxis.pointers.isNotEmpty) {
        _needsRepaintPointers(
            oldAxis, newAxis, axisRenderer, axisIndex, oldPointerRenderers);
      }
    }

    if (oldAxis.ranges != null &&
        newAxis.ranges != null &&
        oldAxis.ranges.isNotEmpty &&
        newAxis.ranges.isNotEmpty &&
        oldAxis.ranges.length == newAxis.ranges.length) {
      final List<_GaugeRangeRenderer> rangeRenderers =
          oldRangeRenderers[axisIndex];
      final List<_GaugeRangeRenderer> newRangeRenderers =
          <_GaugeRangeRenderer>[];
      for (int j = 0; j < newAxis.ranges.length; j++) {
        if (newAxis.ranges[j] != oldAxis.ranges[j]) {
          rangeRenderers[j]._needsRepaintRange = true;
        } else {
          if (axisRenderer._needsRepaintAxis) {
            rangeRenderers[j]._needsRepaintRange = true;
          } else {
            rangeRenderers[j]._needsRepaintRange = false;
          }
        }

        rangeRenderers[j]._range = newAxis.ranges[j];
        newRangeRenderers.add(rangeRenderers[j]);
      }
      _renderingDetails.gaugeRangeRenderers[axisIndex] = newRangeRenderers;
    } else {
      if (newAxis.ranges != null && newAxis.ranges.isNotEmpty) {
        _needsRepaintRanges(
            oldAxis, newAxis, axisRenderer, axisIndex, oldRangeRenderers);
      }
    }
  }

  /// Check current axis index is exist in old gauge
  int _getExistingAxisIndex(RadialAxis currentAxis, SfRadialGauge oldGauge) {
    for (int index = 0; index < oldGauge.axes.length; index++) {
      final RadialAxis axis = oldGauge.axes[index];
      if (axis == currentAxis) {
        return index;
      }
    }
    return null;
  }

  /// Check current range index is exist in old axis
  int _getExistingRangeIndex(GaugeRange currentRange, RadialAxis oldAxis) {
    for (int index = 0; index < oldAxis.ranges.length; index++) {
      final GaugeRange range = oldAxis.ranges[index];
      if (range == currentRange) {
        return index;
      }
    }
    return null;
  }

  /// Check current range index is exist in old axis
  int _getExistingPointerIndex(
      GaugePointer currentPointer, RadialAxis oldAxis) {
    for (int index = 0; index < oldAxis.pointers.length; index++) {
      final GaugePointer pointer = oldAxis.pointers[index];
      if (pointer == currentPointer) {
        return index;
      }
    }
    return null;
  }

  /// Method to check whether the axis needs to be repainted
  void _needsRepaintAxis(
    RadialAxis oldAxis,
    RadialAxis newAxis,
    RadialAxisRenderer axisRenderer,
    int oldAxisIndex,
    Map<int, List<_GaugeRangeRenderer>> oldRangeRenderers,
    Map<int, List<_GaugePointerRenderer>> oldPointerRenderers,
  ) {
    if (oldAxis.backgroundImage == newAxis.backgroundImage &&
        axisRenderer._backgroundImageInfo?.image != null) {
      axisRenderer._backgroundImageInfo = axisRenderer._backgroundImageInfo;
    }
    axisRenderer._needsRepaintAxis = false;
    if (newAxis.pointers != null) {
      _needsRepaintPointers(
          oldAxis, newAxis, axisRenderer, oldAxisIndex, oldPointerRenderers);
    }
    if (newAxis.ranges != null) {
      _needsRepaintRanges(
          oldAxis, newAxis, axisRenderer, oldAxisIndex, oldRangeRenderers);
    }
  }

  /// Checks whether to repaint the axis ranges
  void _needsRepaintRanges(
      RadialAxis oldAxis,
      RadialAxis newAxis,
      RadialAxisRenderer axisRenderer,
      int oldAxisIndex,
      Map<int, List<_GaugeRangeRenderer>> oldRangeRenderers) {
    final List<_GaugeRangeRenderer> newRangeRenderers = <_GaugeRangeRenderer>[];
    final List<_GaugeRangeRenderer> renderers = oldRangeRenderers[oldAxisIndex];
    for (int i = 0; i < newAxis.ranges.length; i++) {
      final GaugeRange newRange = newAxis.ranges[i];
      int index;
      _GaugeRangeRenderer rangeRenderer;
      if (oldAxis.ranges != null) {
        index = i < oldAxis.ranges.length && newRange == oldAxis.ranges[i]
            ? i
            : _getExistingRangeIndex(newRange, oldAxis);
      }

      if (index != null &&
          index < oldAxis.ranges.length &&
          renderers[index] != null) {
        rangeRenderer = renderers[index];
        if (axisRenderer._needsRepaintAxis) {
          rangeRenderer._needsRepaintRange = true;
        } else {
          rangeRenderer._needsRepaintRange = false;
        }
      } else {
        rangeRenderer = _createRangeRenderer(newRange);
        rangeRenderer._needsRepaintRange = true;
      }

      rangeRenderer._range = newRange;
      rangeRenderer._axisRenderer = axisRenderer;
      newRangeRenderers.add(rangeRenderer);
    }

    _renderingDetails.gaugeRangeRenderers[oldAxisIndex] = newRangeRenderers;
  }

  /// Checks whether to animate the pointers
  void _needsAnimatePointers(GaugePointer oldPointer, GaugePointer newPointer,
      _GaugePointerRenderer pointerRenderer) {
    if (oldPointer.value != newPointer.value) {
      setState(() {
        // Sets the previous animation end value as current animation start
        // value of pointer
        pointerRenderer._needsAnimate = true;
        pointerRenderer._animationStartValue =
            pointerRenderer._animationEndValue;
      });
    } else if (oldPointer.animationType != newPointer.animationType) {
      pointerRenderer._needsAnimate = true;
    } else {
      setState(() {
        pointerRenderer._needsAnimate = false;
      });
    }
  }

  /// Check to reset the pointer current value
  void _needsResetPointerValue(GaugePointer oldPointer, GaugePointer newPointer,
      _GaugePointerRenderer pointerRenderer) {
    if (oldPointer.enableDragging == newPointer.enableDragging) {
      if (!(oldPointer.value == newPointer.value)) {
        pointerRenderer._currentValue = newPointer.value;
        pointerRenderer._isDragStarted = false;
      }
    }
  }

  /// Checks whether to repaint the axis pointers
  ///
  /// This method is quite a large method since it used a for loop.
  ///  It could be refactored to smaller  methods,
  ///  but it leads to performance degrade
  void _needsRepaintPointers(
      RadialAxis oldAxis,
      RadialAxis newAxis,
      RadialAxisRenderer axisRenderer,
      int oldAxisIndex,
      Map<int, List<_GaugePointerRenderer>> oldPointerRenderers) {
    final List<_GaugePointerRenderer> newPointerRenderers =
        <_GaugePointerRenderer>[];
    final List<_GaugePointerRenderer> renderers =
        oldPointerRenderers[oldAxisIndex];
    for (int i = 0; i < newAxis.pointers.length; i++) {
      final GaugePointer newPointer = newAxis.pointers[i];
      int index;
      _GaugePointerRenderer pointerRenderer;
      if (oldAxis.pointers != null) {
        index = i < oldAxis.pointers.length &&
                (newPointer == oldAxis.pointers[i] ||
                    newPointer.value != oldAxis.pointers[i].value ||
                    newPointer.animationType !=
                        oldAxis.pointers[i].animationType)
            ? i
            : _getExistingPointerIndex(newPointer, oldAxis);
      }

      if (index != null &&
          index < oldAxis.pointers.length &&
          renderers[index] != null) {
        pointerRenderer = renderers[index];
        if (axisRenderer._needsRepaintAxis) {
          pointerRenderer._needsRepaintPointer = true;
        } else {
          pointerRenderer._needsRepaintPointer = false;
        }
        if (oldAxis.pointers[index].value != newAxis.pointers[i].value) {
          // Sets the previous animation end value as current animation start
          // value of pointer
          pointerRenderer._needsAnimate = true;
          pointerRenderer._needsRepaintPointer = true;
          pointerRenderer._currentValue = newPointer.value;
          pointerRenderer._animationStartValue =
              pointerRenderer._animationEndValue;
        } else if (oldAxis.pointers[index].animationType !=
            newAxis.pointers[i].animationType) {
          pointerRenderer._needsAnimate = true;
          pointerRenderer._needsRepaintPointer = true;
        } else {
          pointerRenderer._needsAnimate = false;
        }

        if (oldAxis.pointers[index].enableDragging ==
            newAxis.pointers[i].enableDragging) {
          if (oldAxis.pointers[i].value == newAxis.pointers[i].value &&
              pointerRenderer._currentValue != renderers[index]._currentValue) {
            pointerRenderer._currentValue = renderers[index]._currentValue;
          }
          pointerRenderer._isDragStarted = renderers[index]._isDragStarted;
        }
      } else {
        pointerRenderer = _createPointerRenderer(newPointer);
        pointerRenderer._needsRepaintPointer = true;
        pointerRenderer._needsAnimate = false;
        if (oldAxis.pointers[i] != null &&
            oldAxis.pointers[i].enableDragging == newPointer.enableDragging &&
            oldPointerRenderers[i] != null &&
            oldAxis.pointers[i].value == newAxis.pointers[i].value) {
          pointerRenderer._currentValue = renderers[i]._currentValue;
          pointerRenderer._isDragStarted = renderers[i]._isDragStarted;
        }
      }

      if (pointerRenderer is MarkerPointerRenderer) {
        final MarkerPointerRenderer markerRenderer = pointerRenderer;
        final MarkerPointer marker = newPointer;
        markerRenderer.pointer = marker;
      } else if (pointerRenderer is NeedlePointerRenderer) {
        final NeedlePointerRenderer needleRenderer = pointerRenderer;
        final NeedlePointer needle = newPointer;
        needleRenderer.pointer = needle;
      }

      pointerRenderer._gaugePointer = newPointer;
      pointerRenderer._axisRenderer = axisRenderer;
      newPointerRenderers.add(pointerRenderer);
    }

    _renderingDetails.gaugePointerRenderers[oldAxisIndex] = newPointerRenderers;
  }

  /// Returns the gauge pointer renderer
  _GaugePointerRenderer _createPointerRenderer(GaugePointer pointer) {
    if (pointer is MarkerPointer) {
      return _createMarkerPointerRenderer(pointer);
    } else if (pointer is NeedlePointer) {
      return _createNeedlePointerRenderer(pointer);
    } else {
      return _createRangePointerRenderer(pointer);
    }
  }

  /// Create the needle pointer renderer.
  NeedlePointerRenderer _createNeedlePointerRenderer(GaugePointer pointer) {
    NeedlePointerRenderer pointerRenderer;
    final NeedlePointer needle = pointer;
    if (needle.onCreatePointerRenderer != null) {
      pointerRenderer = needle.onCreatePointerRenderer();
      pointerRenderer.pointer = needle;
      assert(
          pointerRenderer != null,
          'This onCreateRenderer callback function should return value as'
          'extends from GaugePointerRenderer class and should not be return'
          'value as null');
    } else {
      pointerRenderer = NeedlePointerRenderer();
    }
    pointerRenderer._gaugePointer = needle;
    pointerRenderer._currentValue = needle.value;
    return pointerRenderer;
  }

  /// Create the marker pointer renderer.
  MarkerPointerRenderer _createMarkerPointerRenderer(GaugePointer pointer) {
    final MarkerPointer marker = pointer;
    MarkerPointerRenderer pointerRenderer;
    if (marker.onCreatePointerRenderer != null) {
      pointerRenderer = marker.onCreatePointerRenderer();
      pointerRenderer.pointer = marker;
      assert(
          pointerRenderer != null,
          'This onCreatePointerRenderer callback function should return'
          'value as extends from GaugePointerRenderer class and should not'
          'be return value as null');
    } else {
      pointerRenderer = MarkerPointerRenderer();
    }
    pointerRenderer._gaugePointer = marker;
    pointerRenderer._currentValue = marker.value;
    return pointerRenderer;
  }

  /// Create the range pointer renderer.
  _RangePointerRenderer _createRangePointerRenderer(GaugePointer pointer) {
    final _RangePointerRenderer pointerRenderer = _RangePointerRenderer();
    pointerRenderer._gaugePointer = pointer;
    pointerRenderer._currentValue = pointer.value;
    return pointerRenderer;
  }

  /// Create the radial axis renderer.
  GaugeAxisRenderer _createAxisRenderer(RadialAxis axis) {
    RadialAxisRenderer axisRenderer;
    if (axis.onCreateAxisRenderer != null) {
      axisRenderer = axis.onCreateAxisRenderer();
      axisRenderer.axis = axis;
      assert(
          axisRenderer != null,
          'This onCreateAxisRenderer callback function should return value as'
          'extends from RadialAxisRenderer class and should not be return value'
          'as null');
    } else {
      axisRenderer = RadialAxisRenderer();
    }
    axisRenderer._axis = axis;
    return axisRenderer;
  }

  /// Methods to add the title of circular gauge
  Widget _addGaugeTitle() {
    if (widget.title != null && widget.title.text.isNotEmpty) {
      final Widget titleWidget = Container(
          child: Container(
              padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
              decoration: BoxDecoration(
                  color: widget.title.backgroundColor ??
                      _gaugeTheme.titleBackgroundColor,
                  border: Border.all(
                      color: widget.title.borderColor ??
                          _gaugeTheme.titleBorderColor,
                      width: widget.title.borderWidth)),
              child: Text(
                widget.title.text,
                style: widget.title.textStyle,
                textAlign: TextAlign.center,
                overflow: TextOverflow.clip,
              ),
              alignment: (widget.title.alignment == GaugeAlignment.near)
                  ? Alignment.topLeft
                  : (widget.title.alignment == GaugeAlignment.far)
                      ? Alignment.topRight
                      : (widget.title.alignment == GaugeAlignment.center)
                          ? Alignment.topCenter
                          : Alignment.topCenter));

      return titleWidget;
    } else {
      return Container();
    }
  }

  /// Returns the renderer for gauge range
  _GaugeRangeRenderer _createRangeRenderer(GaugeRange range) {
    return _GaugeRangeRenderer(range);
  }

  /// Method to add the elements of gauge
  Widget _addGaugeElements() {
    return Expanded(child: LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return _AxisContainer(widget, _gaugeTheme, _renderingDetails);
      },
    ));
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
        child: LimitedBox(
            maxHeight: 350,
            maxWidth: 350,
            child: Container(
                color: widget.backgroundColor,
                child: Column(children: <Widget>[
                  _addGaugeTitle(),
                  _addGaugeElements()
                ]))));
  }

  @override
  void dispose() {
    if (_renderingDetails.animationController != null) {
      _renderingDetails.animationController
          .removeListener(_repaintGaugeElements);
      _renderingDetails.animationController.dispose();
    }

    if (widget.axes != null &&
        widget.axes.isNotEmpty &&
        _renderingDetails.axisRenderers != null) {
      for (int i = 0; i < widget.axes.length; i++) {
        final RadialAxisRenderer axisRenderer =
            _renderingDetails.axisRenderers[i];
        if (axisRenderer._imageStream != null) {
          axisRenderer._imageStream.removeListener(axisRenderer._listener);
        }
      }
    }
    super.dispose();
  }

  /// Method to convert the [SfRadialGauge] as an image.
  ///
  /// Returns the [dart:ui.image]
  ///
  ///As this method is in the widget’s state class, you have to use a global
  ///key to access the state to call this method.
  ///
  /// ```dart
  /// final GlobalKey<SfRadialGaugeState> _radialGaugeKey = GlobalKey();
  /// @override
  /// Widget build(BuildContext context) {
  ///   return Scaffold(
  ///     body: Column(
  ///       children: [SfRadialGauge(key: _radialGaugeKey),
  ///               RaisedButton(
  ///                child: Text(
  ///                   'To Image',
  ///                 ),
  ///                 onPressed: _renderImage,
  ///                 shape: RoundedRectangleBorder(
  ///                     borderRadius: BorderRadius.circular(20)),
  ///               ),
  ///       ],
  ///     ),
  ///   );
  /// }

  ///  Future<void> _renderImage() async {
  ///   dart_ui.Image data = await
  ///                     _radialGaugeKey.currentState.toImage(pixelRatio: 3.0);
  ///   final bytes = await data.toByteData(format: dart_ui.ImageByteFormat.png);
  ///   if (data != null) {
  ///     await Navigator.of(context).push(
  ///       MaterialPageRoute(
  ///         builder: (BuildContext context) {
  ///           return Scaffold(
  ///             appBar: AppBar(),
  ///             body: Center(
  ///               child: Container(
  ///                 color: Colors.white,
  ///                 child: Image.memory(bytes.buffer.asUint8List()),
  ///               ),
  ///             ),
  ///           );
  ///         },
  ///       ),
  ///     );
  ///   }
  /// }
  /// ```

  Future<dart_ui.Image> toImage({double pixelRatio = 1.0}) async {
    final RenderRepaintBoundary boundary = context.findRenderObject();
    final dart_ui.Image image = await boundary.toImage(pixelRatio: pixelRatio);
    return image;
  }
}

/// Holds the animation and repainter details.
class _RenderingDetails {
  /// Holds the pointer repaint notifier
  ValueNotifier<int> pointerRepaintNotifier;

  /// Holds the range repaint notifier
  ValueNotifier<int> rangeRepaintNotifier;

  /// Holds the axis repaint notifier
  ValueNotifier<int> axisRepaintNotifier;

  /// Holds the animation controller
  AnimationController animationController;

  /// Specifies whether to animate axes
  bool needsToAnimateAxes;

  /// Specifies whether to animate ranges
  bool needsToAnimateRanges;

  /// Specifies whether to animate pointers
  bool needsToAnimatePointers;

  /// Specifies whether to animate annotation
  bool needsToAnimateAnnotation;

  /// Specifies axis renderer corresponding to the axis
  List<RadialAxisRenderer> axisRenderers;

  Map<int, List<_GaugePointerRenderer>> gaugePointerRenderers;

  Map<int, List<_GaugeRangeRenderer>> gaugeRangeRenderers;
}
