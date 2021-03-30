import 'dart:ui';
import 'dart:ui' as dart_ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import '../axis/radial_axis.dart';
import '../common/common.dart';
import '../common/radial_gauge_renderer.dart';

import '../pointers/gauge_pointer.dart';
import '../pointers/marker_pointer.dart';
import '../pointers/needle_pointer.dart';
import '../pointers/range_pointer.dart';
import '../pointers/widget_pointer.dart';
import '../range/gauge_range.dart';

import '../renderers/gauge_pointer_renderer.dart';
import '../renderers/gauge_range_renderer.dart';
import '../renderers/marker_pointer_renderer.dart';
import '../renderers/marker_pointer_renderer_base.dart';
import '../renderers/needle_pointer_renderer.dart';
import '../renderers/needle_pointer_renderer_base.dart';
import '../renderers/radial_axis_renderer.dart';
import '../renderers/radial_axis_renderer_base.dart';
import '../renderers/range_pointer_renderer.dart';
import '../renderers/widget_pointer_renderer_base.dart';
import '../utils/enum.dart';

/// Create a radial gauge widget to displays numerical values on a circular scale.
/// It has a rich set of features
/// such as axes, ranges, pointers, and annotations that are fully
/// customizable and extendable.
/// Use it to create speedometers, temperature monitors, dashboards,
/// meter gauges, multiaxis clocks, watches, activity gauges, compasses,
/// and more.
///
/// The radial gauge widget allows customizing its appearance
/// using [SfGaugeThemeData] available from the [SfGaugeTheme] widget or
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
      {Key? key,
      List<RadialAxis>? axes,
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
  final GaugeTitle? title;

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
  late SfGaugeThemeData _gaugeTheme;

  /// Hold the radial gauge rendering details
  late RenderingDetails _renderingDetails;

  @override
  void initState() {
    _renderingDetails = RenderingDetails();
    _renderingDetails.axisRenderers = <RadialAxisRendererBase>[];
    _renderingDetails.gaugePointerRenderers =
        <int, List<GaugePointerRenderer>>{};
    _renderingDetails.gaugeRangeRenderers = <int, List<GaugeRangeRenderer>>{};
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
    if (widget.axes.isNotEmpty) {
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
    _gaugeTheme = SfGaugeTheme.of(context) as SfGaugeThemeData;
    super.didChangeDependencies();
  }

  /// Method is used to create renderers for gauge features
  void _createRenderer() {
    if (widget.axes.isNotEmpty) {
      for (int i = 0; i < widget.axes.length; i++) {
        final RadialAxis axis = widget.axes[i];
        final RadialAxisRendererBase axisRenderer = _createAxisRenderer(axis);
        _renderingDetails.axisRenderers.add(axisRenderer);
        if (axis.ranges != null && axis.ranges!.isNotEmpty) {
          _createRangesRenderer(i, axisRenderer);
        }

        if (axis.pointers != null && axis.pointers!.isNotEmpty) {
          _createPointersRenderers(i, axisRenderer);
        }
      }
    }
  }

  /// Method is used to create gauge range renderer
  void _createRangesRenderer(
      int axisIndex, RadialAxisRendererBase axisRenderer) {
    final List<GaugeRangeRenderer> rangeRenderers = <GaugeRangeRenderer>[];
    final RadialAxis axis = widget.axes[axisIndex];
    for (int j = 0; j < axis.ranges!.length; j++) {
      final GaugeRange range = axis.ranges![j];
      final GaugeRangeRenderer renderer = _createRangeRenderer(range);
      renderer.axisRenderer = axisRenderer;
      rangeRenderers.add(renderer);
    }

    _renderingDetails.gaugeRangeRenderers[axisIndex] = rangeRenderers;
  }

  /// Method is used to create gauge pointer renderer
  void _createPointersRenderers(
      int axisIndex, RadialAxisRendererBase axisRenderer) {
    final List<GaugePointerRenderer> pointerRenderers =
        <GaugePointerRenderer>[];
    final RadialAxis axis = widget.axes[axisIndex];
    for (int j = 0; j < axis.pointers!.length; j++) {
      final GaugePointer pointer = axis.pointers![j];
      final GaugePointerRenderer renderer = _createPointerRenderer(pointer);
      renderer.axisRenderer = axisRenderer;
      renderer.needsAnimate = true;
      renderer.animationStartValue =
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
      RenderingDetails _renderingDetails) {
    final List<RadialAxisRendererBase> oldAxisRenderers =
        _renderingDetails.axisRenderers;
    final Map<int, List<GaugeRangeRenderer>> oldRangeRenderers =
        _renderingDetails.gaugeRangeRenderers;
    final Map<int, List<GaugePointerRenderer>> oldPointerRenderers =
        _renderingDetails.gaugePointerRenderers;
    _renderingDetails.axisRenderers = <RadialAxisRendererBase>[];
    _renderingDetails.gaugeRangeRenderers = <int, List<GaugeRangeRenderer>>{};
    _renderingDetails.gaugePointerRenderers =
        <int, List<GaugePointerRenderer>>{};
    for (int i = 0; i < newGauge.axes.length; i++) {
      final RadialAxis newAxis = newGauge.axes[i];
      int? index;
      RadialAxisRendererBase axisRenderer;
      index = i < oldGauge.axes.length && newAxis == oldGauge.axes[i]
          ? i
          : _getExistingAxisIndex(newAxis, oldGauge);

      if (index != null &&
          index < oldGauge.axes.length &&
          index < oldAxisRenderers.length) {
        axisRenderer = oldAxisRenderers[index];
        axisRenderer.axis = newAxis;
        if (axisRenderer.renderer != null) {
          axisRenderer.renderer!.axis = newAxis;
        }
        _needsRepaintAxis(oldGauge.axes[i], newGauge.axes[i], axisRenderer,
            index, oldRangeRenderers, oldPointerRenderers);
      } else if (oldGauge.axes.length == newGauge.axes.length &&
          oldAxisRenderers.length == newGauge.axes.length) {
        axisRenderer = oldAxisRenderers[i];
        axisRenderer.axis = newAxis;
        if (axisRenderer.renderer != null) {
          axisRenderer.renderer!.axis = newAxis;
        }
        final RadialAxis oldAxis = oldGauge.axes[i];
        _needsRepaintExistingAxis(oldAxis, newAxis, axisRenderer, i,
            _renderingDetails, oldPointerRenderers, oldRangeRenderers);
      } else {
        axisRenderer = _createAxisRenderer(newAxis);
        axisRenderer.needsRepaintAxis = true;

        if (newAxis.ranges != null && newAxis.ranges!.isNotEmpty) {
          _createRangesRenderer(i, axisRenderer);
        }

        if (newAxis.pointers != null && newAxis.pointers!.isNotEmpty) {
          _createPointersRenderers(i, axisRenderer);
        }
      }
      axisRenderer.axis = newAxis;
      _renderingDetails.axisRenderers.add(axisRenderer);
    }
  }

  /// Checks whether to repaint the existing axes
  void _needsRepaintExistingAxis(
      RadialAxis oldAxis,
      RadialAxis newAxis,
      RadialAxisRendererBase axisRenderer,
      int axisIndex,
      RenderingDetails _renderingDetails,
      Map<int, List<GaugePointerRenderer>> oldPointerRenderers,
      Map<int, List<GaugeRangeRenderer>> oldRangeRenderers) {
    if (newAxis != oldAxis) {
      axisRenderer.needsRepaintAxis = true;
    } else {
      axisRenderer.needsRepaintAxis = false;
    }
    if (oldAxis.pointers != null &&
        newAxis.pointers != null &&
        oldAxis.pointers!.isNotEmpty &&
        newAxis.pointers!.isNotEmpty &&
        oldAxis.pointers!.length == newAxis.pointers!.length) {
      final List<GaugePointerRenderer> pointerRenderers =
          oldPointerRenderers[axisIndex]!;
      final List<GaugePointerRenderer> newPointerRenderers =
          <GaugePointerRenderer>[];
      for (int j = 0; j < newAxis.pointers!.length; j++) {
        _needsAnimatePointers(
            oldAxis.pointers![j], newAxis.pointers![j], pointerRenderers[j]);
        _needsResetPointerValue(
            oldAxis.pointers![j], newAxis.pointers![j], pointerRenderers[j]);
        if (newAxis.pointers![j] != oldAxis.pointers![j]) {
          pointerRenderers[j].needsRepaintPointer = true;
        } else {
          if (axisRenderer.needsRepaintAxis) {
            pointerRenderers[j].needsRepaintPointer = true;
          } else {
            pointerRenderers[j].needsRepaintPointer = false;
          }
        }

        if (pointerRenderers[j] is MarkerPointerRendererBase) {
          final MarkerPointerRendererBase markerRenderer =
              pointerRenderers[j] as MarkerPointerRendererBase;
          final MarkerPointer marker = newAxis.pointers![j] as MarkerPointer;
          markerRenderer.pointer = marker;
          if (markerRenderer.renderer != null) {
            markerRenderer.renderer!.pointer = marker;
          }
        } else if (pointerRenderers[j] is NeedlePointerRendererBase) {
          final NeedlePointerRendererBase needleRenderer =
              pointerRenderers[j] as NeedlePointerRendererBase;
          final NeedlePointer needle = newAxis.pointers![j] as NeedlePointer;
          needleRenderer.pointer = needle;
          if (needleRenderer.renderer != null) {
            needleRenderer.renderer!.pointer = needle;
          }
        }

        pointerRenderers[j].gaugePointer = newAxis.pointers![j];
        newPointerRenderers.add(pointerRenderers[j]);
      }

      _renderingDetails.gaugePointerRenderers[axisIndex] = newPointerRenderers;
    } else {
      if (newAxis.pointers != null && newAxis.pointers!.isNotEmpty) {
        _needsRepaintPointers(
            oldAxis, newAxis, axisRenderer, axisIndex, oldPointerRenderers);
      }
    }
    if (oldAxis.ranges != null &&
        newAxis.ranges != null &&
        oldAxis.ranges!.isNotEmpty &&
        newAxis.ranges!.isNotEmpty &&
        oldAxis.ranges!.length == newAxis.ranges!.length &&
        oldRangeRenderers[axisIndex] != null) {
      final List<GaugeRangeRenderer> rangeRenderers =
          oldRangeRenderers[axisIndex]!;
      final List<GaugeRangeRenderer> newRangeRenderers = <GaugeRangeRenderer>[];
      for (int j = 0; j < newAxis.ranges!.length; j++) {
        if (newAxis.ranges![j] != oldAxis.ranges![j]) {
          rangeRenderers[j].needsRepaintRange = true;
        } else {
          if (axisRenderer.needsRepaintAxis) {
            rangeRenderers[j].needsRepaintRange = true;
          } else {
            rangeRenderers[j].needsRepaintRange = false;
          }
        }

        rangeRenderers[j].range = newAxis.ranges![j];
        newRangeRenderers.add(rangeRenderers[j]);
      }
      _renderingDetails.gaugeRangeRenderers[axisIndex] = newRangeRenderers;
    } else {
      if (newAxis.ranges != null && newAxis.ranges!.isNotEmpty) {
        _needsRepaintRanges(
            oldAxis, newAxis, axisRenderer, axisIndex, oldRangeRenderers);
      }
    }
  }

  /// Check current axis index is exist in old gauge
  int? _getExistingAxisIndex(RadialAxis currentAxis, SfRadialGauge oldGauge) {
    for (int index = 0; index < oldGauge.axes.length; index++) {
      final RadialAxis axis = oldGauge.axes[index];
      if (axis == currentAxis) {
        return index;
      }
    }
    return null;
  }

  /// Check current range index is exist in old axis
  int? _getExistingRangeIndex(GaugeRange currentRange, RadialAxis oldAxis) {
    for (int index = 0; index < oldAxis.ranges!.length; index++) {
      final GaugeRange range = oldAxis.ranges![index];
      if (range == currentRange) {
        return index;
      }
    }
    return null;
  }

  /// Check current range index is exist in old axis
  int? _getExistingPointerIndex(
      GaugePointer currentPointer, RadialAxis oldAxis) {
    for (int index = 0; index < oldAxis.pointers!.length; index++) {
      final GaugePointer pointer = oldAxis.pointers![index];
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
    RadialAxisRendererBase axisRenderer,
    int oldAxisIndex,
    Map<int, List<GaugeRangeRenderer>> oldRangeRenderers,
    Map<int, List<GaugePointerRenderer>> oldPointerRenderers,
  ) {
    if (oldAxis.backgroundImage == newAxis.backgroundImage &&
        axisRenderer.backgroundImageInfo?.image != null) {
      axisRenderer.backgroundImageInfo = axisRenderer.backgroundImageInfo;
    }
    axisRenderer.needsRepaintAxis = false;
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
      RadialAxisRendererBase axisRenderer,
      int oldAxisIndex,
      Map<int, List<GaugeRangeRenderer>> oldRangeRenderers) {
    final List<GaugeRangeRenderer> newRangeRenderers = <GaugeRangeRenderer>[];
    final List<GaugeRangeRenderer>? renderers = oldRangeRenderers[oldAxisIndex];
    for (int i = 0; i < newAxis.ranges!.length; i++) {
      final GaugeRange newRange = newAxis.ranges![i];
      int? index;
      GaugeRangeRenderer rangeRenderer;
      if (oldAxis.ranges != null) {
        index = i < oldAxis.ranges!.length && newRange == oldAxis.ranges![i]
            ? i
            : _getExistingRangeIndex(newRange, oldAxis);
      }

      if (index != null &&
          index < oldAxis.ranges!.length &&
          renderers != null &&
          index < renderers.length) {
        rangeRenderer = renderers[index];
        if (axisRenderer.needsRepaintAxis) {
          rangeRenderer.needsRepaintRange = true;
        } else {
          rangeRenderer.needsRepaintRange = false;
        }
      } else {
        rangeRenderer = _createRangeRenderer(newRange);
        rangeRenderer.needsRepaintRange = true;
      }

      rangeRenderer.range = newRange;
      rangeRenderer.axisRenderer = axisRenderer;
      newRangeRenderers.add(rangeRenderer);
    }

    _renderingDetails.gaugeRangeRenderers[oldAxisIndex] = newRangeRenderers;
  }

  /// Checks whether to animate the pointers
  void _needsAnimatePointers(GaugePointer oldPointer, GaugePointer newPointer,
      GaugePointerRenderer pointerRenderer) {
    if (oldPointer.value != newPointer.value) {
      setState(() {
        // Sets the previous animation end value as current animation start
        // value of pointer
        pointerRenderer.needsAnimate = true;
        pointerRenderer.animationStartValue = pointerRenderer.animationEndValue;
      });
    } else if (oldPointer.animationType != newPointer.animationType) {
      pointerRenderer.needsAnimate = true;
    } else {
      setState(() {
        pointerRenderer.needsAnimate = false;
      });
    }
  }

  /// Check to reset the pointer current value
  void _needsResetPointerValue(GaugePointer oldPointer, GaugePointer newPointer,
      GaugePointerRenderer pointerRenderer) {
    if (oldPointer.enableDragging == newPointer.enableDragging) {
      if (!(oldPointer.value == newPointer.value)) {
        pointerRenderer.currentValue = newPointer.value;
        pointerRenderer.isDragStarted = false;
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
      RadialAxisRendererBase axisRenderer,
      int oldAxisIndex,
      Map<int, List<GaugePointerRenderer>> oldPointerRenderers) {
    final List<GaugePointerRenderer> newPointerRenderers =
        <GaugePointerRenderer>[];
    final List<GaugePointerRenderer>? renderers =
        oldPointerRenderers[oldAxisIndex];
    for (int i = 0; i < newAxis.pointers!.length; i++) {
      final GaugePointer newPointer = newAxis.pointers![i];
      int? index;
      GaugePointerRenderer pointerRenderer;
      if (oldAxis.pointers != null) {
        index = i < oldAxis.pointers!.length &&
                (newPointer == oldAxis.pointers![i] ||
                    newPointer.value != oldAxis.pointers![i].value ||
                    newPointer.animationType !=
                        oldAxis.pointers![i].animationType)
            ? i
            : _getExistingPointerIndex(newPointer, oldAxis);
      }

      if (index != null &&
          index < oldAxis.pointers!.length &&
          renderers != null &&
          index < renderers.length) {
        pointerRenderer = renderers[index];
        if (axisRenderer.needsRepaintAxis) {
          pointerRenderer.needsRepaintPointer = true;
        } else {
          pointerRenderer.needsRepaintPointer = false;
        }
        if (oldAxis.pointers![index].value != newAxis.pointers![i].value) {
          // Sets the previous animation end value as current animation start
          // value of pointer
          pointerRenderer.needsAnimate = true;
          pointerRenderer.needsRepaintPointer = true;
          pointerRenderer.currentValue = newPointer.value;
          pointerRenderer.animationStartValue =
              pointerRenderer.animationEndValue;
        } else if (oldAxis.pointers![index].animationType !=
            newAxis.pointers![i].animationType) {
          pointerRenderer.needsAnimate = true;
          pointerRenderer.needsRepaintPointer = true;
        } else {
          pointerRenderer.needsAnimate = false;
        }

        if (oldAxis.pointers![index].enableDragging ==
            newAxis.pointers![i].enableDragging) {
          if (oldAxis.pointers![i].value == newAxis.pointers![i].value &&
              pointerRenderer.currentValue != renderers[index].currentValue) {
            pointerRenderer.currentValue = renderers[index].currentValue;
          }
          pointerRenderer.isDragStarted = renderers[index].isDragStarted;
        }
      } else {
        pointerRenderer = _createPointerRenderer(newPointer);
        pointerRenderer.needsRepaintPointer = true;
        pointerRenderer.needsAnimate = false;
        if (oldAxis.pointers != null &&
            i < oldAxis.pointers!.length &&
            oldAxis.pointers![i].enableDragging == newPointer.enableDragging &&
            oldPointerRenderers[i] != null &&
            oldAxis.pointers![i].value == newAxis.pointers![i].value) {
          if (renderers != null && i < renderers.length) {
            pointerRenderer.currentValue = renderers[i].currentValue;
            pointerRenderer.isDragStarted = renderers[i].isDragStarted;
          }
        }
      }

      if (pointerRenderer is MarkerPointerRendererBase) {
        final MarkerPointerRendererBase markerRenderer = pointerRenderer;
        final MarkerPointer marker = newPointer as MarkerPointer;
        markerRenderer.pointer = marker;
        if (markerRenderer.renderer != null) {
          markerRenderer.renderer!.pointer = marker;
        }
      } else if (pointerRenderer is NeedlePointerRendererBase) {
        final NeedlePointerRendererBase needleRenderer = pointerRenderer;
        final NeedlePointer needle = newPointer as NeedlePointer;
        needleRenderer.pointer = needle;
        if (needleRenderer.renderer != null) {
          needleRenderer.renderer!.pointer = needle;
        }
      }

      pointerRenderer.gaugePointer = newPointer;
      pointerRenderer.axisRenderer = axisRenderer;
      newPointerRenderers.add(pointerRenderer);
    }

    _renderingDetails.gaugePointerRenderers[oldAxisIndex] = newPointerRenderers;
  }

  /// Returns the gauge pointer renderer
  GaugePointerRenderer _createPointerRenderer(GaugePointer pointer) {
    if (pointer is MarkerPointer) {
      return _createMarkerPointerRenderer(pointer);
    } else if (pointer is NeedlePointer) {
      return _createNeedlePointerRenderer(pointer);
    } else if (pointer is RangePointer) {
      return _createRangePointerRenderer(pointer);
    } else {
      final WidgetPointerRenderer renderer = WidgetPointerRenderer();
      final WidgetPointer widgetPointer = pointer as WidgetPointer;
      renderer.gaugePointer = widgetPointer;
      renderer.currentValue = widgetPointer.value;
      return renderer;
    }
  }

  /// Create the needle pointer renderer.
  NeedlePointerRendererBase _createNeedlePointerRenderer(GaugePointer pointer) {
    final NeedlePointerRendererBase pointerRendererBase =
        NeedlePointerRendererBase();
    NeedlePointerRenderer? pointerRenderer;
    final NeedlePointer needle = pointer as NeedlePointer;
    if (needle.onCreatePointerRenderer != null) {
      pointerRenderer = needle.onCreatePointerRenderer!();
      pointerRenderer.pointer = needle;
      assert(
          pointerRenderer is NeedlePointerRenderer,
          'This onCreateRenderer callback function should return value as'
          'extends from GaugePointerRenderer class and should not be return'
          'value as null');
    }

    pointerRendererBase.renderer = pointerRenderer;
    pointerRendererBase.gaugePointer = needle;
    pointerRendererBase.currentValue = needle.value;
    return pointerRendererBase;
  }

  /// Create the marker pointer renderer.
  MarkerPointerRendererBase _createMarkerPointerRenderer(GaugePointer pointer) {
    final MarkerPointer marker = pointer as MarkerPointer;
    final MarkerPointerRendererBase pointerRendererBase =
        MarkerPointerRendererBase();
    MarkerPointerRenderer? pointerRenderer;
    if (marker.onCreatePointerRenderer != null) {
      pointerRenderer = marker.onCreatePointerRenderer!();
      pointerRenderer.pointer = marker;
      assert(
          pointerRenderer is MarkerPointerRenderer,
          'This onCreatePointerRenderer callback function should return'
          'value as extends from GaugePointerRenderer class and should not'
          'be return value as null');
    }

    pointerRendererBase.renderer = pointerRenderer;
    pointerRendererBase.gaugePointer = marker;
    pointerRendererBase.currentValue = marker.value;
    return pointerRendererBase;
  }

  /// Create the range pointer renderer.
  RangePointerRenderer _createRangePointerRenderer(GaugePointer pointer) {
    final RangePointerRenderer pointerRenderer = RangePointerRenderer();
    pointerRenderer.gaugePointer = pointer;
    pointerRenderer.currentValue = pointer.value;
    return pointerRenderer;
  }

  /// Create the radial axis renderer.
  RadialAxisRendererBase _createAxisRenderer(RadialAxis axis) {
    final RadialAxisRendererBase axisRendererBase = RadialAxisRendererBase();
    RadialAxisRenderer? axisRenderer;
    if (axis.onCreateAxisRenderer != null) {
      axisRenderer = axis.onCreateAxisRenderer!();
      axisRenderer!.axis = axis;
      assert(
          axisRenderer is RadialAxisRenderer,
          'This onCreateAxisRenderer callback function should return value as'
          'extends from RadialAxisRenderer class and should not be return value'
          'as null');
    }

    axisRendererBase.axis = axis;
    axisRendererBase.renderer = axisRenderer;
    return axisRendererBase;
  }

  /// Methods to add the title of circular gauge
  Widget _addGaugeTitle() {
    if (widget.title != null && widget.title!.text.isNotEmpty) {
      final Widget titleWidget = Container(
          child: Container(
              padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
              decoration: BoxDecoration(
                  color: widget.title!.backgroundColor ??
                      _gaugeTheme.titleBackgroundColor,
                  border: Border.all(
                      color: widget.title!.borderColor ??
                          _gaugeTheme.titleBorderColor,
                      width: widget.title!.borderWidth)),
              child: Text(
                widget.title!.text,
                style: widget.title!.textStyle,
                textAlign: TextAlign.center,
                overflow: TextOverflow.clip,
              ),
              alignment: (widget.title!.alignment == GaugeAlignment.near)
                  ? Alignment.topLeft
                  : (widget.title!.alignment == GaugeAlignment.far)
                      ? Alignment.topRight
                      : (widget.title!.alignment == GaugeAlignment.center)
                          ? Alignment.topCenter
                          : Alignment.topCenter));

      return titleWidget;
    } else {
      return Container();
    }
  }

  /// Returns the renderer for gauge range
  GaugeRangeRenderer _createRangeRenderer(GaugeRange range) {
    return GaugeRangeRenderer(range);
  }

  /// Method to add the elements of gauge
  Widget _addGaugeElements() {
    return Expanded(child: LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return AxisContainer(widget, _gaugeTheme, _renderingDetails);
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
      _renderingDetails.animationController!
          .removeListener(_repaintGaugeElements);
      _renderingDetails.animationController!.dispose();
    }

    if (widget.axes.isNotEmpty && _renderingDetails.axisRenderers.isNotEmpty) {
      for (int i = 0; i < widget.axes.length; i++) {
        final RadialAxisRendererBase axisRenderer =
            _renderingDetails.axisRenderers[i];
        if (axisRenderer.imageStream != null && axisRenderer.listener != null) {
          axisRenderer.imageStream!.removeListener(axisRenderer.listener!);
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
    final RenderRepaintBoundary boundary =
        context.findRenderObject() as RenderRepaintBoundary;
    final dart_ui.Image image = await boundary.toImage(pixelRatio: pixelRatio);
    return image;
  }
}
