import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../linear_gauge/axis/linear_axis_renderer.dart';
import '../../linear_gauge/axis/linear_axis_track_style.dart';
import '../../linear_gauge/axis/linear_tick_style.dart';
import '../../linear_gauge/gauge/linear_gauge_render_widget.dart';
import '../../linear_gauge/gauge/linear_gauge_scope.dart';
import '../../linear_gauge/pointers/linear_bar_pointer.dart';
import '../../linear_gauge/pointers/linear_marker_pointer.dart';
import '../../linear_gauge/range/linear_gauge_range.dart';
import '../../linear_gauge/utils/enum.dart';
import '../../linear_gauge/utils/linear_gauge_helper.dart';
import '../../linear_gauge/utils/linear_gauge_typedef.dart';

/// Creates a linear gauge widget to displays the values on a linear scale.
/// It has a rich set of features
/// such as axis, ranges, and pointers that are fully
/// customizable and extendable.
///
/// ```dart
/// Widget build(BuildContext context) {
///    return Container(
///        child: SfLinearGauge());
///}
/// ```
class SfLinearGauge extends StatefulWidget {
  /// Creates a linear gauge
  SfLinearGauge(
      {Key? key,
      this.minimum = 0.0,
      this.maximum = 100.0,
      this.interval,
      this.ranges,
      this.barPointers,
      this.markerPointers,
      this.orientation = LinearGaugeOrientation.horizontal,
      this.isAxisInversed = false,
      this.isMirrored = false,
      this.animateAxis = false,
      this.animateRange = false,
      this.animationDuration = 1000,
      this.showLabels = true,
      this.showAxisTrack = true,
      this.showTicks = true,
      this.minorTicksPerInterval = 1,
      this.useRangeColorForAxis = false,
      this.axisTrackExtent = 0,
      this.labelPosition = LinearLabelPosition.inside,
      this.tickPosition = LinearElementPosition.inside,
      double tickOffset = 0,
      double labelOffset = 4,
      this.maximumLabels = 3,
      NumberFormat? numberFormat,
      this.onGenerateLabels,
      this.valueToFactorCallback,
      this.factorToValueCallback,
      this.labelFormatterCallback,
      this.axisLabelStyle,
      LinearAxisTrackStyle? axisTrackStyle,
      LinearTickStyle? majorTickStyle,
      LinearTickStyle? minorTickStyle})
      : assert(minimum <= maximum, 'Maximum should be greater than minimum.'),
        axisTrackStyle = axisTrackStyle ?? const LinearAxisTrackStyle(),
        tickOffset = tickOffset > 0 ? tickOffset : 0,
        labelOffset = labelOffset > 0 ? labelOffset : 4,
        majorTickStyle = majorTickStyle ?? const LinearTickStyle(length: 8.0),
        minorTickStyle = minorTickStyle ?? const LinearTickStyle(),
        numberFormat = numberFormat ?? NumberFormat('#.##'),
        super(key: key);

  ///Customizes each range by adding it to the [ranges] collection.
  ///
  /// Also refer [LinearGaugeRange]
  ///
  final List<LinearGaugeRange>? ranges;

  ///Customizes each bar pointer by adding it to the [barPointers] collection.
  ///
  /// Also refer [LinearMarkerPointer]
  ///
  final List<LinearBarPointer>? barPointers;

  /// Add a list of gauge shape and widget pointer to the linear gauge and customize
  /// each pointer by adding it to the [markerPointers] collection.
  ///
  /// Also refer [LinearMarkerPointer]
  ///
  final List<LinearMarkerPointer>? markerPointers;

  /// Specifies the animation for axis.
  ///
  /// Defaults to false.
  ///
  /// This snippet shows how to set load time animation for [SfLinearGauge].
  ///
  /// ```dart
  ///
  /// SfLinearGauge(
  /// animateAxis: true
  /// )
  /// ```
  ///
  final bool animateAxis;

  /// Specifies the animation for range.
  ///
  /// Defaults to false.
  ///
  /// This snippet shows how to set load time animation.
  ///
  /// ```dart
  ///
  /// SfLinearGauge(
  /// animateRange: true
  /// )
  /// ```
  ///
  final bool animateRange;

  /// Specifies the load time animation duration.
  /// Duration is defined in milliseconds.
  ///
  /// Defaults to 1000.
  ///
  /// This snippet shows how to set loading animation duration for[SfLinearGauge].
  ///
  /// ```dart
  ///
  /// SfLinearGauge(
  /// animationDuration: 7000
  /// )
  /// ```
  ///
  final int animationDuration;

  /// Specifies the orientation of [SfLinearGauge].
  ///
  /// Defaults to [LinearGaugeOrientation.horizontal].
  ///
  /// This snippet shows how to set orientation for [SfLinearGauge].
  ///
  /// ```dart
  ///
  /// SfLinearGauge(
  /// orientation: LinearGaugeOrientation.vertical
  /// )
  /// ```
  ///
  final LinearGaugeOrientation orientation;

  /// Specifies the minimum value of an axis. The axis starts with this value.
  ///
  /// Defaults to 0.
  ///
  /// This snippet shows how to set minimum value of an axis.
  ///
  /// ```dart
  ///
  /// SfLinearGauge(
  /// minimum: 10
  /// )
  /// ```
  ///
  final double minimum;

  /// Specifies the maximum value of an axis. The axis ends at this value.
  ///
  /// Defaults to 100.
  ///
  /// This snippet shows how to set maximum value of an axis.
  ///
  /// ```dart
  ///
  /// SfLinearGauge(
  /// maximum: 150
  /// )
  /// ```
  ///
  final double maximum;

  /// Specifies the interval between major ticks in an axis.
  ///
  /// This snippet shows how to set the interval between major ticks.
  ///
  /// ```dart
  ///
  /// SfLinearGauge(
  /// interval: 20
  /// )
  /// ```
  ///
  final double? interval;

  /// Extends the axis on  both ends with the specified value.
  ///
  /// Defaults to 0.
  ///
  /// This snippet shows how to extend the axis track.
  ///
  /// ```dart
  ///
  /// SfLinearGauge(
  /// axisTrackExtent : 5
  /// )
  /// ```
  ///
  final double axisTrackExtent;

  /// Specifies the label style of axis.
  ///
  /// This snippet shows how to set label styles for axis.
  ///
  /// ```dart
  ///
  /// SfLinearGauge(
  /// axisLabelStyle: TextStyle(
  /// fontStyle: FontStyle.italic,
  /// fontWeight: FontWeight.bold,
  /// fontSize: 12.0,
  /// color: Colors.blueGrey),
  /// )
  /// ```
  ///
  final TextStyle? axisLabelStyle;

  /// Customizes the style of the axis line.
  ///
  /// Defaults to the [LinearAxisTrackStyle] property with thickness is 5.0
  /// logical pixels.
  final LinearAxisTrackStyle axisTrackStyle;

  /// Specifies the minor ticks count per interval in an axis.
  ///
  /// Defaults to 1.
  ///
  /// This snippet shows how to set the minor ticks per interval.
  ///
  /// ```dart
  ///
  /// SfLinearGauge(
  /// minorTicksPerInterval: 5
  /// )
  /// ```
  ///
  final int minorTicksPerInterval;

  /// The style to use for the major axis tick lines.
  ///
  /// Defaults to the [LinearTickStyle] property with length is 8.0 logical
  /// pixels.
  ///
  /// Also refer [LinearTickStyle]
  final LinearTickStyle majorTickStyle;

  /// The style to use for the minor axis tick lines.
  ///
  /// Defaults to the [LinearTickStyle] property with length is 4.0 logical
  /// pixels.
  ///
  /// Also refer [LinearTickStyle]
  final LinearTickStyle minorTickStyle;

  /// Determines whether to show the labels in an axis.
  ///
  /// Defaults to true.
  ///
  /// This snippet shows how to hide labels of axis in [SfLinearGauge].
  ///
  /// ```dart
  ///
  /// SfLinearGauge(
  /// showLabels: false
  /// )
  /// ```
  ///
  final bool showLabels;

  /// Determines whether to show an axis track in [SfLinearGauge].
  ///
  /// Defaults to true.
  ///
  /// This snippet shows how to hide an axis in [SfLinearGauge].
  ///
  /// ```dart
  ///
  /// SfLinearGauge(
  /// showAxisTrack: false
  /// )
  /// ```
  ///
  final bool showAxisTrack;

  /// Determines whether to show ticks.
  ///
  /// Defaults to true.
  ///
  /// This snippet shows how to hide ticks in [SfLinearGauge].
  ///
  /// ```dart
  ///
  /// SfLinearGauge(
  /// showTicks: false
  /// )
  /// ```
  ///
  final bool showTicks;

  /// Determines whether to use range color for an axis in [SfLinearGauge].
  ///
  /// Defaults to false.
  ///
  /// This snippet shows how to apply range color for an axis in [SfLinearGauge].
  ///
  /// ```dart
  ///
  /// SfLinearGauge(
  /// useRangeColorForAxis: true
  /// )
  /// ```
  ///
  final bool useRangeColorForAxis;

  /// Specifies the position of labels with respect to an axis.
  ///
  /// Defaults to [LinearLabelPosition.inside].
  ///
  /// This snippet shows how to set position of labels in [SfLinearGauge].
  ///
  /// ```dart
  ///
  /// SfLinearGauge(
  /// labelPosition: LinearLabelPosition.outside
  /// )
  /// ```
  ///
  final LinearLabelPosition labelPosition;

  /// Specifies the position of ticks with respect to axis.
  ///
  /// Defaults to [LinearElementPosition.inside].
  ///
  /// This snippet shows how to set position of ticks in [SfLinearGauge].
  ///
  /// ```dart
  ///
  /// SfLinearGauge(
  /// tickPosition: LinearElementPosition.outside
  /// )
  /// ```
  ///
  final LinearElementPosition tickPosition;

  /// Specifies the offset value of labels to custom-position them.
  ///
  /// Defaults to 4.
  ///
  /// This snippet shows how to set offset for labels.
  ///
  /// ```dart
  ///
  /// SfLinearGauge(
  /// labelOffset : 5
  /// )
  /// ```
  ///
  final double labelOffset;

  /// Specifies the offset value of ticks to custom-position them.
  ///
  /// Defaults to 0.
  ///
  /// This snippet shows how to set offset for ticks.
  ///
  /// ```dart
  ///
  /// SfLinearGauge(
  /// tickOffset: 5
  /// )
  /// ```
  ///
  final double tickOffset;

  /// Determines whether to inverse an axis in a [SfLinearGauge].
  ///
  /// Defaults to false.
  ///
  /// This snippet shows how to set inversed axis in [SfLinearGauge].
  ///
  /// ```dart
  ///
  /// SfLinearGauge(
  /// isAxisInversed: true
  /// )
  /// ```
  ///
  final bool isAxisInversed;

  /// The maximum number of labels to be displayed in 100 logical pixels.
  ///
  /// Defaults to 3.
  ///
  /// This snippet shows how to set [maximumLabels].
  ///
  /// ```dart
  ///
  /// SfLinearGauge(
  /// maximumLabels: 6
  /// )
  /// ```
  ///
  final int maximumLabels;

  /// Determines whether to mirror the linear gauge.
  ///
  /// Defaults to false.
  ///
  /// This snippet shows how to mirror the linear gauge.
  /// in [SfLinearGauge].
  ///
  /// ```dart
  ///
  /// SfLinearGauge(
  /// isMirrored: true
  /// )
  /// ```
  ///
  final bool isMirrored;

  /// Specifies the number format.
  ///
  /// Defaults to NumberFormat('#.##').
  ///
  /// This snippet shows how to set number formatting for axis labels.
  ///
  /// ```dart
  ///
  /// SfLinearGauge(
  /// numberFormat: NumberFormat("0", "en_US"),
  /// )
  /// ```
  ///
  final NumberFormat numberFormat;

  /// Returns the visible labels on [SfLinearGauge]
  ///
  /// Modify the actual labels. Generate your own labels based on needs,
  /// in order to be shown in the gauge.
  ///
  /// This snippet shows how to set generate labels for axis in [SfLinearGauge].
  ///
  /// ```dart
  ///
  /// SfLinearGauge(
  /// onGenerateLabels: () {
  /// return <LinearAxisLabel>[
  /// LinearAxisLabel(text: 'R', value: 0),
  /// LinearAxisLabel(text: 'M', value: 10),
  /// LinearAxisLabel(text: 'L', value: 20),
  /// LinearAxisLabel(text: 'XL', value: 30),];
  /// })
  /// ```
  ///
  final GenerateLabelsCallback? onGenerateLabels;

  /// Returns the converted factor value from the axis value
  ///
  /// The arguments to this method is an axis value.
  /// The calculated value of the factor should be between 0 and 1.
  /// If the axis ranges from 0 to 100 and pass the axis value is 50,
  /// this method return factor value as 0.5.
  /// Overriding method, you can modify the factor value based on needs.
  final ValueToFactorCallback? valueToFactorCallback;

  /// Returns the converted axis value from the factor.
  ///
  /// The arguments to this method is factor which value between 0 to 1.
  /// If the axis ranges from 0 to 100 and pass the factor value is 0.5,
  /// this method  will return the value as 50.
  /// Overriding method, you can modify the axis value based on needs.
  final FactorToValueCallback? factorToValueCallback;

  /// Called when the labels are been generated.
  ///
  /// This snippet shows how to set generate labels for an axis.
  ///
  /// ```dart
  /// SfLinearGauge(onFormatLabel: (value) {
  /// if(value == "100") {
  /// return '°F';
  /// }
  /// else {
  /// return value + '°';
  /// }})
  ///
  final LabelFormatterCallback? labelFormatterCallback;

  @override
  State<StatefulWidget> createState() => _SfLinearGaugeState();
}

class _SfLinearGaugeState extends State<SfLinearGauge>
    with TickerProviderStateMixin {
  AnimationController? _animationController;
  Animation<double>? _fadeAnimation;

  List<LinearBarPointer>? _oldBarPointerList;
  List<LinearMarkerPointer>? _oldMarkerPointerList;

  late bool _isPointerAnimationStarted = false;
  late List<Animation<double>> _pointerAnimations;
  late List<AnimationController> _pointerAnimationControllers;
  late List<Widget> _linearGaugeWidgets;

  final double _pointerAnimationStartValue = 0.5;

  @override
  void initState() {
    _pointerAnimationControllers = <AnimationController>[];
    _linearGaugeWidgets = <Widget>[];
    _updateOldList();
    _initializeAnimations();
    super.initState();
  }

  @override
  void didUpdateWidget(covariant SfLinearGauge oldWidget) {
    if (oldWidget.animateAxis != widget.animateAxis ||
        oldWidget.animateRange != widget.animateRange ||
        !_isEqualLists(widget.markerPointers, _oldMarkerPointerList) ||
        !_isEqualLists(widget.barPointers, _oldBarPointerList)) {
      _updateOldList();
      _initializeAnimations();
    }

    super.didUpdateWidget(oldWidget);
  }

  void _updateOldList() {
    _oldBarPointerList = (widget.barPointers != null)
        ? List<LinearBarPointer>.from(widget.barPointers!)
        : null;
    _oldMarkerPointerList = (widget.markerPointers != null)
        ? List<LinearMarkerPointer>.from(widget.markerPointers!)
        : null;
  }

  bool _isEqualLists(List<dynamic>? a, List<dynamic>? b) {
    if (a == null) {
      return b == null;
    }

    if (b == null || a.length != b.length) {
      return false;
    }

    for (int index = 0; index < a.length; index++) {
      if (a[index].enableAnimation != b[index].enableAnimation ||
          a[index].animationDuration != b[index].animationDuration ||
          a[index].animationType != b[index].animationType) {
        return false;
      }
    }

    return true;
  }

  /// Initialize the animations.
  void _initializeAnimations() {
    _disposeAnimationControllers();
    _isPointerAnimationStarted = false;

    if (widget.animateAxis || widget.animateRange) {
      _animationController = AnimationController(
          vsync: this,
          duration: Duration(milliseconds: widget.animationDuration));
      _animationController!.addListener(_axisAnimationListener);

      _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(
          parent: _animationController!,
          curve: const Interval(0.05, 1.0, curve: Curves.ease)));
    } else {
      if (_animationController != null) {
        _animationController!.removeListener(_axisAnimationListener);
        _animationController = null;
      }

      _fadeAnimation = null;
    }

    _createPointerAnimations();
    _animateElements();
  }

  void _addPointerAnimation(int duration, LinearAnimationType animationType) {
    final AnimationController pointerController = AnimationController(
        vsync: this, duration: Duration(milliseconds: duration));

    final Animation<double> animation = Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(
            parent: pointerController,
            curve: Interval(0, 1, curve: getCurveAnimation(animationType))));

    _pointerAnimations.add(animation);
    _pointerAnimationControllers.add(pointerController);
  }

  //Create animation for pointers.
  void _createPointerAnimations() {
    _pointerAnimations = <Animation<double>>[];
    _pointerAnimationControllers.clear();

    if (widget.barPointers != null && widget.barPointers!.isNotEmpty) {
      ///Adding linear gauge range widgets.
      for (final LinearBarPointer barPointer in widget.barPointers!) {
        if (barPointer.position == LinearElementPosition.outside ||
            barPointer.position == LinearElementPosition.inside) {
          if (barPointer.enableAnimation && barPointer.animationDuration > 0) {
            _addPointerAnimation(
                barPointer.animationDuration, barPointer.animationType);
          }
        }
      }
    }

    if (widget.barPointers != null && widget.barPointers!.isNotEmpty) {
      ///Adding linear gauge range widgets.
      for (final LinearBarPointer barPointer in widget.barPointers!) {
        if (barPointer.position == LinearElementPosition.cross &&
            barPointer.enableAnimation &&
            barPointer.animationDuration > 0) {
          _addPointerAnimation(
              barPointer.animationDuration, barPointer.animationType);
        }
      }
    }

    ///Adding linear gauge range widgets.
    if (widget.markerPointers != null && widget.markerPointers!.isNotEmpty) {
      for (final LinearMarkerPointer shapePointer in widget.markerPointers!) {
        if (shapePointer.enableAnimation &&
            shapePointer.animationDuration > 0) {
          _addPointerAnimation(
              shapePointer.animationDuration, shapePointer.animationType);
        }
      }
    }
  }

  void _axisAnimationListener() {
    if (_pointerAnimationStartValue <= _animationController!.value &&
        !_isPointerAnimationStarted) {
      _isPointerAnimationStarted = true;
      _animatePointers();
    }
  }

  /// Animates the gauge elements.
  void _animateElements() {
    if (widget.animateAxis || widget.animateRange) {
      _animationController!.forward(from: 0);
    } else {
      _animatePointers();
    }
  }

  void _animatePointers() {
    if (_pointerAnimationControllers.isNotEmpty) {
      for (int i = 0; i < _pointerAnimationControllers.length; i++) {
        _pointerAnimationControllers[i].forward(from: 0);
      }
    }
  }

  void _addChild(Widget child, Animation<double>? animation,
      AnimationController? controller) {
    _linearGaugeWidgets.add(LinearGaugeScope(
        animation: animation,
        orientation: widget.orientation,
        isAxisInversed: widget.isAxisInversed,
        isMirrored: widget.isMirrored,
        animationController: controller,
        child: child));
  }

  List<Widget> _buildChildWidgets(BuildContext context) {
    _linearGaugeWidgets.clear();
    int index = 0;

    if (widget.ranges != null && widget.ranges!.isNotEmpty) {
      ///Adding linear gauge range widgets.
      for (final LinearGaugeRange range in widget.ranges!) {
        if (range.position == LinearElementPosition.outside ||
            range.position == LinearElementPosition.inside) {
          _addChild(range, widget.animateRange ? _fadeAnimation : null, null);
        }
      }
    }

    if (widget.barPointers != null && widget.barPointers!.isNotEmpty) {
      ///Adding linear gauge range widgets.
      for (final LinearBarPointer barPointer in widget.barPointers!) {
        if (barPointer.position == LinearElementPosition.outside ||
            barPointer.position == LinearElementPosition.inside) {
          if (barPointer.enableAnimation && barPointer.animationDuration > 0) {
            _addChild(barPointer, _pointerAnimations[index],
                _pointerAnimationControllers[index]);
            index++;
          } else {
            _addChild(barPointer, null, null);
          }
        }
      }
    }

    /// Adding linear gauge axis widget.
    _linearGaugeWidgets.add(LinearAxisRenderObjectWidget(
        linearGauge: widget,
        fadeAnimation: widget.animateAxis ? _fadeAnimation : null));

    if (widget.ranges != null && widget.ranges!.isNotEmpty) {
      /// Adding linear gauge range widgets.
      for (final LinearGaugeRange range in widget.ranges!) {
        if (range.position == LinearElementPosition.cross) {
          _addChild(range, widget.animateRange ? _fadeAnimation : null, null);
        }
      }
    }

    if (widget.barPointers != null && widget.barPointers!.isNotEmpty) {
      /// Adding linear gauge range widgets.
      for (final LinearBarPointer barPointer in widget.barPointers!) {
        if (barPointer.position == LinearElementPosition.cross) {
          if (barPointer.enableAnimation && barPointer.animationDuration > 0) {
            _addChild(barPointer, _pointerAnimations[index],
                _pointerAnimationControllers[index]);
            index++;
          } else {
            _addChild(barPointer, null, null);
          }
        }
      }
    }

    if (widget.markerPointers != null && widget.markerPointers!.isNotEmpty) {
      /// Adding linear gauge widget bar pointer element.
      for (final LinearMarkerPointer pointer in widget.markerPointers!) {
        if (pointer.enableAnimation && pointer.animationDuration > 0) {
          _addChild(pointer as Widget, _pointerAnimations[index],
              _pointerAnimationControllers[index]);
          index++;
        } else {
          _addChild(pointer as Widget, null, null);
        }
      }
    }

    return _linearGaugeWidgets;
  }

  @override
  Widget build(BuildContext context) {
    return LinearGaugeRenderWidget(
        pointerAnimations: _pointerAnimations,
        children: _buildChildWidgets(context));
  }

  void _disposeAnimationControllers() {
    if (_animationController != null) {
      _animationController!.removeListener(_axisAnimationListener);
      _animationController!.dispose();
    }

    if (_pointerAnimationControllers.isNotEmpty) {
      for (final AnimationController controller
          in _pointerAnimationControllers) {
        controller.dispose();
      }
    }
  }

  @override
  void dispose() {
    _disposeAnimationControllers();
    super.dispose();
  }
}
